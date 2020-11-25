Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681C62C3C87
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgKYJmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:04 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57136 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727455AbgKYJmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:02 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7DDE3305D4FA;
        Wed, 25 Nov 2020 11:35:44 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5F7893072785;
        Wed, 25 Nov 2020 11:35:44 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>
Subject: [PATCH v10 09/81] KVM: x86: add kvm_x86_ops.control_cr3_intercept()
Date:   Wed, 25 Nov 2020 11:34:48 +0200
Message-Id: <20201125093600.2766-10-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_CONTROL_CR command, when the
introspection tool has to intercept the read/write access to CR3.

Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm/svm.c          | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 26 ++++++++++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e46fee59d4ed..0eeb1d829a1d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -137,6 +137,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
+#define CR_TYPE_R	1
+#define CR_TYPE_W	2
+#define CR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
@@ -1118,6 +1122,8 @@ struct kvm_x86_ops {
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	bool (*is_valid_cr4)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
+				      bool enable);
 	int (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 95c7072cde8e..4f28fa035048 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1707,6 +1707,19 @@ void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		kvm_update_cpuid_runtime(vcpu);
 }
 
+static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
+				      bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (type & CR_TYPE_R)
+		enable ? svm_set_intercept(svm, INTERCEPT_CR3_READ) :
+			 svm_clr_intercept(svm, INTERCEPT_CR3_READ);
+	if (type & CR_TYPE_W)
+		enable ? svm_set_intercept(svm, INTERCEPT_CR3_WRITE) :
+			 svm_clr_intercept(svm, INTERCEPT_CR3_WRITE);
+}
+
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4233,6 +4246,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_cr0 = svm_set_cr0,
 	.is_valid_cr4 = svm_is_valid_cr4,
 	.set_cr4 = svm_set_cr4,
+	.control_cr3_intercept = svm_control_cr3_intercept,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 93a97aa3d847..c5a53642d1c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2978,24 +2978,37 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
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
@@ -7629,6 +7642,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_cr0 = vmx_set_cr0,
 	.is_valid_cr4 = vmx_is_valid_cr4,
 	.set_cr4 = vmx_set_cr4,
+	.control_cr3_intercept = vmx_control_cr3_intercept,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
