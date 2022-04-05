Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE564F44A6
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiDEOvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237967AbiDENKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 09:10:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76BEB89CDB;
        Tue,  5 Apr 2022 05:11:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 077B5D6E;
        Tue,  5 Apr 2022 05:11:59 -0700 (PDT)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3680E3F5A1;
        Tue,  5 Apr 2022 05:11:58 -0700 (PDT)
From:   Robin Murphy <robin.murphy@arm.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfio: Stop using iommu_present()
Date:   Tue,  5 Apr 2022 13:11:54 +0100
Message-Id: <537103bbd7246574f37f2c88704d7824a3a889f2.1649160714.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.28.0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IOMMU groups have been mandatory for some time now, so a device without
one is necessarily a device without any usable IOMMU, therefore the
iommu_present() check is redundant (or at best unhelpful).

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/vfio/vfio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e..7b0a7b85e77e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -745,11 +745,11 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 
 	iommu_group = iommu_group_get(dev);
 #ifdef CONFIG_VFIO_NOIOMMU
-	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
+	if (!iommu_group && noiommu) {
 		/*
 		 * With noiommu enabled, create an IOMMU group for devices that
-		 * don't already have one and don't have an iommu_ops on their
-		 * bus.  Taint the kernel because we're about to give a DMA
+		 * don't already have one, implying no IOMMU hardware/driver
+		 * exists.  Taint the kernel because we're about to give a DMA
 		 * capable device to a user without IOMMU protection.
 		 */
 		group = vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
-- 
2.28.0.dirty

