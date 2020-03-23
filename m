Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162AE18F087
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgCWIBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:01:02 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:50660 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgCWIBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:01:01 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id A1E87AE80013;
        Mon, 23 Mar 2020 03:52:14 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA window at 4GB
Date:   Mon, 23 Mar 2020 18:53:47 +1100
Message-Id: <20200323075354.93825-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here is an attempt to support bigger DMA space for devices
supporting DMA masks less than 59 bits (GPUs come into mind
first). POWER9 PHBs have an option to map 2 windows at 0
and select a windows based on DMA address being below or above
4GB.

This adds the "iommu=iommu_bypass" kernel parameter and
supports VFIO+pseries machine - current this requires telling
upstream+unmodified QEMU about this via
-global spapr-pci-host-bridge.dma64_win_addr=0x100000000
or per-phb property. 4/4 advertises the new option but
there is no automation around it in QEMU (should it be?).

For now it is either 1<<59 or 4GB mode; dynamic switching is
not supported (could be via sysfs).

This is a rebased version of
https://lore.kernel.org/kvm/20191202015953.127902-1-aik@ozlabs.ru/

The main change since v1 is that now it is 7 patches with
clearer separation of steps.


This is based on 6c90b86a745a "Merge tag 'mmc-v5.6-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc"

Please comment. Thanks.



Alexey Kardashevskiy (7):
  powerpc/powernv/ioda: Move TCE bypass base to PE
  powerpc/powernv/ioda: Rework for huge DMA window at 4GB
  powerpc/powernv/ioda: Allow smaller TCE table levels
  powerpc/powernv/phb4: Use IOMMU instead of bypassing
  powerpc/iommu: Add a window number to
    iommu_table_group_ops::get_table_size
  powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
  vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB

 arch/powerpc/include/asm/iommu.h              |   3 +
 arch/powerpc/include/asm/opal-api.h           |   9 +-
 arch/powerpc/include/asm/opal.h               |   2 +
 arch/powerpc/platforms/powernv/pci.h          |   4 +-
 include/uapi/linux/vfio.h                     |   2 +
 arch/powerpc/platforms/powernv/npu-dma.c      |   1 +
 arch/powerpc/platforms/powernv/opal-call.c    |   2 +
 arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     | 234 ++++++++++++++----
 drivers/vfio/vfio_iommu_spapr_tce.c           |  17 +-
 10 files changed, 213 insertions(+), 65 deletions(-)

-- 
2.17.1

