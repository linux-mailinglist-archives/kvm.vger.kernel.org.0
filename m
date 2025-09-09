Return-Path: <kvm+bounces-57150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7512DB5088A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDE343B8F00
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11CC62652A2;
	Tue,  9 Sep 2025 22:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U7gXYCJW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF198244665;
	Tue,  9 Sep 2025 22:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455210; cv=none; b=Seq0pPr4LUY4nYp/TbD4uFdeF8JGZFCGp4bq1so//ki9CfCuo0qwUekZ2Dm++X6ZuwXdHRp2zSJPpZZvINT8/+cxsbBTuxGGtAzMr3yvdz2IX+zmPTPw8PHXKvDPW5ADAbeHTgCCXdS6C8z5CqhyKY3g9dkJ0oqVFOc9RrKcI2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455210; c=relaxed/simple;
	bh=3MEHUK/+TcOWsAEbKAhaeb7droOEVMg1d8lQHuKDljY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=H68aFdZzSkdmQ0MvffGz2Vm8ndyuO/dJ3OC190juTSFwfrHrtdbOTY3XerYh8w1rcFuiVh/KRIC4E4BkYxRswerftNc002D2OKWAKrUCAzPWLL3xI8VBLYmiMVPMgT+i1UG5f8ycDZf5HfpEzxyS+wITdQO90bA+QTzSlhqZjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U7gXYCJW; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455209; x=1788991209;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=3MEHUK/+TcOWsAEbKAhaeb7droOEVMg1d8lQHuKDljY=;
  b=U7gXYCJW/B3nowEnMyP7tbUuhUJemqtYNjY2ZJ1r50N4FFALWcvc/Vwm
   /bm90zYUX4N3sk7R5Xl3LFGkMgZ7rvn6RI8Ugxv7m87fzTDyQkrvjpPxw
   NuymSP/4UuLNPIYPE4iXCvq6RgkaWiZHHLNDsFPJu/Cp6EAWOTBYxrjI4
   g4ehNoZzo3zlgV57ubRhkdxa1EiUnHSmZk0uLh+NuG9g+NnMRTRx1FzxJ
   pL4m3G/VqvqcKDG8CVC+g469nrGV/0Gre8E0rt5gztUp+urupj8edz/Ut
   BEfZAJxzR+y33k9/HaSWhSVlbaIgcKMWLEAcrVDq1XjQ6G6npQWwGAUbC
   w==;
X-CSE-ConnectionGUID: ZymuJ1TrQ+a85k4q1+fwfA==
X-CSE-MsgGUID: gGxzLhBCRNa2AzHt8t1bpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584609"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584609"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
X-CSE-ConnectionGUID: vQSzBUM+RkCBUdEKy7pqxQ==
X-CSE-MsgGUID: idV5QM8zSBa4OiHDcFgJCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780949"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:07 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH RFC net-next 0/7] ice: implement live migration driver for
 E800 series hardware
Date: Tue, 09 Sep 2025 14:57:49 -0700
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN6iwGgC/43PwU7DMAwG4FeZcibITuLRckJC4gG4Ig4ldbZA1
 6I2ioamvjteLq16qnL6I+v77ZuaeIw8qefDTY2c4xSHXgI+HJQ/N/2JdWwlKwOGAC1orhB0FzP
 rSzyNTZJ5/f2zCqnL2lrP5LFFsE4J9TtyiNdS86He317vfz0n3fM1qU8J5zilYfwra2QsY6XRg
 d3XmFGDdkTUYO2Qq+ol9om7Rz9cSkE2KxTdTtQIWtU1Ah19Y9uwRe2CytuJWkFly1C5RkzELeo
 W9Ah7N3WChpoCQgjeAG9RWtAazE6U7ucTtJYsfBl6WqPzPP8DioNkqj0CAAA=
X-Change-ID: 20250130-e810-live-migration-jk-migration-tlv-33ce5c1d1034
To: Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jacob Keller <jacob.e.keller@intel.com>, 
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>
X-Mailer: b4 0.15-dev-c61db
X-Developer-Signature: v=1; a=openpgp-sha256; l=5432;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=3MEHUK/+TcOWsAEbKAhaeb7droOEVMg1d8lQHuKDljY=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi1NceL0Y0+7P1pF9/TywhfPx6qIH6668nuMjtWVW3
 tm/T2qrOkpZGMS4GGTFFFkUHEJWXjeeEKb1xlkOZg4rE8gQBi5OAZgIix3DP7WG+wFT18vm95wJ
 FvroycMmaOA4d/mc57s7zJ0yl90PjmH4H6OxebvWPqEac5vFDPOqftw+7Fp5oFj619oT6o08RRW
 P2QE=
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

