Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FA228ACA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgGUVRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:02 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37982 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731339AbgGUVQM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:12 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id AA1FD305D76D;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 88F53304FA12;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 24/84] KVM: x86: add .spt_fault()
Date:   Wed, 22 Jul 2020 00:08:22 +0300
Message-Id: <20200721210922.7646-25-alazar@bitdefender.com>
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
such events to the introspection tool if not caused by a SPT page fault.

The code path is: emulator -> {read,write,fetch} callbacks -> page tracking
-> page tracking callbacks -> KVMI_EVENT_PF.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccf2804f46b9..fb41199b33fc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1292,6 +1292,7 @@ struct kvm_x86_ops {
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 
 	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
+	bool (*spt_fault)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 86b670ff33dd..7ecfa10dce5d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4089,6 +4089,14 @@ static u64 svm_fault_gla(struct kvm_vcpu *vcpu)
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
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4217,6 +4225,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.fault_gla = svm_fault_gla,
+	.spt_fault = svm_spt_fault,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a04c46cde5b3..17b88345dfb5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7909,6 +7909,13 @@ static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
 	return ~0ull;
 }
 
+static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8047,6 +8054,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.migrate_timers = vmx_migrate_timers,
 
 	.fault_gla = vmx_fault_gla,
+	.spt_fault = vmx_spt_fault,
 };
 
 static __init int hardware_setup(void)
