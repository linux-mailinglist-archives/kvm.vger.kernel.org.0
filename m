Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDED4FD39F
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 05:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKOEYj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 14 Nov 2019 23:24:39 -0500
Received: from mga12.intel.com ([192.55.52.136]:57184 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfKOEYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 23:24:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 20:24:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,307,1569308400"; 
   d="scan'208";a="208321934"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2019 20:24:38 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 20:24:37 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Fri, 15 Nov 2019 12:24:35 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Libvirt Devel" <libvir-list@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        Jonathon Jongsma <jjongsma@redhat.com>
Subject: RE: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikbbkH6FUlQ7kukEPc4R6T+S6d8oIgAgAB4FoCAAPFxAIANs7pw
Date:   Fri, 15 Nov 2019 04:24:35 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5F69A5@SHSMSX104.ccr.corp.intel.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
        <20191105141042.17dd2d7d@x1.home>
        <20191106042031.GJ1769@zhen-hp.sh.intel.com>
 <20191106114440.7314713e@x1.home>
In-Reply-To: <20191106114440.7314713e@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMThhOGQ1ZjYtMDg3OC00NmQ4LThkMTktMjQ0MjE4YmUxYWNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSkZuR2RkUFBrU0I5RG9cLzk2NFMyd2p2WWwyXC9NakJRaFRKNHV3SFdxRDdjcG9WRmN6RHJPTGoyblJrbGhKU0RFIn0=
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Thursday, November 7, 2019 2:45 AM
> 
> On Wed, 6 Nov 2019 12:20:31 +0800
> Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> 
> > On 2019.11.05 14:10:42 -0700, Alex Williamson wrote:
> > > On Thu, 24 Oct 2019 13:08:23 +0800
> > > Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > >
> > > > Hi,
> > > >
> > > > This is a refresh for previous send of this series. I got impression that
> > > > some SIOV drivers would still deploy their own create and config
> method so
> > > > stopped effort on this. But seems this would still be useful for some
> other
> > > > SIOV driver which may simply want capability to aggregate resources.
> So here's
> > > > refreshed series.
> > > >
> > > > Current mdev device create interface depends on fixed mdev type,
> which get uuid
> > > > from user to create instance of mdev device. If user wants to use
> customized
> > > > number of resource for mdev device, then only can create new mdev
> type for that
> > > > which may not be flexible. This requirement comes not only from to
> be able to
> > > > allocate flexible resources for KVMGT, but also from Intel scalable IO
> > > > virtualization which would use vfio/mdev to be able to allocate
> arbitrary
> > > > resources on mdev instance. More info on [1] [2] [3].
> > > >
> > > > To allow to create user defined resources for mdev, it trys to extend
> mdev
> > > > create interface by adding new "aggregate=xxx" parameter following
> UUID, for
> > > > target mdev type if aggregation is supported, it can create new mdev
> device
> > > > which contains resources combined by number of instances, e.g
> > > >
> > > >     echo "<uuid>,aggregate=10" > create
> > > >
> > > > VM manager e.g libvirt can check mdev type with "aggregation"
> attribute which
> > > > can support this setting. If no "aggregation" attribute found for mdev
> type,
> > > > previous behavior is still kept for one instance allocation. And new
> sysfs
> > > > attribute "aggregated_instances" is created for each mdev device to
> show allocated number.
> > >
> > > Given discussions we've had recently around libvirt interacting with
> > > mdev, I think that libvirt would rather have an abstract interface via
> > > mdevctl[1].  Therefore can you evaluate how mdevctl would support
> this
> > > creation extension?  It seems like it would fit within the existing
> > > mdev and mdevctl framework if aggregation were simply a sysfs
> attribute
> > > for the device.  For example, the mdevctl steps might look like this:
> > >
> > > mdevctl define -u UUID -p PARENT -t TYPE
> > > mdevctl modify -u UUID --addattr=mdev/aggregation --value=2
> > > mdevctl start -u UUID

Hi, Alex, can you elaborate why a sysfs attribute is more friendly
to mdevctl? what is the complexity if having mdevctl to pass
additional parameter at creation time as this series originally 
proposed? Just want to clearly understand the limitation of the
parameter way. :-)

