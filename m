Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBFE741BD5
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbjF1WoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D7F2708;
        Wed, 28 Jun 2023 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992203; x=1719528203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZUG6Bm+xxuoCBKu5kXKP2G7VsQHqLtGPxdo6Qzaf3vQ=;
  b=dbhNSZad+Qxiw8CPdkFAp1wrqnD7uXqx/vacBQO6zrIf1Q1SHdSEicFd
   T/s4njxUx+OAzDRSRu803pzLcSlgygrQmWP8rBbe0OUjiHFxo04iBhwIv
   ZTQKrtP6I4ilG0o4sYIGyTwH+7SqDhdlEwKxuYOSEDY0xKVgSE9XdXqyU
   vqgxXtowC5Gui+TfoNHoynP+crkQY2y+BvfSrTltceLu179zEcqudN0X2
   7HmNCyCAxNQuxYxaD3jOuFwjP38H++G8HeF7pVj6jhfIZOrcc6mD9OxUs
   lzGhs2xAVrPcNzrA+FvLz+/BTeUOg33pp5vsxkXAGJsa69l+YtEm3aL1D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699144"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699144"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830299996"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830299996"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:22 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 05/11] KVM: x86/mmu: Pass around full 64-bit error code for the KVM page fault
Date:   Wed, 28 Jun 2023 15:43:04 -0700
Message-Id: <219ac3c013d093a3b15ed8419536d10e7838c386.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because the full 64-bit error code, or more info about the fault, for the
KVM page fault will be needed for protected VM, TDX and SEV-SNP, update
kvm_mmu_do_page_fault() to accept the 64-bit value so it can pass it to the
callbacks.

The upper 32 bits of error code are discarded at kvm_mmu_page_fault()
by lower_32_bits().  Now it's passed down as full 64 bits.
Currently two hardware defined bits, PFERR_GUEST_FINAL_MASK and
PFERR_GUEST_PAGE_MASK, and one software defined bit, PFERR_IMPLICIT_ACCESS,
is defined.

PFERR_IMPLICIT_ACCESS:
commit 4f4aa80e3b88 ("KVM: X86: Handle implicit supervisor access with SMAP")
introduced a software defined bit PFERR_IMPLICIT_ACCESS at bit 48 to
indicate implicit access for SMAP with instruction emulator.  Concretely
emulator_read_std() and emulator_write_std() set the bit.
permission_fault() checks the bit as smap implicit access.  The vendor page
fault handler shouldn't pass the bit to kvm_mmu_page_fault().

PFERR_GUEST_FINAL_MASK and PFERR_GUEST_PAGE_MASK:
commit 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
introduced them to optimize the nested page fault handling.  Other code
path doesn't use the bits.  Those two bits can be safely passed down
without functionality change.

The accesses of fault->error_code are as follows
- FNAME(page_fault): PFERR_IMPLICIT_ACCESS shouldn't be passed down.
                     PFERR_GUEST_FINAL_MASK and PFERR_GUEST_PAGE_MASK
                     aren't used.
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK, and
                        PFERR_NESTED_GUEST_PAGE is used outside of the
                        masking upper 32 bits.
- mmutrace: change u32 -> u64
- pgprintk(): change %x -> %llx

No functional change is intended.  This is a preparation to pass on more
info with page fault error code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v2 -> v3:
- Make depends on a patch to clear PFERR_IMPLICIT_ACCESS
- drop clearing the upper 32 bit, instead just pass whole 64 bits
- update commit message to mention about PFERR_IMPLICIT_ACCESS and
  PFERR_NESTED_GUEST_PAGE

Changes v1 -> v2:
- no change
---
 arch/x86/kvm/mmu/mmu.c          | 5 ++---
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dc2b9a2f717c..b8ba7f11c3cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4510,7 +4510,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu,
 				struct kvm_page_fault *fault)
 {
-	pgprintk("%s: gva %lx error %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: gva %llx error %llx\n", __func__, fault->addr, fault->error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
 	fault->max_level = PG_LEVEL_2M;
@@ -5820,8 +5820,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f1786698ae00..7f9ec1e5b136 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -191,7 +191,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -283,7 +283,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2d7555381955..2e77883c92f6 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -261,7 +261,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..42d48b1ec7b3 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -758,7 +758,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct guest_walker walker;
 	int r;
 
-	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: addr %llx err %llx\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
-- 
2.25.1

