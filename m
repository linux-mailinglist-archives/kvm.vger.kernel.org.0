Return-Path: <kvm+bounces-15705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E708AF5B1
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 19:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A45211C24500
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 17:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C59E143864;
	Tue, 23 Apr 2024 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1O3QXxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AE4142E8A;
	Tue, 23 Apr 2024 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893819; cv=none; b=GiasdAVOp+9VfECtUhm1WF1QxF7TU/KEEFvO8l9FIUvbACUrCTTEOQa5SFgFCnJMoRJ5ALIypq3wztWytw0t6Tk72qTKVHZYNLBnQZzgZtllF48Ai0V5/xdgZht5hBwoCkABsE30CMvyrqJFWFORllVTxO7UwBcowtWWR5kTrvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893819; c=relaxed/simple;
	bh=MGqiHDPtZsSCXG8bvNCAhgbi77LAhqnLcPki4bnuNV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=REXRHnaXNoy4GyxbmUmT2gYnnU/RPE9nVixOKgzBZWOSIrqFj5QbjYfv2JEOSN905gMC6zMB8wmgORKYz5SIdM+I0AFo2Cu7yctLDigzrCX7mhUuj8IcvrXK30axBLFp+wREKuvt1WyOJeaYtLYTQk2qRAlIh3igT24W38oIg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1O3QXxq; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713893818; x=1745429818;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MGqiHDPtZsSCXG8bvNCAhgbi77LAhqnLcPki4bnuNV8=;
  b=V1O3QXxqfMxTqRnmRSyQZ6qsSzqYPOotASIop8b+I5Vv7i36IgCFr4AR
   sQrrZ0H702EHzAMaNFizLDzB60XechOxO/mQJSqTJFn5EA6UUgo8szo1X
   hPmnhDxOYGvBat5AxEYbqrOaIfNwJAgtzHp5cF2tSu552HkMdQX9M/kCL
   AxG8JTv1LVHr1mW35dtClbuR+ZbAN7T89myh9pFxfiJix98ojLUEJHzR6
   cTSTtfPS+opbZ0yK93Qjhadsr+AYQeRv5VU89/CMoIp709xoNEPB/aKAJ
   GucbI1cbWbKdj0RIaMZ0Aaajpf3AoxGqVyMMc38S2D5y32bCIxFrNTgID
   w==;
X-CSE-ConnectionGUID: er/uk0uTRKmCqA5ghPs/Pw==
X-CSE-MsgGUID: fzj9G/+DREaZXV+cLjVM7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9712505"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9712505"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:36:47 -0700
X-CSE-ConnectionGUID: 2MIRNS+kTeip0/SWWPNZhw==
X-CSE-MsgGUID: jmxyX6T1Tlu94EczzQJ3SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29097460"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 23 Apr 2024 10:36:45 -0700
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
	oliver.sang@intel.com,
	acme@kernel.org,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3  10/12] x86/irq: Extend checks for pending vectors to posted interrupts
Date: Tue, 23 Apr 2024 10:41:12 -0700
Message-Id: <20240423174114.526704-11-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
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
							done;*
						else
6							send a notification ->

* ON: outstanding notification, 1 will suppress new notifications

If the affinity change happens between 3 and 5 in IOMMU, the old CPU's posted
interrupt request (PIR) could have pending bit set for the vector being moved.

This patch adds a helper function to check individual vector status.
Then use the helper to check for pending interrupts on the source CPU's
PID.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v3: Fix a stray letter in the comment, no code change
v2: Fold in helper function patch.
---
 arch/x86/include/asm/apic.h        |  3 ++-
 arch/x86/include/asm/posted_intr.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 50f9781fa3ed..5644c396713e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -14,6 +14,7 @@
 #include <asm/msr.h>
 #include <asm/hardirq.h>
 #include <asm/io.h>
+#include <asm/posted_intr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -508,7 +509,7 @@ static inline bool is_vector_pending(unsigned int vector)
 	if (irr  & (1 << (vector % 32)))
 		return true;
 
-	return false;
+	return pi_pending_this_cpu(vector);
 }
 
 /*
diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index 6f84f6739d99..de788b400fba 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _X86_POSTED_INTR_H
 #define _X86_POSTED_INTR_H
+#include <asm/irq_vectors.h>
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
@@ -92,8 +93,25 @@ static inline void __pi_clear_sn(struct pi_desc *pi_desc)
 }
 
 #ifdef CONFIG_X86_POSTED_MSI
+/*
+ * Not all external vectors are subject to interrupt remapping, e.g. IOMMU's
+ * own interrupts. Here we do not distinguish them since those vector bits in
+ * PIR will always be zero.
+ */
+static inline bool pi_pending_this_cpu(unsigned int vector)
+{
+	struct pi_desc *pid = this_cpu_ptr(&posted_msi_pi_desc);
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


