Return-Path: <kvm+bounces-49867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E10C0ADEB60
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F9B51887712
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF6472DE1E2;
	Wed, 18 Jun 2025 12:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdxKBZ1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDE3F9C5;
	Wed, 18 Jun 2025 12:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750248529; cv=none; b=qIpEUoadphjd1X15yirXrReayVcpE7CJ+7RWRLtinmWfIJ2EL/CSLvV2GzqfIAjrs3zhRorVj6F7o7FOgP+E3THc2UNk/PYi4jK1yEXPrF/h4Z31W0oEeJgioev27alLouuwhjq9+N50o+x3tc1YVrwlXyBWtp0nzAF9sJJUiMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750248529; c=relaxed/simple;
	bh=9PvWQIN2DOiS+eGDpdKz3WgqnQceFcRO174Ih2hRwLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOvy3u1D6sdn6H4N9Xq6Fvo7x/kR03ngykLg9BV3luZfqgvf6Akn56TVC4qA4YTGB9pWFJ5vnu9sbFxtPRlHF1espGMiWTIRbs6oWS52OI11f3gkbPLDiM4cR2TiMttPBpwq6jiDhw+175Op0vlGcHNPIpqMsJeflZfr4r69ct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdxKBZ1v; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750248527; x=1781784527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9PvWQIN2DOiS+eGDpdKz3WgqnQceFcRO174Ih2hRwLI=;
  b=fdxKBZ1vEtPU149VgO+pr2p0Z20FozbKZ2v9uF4dvWkRxotbYsRIpc5M
   WLaoZG2iLFiofj1VAwttblw5YMJeMmciGmJPcIPUvcqmjGFyZjckVBNFQ
   gBSfyWAOhixKswoBMi24MBBEnU/Rkoem1PtRWg5MKVp8BVc9CVzP9Y5Ka
   2/F0N63poVP3sZA+Q1wQzmFIuBV1sF6dhGxMflqXU3yuIQEaBEwkqFXVd
   TMHc46rlUBmyrIEAG2J8t+xUjVCJu8230nZMIzkmMOgY1IrBMm65BDCQP
   7W7z1LzdbT471+zasY+/OsBOhIUiNCNUbjhnUA1/vYBP/Pb17kY+oFCUm
   g==;
X-CSE-ConnectionGUID: 51U2Xs1xSFawIURNWLH/Aw==
X-CSE-MsgGUID: 13aPbU5ZRi2P5DrfRxJk7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="77869043"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="77869043"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:46 -0700
X-CSE-ConnectionGUID: 8svx1IzZSXisrWdvIDRz7A==
X-CSE-MsgGUID: HxAOmSDzQhC4iTG0+KT5Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154213206"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.234])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:39 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Tony Luck <tony.luck@intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com
Cc: vannapurve@google.com,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-edac@vger.kernel.org,
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
Subject: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Date: Wed, 18 Jun 2025 15:08:06 +0300
Message-ID: <20250618120806.113884-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250618120806.113884-1-adrian.hunter@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

Skip clearing a private page if it is marked as poisoned.

The machine check architecture may have the capability to recover from
memory corruption in SEAM non-root (i.e. TDX VM guest) mode.  In that
case the page is marked as poisoned, and the TDX Module puts the TDX VM
into a FATAL error state where the only operation permitted is to tear it
down.

During tear down, reclaimed pages are cleared which, in some cases,  helps
to avoid integrity violation or TD bit mismatch detection when later being
read using a shared HKID.

However a poisoned page will never be allocated again, so clearing is not
necessary, and in any case poisoned pages should not be touched.

Note that while it is possible that memory corruption arises from integrity
violation which could be cleared by MOVDIR64B, that is not necessarily the
cause of the machine check.

Suggested-by: Kai Huang <kai.huang@intel.com>
Fixes: 8d032b683c299 ("KVM: TDX: create/destroy VM structure")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 457f91b95147..f4263f7a3924 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -282,10 +282,10 @@ static void tdx_clear_page(struct page *page)
 	void *dest = page_to_virt(page);
 	unsigned long i;
 
-	/*
-	 * The page could have been poisoned.  MOVDIR64B also clears
-	 * the poison bit so the kernel can safely use the page again.
-	 */
+	/* Machine check handler may have poisoned the page */
+	if (PageHWPoison(page))
+		return;
+
 	for (i = 0; i < PAGE_SIZE; i += 64)
 		movdir64b(dest + i, zero_page);
 	/*
-- 
2.48.1


