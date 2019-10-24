Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912CFE29C1
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 07:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437451AbfJXFIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 01:08:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:7748 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfJXFIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 01:08:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 22:08:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,223,1569308400"; 
   d="scan'208";a="197627623"
Received: from debian-nuc.sh.intel.com ([10.239.160.133])
  by fmsmga007.fm.intel.com with ESMTP; 23 Oct 2019 22:08:32 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        kevin.tian@intel.com, cohuck@redhat.com
Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
Date:   Thu, 24 Oct 2019 13:08:23 +0800
Message-Id: <20191024050829.4517-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a refresh for previous send of this series. I got impression that
some SIOV drivers would still deploy their own create and config method so
stopped effort on this. But seems this would still be useful for some other
SIOV driver which may simply want capability to aggregate resources. So here's
refreshed series.

Current mdev device create interface depends on fixed mdev type, which get uuid
from user to create instance of mdev device. If user wants to use customized
number of resource for mdev device, then only can create new mdev type for that
which may not be flexible. This requirement comes not only from to be able to
allocate flexible resources for KVMGT, but also from Intel scalable IO
virtualization which would use vfio/mdev to be able to allocate arbitrary
resources on mdev instance. More info on [1] [2] [3].

To allow to create user defined resources for mdev, it trys to extend mdev
create interface by adding new "aggregate=xxx" parameter following UUID, for
target mdev type if aggregation is supported, it can create new mdev device
which contains resources combined by number of instances, e.g

    echo "<uuid>,aggregate=10" > create

VM manager e.g libvirt can check mdev type with "aggregation" attribute which
can support this setting. If no "aggregation" attribute found for mdev type,
previous behavior is still kept for one instance allocation. And new sysfs
attribute "aggregated_instances" is created for each mdev device to show allocated number.

References:
[1] https://software.intel.com/en-us/download/intel-virtualization-technology-for-directed-io-architecture-specification
[2] https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf

Zhenyu Wang (6):
  vfio/mdev: Add new "aggregate" parameter for mdev create
  vfio/mdev: Add "aggregation" attribute for supported mdev type
  vfio/mdev: Add "aggregated_instances" attribute for supported mdev
    device
  Documentation/driver-api/vfio-mediated-device.rst: Update for
    vfio/mdev aggregation support
  Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev
    aggregation support
  drm/i915/gvt: Add new type with aggregation support

 Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
 .../driver-api/vfio-mediated-device.rst       | 23 ++++++
 drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
 drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
 drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
 drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
 drivers/vfio/mdev/mdev_private.h              |  6 +-
 drivers/vfio/mdev/mdev_sysfs.c                | 79 ++++++++++++++++++-
 include/linux/mdev.h                          | 19 +++++
 10 files changed, 294 insertions(+), 17 deletions(-)

-- 
2.24.0.rc0

