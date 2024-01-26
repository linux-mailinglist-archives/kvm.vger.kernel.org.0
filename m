Return-Path: <kvm+bounces-7244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0166D83E704
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94E411F25E6C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDED5A7B6;
	Fri, 26 Jan 2024 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVFqwKBB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F0758AD6;
	Fri, 26 Jan 2024 23:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312245; cv=none; b=XFvZQCSTXI0vaPSvBzbsGpZjSWghmBVCCdxvSeQ5J6um3oHc1arV77OXyHSURj1ErTHg3dhAbF0Elr/N+m7NEKkgUdL8dPKPdWxX+lxOz/EY7lg4RwJMTc8GbfhDuPcNwWcP58EdPZLy6B2pvQ2eB5j4eftZ+QA3n3o03a7yWO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312245; c=relaxed/simple;
	bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cIU3Zw3CDMIqCtNAT88WQ1Rg63mwfQ2AvyeT3ZLMCcjelurM/dv2QaabmQxlvezeeVIY9UbgDRDhwfElzDasnxYvniFZcU3HZVxkDIC6dAvDigBkOfM3qC56M2STPEGhFkoEhNDuvKkbAQQF5WLd7WaL/D2LL9nQjCz2lOfiQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVFqwKBB; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312243; x=1737848243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
  b=UVFqwKBB0HHHM9yNjwsGDBn92Q0uNqj5NO+RtPvV59UwG/ppJD9qsHCZ
   AeCs2B8PaiBdqLQ/7O3/i79EXDqXRPSM4aiH+apvYkeiagetMx5yiK4ly
   uHXOQI8hT+lwcJ3xRGuYveePVg3YUd01nSTSPJ0Fk6ZK26gsYVFwf601K
   4yGmcQJrswKXkTA5KHKxxfjebgmoIgxs3yPhothIsxXCdzPvVb0bguShk
   EC0oOAENuG4t5BMlnTuCM5XA+RCYgOj2zksaoVX/1BRNYq7C/CWTlwydf
   KPyF/h3IS7pwSNqJgmAyqY9gM6jBCot3o4Gm26x4hEMOZSvwNMjHNlJoI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990643"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990643"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290711"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290711"
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
Subject: [PATCH 02/15] x86/irq: Unionize PID.PIR for 64bit access w/o casting
Date: Fri, 26 Jan 2024 15:42:24 -0800
Message-Id: <20240126234237.547278-3-jacob.jun.pan@linux.intel.com>
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

Make PIR field into u64 such that atomic xchg64 can be used without ugly
casting.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index f0324c56f7af..acf237b2882e 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -9,7 +9,10 @@
 
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
-	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		u32 pir[8];     /* Posted interrupt requested */
+		u64 pir64[4];
+	};
 	union {
 		struct {
 				/* bit 256 - Outstanding Notification */
-- 
2.25.1


