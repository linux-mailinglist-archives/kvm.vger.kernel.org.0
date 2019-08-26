Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7C99C915
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfHZGRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:17:17 -0400
Received: from ozlabs.ru ([107.173.13.209]:55914 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfHZGRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:17:17 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 2CD15AE80011;
        Mon, 26 Aug 2019 02:16:53 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH kernel v2 0/4] powerpc/powernv/kvm: Invalidate multiple TCEs at once
Date:   Mon, 26 Aug 2019 16:17:01 +1000
Message-Id: <20190826061705.92048-1-aik@ozlabs.ru>
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

This is a rework of https://patchwork.ozlabs.org/patch/1149003/
This depends on KVM-PPC's bugfix: https://patchwork.ozlabs.org/patch/1152937/

I expect 1/4 to go via the PPC tree, 2/4 via the KVM-PPC tree,
3/4 via the VFIO tree and 4/4 via the PPC tree so it is a loop.
There is always a hope it can go via one tree :)


This is based on sha1
42ac26d253eb Santosh Sivaraj "powerpc: add machine check safe copy_to_user".

Please comment. Thanks.



Alexey Kardashevskiy (4):
  powerpc/powernv/ioda: Split out TCE invalidation from TCE updates
  KVM: PPC: Invalidate multiple TCEs at once
  vfio/spapr_tce: Invalidate multiple TCEs at once
  powerpc/powernv/ioda: Remove obsolete iommu_table_ops::exchange
    callbacks

 arch/powerpc/include/asm/iommu.h          | 21 ++++++---
 arch/powerpc/kernel/iommu.c               | 23 ++++++----
 arch/powerpc/kvm/book3s_64_vio.c          | 29 ++++++++----
 arch/powerpc/kvm/book3s_64_vio_hv.c       | 38 +++++++++++----
 arch/powerpc/platforms/powernv/pci-ioda.c | 56 ++++-------------------
 drivers/vfio/vfio_iommu_spapr_tce.c       | 18 +++++---
 6 files changed, 96 insertions(+), 89 deletions(-)

-- 
2.17.1

