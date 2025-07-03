Return-Path: <kvm+bounces-51500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47637AF7C9E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 383914E08F1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1F82EF9CB;
	Thu,  3 Jul 2025 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQ3pjsl+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581EA2E7620;
	Thu,  3 Jul 2025 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751557063; cv=none; b=pZuHtu2Jjwk/E8+QjhGJ+4AejcQC4e08diy1RYsYM+sAr1wU88iJTjgWXqTAa9dEheIlpIGpJJ0ek/RYD8gLWpXrctYYXGdtQFBZSJKmo46oNgw5M7ZMINciu+OvY4j8fLPHol3eS7eN2D/zs6Cvh1L767xHMBRyHJQlD3oliok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751557063; c=relaxed/simple;
	bh=ig4e+5I8hSgr0vu+ManW3qFfz8gcMIjG9Qh9K5jsZ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0kgcWCVP/7vnpke/V0j2sIRLuKpDI/NsLkf4WqhAtfo/giMG6PVnT24ffhV3RUS0TPFFLmQ2yC8GlQtN1QmqeiRFMIB+6TJEXnT29aSE+bWN62GcxtWQUC4iSl2KPQcatI3xxwinb50oQZrVSorFwlnGDaWjwVK0OotxdXDQfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQ3pjsl+; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751557062; x=1783093062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ig4e+5I8hSgr0vu+ManW3qFfz8gcMIjG9Qh9K5jsZ3Y=;
  b=fQ3pjsl+0ZOE0zWLkYyshzmMlDNTVNLiAukV/gY02vAOAZllcuGuSmVd
   Dtl2n9Y34u0mSegnZC0oF2bIGv0KoigUPeMkZ9TC8ZNJffuHdNj0yWOAe
   EScVy6GK5OhL5/Dte/gnOm0VNF6C1DC1asJxEQ1L0JHCQ6ipTory07uNp
   Pt4gdZMtKeReug2k1YwDOobFnNMrCFnu5O2iz7YngkK7QYx2wzE23KeiQ
   ZlgeSExBj9nP3WJKm67zC/dHsEF6XLYcq6F6dSNCPfZqO52nymERMTn/n
   V3LS6csTAMALVLNvBtI9JRqeN1PVXKDwqFlBNnoBBCt5i15DFwnVpT7l6
   g==;
X-CSE-ConnectionGUID: rlJo1gIaTkK8eJI83zjxnw==
X-CSE-MsgGUID: +DNoMenbQfCYDjABIZHvLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76436688"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="76436688"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:41 -0700
X-CSE-ConnectionGUID: gJjfCQoiS1iD0sYiLVRShw==
X-CSE-MsgGUID: UJtWWCbCRqaaihgUssbEhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="178065127"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:36 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu,  3 Jul 2025 18:37:12 +0300
Message-ID: <20250703153712.155600-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250703153712.155600-1-adrian.hunter@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Avoid clearing reclaimed TDX private pages unless the platform is affected
by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
time on unaffected systems.

Background

KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:

   - Clears the TD Owner bit (which identifies TDX private memory) and
     integrity metadata without triggering integrity violations.
   - Clears poison from cache lines without consuming it, avoiding MCEs on
     access (refer TDX Module Base spec. 16.5. Handling Machine Check
     Events during Guest TD Operation).

The TDX module also uses MOVDIR64B to initialize private pages before use.
If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")

In contrast, when private pages are reclaimed, the TDX Module handles
flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.

Problem

Clearing all private pages during VM shutdown is costly. For guests
with a large amount of memory it can take minutes.

Solution

TDX Module Base Architecture spec. documents that private pages reclaimed
from a TD should be initialized using MOVDIR64B, in order to avoid
integrity violation or TD bit mismatch detection when later being read
using a shared HKID, refer April 2025 spec. "Page Initialization" in
section "8.6.2. Platforms not Using ACT: Required Cache Flush and
Initialization by the Host VMM"

That is an overstatement and will be clarified in coming versions of the
spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
Mode" in the same spec, there is no issue accessing such reclaimed pages
using a shared key that does not have integrity enabled. Linux always uses
KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
description in "Intel Architecture Memory Encryption Technologies" spec
version 1.6 April 2025. So there is no need to clear pages to avoid
integrity violations.

There remains a risk of poison consumption. However, in the context of
TDX, it is expected that there would be a machine check associated with the
original poisoning. On some platforms that results in a panic. However
platforms may support "SEAM_NR" Machine Check capability, in which case
Linux machine check handler marks the page as poisoned, which prevents it
from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
Implement recovery for errors in TDX/SEAM non-root mode")

Improvement

By skipping the clearing step on unaffected platforms, shutdown time
can improve by up to 40%.

On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
clearing because these platforms may trigger poison on partial writes to
previously-private pages, even with KeyID 0, refer commit 1e536e1068970
("x86/cpu: Detect TDX partial write machine check erratum")

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	Improve the comment


 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 14d93ed05bd2..4fa86188aa40 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -642,6 +642,14 @@ void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
 	unsigned long phys, end;
 
+	/*
+	 * Typically, any write to the page will convert it from TDX
+	 * private back to normal kernel memory. Systems with the
+	 * erratum need to do the conversion explicitly.
+	 */
+	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		return;
+
 	end = base + size;
 	for (phys = base; phys < end; phys += 64)
 		movdir64b(__va(phys), zero_page);
-- 
2.48.1


