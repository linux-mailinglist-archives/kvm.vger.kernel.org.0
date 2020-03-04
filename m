Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD71799FE
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388465AbgCDUfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgCDUel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:34:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BE021775;
        Wed,  4 Mar 2020 20:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354080;
        bh=f4KROPbHNkx5Xhey9xixv6mSd8poFgDzqzSMEAMUG1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkDBxlE+BKgy9IzDpkhV9UAwDp2+se6UmGtgDvzbp9VPu+zvhAsW2l07WtnKmaeRL
         w1QtZAs1YEds04ISjim/TlaGrbNh3aENxC9FT6ryaZwvNuCxla3yLPtv5S0Xv1Id76
         tSf8gyesndhNQOczjM6VNhYgdeGikor2agheq0iw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9aj0-00A59R-TH; Wed, 04 Mar 2020 20:34:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 02/23] irqchip/gic-v4.1: Skip absent CPUs while iterating over redistributors
Date:   Wed,  4 Mar 2020 20:33:09 +0000
Message-Id: <20200304203330.4967-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a system that is only sparsly populated with CPUs, we can end-up with
redistributors structures that are not initialized. Let's make sure we
don't try and access those when iterating over them (in this case when
checking we have a L2 VPE table).

Fixes: 4e6437f12d6e ("irqchip/gic-v4.1: Ensure L2 vPE table is allocated at RD level")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 83b1186ffcad..da883a691028 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2452,6 +2452,10 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 	if (!gic_rdists->has_rvpeid)
 		return true;
 
+	/* Skip non-present CPUs */
+	if (!base)
+		return true;
+
 	val  = gicr_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
 
 	esz  = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val) + 1;
-- 
2.20.1

