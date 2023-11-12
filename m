Return-Path: <kvm+bounces-1526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3791E7E8E31
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8375DB209E4
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E066F79F1;
	Sun, 12 Nov 2023 04:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FgMV0xSW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF61FCE
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:12 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0482830EB;
	Sat, 11 Nov 2023 20:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762330; x=1731298330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KgNwZKlEknUh48ho6jIqFjsi+lR3uCezgczS6gTj3Dk=;
  b=FgMV0xSWXOakTmNh32PJv5YQtta8fgkAGPAvci5uzJH1fRuR2OhxVzij
   rrfDI6sjDjDe2o4lynHhD70o8B1C7ZGPEiOazFTSRihh5vBH9dZbCps6y
   htg2rjH7sl/PZ6+hargAlZzwFNw8V7jax1QNMlrlKatiWp0PfweWNmZvX
   rLRFDOSOw6+lzb9p7+XPbpOdt4jFyjs7Qb2M3gEQL5U2EwquIRiK2zSSr
   T3a5ZQnR6vuMk9v4vJq6fUnIx+x8mPz5oPFrLZwXoaVhzeop6z4Tc7m1n
   oyYI+syGHpeltHbW8GZZ1df17ZVz5UN5Qb9j1CNLj4FOaw/HdxgEkMv1K
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533894"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533894"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936754"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936754"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:08 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	peterz@infradead.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH RFC 06/13] x86/irq: Unionize PID.PIR for 64bit access w/o casting
Date: Sat, 11 Nov 2023 20:16:36 -0800
Message-Id: <20231112041643.2868316-7-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make PIR field into u64 such that atomic xchg64 can be used without ugly
casting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index 2cd9ac1af835..3af00f5395e4 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -9,7 +9,10 @@
 
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
-	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		u32 pir[8];     /* Posted interrupt requested */
+		u64 pir_l[4];
+	};
 	union {
 		struct {
 				/* bit 256 - Outstanding Notification */
-- 
2.25.1


