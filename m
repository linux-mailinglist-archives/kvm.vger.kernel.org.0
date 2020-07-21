Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265FD228AE3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgGUVRw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:52 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37850 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731264AbgGUVQF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 37B47305D7EC;
        Wed, 22 Jul 2020 00:09:20 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 17E13303EFFA;
        Wed, 22 Jul 2020 00:09:20 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [PATCH v9 10/84] KVM: x86: add .control_cr3_intercept() to struct kvm_x86_ops
Date:   Wed, 22 Jul 2020 00:08:08 +0300
Message-Id: <20200721210922.7646-11-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function is needed for the KVMI_VCPU_CONTROL_CR command, when the
introspection tool has to intercept the read/write access to CR3.

Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/svm/svm.c          | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 26 ++++++++++++++++++++------
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 78fe3c7c814c..89c0bd6529a5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -136,6 +136,10 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_NR_FIXED_MTRR_REGION 88
 #define KVM_NR_VAR_MTRR 8
 
+#define CR_TYPE_R	1
+#define CR_TYPE_W	2
+#define CR_TYPE_RW	3
+
 #define ASYNC_PF_PER_VCPU 64
 
 enum kvm_reg {
@@ -1111,6 +1115,8 @@ struct kvm_x86_ops {
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
+	void (*control_cr3_intercept)(struct kvm_vcpu *vcpu, int type,
+				      bool enable);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
 	void (*get_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*set_idt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 23b3cd057753..f14fc940538b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1596,6 +1596,19 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	return 0;
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
 static void svm_set_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -4008,6 +4021,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr4 = svm_set_cr4,
+	.control_cr3_intercept = svm_control_cr3_intercept,
 	.set_efer = svm_set_efer,
 	.get_idt = svm_get_idt,
 	.set_idt = svm_set_idt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 069593f2f504..6b9639703560 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3003,24 +3003,37 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
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
@@ -7876,6 +7889,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr4 = vmx_set_cr4,
+	.control_cr3_intercept = vmx_control_cr3_intercept,
 	.set_efer = vmx_set_efer,
 	.get_idt = vmx_get_idt,
 	.set_idt = vmx_set_idt,
