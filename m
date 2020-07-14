Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0221F708
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 18:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgGNQQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 12:16:31 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32744 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726062AbgGNQQb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jul 2020 12:16:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594743388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JzLzq9mlnBFti2euSu/23DFRBEzhfPDxL3/5Phwg7w=;
        b=KXA1ZpclRvQMvNIvGjLUAdlYWxwvIUZWgVcGFUOCnPwfAjZpAkQDavAzkiY/4nMKE4pkh0
        T958B6JGrcOLtxqvfP/BB0CR3JBlfVzeChHnChhdv5MDCTuUqYH424qW9FBiaaP/X4LAxc
        iVVek7gptMbyHjPtx4TSMCZIPKbcQrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-q1Vi85UaOhSx0YHAEnghPQ-1; Tue, 14 Jul 2020 12:16:27 -0400
X-MC-Unique: q1Vi85UaOhSx0YHAEnghPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FE4C800597;
        Tue, 14 Jul 2020 16:16:25 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CCC4710A0;
        Tue, 14 Jul 2020 16:16:17 +0000 (UTC)
Date:   Tue, 14 Jul 2020 10:16:16 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, smooney@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, corbet@lwn.net,
        kwankhede@nvidia.com, dgilbert@redhat.com, eauger@redhat.com,
        jian-feng.ding@intel.com, hejie.xu@intel.com, kevin.tian@intel.com,
        zhenyuw@linux.intel.com, bao.yumeng@zte.com.cn,
        xin-ran.wang@intel.com, shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200714101616.5d3a9e75@x1.home>
In-Reply-To: <20200714102129.GD25187@redhat.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
        <20200714102129.GD25187@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 11:21:29 +0100
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote:
> > hi folks,
> > we are defining a device migration compatibility interface that helps u=
pper
> > layer stack like openstack/ovirt/libvirt to check if two devices are
> > live migration compatible.
> > The "devices" here could be MDEVs, physical devices, or hybrid of the t=
wo.
> > e.g. we could use it to check whether
> > - a src MDEV can migrate to a target MDEV,
> > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > - a src MDEV can migration to a target VF in SRIOV.
> >   (e.g. SIOV/SRIOV backward compatibility case)
> >=20
> > The upper layer stack could use this interface as the last step to check
> > if one device is able to migrate to another device before triggering a =
real
> > live migration procedure.
> > we are not sure if this interface is of value or help to you. please do=
n't
> > hesitate to drop your valuable comments.
> >=20
> >=20
> > (1) interface definition
> > The interface is defined in below way:
> >=20
> >              __    userspace
> >               /\              \
> >              /                 \write
> >             / read              \
> >    ________/__________       ___\|/_____________
> >   | migration_version |     | migration_version |-->check migration
> >   ---------------------     ---------------------   compatibility
> >      device A                    device B
> >=20
> >=20
> > a device attribute named migration_version is defined under each device=
's
> > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migrat=
ion_version).
> > userspace tools read the migration_version as a string from the source =
device,
> > and write it to the migration_version sysfs attribute in the target dev=
ice.
> >=20
> > The userspace should treat ANY of below conditions as two devices not c=
ompatible:
> > - any one of the two devices does not have a migration_version attribute
> > - error when reading from migration_version attribute of one device
> > - error when writing migration_version string of one device to
> >   migration_version attribute of the other device
> >=20
> > The string read from migration_version attribute is defined by device v=
endor
> > driver and is completely opaque to the userspace.
> > for a Intel vGPU, string format can be defined like
> > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggre=
gator count".
> >=20
> > for an NVMe VF connecting to a remote storage. it could be
> > "PCI ID" + "driver version" + "configured remote storage URL"
> >=20
> > for a QAT VF, it may be
> > "PCI ID" + "driver version" + "supported encryption set".
> >=20
> > (to avoid namespace confliction from each vendor, we may prefix a drive=
r name to
> > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)

It's very strange to define it as opaque and then proceed to describe
the contents of that opaque string.  The point is that its contents
are defined by the vendor driver to describe the device, driver version,
and possibly metadata about the configuration of the device.  One
instance of a device might generate a different string from another.
The string that a device produces is not necessarily the only string
the vendor driver will accept, for example the driver might support
backwards compatible migrations.

