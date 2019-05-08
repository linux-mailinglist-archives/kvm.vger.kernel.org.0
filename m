Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8B178FF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 14:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfEHMCr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 08:02:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:22896 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbfEHMCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 08:02:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 05:02:46 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2019 05:02:42 -0700
Date:   Wed, 8 May 2019 07:57:05 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "arei.gonglei@huawei.com" <arei.gonglei@huawei.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>
Subject: Re: [PATCH v2 1/2] vfio/mdev: add version attribute for mdev device
Message-ID: <20190508115704.GB24397@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20190506014514.3555-1-yan.y.zhao@intel.com>
 <20190506014904.3621-1-yan.y.zhao@intel.com>
 <20190507111954.43d477c3.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507111954.43d477c3.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 07, 2019 at 05:19:54PM +0800, Cornelia Huck wrote:
> On Sun,  5 May 2019 21:49:04 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > version attribute is used to check two mdev devices' compatibility.
> > 
> > The key point of this version attribute is that it's rw.
> > User space has no need to understand internal of device version and no
> > need to compare versions by itself.
> > Compared to reading version strings from both two mdev devices being
> > checked, user space only reads from one mdev device's version attribute.
> > After getting its version string, user space writes this string into the
> > other mdev device's version attribute. Vendor driver of mdev device
> > whose version attribute being written will check device compatibility of
> > the two mdev devices for user space and return success for compatibility
> > or errno for incompatibility.
> 
> I'm still missing a bit _what_ is actually supposed to be
> compatible/incompatible. I'd assume some internal state descriptions
> (even if this is not actually limited to migration).
>
right.
originally, I thought this attribute should only contain a device's hardware
compatibility info. But seems also including vendor specific software migration
version is more reasonable, because general VFIO migration code cannot know
version of vendor specific software migration code until migration data is
transferring to the target vm. Then renaming it to migration_version is more
appropriate.
:)

> > So two readings of version attributes + checking in user space are now
> > changed to one reading + one writing of version attributes + checking in
> > vendor driver.
> 
> I'm not sure that needs to go into the patch description (sounds like
> it is rather a change log?)
> 
Indeed :)

> > Format and length of version strings are now private to vendor driver
> > who can define them freely.
> 
> Same here; simply drop the 'now'?
> 
ok. thanks:)

> > 
> >              __ user space
> >               /\          \
> >              /             \write
> >             / read          \
> >      ______/__           ___\|/___
> >     | version |         | version |-->check compatibility
> >     -----------         -----------
> >     mdev device A       mdev device B
> > 
> > This version attribute is optional. If a mdev device does not provide
> > with a version attribute, this mdev device is incompatible to all other
> > mdev devices.
> 
> Again, I'd like an explanation here what kind of compatibility we're
> talking about.
> 
as above, let me reword it to migration compatibility.

