Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA81A62D4
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 08:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgDMGD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 02:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgDMGDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 02:03:55 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B7EC0A3BE0;
        Sun, 12 Apr 2020 23:03:55 -0700 (PDT)
IronPort-SDR: sTmA9b3T4GGfb3yESswvYBcXzp20GWGINyDSv8Ijcm/ShItLfFt7SEtjcUN3SDEuFc1X8OBMiD
 QAGwc7DSkagw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 23:03:54 -0700
IronPort-SDR: z+0HOU69jei098SSeSutY5Rei2Llm3kZRcVPTTqJjFp4sXn0qI63LlAxr5XpUfVmCleoF6dxxX
 Quj74UvirE2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,377,1580803200"; 
   d="scan'208";a="245065624"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 12 Apr 2020 23:03:48 -0700
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
Subject: [PATCH v5 1/4] vfio/mdev: add migration_version attribute for mdev (under mdev_type node)
Date:   Mon, 13 Apr 2020 01:54:03 -0400
Message-Id: <20200413055403.27203-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413055201.27053-1-yan.y.zhao@intel.com>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

migration_version attribute is used to check migration compatibility
between two mdev devices of the same mdev type.
The key is that it's rw and its data is opaque to userspace.

Userspace reads migration_version of mdev device at source side and
writes the value to migration_version attribute of mdev device at target
side. It judges migration compatibility according to whether the read
and write operations succeed or fail.

Currently, it is able to read/write migration_version attribute under two
places:

(1) under mdev_type node
userspace is able to know whether two mdev devices are compatible before
a mdev device is created.

userspace also needs to check whether the two mdev devices are of the same
mdev type before checking the migration_version attribute. It also needs
to check device creation parameters if aggregation is supported in future.

(2) under mdev device node
userspace is able to know whether two mdev devices are compatible after
they are all created. But it does not need to check mdev type and device
creation parameter for aggregation as device vendor driver would have
incorporated those information into the migration_version attribute.

             __    userspace
              /\              \
             /                 \write
            / read              \
   ________/__________       ___\|/_____________
  | migration_version |     | migration_version |-->check migration
  ---------------------     ---------------------   compatibility
    mdev device A               mdev device B

This patch is for mdev documentation about the first place (under
mdev_type node)

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Erik Skultety <eskultet@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
Cc: Neo Jia <cjia@nvidia.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Christophe de Dinechin <dinechin@redhat.com>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

---
v5:
updated commit message a little to indicate this patch is for
migration_version attribute under mdev_type node

v4:
fixed a typo. (Cornelia Huck)

v3:
1. renamed version to migration_version
(Christophe de Dinechin, Cornelia Huck, Alex Williamson)
2. let errno to be freely defined by vendor driver
(Alex Williamson, Erik Skultety, Cornelia Huck, Dr. David Alan Gilbert)
3. let checking mdev_type be prerequisite of migration compatibility
check. (Alex Williamson)
4. reworded example usage section.
(most of this section came from Alex Williamson)
5. reworded attribute intention section (Cornelia Huck)

v2:
1. added detailed intent and usage
2. made definition of version string completely private to vendor driver
   (Alex Williamson)
3. abandoned changes to sample mdev drivers (Alex Williamson)
4. mandatory --> optional (Cornelia Huck)
5. added description for errno (Cornelia Huck)
---
 .../driver-api/vfio-mediated-device.rst       | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..2d1f3c0f3c8f 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -202,6 +202,7 @@ Directories and files under the sysfs for Each Physical Device
   |     |   |--- available_instances
   |     |   |--- device_api
   |     |   |--- description
+  |     |   |--- migration_version
   |     |   |--- [devices]
   |     |--- [<type-id>]
   |     |   |--- create
@@ -209,6 +210,7 @@ Directories and files under the sysfs for Each Physical Device
   |     |   |--- available_instances
   |     |   |--- device_api
   |     |   |--- description
+  |     |   |--- migration_version
   |     |   |--- [devices]
   |     |--- [<type-id>]
   |          |--- create
@@ -216,6 +218,7 @@ Directories and files under the sysfs for Each Physical Device
   |          |--- available_instances
   |          |--- device_api
   |          |--- description
+  |          |--- migration_version
   |          |--- [devices]
 
 * [mdev_supported_types]
@@ -246,6 +249,116 @@ Directories and files under the sysfs for Each Physical Device
   This attribute should show the number of devices of type <type-id> that can be
   created.
 
