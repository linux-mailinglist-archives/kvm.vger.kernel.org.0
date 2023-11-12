Return-Path: <kvm+bounces-1530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F39F47E8E39
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E6081C20748
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55CFBE71;
	Sun, 12 Nov 2023 04:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eng2LJO8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD788440E
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:13 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086FA3840;
	Sat, 11 Nov 2023 20:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762332; x=1731298332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bUqv9KmUqsXG7vFMJHl27FbTCB3T6tJUXKy8ifc6Wm4=;
  b=eng2LJO8TCP7SkPzLh5v6ZEFHOlGOEoj89K6p9YRensaWSbAzvQoo+aF
   +HrjA777KtW9PvfctnMYwOw3ahY1E9MoqUn82yx5pFeaXDeW2OVxZUhYy
   5bthu/qMlnA0Ae9tkwu9E8IaTeJCRlDvJ5urn5HHLDiiIKOF2PpFbedTD
   pVxteSnj10ytFz3i+5gYEEolU6Wzk8IP/whsT0ZmUiGL++/B/4mPo05f0
   XXodrPtReCOZLAQAs8FAAOn3HrKPDYq0ql8wCrcZ3q4hTiM0qVR4pRBL8
   xuoMPZJUPjhua4XaiiXdwNwIQucnw5E3+xyF+MRmxyx7ktuE8GvPZTvvu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533937"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533937"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936767"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936767"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:09 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	peterz@infradead.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH RFC 10/13] x86/irq: Handle potential lost IRQ during migration and CPU offline
Date: Sat, 11 Nov 2023 20:16:40 -0800
Message-Id: <20231112041643.2868316-11-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Though IRTE modification for IRQ affinity change is a atomic operation,
it does not guarantee the timing of IRQ posting at PID.

considered the following scenario:
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

If IRQ affinity change happens between 3 and 5 in IOMMU, old CPU's PIR could
have pending bit set for the vector being moved. We must check PID.PIR
to prevent the lost of interrupts.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apic/vector.c |  8 +++++++-
 arch/x86/kernel/irq.c         | 20 +++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 319448d87b99..14fc33cfdb37 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -19,6 +19,7 @@
 #include <asm/apic.h>
 #include <asm/i8259.h>
 #include <asm/desc.h>
+#include <asm/posted_intr.h>
 #include <asm/irq_remapping.h>
 
 #include <asm/trace/irq_vectors.h>
@@ -978,9 +979,14 @@ static void __vector_cleanup(struct vector_cleanup *cl, bool check_irr)
 		 * Do not check IRR when called from lapic_offline(), because
 		 * fixup_irqs() was just called to scan IRR for set bits and
 		 * forward them to new destination CPUs via IPIs.
+		 *
+		 * If the vector to be cleaned is delivered as posted intr,
+		 * it is possible that the interrupt has been posted but
+		 * not made to the IRR due to coalesced notifications.
+		 * Therefore, check PIR to see if the interrupt was posted.
 		 */
 		irr = check_irr ? apic_read(APIC_IRR + (vector / 32 * 0x10)) : 0;
-		if (irr & (1U << (vector % 32))) {
+		if (irr & (1U << (vector % 32)) || is_pi_pending_this_cpu(vector)) {
 			pr_warn_once("Moved interrupt pending in old target APIC %u\n", apicd->irq);
 			rearm = true;
 			continue;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 786c2c8330f4..7732cb9bbf0c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -444,11 +444,26 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
 }
 #endif /* X86_POSTED_MSI */
 
+/*
+ * Check if a given vector is pending in APIC IRR or PIR if posted interrupt
+ * is enabled for coalesced interrupt delivery (CID).
+ */
+static inline bool is_vector_pending(unsigned int vector)
+{
+	unsigned int irr;
+
+	irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+	if (irr  & (1 << (vector % 32)))
+		return true;
+
+	return is_pi_pending_this_cpu(vector);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
 {
-	unsigned int irr, vector;
+	unsigned int vector;
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
@@ -475,8 +490,7 @@ void fixup_irqs(void)
 		if (IS_ERR_OR_NULL(__this_cpu_read(vector_irq[vector])))
 			continue;
 
-		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
-		if (irr  & (1 << (vector % 32))) {
+		if (is_vector_pending(vector)) {
 			desc = __this_cpu_read(vector_irq[vector]);
 
 			raw_spin_lock(&desc->lock);
-- 
2.25.1


