Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE2218FEB
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 20:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGHSsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 14:48:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26179 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbgGHSsM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 14:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594234089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IVUxDtXB+Qqd5NeebgBiGt7MkjFkxLkx6xiTjpS2ckc=;
        b=A8sEEbGdAQC9LvcIrSHjhtOhq28AXcNnEmhVO62Dh5ztKvGXq5+g+vnZ5hs426FRL05XK9
        HaBxBNEFOrZ+fg5Ix8KzA/EUiv61Fi/w/YiNeB00BfsHLB1S7uZTwiYwfjAwqlG3vS6Naa
        XFvPz60xa2hIkKtbNBgxoaxUPYYh2zU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-82YFVr6DNUe-4IHUUkPb1g-1; Wed, 08 Jul 2020 14:48:08 -0400
X-MC-Unique: 82YFVr6DNUe-4IHUUkPb1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3AE180183C;
        Wed,  8 Jul 2020 18:48:06 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 841495D9C9;
        Wed,  8 Jul 2020 18:48:06 +0000 (UTC)
Date:   Wed, 8 Jul 2020 12:48:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200708124806.058e33d9@x1.home>
In-Reply-To: <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
        <20200408055824.2378-1-zhenyuw@linux.intel.com>
        <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200707190634.4d9055fe@x1.home>
        <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jul 2020 06:31:00 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, July 8, 2020 9:07 AM
> > 
> > On Tue, 7 Jul 2020 23:28:39 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > Hi, Alex,
> > >
> > > Gentle ping... Please let us know whether this version looks good.  
> > 
> > I figured this is entangled with the versioning scheme.  There are
> > unanswered questions about how something that assumes a device of a
> > given type is software compatible to another device of the same type
> > handles aggregation and how the type class would indicate compatibility
> > with an aggregated instance.  Thanks,
> >   
> 
> Yes, this open is an interesting topic. I didn't closely follow the versioning
> scheme discussion. Below is some preliminary thought in my mind:
> 
> --
> First, let's consider migrating an aggregated instance:
> 
> A conservative policy is to check whether the compatible type is supported 
> on target device and whether available instances under that type can afford 
> the ask of the aggregated instance. Compatibility check in this scheme is 
> separated from aggregation check, then no change is required to the current 
> versioning interface.

How many features, across how many attributes is an administrative tool
supposed to check for compatibility?  ie. if we add an 'aggregation'
feature now and 'translucency' feature next year, with new sysfs
attributes and creation options, won't that break this scheme?  I'm not
willing to assume aggregation is the sole new feature we will ever add,
therefore we don't get to make it a special case without a plan for how
the next special case will be integrated.

We also can't even seem to agree that type is a necessary requirement
for compatibility.  Your discussion below of a type-A, which is
equivalent to a type-B w/ aggregation set to some value is an example
of this.  We might also have physical devices with extensions to
support migration.  These could possibly be compatible with full mdev
devices.  We have no idea how an administrative tool would discover
this other than an exhaustive search across every possible target.
That's ugly but feasible when considering a single target host, but
completely untenable when considering a datacenter.

 
> Then there comes a case where the target device doesn't handle aggregation
> but support a different type which however provides compatible capabilities 
> and same resource size as the aggregated instance expects. I guess this is
> one puzzle how to check compatibility between such types. One possible
> extension is to introduce a non_aggregated_list  to indicate compatible 
> non-aggregated types for each aggregated instance. Then mgmt.. stack 
> just loop the compatible list if the conservative policy fails.  I didn't think 
> carefully about what format is reasonable here. But if we agree that an
> separate interface is required to support such usage, then this may come
> later after the basic migration_version interface is completed.

...and then a non_translucency_list and then a non_brilliance_list and
then a non_whatever_list... no.  Additionally it's been shown difficult
to predict the future, if a new device is developed to be compatible
with an existing device it would require updates to the existing device
to learn about that compatibility.

> --
> 
> Another scenario is about migrating a non-aggregated instance to a device
> handling aggregation. Then there is an open whether an aggregated type 
> can be used to back the non-aggregated instance in case of no available 
> instance under the original type claimed by non-aggregated instance. 
> This won't happen in KVMGT, because all vGPU types share the same 
> resource pool. Allocating instance under one type also decrement available 
> instances under other types. So if we fail to find available instance under 
> type-A (with 4x resource of type-B), then we will also fail to create an
>  aggregated instance (aggregate=4) under type-B. therefore, we just 
> need stick to basic type compatibility check for non-aggregated instance. 
> And I feel this assumption can be applied to other devices handling 
> aggregation. It doesn't make sense for two types to claim compatibility 
> (only with resource size difference) when their resources are allocated
> from different pools (which usually implies different capability or QOS/
> SLA difference). With this assumption, we don't need provide another
> interface to indicate compatible aggregated types for non-aggregated
> interface.
> --
> 
> I may definitely overlook something here, but if above analysis sounds
> reasonable, then this series could be decoupled from the versioning 
> scheme discussion based on conservative policy for now. :)

The only potential I see for decoupling the discussions would be to do
aggregation via a vendor attribute.  Those already provide a mechanism
to manipulate a device after creation and something that we'll already
need to solve in determining migration compatibility.  So in that
sense, it seems like it at least doesn't make the problem worse.
Thanks,

Alex