+* migration_version
+
+  This attribute is rw, and is optional.
+  It is used to check migration compatibility between two mdev devices of the
+  same mdev type. Absence of this attribute means the device of type <type-id>
+  does not support migration.
+  This attribute provides a way to check migration compatibility between two
+  mdev devices from userspace even before device creation. The intended usage is
+  for userspace to read the migration_version attribute from one mdev device and
+  then writing that value to the migration_version attribute of the other mdev
+  device. The second mdev device indicates compatibility via the return code of
+  the write operation. This makes compatibility between mdev devices completely
+  vendor-defined and opaque to userspace. Userspace should do nothing more
+  than verify the mdev types match and then use the migration_version attribute
+  to confirm source to target compatibility.
+
+  Reading/Writing Attribute Data:
+  read(2) will fail if device of type <type-id> does not support migration and
+          otherwise succeed and return migration_version string of the device of
+          type <type-id>.
+
+          This migration_version string is vendor defined and opaque to the
+          userspace. Vendor is free to include whatever they feel is relevant.
+          e.g. <pciid of parent device>-<software version>.
+
+          Restrictions on this migration_version string:
+            1. It should only contain ascii characters
+            2. MAX Length is PATH_MAX (4096)
+
+  write(2) expects migration_version string of source mdev device, and will
+          succeed if it is determined to be compatible and otherwise fail with
+          vendor specific errno.
+
+  Errno:
+  -An errno on read(2) indicates the device of type <type-id> does not support
+  migration;
+  -An errno on write(2) indicates the devices are incompatible or the target
+  doesn't support migration.
+  Vendor driver is free to define specific errno and is suggested to
+  print detailed error in syslog for diagnose purpose.
+
+  Userspace should treat ANY of below conditions as two mdev devices not
+  compatible:
+  (0) The mdev devices are not of the same type
+  (1) any one of the two mdev devices does not have a migration_version
+  attribute
+  (2) error when reading from migration_version attribute of one mdev device
+  (3) error when writing migration_version string of one mdev device to
+  migration_version attribute of the other mdev device
+
+  Userspace should regard two mdev devices compatible when ALL of below
+  conditions are met:
+  (0) The mdev devices are of the same type
+  (1) success when reading from migration_version attribute of one mdev device.
+  (2) success when writing migration_version string of one mdev device to
+  migration_version attribute of the other mdev device.
+
+  Example Usage:
+  (1) Compare mdev types:
+
+  The mdev type of an instantiated device can be read from the mdev_type link
+  within the device instance in sysfs, for example:
+
+  # basename $(readlink -f /sys/bus/mdev/devices/$MDEV_UUID/mdev_type/)
+
+  The mdev types available on a given host system can also be found through
+  /sys/class/mdev_bus, for example:
+
+  # ls /sys/class/mdev_bus/*/mdev_supported_types/
+
+  Migration is only possible between devices of the same mdev type.
+
+  (2) Retrieve the mdev source migration_version:
+
+  The migration_version information can either be read from the mdev_type link
+  on an instantiated device:
+
+  # cat /sys/bus/mdev/devices/$UUID1/mdev_type/migration_version
+
+  Or it can be read from the mdev type definition, for example:
+
+  # cat /sys/class/mdev_bus/*/mdev_supported_types/$MDEV_TYPE/migration_version
+
+  If reading the source migration_version generates an error, migration is not
+  possible.
+  NB, there might be several parent devices for a given mdev type on a host
+  system, each may support or expose different migration_versions.
+  Matching the specific mdev type to a parent may become important in such
+  configurations.
+
+  (3) Test source migration_version at target:
+
+  Given a migration_version as outlined above, its compatibility to an
+  instantiated device of the same mdev type can be tested as:
+  # echo $VERSION > /sys/bus/mdev/devices/$UUID2/mdev_type/migration_version
+
+  If this write fails, the source and target migration versions are not
+  compatible or the target does not support migration.
+
+  Compatibility can also be tested prior to target device creation using the
+  mdev type definition for a parent device with a previously found matching mdev
+  type, for example:
+
+  # echo $VERSION > \
+  /sys/class/mdev_bus/$PARENT/mdev_supported_types/$MDEV_TYPE/migration_version
+
+  Again, an error writing the migration_version indicates that an instance of
+  this mdev type would not support a migration from the provided migration
+  version.
+
 * [device]
 
   This directory contains links to the devices of type <type-id> that have been
-- 
2.17.1

