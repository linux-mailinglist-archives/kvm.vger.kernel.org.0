Return-Path: <kvm+bounces-1534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F30D7E8E3B
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FB021F20F83
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983B01172D;
	Sun, 12 Nov 2023 04:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOnPHrSP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3D46B2
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:14 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B351530D5;
	Sat, 11 Nov 2023 20:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762332; x=1731298332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFZk1jO0NsxwqOQHg0a3driwffs3nDYuRHJpiimktAA=;
  b=gOnPHrSPA0GRoHHYvgsWYBpVIn1KSrHL7uQHOEglojLEBN9bAq3py+wz
   zIJQ2t6p9Uj1/1XSjwcaCoke0JyRbQDFl70FY/075uRbF+9JIPZ4oSG7I
   WPq5OwK9Qs+eaRpO6KbDTgjwu0B9i4/DTr2JHEJ+IcLaoqJImUYH6G541
   1WiGcwLVPAHyg1gAuwFBFeD+ljyAMwVRijXRNUNYDMHjXenurqCDojoa8
   9RCmEdzfXL2q0bo8Nb/Gy5kzx6pikr2pfmvtcEAqYJhuTmTJe2QipU9GV
   fSa1qA/NlcdjSJ1t9oUSaCMn0znaxi+jHQqhfoadnQnBaqpORYDp2UH0o
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533961"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533961"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936773"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936773"
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
Subject: [PATCH RFC 12/13] iommu/vt-d: Add a helper to retrieve PID address
Date: Sat, 11 Nov 2023 20:16:42 -0800
Message-Id: <20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
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

From: Thomas Gleixner <tglx@linutronix.de>

When programming IRTE for posted mode, we need to retrieve the physical
address of the posted interrupt descriptor (PID) that belongs to it's
target CPU.

This per CPU PID has already been set up during cpu_init().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iommu/intel/irq_remapping.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index f2870d3c8313..971e6c37002f 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1125,6 +1125,15 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.reenable		= reenable_irq_remapping,
 	.enable_faulting	= enable_drhd_fault_handling,
 };
+#ifdef CONFIG_X86_POSTED_MSI
+
+static u64 get_pi_desc_addr(struct irq_data *irqd)
+{
+	int cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));
+
+	return __pa(per_cpu_ptr(&posted_interrupt_desc, cpu));
+}
+#endif
 
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
 {
-- 
2.25.1


