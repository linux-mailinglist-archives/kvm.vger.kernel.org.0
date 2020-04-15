Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19961A981A
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505548AbgDOJM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 05:12:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:57775 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408371AbgDOJMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 05:12:21 -0400
IronPort-SDR: +tnYFqayJ9FGNcp77jB0GuCcQO6yFDfGY4ZXyM817O+9AQtDKrjmZqPeIqWE4Xw7Ts8RikZJUr
 4hRiZR/EuZfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 02:12:20 -0700
IronPort-SDR: 6DZfSWbji33ZBRzjz6OV60+zabtDaKUmsqS6CmrO5jvPhgTksdHX4hTo959D8/TW+pnYu1H5Jz
 UD9fHbnsn6Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,386,1580803200"; 
   d="scan'208";a="245644372"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga008.fm.intel.com with ESMTP; 15 Apr 2020 02:12:14 -0700
Date:   Wed, 15 Apr 2020 05:02:36 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Erik Skultety <eskultet@redhat.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Xin" <xin.zeng@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v5 3/4] vfio/mdev: add migration_version attribute for
 mdev (under mdev device node)
Message-ID: <20200415090236.GK10586@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
 <20200413055504.27311-1-yan.y.zhao@intel.com>
 <20200415074258.GK269314@sturgeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200415074258.GK269314@sturgeon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 15, 2020 at 03:42:58PM +0800, Erik Skultety wrote:
> On Mon, Apr 13, 2020 at 01:55:04AM -0400, Yan Zhao wrote:
> > migration_version attribute is used to check migration compatibility
> > between two mdev devices of the same mdev type.
> > The key is that it's rw and its data is opaque to userspace.
> >
> > Userspace reads migration_version of mdev device at source side and
> > writes the value to migration_version attribute of mdev device at target
> > side. It judges migration compatibility according to whether the read
> > and write operations succeed or fail.
> >
> > Currently, it is able to read/write migration_version attribute under two
> > places:
> >
> > (1) under mdev_type node
> > userspace is able to know whether two mdev devices are compatible before
> > a mdev device is created.
> >
> > userspace also needs to check whether the two mdev devices are of the same
> > mdev type before checking the migration_version attribute. It also needs
> > to check device creation parameters if aggregation is supported in future.
> >
> > (2) under mdev device node
> > userspace is able to know whether two mdev devices are compatible after
> > they are all created. But it does not need to check mdev type and device
> > creation parameter for aggregation as device vendor driver would have
> > incorporated those information into the migration_version attribute.
> >
> >              __    userspace
> >               /\              \
> >              /                 \write
> >             / read              \
> >    ________/__________       ___\|/_____________
> >   | migration_version |     | migration_version |-->check migration
> >   ---------------------     ---------------------   compatibility
> >     mdev device A               mdev device B
> >
> > This patch is for mdev documentation about the second place (under
> > mdev device node)
> >
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Erik Skultety <eskultet@redhat.com>
> > Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: "Tian, Kevin" <kevin.tian@intel.com>
> > Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> > Cc: "Wang, Zhi A" <zhi.a.wang@intel.com>
> > Cc: Neo Jia <cjia@nvidia.com>
> > Cc: Kirti Wankhede <kwankhede@nvidia.com>
> > Cc: Daniel P. Berrangé <berrange@redhat.com>
> > Cc: Christophe de Dinechin <dinechin@redhat.com>
> >
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  .../driver-api/vfio-mediated-device.rst       | 70 +++++++++++++++++++
> >  1 file changed, 70 insertions(+)
> >
> > diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> > index 2d1f3c0f3c8f..efbadfd51b7e 100644
> > --- a/Documentation/driver-api/vfio-mediated-device.rst
> > +++ b/Documentation/driver-api/vfio-mediated-device.rst
> > @@ -383,6 +383,7 @@ Directories and Files Under the sysfs for Each mdev Device
> >           |--- remove
> >           |--- mdev_type {link to its type}
> >           |--- vendor-specific-attributes [optional]
> > +         |--- migration_verion [optional]
> >
> >  * remove (write only)
> >
> > @@ -394,6 +395,75 @@ Example::
> >
> >  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
> >
> > +* migration_version (rw, optional)
> 
> Hmm, ^this is not consistent with how patch 1/5 reports this information, but
> looking at the existing docs we're not doing very well in terms of consistency
> there either.
> 
> I suggest we go with "(read-write)" in both patch 1/5 and here and then start
> the paragraph with "This is an optional attribute."
>
ok. got it.