This series implements the QEMU/KVM live migration support for the ice E800
series hardware. It is a long-overdue followup to the version from Yahui
back in 2023. That version itself is an evolution of the original v1
protocol from some years before that.

This version is a significant rework and complete replaces the
virtchnl message based approach with one based on the PF serializing state
via a custom Type-Length-Value format.

This solution significantly reduces the impact a VF can have on the payload
size, as the size is no longer based directly on messages sent by the VF.
It also ensures that other data such as host-based RSS and MSI-X is sent,
which previously was ignored since there were no equivalent virtchnl
messages.

Finally, replay can now be ordered to safely restore Tx and Rx queues
without needing hacks to the virtchnl initialization flows, and the driver
now only holds migration data for a short limited time while suspending,
rather than requiring we save every virtchnl message the VF sends for the
life time of the VF.

To test this, I used QEMU/KVM:

  echo 2 >/sys/class/net/enp175s0f0np0/device/sriov_numvfs

  echo "0000:af:01.0" >/sys/bus/pci/drivers/iavf/unbind
  echo "0000:af:01.1" >/sys/bus/pci/drivers/iavf/unbind

  modprobe ice_vfio_pci

  echo "8086 1889" >/sys/bus/pci/drivers/ice-vfio-pci/new_id

I've tested with QEMU using the "enable-migration=on" and
"x-pre-copy-dirty-page-tracking=off" settings, as we do not currently
support dirty page tracking.

The initial host QEMU instance is launched as usual, while the target QEMU
instance is launched with the -incoming tcp:localhost:4444 option.

To initiate migration you can issue the migration command from the QEMU
console:

  migrate tcp:localhost:4444

I've tested with and without traffic, and I tried to cover a wide variety
of VF settings and configuration.

REVIEWER NOTES AND REQUESTS:

  I am sending this as RFC to the netdev and VFIO mailing lists, as I am
  uncertain what the preferred path for merging is. I am also awaiting
  testing from Intel's virtualization team.

  I've managed to reduce the overall patch series size as much as possible
  by sending many of the cleanups ahead of time. These have finally all
  merged into net-next.

  This work is based on the original live migration patches from Yahui.
  However, the ice driver implementation is entirely rewritten. The VFIO
  driver code is still primarily Yahui's, with some minor alterations and
  cleanups applied.

  I decided to separate the deferred reset logic in the VFIO driver to its
  own patch, and am open to alternative suggestions for resolving this
  potential deadlock. I saw a similar deferred logic in other drivers. I
  have thus far not come up with a better solution.

  The biggest remaining gap on the ice driver side is that I don't have a
  good idea how to best plan for future VF enhancements. Currently, all the
  existing configuration and features now work. However, a future feature
  might require new migration data, and I don't have a good idea how to
  make the driver safely disable such features until they're supported
  within the migration.

  The TLV format does allow for extension, (both with a full version field
  and with passing the set of known TLVs). However, the driver likely could
  use some sort of infrastructure so that new VF virtchnl commands or
  features get blocked by default until they are confirmed to work with
  migration. Suggestions on how best to implement that are welcome.

Link: https://lore.kernel.org/netdev/20231121025111.257597-1-yahui.cao@intel.com/
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Jacob Keller (7):
      ice: add basic skeleton and TLV framework for live migration support
      ice: implement device suspension for live migration
      ice: add migration TLV for basic VF information
      ice: add migration TLVs for queue and interrupt state
      ice: add remaining migration TLVs
      ice-vfio-pci: add ice VFIO PCI live migration driver
      ice-vfio-pci: implement PCI .reset_done handling

 drivers/net/ethernet/intel/ice/ice.h               |    2 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |    8 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |    2 +
 .../net/ethernet/intel/ice/virt/migration_tlv.h    |  495 +++++
 include/linux/net/intel/ice_migration.h            |   49 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   16 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    3 +
 drivers/net/ethernet/intel/ice/virt/migration.c    | 2147 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/virt/queues.c       |   21 +
 drivers/vfio/pci/ice/main.c                        |  764 +++++++
 MAINTAINERS                                        |    7 +
 drivers/net/ethernet/intel/ice/Makefile            |    1 +
 drivers/vfio/pci/Kconfig                           |    2 +
 drivers/vfio/pci/Makefile                          |    2 +
 drivers/vfio/pci/ice/Kconfig                       |    8 +
 drivers/vfio/pci/ice/Makefile                      |    4 +
 16 files changed, 3531 insertions(+)
---
base-commit: 3b4296f5893d3a4e19edfc3800cb79381095e55f
change-id: 20250130-e810-live-migration-jk-migration-tlv-33ce5c1d1034

Best regards,
--  
Jacob Keller <jacob.e.keller@intel.com>


