Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24AAF16D08
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 23:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfEGVSg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 May 2019 17:18:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51040 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfEGVSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 17:18:35 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0384B30832C5;
        Tue,  7 May 2019 21:18:35 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9CFA60BF3;
        Tue,  7 May 2019 21:18:27 +0000 (UTC)
Date:   Tue, 7 May 2019 15:18:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, arei.gonglei@huawei.com,
        aik@ozlabs.ru, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        eauger@redhat.com, yi.l.liu@intel.com, ziye.yang@intel.com,
        mlevitsk@redhat.com, pasic@linux.ibm.com, felipe@nutanix.com,
        changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, eskultet@redhat.com, dgilbert@redhat.com,
        cohuck@redhat.com, kevin.tian@intel.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, cjia@nvidia.com, kwankhede@nvidia.com,
        berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190507151826.502be009@x1.home>
In-Reply-To: <20190506014904.3621-1-yan.y.zhao@intel.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
        <20190506014904.3621-1-yan.y.zhao@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 07 May 2019 21:18:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun,  5 May 2019 21:49:04 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> version attribute is used to check two mdev devices' compatibility.
> 
> The key point of this version attribute is that it's rw.
> User space has no need to understand internal of device version and no
> need to compare versions by itself.
> Compared to reading version strings from both two mdev devices being
> checked, user space only reads from one mdev device's version attribute.
> After getting its version string, user space writes this string into the
> other mdev device's version attribute. Vendor driver of mdev device
> whose version attribute being written will check device compatibility of
> the two mdev devices for user space and return success for compatibility
> or errno for incompatibility.
> So two readings of version attributes + checking in user space are now
> changed to one reading + one writing of version attributes + checking in
> vendor driver.
> Format and length of version strings are now private to vendor driver
> who can define them freely.
> 
>              __ user space
>               /\          \
>              /             \write
>             / read          \
>      ______/__           ___\|/___
>     | version |         | version |-->check compatibility
>     -----------         -----------
>     mdev device A       mdev device B
> 
> This version attribute is optional. If a mdev device does not provide
> with a version attribute, this mdev device is incompatible to all other
> mdev devices.
> 
> Live migration is able to take advantage of this version attribute.
> Before user space actually starts live migration, it can first check
> whether two mdev devices are compatible.
> 
> v2:
> 1. added detailed intent and usage
> 2. made definition of version string completely private to vendor driver
>    (Alex Williamson)
> 3. abandoned changes to sample mdev drivers (Alex Williamson)
> 4. mandatory --> optional (Cornelia Huck)
> 5. added description for errno (Cornelia Huck)
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Erik Skultety <eskultet@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: "Tian, Kevin" <kevin.tian@intel.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
> Cc: Neo Jia <cjia@nvidia.com>
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Daniel P. Berrangé <berrange@redhat.com>
> Cc: Christophe de Dinechin <dinechin@redhat.com>
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  Documentation/vfio-mediated-device.txt | 140 +++++++++++++++++++++++++
>  1 file changed, 140 insertions(+)
> 
> diff --git a/Documentation/vfio-mediated-device.txt b/Documentation/vfio-mediated-device.txt
> index c3f69bcaf96e..013a764968eb 100644
> --- a/Documentation/vfio-mediated-device.txt
> +++ b/Documentation/vfio-mediated-device.txt
> @@ -202,6 +202,7 @@ Directories and files under the sysfs for Each Physical Device
>    |     |   |--- available_instances
>    |     |   |--- device_api
>    |     |   |--- description
> +  |     |   |--- version
>    |     |   |--- [devices]
>    |     |--- [<type-id>]
>    |     |   |--- create
> @@ -209,6 +210,7 @@ Directories and files under the sysfs for Each Physical Device
>    |     |   |--- available_instances
>    |     |   |--- device_api
>    |     |   |--- description
> +  |     |   |--- version
>    |     |   |--- [devices]
>    |     |--- [<type-id>]
>    |          |--- create
> @@ -216,6 +218,7 @@ Directories and files under the sysfs for Each Physical Device
>    |          |--- available_instances
>    |          |--- device_api
>    |          |--- description
> +  |          |--- version
>    |          |--- [devices]

I thought there was a request to make this more specific to migration
by renaming it to something like migration_version.  Also, as an
optional attribute, it seems the example should perhaps not add it to
all types to illustrate that it is not required.

>  
>  * [mdev_supported_types]
> @@ -246,6 +249,143 @@ Directories and files under the sysfs for Each Physical Device
>    This attribute should show the number of devices of type <type-id> that can be
>    created.
>  
> +* version
> +
> +  This attribute is rw, and is optional.
> +  It is used to check device compatibility between two mdev devices and is

between two mdev devices of the same type.

> +  accessed in pairs between the two mdev devices being checked.

"in pairs"?

> +  The intent of this attribute is to make an mdev device's version opaque to
> +  user space, so instead of reading two mdev devices' version strings and

