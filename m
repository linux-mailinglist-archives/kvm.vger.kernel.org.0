Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAC7BBCEE
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjJFQl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjJFQlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9A0AD;
        Fri,  6 Oct 2023 09:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610484; x=1728146484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BnxHeCvree896UWaqx9iqbQG2BrZrTAePfLACfL+Aho=;
  b=jkqHw2M8YmT0+VPZVRjUIDGfdpr7wLBokNFVlvJK24pbWh88ZkFhe9Db
   vRnAWv9B4esmjwXf1Re4CF7eUWtUWYAYSyqFpiU89+O7jG/YSd1nf7e5x
   +itFwWolmPznNwLV4u+rYH9PdQ45QNTSBv11xhoYgkvpjVEwQqg/UFONt
   WnWMtCQOsYid2zzpAql2Y2HNPEQfnYk7rOxKV2oQPwIZYkPs+bhtrinYm
   wo65LLgXTC5y42qBWENAeHpunCOkJC6BbiHaykT0GEDgLvmHKzEqFf0su
   YCfYcgx6Ym6Frzd9mRXggRkHZeP+lUGmdxCx3LE6p3Egn3JB4k4Z4gCW3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063147"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063147"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892834"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892834"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 00/18]  vfio/pci: Back guest interrupts from Interrupt Message Store (IMS)
Date:   Fri,  6 Oct 2023 09:40:55 -0700
Message-Id: <cover.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
device. VFIO PCI is split into a "frontend" and "backend" to support
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
IMS can also associate a unique cookie with each vector and to maintain
this association the backend maintains interrupt contexts for the virtual
device's lifetime.

Guests may access a virtual device via both 'direct-path', where the
guest interacts directly with the underlying hardware, and 'intercepted
path', where the virtual device emulates operations. VFIO PCI
supports emulated interrupts (better naming suggestions are welcome) to
handle 'intercepted path' operations where completion interrupts are
signaled from the virtual device, not the underlying hardware. Backend
support is required for emulated interrupts and only VFIO PCI IMS
backend supports emulated interrupts in this series.

This has been tested with a yet to be published VFIO driver for the
Intel Data Accelerators (IDXD) present in Intel Xeon CPUs.

While this series contains a working implementation it is presented
as an RFC with the goal to obtain feedback on whether VFIO PCI IMS
is appropriate for inclusion into VFIO and whether it is
(or could be adapted to be) appropriate for support of other
planned IMS usages you may be aware of.

Any feedback will be greatly appreciated.

Reinette

Reinette Chatre (18):
  PCI/MSI: Provide stubs for IMS functions
  vfio/pci: Move PCI specific check from wrapper to PCI function
  vfio/pci: Use unsigned int instead of unsigned
  vfio/pci: Make core interrupt callbacks accessible to all virtual
    devices
  vfio/pci: Split PCI interrupt management into front and backend
  vfio/pci: Separate MSI and MSI-X handling
  vfio/pci: Move interrupt eventfd to interrupt context
  vfio/pci: Move mutex acquisition into function
  vfio/pci: Move interrupt contexts to generic interrupt struct
  vfio/pci: Move IRQ type to generic interrupt context
  vfio/pci: Split interrupt context initialization
  vfio/pci: Provide interrupt context to generic ops
  vfio/pci: Make vfio_pci_set_irqs_ioctl() available
  vfio/pci: Add core IMS support
  vfio/pci: Support emulated interrupts
  vfio/pci: Support emulated interrupts in IMS backend
  vfio/pci: Add accessor for IMS index
  vfio/pci: Support IMS cookie modification

 drivers/vfio/pci/vfio_pci_config.c |   2 +-
 drivers/vfio/pci/vfio_pci_core.c   |  50 +--
 drivers/vfio/pci/vfio_pci_intrs.c  | 658 ++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_priv.h   |   2 +-
 include/linux/pci.h                |  31 +-
 include/linux/vfio_pci_core.h      |  70 ++-
 6 files changed, 706 insertions(+), 107 deletions(-)


base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
-- 
2.34.1

