Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC730E48D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 22:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhBCVBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 16:01:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:12604 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232852AbhBCU6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:58:46 -0500
IronPort-SDR: v1D1CfHrryRk8k9lyEPtzuGeiFgs8eZGaeOlk2+3AflrDm80gAzZAr1FN8MQ/5XkI6rIFssBb1
 Wz2rYPwXdFOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="200084229"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="200084229"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 12:57:29 -0800
IronPort-SDR: 4XvBfjP/iQqbBWLZ2szBUV+ObDD33PykBEc1uG1b8bXLvYgFtaa6445QuPrkFnLgTfY8JojNhn
 y11wMRRTP6ng==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="372510555"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 03 Feb 2021 12:57:29 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        megha.dey@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, maz@kernel.org, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: [PATCH 04/12] genirq/proc: Take buslock on affinity write
Date:   Wed,  3 Feb 2021 12:56:37 -0800
Message-Id: <1612385805-3412-5-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
References: <1612385805-3412-1-git-send-email-megha.dey@intel.com>
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
busses.

Change the locking in irq_set_affinity() to bus_lock/unlock to help with
that. There are a few other callers than the proc interface, but none of
them is affected by this change as none of them affects an irq chip with
bus lock support.

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

