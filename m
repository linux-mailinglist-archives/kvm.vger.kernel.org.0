Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB631A94FC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 09:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635255AbgDOHna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 03:43:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2635245AbgDOHnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 03:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586936601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1OHfgn9pPaDAsC+K8et0tvkSEtEL5Qfqe8kjye9uA/o=;
        b=BD+JWslc2xokOS+582PkwkI+6wM2nq/8fetaFbxuluDPhyEYYjjyT+Z0S/nYjxW5aBWRKP
        xYyLHvzln4VlPXI962yjSUCar/D2iUD0QA3rDBBRWOUj2GAfXFozdb90SeTUTC1DJYmI1m
        A1yz/YUVKCvppbw68eYgbEY68drGPgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-XK4FppVTPWSD-eyzXPObBg-1; Wed, 15 Apr 2020 03:43:17 -0400
X-MC-Unique: XK4FppVTPWSD-eyzXPObBg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D3DD8017F5;
        Wed, 15 Apr 2020 07:43:14 +0000 (UTC)
Received: from sturgeon (unknown [10.40.192.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0F761000337;
        Wed, 15 Apr 2020 07:43:00 +0000 (UTC)
Date:   Wed, 15 Apr 2020 09:42:58 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     intel-gvt-dev@lists.freedesktop.org, cjia@nvidia.com,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        libvir-list@redhat.com, Zhengxiao.zx@alibaba-inc.com,
        shuangtai.tst@alibaba-inc.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, corbet@lwn.net,
        yi.l.liu@intel.com, ziye.yang@intel.com, mlevitsk@redhat.com,
        pasic@linux.ibm.com, aik@ozlabs.ru, felipe@nutanix.com,
        Ken.Xue@amd.com, kevin.tian@intel.com, xin.zeng@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, dinechin@redhat.com,
        changpeng.liu@intel.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, zhi.a.wang@intel.com,
        jonathan.davies@nutanix.com, shaopeng.he@intel.com
Subject: Re: [PATCH v5 3/4] vfio/mdev: add migration_version attribute for
 mdev (under mdev device node)
Message-ID: <20200415074258.GK269314@sturgeon>
References: <20200413055201.27053-1-yan.y.zhao@intel.com>
 <20200413055504.27311-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200413055504.27311-1-yan.y.zhao@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 01:55:04AM -0400, Yan Zhao wrote:
> migration_version attribute is used to check migration compatibility
> between two mdev devices of the same mdev type.
> The key is that it's rw and its data is opaque to userspace.
>
> Userspace reads migration_version of mdev device at source side and
> writes the value to migration_version attribute of mdev device at targe=
t
> side. It judges migration compatibility according to whether the read
> and write operations succeed or fail.
>
> Currently, it is able to read/write migration_version attribute under t=
wo
> places:
>
> (1) under mdev_type node
> userspace is able to know whether two mdev devices are compatible befor=
e
> a mdev device is created.
>
> userspace also needs to check whether the two mdev devices are of the s=
ame
> mdev type before checking the migration_version attribute. It also need=
s
> to check device creation parameters if aggregation is supported in futu=
re.
>
> (2) under mdev device node
> userspace is able to know whether two mdev devices are compatible after
> they are all created. But it does not need to check mdev type and devic=
e
> creation parameter for aggregation as device vendor driver would have
> incorporated those information into the migration_version attribute.
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
> This patch is for mdev documentation about the second place (under
> mdev device node)
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
> Cc: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> Cc: Christophe de Dinechin <dinechin@redhat.com>
>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 70 +++++++++++++++++++
>  1 file changed, 70 insertions(+)
>
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Docume=
ntation/driver-api/vfio-mediated-device.rst
> index 2d1f3c0f3c8f..efbadfd51b7e 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -383,6 +383,7 @@ Directories and Files Under the sysfs for Each mdev=
 Device
>           |--- remove
>           |--- mdev_type {link to its type}
>           |--- vendor-specific-attributes [optional]
> +         |--- migration_verion [optional]
>
>  * remove (write only)
>
> @@ -394,6 +395,75 @@ Example::
>
>  	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
>
> +* migration_version (rw, optional)

Hmm, ^this is not consistent with how patch 1/5 reports this information,=
 but
looking at the existing docs we're not doing very well in terms of consis=
tency
there either.

I suggest we go with "(read-write)" in both patch 1/5 and here and then s=
tart
the paragraph with "This is an optional attribute."

> +  It is used to check migration compatibility between two mdev devices=
.
> +  Absence of this attribute means the mdev device does not support mig=
ration.
> +
> +  This attribute provides a way to check migration compatibility betwe=
en two
> +  mdev devices from userspace after device created. The intended usage=
 is

after the target device has been created.

side note: maybe add something like "(see the migration_version attribute=
 of
the device node if the target device already exists)" in the same section=
 in
patch 1/5.

> +  for userspace to read the migration_version attribute from one mdev =
device and
> +  then writing that value to the migration_version attribute of the ot=
her mdev
> +  device. The second mdev device indicates compatibility via the retur=
n code of
> +  the write operation. This makes compatibility between mdev devices c=
ompletely
> +  vendor-defined and opaque to userspace. Userspace should do nothing =
more
> +  than use the migration_version attribute to confirm source to target
> +  compatibility.

...

> +
> +  Reading/Writing Attribute Data:
> +  read(2) will fail if a mdev device does not support migration and ot=
herwise
> +        succeed and return migration_version string of the mdev device=
.
> +
> +        This migration_version string is vendor defined and opaque to =
the
> +        userspace. Vendor is free to include whatever they feel is rel=
evant.
> +        e.g. <pciid of parent device>-<software version>.
> +
> +        Restrictions on this migration_version string:
> +            1. It should only contain ascii characters
> +            2. MAX Length is PATH_MAX (4096)
> +
> +  write(2) expects migration_version string of source mdev device, and=
 will
> +         succeed if it is determined to be compatible and otherwise fa=
il with
> +         vendor specific errno.
> +
> +  Errno:
> +  -An errno on read(2) indicates the mdev devicedoes not support migra=
tion;

s/devicedoes/device does/

> +  -An errno on write(2) indicates the mdev devices are incompatible or=
 the
> +   target doesn't support migration.
> +  Vendor driver is free to define specific errno and is suggested to
> +  print detailed error in syslog for diagnose purpose.
> +
> +  Userspace should treat ANY of below conditions as two mdev devices n=
ot
> +  compatible:
> +  (1) any one of the two mdev devices does not have a migration_versio=
n
> +  attribute
> +  (2) error when reading from migration_version attribute of one mdev =
device
> +  (3) error when writing migration_version string of one mdev device t=
o
> +  migration_version attribute of the other mdev device
> +
> +  Userspace should regard two mdev devices compatible when ALL of belo=
w
> +  conditions are met:
> +  (1) success when reading from migration_version attribute of one mde=
v device.
> +  (2) success when writing migration_version string of one mdev device=
 to
> +  migration_version attribute of the other mdev device.
> +
> +  Example Usage:
> +  (1) Retrieve the mdev source migration_version:
> +
> +  # cat /sys/bus/mdev/devices/$mdev_UUID1/migration_version
> +
> +  If reading the source migration_version generates an error, migratio=
n is not
> +  possible.
> +
> +  (2) Test source migration_version at target:
> +
> +  Given a migration_version as outlined above, its compatibility to an
> +  instantiated device of the same mdev type can be tested as:
> +  # echo $VERSION > /sys/bus/mdev/devices/$mdev_UUID2/migration_versio=
n
> +
> +  If this write fails, the source and target migration versions are no=
t
> +  compatible or the target does not support migration.
> +
> +
>  Mediated device Hot plug
>  ------------------------

Overall, the same comments as in 1/5 apply text-wise.

Regards,
--
Erik Skultety

