Return-Path: <kvm+bounces-48763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C952EAD2693
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 941381708FC
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CA6225A38;
	Mon,  9 Jun 2025 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2OiRVul"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB72222D5;
	Mon,  9 Jun 2025 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496444; cv=none; b=H4jX0/hSTcjhScVJTolmiPw56o3ZuDgs2hl5ongGdNoUK2Dhod2ooig5tPnXtN+t20ZRWl3fzncr4iGMt635/Rh4R4m/5NWHkIZ2RvDcxK9PZhevFsoQO/y/RctKHRKJU/tvzTZU/enoEieXQKOnAXtrcFe6tty7rLrvGhbj0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496444; c=relaxed/simple;
	bh=kX+3ZVR0+aZ1UszWZjARbJWwTNTIBQcWEhqm1x/9MBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTmxh6Hx20JaZmUqRW0IMJxj+VF3hM2fe8y1o/6/iDjNXrcBeyWOpP/0kI636k+Bp59Yfzdpbk9614Qiz+F7QnZB6/DQBlH9GE+RDHmG9eab9fcwaw3lcDyIyyMb87Ypcf7MlMiM+IZwJnqMx5Ao14hDGQ4v+c7d3asXdMjye1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2OiRVul; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496443; x=1781032443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kX+3ZVR0+aZ1UszWZjARbJWwTNTIBQcWEhqm1x/9MBs=;
  b=G2OiRVul5YovaOSYABfHCZjX5XJkeR0fgCI9sCtJKaW9aUZ6P4C64+j0
   c546WC83NUZznbHIn5kzve3kG076LAeh1zNeVPD5qujtYf06q62E5AFO8
   TrYaxk5NvNdQZdBTM0DKblHcYu6AZF02uEV6fmTgche56lyerJK41HatD
   okK/IqC1BftODCTK9a0BBnn2s3aHsIxI7c/8QknfsL9U1Mzx3Inkv7OuK
   bLMjgeFroEhonkhFqm3um9K+oUShgPH4Z0uYivT3ofmFVkcBUwcdjNVuG
   1TgxRGYKem7sfF7JTFTjCXERgdfaMjnyAIYXHpVe6ZirBuKtawJUX3rcU
   w==;
X-CSE-ConnectionGUID: aNRxnkqRQjGhZa9oaVsMWg==
X-CSE-MsgGUID: 6OLddxpWQ6ypJ402xxtBkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681811"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681811"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:14:00 -0700
X-CSE-ConnectionGUID: xyquTUd2SemM+bGqi0GaHQ==
X-CSE-MsgGUID: XiVCkRk/ToefjoqPvYMteQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174198"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 8310CA65; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 12/12] Documentation/x86: Add documentation for TDX's Dynamic PAMT
Date: Mon,  9 Jun 2025 22:13:40 +0300
Message-ID: <20250609191340.2051741-13-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand TDX documentation to include information on the Dynamic PAMT
feature.

The new section explains PAMT support in the TDX module and how it is
enabled on the kernel side.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/arch/x86/tdx.rst | 108 +++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index 719043cd8b46..a1dc50dd6f57 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -99,6 +99,114 @@ initialize::
 
   [..] virt/tdx: module initialization failed ...
 
