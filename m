Return-Path: <kvm+bounces-7246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0730883E706
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F3B1C2530C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F165B5BA;
	Fri, 26 Jan 2024 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f6vqIDvl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140E95915C;
	Fri, 26 Jan 2024 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312245; cv=none; b=Z0NHwntXMf30RBTtZr6Pa6g1WQUazRIGJK4g+gWohPkCvGOz/Kwn8JWhL4BOwg10sJ2a+RV35NmOFlukLmD21px+SUZ8dYg4ofht81qngAKrbdaTAxzTsrJbncGd7Yl2jPOK3aL3SFwNbSkYh3YZvgzOpER16AMFSkXw606uLno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312245; c=relaxed/simple;
	bh=/Fp/FdRCU1EQNKKT7uYQEIyHFwY63ZnDL0vny89H1Xg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VCCXGY4XdQ6iYFhyWeXy4/OGW5ni34LixwDSaJC0OlUGQmq0ejEWK985SNOA3aUkg/+32YkgVk/x2aoJf9L2tBvKQDoodgsyHgtbWL1zks0s/8ShQokFhuUEwfESTsb+Gj8cJ1YGfFz0dRrnnOBG0UhAhuzAyUekPs7laqudVeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f6vqIDvl; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312244; x=1737848244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Fp/FdRCU1EQNKKT7uYQEIyHFwY63ZnDL0vny89H1Xg=;
  b=f6vqIDvl2sr1zLH9K5cYsB1cIBYqZajZXAv3W08rC/KjVF0kVaKZaGDL
   huYWEgCT6eVOrP2fEi6sqXhDsdR9f9tABDK6vzA8N1Z28IZQkNDwNU/+H
   cHcG8BfftYZ64lWCbpupNiC9l3GlB52Zz3n/L/JqMFYO7bkfVcvrx+1Oj
   A7p0xLcu+mVyFFOU5epSChTk4Df0cusWFzJlGHC5wEldBEihiiPxCGsvJ
   CmZlFuAUmLOWjW6EQQhfx6Lh0m/Y27aS+ixUetizLJ86asLYfzynwQSPv
   7AbcgeWH9UL+pPTeHNK0e/7MTVT75jSo/lW1qrPoq67v1kxKkOwVYG3WT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990656"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990656"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290714"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290714"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:20 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 03/15] x86/irq: Use bitfields exclusively in posted interrupt descriptor
Date: Fri, 26 Jan 2024 15:42:25 -0800
Message-Id: <20240126234237.547278-4-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

Mixture of bitfields and types is weird and really not intuitive, remove
types and use bitfields exclusively.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index acf237b2882e..896b3462f3dd 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -16,17 +16,17 @@ struct pi_desc {
 	union {
 		struct {
 				/* bit 256 - Outstanding Notification */
-			u16	on	: 1,
+			u64	on	:  1,
 				/* bit 257 - Suppress Notification */
-				sn	: 1,
+				sn	:  1,
 				/* bit 271:258 - Reserved */
-				rsvd_1	: 14;
+					: 14,
 				/* bit 279:272 - Notification Vector */
-			u8	nv;
+				nv	:  8,
 				/* bit 287:280 - Reserved */
-			u8	rsvd_2;
+					:  8,
 				/* bit 319:288 - Notification Destination */
-			u32	ndst;
+				ndst	: 32;
 		};
 		u64 control;
 	};
-- 
2.25.1


