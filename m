Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E637D9E70
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbjJ0RBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345949AbjJ0RBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A5A129;
        Fri, 27 Oct 2023 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426086; x=1729962086;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ozauHBHFBRnrgh+ZXhGMkwr2BhhLLIA0u+Wcz+Cgya8=;
  b=JSGiRJz+nKBRgRmQq+GO0jTutFp9lZxuEheEWX6vlxx+FhnhO2vcqN11
   IBM8cJkfLDnUjEW/MXyu03we2Ut5d3jv4aBQbzJRWi1gwaczUdOFI/2mb
   Lh3SElnNqHJnz8ooOxVSS9WBMRWtsQg/Iu4FH6ly3PHJ7GnHVQNikcUeM
   LBhQ6UKNbxgtrniYdPTvLRM3J/Kq8TMrcDG0nanNACdovU6Is+UY9trfu
   ytHizwaxLUwwRguyIy2fVmZvbkpHpbiw1w9KpNJjAX1xLtR/huWYDMPI8
   V06Fv3s0sroOxqGtZKIQ+gTT7YynFWZKSIsJwNdVdhA9SCLXobNfJhm/j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611816"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611816"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988138"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988138"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:12 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from Interrupt Message Store (IMS)
Date:   Fri, 27 Oct 2023 10:00:32 -0700
Message-Id: <cover.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since RFC V2:
- RFC V2: https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com/
- Still submiting this as RFC series. I believe that this now matches the
  expectatations raised during earlier reviews. If you agree this is
  the right direction then I can drop the RFC prefix on next submission.
  If you do not agree then please do let me know where I missed
  expectations.
- First patch (PCI/MSI: Provide stubs for IMS functions)
  has been submitted upstream separately and is queued for inclusion during
  the next merge window. I do still include it in this series to avoid
  the noise about issues that bots will find when checking this series
  without it included.
  https://lore.kernel.org/lkml/169757242009.3135.5502383859327174030.tip-bot2@tip-bot2/
- Eliminated duplicate code between the PCI passthrough device backend and
  the IMS backend through more abstraction within the interrupt management
  frontend. (Kevin)
- Emulated interrupts are now managed by the interrupt management
  frontend and no longer unique to IMS. (Jason and Kevin)
- Since being an emulated interrupt is a persistent property there is
  a new functional change to PCI interrupt management in that per-interrupt
  contexts (managed by frontend) are now persistent (they remain allocated
  until device release).
- Most of the patches from RFC V2 look the same with more patches
  added to support the additional abstraction needed to eliminate the
  duplicate code. The IMS support was refactored to benefit from the
  new abstraction. Please refer to individual patches for specific changes.

Changes since RFC V1:
- RFC V1: https://lore.kernel.org/lkml/cover.1692892275.git.reinette.chatre@intel.com/
- This is a complete rewrite based on feedback from Jason and Kevin.
  Primarily the transition is to make IMS a new backend of MSI-X
  emulation: VFIO PCI transitions to be an interrupt management frontend
  with existing interrupt management for PCI passthrough devices as a
  backend and IMS interrupt management introduced as a new backend.
  The first part of the series splits VFIO PCI interrupt
  management into a "frontend" and "backend" with the existing PCI
  interrupt management as its first backend. The second part of the
  series adds IMS interrupt management as a new interrupt management
  backend.
  This is a significant change from RFC V1 as well as in the impact of
  the changes on existing VFIO PCI. This was done in response to
  feedback that I hope I understood as intended. If I did not get it
  right, please do point out to me where I went astray and I'd be
  happy to rewrite. Of course, suggestions for improvement will
  be much appreciated.

Hi Everybody,

