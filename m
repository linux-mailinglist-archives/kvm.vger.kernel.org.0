Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3003AE5E2
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 11:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFUJXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 05:23:05 -0400
Received: from foss.arm.com ([217.140.110.172]:59590 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230471AbhFUJW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 05:22:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7AF3ED1;
        Mon, 21 Jun 2021 02:20:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A75EE3F718;
        Mon, 21 Jun 2021 02:20:42 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org, pierre.gondois@arm.com
Subject: [PATCH v2 kvmtool 2/4] arm/fdt.c: Don't generate the node if generator function is NULL
Date:   Mon, 21 Jun 2021 10:21:26 +0100
Message-Id: <20210621092128.11313-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621092128.11313-1-alexandru.elisei@arm.com>
References: <20210621092128.11313-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Print a more helpful debugging message when a MMIO device hasn't set a
function to generate an FDT node instead of causing a segmentation fault by
dereferencing a NULL pointer.

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

