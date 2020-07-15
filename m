Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981072206F3
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 10:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgGOIXb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 04:23:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729652AbgGOIXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 04:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594801408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H1N3KvEZTGjGVeuRJgwl++MJgD0/MJqWd13En7/X0GI=;
        b=FzHLoVeOLAnf6bvAltvJMoWhjK1MUb2YlgXgDRogdNoizY+UrxP+whsdDRpoYuV5wW733j
        CYEv+/mySXraD77h9aoQwUc7YcZmcf+qsyjD7TbuJbn1sMKg5rHsgP6ukJKU+MfzDUFo7Y
        DW75GSYV1sDztb5cKL5xbCyAYdYHXEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-1LaqrPl6Pga-cYMArC2aQg-1; Wed, 15 Jul 2020 04:23:26 -0400
X-MC-Unique: 1LaqrPl6Pga-cYMArC2aQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6874C8014D4;
        Wed, 15 Jul 2020 08:23:24 +0000 (UTC)
Received: from work-vm (ovpn-114-223.ams2.redhat.com [10.36.114.223])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65E9D60BF4;
        Wed, 15 Jul 2020 08:23:11 +0000 (UTC)
Date:   Wed, 15 Jul 2020 09:23:09 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
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
Message-ID: <20200715082309.GC2864@work-vm>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <20200714102129.GD25187@redhat.com>
 <20200714101616.5d3a9e75@x1.home>
 <20200714171946.GL2728@work-vm>
 <20200714145948.17b95eb3@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714145948.17b95eb3@x1.home>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Tue, 14 Jul 2020 18:19:46 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > On Tue, 14 Jul 2020 11:21:29 +0100
> > > Daniel P. Berrangé <berrange@redhat.com> wrote:
> > >   
> > > > On Tue, Jul 14, 2020 at 07:29:57AM +0800, Yan Zhao wrote:  
> > > > > hi folks,
> > > > > we are defining a device migration compatibility interface that helps upper
> > > > > layer stack like openstack/ovirt/libvirt to check if two devices are
> > > > > live migration compatible.
> > > > > The "devices" here could be MDEVs, physical devices, or hybrid of the two.
> > > > > e.g. we could use it to check whether
> > > > > - a src MDEV can migrate to a target MDEV,
> > > > > - a src VF in SRIOV can migrate to a target VF in SRIOV,
> > > > > - a src MDEV can migration to a target VF in SRIOV.
> > > > >   (e.g. SIOV/SRIOV backward compatibility case)
> > > > > 
> > > > > The upper layer stack could use this interface as the last step to check
> > > > > if one device is able to migrate to another device before triggering a real
> > > > > live migration procedure.
> > > > > we are not sure if this interface is of value or help to you. please don't
> > > > > hesitate to drop your valuable comments.
> > > > > 
> > > > > 
> > > > > (1) interface definition
> > > > > The interface is defined in below way:
> > > > > 
> > > > >              __    userspace
> > > > >               /\              \
> > > > >              /                 \write
> > > > >             / read              \
> > > > >    ________/__________       ___\|/_____________
> > > > >   | migration_version |     | migration_version |-->check migration
> > > > >   ---------------------     ---------------------   compatibility
> > > > >      device A                    device B
> > > > > 
> > > > > 
> > > > > a device attribute named migration_version is defined under each device's
> > > > > sysfs node. e.g. (/sys/bus/pci/devices/0000\:00\:02.0/$mdev_UUID/migration_version).
> > > > > userspace tools read the migration_version as a string from the source device,
> > > > > and write it to the migration_version sysfs attribute in the target device.
> > > > > 
> > > > > The userspace should treat ANY of below conditions as two devices not compatible:
> > > > > - any one of the two devices does not have a migration_version attribute
> > > > > - error when reading from migration_version attribute of one device
> > > > > - error when writing migration_version string of one device to
> > > > >   migration_version attribute of the other device
> > > > > 
> > > > > The string read from migration_version attribute is defined by device vendor
> > > > > driver and is completely opaque to the userspace.
> > > > > for a Intel vGPU, string format can be defined like
> > > > > "parent device PCI ID" + "version of gvt driver" + "mdev type" + "aggregator count".
> > > > > 
> > > > > for an NVMe VF connecting to a remote storage. it could be
> > > > > "PCI ID" + "driver version" + "configured remote storage URL"
> > > > > 
> > > > > for a QAT VF, it may be
> > > > > "PCI ID" + "driver version" + "supported encryption set".
> > > > > 
> > > > > (to avoid namespace confliction from each vendor, we may prefix a driver name to
> > > > > each migration_version string. e.g. i915-v1-8086-591d-i915-GVTg_V5_8-1)  
> > > 
> > > It's very strange to define it as opaque and then proceed to describe
> > > the contents of that opaque string.  The point is that its contents
> > > are defined by the vendor driver to describe the device, driver version,
> > > and possibly metadata about the configuration of the device.  One
> > > instance of a device might generate a different string from another.
> > > The string that a device produces is not necessarily the only string
> > > the vendor driver will accept, for example the driver might support
> > > backwards compatible migrations.  
> > 
> > (As I've said in the previous discussion, off one of the patch series)
> > 
> > My view is it makes sense to have a half-way house on the opaqueness of
> > this string; I'd expect to have an ID and version that are human
> > readable, maybe a device ID/name that's human interpretable and then a
> > bunch of other cruft that maybe device/vendor/version specific.
> > 
> > I'm thinking that we want to be able to report problems and include the
> > string and the user to be able to easily identify the device that was
> > complaining and notice a difference in versions, and perhaps also use
> > it in compatibility patterns to find compatible hosts; but that does
> > get tricky when it's a 'ask the device if it's compatible'.
> 
> In the reply I just sent to Dan, I gave this example of what a
> "compatibility string" might look like represented as json:
> 
> {
>   "device_api": "vfio-pci",
>   "vendor": "vendor-driver-name",
>   "version": {
>     "major": 0,
>     "minor": 1
>   },
>   "vfio-pci": { // Based on above device_api
>     "vendor": 0x1234, // Values for the exposed device
>     "device": 0x5678,
>       // Possibly further parameters for a more specific match
>   },
>   "mdev_attrs": [
>     { "attribute0": "VALUE" }
>   ]
> }
> 
> Are you thinking that we might allow the vendor to include a vendor
> specific array where we'd simply require that both sides have matching
> fields and values?  ie.
> 
>   "vendor_fields": [
>     { "unknown_field0": "unknown_value0" },
>     { "unknown_field1": "unknown_value1" },
>   ]
> 
> We could certainly make that part of the spec, but I can't really
> figure the value of it other than to severely restrict compatibility,
> which the vendor could already do via the version.major value.  Maybe
> they'd want to put a build timestamp, random uuid, or source sha1 into
> such a field to make absolutely certain compatibility is only determined
> between identical builds?  Thanks,

No, I'd mostly anticipated matching on the vendor and device and maybe a
version number for the bit the user specifies; I had assumed all that
'vendor cruft' was still mostly opaque; having said that, if it did
become a list of attributes like that (some of which were vendor
specific) that would make sense to me.

Dave

> 
> Alex
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

