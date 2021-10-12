Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDC342A58D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhJLNZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 09:25:46 -0400
Received: from foss.arm.com ([217.140.110.172]:42124 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236727AbhJLNZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 09:25:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AE201063;
        Tue, 12 Oct 2021 06:23:44 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 887923F66F;
        Tue, 12 Oct 2021 06:23:43 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v2 kvmtool 1/7] arm/gicv2m: Set errno when gicv2_update_routing() fails
Date:   Tue, 12 Oct 2021 14:25:04 +0100
Message-Id: <20211012132510.42134-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211012132510.42134-1-alexandru.elisei@arm.com>
References: <20211012132510.42134-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of an error when updating the routing table entries,
irq__update_msix_route() uses perror to print an error message.
gicv2m_update_routing() doesn't set errno, and instead returns the value
that errno should have had, which can lead to failure messages like this:

KVM_SET_GSI_ROUTING: Success

Set errno in gicv2m_update_routing() to avoid such messages in the future.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/gicv2m.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arm/gicv2m.c b/arm/gicv2m.c
index d7e6398..b47ada8 100644
--- a/arm/gicv2m.c
+++ b/arm/gicv2m.c
@@ -42,16 +42,18 @@ static int gicv2m_update_routing(struct kvm *kvm,
 {
 	int spi;
 
-	if (entry->type != KVM_IRQ_ROUTING_MSI)
-		return -EINVAL;
+	if (entry->type != KVM_IRQ_ROUTING_MSI) {
+		errno = EINVAL;
+		return -errno;
+	}
 
 	if (!entry->u.msi.address_hi && !entry->u.msi.address_lo)
 		return 0;
 
 	spi = entry->u.msi.data & GICV2M_SPI_MASK;
 	if (spi < v2m.first_spi || spi >= v2m.first_spi + v2m.num_spis) {
-		pr_err("invalid SPI number %d", spi);
-		return -EINVAL;
+		errno = EINVAL;
+		return -errno;
 	}
 
 	v2m.spis[spi - v2m.first_spi] = entry->gsi;
-- 
2.20.1

