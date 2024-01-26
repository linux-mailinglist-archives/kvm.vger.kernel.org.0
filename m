Return-Path: <kvm+bounces-7251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5A483E70F
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFB79B264F5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7E8605A6;
	Fri, 26 Jan 2024 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfxnOCn9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8615BADD;
	Fri, 26 Jan 2024 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312249; cv=none; b=mkEYgeOxhCD+v5tvuff4TpXJrlYZo8JLQPuAeR7LVcTQs0zae2G0fTIkRdZKDOiDp8SN9ls/uMBsJsTY7vLIEKe12I1CyaaTPjDrIyYzYIC57Q4Hg+JBadOE4fT2+KJS/xB10sQ452EzCJXLWqFUI9iXH0BOPHBwdxKHrfwawVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312249; c=relaxed/simple;
	bh=KVXuQfj6u+U1cGUQ3TC+vIVsCaW1LZRHuP8dLBZSJDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=odbM7rJ+qmhE2hLkULgEbVpHZyJc5zP+elEgVURpkCwvLJNVJFLUxGFf+aTLQFCpwxd84EMOn/80NlTnfkQ832c59qxDYiLYl/Y4UVqOhb25y6pxSpCU8tacY60KRuU5SG7IPYDfjKSAvvinNiMPzooisT1gD2C1KpNAjy2WCD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfxnOCn9; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312248; x=1737848248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KVXuQfj6u+U1cGUQ3TC+vIVsCaW1LZRHuP8dLBZSJDg=;
  b=ZfxnOCn9I4TNcSMm+NXVzWD7vVL1fw+gKUz1p5j4Kl68v/HRzgNSdK5x
   08/aSW894nMo6fWzfSxZl9tA3ioN2cUfn8TFEaQGpKfQuO6BtjeNv1P5w
   uiUGEQzIIPjRwwS0mHwHOJTPpLmlzjc+ZjAs2D4G1fbcwCb92qTCY/7aY
   nN3t0CRVNhL2/V9U+//IQct/P8t8HxCnRkfjJ7wTlxUAL/DGRYiO/Rpy6
   rRzrn8yZHbzW+perk5C4xVt8vv3a3oZNsTyB1sUttPYst1THIxZRdwJSO
   JXbNZF4lksDiuOfKMcQDregCGhjYc6vvNAUA6V5lX/kPdWlc5bYpOYqXh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990715"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990715"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290734"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290734"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:21 -0800
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
Subject: [PATCH 08/15] x86/irq: Factor out calling ISR from common_interrupt
Date: Fri, 26 Jan 2024 15:42:30 -0800
Message-Id: <20240126234237.547278-9-jacob.jun.pan@linux.intel.com>
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

Prepare for calling external IRQ handlers directly from the posted MSI
demultiplexing loop. Extract the common code with common interrupt to
avoid code duplication.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/irq.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index f6546f83d616..1a1762baf85f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -242,18 +242,10 @@ static __always_inline void handle_irq(struct irq_desc *desc,
 		__handle_irq(desc, regs);
 }
 
-/*
- * common_interrupt() handles all normal device IRQ's (the special SMP
- * cross-CPU interrupts have their own entry points).
- */
-DEFINE_IDTENTRY_IRQ(common_interrupt)
+static __always_inline void call_irq_handler(int vector, struct pt_regs *regs)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct irq_desc *desc;
 
-	/* entry code tells RCU that we're not quiescent.  Check it. */
-	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
-
 	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
@@ -268,7 +260,20 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 			__this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
 		}
 	}
+}
+
+/*
+ * common_interrupt() handles all normal device IRQ's (the special SMP
+ * cross-CPU interrupts have their own entry points).
+ */
+DEFINE_IDTENTRY_IRQ(common_interrupt)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/* entry code tells RCU that we're not quiescent.  Check it. */
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
 
+	call_irq_handler(vector, regs);
 	set_irq_regs(old_regs);
 }
 
-- 
2.25.1


