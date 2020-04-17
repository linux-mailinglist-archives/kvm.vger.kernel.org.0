Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F27A1ADAA4
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 12:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgDQKBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 06:01:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:4009 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgDQKBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 06:01:49 -0400
IronPort-SDR: btkvFp/W9MklE5QSu5bXAZcTLRxyiE3+sZYC+EqxtaIY2ALeXWr6AADNCK437WvLyYrgChzee6
 eC5silteccQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 03:01:48 -0700
IronPort-SDR: RRMDjiqrvQ2P/0gurYOYvUWAJrG/sp/kx652ixtBwkFyqw2s4kkhPO4KjOMYq+gVZJLivZFFld
 11a36OM2x6Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,394,1580803200"; 
   d="scan'208";a="454679512"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 17 Apr 2020 03:01:41 -0700
Date:   Fri, 17 Apr 2020 05:52:02 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "berrange@redhat.com" <berrange@redhat.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>
Subject: Re: [PATCH v5 0/4] introduction of migration_version attribute for
 VFIO live migration
Message-ID: <20200417095202.GD16688@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
 <20200417104450.2d2f2fa9.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417104450.2d2f2fa9.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 04:44:50PM +0800, Cornelia Huck wrote:
> On Mon, 13 Apr 2020 01:52:01 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > This patchset introduces a migration_version attribute under sysfs of VFIO
> > Mediated devices.
> > 
> > This migration_version attribute is used to check migration compatibility
> > between two mdev devices.
> > 
> > Currently, it has two locations:
> > (1) under mdev_type node,
> >     which can be used even before device creation, but only for mdev
> >     devices of the same mdev type.
> > (2) under mdev device node,
> >     which can only be used after the mdev devices are created, but the src
> >     and target mdev devices are not necessarily be of the same mdev type
> > (The second location is newly added in v5, in order to keep consistent
> > with the migration_version node for migratable pass-though devices)
> 
> What is the relationship between those two attributes?
> 
(1) is for mdev devices specifically, and (2) is provided to keep the same
sysfs interface as with non-mdev cases. so (2) is for both mdev devices and
non-mdev devices.

in future, if we enable vfio-pci vendor ops, (i.e. a non-mdev device
is binding to vfio-pci, but is able to register migration region and do
migration transactions from a vendor provided affiliate driver),
the vendor driver would export (2) directly, under device node.
It is not able to provide (1) as there're no mdev devices involved.

> Is existence (and compatibility) of (1) a pre-req for possible
> existence (and compatibility) of (2)?
>
no. (2) does not reply on (1).

> Does userspace need to check (1) or can it completely rely on (2), if
> it so chooses?
>
I think it can completely reply on (2) if compatibility check before
mdev creation is not required.

> If devices with a different mdev type are indeed compatible, it seems
> userspace can only find out after the devices have actually been
> created, as (1) does not apply?
yes, I think so. 

> One of my worries is that the existence of an attribute with the same
> name in two similar locations might lead to confusion. But maybe it
> isn't a problem.
>
Yes, I have the same feeling. but as (2) is for sysfs interface
consistency, to make it transparent to userspace tools like libvirt,
I guess the same name is necessary?

Thanks
Yan
> > 
> > Patch 1 defines migration_version attribute for the first location in
> > Documentation/vfio-mediated-device.txt
> > 
> > Patch 2 uses GVT as an example for patch 1 to show how to expose
> > migration_version attribute and check migration compatibility in vendor
> > driver.
> > 
> > Patch 3 defines migration_version attribute for the second location in
> > Documentation/vfio-mediated-device.txt
> > 
> > Patch 4 uses GVT as an example for patch 3 to show how to expose
> > migration_version attribute and check migration compatibility in vendor
> > driver.
> > 
> > (The previous "Reviewed-by" and "Acked-by" for patch 1 and patch 2 are
> > kept in v5, as there are only small changes to commit messages of the two
> > patches.)
> > 
> > v5:
> > added patch 2 and 4 for mdev device part of migration_version attribute.
> > 
> > v4:
> > 1. fixed indentation/spell errors, reworded several error messages
> > 2. added a missing memory free for error handling in patch 2
> > 
> > v3:
> > 1. renamed version to migration_version
> > 2. let errno to be freely defined by vendor driver
> > 3. let checking mdev_type be prerequisite of migration compatibility check
> > 4. reworded most part of patch 1
> > 5. print detailed error log in patch 2 and generate migration_version
> > string at init time
> > 
> > v2:
> > 1. renamed patched 1
> > 2. made definition of device version string completely private to vendor
> > driver
> > 3. reverted changes to sample mdev drivers
> > 4. described intent and usage of version attribute more clearly.
> > 
> > 
> > Yan Zhao (4):
> >   vfio/mdev: add migration_version attribute for mdev (under mdev_type
> >     node)
> >   drm/i915/gvt: export migration_version to mdev sysfs (under mdev_type
> >     node)
> >   vfio/mdev: add migration_version attribute for mdev (under mdev device
> >     node)
> >   drm/i915/gvt: export migration_version to mdev sysfs (under mdev
> >     device node)
> > 
> >  .../driver-api/vfio-mediated-device.rst       | 183 ++++++++++++++++++
> >  drivers/gpu/drm/i915/gvt/Makefile             |   2 +-
> >  drivers/gpu/drm/i915/gvt/gvt.c                |  39 ++++
> >  drivers/gpu/drm/i915/gvt/gvt.h                |   7 +
> >  drivers/gpu/drm/i915/gvt/kvmgt.c              |  55 ++++++
> >  drivers/gpu/drm/i915/gvt/migration_version.c  | 170 ++++++++++++++++
> >  drivers/gpu/drm/i915/gvt/vgpu.c               |  13 +-
> >  7 files changed, 466 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/gpu/drm/i915/gvt/migration_version.c
> > 
> 