perhaps "...instead of reading the version string of two mdev devices
and comparing them in userspace..."

> +  comparing in userspace, user space should only read one mdev device's version
> +  attribute, and writes this version string into the other mdev device's version
> +  attribute. Then vendor driver of mdev device whose version attribute being
> +  written would check the incoming version string and tell user space whether
> +  the two mdev devices are compatible via return value. That's why this
> +  attribute is writable.
> +
> +  when reading this attribute, it should show device version string of
> +  the device of type <type-id>.
> +
> +  This string is private to vendor driver itself. Vendor driver is able to
> +  freely define format and length of device version string.
> +  e.g. It can use a combination of pciid of parent device + mdev type.

Can the user assume the data contents of the string is ascii
characters?  It's good that the vendor driver defines the format and
length, but the user probably needs some expectation bounding that
length.  Should we define it as no larger than PATH_MAX (4096), or maybe
NAME_MAX (255) might be more reasonable?

> +
> +  When writing a string to this attribute, vendor driver should analyze this
> +  string and check whether the mdev device being identified by this string is
> +  compatible with the mdev device for this attribute. vendor driver should then

Compatible for what purpose?  I think this is where specifically
calling this a migration_version potentially has value.

> +  return written string's length if it regards the two mdev devices are
> +  compatible; vendor driver should return negative errno if it regards the two
> +  mdev devices are not compatible.

IOW, the write(2) will succeed if the version is determined to be
compatible and otherwise fail with vendor specific errno.

> +
> +  User space should treat ANY of below conditions as two mdev devices not
> +  compatible:

(0) The mdev devices are not of the same type.

> +  (1) any one of the two mdev devices does not have a version attribute
> +  (2) error when read from one mdev device's version attribute

Is this intended to support that the vendor driver can supply a version
attribute but not support migration?  TBH, this sounds like a vendor
driver bug, but maybe it's necessary if the vendor driver could have
some types that support migration and others that do not?  IOW, we're
supplying the same attribute groups to all devices from a vendor, in
which case my comment above regarding an example type without a version
attribute might be invalid.

> +  (3) error when write one mdev device's version string to the other mdev
> +  device's version attribute
> +
> +  User space should regard two mdev devices compatible when ALL of below
> +  conditions are met:

(0) The mdev devices are of the same type

> +  (1) success when read from one mdev device's version attribute.
> +  (2) success when write one mdev device's version string to the other mdev
> +  device's version attribute
> +
> +  Errno:
> +  If vendor driver wants to claim a mdev device incompatible to all other mdev
> +  devices, it should not register version attribute for this mdev device. But if
> +  a vendor driver has already registered version attribute and it wants to claim
> +  a mdev device incompatible to all other mdev devices, it needs to return
> +  -ENODEV on access to this mdev device's version attribute.
> +  If a mdev device is only incompatible to certain mdev devices, write of
> +  incompatible mdev devices's version strings to its version attribute should
> +  return -EINVAL;

I think it's best not to define the specific errno returned for a
specific situation, let the vendor driver decide, userspace simply
needs to know that an errno on read indicates the device does not
support migration version comparison and that an errno on write
indicates the devices are incompatible or the target doesn't support
migration versions.

> +
> +  This attribute can be taken advantage of by live migration.
> +  If user space detects two mdev devices are compatible through version
> +  attribute, it can start migration between the two mdev devices, otherwise it
> +  should abort its migration attempts between the two mdev devices.
> +
> +  Example Usage:
> +  case 1:
> +  source side mdev device is of uuid 5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd,
> +  its mdev type is i915-GVTg_V5_4. pci id of parent device is 8086-193b.
> +  target side mdev device is if of uuid 882cc4da-dede-11e7-9180-078a62063ab1,
> +  its mdev type is i915-GVTg_V5_4. pci id of parent device is 8086-193b.
> +
> +  # readlink /sys/bus/pci/devices/0000\:00\:02.0/\
> +  5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/mdev_type
> +  ../mdev_supported_types/i915-GVTg_V5_4
> +
> +  # readlink /sys/bus/pci/devices/0000\:00\:02.0/\
> +  882cc4da-dede-11e7-9180-078a62063ab1/mdev_type
> +  ../mdev_supported_types/i915-GVTg_V5_4
> +
> +  (1) read source side mdev device's version.
> +  #cat \
> +    /sys/bus/pci/devices/0000\:00\:02.0/5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/\
> +    mdev_type/version
> +  8086-193b-i915-GVTg_V5_4

Is this really the version information exposed in 2/2?  This is opaque,
so of course you can add things later, but it seems short sighted not
to even append a version 0 tag to account for software compatibility
differences since the above only represents a parent and mdev type
based version.

