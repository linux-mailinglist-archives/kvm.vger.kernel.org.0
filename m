Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9A32AD64
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 05:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfE0Dtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 23:49:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:26348 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfE0Dtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 23:49:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 May 2019 20:49:42 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by orsmga006.jf.intel.com with ESMTP; 26 May 2019 20:49:37 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 1/2] vfio/mdev: add migration_version attribute for mdev device
Date:   Sun, 26 May 2019 23:43:42 -0400
Message-Id: <20190527034342.31523-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527034155.31473-1-yan.y.zhao@intel.com>
References: <20190527034155.31473-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

migration_version attribute is used to check migration compatibility
between two mdev device of the same mdev type.
The key is that it's rw and its data is opaque to userspace.

Userspace reads migration_version of mdev device at source side and
writes the value to migration_version attribute of mdev device at target
side. It judges migration compatibility according to whether the read
and write operations succeed or fail.

As this attribute is under mdev_type node, userspace is able to know
whether two mdev devices are compatible before a mdev device is created.

userspace needs to check whether the two mdev devices are of the same
mdev type before checking the migration_version attribute. It also needs
to check device creation parameters if aggregation is supported in
future.

             __    userspace
              /\              \
             /                 \write
            / read              \
   ________/__________       ___\|/_____________
  | migration_version |     | migration_version |-->check migration
  ---------------------     ---------------------   compatibility
    mdev device A               mdev device B

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

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

---
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
 Documentation/vfio-mediated-device.txt | 113 +++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/Documentation/vfio-mediated-device.txt b/Documentation/vfio-mediated-device.txt
index c3f69bcaf96e..1241e1cee64e 100644
--- a/Documentation/vfio-mediated-device.txt
+++ b/Documentation/vfio-mediated-device.txt
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

