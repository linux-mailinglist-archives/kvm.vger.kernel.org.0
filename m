Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7537A142C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfH2IxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:53:06 -0400
Received: from ozlabs.ru ([107.173.13.209]:49828 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbfH2IxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:53:05 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 46E3BAE80570;
        Thu, 29 Aug 2019 04:52:41 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v3 4/5] powerpc/pseries/iommu: Switch to xchg_no_kill
Date:   Thu, 29 Aug 2019 18:52:51 +1000
Message-Id: <20190829085252.72370-5-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829085252.72370-1-aik@ozlabs.ru>
References: <20190829085252.72370-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the last implementation of iommu_table_ops::exchange() which
we are about to remove.

This implements xchg_no_kill() for pseries. Since it is paravirtual
platform, the hypervisor does TCE invalidations and we do not have
to deal with it here, hence no tce_kill() hook.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
Changes:
v3:
* new to the series and it fixes compile error from v2
---
 arch/powerpc/platforms/pseries/iommu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 42fb03253334..df7db33ca93b 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -621,7 +621,8 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 
 #ifdef CONFIG_IOMMU_API
 static int tce_exchange_pseries(struct iommu_table *tbl, long index, unsigned
-				long *tce, enum dma_data_direction *direction)
+				long *tce, enum dma_data_direction *direction,
+				bool realmode)
 {
 	long rc;
 	unsigned long ioba = (unsigned long) index << tbl->it_page_shift;
@@ -649,7 +650,7 @@ static int tce_exchange_pseries(struct iommu_table *tbl, long index, unsigned
 struct iommu_table_ops iommu_table_lpar_multi_ops = {
 	.set = tce_buildmulti_pSeriesLP,
 #ifdef CONFIG_IOMMU_API
-	.exchange = tce_exchange_pseries,
+	.xchg_no_kill = tce_exchange_pseries,
 #endif
 	.clear = tce_freemulti_pSeriesLP,
 	.get = tce_get_pSeriesLP
-- 
2.17.1

