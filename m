Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3668A2D2CE
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 02:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfE2AWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 20:22:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:26926 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfE2AWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 20:22:15 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:22:14 -0700
X-ExtLoop1: 1
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga005.jf.intel.com with ESMTP; 28 May 2019 17:22:09 -0700
Date:   Tue, 28 May 2019 20:16:25 -0400
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
Subject: Re: [PATCH v3 1/2] vfio/mdev: add migration_version attribute for
 mdev device
Message-ID: <20190529001625.GG27438@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20190527034155.31473-1-yan.y.zhao@intel.com>
 <20190527034342.31523-1-yan.y.zhao@intel.com>
 <20190528105332.7c5a2f82.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190528105332.7c5a2f82.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 28, 2019 at 04:53:32PM +0800, Cornelia Huck wrote:
> On Sun, 26 May 2019 23:43:42 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > migration_version attribute is used to check migration compatibility
> > between two mdev device of the same mdev type.
> 
> s/device/devices/
>
yes... sorry and thanks :)

> > The key is that it's rw and its data is opaque to userspace.
> > 
> > Userspace reads migration_version of mdev device at source side and
> > writes the value to migration_version attribute of mdev device at target
> > side. It judges migration compatibility according to whether the read
> > and write operations succeed or fail.
> > 
> > As this attribute is under mdev_type node, userspace is able to know
> > whether two mdev devices are compatible before a mdev device is created.
> > 
> > userspace needs to check whether the two mdev devices are of the same
> > mdev type before checking the migration_version attribute. It also needs
> > to check device creation parameters if aggregation is supported in
> > future.
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
> > 
> > ---
> > v3:
> > 1. renamed version to migration_version
> > (Christophe de Dinechin, Cornelia Huck, Alex Williamson)
> > 2. let errno to be freely defined by vendor driver
> > (Alex Williamson, Erik Skultety, Cornelia Huck, Dr. David Alan Gilbert)
> > 3. let checking mdev_type be prerequisite of migration compatibility
> > check. (Alex Williamson)
> > 4. reworded example usage section.
> > (most of this section came from Alex Williamson)
> > 5. reworded attribute intention section (Cornelia Huck)
> > 
> > v2:
> > 1. added detailed intent and usage
> > 2. made definition of version string completely private to vendor driver
> >    (Alex Williamson)
> > 3. abandoned changes to sample mdev drivers (Alex Williamson)
> > 4. mandatory --> optional (Cornelia Huck)
> > 5. added description for errno (Cornelia Huck)
> > ---
> >  Documentation/vfio-mediated-device.txt | 113 +++++++++++++++++++++++++
> >  1 file changed, 113 insertions(+)
> > 
> 
> While I probably would have written a more compact description, your
> version is fine with me as well.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Thank you Cornelia!

> _______________________________________________
> intel-gvt-dev mailing list
> intel-gvt-dev@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gvt-dev
