Return-Path: <kvm+bounces-7245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4C583E707
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8383E285977
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9450D5B5C1;
	Fri, 26 Jan 2024 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kDt3zOO1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67EB5914E;
	Fri, 26 Jan 2024 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312245; cv=none; b=IlwzRLHrUNs5IUyWlyazOTJ8dQqOfUyyo4k7jDE3V5KxlFQl7F+pFUly4b2szxjx7l9X1im5WNAB9YqZkGLe+aqu3wizO6bvOQ94VWo5vtASmde7iO9GIj5xXXiAZNUziFm19p/Ol7jU9SvFeZmf88z64AWNXnUkjxycQ7dJzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312245; c=relaxed/simple;
	bh=zBgPFasqGZOjr8K1swC88xgZ1PNA6b0D2k/Kg52KNW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ThUVKNuxnSOU8FfLTLnVBEHS7ChtJLeW2p7FuE/psfST32mZqORknE+3uUAXLMUkgMaYeHgIB6Ho7tZOqq/no7JVwq8XEhbyLAuDAZuMSorfaIgQHQyVri+uBHm9RCu1qsez5RDEJ4dIq5HlXzzxE3UHW1r9LlKgk+y3yeQJucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kDt3zOO1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312244; x=1737848244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zBgPFasqGZOjr8K1swC88xgZ1PNA6b0D2k/Kg52KNW0=;
  b=kDt3zOO1pXD2HdzS6OZGdsWbv0gSfjOMTcs5P/bIXJUCRQeuVM6arC7j
   CGX/63b8lMvYI8bbFKRsbrzB5mMhG7m7ywS+GPZ55eEVFaovpW4JPWUsI
   BuVPo9QMgiOsNb86IwP5k3ZX7qliDUlTGtYM91gvTcci3tfweIuL/Ikfy
   +KZPjYYtLfrXSofkDOsKjxEUYH4LIOVmJuS74Zmyr/Vo0U1d77AqU9SiR
   A+35gDXRBueaoBqHXRXTlTNpsn9WYW8Fp6Qv8pXNxw3nSsFaaiBHLGzW6
   qyPhLHLgqe6TPY57Gdrzyh24sO9X7kDkORHCWRQCE3bv2bzD9q/l3J416
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990631"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990631"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290708"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290708"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:19 -0800
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
Subject: [PATCH 01/15] x86/irq: Move posted interrupt descriptor out of vmx code
Date: Fri, 26 Jan 2024 15:42:23 -0800
Message-Id: <20240126234237.547278-2-jacob.jun.pan@linux.intel.com>
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
index e262bc2ba4e5..d4b6072344ed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -67,6 +67,7 @@
 #include "x86.h"
 #include "smm.h"
 #include "vmx_onhyperv.h"
+#include "posted_intr.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e3b0985bb74a..5ca8ab15b4f8 100644
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