> > (2) backgrounds
> >=20
> > The reason we hope the migration_version string is opaque to the usersp=
ace
> > is that it is hard to generalize standard comparing fields and comparing
> > methods for different devices from different vendors.
> > Though userspace now could still do a simple string compare to check if
> > two devices are compatible, and result should also be right, it's still
> > too limited as it excludes the possible candidate whose migration_versi=
on
> > string fails to be equal.
> > e.g. an MDEV with mdev_type_1, aggregator count 3 is probably compatible
> > with another MDEV with mdev_type_3, aggregator count 1, even their
> > migration_version strings are not equal.
> > (assumed mdev_type_3 is of 3 times equal resources of mdev_type_1).
> >=20
> > besides that, driver version + configured resources are all elements de=
manding
> > to take into account.
> >=20
> > So, we hope leaving the freedom to vendor driver and let it make the fi=
nal decision
> > in a simple reading from source side and writing for test in the target=
 side way.
> >=20
> >=20
> > we then think the device compatibility issues for live migration with a=
ssigned
> > devices can be divided into two steps:
> > a. management tools filter out possible migration target devices.
> >    Tags could be created according to info from product specification.
> >    we think openstack/ovirt may have vendor proprietary components to c=
reate
> >    those customized tags for each product from each vendor. =20
>=20
> >    for Intel vGPU, with a vGPU(a MDEV device) in source side, the tags =
to
> >    search target vGPU are like:
> >    a tag for compatible parent PCI IDs,
> >    a tag for a range of gvt driver versions,
> >    a tag for a range of mdev type + aggregator count
> >=20
> >    for NVMe VF, the tags to search target VF may be like:
> >    a tag for compatible PCI IDs,
> >    a tag for a range of driver versions,
> >    a tag for URL of configured remote storage. =20

I interpret this as hand waving, ie. the first step is for management
tools to make a good guess :-\  We don't seem to be willing to say that
a given mdev type can only migrate to a device with that same type.
There's this aggregation discussion happening separately where a base
mdev type might be created or later configured to be equivalent to a
different type.  The vfio migration API we've defined is also not
limited to mdev devices, for example we could create vendor specific
quirks or hooks to provide migration support for a physical PF/VF
device.  Within the realm of possibility then is that we could migrate
between a physical device and an mdev device, which are simply
different degrees of creating a virtualization layer in front of the
device.
=20
> Requiring management application developers to figure out this possible
> compatibility based on prod specs is really unrealistic. Product specs
> are typically as clear as mud, and with the suggestion we consider
> different rules for different types of devices, add up to a huge amount
> of complexity. This isn't something app developers should have to spend
> their time figuring out.

Agreed.

> The suggestion that we make use of vendor proprietary helper components
> is totally unacceptable. We need to be able to build a solution that
> works with exclusively an open source software stack.

I'm surprised to see this as well, but I'm not sure if Yan was really
suggesting proprietary software so much as just vendor specific
knowledge.

> IMHO there needs to be a mechanism for the kernel to report via sysfs
> what versions are supported on a given device. This puts the job of
> reporting compatible versions directly under the responsibility of the
> vendor who writes the kernel driver for it. They are the ones with the
> best knowledge of the hardware they've built and the rules around its
> compatibility.

The version string discussed previously is the version string that
represents a given device, possibly including driver information,
configuration, etc.  I think what you're asking for here is an
enumeration of every possible version string that a given device could
accept as an incoming migration stream.  If we consider the string as
opaque, that means the vendor driver needs to generate a separate
string for every possible version it could accept, for every possible
configuration option.  That potentially becomes an excessive amount of
data to either generate or manage.

Am I overestimating how vendors intend to use the version string?

We'd also need to consider devices that we could create, for instance
providing the same interface enumeration prior to creating an mdev
device to have a confidence level that the new device would be a valid
target.

We defined the string as opaque to allow vendor flexibility and because
defining a common format is hard.  Do we need to revisit this part of
the discussion to define the version string as non-opaque with parsing
rules, probably with separate incoming vs outgoing interfaces?  Thanks,

Alex

