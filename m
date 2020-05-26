Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618191A62CB
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 08:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgDMGCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 02:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgDMGCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 02:02:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34661C0A3BE0;
        Sun, 12 Apr 2020 23:02:00 -0700 (PDT)
IronPort-SDR: J+h/MBje8AxqNUX6hmRuU4GVAaqWr2uoKhQKt/uhcPmiklveoPpVrJyaVGOpVr+nKwH9OXIx2f
 HYUziwvH9OIQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 23:01:59 -0700
IronPort-SDR: O5wdGuyQlc7bo5KmVytTBytv4gIaY33RmF0q8WDMiPNVI4GCYyrC5X6Yd4Ae+HQAXSFb7BKflg
 896Qwv3gpldQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,377,1580803200"; 
   d="scan'208";a="453054045"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2020 23:01:52 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     libvir-list@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, xin.zeng@intel.com,
        ziye.yang@intel.com, mlevitsk@redhat.com, pasic@linux.ibm.com,
        felipe@nutanix.com, changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        alex.williamson@redhat.com, eskultet@redhat.com,
        dgilbert@redhat.com, cohuck@redhat.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, cjia@nvidia.com,
        kwankhede@nvidia.com, berrange@redhat.com, dinechin@redhat.com,
        corbet@lwn.net, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v5 0/4] introduction of migration_version attribute for VFIO live migration
Date:   Mon, 13 Apr 2020 01:52:01 -0400
Message-Id: <20200413055201.27053-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset introduces a migration_version attribute under sysfs of VFIO
Mediated devices.

This migration_version attribute is used to check migration compatibility
between two mdev devices.

Currently, it has two locations:
(1) under mdev_type node,
    which can be used even before device creation, but only for mdev
    devices of the same mdev type.
(2) under mdev device node,
    which can only be used after the mdev devices are created, but the src
    and target mdev devices are not necessarily be of the same mdev type
(The second location is newly added in v5, in order to keep consistent
with the migration_version node for migratable pass-though devices)

Patch 1 defines migration_version attribute for the first location in
Documentation/vfio-mediated-device.txt

Patch 2 uses GVT as an example for patch 1 to show how to expose
migration_version attribute and check migration compatibility in vendor
driver.

Patch 3 defines migration_version attribute for the second location in
Documentation/vfio-mediated-device.txt

Patch 4 uses GVT as an example for patch 3 to show how to expose
migration_version attribute and check migration compatibility in vendor
driver.

(The previous "Reviewed-by" and "Acked-by" for patch 1 and patch 2 are
kept in v5, as there are only small changes to commit messages of the two
patches.)

v5:
added patch 2 and 4 for mdev device part of migration_version attribute.

v4:
1. fixed indentation/spell errors, reworded several error messages
2. added a missing memory free for error handling in patch 2

v3:
1. renamed version to migration_version
2. let errno to be freely defined by vendor driver
3. let checking mdev_type be prerequisite of migration compatibility check
4. reworded most part of patch 1
5. print detailed error log in patch 2 and generate migration_version
string at init time

v2:
1. renamed patched 1
2. made definition of device version string completely private to vendor
driver
3. reverted changes to sample mdev drivers
4. described intent and usage of version attribute more clearly.


Yan Zhao (4):
  vfio/mdev: add migration_version attribute for mdev (under mdev_type
    node)
  drm/i915/gvt: export migration_version to mdev sysfs (under mdev_type
    node)
  vfio/mdev: add migration_version attribute for mdev (under mdev device
    node)
  drm/i915/gvt: export migration_version to mdev sysfs (under mdev
    device node)

 .../driver-api/vfio-mediated-device.rst       | 183 ++++++++++++++++++
 drivers/gpu/drm/i915/gvt/Makefile             |   2 +-
 drivers/gpu/drm/i915/gvt/gvt.c                |  39 ++++
 drivers/gpu/drm/i915/gvt/gvt.h                |   7 +
 drivers/gpu/drm/i915/gvt/kvmgt.c              |  55 ++++++
 drivers/gpu/drm/i915/gvt/migration_version.c  | 170 ++++++++++++++++
 drivers/gpu/drm/i915/gvt/vgpu.c               |  13 +-
 7 files changed, 466 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/gvt/migration_version.c

-- 
2.17.1

