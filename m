Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4003C757E
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGMRIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:08:34 -0400
Received: from foss.arm.com ([217.140.110.172]:47596 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhGMRId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:08:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7183B1FB;
        Tue, 13 Jul 2021 10:05:43 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1C973F7D8;
        Tue, 13 Jul 2021 10:05:41 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org, pierre.gondois@arm.com
Subject: [PATCH v3 kvmtool 2/4] arm/fdt.c: Don't generate the node if generator function is NULL
Date:   Tue, 13 Jul 2021 18:06:29 +0100
Message-Id: <20210713170631.155595-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210713170631.155595-1-alexandru.elisei@arm.com>
References: <20210713170631.155595-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print a more helpful debugging message when a MMIO device hasn't set a
function to generate an FDT node instead of causing a segmentation fault by
dereferencing a NULL pointer.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/fdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 02091e9e0bee..7032985e99a3 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -171,7 +171,12 @@ static int setup_fdt(struct kvm *kvm)
 	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
 	while (dev_hdr) {
 		generate_mmio_fdt_nodes = dev_hdr->data;
-		generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
+		if (generate_mmio_fdt_nodes) {
+			generate_mmio_fdt_nodes(fdt, dev_hdr, generate_irq_prop);
+		} else {
+			pr_debug("Missing FDT node generator for MMIO device %d",
+				 dev_hdr->dev_num);
+		}
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
-- 
2.32.0

