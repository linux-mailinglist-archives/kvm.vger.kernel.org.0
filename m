Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0517321FF5C
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 23:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGNVAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 17:00:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726768AbgGNVAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 17:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594760421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSM5fxb0uVcO9SHCvJ1b0FiIX2VVoi8pq0fYNwpoFkw=;
        b=HVrNrLxbLswJwFhfp3/lfBw8E6Qf9MMWuB9okMw5m88QBratG9EajfAMye0aAwxNKvVGoQ
        oTB6MynKn4I0JZTncLLc0cYtE8cmciKDb2EvWD52y6kNf4B8MpuR/PbVO9PrhEhrZcBzor
        M8sbxbPPzEAwl/K8rewbdLu3eRyD5XM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-CagJpU0GMwKjZGZf3TfEbQ-1; Tue, 14 Jul 2020 17:00:18 -0400
X-MC-Unique: CagJpU0GMwKjZGZf3TfEbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B450A4D15;
        Tue, 14 Jul 2020 21:00:12 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8DB610013C3;
        Tue, 14 Jul 2020 20:59:48 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:59:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, devel@ovirt.org,
        openstack-discuss@lists.openstack.org, libvir-list@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, smooney@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dinechin@redhat.com, corbet@lwn.net,
        kwankhede@nvidia.com, eauger@redhat.com, jian-feng.ding@intel.com,
        hejie.xu@intel.com, kevin.tian@intel.com, zhenyuw@linux.intel.com,
        bao.yumeng@zte.com.cn, xin-ran.wang@intel.com,
        shaohe.feng@intel.com
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200714145948.17b95eb3@x1.home>
In-Reply-To: <20200714171946.GL2728@work-vm>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
        <20200714102129.GD25187@redhat.com>
        <20200714101616.5d3a9e75@x1.home>
        <20200714171946.GL2728@work-vm>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 18:19:46 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > On Tue, 14 Jul 2020 11:21:29 +0100
> > Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:
> >  =20
> > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote: =20
> > > > hi folks,
> > > > we are defining a device migration compatibility interface that hel=
ps upper
> > > > layer stack like openstack/ovirt/libvirt to check if two devices are
> > > > live migration compatible.
> > > > The "devices" here could be MDEVs, physical devices, or hybrid of t=
he two.
> > > > e.g. we could use it to check whether
> > > > - a src MDEV can migrate to a target MDEV,
> > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > > > - a src MDEV can migration to a target VF in SRIOV.
> > > >   (e.g. SIOV/SRIOV backward compatibility case)
> > > >=20
> > > > The upper layer stack could use this interface as the last step to =
check
> > > > if one device is able to migrate to another device before triggerin=
g a real
> > > > live migration procedure.
> > > > we are not sure if this interface is of value or help to you. pleas=
e don't
> > > > hesitate to drop your valuable comments.
> > > >=20
> > > >=20
> > > > (1) interface definition
> > > > The interface is defined in below way:
> > > >=20
> > > >              __    userspace
> > > >               /\              \
> > > >              /                 \write
> > > >             / read              \
> > > >    ________/__________       ___\|/_____________
> > > >   | migration_version |     | migration_version |-->check migration
> > > >   ---------------------     ---------------------   compatibility
> > > >      device A                    device B
> > > >=20
> > > >=20
> > > > a device attribute named migration_version is defined under each de=
vice's
> > > > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/mi=
gration_version).
> > > > userspace tools read the migration_version as a string from the sou=
rce device,
> > > > and write it to the migration_version sysfs attribute in the target=
 device.
> > > >=20
> > > > The userspace should treat ANY of below conditions as two devices n=
ot compatible:
> > > > - any one of the two devices does not have a migration_version attr=
ibute
> > > > - error when reading from migration_version attribute of one device
> > > > - error when writing migration_version string of one device to
> > > >   migration_version attribute of the other device
> > > >=20
> > > > The string read from migration_version attribute is defined by devi=
ce vendor
> > > > driver and is completely opaque to the userspace.
> > > > for a Intel vGPU, string format can be defined like
> > > > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "a=
ggregator count".
> > > >=20
> > > > for an NVMe VF connecting to a remote storage. it could be
> > > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > >=20
> > > > for a QAT VF, it may be
> > > > "PCI ID" + "driver version" + "supported encryption set".
> > > >=20
> > > > (to avoid namespace confliction from each vendor, we may prefix a d=
river name to
> > > > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_=
8-1) =20
> >=20
> > It's very strange to define it as opaque and then proceed to describe
> > the contents of that opaque string.  The point is that its contents
> > are defined by the vendor driver to describe the device, driver version,
> > and possibly metadata about the configuration of the device.  One
> > instance of a device might generate a different string from another.
> > The string that a device produces is not necessarily the only string
> > the vendor driver will accept, for example the driver might support
> > backwards compatible migrations. =20
>=20
> (As I've said in the previous discussion, off one of the patch series)
>=20
> My view is it makes sense to have a half-way house on the opaqueness of
> this string; I'd expect to have an ID and version that are human
> readable, maybe a device ID/name that's human interpretable and then a
> bunch of other cruft that maybe device/vendor/version specific.
>=20
> I'm thinking that we want to be able to report problems and include the
> string and the user to be able to easily identify the device that was
> complaining and notice a difference in versions, and perhaps also use
> it in compatibility patterns to find compatible hosts; but that does
> get tricky when it's a 'ask the device if it's compatible'.

In the reply I just sent to Dan, I gave this example of what a
"compatibility string" might look like represented as json:

{
  "device_api": "vfio-pci",
  "vendor": "vendor-driver-name",
  "version": {
    "major": 0,
    "minor": 1
  },
  "vfio-pci": { // Based on above device_api
    "vendor": 0x1234, // Values for the exposed device
    "device": 0x5678,
      // Possibly further parameters for a more specific match
  },
  "mdev_attrs": [
    { "attribute0": "VALUE" }
  ]
}

Are you thinking that we might allow the vendor to include a vendor
specific array where we'd simply require that both sides have matching
fields and values?  ie.

  "vendor_fields": [
    { "unknown_field0": "unknown_value0" },
    { "unknown_field1": "unknown_value1" },
  ]

We could certainly make that part of the spec, but I can't really
figure the value of it other than to severely restrict compatibility,
which the vendor could already do via the version.major value.  Maybe
they'd want to put a build timestamp, random uuid, or source sha1 into
such a field to make absolutely certain compatibility is only determined
between identical builds?  Thanks,

Alex

