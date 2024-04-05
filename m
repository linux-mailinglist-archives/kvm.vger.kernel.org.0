Return-Path: <kvm+bounces-13754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72C9689A726
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28CE71F2222D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23BD177984;
	Fri,  5 Apr 2024 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvbgW2Lp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B5717555B;
	Fri,  5 Apr 2024 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356009; cv=none; b=q+RyzbgJM/bfqf+0uKWVLLxOp6yo15jh71HFgLbVwCVV9Ljll1DMC3e6KwyjOyYIZvsVtxoIAdcUqvIhaI/6q7e/KVd5Aadn5LPYZzNhQCgSRwVw3kfVyKRTyUQVCCQej4260tBoIOR2ZTWteLbDoZRxTa8Qg3Y9BGS/y3aY79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356009; c=relaxed/simple;
	bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g+miIwR3EVi7afTLA/MXfNisdILhGWzhkpx6bN8GWngh/p9fbNlKGreoo1PcTaUmHsvaoIU93ONxXchHg3vrznEuO/78fV4NUDcID0YY/bFJAqPR17XTU33s7mZBqcHFMvn/FhjR9N6/QdP9kwBss8tg4UV0enmjab3FXgFuURE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IvbgW2Lp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356008; x=1743892008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GX8HhoSt+Bowm5iZvkwyHIzLD8tLG+XNrU90AlqK/Q=;
  b=IvbgW2LpmEB0sRGfKRTG2zfSi3ceSoQKRgK22yTUdWsrxiX22Z6gURcg
   Vyh4xPbZAoVazQaLSW+WoZPpxqL8vpKchBs3YLTYJZxA4Dn394xIHgZau
   nehysJJcBLlZGTJKw2FjVnhH1YMjRkF+pAU8g86fuQBTYblJo5ih/tixO
   RVScWMnl1H99snuKwaLKocZxMGaU9GNgDzltS/qqPB+mS5iazqA9OHuzw
   3v4pFxnSdYFVXvDx8Ze2OOzM2VtWEFzE/5N31mAMNT8lXrmrYPzbKPBvY
   5ECr2cFj20dhwnACsZT03nd4zWSEZTLMbQGgSLZYXJ1f7cD35Fkra72xL
   Q==;
X-CSE-ConnectionGUID: 7Yhc0KWzTtWstoOCJbDCMw==
X-CSE-MsgGUID: RSAoS6FIQxeMa74FDlKMGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062684"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062684"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:46 -0700
X-CSE-ConnectionGUID: 0z4oK8SVSReyiQmluJIm4g==
X-CSE-MsgGUID: bs4BYb9qQQSpBWes3fTEKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928311"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:45 -0700
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
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 02/13] x86/irq: Unionize PID.PIR for 64bit access w/o casting
Date: Fri,  5 Apr 2024 15:30:59 -0700
Message-Id: <20240405223110.1609888-3-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
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


