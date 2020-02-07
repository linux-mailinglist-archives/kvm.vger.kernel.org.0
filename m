Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F8155D80
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBGSQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:47 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40642 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbgBGSQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:43 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 346C1305D3CE;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 29EB6305206E;
        Fri,  7 Feb 2020 20:16:39 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v7 11/78] KVM: x86: add .control_cr3_intercept() to struct kvm_x86_ops
Date:   Fri,  7 Feb 2020 20:15:29 +0200
Message-Id: <20200207181636.1065-12-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_CONTROL_CR command.

Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm.c              | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 26 ++++++++++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d279195dac97..9032c996ebdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -134,6 +134,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
+#define CR_TYPE_R	1
+#define CR_TYPE_W	2
+#define CR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
@@ -1064,6 +1068,8 @@ struct kvm_x86_ops {
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
+				      bool enable);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index df34ab0da4ff..b6081afec926 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7256,6 +7256,19 @@ static inline bool svm_bp_intercepted(struct kvm_vcpu *vcpu)
 	return get_exception_intercept(svm, BP_VECTOR);
 }
 
+static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
+				      bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (type & CR_TYPE_R)
+		enable ? set_cr_intercept(svm, INTERCEPT_CR3_READ) :
+			 clr_cr_intercept(svm, INTERCEPT_CR3_READ);
+	if (type & CR_TYPE_W)
+		enable ? set_cr_intercept(svm, INTERCEPT_CR3_WRITE) :
+			 clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7297,6 +7310,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.set_cr0 = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
 	.set_cr4 = svm_set_cr4,
+	.control_cr3_intercept = svm_control_cr3_intercept,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0d7ca70b310e..4b6edb68e9e0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2900,24 +2900,37 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
+static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
+				      bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 cr3_exec_control = 0;
+
+	if (type & CR_TYPE_R)
+		cr3_exec_control |= CPU_BASED_CR3_STORE_EXITING;
+	if (type & CR_TYPE_W)
+		cr3_exec_control |= CPU_BASED_CR3_LOAD_EXITING;
+
+	if (enable)
+		exec_controls_setbit(vmx, cr3_exec_control);
+	else
+		exec_controls_clearbit(vmx, cr3_exec_control);
+}
+
 static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 					unsigned long cr0,
 					struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
 		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
-		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-					  CPU_BASED_CR3_STORE_EXITING);
+		vmx_control_cr3_intercept(vcpu, CR_TYPE_RW, true);
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	} else if (!is_paging(vcpu)) {
 		/* From nonpaging to paging */
-		exec_controls_clearbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
-					    CPU_BASED_CR3_STORE_EXITING);
+		vmx_control_cr3_intercept(vcpu, CR_TYPE_RW, false);
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
 	}
@@ -7801,6 +7814,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
 	.set_cr4 = vmx_set_cr4,
+	.control_cr3_intercept = vmx_control_cr3_intercept,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
