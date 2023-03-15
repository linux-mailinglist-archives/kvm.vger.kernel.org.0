Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC106BBE5A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjCOVAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjCOU7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5026F62B;
        Wed, 15 Mar 2023 13:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913985; x=1710449985;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hb7D1RXhRsrwRGeWcZ1vlY8kv9USBsZ/ZzQZjyvq4g4=;
  b=ksslGtIRpoWFPafgl+eJxGNFSbT9xphvRcCGDyTf2KmPxuZ5Msw0XATY
   GPaSdKzBm9ZmC8Jnk/nhIqlDcQkY5zzvPn9voTYcqBzfynps1aE0dBdot
   sFvyQnLSs8ppVDTKVTa/SfRelZxI6EbHQ/HqP/RaNnPOl3Hwsk//cxjer
   1IgnSWSxGgC7M7yDS0COmRtZgL6gHmHkpzigvPAED3VUNfFFpw4UAvvOM
   TPhJ0EEpvwoCEIaX09Ucn600XcT50A1l3TMii0NEP337zqB8WyjRFbxKW
   4LgiGxaDuSzTAkWTSB8tPQ3o5qdFQZD64H8t/+KWa98oq9uYCXKFFLEFX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176495"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176495"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747209"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747209"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/8] vfio/pci: Support dynamic allocation of MSI-X interrupts
Date:   Wed, 15 Mar 2023 13:59:20 -0700
Message-Id: <cover.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

== Cover letter ==

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
support for dynamic MSI-X the flag is cleared for MSI-X, enabling
Qemu to modify its behavior.

== Why is this an RFC ? ==

vfio support for dynamic MSI-X needs to work with existing user space
as well as upcoming user space that takes advantage of this feature.
I would appreciate guidance on the expectations and requirements
surrounding error handling when considering existing user space.

For example, consider the following scenario:
Start: Consider a passthrough device that supports 10 MSI-X interrupts
	(0 to 9) and existing Qemu allocated interrupts 0 to 4.

Scenario: Qemu (hypothetically) attempts to associate a new action to
	interrupts 0 to 7. Early checking of this range in
	vfio_set_irqs_validate_and_prepare() will pass since it
	is a valid range for the device. What happens after the
	early checking is considered next:

Current behavior (before this series): Since the provided range, 0 - 7,
	exceeds the allocated range, no action will be taken on existing
	allocated interrupts 0 - 4 and the Qemu request will fail without
	making any state changes.

New behavior (with this series): Since vfio supports dynamic MSI-X new
	interrupts will be allocated for vectors 5, 6, and 7. Please note
	that this changes the behavior encountered by unmodified Qemu: new
	interrupts are allocated instead of returning an error. Even more,
	since the range provided by Qemu spans 0 - 7, a failure during
	allocation of 5, 6, or 7 will result in release of entire range.

This series aims to maintain existing error behavior for MSI (please see
"vfio/pci: Remove interrupt context counter") but I would appreciate your
guidance on whether existing error behavior should be maintained for MSI-X
and how to do so if it is a requirement.

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

 drivers/vfio/pci/vfio_pci_core.c  |   3 +-
 drivers/vfio/pci/vfio_pci_intrs.c | 376 ++++++++++++++++++++++--------
 include/linux/vfio_pci_core.h     |   3 +-
 include/uapi/linux/vfio.h         |   3 +
 4 files changed, 286 insertions(+), 99 deletions(-)


base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.34.1

