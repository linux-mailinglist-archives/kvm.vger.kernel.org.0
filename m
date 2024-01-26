Return-Path: <kvm+bounces-7250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B9A83E710
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 800822896C2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6073605B4;
	Fri, 26 Jan 2024 23:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J6tgjPIF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90365BAE7;
	Fri, 26 Jan 2024 23:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312249; cv=none; b=jFaVeGS+m5CDLgnuAYB3uJvAQedi6r61T+5tTNlqsQJ7f+WK8O43pM9xcZVSpHwdC0cHjYO8OohG1uHN5gtLfNMJvf1Q14i2vYGr3fAPTXpUVj0L5wZWTkJF9t4uAHJZKuVI/wV5i5aboHAJlUfs9B2m5/zDlQYqL3IdP62yc2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312249; c=relaxed/simple;
	bh=MqzYCPV34vdfoVMKAgtS0juqP6fLnnDqzn4F90K69Xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L9LIFjH97JfLrZeK47JqeCznRdwPI7D8SicVMdalyeL1P/RiOsfzpfMZKZY/uQrMa2Dm+bXne53fNPMkcxm30TBaE7hcQVWHUv5bGy7vBMtI979ZF1Gzl1yR6PdnCS2gd3b7xcX5YXUd7VIzyvpuVAQBXn2hhNAALPHwWS99twI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J6tgjPIF; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312248; x=1737848248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MqzYCPV34vdfoVMKAgtS0juqP6fLnnDqzn4F90K69Xk=;
  b=J6tgjPIFmZEEAu3lcIFffeQgtu8D++Cv4u8kZ853dPNWmQ6qxXQLXw+6
   vaTQjmtiWbw1/k8HsuDPk7ZeJKgWjslKaN8JWY7qQ2NzogM5XmBvgybx3
   BPXUuTYVd+60XLenrTBej+2Bb3DOy1jDBbbql2kW7q+RK4E5U1oeOOyhD
   hLCMg2HMjZEqP8oAl5tmFSuSDd4Q3Mlscy74P/nx05H8pCtEypadbKxGY
   RijMjjo22AdPN9RL9D1avMKJ2U9CeWyaqljl0njH9CR1GSP9owcJGpSBx
   /GCqIxlUIHjs5tR+wlDA/sa+EwsXcr77C9ikjTRQCEYNwO3Zt8IdYtUQM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990714"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990714"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290731"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290731"
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
Subject: [PATCH 07/15] x86/irq: Add accessors for posted interrupt descriptors
Date: Fri, 26 Jan 2024 15:42:29 -0800
Message-Id: <20240126234237.547278-8-jacob.jun.pan@linux.intel.com>
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

Posted interrupts are controlled by and pending interrupts are marked in
the posted interrupt descriptor. The upcoming support for host side posted
interrupts requires accessors to check for pending vectors.

This patch adds a helper function to check individual vector status.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index a36cc971ea13..eb939f630b02 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _X86_POSTED_INTR_H
 #define _X86_POSTED_INTR_H
+#include <asm/irq_vectors.h>
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
@@ -89,9 +90,26 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 }
 
 #ifdef CONFIG_X86_POSTED_MSI
+/*
+ * Not all external vectors are subject to interrupt remapping, e.g. IOMMU's
+ * own interrupts. Here we do not distinguish them since those vector bits in
+ * PIR will always be zero.
+ */
+static inline bool pi_pending_this_cpu(unsigned int vector)
+{
+	struct pi_desc *pid = this_cpu_ptr(&posted_interrupt_desc);
+
+	if (WARN_ON_ONCE(vector > NR_VECTORS || vector < FIRST_EXTERNAL_VECTOR))
+		return false;
+
+	return test_bit(vector, (unsigned long *)pid->pir);
+}
+
 extern void intel_posted_msi_init(void);
 
 #else
+static inline bool pi_pending_this_cpu(unsigned int vector) { return false; }
+
 static inline void intel_posted_msi_init(void) {};
 
 #endif /* X86_POSTED_MSI */
-- 
2.25.1


