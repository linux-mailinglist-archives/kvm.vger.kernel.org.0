Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302CA562FEB
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbiGAJZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiGAJZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:25:03 -0400
Received: from out0-140.mail.aliyun.com (out0-140.mail.aliyun.com [140.205.0.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC61674360;
        Fri,  1 Jul 2022 02:24:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.OHOTEQy_1656667454;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OHOTEQy_1656667454)
          by smtp.aliyun-inc.com;
          Fri, 01 Jul 2022 17:24:14 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Replace UNMAPPED_GVA with INVALID_GPA for gva_to_gpa()
Date:   Fri, 01 Jul 2022 17:24:13 +0800
Message-Id: <6104978956449467d3c68f1ad7f2c2f6d771d0ee.1656667239.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The result of gva_to_gpa() is physical address not virtual address,
it is odd that UNMAPPED_GVA macro is used as the result for physical
address. Replace UNMAPPED_GVA with INVALID_GPA and drop UNMAPPED_GVA
macro.

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +++---
 arch/x86/kvm/vmx/sgx.c          |  2 +-
 arch/x86/kvm/x86.c              | 18 +++++++++---------
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 665667d61caf..b438d86796ac 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -129,7 +129,6 @@
 #define INVALID_PAGE (~(hpa_t)0)
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
 
-#define UNMAPPED_GVA (~(gpa_t)0)
 #define INVALID_GPA (~(gpa_t)0)
 
 /* KVM Hugepage definitions for x86 */
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fc6d8dcff019..25ad6c32700a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -378,7 +378,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * information to fix the exit_qualification or exit_info_1
 		 * fields.
 		 */
-		if (unlikely(real_gpa == UNMAPPED_GVA))
+		if (unlikely(real_gpa == INVALID_GPA))
 			return 0;
 
 		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
@@ -431,7 +431,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 #endif
 
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
-	if (real_gpa == UNMAPPED_GVA)
+	if (real_gpa == INVALID_GPA)
 		return 0;
 
 	walker->gfn = real_gpa >> PAGE_SHIFT;
@@ -962,7 +962,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			       struct x86_exception *exception)
 {
 	struct guest_walker walker;
-	gpa_t gpa = UNMAPPED_GVA;
+	gpa_t gpa = INVALID_GPA;
 	int r;
 
 #ifndef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 35e7ec91ae86..7ae8aa73724c 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -79,7 +79,7 @@ static int sgx_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t gva, bool write,
 	else
 		*gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, &ex);
 
-	if (*gpa == UNMAPPED_GVA) {
+	if (*gpa == INVALID_GPA) {
 		kvm_inject_emulated_page_fault(vcpu, &ex);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ce0c6fe166d..fe6ae7f518d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -849,7 +849,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 */
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(pdpt_gfn),
 				     PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
-	if (real_gpa == UNMAPPED_GVA)
+	if (real_gpa == INVALID_GPA)
 		return 0;
 
 	/* Note the offset, PDPTRs are 32 byte aligned when using PAE paging. */
@@ -6981,7 +6981,7 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
-		if (gpa == UNMAPPED_GVA)
+		if (gpa == INVALID_GPA)
 			return X86EMUL_PROPAGATE_FAULT;
 		ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, data,
 					       offset, toread);
@@ -7012,7 +7012,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	/* Inline kvm_read_guest_virt_helper for speed.  */
 	gpa_t gpa = mmu->gva_to_gpa(vcpu, mmu, addr, access|PFERR_FETCH_MASK,
 				    exception);
-	if (unlikely(gpa == UNMAPPED_GVA))
+	if (unlikely(gpa == INVALID_GPA))
 		return X86EMUL_PROPAGATE_FAULT;
 
 	offset = addr & (PAGE_SIZE-1);
@@ -7082,7 +7082,7 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 		unsigned towrite = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
-		if (gpa == UNMAPPED_GVA)
+		if (gpa == INVALID_GPA)
 			return X86EMUL_PROPAGATE_FAULT;
 		ret = kvm_vcpu_write_guest(vcpu, gpa, data, towrite);
 		if (ret < 0) {
@@ -7193,7 +7193,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 
 	*gpa = mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 
-	if (*gpa == UNMAPPED_GVA)
+	if (*gpa == INVALID_GPA)
 		return -1;
 
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
@@ -7430,7 +7430,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
 
-	if (gpa == UNMAPPED_GVA ||
+	if (gpa == INVALID_GPA ||
 	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto emul_write;
 
@@ -8253,7 +8253,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * If the mapping is invalid in guest, let cpu retry
 		 * it to generate fault.
 		 */
-		if (gpa == UNMAPPED_GVA)
+		if (gpa == INVALID_GPA)
 			return true;
 	}
 
@@ -11292,7 +11292,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	gpa = kvm_mmu_gva_to_gpa_system(vcpu, vaddr, NULL);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	tr->physical_address = gpa;
-	tr->valid = gpa != UNMAPPED_GVA;
+	tr->valid = gpa != INVALID_GPA;
 	tr->writeable = 1;
 	tr->usermode = 0;
 
@@ -12893,7 +12893,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
 
 	if (!(error_code & PFERR_PRESENT_MASK) ||
-	    mmu->gva_to_gpa(vcpu, mmu, gva, access, &fault) != UNMAPPED_GVA) {
+	    mmu->gva_to_gpa(vcpu, mmu, gva, access, &fault) != INVALID_GPA) {
 		/*
 		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
 		 * tables probably do not match the TLB.  Just proceed
-- 
2.31.1