> > >
> > > When mdevctl starts the mdev, it will first create it using the
> > > existing mechanism, then apply aggregation attribute, which can
> consume
> > > the necessary additional instances from the parent device, or return an
> > > error, which would unwind and return a failure code to the caller
> > > (libvirt).  I think the vendor driver would then have freedom to decide
> > > when the attribute could be modified, for instance it would be entirely
> > > reasonable to return -EBUSY if the user attempts to modify the
> > > attribute while the mdev device is in-use.  Effectively aggregation
> > > simply becomes a standardized attribute with common meaning.
> Thoughts?
> > > [cc libvirt folks for their impression] Thanks,
> >
> > I think one problem is that before mdevctl start to create mdev you
> > don't know what vendor attributes are, as we apply mdev attributes
> > after create. You may need some lookup depending on parent.. I think
> > making aggregation like other vendor attribute for mdev might be the
> > simplest way, but do we want to define its behavior in formal? e.g
> > like previous discussed it should show maxium instances for aggregation,
> etc.
> 
> Yes, we'd still want to standardize how we enable and discover
> aggregation since we expect multiple users.  Even if libvirt were to
> use mdevctl as it's mdev interface, higher level tools should have an
> introspection mechanism available.  Possibly the sysfs interfaces
> proposed in this series remains largely the same, but I think perhaps
> the implementation of them moves out to the vendor driver.  In fact,
> perhaps the only change to mdev core is to define the standard.  For
> example, the "aggregation" attribute on the type is potentially simply
> a defined, optional, per type attribute, similar to "name" and
> "description".  For "aggregated_instances" we already have the
> mdev_attr_groups of the mdev_parent_ops, we could define an
> attribute_group with .name = "mdev" as a set of standardized
> attributes, such that vendors could provide both their own vendor
> specific attributes and per device attributes with a common meaning and
> semantic defined in the mdev ABI.

such standardization sounds good.

> 
> > The behavior change for driver is that previously aggregation is
> > handled at create time, but for sysfs attr it should handle any
> > resource allocation before it's really in-use. I think some SIOV
> > driver which already requires some specific config should be ok,
> > but not sure for other driver which might not be explored in this before.
> > Would that be a problem? Kevin?
> 
> Right, I'm assuming the aggregation could be modified until the device
> is actually opened, the driver can nak the aggregation request by
> returning an errno to the attribute write.  I'm trying to anticipate
> whether this introduces new complications, for instances races with
> contiguous allocations.  I think these seem solvable within the vendor
> drivers, but please note it if I'm wrong.  Thanks,
> 

So far I didn't see a problem with this way. Regarding to contiguous
allocations, ideally it should be fine as long as aggregation paths are
properly locked similar  as creation paths when allocating resources.
It will introduce some additional work in vendor driver but such
overhead is worthy if it leads to cleaner uapi.

There is one open though. In concept the aggregation feature can
be used for both increasing and decreasing the resource when 
exposing as a sysfs attribute, any time when the device is not in-use. 
Increasing resource is possibly fine, but I'm not sure about decreasing
resource. Is there any vendor driver which cannot afford resource
decrease once it has ever been used (after deassignment), or require
at least an explicit reset before decrease? If yes, how do we report
such special requirement (only-once, multiple-times, multiple-times-
before-1st-usage) to user space?

It's sort of like what Cornelia commented about standardization
of post-creation resource configuration. If it may end up to be
a complex story (or at least take time to understand/standardize
all kinds of requirements), does it still make sense to support
creation-time parameter as a quick-path for this aggregation feature? :-)

Thanks
Kevin