> > +  It is used to check migration compatibility between two mdev devices.
> > +  Absence of this attribute means the mdev device does not support migration.
> > +
> > +  This attribute provides a way to check migration compatibility between two
> > +  mdev devices from userspace after device created. The intended usage is
> 
> after the target device has been created.
> 
> side note: maybe add something like "(see the migration_version attribute of
> the device node if the target device already exists)" in the same section in
> patch 1/5.

ok. good idea.
> 
> > +  for userspace to read the migration_version attribute from one mdev device and
> > +  then writing that value to the migration_version attribute of the other mdev
> > +  device. The second mdev device indicates compatibility via the return code of
> > +  the write operation. This makes compatibility between mdev devices completely
> > +  vendor-defined and opaque to userspace. Userspace should do nothing more
> > +  than use the migration_version attribute to confirm source to target
> > +  compatibility.
> 
> ...
> 
> > +
> > +  Reading/Writing Attribute Data:
> > +  read(2) will fail if a mdev device does not support migration and otherwise
> > +        succeed and return migration_version string of the mdev device.
> > +
> > +        This migration_version string is vendor defined and opaque to the
> > +        userspace. Vendor is free to include whatever they feel is relevant.
> > +        e.g. <pciid of parent device>-<software version>.
> > +
> > +        Restrictions on this migration_version string:
> > +            1. It should only contain ascii characters
> > +            2. MAX Length is PATH_MAX (4096)
> > +
> > +  write(2) expects migration_version string of source mdev device, and will
> > +         succeed if it is determined to be compatible and otherwise fail with
> > +         vendor specific errno.
> > +
> > +  Errno:
> > +  -An errno on read(2) indicates the mdev devicedoes not support migration;
> 
> s/devicedoes/device does/
> 
sorry for such kind of errors.

> > +  -An errno on write(2) indicates the mdev devices are incompatible or the
> > +   target doesn't support migration.
> > +  Vendor driver is free to define specific errno and is suggested to
> > +  print detailed error in syslog for diagnose purpose.
> > +
> > +  Userspace should treat ANY of below conditions as two mdev devices not
> > +  compatible:
> > +  (1) any one of the two mdev devices does not have a migration_version
> > +  attribute
> > +  (2) error when reading from migration_version attribute of one mdev device
> > +  (3) error when writing migration_version string of one mdev device to
> > +  migration_version attribute of the other mdev device
> > +
> > +  Userspace should regard two mdev devices compatible when ALL of below
> > +  conditions are met:
> > +  (1) success when reading from migration_version attribute of one mdev device.
> > +  (2) success when writing migration_version string of one mdev device to
> > +  migration_version attribute of the other mdev device.
> > +
> > +  Example Usage:
> > +  (1) Retrieve the mdev source migration_version:
> > +
> > +  # cat /sys/bus/mdev/devices/$mdev_UUID1/migration_version
> > +
> > +  If reading the source migration_version generates an error, migration is not
> > +  possible.
> > +
> > +  (2) Test source migration_version at target:
> > +
> > +  Given a migration_version as outlined above, its compatibility to an
> > +  instantiated device of the same mdev type can be tested as:
> > +  # echo $VERSION > /sys/bus/mdev/devices/$mdev_UUID2/migration_version
> > +
> > +  If this write fails, the source and target migration versions are not
> > +  compatible or the target does not support migration.
> > +
> > +
> >  Mediated device Hot plug
> >  ------------------------
> 
> Overall, the same comments as in 1/5 apply text-wise.
> 

got it. will align it with the first patch.

Thanks
Yan

> Regards,
> --
> Erik Skultety
> 
