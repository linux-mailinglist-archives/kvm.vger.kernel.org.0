Return-Path: <kvm+bounces-58063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ABDD5B875CE
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8B767A738E
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF052F3632;
	Thu, 18 Sep 2025 23:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CAqpEbA/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5D2FDC50;
	Thu, 18 Sep 2025 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237787; cv=none; b=LjgMrco9o9LrEWKO9HI0NMDfrsk4n9CGEbIUUUjL+v20iCxmd7ixpxeW+6xZsi5Lr2jN3uo5zGM9GLm+YkL9fhl1HyI1GtVqn9tXi7GWPhARZ/uu5QppCxgfSxdk2twZYAnyojuk/vxXV6dck135iGKkFDOOsZsYd/mgPYd+EJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237787; c=relaxed/simple;
	bh=YNABSNX5onYUhhntZUKy1Dc52UoGlsO+Tqj088IDCfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkbyl0Cvsh8+fGY4l9OF/+8lhCvRLiNWhJ23oIhIcx2Y4RABl8ueaHtKwffy71iD94iGIxV6etrv7Eji5DMosNz4kfDKEwKbph20guCPHPjNO9O3VRWv5oRx72eFv0fJLZ8HIas2pefixkN5yzuRqnXhOeM6hL5v0Mrn+KszPfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CAqpEbA/; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237786; x=1789773786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YNABSNX5onYUhhntZUKy1Dc52UoGlsO+Tqj088IDCfw=;
  b=CAqpEbA/PzzRjIfxCZwRMMvD8Yd40AIxDJuAexRO66LihJTmg3+ePX72
   rG06NdmmpbhkfFoOkp0xcNyhhKPexVMGYwnrWvCaOojKWQyzX2+13QIup
   nmQIpjrxd+V/xXCfOlTHhXYZU3a/6rCI7B/pMBNI9fPW9DEoMWlGKBV4y
   pyKHrG+kJ51LAYdAoAfhI0l/LocWiYYWex+HP8EZNwdv5i0dtZj9aY1M2
   3O8Lmwfe+zgAkuV/t+IXdb47wHBBtqw7PwvChkeiU5f5Qx2y8txm/0d1s
   myeatEEMu+x8V84ILr+vO01U9f+NS2mh0rRU2bG0LbQKgVjGr6PbS+u1p
   g==;
X-CSE-ConnectionGUID: i/nVtO4mQ1yP5bccR1Q+Pw==
X-CSE-MsgGUID: c3D2wBObQ2uhWU+CmLit8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735418"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735418"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:03 -0700
X-CSE-ConnectionGUID: gbcfhf72S3ig6y7S4FJN9A==
X-CSE-MsgGUID: xpQ9hGz7QVqBcC1yPTy9vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491425"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:02 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 08/16] x86/virt/tdx: Optimize tdx_alloc/free_page() helpers
Date: Thu, 18 Sep 2025 16:22:16 -0700
Message-ID: <20250918232224.2202592-9-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
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
tdx_pamt_put() goes 1->0 outside the lock, but tdx_pamt_put() does 0-1
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
v3:
 - Split out optimization from “x86/virt/tdx: Add tdx_alloc/free_page() helpers”
 - Remove edge case handling that I could not find a reason for
 - Write log
---
 arch/x86/include/asm/shared/tdx_errno.h |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c             | 46 +++++++++++++++++++++----
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm/shared/tdx_errno.h
index 49ab7ecc7d54..4bc0b9c9e82b 100644
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
@@ -100,6 +101,7 @@ DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
 DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
 DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
+DEFINE_TDX_ERRNO_HELPER(TDX_HPA_RANGE_NOT_FREE);
 DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
 DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index af73b6c2e917..c25e238931a7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2117,7 +2117,7 @@ int tdx_pamt_get(struct page *page)
 	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
 	atomic_t *pamt_refcount;
 	u64 tdx_status;
-	int ret;
+	int ret = 0;
 
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
@@ -2128,14 +2128,40 @@ int tdx_pamt_get(struct page *page)
 
 	pamt_refcount = tdx_find_pamt_refcount(hpa);
 
+	if (atomic_inc_not_zero(pamt_refcount))
+		goto out_free;
+
 	scoped_guard(spinlock, &pamt_lock) {
-		if (atomic_read(pamt_refcount))
+		/*
+		 * Lost race to other tdx_pamt_add(). Other task has already allocated
+		 * PAMT memory for the HPA.
+		 */
+		if (atomic_read(pamt_refcount)) {
+			atomic_inc(pamt_refcount);
 			goto out_free;
+		}
 
 		tdx_status = tdh_phymem_pamt_add(hpa | TDX_PS_2M, pamt_pa_array);
 
 		if (IS_TDX_SUCCESS(tdx_status)) {
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
 			atomic_inc(pamt_refcount);
+			goto out_free;
 		} else {
 			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
 			goto out_free;
@@ -2167,15 +2193,23 @@ void tdx_pamt_put(struct page *page)
 
 	pamt_refcount = tdx_find_pamt_refcount(hpa);
 
+	/*
+	 * Unlike the paired call in tdx_pamt_get(), decrement the refcount
+	 * outside the lock even if it's not the special 0<->1 transition.
+	 * See special logic around HPA_RANGE_NOT_FREE in tdx_pamt_get().
+	 */
+	if (!atomic_dec_and_test(pamt_refcount))
+		return;
+
 	scoped_guard(spinlock, &pamt_lock) {
-		if (!atomic_read(pamt_refcount))
+		/* Lost race with tdx_pamt_get() */
+		if (atomic_read(pamt_refcount))
 			return;
 
 		tdx_status = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, pamt_pa_array);
 
-		if (IS_TDX_SUCCESS(tdx_status)) {
-			atomic_dec(pamt_refcount);
-		} else {
+		if (!IS_TDX_SUCCESS(tdx_status)) {
+			atomic_inc(pamt_refcount);
 			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
 			return;
 		}
-- 
2.51.0


