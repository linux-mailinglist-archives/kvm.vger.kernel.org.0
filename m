Return-Path: <kvm+bounces-13752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D089A722
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3670B2140A
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB601176FB3;
	Fri,  5 Apr 2024 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XokvInM3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D58174EF6;
	Fri,  5 Apr 2024 22:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356008; cv=none; b=r9t6nxOxgyqEXB8UvK1TijLH+IeDduj4JmIS1YAW6DPvLzIuo3DbV8uyArIB2uezOqb4aALt53xKLBoqTwpFa+3LWJpHbn8YoqEgclWNex4FlpipfGnn0wZAq3lpcD8QnbLYTSflryBlStQdq/zQLNpAPu3LRPwPQIx4Hi8r0Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356008; c=relaxed/simple;
	bh=Bh8qAq471IuQbwA8oP4ru9wTknH7iKls9mGK6YcKMpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJxNMfu7Ns5WvN23yDi831au4MUupMC8+v8GPszZMBS3SJMSCwgdOU19zROFowumWDERahQRM79LfDnFvFJi0HiFJEvScDQ8dMtIHBhk4T2VbPRS8oI6pT120JcXTBmkXlB5u7wfr59CMGdqm2q37lt8sC0Nab+p8g1N5E9ze4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XokvInM3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356007; x=1743892007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bh8qAq471IuQbwA8oP4ru9wTknH7iKls9mGK6YcKMpg=;
  b=XokvInM3RIiZ1dEeTQuqOZzUL1b12Wcxlq7cvJjDHqfROV6SRgV8GWJM
   iV9ccygx8BOSsH0hYWfC7i17b+1c84QuCozKsM7PuuvY/ICB3qtjn3+bS
   PTBDU7SCFIqcp30NwovbEnuAHFEbIzrXyYyZyCUcpVl2FyUaUG1GyGVhq
   yBwv8TQ6CU7pd2eGdrMVW4YdjqMmG8EH5xqhrfpdGGA8oCly/vsQ2NN3P
   N6oo0Gmx7GhHtXHARC6VMGFESGS8V9Akks8kGrW6D/H3SRGIyA4nh78c5
   Gwf3lwrABEz9gWCNSLNSI62qNd1HAs4pRu/U6vXuc1sY2SLHrfWtnUbt9
   g==;
X-CSE-ConnectionGUID: 1CfHmgnzRKWhUTCBWNuuww==
X-CSE-MsgGUID: ZS9969qVRk6mQmqmdJfP5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062669"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062669"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:45 -0700
X-CSE-ConnectionGUID: cPYrfhevQh+UdDZtipl+Cg==
X-CSE-MsgGUID: jc3lcFRGSWyLv6aWkzfreA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928308"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:44 -0700
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
Subject: [PATCH v2 01/13] x86/irq: Move posted interrupt descriptor out of vmx code
Date: Fri,  5 Apr 2024 15:30:58 -0700
Message-Id: <20240405223110.1609888-2-jacob.jun.pan@linux.intel.com>
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

To prepare native usage of posted interrupt, move PID declaration out of
VMX code such that they can be shared.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/posted_intr.h | 88 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/posted_intr.h     | 93 +-----------------------------
 arch/x86/kvm/vmx/vmx.c             |  1 +
 arch/x86/kvm/vmx/vmx.h             |  2 +-
 4 files changed, 91 insertions(+), 93 deletions(-)
 create mode 100644 arch/x86/include/asm/posted_intr.h