> > 
> > Live migration is able to take advantage of this version attribute.
> > Before user space actually starts live migration, it can first check
> > whether two mdev devices are compatible.
> > 
> > v2:
> > 1. added detailed intent and usage
> > 2. made definition of version string completely private to vendor driver
> >    (Alex Williamson)
> > 3. abandoned changes to sample mdev drivers (Alex Williamson)
> > 4. mandatory --> optional (Cornelia Huck)
> > 5. added description for errno (Cornelia Huck)
> 
> This changelog should go below the ---, so that it does not actually
> show up in the patch description later :)
got it:)

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
> >  Documentation/vfio-mediated-device.txt | 140 +++++++++++++++++++++++++
> >  1 file changed, 140 insertions(+)
> > 
> > diff --git a/Documentation/vfio-mediated-device.txt b/Documentation/vfio-mediated-device.txt
> > index c3f69bcaf96e..013a764968eb 100644
> > --- a/Documentation/vfio-mediated-device.txt
> > +++ b/Documentation/vfio-mediated-device.txt
> > @@ -202,6 +202,7 @@ Directories and files under the sysfs for Each Physical Device
> >    |     |   |--- available_instances
> >    |     |   |--- device_api
> >    |     |   |--- description
> > +  |     |   |--- version
> >    |     |   |--- [devices]
> >    |     |--- [<type-id>]
> >    |     |   |--- create
> > @@ -209,6 +210,7 @@ Directories and files under the sysfs for Each Physical Device
> >    |     |   |--- available_instances
> >    |     |   |--- device_api
> >    |     |   |--- description
> > +  |     |   |--- version
> >    |     |   |--- [devices]
> >    |     |--- [<type-id>]
> >    |          |--- create
> > @@ -216,6 +218,7 @@ Directories and files under the sysfs for Each Physical Device
> >    |          |--- available_instances
> >    |          |--- device_api
> >    |          |--- description
> > +  |          |--- version
> >    |          |--- [devices]
> >  
> >  * [mdev_supported_types]
> > @@ -246,6 +249,143 @@ Directories and files under the sysfs for Each Physical Device
> >    This attribute should show the number of devices of type <type-id> that can be
> >    created.
> >  
> > +* version
> > +
> > +  This attribute is rw, and is optional.
> > +  It is used to check device compatibility between two mdev devices and is
> > +  accessed in pairs between the two mdev devices being checked.
> > +  The intent of this attribute is to make an mdev device's version opaque to
> > +  user space, so instead of reading two mdev devices' version strings and
> > +  comparing in userspace, user space should only read one mdev device's version
> > +  attribute, and writes this version string into the other mdev device's version
> > +  attribute. Then vendor driver of mdev device whose version attribute being
> > +  written would check the incoming version string and tell user space whether
> > +  the two mdev devices are compatible via return value. That's why this
> > +  attribute is writable.
> 
> I would reword this a bit:
> 
> "This attribute provides a way to check device compatibility between
> two mdev devices from userspace. The intended usage is for userspace to
> read the version attribute from one mdev device and then writing that
> value to the version attribute of the other mdev device. The second
> mdev device indicates compatibility via the return code of the write
> operation. This makes compatibility between mdev devices completely
> vendor-defined and opaque to userspace."
> 
> We still should explain _what_ compatibility we're talking about here,
> though.
> 
Thanks. It's much better than mine:) 
Then I'll change compatibility --> migration compatibility.

> > +
> > +  when reading this attribute, it should show device version string of
> > +  the device of type <type-id>.
> > +
> > +  This string is private to vendor driver itself. Vendor driver is able to
> > +  freely define format and length of device version string.
> > +  e.g. It can use a combination of pciid of parent device + mdev type.
> > +
> > +  When writing a string to this attribute, vendor driver should analyze this
> > +  string and check whether the mdev device being identified by this string is
> > +  compatible with the mdev device for this attribute. vendor driver should then
> > +  return written string's length if it regards the two mdev devices are
> > +  compatible; vendor driver should return negative errno if it regards the two
> > +  mdev devices are not compatible.
> > +
> > +  User space should treat ANY of below conditions as two mdev devices not
> > +  compatible:
> > +  (1) any one of the two mdev devices does not have a version attribute
> > +  (2) error when read from one mdev device's version attribute
> 
> s/read/reading/
> 
> > +  (3) error when write one mdev device's version string to the other mdev
> 
> s/write/writing/
> 
> > +  device's version attribute
> > +
> > +  User space should regard two mdev devices compatible when ALL of below
> > +  conditions are met:
> > +  (1) success when read from one mdev device's version attribute.
> 
> s/read/reading/
> 
> > +  (2) success when write one mdev device's version string to the other mdev
> 
> s/write/writing/
got it. thanks for pointing them out:)
> 
> > +  device's version attribute
> > +
> > +  Errno:
> > +  If vendor driver wants to claim a mdev device incompatible to all other mdev
> 
> "If the vendor driver wants to designate a mdev device..."
> 
ok. thanks:)
> > +  devices, it should not register version attribute for this mdev device. But if
> > +  a vendor driver has already registered version attribute and it wants to claim
> > +  a mdev device incompatible to all other mdev devices, it needs to return
> > +  -ENODEV on access to this mdev device's version attribute.
> > +  If a mdev device is only incompatible to certain mdev devices, write of
> > +  incompatible mdev devices's version strings to its version attribute should
> > +  return -EINVAL;
> 
> 
> Maybe put the defined return code into a bulleted list instead? But
> this looks reasonable as well.
> 
as user space have no idea of those errno and only gets 0/1 as return code from
read/write. maybe I can move this description of errno to patch 2/2 as an
example?

> > +
> > +  This attribute can be taken advantage of by live migration.
> > +  If user space detects two mdev devices are compatible through version
> > +  attribute, it can start migration between the two mdev devices, otherwise it
> > +  should abort its migration attempts between the two mdev devices.
> 
> (...)
> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
