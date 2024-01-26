Return-Path: <kvm+bounces-7254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE3A83E718
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7792B1F28274
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B1B60DDA;
	Fri, 26 Jan 2024 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J/DZw0zL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07F260267;
	Fri, 26 Jan 2024 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312251; cv=none; b=C1Z04LhT0KNOJCILdgUk+ZmF7pQwH5c97oX7SeBOfGZ/CVbrrFRUJlRfFvmMV6hy2nkpyZ/KFzZZhNUGmsgGqX15CqewV0MUV+MGXmIiXAFz2ufqzSc9abVy73zupz19Qb+TpRMnDLvlx4c5xGXFslbZ44tZsLB8nbCqENGKwUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312251; c=relaxed/simple;
	bh=6ZuNeLIEAeBdSx49wXWrTgYdLXjN/iAwcc2wy4sRSo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mw3EGsON8JSXs6LuhJi92CFKse9jInHBYHULy+CsJsLZh0D+lxlKUAPsY//quT334vbI7fFzJGXRpm3ko/QKN3zYhQnjhzSG4e4qvUorhnxiGyury3N4hH9PzAqDgxn7o3D6TJPOm0fjuPi24QaB5GwHpbAbgEH4U8EfzBamiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J/DZw0zL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312250; x=1737848250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ZuNeLIEAeBdSx49wXWrTgYdLXjN/iAwcc2wy4sRSo0=;
  b=J/DZw0zLgz6bSzhcUX0kTWTJUbGmhwRtA/VZegDH0GrY5oKqaOjPET7U
   5mNlLRNwsXq5AUS4+Rv6GkN7FLtA6i133znDY5mzAaaSmE5rQ7+4NvwGj
   626TkMc6S8xsHzT723QFAGmAcKD89nVx4CKdudg43mDUqZvj4qrBdVmXb
   a2BVWW358vuyzy09e0eIPL5YYXOzK19BzoKvgjuYAeBnMdi2G8+91nHQq
   B1WotXMkwj2lM6qRZzx8u/bsQ1mxO/sPfYlSEwcMx/ClXmvOKSt2kxzzD
   lOhlV6dRglDWXAEvqE+UzC/Tx83D29+PwECRZO5IT+B0hRaEXJXxnnUWv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990744"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990744"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290742"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290742"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:22 -0800
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
Subject: [PATCH 10/15] x86/irq: Factor out common code for checking pending interrupts
Date: Fri, 26 Jan 2024 15:42:32 -0800
Message-Id: <20240126234237.547278-11-jacob.jun.pan@linux.intel.com>
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

Use a common function for checking pending interrupt vector in APIC IRR
instead of duplicated open coding them.

Additional checks for posted MSI vectors can then be contained in this
function.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/apic.h   | 11 +++++++++++
 arch/x86/kernel/apic/vector.c |  5 ++---
 arch/x86/kernel/irq.c         |  5 ++---
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9d159b771dc8..e9d8e554765c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -492,6 +492,17 @@ static inline bool lapic_vector_set_in_irr(unsigned int vector)
 	return !!(irr & (1U << (vector % 32)));
 }
 
+static inline bool is_vector_pending(unsigned int vector)
+{
+	unsigned int irr;
+
+	irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+	if (irr  & (1 << (vector % 32)))
+		return true;
+
+	return false;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 185738c72766..9eec52925fa3 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -965,7 +965,7 @@ static void __vector_cleanup(struct vector_cleanup *cl, bool check_irr)
 	lockdep_assert_held(&vector_lock);
 
 	hlist_for_each_entry_safe(apicd, tmp, &cl->head, clist) {
-		unsigned int irr, vector = apicd->prev_vector;
+		unsigned int vector = apicd->prev_vector;
 
 		/*
 		 * Paranoia: Check if the vector that needs to be cleaned
@@ -979,8 +979,7 @@ static void __vector_cleanup(struct vector_cleanup *cl, bool check_irr)
 		 * fixup_irqs() was just called to scan IRR for set bits and
 		 * forward them to new destination CPUs via IPIs.
 		 */
-		irr = check_irr ? apic_read(APIC_IRR + (vector / 32 * 0x10)) : 0;
-		if (irr & (1U << (vector % 32))) {
+		if (check_irr && is_vector_pending(vector)) {
 			pr_warn_once("Moved interrupt pending in old target APIC %u\n", apicd->irq);
 			rearm = true;
 			continue;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 54ddf148f1ed..8e09d40ea928 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -472,7 +472,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
 {
-	unsigned int irr, vector;
+	unsigned int vector;
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
@@ -499,8 +499,7 @@ void fixup_irqs(void)
 		if (IS_ERR_OR_NULL(__this_cpu_read(vector_irq[vector])))
 			continue;
 
-		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
-		if (irr  & (1 << (vector % 32))) {
+		if (is_vector_pending(vector)) {
 			desc = __this_cpu_read(vector_irq[vector]);
 
 			raw_spin_lock(&desc->lock);
-- 
2.25.1