> +  (2) write source side mdev device's version string into target side mdev
> +  device's version attribute.
> +  # echo 8086-193b-i915-GVTg_V5_4 >
> +   /sys/bus/pci/devices/0000\:00\:02.0/882cc4da-dede-11e7-9180-078a62063ab1/\
> +  mdev_type/version
> +  # echo $?
> +  0

TBH, there's a lot of superfluous information in this example that can
be stripped out.  For example:

"
(1) Compare mdev types:

The mdev type of an instantiated device can be read from the mdev_type
link within the device instance in sysfs, for example:

  # basename $(readlink -f /sys/bus/mdev/devices/$MDEV_UUID/mdev_type/)

The mdev types available on a given host system can also be found
through /sys/class/mdev_bus, for example:

  # ls /sys/class/mdev_bus/*/mdev_supported_types/

Migration is only possible between devices of the same mdev type.

(2) Retrieve the mdev source version:

The migration version information can either be read from the mdev_type
link on an instantiated device:

  # cat /sys/bus/mdev/devices/$UUID1/mdev_type/version

Or it can be read from the mdev type definition, for example:

  # cat /sys/class/mdev_bus/*/mdev_supported_types/$MDEV_TYPE/version

If reading the source version generates an error, migration is not
possible.  NB, there might be several parent devices for a given mdev
type on a host system, each may support or expose different versions.
Matching the specific mdev type to a parent may become important in
such configurations.

(3) Test source version at target:

Given a version as outlined above, its compatibility to an instantiated
device of the same mdev type can be tested as:

  # echo $VERSION > /sys/bus/mdev/devices/$UUID2/mdev_type/version

If this write fails, the source and target versions are not compatible
or the target does not support migration.

Compatibility can also be tested prior to target device creation using
the mdev type definition for a parent device with a previously found
matching mdev type, for example:

  # echo $VERSION > /sys/class/mdev_bus/$PARENT/mdev_supported_types/$MDEV_TYPE/version

Again, an error writing the version indicates that an instance of this
mdev type would not support a migration from the provided version.
"

In particular from the provided example, the specific UUIDs, mdev
types, parent information, and contents of the version attribute do not
contribute to illustrating the protocol.  In fact, displaying the
contents of the version attribute may tempt users to do comparison on
their own, especially given how easy it is to decide the GVT-g version
string.


> +
> +  in this case, user space's write to target side mdev device's version
> +  attribute returns success to indicate the two mdev devices are compatible.
> +
> +  case 2:
> +  source side mdev device is of uuid 5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd,
> +  its mdev type is i915-GVTg_V5_4. pci id of parent device is 8086-193b.
> +  target side mdev device is if of uuid 882cc4da-dede-11e7-9180-078a62063ab1,
> +  its mdev type is i915-GVTg_V5_4. pci id of parent device is 8086-191b.
> +
> +  # readlink /sys/bus/pci/devices/0000\:00\:02.0/\
> +  5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/mdev_type
> +  ../mdev_supported_types/i915-GVTg_V5_4
> +
> +  # readlink /sys/bus/pci/devices/0000\:00\:02.0/\
> +  882cc4da-dede-11e7-9180-078a62063ab1/mdev_type
> +  ../mdev_supported_types/i915-GVTg_V5_4
> +
> +  (1) read source side mdev device's version.
> +  #cat \
> +    /sys/bus/pci/devices/0000\:00\:02.0/5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/\
> +    mdev_type/version
> +  8086-193b-i915-GVTg_V5_4
> +
> +  (2) write source side mdev device's version string into target side mdev
> +  device's version attribute.
> +  # echo 8086-193b-i915-GVTg_V5_4 >
> +   /sys/bus/pci/devices/0000\:00\:02.0/882cc4da-dede-11e7-9180-078a62063ab1/\
> +  mdev_type/version
> +  -bash: echo: write error: Invalid argument
> +
> +  in this case, user space's write to target side mdev device's version
> +  attribute returns error to indicate the two mdev devices are incompatible.
> +  (incompatible because pci ids of the two mdev devices' parent devices are
> +  different).
> +
> +  case 3:
> +  source side mdev device is of uuid 5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd,
> +  its mdev type is i915-GVTg_V5_4. pci id of parent device is 8086-193b.
> +  But vendor driver does not provide version attribute for this device.
> +
> +  (1) read source side mdev device's version.
> +  #cat \
> +    /sys/bus/pci/devices/0000\:00\:02.0/5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/\
> +    mdev_type/version
> +  cat: '/sys/bus/pci/devices/0000:00:02.0/5ac1fb20-2bbf-4842-bb7e-36c58c3be9cd/\
> +  mdev_type/version': No such file or directory
> +
> +  in this case, user space reads source side mdev device's version attribute
> +  which does not exist however. user space regards the two mdev devices as not
> +  compatible and will not start migration between the two mdev devices.
> +
> +

This is far too long for description and examples, it's not this
complicated.  Thanks,

Alex

>  * [device]
>  
>    This directory contains links to the devices of type <type-id> that have been

