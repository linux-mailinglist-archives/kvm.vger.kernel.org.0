Return-Path: <kvm+bounces-53371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6F8B10AE2
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABB16580D0A
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6BA41FECA1;
	Thu, 24 Jul 2025 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Figj09oU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6942D8367;
	Thu, 24 Jul 2025 13:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753362270; cv=none; b=tHODZ9ML/gOmQ/bEFyTKxkgr6Fpwq4B3oZVwy6H0l+oCtkI3Jawg4wIyPafMbILPHJi8oJxLrgOtF7R3fWntNBWax24SSO+ARVTr/Rhn7GGwo0o8uRiCF1aQ2FNQySRDSbNkEkpRk2ul1KDCDogQSt21/ebhHa+FokKUzPre3EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753362270; c=relaxed/simple;
	bh=FphqiSN4vulq9eQKOI1Wr68shAavKpTgYqrH0G6sDU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RK9Rk9bgoPlM54wizq+sCq1J5UHKUHmMty8+d8/j5aBlEZw4uCXRn3m/ZXhW+DH7Da01tkHTZOyVY8ZhHeEZCdFmbVRMTK8f+1J17izwUSoo5DV2O+lI0szkIIYoCV5Huo/TfUHNH4egE8gLQFe7gSs34k3wT5NFyuXQvT7DfLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Figj09oU; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753362269; x=1784898269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FphqiSN4vulq9eQKOI1Wr68shAavKpTgYqrH0G6sDU4=;
  b=Figj09oU54TFGdmN42f7XKq06q2IjJkiO6Mb7hu8zFUGLwE2Pk7iDAiP
   oyk/9uf6iTkAbnHDzvra+R4NHzaE4TlCgb520TG2NKhU/o22WShCaCxwd
   hNvcIfB5EP6RqJxZfo2Of6oAKrSIzDVx7Cgc08VAgxl9O5aWoMJIp38ZG
   SZX/V4JWlBj584F7AcVUTChX8teow/q3SgeHJscacsxKYplKzxfPU/Npc
   mRlcE2fcvFaWO7O8HwQm6iMTWe0HkkC7BDajiDQZ5qYQkJ5PBrAu3hP8y
   SyIIIe50+LBofLaI7CCcnGjkMc/hpVsLmeVRkFv/YtBWOYXvXz6F4MwQ6
   g==;
X-CSE-ConnectionGUID: h5crpJ3LRC2jBRJLZbF8Tg==
X-CSE-MsgGUID: 92s+M7JURoaB4NM5OFlmGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59480699"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="59480699"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:28 -0700
X-CSE-ConnectionGUID: RO81xzs+QBeePLNXB3JQdQ==
X-CSE-MsgGUID: /Tz16rhqRImetwECSUvB0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165599066"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.21])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 06:04:23 -0700
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
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V6 3/3] x86/tdx: Skip clearing reclaimed pages unless X86_BUG_TDX_PW_MCE is present
Date: Thu, 24 Jul 2025 16:03:54 +0300
Message-ID: <20250724130354.79392-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250724130354.79392-1-adrian.hunter@intel.com>
References: <20250724130354.79392-1-adrian.hunter@intel.com>
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
     access (refer TDX Module Base spec. 1348549-006US section 6.5.
     Handling Machine Check Events during Guest TD Operation).

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

Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V6:

	Add Xiaoyao's Rev'd-by

Changes in V5:

	None

Changes in V4:

	Add TDX Module Base spec. version (Rick)
	Add Rick's Rev'd-by

Changes in V3:

	Remove "flush cache" comments (Rick)
	Update function comment to better relate to "quirk" naming (Rick)
	Add "via MOVDIR64B" to comment (Xiaoyao)
	Add Rev'd-by, Ack'd-by tags

Changes in V2:

	Improve the comment


 arch/x86/virt/vmx/tdx/tdx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9e4638f68ba0..823850399bb7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -633,15 +633,19 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
 }
 
 /*
- * Convert TDX private pages back to normal by using MOVDIR64B to
- * clear these pages.  Note this function doesn't flush cache of
- * these TDX private pages.  The caller should make sure of that.
+ * Convert TDX private pages back to normal by using MOVDIR64B to clear these
+ * pages. Typically, any write to the page will convert it from TDX private back
+ * to normal kernel memory. Systems with the X86_BUG_TDX_PW_MCE erratum need to
+ * do the conversion explicitly via MOVDIR64B.
  */
 static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 {
 	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
 	unsigned long phys, end;
 
+	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
+		return;
+
 	end = base + size;
 	for (phys = base; phys < end; phys += 64)
 		movdir64b(__va(phys), zero_page);
-- 
2.48.1