With Interrupt Message Store (IMS) support introduced in
commit 0194425af0c8 ("PCI/MSI: Provide IMS (Interrupt Message Store)
support") a device can create a secondary interrupt domain that works
side by side with MSI-X on the same device. IMS allows for
implementation-specific interrupt storage that is managed by the
implementation specific interrupt chip associated with the IMS domain
at the time it (the IMS domain) is created for the device via
pci_create_ims_domain().

An example usage of IMS is for devices that can have their resources
assigned to guests with varying granularity. For example, an
accelerator device may support many workqueues and a single workqueue
can be composed into a virtual device for use by a guest. Using
IMS interrupts for the guest preserves MSI-X for host usage while
allowing a significantly larger number of interrupt vectors than
allowed by MSI-X. All while enabling usage of the same device driver
within the host and guest.

This series introduces IMS support to VFIO PCI for use by
virtual devices that support MSI-X interrupts that are backed by IMS
interrupts on the host. Specifically, that means that when the virtual
device's VFIO_DEVICE_SET_IRQS ioctl() receives a "trigger interrupt"
(VFIO_IRQ_SET_ACTION_TRIGGER) for a MSI-X index then VFIO PCI IMS
allocates/frees an IMS interrupt on the host.

VFIO PCI assumes that it is managing interrupts of a passthrough PCI
device. Split VFIO PCI into a "frontend" and "backend" to support
interrupt management for virtual devices that are not passthrough PCI
devices. The VFIO PCI frontend directs guest requests to the
appropriate backend. Existing interrupt management for passthrough PCI
devices is the first backend, guest MSI-X interrupts backed by
IMS interrupts on the host is the new backend (VFIO PCI IMS).

An IMS interrupt is allocated via pci_ims_alloc_irq() that requires
an implementation specific cookie that is opaque to VFIO PCI IMS. This
can be a PASID, queue ID, pointer etc. During initialization
VFIO PCI IMS learns which PCI device to operate on and what the
default cookie should be for any new interrupt allocation. VFIO PCI
IMS can also associate a unique cookie with each vector.

Guests may access a virtual device via both 'direct-path', where the
guest interacts directly with the underlying hardware, and 'intercepted
path', where the virtual device emulates operations. VFIO PCI
supports emulated interrupts (better naming suggestions are welcome) to
handle 'intercepted path' operations where completion interrupts are
signaled from the virtual device, not the underlying hardware.

This has been tested with a yet to be published VFIO driver for the
Intel Data Accelerators (IDXD) present in Intel Xeon CPUs.

While this series contains a working implementation it is presented
as an RFC with the goal to obtain feedback on whether VFIO PCI IMS
is appropriate for inclusion into VFIO and whether it is
(or could be adapted to be) appropriate for support of other
planned IMS usages you may be aware of.

Any feedback will be greatly appreciated.

Reinette

Reinette Chatre (26):
  PCI/MSI: Provide stubs for IMS functions
  vfio/pci: Move PCI specific check from wrapper to PCI function
  vfio/pci: Use unsigned int instead of unsigned
  vfio/pci: Make core interrupt callbacks accessible to all virtual
    devices
  vfio/pci: Split PCI interrupt management into front and backend
  vfio/pci: Separate MSI and MSI-X handling
  vfio/pci: Move interrupt eventfd to interrupt context
  vfio/pci: Move mutex acquisition into function
  vfio/pci: Move per-interrupt contexts to generic interrupt struct
  vfio/pci: Move IRQ type to generic interrupt context
  vfio/pci: Provide interrupt context to irq_is() and is_irq_none()
  vfio/pci: Provide interrupt context to generic ops
  vfio/pci: Provide interrupt context to vfio_msi_enable() and
    vfio_msi_disable()
  vfio/pci: Let interrupt management backend interpret interrupt index
  vfio/pci: Move generic code to frontend
  vfio/pci: Split interrupt context initialization
  vfio/pci: Make vfio_pci_set_irqs_ioctl() available
  vfio/pci: Preserve per-interrupt contexts
  vfio/pci: Store Linux IRQ number in per-interrupt context
  vfio/pci: Separate frontend and backend code during interrupt
    enable/disable
  vfio/pci: Replace backend specific calls with callbacks
  vfio/pci: Introduce backend specific context initializer
  vfio/pci: Support emulated interrupts
  vfio/pci: Add core IMS support
  vfio/pci: Add accessor for IMS index
  vfio/pci: Support IMS cookie modification

 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/pci/vfio_pci_core.c   |  50 +-
 drivers/vfio/pci/vfio_pci_intrs.c  | 758 ++++++++++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_priv.h   |   2 +-
 include/linux/pci.h                |  34 +-
 include/linux/vfio_pci_core.h      |  87 +++-
 6 files changed, 756 insertions(+), 177 deletions(-)


base-commit: 611da07b89fdd53f140d7b33013f255bf0ed8f34
-- 
2.34.1

