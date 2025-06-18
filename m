Return-Path: <kvm+bounces-49869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C8BADEB7F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 492B540122D
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3024E2DFF3E;
	Wed, 18 Jun 2025 12:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="beVw8WfY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90092DBF45;
	Wed, 18 Jun 2025 12:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750248587; cv=none; b=F8NkscKF1e1glcsoO+SDuEjbWunJgxhL4x6rRgh1FgbTF4COuU7hgQTJs5srjIrS4+3XIYAx03nfvpl8hBZOGDsQvAUkbOJHtM6W1Xs3pLPHK+2FHLOdNHzL5ER/yADSTBqLtgVpFxISAqgYwJrNAvd+fRMerTVRL89Ut4tjvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750248587; c=relaxed/simple;
	bh=xOXdFzt/cGAT7EXDjHSOYuUckW3uOERT1XUKP0JE6is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyWXeT2t5NTYrlTSoigdGQcPG7P2jpNJHCcrE0RnD4rW4SGiI3oiOak1SioCDf6GxM3lQ3UwYB9WShdZy4dWF2SlkzY3nC5n8jhOLOjOdaPbom393US4/S5iMApN7l7dmAucwv93EOaNP8+HGTPpKXjQgwTITeelfDim10sA800=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=beVw8WfY; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750248586; x=1781784586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xOXdFzt/cGAT7EXDjHSOYuUckW3uOERT1XUKP0JE6is=;
  b=beVw8WfYa8QJ/8jTkiz40MEdLDBXhZEKmQ5YMxYXN+oN64zYFoybP8r1
   Xb8m5nZXT7PSzdFGq68P0bWu3VZptkjHHXMlWsr6oMmJak27S9YliUZwW
   w8chi3AWKHRXsEejf5/sESyCwzaNaziHh45FMwrJgRMkmasXVtL6gJQ4o
   aRCS3cDOgTgNQzupbslx/EBc//WlbnNryaojGDl9CoOIpgkC4fT2oo9ZX
   AwMHUUqBY2ZR6OE7HaFTsntWK80UeV41OyEcn9Q09Vvp11FQkxIF9gjqe
   +CqjrMkEfmIysQxcFsn2VPwUVMFb0Q/601+ZVeM8fCch/HveLL0OjJzlU
   A==;
X-CSE-ConnectionGUID: 5xodWU7WQfi7/b1xLA7Pxg==
X-CSE-MsgGUID: Hiqle2aLSpazXXjpZg/lkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="77869036"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="77869036"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:40 -0700
X-CSE-ConnectionGUID: fxVCo2r8T4yCHA//tSlYFQ==
X-CSE-MsgGUID: /+InbJlTT3G0GDvnBDVyrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154213127"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.245.234])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:08:33 -0700
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
Subject: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for errors in TDX/SEAM non-root mode
Date: Wed, 18 Jun 2025 15:08:05 +0300
Message-ID: <20250618120806.113884-2-adrian.hunter@intel.com>
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

Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
valid physical address bits within the machine check bank address register.

This is particularly needed in the case of errors in TDX/SEAM non-root mode
because the reported address contains the TDX KeyID.  Refer to TDX and
TME-MK documentation for more information about KeyIDs.

Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
non-root mode") uses the address to mark the affected page as poisoned, but
omits to use the aforementioned mask.

Mask the address with MCI_ADDR_PHYSADDR so that the page can be found.

Fixes: 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM non-root mode")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/kernel/cpu/mce/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index e9b3c5d4a52e..76c4634c6a5f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1665,7 +1665,8 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		 * be added to free list when the guest is terminated.
 		 */
 		if (mce_usable_address(m)) {
-			struct page *p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
+			unsigned long pfn = (m->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+			struct page *p = pfn_to_online_page(pfn);
 
 			if (p)
 				SetPageHWPoison(p);
-- 
2.48.1


