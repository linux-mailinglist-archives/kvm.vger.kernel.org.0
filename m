Return-Path: <kvm+bounces-13761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130FF89A733
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C144B2851F4
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF7E17995F;
	Fri,  5 Apr 2024 22:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QeavWFWh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A90D1791F7;
	Fri,  5 Apr 2024 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356014; cv=none; b=LvgOHxLxVf2vkf8EBdNt+J2PUcjB4aWpiWqFu7mgE2qSOXJxgGP2KMYwlgf4PgQkytqKFZIhygZd7Z83geaN8zBxvLz8gQlkRg9l8qwsaK3WHlpOen5nyLFdjBzQLcugeQUTdc7FNJxz2soVGvfK0or1whBbIFgqPWzmLXwPJpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356014; c=relaxed/simple;
	bh=H0TGjg1UoYwF5qFJJyPYA+APS27Sn0hasVdnhJ92ypQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oK6K6b4OkYZO/W4DU4xO+15EIY0LgbHH7yJKkfA098fSOofWQ289/U9nTdTazGd9DDaGiyNih0ICQo+ddPFZzpCosb+lRBIg/N2hEw4/htkhswi98pt/Q461uhsmkbq6xqY6rmJNr6uqYAudGDrAaGbRX960XxoJAqvLeLWTpRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QeavWFWh; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356013; x=1743892013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H0TGjg1UoYwF5qFJJyPYA+APS27Sn0hasVdnhJ92ypQ=;
  b=QeavWFWhHaPj/eIADbbRVVKA04Q5MQRzVTBrctUalAaf8KqYBVWLS/R9
   o00G2EdagukR8oLZAXhU/iY5vUM9lggWBzNRZDWjxKxoCOATMkv7diilQ
   P736B2chKmioLiBrjD9B52zDYD0yRfeIEnEg5fEeXeRHeUQvwY/EM332B
   r4AL1mlzfUA3rESHhZIMVbt4u7Xt+pAqeAMgpJIsJTF0b9r5WJIKXMDHQ
   Z900qvIR7z9/yBWK/wr3o1QqZJbRhpDeN15gLZusaj+ELd7PhKezPAizu
   avH924j+vGalA8+tDgI64ro7QC847cIcXQOfnG+AIEWOaiMIrW22EkHD3
   g==;
X-CSE-ConnectionGUID: isRSDQQzTqyXWvrNNpYGow==
X-CSE-MsgGUID: ZZ03KpwnSL+0nE5pZJYBMw==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062806"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062806"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:52 -0700
X-CSE-ConnectionGUID: CcfzkElUSke4mF1BjCAwnw==
X-CSE-MsgGUID: Zz+SdyguRFaEXm2dCFFyfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928336"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:50 -0700
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
Subject: [PATCH v2 10/13] x86/irq: Extend checks for pending vectors to posted interrupts
Date: Fri,  5 Apr 2024 15:31:07 -0700
Message-Id: <20240405223110.1609888-11-jacob.jun.pan@linux.intel.com>
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

This patch adds a helper function to check individual vector status.
Then use the helper to check for pending interrupts on the source CPU's
PID.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v2: Fold in helper function patch.
---
 arch/x86/include/asm/apic.h        |  3 ++-
 arch/x86/include/asm/posted_intr.h | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index ebf80718912d..5bf0d6c2523b 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -13,6 +13,7 @@
 #include <asm/mpspec.h>
 #include <asm/msr.h>
 #include <asm/hardirq.h>
+#include <asm/posted_intr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -507,7 +508,7 @@ static inline bool is_vector_pending(unsigned int vector)
 	if (irr  & (1 << (vector % 32)))
 		return true;
 
-	return false;
+	return pi_pending_this_cpu(vector);
 }
 
 /*
diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
index 4e5eea2d20e0..8aaa15515490 100644
--- a/arch/x86/include/asm/posted_intr.h
+++ b/arch/x86/include/asm/posted_intr.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _X86_POSTED_INTR_H
 #define _X86_POSTED_INTR_H
+#include <asm/irq_vectors.h>
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
@@ -81,9 +82,26 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
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


