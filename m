Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9883D32685B
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 21:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhBZUOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 15:14:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:35622 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhBZUMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 15:12:54 -0500
IronPort-SDR: v15gtxW41SeRMEZxM4Mjkccj2IG1llTOLEW6xNdYEk31e0K2qjcGuWuTvDHDqGC4AaLpnbQjmg
 NgxYmTaW7gcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9907"; a="165846890"
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="165846890"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 12:11:12 -0800
IronPort-SDR: u4IAvGdLeToPWo/koT5J5hjXR2dHjNUyI+wV88uEkb9QnkDbyoyO6UoKv2YP3Z7gUMSeRDGQRA
 2O1bk3wGK+KQ==
X-IronPort-AV: E=Sophos;i="5.81,209,1610438400"; 
   d="scan'208";a="405109431"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 Feb 2021 12:11:11 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [Patch V2 04/13] genirq/proc: Take buslock on affinity write
Date:   Fri, 26 Feb 2021 12:11:08 -0800
Message-Id: <1614370277-23235-5-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Until now interrupt chips which support setting affinity are not locking
the associated bus lock for two reasons:

 - All chips which support affinity setting do not use buslock because they
   just can operated directly on the hardware.

 - All chips which use buslock do not support affinity setting because
   their interrupt chips are not capable. These chips are usually connected
   over a bus like I2C, SPI etc. and have an interrupt output which is
   conneted to CPU interrupt of some sort. So there is no way to set the
   affinity on the chip itself.

Upcoming hardware which is PCIE based sports a non standard MSI(X) variant
which stores the MSI message in RAM which is associated to e.g. a device
queue. The device manages this RAM and writes have to be issued via command
queues or similar mechanisms which is obviously not possible from interrupt
disabled, raw spinlock held context.

The buslock mechanism of irq chips can be utilized to support that. The
affinity write to the chip writes to shadow state, marks it pending and the
irq chip's irq_bus_sync_unlock() callback handles the command queue and
wait for completion similar to the other chip operations on I2C or SPI
buses.

Change the locking in irq_set_affinity() to bus_lock/unlock to help with
that. There are a few other callers than the proc interface, but none of
them is affected by this change as none of them affects an irq chip with
bus lock support.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 kernel/irq/manage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index dec3f73..85ede4e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -443,16 +443,16 @@ int irq_update_affinity_desc(unsigned int irq,
 
 int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc;
 	unsigned long flags;
 	int ret;
 
+	desc = irq_get_desc_buslock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
 	if (!desc)
 		return -EINVAL;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
 	ret = irq_set_affinity_locked(irq_desc_get_irq_data(desc), mask, force);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	irq_put_desc_busunlock(desc, flags);
 	return ret;
 }
 
-- 
2.7.4

