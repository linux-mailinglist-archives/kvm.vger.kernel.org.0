Return-Path: <kvm+bounces-64037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A247AC76D0D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 623014E3B7C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FAB2BF3C5;
	Fri, 21 Nov 2025 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jtt+usQe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D031EEE6;
	Fri, 21 Nov 2025 00:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686309; cv=none; b=CgCMxu9mDidJ28Ej/wQEqiKGgRRUOvjO2vBP4BCOT4IDibFZFhg2eCVKgcfOOQB/Eil29yDe0xOKwCQM0z/9RVwMTYr2ANse7PKf38djfa2FEvBHkFOn9W4lr1vLvI8LjsafHiR4chXJ0dX8HAYjeZleMg69qCYsAPWL4wblD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686309; c=relaxed/simple;
	bh=ZbaZuFKUkjb/la2gWPavHW92oSW6c732jkDotpq/0tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFRHO8f+YLZ4/cO0NBWX+RPC0fLsi9etCsDl0cfqPiJWfdckv7nq96xrt9vHD0yUcvsWJoWZkmZc82tAfftZF7q+BpcHr6Z3IIjCcdz33WLRfO+7WNkkel29SWgYO6XFACmbQtHKcz/2q5F3AtIsE1fi1TebMuqLmrQt5v62qUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jtt+usQe; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686308; x=1795222308;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZbaZuFKUkjb/la2gWPavHW92oSW6c732jkDotpq/0tE=;
  b=Jtt+usQeYiwR10EcKTzbJJz+otlleinAq8J3XMW4oRUoXpY0EVp4YRWy
   yw4tneHLIM0ZI2QfY3C2xQQgFaliGc7QYUKF+Kl8Bhy7ZmhwJPZOlf4fb
   PY5pMTW+OqhatRO2Yox/H72Kn4f3fZWjjm7ErTlpcVGAVv1zvTOIsD0LH
   G/XZ6XddvTK+0Lbyjlx/AOvQ8l5UmWfcpRa/sh0HU0TvjLJl+c2LLPlpG
   l145yoxANwVkbJu7GlpKK1tFtrdEuOz880rNWO7m1qluc6tks+pnHLjln
   /opdR7HhkTozeYgBKmoC1Y06Qh0hrlUCxuC++WdAR0fFQ154izKP+rTrF
   w==;
X-CSE-ConnectionGUID: ZYnqDNdoSCShe2XkXvf2yA==
X-CSE-MsgGUID: Nt2ECToMTRCuMJfC1ea0JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780774"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780774"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:44 -0800
X-CSE-ConnectionGUID: v16xsLIMR3qyD+ojmSK/4g==
X-CSE-MsgGUID: 6cla+7TATgGm9IsVAElbPg==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:44 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 08/16] x86/virt/tdx: Optimize tdx_alloc/free_page() helpers
Date: Thu, 20 Nov 2025 16:51:17 -0800
Message-ID: <20251121005125.417831-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Optimize the PAMT alloc/free helpers to avoid taking the global lock when
possible.

The recently introduced PAMT alloc/free helpers maintain a refcount to
keep track of when it is ok to reclaim and free a 4KB PAMT page. This
refcount is protected by a global lock in order to guarantee that races
don’t result in the PAMT getting freed while another caller requests it
be mapped. But a global lock is a bit heavyweight, especially since the
refcounts can be (already are) updated atomically.

A simple approach would be to increment/decrement the refcount outside of
the lock before actually adjusting the PAMT, and only adjust the PAMT if
the refcount transitions from/to 0. This would correctly allocate and free
the PAMT page without getting out of sync. But there it leaves a race
where a simultaneous caller could see the refcount already incremented and
return before it is actually mapped.

So treat the refcount 0->1 case as a special case. On add, if the refcount
is zero *don’t* increment the refcount outside the lock (to 1). Always
take the lock in that case and only set the refcount to 1 after the PAMT
is actually added. This way simultaneous adders, when PAMT is not
installed yet, will take the slow lock path.

On the 1->0 case, it is ok to return from tdx_pamt_put() when the DPAMT is
not actually freed yet, so the basic approach works. Just decrement the
refcount before  taking the lock. Only do the lock and removal of the PAMT
when the refcount goes to zero.

There is an asymmetry between tdx_pamt_get() and tdx_pamt_put() in that
tdx_pamt_put() goes 1->0 outside the lock, but tdx_pamt_get() does 0-1
inside the lock. Because of this, there is a special race where
tdx_pamt_put() could decrement the refcount to zero before the PAMT is
actually removed, and tdx_pamt_get() could try to do a PAMT.ADD when the
page is already mapped. Luckily the TDX module will tell return a special
error that tells us we hit this case. So handle it specially by looking
for the error code.

The optimization is a little special, so make the code extra commented
and verbose.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Clean up code, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Use atomic_set() in the HPA_RANGE_NOT_FREE case (Kiryl)
 - Log, comment typos (Binbin)
 - Move PAMT page allocation after refcount check in tdx_pamt_get() to
   avoid an alloc/free in the common path.

v3:
 - Split out optimization from “x86/virt/tdx: Add tdx_alloc/free_page() helpers”
 - Remove edge case handling that I could not find a reason for
 - Write log
