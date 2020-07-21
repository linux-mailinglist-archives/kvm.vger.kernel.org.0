Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B81C228AE8
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgGUVSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:06 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731244AbgGUVQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CCF60305D76E;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id ACAA0304FA14;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 25/84] KVM: x86: add .gpt_translation_fault()
Date:   Wed, 22 Jul 2020 00:08:23 +0300
Message-Id: <20200721210922.7646-26-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This function is needed for the KVMI_EVENT_PF event, to avoid sending
such events to the introspection tool if caused by a guest page table walk.

The code path is: emulator -> {read,write,fetch} callbacks -> page tracking
-> page tracking callbacks -> KVMI_EVENT_PF.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 12 ++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  8 ++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb41199b33fc..a905e14e4c75 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1293,6 +1293,7 @@ struct kvm_x86_ops {
 
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
+	bool (*gpt_translation_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ecfa10dce5d..580997701b1c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4097,6 +4097,17 @@ static bool svm_spt_fault(struct kvm_vcpu *vcpu)
 	return (vmcb->control.exit_code == SVM_EXIT_NPF);
 }
 
+static bool svm_gpt_translation_fault(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	if (vmcb->control.exit_info_1 & PFERR_GUEST_PAGE_MASK)
+		return true;
+
+	return false;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4226,6 +4237,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.fault_gla = svm_fault_gla,
 	.spt_fault = svm_spt_fault,
+	.gpt_translation_fault = svm_gpt_translation_fault,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 17b88345dfb5..a043e3e7d09a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7916,6 +7916,13 @@ static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
 	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
 }
 
+static bool vmx_gpt_translation_fault(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GVA_TRANSLATED)
+		return false;
+	return true;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8055,6 +8062,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.fault_gla = vmx_fault_gla,
 	.spt_fault = vmx_spt_fault,
+	.gpt_translation_fault = vmx_gpt_translation_fault,
 };
 
 static __init int hardware_setup(void)
