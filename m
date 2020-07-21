Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C2228AEC
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgGUVSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:12 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731249AbgGUVQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 875D5305D76C;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 63DF9304FA13;
        Wed, 22 Jul 2020 00:09:22 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 23/84] KVM: x86: add .fault_gla()
Date:   Wed, 22 Jul 2020 00:08:21 +0300
Message-Id: <20200721210922.7646-24-alazar@bitdefender.com>
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

This function is needed for kvmi_update_ad_flags()
and kvm_page_track_emulation_failure().

kvmi_update_ad_flags() uses the the existing guest page table walk code
to update the A/D bits and return to guest (on SPT page faults caused
by guest page table walks when the introspection tool write-protects
the guest page tables).

kvm_page_track_emulation_failure() calls the page tracking code, which
will be changed with a following patch to receive the GVA in addition to
the GPA. Both might be needed by the introspection tool.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/include/asm/vmx.h      | 2 ++
 arch/x86/kvm/svm/svm.c          | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 9 +++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2530af4420cf..ccf2804f46b9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1290,6 +1290,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cd7de4b401fe..04487eb38b5c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -543,6 +543,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GLA_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -550,6 +551,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GLA_VALID		(1 << EPT_VIOLATION_GLA_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1ec88ff241ab..86b670ff33dd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4082,6 +4082,13 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static u64 svm_fault_gla(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->vcpu.arch.cr2 ? svm->vcpu.arch.cr2 : ~0ull;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_teardown,
 	.hardware_enable = svm_hardware_enable,
@@ -4208,6 +4215,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.fault_gla = svm_fault_gla,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6554c2278176..a04c46cde5b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7902,6 +7902,13 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GLA_VALID)
+		return vmcs_readl(GUEST_LINEAR_ADDRESS);
+	return ~0ull;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8038,6 +8045,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+
+	.fault_gla = vmx_fault_gla,
 };
 
 static __init int hardware_setup(void)
