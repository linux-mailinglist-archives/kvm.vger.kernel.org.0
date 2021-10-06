Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1240B4244C3
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhJFRm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53720 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239135AbhJFRmh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:37 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 62BB1305CD45;
        Wed,  6 Oct 2021 20:30:57 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 496923064495;
        Wed,  6 Oct 2021 20:30:57 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 11/77] KVM: x86: add kvm_x86_ops.control_desc_intercept()
Date:   Wed,  6 Oct 2021 20:30:07 +0300
Message-Id: <20211006173113.26445-12-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed to intercept descriptor-table registers access.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/svm.c             | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 15 +++++++++++++--
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9a962bd098d0..dd08f3120f8f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,6 +125,7 @@ KVM_X86_OP(bp_intercepted)
 KVM_X86_OP(control_cr3_intercept)
 KVM_X86_OP(cr3_write_intercepted)
 KVM_X86_OP(desc_ctrl_supported)
+KVM_X86_OP(control_desc_intercept)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1acaa27ffd8f..2e5ddb18804b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1350,6 +1350,7 @@ struct kvm_x86_ops {
 	void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	bool (*desc_ctrl_supported)(void);
+	void (*control_desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e5cd8813cca6..0d46f5aa20c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1780,6 +1780,31 @@ static bool svm_desc_ctrl_supported(void)
 	return true;
 }
 
+static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (enable) {
+		svm_set_intercept(svm, INTERCEPT_STORE_IDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_GDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_LDTR);
+		svm_set_intercept(svm, INTERCEPT_STORE_TR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_IDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_GDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_LDTR);
+		svm_set_intercept(svm, INTERCEPT_LOAD_TR);
+	} else {
+		svm_clr_intercept(svm, INTERCEPT_STORE_IDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_GDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_LDTR);
+		svm_clr_intercept(svm, INTERCEPT_STORE_TR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_IDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_GDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_LDTR);
+		svm_clr_intercept(svm, INTERCEPT_LOAD_TR);
+	}
+}
+
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4666,6 +4691,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_gdt = svm_get_gdt,
 	.set_gdt = svm_set_gdt,
 	.desc_ctrl_supported = svm_desc_ctrl_supported,
+	.control_desc_intercept = svm_control_desc_intercept,
 	.set_dr7 = svm_set_dr7,
 	.sync_dirty_debug_regs = svm_sync_dirty_debug_regs,
 	.cache_reg = svm_cache_reg,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 026d678b82b9..d0f02d52b401 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3160,6 +3160,16 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (enable)
+		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
+	else
+		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+}
+
 static bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	/*
@@ -3197,11 +3207,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
-			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, true);
 			hw_cr4 &= ~X86_CR4_UMIP;
 		} else if (!is_guest_mode(vcpu) ||
 			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
-			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, false);
 		}
 	}
 
@@ -7636,6 +7646,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_gdt = vmx_get_gdt,
 	.set_gdt = vmx_set_gdt,
 	.desc_ctrl_supported = vmx_desc_ctrl_supported,
+	.control_desc_intercept = vmx_control_desc_intercept,
 	.set_dr7 = vmx_set_dr7,
 	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
 	.cache_reg = vmx_cache_reg,
