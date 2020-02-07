Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8A155D81
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgBGSQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:48 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727490AbgBGSQp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:45 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id ADC38305D3D9;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A14643052077;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 22/78] KVM: x86: add .fault_gla()
Date:   Fri,  7 Feb 2020 20:15:40 +0200
Message-Id: <20200207181636.1065-23-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/include/asm/vmx.h      | 2 ++
 arch/x86/kvm/svm.c              | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 9 +++++++++
 4 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9f12d40198b5..6094884d3015 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1253,6 +1253,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	u64 (*fault_gla)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1835767aa335..edb1afc060d6 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -524,6 +524,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GLA_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -531,6 +532,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GLA_VALID		(1 << EPT_VIOLATION_GLA_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
 /*
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c3b7f593299f..ab9576444e6b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7351,6 +7351,13 @@ static void svm_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 	set_msr_interception(vcpu, msrpm, msr, type, !enable);
 }
 
+static u64 svm_fault_gla(struct kvm_vcpu *vcpu)
+{
+	const struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->vcpu.arch.cr2 ? svm->vcpu.arch.cr2 : ~0ull;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7495,6 +7502,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.fault_gla = svm_fault_gla,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a96a911e5f2..f1df5725d06f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7816,6 +7816,13 @@ static void vmx_control_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 	vmx_set_intercept_for_msr(vcpu, msr_bitmap, msr, type, enable);
 }
 
+static u64 vmx_fault_gla(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exit_qualification & EPT_VIOLATION_GLA_VALID)
+		return vmcs_readl(GUEST_LINEAR_ADDRESS);
+	return ~0ull;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7973,6 +7980,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+
+	.fault_gla = vmx_fault_gla,
 };
 
 static void vmx_cleanup_l1d_flush(void)
