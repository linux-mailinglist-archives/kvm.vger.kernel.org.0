Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D33787511
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbjHXQRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242482AbjHXQQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:16:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C0F19BD;
        Thu, 24 Aug 2023 09:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692893818; x=1724429818;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oLQ8yqhHS6tkE8jXcexqhkAuSmLocZUzhSD97p4u0N4=;
  b=XCrjt8OjZ2U6uZpVbaVg1hsLh/AQWJVnWkS/5uLdkZBI6QH8uzzSzTgJ
   bFAOHBm/uCKQVtL0ilrW9vIs+xrlcJrLE4AU4Lz93B4rzsiHJFd1gPpw2
   FzfC7EJnQ72CFql2yraqMCNSdCh8czRgMcKt3Rzj07UInyNAkUmFTn3q0
   5ZTJqaXc9NvDUt/MoSxXGSgT0dRCu55MSzxRvpHcxhaZbQAzdhWUtkF8p
   O6DlqS769ZAOzaCJWhIZQF9Z8/c7nmQxY9kQGiAjFCWbklHEcW65Lixio
   ecwWhXZ6XtblbSgLjd9Xjm63CCaUwpiBVBmYMPKC/vbDjm04MiAq5aOJj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="364679232"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="364679232"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="686970902"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="686970902"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] vfio/ims: Back guest interrupts from Interrupt Message Store (IMS)
Date:   Thu, 24 Aug 2023 09:15:19 -0700
Message-Id: <cover.1692892275.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

This series introduces a VFIO library (VFIO PCI IMS) for use by
virtual devices that support MSI-X interrupts that are backed by IMS
interrupts on the host. Specifically, that means that when the virtual
device's VFIO_DEVICE_SET_IRQS ioctl() receives a "trigger interrupt"
(VFIO_IRQ_SET_ACTION_TRIGGER) for a MSI-X index then VFIO PCI IMS
allocates/frees an IMS interrupt on the host.

An IMS interrupt is allocated via pci_ims_alloc_irq() that requires
an implementation specific cookie that is opaque to VFIO PCI IMS. This
can be a PASID, queue ID, pointer etc. During initialization
VFIO PCI IMS learns which PCI device to operate on and what the
default cookie should be for any new interrupt allocation. VFIO PCI
IMS can also associate a unique cookie with each vector and to maintain
this association the library maintains interrupt contexts for the virtual
device's lifetime.

Guests may access a virtual device via both 'direct-path', where the
guest interacts directly with the underlying hardware, and 'intercepted
path', where the virtual device emulates operations. VFIO PCI IMS
supports emulated interrupts (better naming suggestions are welcome) to
handle 'intercepted path' operations where completion interrupts are
signaled from the virtual device, not the underlying hardware.

This library has been tested with a yet to be published VFIO
driver for the Intel Data Accelerators (IDXD) present in Intel Xeon
CPUs.

While this series contains a working implementation it is presented
as an RFC with the goal to obtain feedback on whether VFIO PCI IMS
is appropriate for inclusion into VFIO and whether it is
(or could be adapted to be) appropriate for support of other
planned IMS usages you may be aware of.

Any feedback will be greatly appreciated.

Reinette

Reinette Chatre (3):
  vfio/pci: Introduce library allocating from Interrupt Message Store
    (IMS)
  vfio/ims: Support emulated interrupts
  vfio/ims: Add helper that returns IMS index

 drivers/vfio/pci/Kconfig        |  12 +
 drivers/vfio/pci/Makefile       |   2 +
 drivers/vfio/pci/vfio_pci_ims.c | 499 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  81 ++++++
 4 files changed, 594 insertions(+)
 create mode 100644 drivers/vfio/pci/vfio_pci_ims.c


base-commit: a5e505a99ca748583dbe558b691be1b26f05d678
-- 
2.34.1

