Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D59173AD0E
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjFVXRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjFVXRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0541526A0;
        Thu, 22 Jun 2023 16:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475839; x=1719011839;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ROuJQzixyiTqp680sndGz2g/SfpfDyBJFI0PJfgE+Y=;
  b=R2LKDd7wNdndVsl3+BKTsx+L78PMZ+DJHe5o7dyHpRcTa1B4xnur2lM/
   tXbYSslXOnvY4yX4hhsqXFLl/HFm5zjnkODwE/ecTZRwzGnoAcFAJD9jT
   pYx1cQJru1tYjpr0GQGX3xFDX/fGUCznqn3qM9fLpbxKQqQOqnZwhzzmN
   44Sf1KLGbAAAN8rwSHnpIVDFIquHgrfEHkoTcw0U2WGdbbIkQ3F3n9MY2
   9EiWP78TpE8RKKYbjsZiGs8rdYSyqnzwOlz5f4R896X/7yP4OdUvbWIPM
   aWUsfNYMG6qLVhTwp7GCL0qMopmafJWLoxO1r+zsFKerPln6vwp/Ck68g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129729"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129729"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285979"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285979"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:11 -0700
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
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error code for the KVM page fault
Date:   Thu, 22 Jun 2023 16:16:27 -0700
Message-Id: <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687474039.git.isaku.yamahata@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Because only FNAME(page_fault) depends on it, move lower_32_bits() into
FNAME(page_fault).

The accesses of fault->error_code are as follows
- FNAME(page_fault): change to explicitly use lower_32_bits()
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK,
                        PFERR_NESTED_GUEST_PAGE
- mmutrace: changed u32 -> u64
- pgprintk(): change %x -> %llx

No functional change is intended.  This is a preparation to pass on more
info with page fault error code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v1 -> v2:
- no change
---
 arch/x86/kvm/mmu/mmu.c          | 5 ++---
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  | 4 ++--
 4 files changed, 7 insertions(+), 8 deletions(-)

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
index 0662e0278e70..ee4b881c5b39 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -758,7 +758,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct guest_walker walker;
 	int r;
 
-	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
+	pgprintk("%s: addr %llx err %llx\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
 
 	/*
@@ -767,7 +767,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 * The bit needs to be cleared before walking guest page tables.
 	 */
 	r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
-			     fault->error_code & ~PFERR_RSVD_MASK);
+			     lower_32_bits(fault->error_code) & ~PFERR_RSVD_MASK);
 
 	/*
 	 * The page is not mapped by the guest.  Let the guest handle it.
-- 
2.25.1

