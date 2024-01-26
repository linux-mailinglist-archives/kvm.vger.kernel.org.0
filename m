Return-Path: <kvm+bounces-7256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38FFA83E71D
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 00:41:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDFB4B241C8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9E6627FE;
	Fri, 26 Jan 2024 23:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hLljP1ki"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BE76089C;
	Fri, 26 Jan 2024 23:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706312254; cv=none; b=TvxPzsKuFWcHwR/OOIczAIZeS0e9FZQzhOxMFXEj3Ixn4EAZiU++KUb9TQUX4PGdWPmgB+HpBukdpncI0qCp0vJ40u2rOdcZO4oVNabO6s0QKb0/L03botqpaL4y5iyqCHevELcMaE5tlgo+9wiN2U532IeS8t6iRUJ8bJI62+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706312254; c=relaxed/simple;
	bh=RLEMYdVVEnLOqM5rupdyL8vv8OyQExpN9wq5K3uinZc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DMswAOFwrr3Hq9hlKBD8alT17miAORXamBLdCzt1YsCInEU6e4MPvHUB+8YhdQQQTgOYGPCb6jxrOZoRnW9GRlsLSB/EHnHkusx+MO8tDFzIc2ftt5VY4LMMW9+d0drHzclKUraF1SQPtPyJUGP3hmv0Ir0NgD0wm4pggIj3ynY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hLljP1ki; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706312252; x=1737848252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RLEMYdVVEnLOqM5rupdyL8vv8OyQExpN9wq5K3uinZc=;
  b=hLljP1kichLqz/h6poVw4fiZ+htNkkGk+R2nYgfJY0zb4VWLWDxhWVja
   GKv7VH27O7Sjd6apVqIOBP/bHDAOQgSCae6Bn9iZlGC1ygJ9KfLyYrxlQ
   tXPx0Y0IKiGXYLqaz9FL7RA1zrkUhZTA54LGg/cBdmA/+TtvBw3JF0sHm
   3dMO5pyjvG+vfDDnW0Cjh+JX9uokUL5JHvggQpYIYoKjXxH1SXiGUkWZ1
   ugQWW2VPhojUuCdTyVgxW6iRbCZS1nahY95zJ+y2I5++azX7NgKcannMg
   8gDz/5r1hvOBqS4RWhyz54COeR1n1ojkz6PYLOKGx+NUrVhP4AuPjDXrD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9990798"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9990798"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 15:37:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="821290755"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="821290755"
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
Subject: [PATCH 14/15] iommu/vt-d: Add a helper to retrieve PID address
Date: Fri, 26 Jan 2024 15:42:36 -0800
Message-Id: <20240126234237.547278-15-jacob.jun.pan@linux.intel.com>
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

From: Thomas Gleixner <tglx@linutronix.de>

Physical address of the Intel posted interrupt descriptor (PID) is needed
when programming interrupt remapping table entry (IRTE) for posted mode.

PID is per-CPU, this patch adds a helper function to retrieve the target
CPU's PID address based on the effective affinity mask of the interrupt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
v1: Added a warning if the effective affinity mask is not set up
---
 drivers/iommu/intel/irq_remapping.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index fa719936b44e..01df65dca1d5 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -19,6 +19,7 @@
 #include <asm/cpu.h>
 #include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
+#include <asm/posted_intr.h>
 
 #include "iommu.h"
 #include "../irq_remapping.h"
@@ -1126,6 +1127,19 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.enable_faulting	= enable_drhd_fault_handling,
 };
 
+#ifdef CONFIG_X86_POSTED_MSI
+
+static phys_addr_t get_pi_desc_addr(struct irq_data *irqd)
+{
+	int cpu = cpumask_first(irq_data_get_effective_affinity_mask(irqd));
+
+	if (WARN_ON(cpu >= nr_cpu_ids))
+		return 0;
+
+	return __pa(per_cpu_ptr(&posted_interrupt_desc, cpu));
+}
+#endif
+
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
 {
 	struct intel_ir_data *ir_data = irqd->chip_data;
-- 
2.25.1