+Dynamic PAMT
+------------
+
+Dynamic PAMT support in TDX module
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Dynamic PAMT is a TDX feature that allows VMM to allocate PAMT_4K as
+needed. PAMT_1G and PAMT_2M are still allocated statically at the time of
+TDX module initialization. At init stage allocation of PAMT_4K is replaced
+with PAMT_PAGE_BITMAP which currently requires one bit of memory per 4k.
+
+VMM is responsible for allocating and freeing PAMT_4K. There's a couple of
+new SEAMCALLs for this: TDH.PHYMEM.PAMT.ADD and TDH.PHYMEM.PAMT.REMOVE.
+They add/remove PAMT memory in form of page pair. There's no requirement
+for these pages to be contiguous.
+
+Page pair supplied via TDH.PHYMEM.PAMT.ADD will cover specified 2M region.
+It allows any 4K from the region to be usable by TDX module.
+
+With Dynamic PAMT, a number of SEAMCALLs can now fail due to missing PAMT
+memory (TDX_MISSING_PAMT_PAGE_PAIR):
+
+ - TDH.MNG.CREATE
+ - TDH.MNG.ADDCX
+ - TDH.VP.ADDCX
+ - TDH.VP.CREATE
+ - TDH.MEM.PAGE.ADD
+ - TDH.MEM.PAGE.AUG
+ - TDH.MEM.PAGE.DEMOTE
+ - TDH.MEM.PAGE.RELOCATE
+
+Basically, if you supply memory to a TD, this memory has to backed by PAMT
+memory.
+
+Once no TD uses the 2M range, the PAMT page pair can be reclaimed with
+TDH.PHYMEM.PAMT.REMOVE.
+
+TDX module track PAMT memory usage and can give VMM a hint that PAMT
+memory can be removed. Such hint is provided from all SEAMCALLs that
+removes memory from TD:
+
+ - TDH.MEM.SEPT.REMOVE
+ - TDH.MEM.PAGE.REMOVE
+ - TDH.MEM.PAGE.PROMOTE
+ - TDH.MEM.PAGE.RELOCATE
+ - TDH.PHYMEM.PAGE.RECLAIM
+
+With Dynamic PAMT, TDH.MEM.PAGE.DEMOTE takes PAMT page pair as additional
+input to populate PAMT_4K on split. TDH.MEM.PAGE.PROMOTE returns no longer
+needed PAMT page pair.
+
+PAMT memory is global resource and not tied to a specific TD. TDX modules
+maintains PAMT memory in a radix tree addressed by physical address. Each
+entry in the tree can be locked with shared or exclusive lock. Any
+modification of the tree requires exclusive lock.
+
+Any SEAMCALL that takes explicit HPA as an argument will walk the tree
+taking shared lock on entries. It required to make sure that the page
+pointed by HPA is of compatible type for the usage.
+
+TDCALLs don't take PAMT locks as none of the take HPA as an argument.
+
+Dynamic PAMT enabling in kernel
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Kernel maintains refcounts for every 2M regions with two helpers
+tdx_pamt_get() and tdx_pamt_put().
+
+The refcount represents number of users for the PAMT memory in the region.
+Kernel calls TDH.PHYMEM.PAMT.ADD on 0->1 transition and
+TDH.PHYMEM.PAMT.REMOVE on transition 1->0.
+
+The function tdx_alloc_page() allocates a new page and ensures that it is
+backed by PAMT memory. Pages allocated in this manner are ready to be used
+for a TD. The function tdx_free_page() frees the page and releases the
+PAMT memory for the 2M region if it is no longer needed.
+
+PAMT memory gets allocated as part of TD init, VCPU init, on populating
+SEPT tree and adding guest memory (both during TD build and via AUG on
+accept). Splitting 2M page into 4K also requires PAMT memory.
+
+PAMT memory removed on reclaim of control pages and guest memory.
+
+Populating PAMT memory on fault and on split is tricky as kernel cannot
+allocate memory from the context where it is needed. These code paths use
+pre-allocated PAMT memory pools.
+
+Previous attempt on Dynamic PAMT enabling
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The initial attempt at kernel enabling was quite different. It was built
+around lazy PAMT allocation: only trying to add a PAMT page pair if a
+SEAMCALL fails due to a missing PAMT and reclaiming it based on hints
+provided by the TDX module.
+
+The motivation was to avoid duplicating the PAMT memory refcounting that
+the TDX module does on the kernel side.
+
+This approach is inherently more racy as there is no serialization of
+PAMT memory add/remove against SEAMCALLs that add/remove memory for a TD.
+Such serialization would require global locking, which is not feasible.
+
+This approach worked, but at some point it became clear that it could not
+be robust as long as the kernel avoids TDX_OPERAND_BUSY loops.
+TDX_OPERAND_BUSY will occur as a result of the races mentioned above.
+
+This approach was abandoned in favor of explicit refcounting.
+
 TDX Interaction to Other Kernel Components
 ------------------------------------------
 
-- 
2.47.2