---
 arch/x86/include/asm/shared/tdx_errno.h |  2 +
 arch/x86/virt/vmx/tdx/tdx.c             | 68 ++++++++++++++++++-------
 2 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
index e302aed31b50..acf7197527da 100644
--- a/arch/x86/include/asm/shared/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -21,6 +21,7 @@
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
 #define TDX_RND_NO_ENTROPY			0x8000020300000000ULL
 #define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000ULL
+#define TDX_HPA_RANGE_NOT_FREE			0xC000030400000000ULL
 #define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000ULL
 #define TDX_KEY_GENERATION_FAILED		0x8000080000000000ULL
 #define TDX_KEY_STATE_INCORRECT			0xC000081100000000ULL
@@ -94,6 +95,7 @@ DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
 DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
+DEFINE_TDX_ERRNO_HELPER(TDX_HPA_RANGE_NOT_FREE);
 DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
 DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
 DEFINE_TDX_ERRNO_HELPER(TDX_SW_ERROR);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 745b308785d6..39e2e448c8ba 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2139,21 +2139,28 @@ int tdx_pamt_get(struct page *page)
 	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
 	atomic_t *pamt_refcount;
 	u64 tdx_status;
-	int ret;
+	int ret = 0;
 
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
 
+	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
+
+	/*
+	 * If the pamt page is already added (i.e. refcount >= 1),
+	 * then just increment the refcount.
+	 */
+	if (atomic_inc_not_zero(pamt_refcount))
+		return 0;
+
 	ret = alloc_pamt_array(pamt_pa_array);
 	if (ret)
 		goto out_free;
 
-	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
-
 	scoped_guard(spinlock, &pamt_lock) {
 		/*
-		 * If the pamt page is already added (i.e. refcount >= 1),
-		 * then just increment the refcount.
+		 * Lost race to other tdx_pamt_add(). Other task has already allocated
+		 * PAMT memory for the HPA.
 		 */
 		if (atomic_read(pamt_refcount)) {
 			atomic_inc(pamt_refcount);
@@ -2163,12 +2170,29 @@ int tdx_pamt_get(struct page *page)
 		/* Try to add the pamt page and take the refcount 0->1. */
 
 		tdx_status = tdh_phymem_pamt_add(page, pamt_pa_array);
-		if (!IS_TDX_SUCCESS(tdx_status)) {
+		if (IS_TDX_SUCCESS(tdx_status)) {
+			/*
+			 * The refcount is zero, and this locked path is the only way to
+			 * increase it from 0-1. If the PAMT.ADD was successful, set it
+			 * to 1 (obviously).
+			 */
+			atomic_set(pamt_refcount, 1);
+		} else if (IS_TDX_HPA_RANGE_NOT_FREE(tdx_status)) {
+			/*
+			 * Less obviously, another CPU's call to tdx_pamt_put() could have
+			 * decremented the refcount before entering its lock section.
+			 * In this case, the PAMT is not actually removed yet. Luckily
+			 * TDX module tells about this case, so increment the refcount
+			 * 0-1, so tdx_pamt_put() skips its pending PAMT.REMOVE.
+			 *
+			 * The call didn't need the pages though, so free them.
+			 */
+			atomic_set(pamt_refcount, 1);
+			goto out_free;
+		} else {
 			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
 			goto out_free;
 		}
-
-		atomic_inc(pamt_refcount);
 	}
 
 	return ret;
@@ -2197,20 +2221,32 @@ void tdx_pamt_put(struct page *page)
 
 	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
 
+	/*
+	 * If the there are more than 1 references on the pamt page,
+	 * don't remove it yet. Just decrement the refcount.
+	 *
+	 * Unlike the paired call in tdx_pamt_get(), decrement the refcount
+	 * outside the lock even if it's the special 0<->1 transition. See
+	 * special logic around HPA_RANGE_NOT_FREE in tdx_pamt_get().
+	 */
+	if (!atomic_dec_and_test(pamt_refcount))
+		return;
+
 	scoped_guard(spinlock, &pamt_lock) {
-		/*
-		 * If the there are more than 1 references on the pamt page,
-		 * don't remove it yet. Just decrement the refcount.
-		 */
-		if (atomic_read(pamt_refcount) > 1) {
-			atomic_dec(pamt_refcount);
+		/* Lost race with tdx_pamt_get(). */
+		if (atomic_read(pamt_refcount))
 			return;
-		}
 
 		/* Try to remove the pamt page and take the refcount 1->0. */
 
 		tdx_status = tdh_phymem_pamt_remove(page, pamt_pa_array);
 		if (!IS_TDX_SUCCESS(tdx_status)) {
+			/*
+			 * Since the refcount was optimistically decremented above
+			 * outside the lock, revert it if there is a failure.
+			 */
+			atomic_inc(pamt_refcount);
+
 			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
 
 			/*
@@ -2219,8 +2255,6 @@ void tdx_pamt_put(struct page *page)
 			 */
 			return;
 		}
-
-		atomic_dec(pamt_refcount);
 	}
 
 	/*
-- 
2.51.2


