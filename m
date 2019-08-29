Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78F46A1424
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfH2Iw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:52:57 -0400
Received: from ozlabs.ru ([107.173.13.209]:49750 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfH2Iw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:52:57 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 6E65FAE80037;
        Thu, 29 Aug 2019 04:52:32 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v3 0/5] powerpc/powernv/kvm: Invalidate multiple TCEs at once
Date:   Thu, 29 Aug 2019 18:52:47 +1000
Message-Id: <20190829085252.72370-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far TCE cache updates (IOMMU translation cache on POWER8/9
PHB/NPU units) were barely noticeable; however with 100+GB guests
we now see RCU stall warnings in guests because we spend too much
time in the host system firmware which does actual TCE cache
updates, hence this patchset.

This is a rework of
https://patchwork.ozlabs.org/patch/1149003/
https://patchwork.ozlabs.org/patch/1152985/ (cannot post link to the series
as it appears empty because of broken patchworks)

This depends on KVM-PPC's bugfix: https://patchwork.ozlabs.org/patch/1152937/

I expect 1/5 to go via the PPC tree, 2/5 via the KVM-PPC tree,
3/5 via the VFIO tree and the rest via the PPC tree.

Changes:
v3:
* added 4/5 to fix compile error from 5/5
* added "Book3S" to 2/5's subject line


This is based on sha1
42ac26d253eb Santosh Sivaraj "powerpc: add machine check safe copy_to_user".

Please comment. Thanks.



Alexey Kardashevskiy (5):
  powerpc/powernv/ioda: Split out TCE invalidation from TCE updates
  KVM: PPC: Book3S: Invalidate multiple TCEs at once
  vfio/spapr_tce: Invalidate multiple TCEs at once
  powerpc/pseries/iommu: Switch to xchg_no_kill
  powerpc/powernv/ioda: Remove obsolete iommu_table_ops::exchange
    callbacks

 arch/powerpc/include/asm/iommu.h          | 21 ++++++---
 arch/powerpc/kernel/iommu.c               | 23 ++++++----
 arch/powerpc/kvm/book3s_64_vio.c          | 29 ++++++++----
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 38 +++++++++++----
 arch/powerpc/platforms/powernv/pci-ioda.c | 56 ++++-------------------
 arch/powerpc/platforms/pseries/iommu.c    |  5 +-
 drivers/vfio/vfio_iommu_spapr_tce.c       | 18 +++++---
 7 files changed, 99 insertions(+), 91 deletions(-)

-- 
2.17.1

