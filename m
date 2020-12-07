Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409132D1B04
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLGUry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:47:54 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42566 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbgLGUrx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:47:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 33DDF305D50C;
        Mon,  7 Dec 2020 22:46:15 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 103A63072784;
        Mon,  7 Dec 2020 22:46:15 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 20/81] KVM: x86: add kvm_x86_ops.fault_gla()
Date:   Mon,  7 Dec 2020 22:45:21 +0200
Message-Id: <20201207204622.15258-21-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This function is needed for kvmi_update_ad_flags()
and kvm_page_track_emulation_failure().

kvmi_update_ad_flags() uses the existing guest page table walk code to
update the A/D bits and return to guest (when the introspection tool
write-protects the guest page tables).

kvm_page_track_emulation_failure() calls the page tracking code, that
can trigger an event for the introspection tool (which might need the
GVA in addition to the GPA).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/include/asm/vmx.h      | 2 ++
 arch/x86/kvm/svm/svm.c          | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 9 +++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 86048037da23..45c72af05fa2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1303,6 +1303,8 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+
+	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 38ca445a8429..5543332292b5 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -544,6 +544,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GLA_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -551,6 +552,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GLA_VALID		(1 << EPT_VIOLATION_GLA_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
 /*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 43a2e4ec6178..c6730ec39c58 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4314,6 +4314,13 @@ static int svm_vm_init(struct kvm *kvm)
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
@@ -4442,6 +4449,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+
+	.fault_gla = svm_fault_gla,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d5d4203378d3..41ea1ee9d419 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7641,6 +7641,13 @@ static int vmx_cpu_dirty_log_size(void)
 	return enable_pml ? PML_ENTITY_NUM : 0;
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
 
@@ -7779,6 +7786,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
+
+	.fault_gla = vmx_fault_gla,
 };
 
 static __init int hardware_setup(void)
