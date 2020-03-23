Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C213918F08C
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbgCWIBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:01:06 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:50658 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgCWIBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:01:03 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 353E2AE807DF;
        Mon, 23 Mar 2020 03:52:23 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 3/7] powerpc/powernv/ioda: Allow smaller TCE table levels
Date:   Mon, 23 Mar 2020 18:53:50 +1100
Message-Id: <20200323075354.93825-4-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323075354.93825-1-aik@ozlabs.ru>
References: <20200323075354.93825-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now the minimum allocation size for a TCE table level is PAGE_SIZE (64k)
as this is the minimum for alloc_pages(). The limit was set in POWER8
where we did not have sparse RAM so we did not need sparse TCE tables.
On POWER9 we have gaps in the phys address space for which using multi
level TCE tables makes sense. The problem with that is that 64K per level
is too much for 2 levels and 1GB pages as it exceeds the hardware limit
of 55bits so we need smaller levels.

This drops the minimum level size to 4K.

For a machine with 2 CPUs, top RAM address 0x4000.0000.0000
(each node gets 32TiB) and 1GiB IOMMU pages:
Before the patch: 512KiB or 8 pages.
After the patch: 3 pages: one level1 + 2xlevel2 tables, each can map
up to 64k>>3<<30 = 8TiB of physical space.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda-tce.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda-tce.c b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
index 5dc6847d5f4c..82e680da9d94 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda-tce.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
@@ -37,7 +37,7 @@ static __be64 *pnv_alloc_tce_level(int nid, unsigned int shift)
 	__be64 *addr;
 
 	tce_mem = alloc_pages_node(nid, GFP_ATOMIC | __GFP_NOWARN,
-			shift - PAGE_SHIFT);
+			shift > PAGE_SHIFT ? shift - PAGE_SHIFT : 0);
 	if (!tce_mem) {
 		pr_err("Failed to allocate a TCE memory, level shift=%d\n",
 				shift);
@@ -282,7 +282,7 @@ long pnv_pci_ioda2_table_alloc_pages(int nid, __u64 bus_offset,
 	/* Adjust direct table size from window_size and levels */
 	entries_shift = (entries_shift + levels - 1) / levels;
 	level_shift = entries_shift + 3;
-	level_shift = max_t(unsigned int, level_shift, PAGE_SHIFT);
+	level_shift = max_t(unsigned int, level_shift, 12); /* 4K is minimum */
 
 	if ((level_shift - 3) * levels + page_shift >= 55)
 		return -EINVAL;
-- 
2.17.1

