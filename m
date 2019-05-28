Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154222C1CB
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 10:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfE1Ixv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 28 May 2019 04:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfE1Ixt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 04:53:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8118381E03;
        Tue, 28 May 2019 08:53:48 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EAD97D580;
        Tue, 28 May 2019 08:53:34 +0000 (UTC)
Date:   Tue, 28 May 2019 10:53:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, aik@ozlabs.ru,
        Zhengxiao.zx@alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        qemu-devel@nongnu.org, eauger@redhat.com, yi.l.liu@intel.com,
        ziye.yang@intel.com, mlevitsk@redhat.com, pasic@linux.ibm.com,
        felipe@nutanix.com, changpeng.liu@intel.com, Ken.Xue@amd.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, alex.williamson@redhat.com,
        eskultet@redhat.com, dgilbert@redhat.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, cjia@nvidia.com,
        kwankhede@nvidia.com, berrange@redhat.com, dinechin@redhat.com
Subject: Re: [PATCH v3 1/2] vfio/mdev: add migration_version attribute for
 mdev device
Message-ID: <20190528105332.7c5a2f82.cohuck@redhat.com>
In-Reply-To: <20190527034342.31523-1-yan.y.zhao@intel.com>
References: <20190527034155.31473-1-yan.y.zhao@intel.com>
        <20190527034342.31523-1-yan.y.zhao@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 28 May 2019 08:53:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 May 2019 23:43:42 -0400
Yan Zhao <yan.y.zhao@intel.com> wrote:

> migration_version attribute is used to check migration compatibility
> between two mdev device of the same mdev type.

s/device/devices/

> The key is that it's rw and its data is opaque to userspace.
> 
> Userspace reads migration_version of mdev device at source side and
> writes the value to migration_version attribute of mdev device at target
> side. It judges migration compatibility according to whether the read
> and write operations succeed or fail.
> 
> As this attribute is under mdev_type node, userspace is able to know
> whether two mdev devices are compatible before a mdev device is created.
> 
> userspace needs to check whether the two mdev devices are of the same
> mdev type before checking the migration_version attribute. It also needs
> to check device creation parameters if aggregation is supported in
> future.
> 
>              __    userspace
>               /\              \
>              /                 \write
>             / read              \
>    ________/__________       ___\|/_____________
>   | migration_version |     | migration_version |-->check migration
>   ---------------------     ---------------------   compatibility
>     mdev device A               mdev device B
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
> 
> ---
> v3:
> 1. renamed version to migration_version
> (Christophe de Dinechin, Cornelia Huck, Alex Williamson)
> 2. let errno to be freely defined by vendor driver
> (Alex Williamson, Erik Skultety, Cornelia Huck, Dr. David Alan Gilbert)
> 3. let checking mdev_type be prerequisite of migration compatibility
> check. (Alex Williamson)
> 4. reworded example usage section.
> (most of this section came from Alex Williamson)
> 5. reworded attribute intention section (Cornelia Huck)
> 
> v2:
> 1. added detailed intent and usage
> 2. made definition of version string completely private to vendor driver
>    (Alex Williamson)
> 3. abandoned changes to sample mdev drivers (Alex Williamson)
> 4. mandatory --> optional (Cornelia Huck)
> 5. added description for errno (Cornelia Huck)
> ---
>  Documentation/vfio-mediated-device.txt | 113 +++++++++++++++++++++++++
>  1 file changed, 113 insertions(+)
> 

While I probably would have written a more compact description, your
version is fine with me as well.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
