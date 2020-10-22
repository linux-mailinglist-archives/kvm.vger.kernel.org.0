Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1830C296413
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368333AbgJVRwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:52:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368308AbgJVRwE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Oct 2020 13:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603389122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Snym3up3V+Jaq0VoNL6Bf+mG/o9VEWmu15l14qW0Ezk=;
        b=HsazYTo14z6lwcl7LUJ3FQ7pG7jDOug5XxgjlKpej0aMZWNVfrvKuZk6qdWOpUMA2MvS7x
        eKV1hBv4VDzvIYbmp7XAiCN/aJadQY3pqa+256+thxwrRJzoEYzN1SqR/XFBch1Ky/GGvp
        D2MMiWGHPygPQ2EPnMXuTMnenDNnTRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-hOLuj33oMqSIV1a9CNuMAw-1; Thu, 22 Oct 2020 13:52:00 -0400
X-MC-Unique: hOLuj33oMqSIV1a9CNuMAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B36AA107ACF8;
        Thu, 22 Oct 2020 17:51:58 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 510515D9CC;
        Thu, 22 Oct 2020 17:51:58 +0000 (UTC)
Date:   Thu, 22 Oct 2020 11:51:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [GIT PULL] VFIO updates for v5.10-rc1
Message-ID: <20201022115157.597fa544@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit ba4f184e126b751d1bffad5897f263108befc780:

  Linux 5.9-rc6 (2020-09-20 16:33:55 -0700)

are available in the Git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v5.10-rc1

for you to fetch changes up to 2e6cfd496f5b57034cf2aec738799571b5a52124:

  vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages (2020-10-20 10:12:17 -0600)


Please note, this tag has a minor merge conflict with the s390
tree as Vasily noted in his pull request[1] and originally found
by Stephen[2] in linux-next.  The resolution is:

diff --cc arch/s390/pci/pci_bus.c
index 0c0db7c3a404,c93486a9989b..755b46f4c595
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@@ -135,9 -197,10 +135,10 @@@ void pcibios_bus_add_device(struct pci_
  	 * With pdev->no_vf_scan the common PCI probing code does not
  	 * perform PF/VF linking.
  	 */
- 	if (zdev->vfn)
+ 	if (zdev->vfn) {
 -		zpci_bus_setup_virtfn(zdev->zbus, pdev, zdev->vfn);
 +		zpci_iov_setup_virtfn(zdev->zbus, pdev, zdev->vfn);
- 
+ 		pdev->no_command_memory = 1;
+ 	}
  }
  
  static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)

[1]https://lore.kernel.org/lkml/your-ad-here.call-01602846038-ext-6012@work.hours/
[2]https://lore.kernel.org/lkml/20200924142651.28382ed7@canb.auug.org.au/

----------------------------------------------------------------
VFIO updates for v5.10-rc1

 - New fsl-mc vfio bus driver supporting userspace drivers of objects
   within NXP's DPAA2 architecture (Diana Craciun)

 - Support for exposing zPCI information on s390 (Matthew Rosato)

 - Fixes for "detached" VFs on s390 (Matthew Rosato)

 - Fixes for pin-pages and dma-rw accesses (Yan Zhao)

 - Cleanups and optimize vconfig regen (Zenghui Yu)

 - Fix duplicate irq-bypass token registration (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (3):
      Merge branches 'v5.10/vfio/bardirty', 'v5.10/vfio/dma_avail', 'v5.10/vfio/misc', 'v5.10/vfio/no-cmd-mem' and 'v5.10/vfio/yan_zhao_fixes' into v5.10/vfio/next
      Merge branches 'v5.10/vfio/fsl-mc-v6' and 'v5.10/vfio/zpci-info-v3' into v5.10/vfio/next
      vfio/pci: Clear token on bypass registration failure

Bharat Bhushan (1):
      vfio/fsl-mc: Add VFIO framework skeleton for fsl-mc devices

Diana Craciun (12):
      vfio/fsl-mc: Scan DPRC objects on vfio-fsl-mc driver bind
      vfio/fsl-mc: Implement VFIO_DEVICE_GET_INFO ioctl
      vfio/fsl-mc: Implement VFIO_DEVICE_GET_REGION_INFO ioctl call
      vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions
      vfio/fsl-mc: Added lock support in preparation for interrupt handling
      vfio/fsl-mc: Add irq infrastructure for fsl-mc devices
      vfio/fsl-mc: trigger an interrupt via eventfd
      vfio/fsl-mc: Add read/write support for fsl-mc devices
      vfio/fsl-mc: Add support for device reset
      vfio/fsl-mc: Fixed vfio-fsl-mc driver compilation on 32 bit
      vfio/fsl-mc: Fix the dead code in vfio_fsl_mc_set_irq_trigger
      vfio/fsl-mc: fix the return of the uninitialized variable ret

Matthew Rosato (9):
      PCI/IOV: Mark VFs as not implementing PCI_COMMAND_MEMORY
      vfio iommu: Add dma available capability
      s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY
      vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn
      s390/pci: stash version in the zpci_dev
      s390/pci: track whether util_str is valid in the zpci_dev
      vfio: Introduce capability definitions for VFIO_DEVICE_GET_INFO
      vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO
      MAINTAINERS: Add entry for s390 vfio-pci

Xiaoyang Xu (1):
      vfio iommu type1: Fix memory leak in vfio_iommu_type1_pin_pages

Yan Zhao (3):
      vfio: add a singleton check for vfio_group_pin_pages
      vfio: fix a missed vfio group put in vfio_pin_pages
      vfio/type1: fix dirty bitmap calculation in vfio_dma_rw

Zenghui Yu (3):
      vfio: Fix typo of the device_state
      vfio/pci: Remove redundant declaration of vfio_pci_driver
      vfio/pci: Don't regenerate vconfig for all BARs if !bardirty

 MAINTAINERS                               |  14 +
 arch/s390/include/asm/pci.h               |   4 +-
 arch/s390/pci/pci_bus.c                   |   5 +-
 arch/s390/pci/pci_clp.c                   |   2 +
 drivers/pci/iov.c                         |   1 +
 drivers/vfio/Kconfig                      |   1 +
 drivers/vfio/Makefile                     |   1 +
 drivers/vfio/fsl-mc/Kconfig               |   9 +
 drivers/vfio/fsl-mc/Makefile              |   4 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 683 ++++++++++++++++++++++++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c    | 194 +++++++++
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  55 +++
 drivers/vfio/pci/Kconfig                  |  12 +
 drivers/vfio/pci/Makefile                 |   1 +
 drivers/vfio/pci/vfio_pci.c               |  38 +-
 drivers/vfio/pci/vfio_pci_config.c        |  27 +-
 drivers/vfio/pci/vfio_pci_intrs.c         |   4 +-
 drivers/vfio/pci/vfio_pci_private.h       |  12 +
 drivers/vfio/pci/vfio_pci_zdev.c          | 143 +++++++
 drivers/vfio/vfio.c                       |   9 +-
 drivers/vfio/vfio_iommu_type1.c           |  23 +-
 include/linux/pci.h                       |   1 +
 include/uapi/linux/vfio.h                 |  29 +-
 include/uapi/linux/vfio_zdev.h            |  78 ++++
 24 files changed, 1330 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/fsl-mc/Kconfig
 create mode 100644 drivers/vfio/fsl-mc/Makefile
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc.c
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
 create mode 100644 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
 create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
 create mode 100644 include/uapi/linux/vfio_zdev.h

