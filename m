Return-Path: <kvm+bounces-7253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5854F83E715
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:40:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC87F1F280F5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84A760DC1;
	Fri, 26 Jan 2024 23:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iaKSdoT7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BC560268;
	Fri, 26 Jan 2024 23:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312251; cv=none; b=MIoMveoadXWzrlXR4IHD861Ucqet4jUn8PDfO4+u2rMdJgY3VdaMz5Dj9O49eB7U0OPGQqRP4KxO7zQBqnmIzUFYnzgVLpcMOGvnhX0qPIX+nRzSzqaPiPj3HqIRWCUbZgcv3DRCBjnuAxijhzftXIXXYzKLIvHGGP2NHo/ART4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312251; c=relaxed/simple;
	bh=5z7HUBzE7Ul+Bci9YbfIrBXJxLaOXS9r2ggCh19e6Ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hWslVEJxlPWavH7xH9pm6qax6ENH5Dhh4EklWS+nVzJos465Eug+aGuCotEXR5icnpisuCRc1laA+m9VuDcOQI1R8+6qjT0KJx5lG+t+HN7W30neztvC/jzMmjRnEKTvvohriF8qYD9ocR0yD9ads5k2VrmbY5ZAFmg0/HoRYng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iaKSdoT7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312250; x=1737848250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5z7HUBzE7Ul+Bci9YbfIrBXJxLaOXS9r2ggCh19e6Ag=;
  b=iaKSdoT7f1BgjB9CyiKX5BC1FM6Up2YfHvVQNXGifwIO6UMS12E7P7Jr
   HAiHpFysaoD7/V/q0mcuopQwTu1A5yBQUesUBb4KW6kcFYhZYi/5OAJpv
   3SCVJee/97y9xq5fiTlbp1pwtoAlyAoA17yzNCpE6los58/pcDlOP35Mh
   ljNwB1HLbhBBaVXBfwd07fpffXHlap3hWJaQ2xgZl4btRkrdBGTFYbXsP
   wknz0fFYRWGEM7cbBWz+y+5jJ8tjNgoX8Ugtdy2tmABrd+krvbfwy/ppt
   /E9gvtgzaSu5thLCnD/5MTd8O9Grj/+PqIIwBFuzHIdr7PjGZ5Ap6E7E7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990760"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990760"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290745"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290745"
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
Subject: [PATCH 11/15] x86/irq: Extend checks for pending vectors to posted interrupts
Date: Fri, 26 Jan 2024 15:42:33 -0800
Message-Id: <20240126234237.547278-12-jacob.jun.pan@linux.intel.com>
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

During interrupt affinity change, it is possible to have interrupts delivered
to the old CPU after the affinity has changed to the new one. To prevent lost
interrupts, local APIC IRR is checked on the old CPU. Similar checks must be
done for posted MSIs given the same reason.

Consider the following scenario:
	Device		system agent		iommu		memory 		CPU/LAPIC
1	FEEX_XXXX
2			Interrupt request
3						Fetch IRTE	->
4						->Atomic Swap PID.PIR(vec)
						Push to Global Observable(GO)
5						if (ON*)
	i						done;*
						else
6							send a notification ->

* ON: outstanding notification, 1 will suppress new notifications

If the affinity change happens between 3 and 5 in IOMMU, the old CPU's posted
interrupt request (PIR) could have pending bit set for the vector being moved.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/apic.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e9d8e554765c..6661fefdd49a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -13,6 +13,7 @@
 #include <asm/mpspec.h>
 #include <asm/msr.h>
 #include <asm/hardirq.h>
+#include <asm/posted_intr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -500,7 +501,7 @@ static inline bool is_vector_pending(unsigned int vector)
 	if (irr  & (1 << (vector % 32)))
 		return true;
 
-	return false;
+	return pi_pending_this_cpu(vector);
 }
 
 /*
-- 
2.25.1