diff --git a/arch/x86/include/asm/posted_intr.h b/arch/x86/include/asm/posted_intr.h
new file mode 100644
index 000000000000..f0324c56f7af
--- /dev/null
+++ b/arch/x86/include/asm/posted_intr.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_POSTED_INTR_H
+#define _X86_POSTED_INTR_H
+
+#define POSTED_INTR_ON  0
+#define POSTED_INTR_SN  1
+
+#define PID_TABLE_ENTRY_VALID 1
+
+/* Posted-Interrupt Descriptor */
+struct pi_desc {
+	u32 pir[8];     /* Posted interrupt requested */
+	union {
+		struct {
+				/* bit 256 - Outstanding Notification */
+			u16	on	: 1,
+				/* bit 257 - Suppress Notification */
+				sn	: 1,
+				/* bit 271:258 - Reserved */
+				rsvd_1	: 14;
+				/* bit 279:272 - Notification Vector */
+			u8	nv;
+				/* bit 287:280 - Reserved */
+			u8	rsvd_2;
+				/* bit 319:288 - Notification Destination */
+			u32	ndst;
+		};
+		u64 control;
+	};
+	u32 rsvd[6];
+} __aligned(64);
+
+static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
+{
+	return test_and_set_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
+{
+	return test_and_clear_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
+{
+	return test_and_clear_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
+{
+	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
+}
+
+static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
+{
+	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+}
+
+static inline void pi_set_sn(struct pi_desc *pi_desc)
+{
+	set_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_set_on(struct pi_desc *pi_desc)
+{
+	set_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_clear_on(struct pi_desc *pi_desc)
+{
+	clear_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline void pi_clear_sn(struct pi_desc *pi_desc)
+{
+	clear_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_on(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_ON, (unsigned long *)&pi_desc->control);
+}
+
+static inline bool pi_test_sn(struct pi_desc *pi_desc)
+{
+	return test_bit(POSTED_INTR_SN, (unsigned long *)&pi_desc->control);
+}
+
+#endif /* _X86_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 26992076552e..6b2a0226257e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -1,98 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __KVM_X86_VMX_POSTED_INTR_H
 #define __KVM_X86_VMX_POSTED_INTR_H
-
-#define POSTED_INTR_ON  0
-#define POSTED_INTR_SN  1
-
-#define PID_TABLE_ENTRY_VALID 1
-
-/* Posted-Interrupt Descriptor */
-struct pi_desc {
-	u32 pir[8];     /* Posted interrupt requested */
-	union {
-		struct {
-				/* bit 256 - Outstanding Notification */
-			u16	on	: 1,
-				/* bit 257 - Suppress Notification */
-				sn	: 1,
-				/* bit 271:258 - Reserved */
-				rsvd_1	: 14;
-				/* bit 279:272 - Notification Vector */
-			u8	nv;
-				/* bit 287:280 - Reserved */
-			u8	rsvd_2;
-				/* bit 319:288 - Notification Destination */
-			u32	ndst;
-		};
-		u64 control;
-	};
-	u32 rsvd[6];
-} __aligned(64);
-
-static inline bool pi_test_and_set_on(struct pi_desc *pi_desc)
-{
-	return test_and_set_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
-{
-	return test_and_clear_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_clear_sn(struct pi_desc *pi_desc)
-{
-	return test_and_clear_bit(POSTED_INTR_SN,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
-{
-	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
-}
-
-static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
-{
-	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
-}
-
-static inline void pi_set_sn(struct pi_desc *pi_desc)
-{
-	set_bit(POSTED_INTR_SN,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_set_on(struct pi_desc *pi_desc)
-{
-	set_bit(POSTED_INTR_ON,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_clear_on(struct pi_desc *pi_desc)
-{
-	clear_bit(POSTED_INTR_ON,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline void pi_clear_sn(struct pi_desc *pi_desc)
-{
-	clear_bit(POSTED_INTR_SN,
-		(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_on(struct pi_desc *pi_desc)
-{
-	return test_bit(POSTED_INTR_ON,
-			(unsigned long *)&pi_desc->control);
-}
-
-static inline bool pi_test_sn(struct pi_desc *pi_desc)
-{
-	return test_bit(POSTED_INTR_SN,
-			(unsigned long *)&pi_desc->control);
-}
+#include <asm/posted_intr.h>
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c37a89eda90f..d94bb069bac9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -70,6 +70,7 @@
 #include "x86.h"
 #include "smm.h"
 #include "vmx_onhyperv.h"
+#include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..e133e8077e6d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -7,10 +7,10 @@
 #include <asm/kvm.h>
 #include <asm/intel_pt.h>
 #include <asm/perf_event.h>
+#include <asm/posted_intr.h>
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
-#include "posted_intr.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
-- 
2.25.1


