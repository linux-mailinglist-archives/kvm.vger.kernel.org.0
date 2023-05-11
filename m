Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5356FF646
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238454AbjEKPo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbjEKPoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:44:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDCED7;
        Thu, 11 May 2023 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819894; x=1715355894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UPzRdwh80F7gww+xL3tYd6eQrJ5u7CiNTO8sjTFxYz8=;
  b=WwchiOZ/dPsMt2jhO+sAHKVyBiqoiB1S6y2FLy5zaYjm7GHMyo1x+KWX
   lkWVrPHVzps9wA7CqE0TjqvX4kQjk6LueoLU9OG7IXDsePqZ8DoW90YIa
   W1JKW6RLxtg5Vb3QQYp6eJVCYjyYJQbNYxjjtx241yO+lUPVfNpRvZR7G
   Kvl2E2ig94Cqo22eguPO4MY4sN88G8NMIdwtN56nUV8UbsiOKqNd5s9Rb
   4uLWY8mRzKVfSQiinGhHaLmZHlTbTaO3F5ZkO5of73okCKhVy+5fgKRse
   5qeVKHE6MgAITsZnqCzIca8pnvBS7AUUDdKXo9sN2cZ9fXNSnqClW6A87
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046640"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046640"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776218"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776218"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 00/11] vfio/pci: Support dynamic allocation of MSI-X interrupts
Date:   Thu, 11 May 2023 08:44:27 -0700
Message-Id: <cover.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changes since V4:
- V4: https://lore.kernel.org/lkml/cover.1682615447.git.reinette.chatre@intel.com/
- Add Kevin's Reviewed-by tag as applicable.
- Treat non-existing INTx interrupt context as kernel bug with WARN. This
  exposed an issue in the scenario where INTx mask/unmask may occur without
  INTx enabled. This is fixed by obtaining the interrupt context later
  (right before use) within impacted functions: vfio_pci_intx_mask() and
  vfio_pci_intx_unmask_handler(). (Kevin)
- Treat pci_irq_vector() returning '0' for a MSI/MSI-X interrupt as a kernel
  bug via a WARN instead of ignoring this value. (Kevin)
- Improve accuracy of comments. (Kevin)
- Please refer to individual patches for local changes.

Changes since V3:
- V3: https://lore.kernel.org/lkml/cover.1681837892.git.reinette.chatre@intel.com/
- Be considerate about layout and size with changes to
  struct vfio_pci_core_device. Keep flags together and transition all to
  use bitfields. (Alex and Jason)
- Do not free dynamically allocated interrupts on error path. (Alex)
- Please refer to individual patches for localized changes.

Changes since V2:
- V2: https://lore.kernel.org/lkml/cover.1680038771.git.reinette.chatre@intel.com/
- During testing of V2 "kernel test robot" reported issues resulting from
  include/linux/pci.h missing a stub for pci_msix_can_alloc_dyn() when
  CONFIG_PCI_MSI=n. A separate fix was sent to address this. The fix can
  be found in the kernel (since v6.3-rc7) as
  commit 195d8e5da3ac ("PCI/MSI: Provide missing stub for pci_msix_can_alloc_dyn()")
- Biggest change is the transition to "active contexts" for both MSI and MSI-X.
  Interrupt contexts have always been allocated when the interrupts are
  allocated while they are only used while interrupts are
  enabled. In this series interrupt contexts are made dynamic, while doing
  so their allocation is moved to match how they are used: allocated when
  interrupts are enabled. Whether a Linux interrupt number exists determines
  whether an interrupt can be enabled.
  Previous policy (up to V2) that an allocated interrupt has an interrupt
  context no longer applies. Instead, an interrupt context has a
  handler/trigger, aka "active contexts". (Alex)
- Re-ordered patches in support of "active contexts".
- Only free interrupts on MSI-X teardown and otherwise use the
  allocated interrupts as a cache. (Alex)
- Using unsigned int for the vector broke the unwind loop within
  vfio_msi_set_block(). (Alex)
- Introduce new "has_dyn_msix" property of virtual device instead of
  querying support every time. (Alex)
- Some smaller changes, please refer to individual patches.

Changes since RFC V1:
- RFC V1: https://lore.kernel.org/lkml/cover.1678911529.git.reinette.chatre@intel.com/
- Improved changelogs.
- Simplify interface so that vfio_irq_ctx_alloc_single() returns pointer to
  allocated context. (Alex)
- Remove vfio_irq_ctx_range_allocated() and associated attempts to maintain
  invalid error path behavior. (Alex and Kevin)
- Add pointer to interrupt context as function parameter to
  vfio_irq_ctx_free(). (Alex)
- Ensure variables are initialized. (Dan Carpenter)
- Only support dynamic allocation if device supports it. (Alex)

Qemu allocates interrupts incrementally at the time the guest unmasks an
interrupt, for example each time a Linux guest runs request_irq().

Dynamic allocation of MSI-X interrupts was not possible until v6.2 [1].
This prompted Qemu to, when allocating a new interrupt, first release all
previously allocated interrupts (including disable of MSI-X) followed
by re-allocation of all interrupts that includes the new interrupt.
Please see [2] for a detailed discussion about this issue.

Releasing and re-allocating interrupts may be acceptable if all
interrupts are unmasked during device initialization. If unmasking of
interrupts occur during runtime this may result in lost interrupts.
For example, consider an accelerator device with multiple work queues,
each work queue having a dedicated interrupt. A work queue can be
enabled at any time with its associated interrupt unmasked while other
work queues are already active. Having all interrupts released and MSI-X
disabled to enable the new work queue will impact active work queues.

This series builds on the recent interrupt sub-system core changes
that added support for dynamic MSI-X allocation after initial MSI-X
enabling.

Add support for dynamic MSI-X allocation to vfio-pci. A flag
indicating lack of support for dynamic allocation already exist:
VFIO_IRQ_INFO_NORESIZE and has always been set for MSI and MSI-X. With
support for dynamic MSI-X the flag is cleared for MSI-X when supported,
enabling Qemu to modify its behavior.

Any feedback is appreciated

Reinette

[1] commit 34026364df8e ("PCI/MSI: Provide post-enable dynamic allocation interfaces for MSI-X")
[2] https://lore.kernel.org/kvm/MWHPR11MB188603D0D809C1079F5817DC8C099@MWHPR11MB1886.namprd11.prod.outlook.com/#t

Reinette Chatre (11):
  vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
  vfio/pci: Remove negative check on unsigned vector
  vfio/pci: Prepare for dynamic interrupt context storage
  vfio/pci: Move to single error path
  vfio/pci: Use xarray for interrupt context storage
  vfio/pci: Remove interrupt context counter
  vfio/pci: Update stale comment
  vfio/pci: Use bitfield for struct vfio_pci_core_device flags
  vfio/pci: Probe and store ability to support dynamic MSI-X
  vfio/pci: Support dynamic MSI-X
  vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X

 drivers/vfio/pci/vfio_pci_core.c  |   8 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 305 ++++++++++++++++++++----------
 include/linux/vfio_pci_core.h     |  26 +--
 include/uapi/linux/vfio.h         |   3 +
 4 files changed, 229 insertions(+), 113 deletions(-)


base-commit: 457391b0380335d5e9a5babdec90ac53928b23b4
-- 
2.34.1

