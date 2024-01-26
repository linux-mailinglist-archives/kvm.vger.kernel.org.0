Return-Path: <kvm+bounces-7258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E7083E721
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:41:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4481C1C27885
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E4163106;
	Fri, 26 Jan 2024 23:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CoHQNaQk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74BE60886;
	Fri, 26 Jan 2024 23:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312255; cv=none; b=ewcZMyd6QV3wtetaDTAB9QdL/FMEtAFxdTpaW54IdWfsWtA3g7s26E+C+R9WClnGpGa2/ocesuu9qzzYRlravFto+v+JXsah+5//jSw1LN5gRGoBbpcUOV6BONeWbrRGfQRD4Cl00OU6Tf2LsXWqR3Qsh+YXjRWZBcjniLdez2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312255; c=relaxed/simple;
	bh=tBMxqVMHu63G2rJ3nBVSuahDnZ+Xdu27rPnRP82vOHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V5nkXVJg/nbBQFcU7N5HfrCVRFB1tT4xzzEUTP8DT2KMZmXyIT50GHcKpK/SP8rz4emZ8kDshtq8S2F3iV+L61Xe3VEU6NYOd5KNcxwp1Zv+ahS9XtBhNNa8DCKeE1ep9isJPrP2Ss9Fg17r6rZXHUCHcyITj79OOfB1lOM9wtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CoHQNaQk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312252; x=1737848252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tBMxqVMHu63G2rJ3nBVSuahDnZ+Xdu27rPnRP82vOHs=;
  b=CoHQNaQk+fa7SE2Cgdtn3qi11C/B4/3FesyQXpnM6wqpVpUsTQkuTnIP
   gWryWQC49UwoFhw/cstBTyAc68hXdkzy/Jr9cioFJORAYUbD69tho8cHx
   nRuNdOM4ZfMZI6Kpqbu/ocOa6ZRpqum+ryaLO9vMtlifykIRf866m0k+m
   B7hvQlw8TCxx3EbT4zPcKi0gZrtW8JVDNxwBmQp7VMIwejKBR7JbU5zeI
   LOr6FhCFcYJQoio+d84cNcxSEyAf42sFv5v7Xb+ksjUNdKB/z1oP2YmCX
   wrrZrZ4twNKwD23sDrBL41CDuqfrWmFeVVqZeUmNAHoXVY6xUCcqg/6gM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990778"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990778"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290752"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290752"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga001.jf.intel.com with ESMTP; 26 Jan 2024 15:37:23 -0800
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
Subject: [PATCH 13/15] iommu/vt-d: Add an irq_chip for posted MSIs
Date: Fri, 26 Jan 2024 15:42:35 -0800
Message-Id: <20240126234237.547278-14-jacob.jun.pan@linux.intel.com>
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

Introduce a new irq_chip for posted MSIs, the key difference is in
irq_ack where EOI is performed by the notification handler.

When posted MSI is enabled, MSI domain/chip hierarchy will look like
this example:

domain:  IR-PCI-MSIX-0000:50:00.0-12
 hwirq:   0x29
 chip:    IR-PCI-MSIX-0000:50:00.0
  flags:   0x430
             IRQCHIP_SKIP_SET_WAKE
             IRQCHIP_ONESHOT_SAFE
 parent:
    domain:  INTEL-IR-10-13
     hwirq:   0x2d0000
     chip:    INTEL-IR-POST
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x77
         chip:    APIC

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iommu/intel/irq_remapping.c | 46 +++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 566297bc87dd..fa719936b44e 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1233,6 +1233,52 @@ static struct irq_chip intel_ir_chip = {
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
 };
 
+static void dummy(struct irq_data *d)
+{
+}
+
+/*
+ * With posted MSIs, all vectors are multiplexed into a single notification
+ * vector. Devices MSIs are then dispatched in a demux loop where
+ * EOIs can be coalesced as well.
+ *
+ * "INTEL-IR-POST" IRQ chip does not do EOI on ACK, thus the dummy irq_ack()
+ * function. Instead EOI is performed by the posted interrupt notification
+ * handler.
+ *
+ * For the example below, 3 MSIs are coalesced into one CPU notification. Only
+ * one apic_eoi() is needed.
+ *
+ * __sysvec_posted_msi_notification()
+ *	irq_enter();
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *	irq_enter();
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *	irq_enter();
+ *		handle_edge_irq()
+ *			irq_chip_ack_parent()
+ *				dummy(); // No EOI
+ *			handle_irq_event()
+ *				driver_handler()
+ *	apic_eoi()
+ * irq_exit()
+ */
+static struct irq_chip intel_ir_chip_post_msi = {
+	.name			= "INTEL-IR-POST",
+	.irq_ack		= dummy,
+	.irq_set_affinity	= intel_ir_set_affinity,
+	.irq_compose_msi_msg	= intel_ir_compose_msi_msg,
+	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
+};
+
 static void fill_msi_msg(struct msi_msg *msg, u32 index, u32 subhandle)
 {
 	memset(msg, 0, sizeof(*msg));
-- 
2.25.1


