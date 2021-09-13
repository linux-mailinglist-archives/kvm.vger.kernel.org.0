Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7E84097AC
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 17:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbhIMPol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 11:44:41 -0400
Received: from foss.arm.com ([217.140.110.172]:33246 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344213AbhIMPoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 11:44:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14A8312FC;
        Mon, 13 Sep 2021 08:43:01 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C9AE3F719;
        Mon, 13 Sep 2021 08:42:59 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v1 kvmtool 7/7] vfio/pci: Align MSIX Table and PBA size allocation to 64k
Date:   Mon, 13 Sep 2021 16:44:13 +0100
Message-Id: <20210913154413.14322-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913154413.14322-1-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When allocating MMIO space for the MSI-X table, kvmtool rounds the
allocation to the host's page size to make it as easy as possible for the
guest to map the table to a page, if it wants to (and doesn't do BAR
reassignment, like the x86 architecture for example). However, the host's
page size can differ from the guest's, for example, if the host is compiled
with 4k pages and the guest is using 64k pages.

To make sure the allocation is always aligned to a guest's page size, round
it up to the maximum page size, which is 64k. Do the same for the pending
bit array if it lives in its own BAR.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 vfio/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index a6d0408..7e258a4 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1,3 +1,5 @@
+#include "linux/sizes.h"
+
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
@@ -929,7 +931,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	if (!info.size)
 		return -EINVAL;
 
-	map_size = ALIGN(info.size, PAGE_SIZE);
+	map_size = ALIGN(info.size, SZ_64K);
 	table->guest_phys_addr = pci_get_mmio_block(map_size);
 	if (!table->guest_phys_addr) {
 		pr_err("cannot allocate MMIO space");
@@ -960,7 +962,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 		if (!info.size)
 			return -EINVAL;
 
-		map_size = ALIGN(info.size, PAGE_SIZE);
+		map_size = ALIGN(info.size, SZ_64K);
 		pba->guest_phys_addr = pci_get_mmio_block(map_size);
 		if (!pba->guest_phys_addr) {
 			pr_err("cannot allocate MMIO space");
-- 
2.20.1

