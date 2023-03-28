Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C930A6CCC50
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjC1VyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjC1VyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B412D45;
        Tue, 28 Mar 2023 14:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040429; x=1711576429;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QmZj2CBQ6APsaWV/5Z3y8VoSMgDtNkhfhFzIrzqpJoI=;
  b=T8C8jYwT7bMV3IwYlHeXG8bJ4nCtOnJ+iVLai8J3JDwJNY3sw4FXhxlk
   VUNwpXb5Hq2cb4Ji4kPGLVDSPNhdM4t4cLbCCMFl8BvNOVc4mTQNNp39j
   GB1UGkQCF0i00KmHoNJBxrP3HDz+p9xJme+5Fit2m/pHx3N+/mQBxQi4i
   Jh66mLegVNPwwlpqqJbTt0gmJ6qg9gRejkPpbQhVpvywC1xg45HN/FwP1
   x1QWnPs0KkpWdvlc0I3T4I/RA9Pb/4GhY3/aC1IIaGle/SSleqZGGmYre
   2Htu38Vu1MCNIJRSMZrbvUELZP3dSjdfW6AZIEm92vi6wJUsAraTYxg+A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316908"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316908"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543762"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543762"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/8] vfio/pci: Support dynamic allocation of MSI-X interrupts
Date:   Tue, 28 Mar 2023 14:53:27 -0700
Message-Id: <cover.1680038771.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Reinette Chatre (8):
  vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
  vfio/pci: Remove negative check on unsigned vector
  vfio/pci: Prepare for dynamic interrupt context storage
  vfio/pci: Use xarray for interrupt context storage
  vfio/pci: Remove interrupt context counter
  vfio/pci: Move to single error path
  vfio/pci: Support dynamic MSI-x
  vfio/pci: Clear VFIO_IRQ_INFO_NORESIZE for MSI-X

 drivers/vfio/pci/vfio_pci_core.c  |   5 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 347 +++++++++++++++++++++---------
 include/linux/vfio_pci_core.h     |   3 +-
 include/uapi/linux/vfio.h         |   3 +
 4 files changed, 257 insertions(+), 101 deletions(-)


base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.34.1

