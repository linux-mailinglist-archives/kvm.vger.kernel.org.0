Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5004221B927
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGJPNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:13:08 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57504 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727941AbgGJPMe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 11:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594393946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMGVZSRXo7baW8lGtzLkE8JQNic6/IT/q58/50/MWpA=;
        b=eyG92M6R1kj3SAtF9RZFhKOhKTTjtZQ8KYtbZQvOI8Ly6l+bXoXD7N1UZ6W/mhN2LcGC15
        eLdAY+RshXdilGBjXVDCcFt28W823iRxWB9aZnIFI1IkIrXt51ovU88YkfdD+QL4Bex8yu
        Cm1pr+GS3ADw6w/j4JC+8+5qtqVa5zM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-KXqCn5DjOe6xAnO8huHGwQ-1; Fri, 10 Jul 2020 11:12:20 -0400
X-MC-Unique: KXqCn5DjOe6xAnO8huHGwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B7A100AA2A;
        Fri, 10 Jul 2020 15:12:19 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD7415C662;
        Fri, 10 Jul 2020 15:12:18 +0000 (UTC)
Date:   Fri, 10 Jul 2020 09:12:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: Re: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Message-ID: <20200710091217.7a62b4cc@x1.home>
In-Reply-To: <20200710062958.GB29271@joy-OptiPlex-7040>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
        <20200408055824.2378-1-zhenyuw@linux.intel.com>
        <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200707190634.4d9055fe@x1.home>
        <MWHPR11MB16454BF5C1BF4D5D22F0B2B38C670@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200708124806.058e33d9@x1.home>
        <MWHPR11MB1645C5033CB813EBD72CE4FD8C640@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200709112810.6085b7f6@x1.home>
        <MWHPR11MB1645D3E53C055461AB5E8E3C8C650@MWHPR11MB1645.namprd11.prod.outlook.com>
        <20200710062958.GB29271@joy-OptiPlex-7040>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jul 2020 14:29:59 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Fri, Jul 10, 2020 at 02:09:06AM +0000, Tian, Kevin wrote:
> <...>
> > > > > We also can't even seem to agree that type is a necessary require=
ment
> > > > > for compatibility.  Your discussion below of a type-A, which is
> > > > > equivalent to a type-B w/ aggregation set to some value is an exa=
mple
> > > > > of this.  We might also have physical devices with extensions to
> > > > > support migration.  These could possibly be compatible with full =
mdev
> > > > > devices.  We have no idea how an administrative tool would discov=
er
> > > > > this other than an exhaustive search across every possible target.
> > > > > That's ugly but feasible when considering a single target host, b=
ut
> > > > > completely untenable when considering a datacenter. =20
> > > >
> > > > If exhaustive search can be done just one-off to build the compatib=
ility
> > > > database for all assignable devices on each node, then it might be
> > > > still tenable in datacenter? =20
> > >=20
> > >=20
> > > I'm not sure what "one-off" means relative to this discussion.  Is th=
is
> > > trying to argue that if it's a disturbingly heavyweight operation, but
> > > a management tool only needs to do it once, it's ok?  We should reall=
y =20
> >=20
> > yes
> >  =20
> > > be including openstack and ovirt folks in any discussion about what
> > > might be acceptable across a datacenter.  I can sometimes get away wi=
th
> > > representing what might be feasible for libvirt, but this is the sort
> > > of knowledge and policy decision that would occur above libvirt. =20
> >=20
> > Agree. and since this is more about general migration compatibility,
> > let's start new thread and involve openstack/ovirt guys. Yan, can you
> > initiate this?
> > =20
> sure.
> hi Alex,
> I'm not sure if below mailling lists are enough and accurate,
> do you know what extra people and lists I need to involve in?
>=20
> devel@ovirt.org, openstack-discuss@lists.openstack.org,
> libvir-list@redhat.com

You could also include

Daniel P. Berrang=C3=A9 <berrange@redhat.com>
Sean Mooney <smooney@redhat.com>

=20
> BTW, I found a page about live migration of SRIOV devices in openstack.
> https://specs.openstack.org/openstack/nova-specs/specs/stein/approved/lib=
virt-neutron-sriov-livemigration.html

Sean, above, is involved with that specification.  AFAIK the only
current live migration of SR-IOV devices involve failover and hotplug
trickery.  Thanks,

Alex

