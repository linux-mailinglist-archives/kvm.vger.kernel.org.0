Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979CD197909
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgC3KVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:00 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43866 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729596AbgC3KUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id AB4773074895;
        Mon, 30 Mar 2020 13:12:52 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8BA61305B7A3;
        Mon, 30 Mar 2020 13:12:52 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 25/81] KVM: x86: add .spt_fault()
Date:   Mon, 30 Mar 2020 13:12:12 +0300
Message-Id: <20200330101308.21702-26-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This function is needed for the KVMI_EVENT_PF event.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c425bf1d257a..18e879d508c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1290,6 +1290,7 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
+	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 767ffd3ce4b1..42fab46e6553 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7529,6 +7529,14 @@ static u64 svm_fault_gla(struct kvm_vcpu *vcpu)
 	return svm->vcpu.arch.cr2 ? svm->vcpu.arch.cr2 : ~0ull;
 }
 
+static bool svm_spt_fault(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	return (vmcb->control.exit_code == SVM_EXIT_NPF);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7679,6 +7687,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.fault_gla = svm_fault_gla,
+	.spt_fault = svm_spt_fault,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1c6485aebf1..cc30513eca95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7914,6 +7914,13 @@ static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
 	return ~0ull;
 }
 
+static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -8076,6 +8083,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 
 	.fault_gla = vmx_fault_gla,
+	.spt_fault = vmx_spt_fault,
 };
 
 static void vmx_cleanup_l1d_flush(void)
