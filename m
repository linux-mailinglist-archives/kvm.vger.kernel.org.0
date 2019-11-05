Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD0BF07CC
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfKEVKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 16:10:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728515AbfKEVKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 16:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572988247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EmLe1gmgcHHj33MeXBIBj/7G1klvYJ3zwjawejfOLSs=;
        b=J+BfdH/GOQcTzHkwSi8WbYEqQBFgh7RUzu3OJMKWSVtORS4Cl2CYBSVIiiR47S3b7tUhh/
        47L8O/oGZdciwi8GKdCk5HfbGzkLXT1tLmxWV9BsugHAQhkSFqQX2pKZ9y4kq6C5T+udI5
        n/p1kBKAq6BxuClRibJtKYh5OkWXXEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-Gh2dD4jDO92z153iphuTSA-1; Tue, 05 Nov 2019 16:10:45 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4CA477;
        Tue,  5 Nov 2019 21:10:44 +0000 (UTC)
Received: from x1.home (ovpn-116-110.phx2.redhat.com [10.3.116.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 277022898B;
        Tue,  5 Nov 2019 21:10:43 +0000 (UTC)
Date:   Tue, 5 Nov 2019 14:10:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     kvm@vger.kernel.org, kwankhede@nvidia.com, kevin.tian@intel.com,
        cohuck@redhat.com, Libvirt Devel <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Message-ID: <20191105141042.17dd2d7d@x1.home>
In-Reply-To: <20191024050829.4517-1-zhenyuw@linux.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Gh2dD4jDO92z153iphuTSA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Oct 2019 13:08:23 +0800
Zhenyu Wang <zhenyuw@linux.intel.com> wrote:

> Hi,
>=20
> This is a refresh for previous send of this series. I got impression that
> some SIOV drivers would still deploy their own create and config method s=
o
> stopped effort on this. But seems this would still be useful for some oth=
er
> SIOV driver which may simply want capability to aggregate resources. So h=
ere's
> refreshed series.
>=20
> Current mdev device create interface depends on fixed mdev type, which ge=
t uuid
> from user to create instance of mdev device. If user wants to use customi=
zed
> number of resource for mdev device, then only can create new mdev type fo=
r that
> which may not be flexible. This requirement comes not only from to be abl=
e to
> allocate flexible resources for KVMGT, but also from Intel scalable IO
> virtualization which would use vfio/mdev to be able to allocate arbitrary
> resources on mdev instance. More info on [1] [2] [3].
>=20
> To allow to create user defined resources for mdev, it trys to extend mde=
v
> create interface by adding new "aggregate=3Dxxx" parameter following UUID=
, for
> target mdev type if aggregation is supported, it can create new mdev devi=
ce
> which contains resources combined by number of instances, e.g
>=20
>     echo "<uuid>,aggregate=3D10" > create
>=20
> VM manager e.g libvirt can check mdev type with "aggregation" attribute w=
hich
> can support this setting. If no "aggregation" attribute found for mdev ty=
pe,
> previous behavior is still kept for one instance allocation. And new sysf=
s
> attribute "aggregated_instances" is created for each mdev device to show =
allocated number.

Given discussions we've had recently around libvirt interacting with
mdev, I think that libvirt would rather have an abstract interface via
mdevctl[1].  Therefore can you evaluate how mdevctl would support this
creation extension?  It seems like it would fit within the existing
mdev and mdevctl framework if aggregation were simply a sysfs attribute
for the device.  For example, the mdevctl steps might look like this:

mdevctl define -u UUID -p PARENT -t TYPE
mdevctl modify -u UUID --addattr=3Dmdev/aggregation --value=3D2
mdevctl start -u UUID

When mdevctl starts the mdev, it will first create it using the
existing mechanism, then apply aggregation attribute, which can consume
the necessary additional instances from the parent device, or return an
error, which would unwind and return a failure code to the caller
(libvirt).  I think the vendor driver would then have freedom to decide
when the attribute could be modified, for instance it would be entirely
reasonable to return -EBUSY if the user attempts to modify the
attribute while the mdev device is in-use.  Effectively aggregation
simply becomes a standardized attribute with common meaning.  Thoughts?
[cc libvirt folks for their impression] Thanks,

Alex

[1] https://github.com/mdevctl/mdevctl

> References:
> [1] https://software.intel.com/en-us/download/intel-virtualization-techno=
logy-for-directed-io-architecture-specification
> [2] https://software.intel.com/en-us/download/intel-scalable-io-virtualiz=
ation-technical-specification
> [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
>=20
> Zhenyu Wang (6):
>   vfio/mdev: Add new "aggregate" parameter for mdev create
>   vfio/mdev: Add "aggregation" attribute for supported mdev type
>   vfio/mdev: Add "aggregated_instances" attribute for supported mdev
>     device
>   Documentation/driver-api/vfio-mediated-device.rst: Update for
>     vfio/mdev aggregation support
>   Documentation/ABI/testing/sysfs-bus-vfio-mdev: Update for vfio/mdev
>     aggregation support
>   drm/i915/gvt: Add new type with aggregation support
>=20
>  Documentation/ABI/testing/sysfs-bus-vfio-mdev | 24 ++++++
>  .../driver-api/vfio-mediated-device.rst       | 23 ++++++
>  drivers/gpu/drm/i915/gvt/gvt.c                |  4 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                | 11 ++-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 53 ++++++++++++-
>  drivers/gpu/drm/i915/gvt/vgpu.c               | 56 ++++++++++++-
>  drivers/vfio/mdev/mdev_core.c                 | 36 ++++++++-
>  drivers/vfio/mdev/mdev_private.h              |  6 +-
>  drivers/vfio/mdev/mdev_sysfs.c                | 79 ++++++++++++++++++-
>  include/linux/mdev.h                          | 19 +++++
>  10 files changed, 294 insertions(+), 17 deletions(-)
>=20

