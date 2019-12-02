Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B410E46E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfLBCJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Dec 2019 21:09:38 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:38182 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfLBCJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Dec 2019 21:09:38 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id AC719AE800ED;
        Sun,  1 Dec 2019 20:58:54 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel RFC 0/4] powerpc/powenv/ioda: Allow huge DMA window at 4GB
Date:   Mon,  2 Dec 2019 12:59:49 +1100
Message-Id: <20191202015953.127902-1-aik@ozlabs.ru>
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

This is based on sha1
a6ed68d6468b Linus Torvalds "Merge tag 'drm-next-2019-11-27' of git://anongit.freedesktop.org/drm/drm".

Please comment. Thanks.



Alexey Kardashevskiy (4):
  powerpc/powernv/ioda: Rework for huge DMA window at 4GB
  powerpc/powernv/ioda: Allow smaller TCE table levels
  powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
  vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB

 arch/powerpc/include/asm/iommu.h              |   1 +
 arch/powerpc/include/asm/opal-api.h           |  11 +-
 arch/powerpc/include/asm/opal.h               |   2 +
 arch/powerpc/platforms/powernv/pci.h          |   1 +
 include/uapi/linux/vfio.h                     |   2 +
 arch/powerpc/platforms/powernv/opal-call.c    |   2 +
 arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     | 219 ++++++++++++++----
 drivers/vfio/vfio_iommu_spapr_tce.c           |  10 +-
 9 files changed, 202 insertions(+), 50 deletions(-)

-- 
2.17.1

