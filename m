Return-Path: <kvm+bounces-15344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F348AB36B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D2532842CC
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BDFB130E5C;
	Fri, 19 Apr 2024 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z69/byjY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB477F7C7
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713544558; cv=none; b=CXMfxP4HUMrm0fSVS0alxN02a3t3CD9wdhj8MhlMQsMoK7ec3bvBFSfoZUvxz5IEIWkhcR4Mn4ZQ1CTUI+VQynjtvXf+4VCZSLITjUHZ1nJFzlDkvueyV0vXUElpMvJnYAuMEC6fBfR4Lk8HdR9vFERSJGqCggQtGVudLd2jx6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713544558; c=relaxed/simple;
	bh=xENYoPum6yNYeS/E/8CEtcTyk7Gf7L25b78k5uOhFmU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HZagk3vT33jTA9hfz8WvWC/XOIQa/1fJ66gCScjPp3YsECDsKFkG9dvaDhp09mxDnOX32F5ObAEzrzfxzEJnfN+QEmQSLYM293vq73rWJ0kB1M0R6PWDjtK0+oBxYlMAd9qU35dA8ZHnGkJQcEf6SBmOGB/KQrgYJLkobr1p+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z69/byjY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713544555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdVR6ih/gpqSFGIptaTHhY1yJ/xUplAZaeOP0TUfrNM=;
	b=Z69/byjYOM8OTYrTdLIvzvmFrvYvDYFySQwTlAFLCcq1RrGKW3mJmSypbOJaD5PqZGtc8e
	8KVCrvEV3i93C5W1gUSoUk1p4oCJgszgWguo8NTfwNwPK6fqvsRfl6eY/MZqJb5z+kZh8j
	+47gz0ShpSkpB+ZnWRG6I5Jzux8/Zz8=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-UBCTyxV6PdW1mH7bMoaThw-1; Fri, 19 Apr 2024 12:35:54 -0400
X-MC-Unique: UBCTyxV6PdW1mH7bMoaThw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7cc78077032so350732939f.0
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:35:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713544553; x=1714149353;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdVR6ih/gpqSFGIptaTHhY1yJ/xUplAZaeOP0TUfrNM=;
        b=AuWrmfu4G37PudFeET8NBUfRIS9BxmOjxULDooTabiiNR+3lG6xLei1am+YxAlOrDa
         TaaCcj5Xh239/dTjQX0V2k8QqItU+2cG+pd2Ss35KJrwsOlgnkV32E0xGkpiGERUr+OA
         GXLwu56Ew/3rwDfGk+IrmAYCC8XDML1Q7T21n6q/BUPZJ2SGXx6xeZdiAtIFP9B1lLMU
         bBiWAVrNWj1XOMqV1Bnzzfq367/zkM4t8rLJi4mBsFc7J2ji1MCV8N2xbZ9i/NVHy0Tq
         rlQJIyJV9IeGXwVZqn4k28dGabMMM5c02wjgcVjUHETmMU9lj+m6/ujWPgkyxN5W9Ap3
         LyTw==
X-Forwarded-Encrypted: i=1; AJvYcCXro5vd0wYZ8MmZwfsEA+vsVzKUOksJSSRXkl3MQYCNYnUUY+PH5TAzSCjaz1Xg2iRBnsCt8KqXWrmdevQY9ckUYd0T
X-Gm-Message-State: AOJu0Yw0DdchPuBOSwuVFCw6fg52+kCREEr0PwssLTxXrtZ1nLJHTHzT
	A2meKrFT4XB46VNnoqt99pihrMtz5JCcBddMTw7nu8KPHMH4B43NjI0jNz2XO4wYBZCe8wNDAE/
	VWRp2l0tEirJELEClA9XSCk9WCZb7SvXpYw+szyBBNkvqneQA9Q==
X-Received: by 2002:a5d:9c12:0:b0:7d3:eb4b:ca06 with SMTP id 18-20020a5d9c12000000b007d3eb4bca06mr3102138ioe.4.1713544553590;
        Fri, 19 Apr 2024 09:35:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoahWr9Ra1p/zkH9TWQjcfyp7eDiqGYVUds6eGBvIjVVtf4CShyMAPy4jI4wLEeWo1+a0pvg==
X-Received: by 2002:a5d:9c12:0:b0:7d3:eb4b:ca06 with SMTP id 18-20020a5d9c12000000b007d3eb4bca06mr3102115ioe.4.1713544553254;
        Fri, 19 Apr 2024 09:35:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id y18-20020a05663824d200b004829446d63dsm1173221jat.175.2024.04.19.09.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:35:52 -0700 (PDT)
Date: Fri, 19 Apr 2024 10:35:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240419103550.71b6a616.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240416175018.GJ3637727@nvidia.com>
	<BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417122051.GN3637727@nvidia.com>
	<20240417170216.1db4334a.alex.williamson@redhat.com>
	<BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
	<20240418143747.28b36750.alex.williamson@redhat.com>
	<BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Apr 2024 05:52:01 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 19, 2024 4:38 AM
> >=20
> > On Thu, 18 Apr 2024 17:03:15 +0800
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >  =20
> > > On 2024/4/18 08:06, Tian, Kevin wrote: =20
> > > >> From: Alex Williamson <alex.williamson@redhat.com>
> > > >> Sent: Thursday, April 18, 2024 7:02 AM
> > > >>
> > > >> But we don't actually expose the PASID capability on the PF and as
> > > >> argued in path 4/ we can't because it would break existing userspa=
ce.
> > > > > Come back to this statement. =20
> > > >
> > > > Does 'break' means that legacy Qemu will crash due to a guest write
> > > > to the read-only PASID capability, or just a conceptually functional
> > > > break i.e. non-faithful emulation due to writes being dropped? =20
> >=20
> > I expect more the latter.
> >  =20
> > > > If the latter it's probably not a bad idea to allow exposing the PA=
SID
> > > > capability on the PF as a sane guest shouldn't enable the PASID
> > > > capability w/o seeing vIOMMU supporting PASID. And there is no
> > > > status bit defined in the PASID capability to check back so even
> > > > if an insane guest wants to blindly enable PASID it will naturally
> > > > write and done. The only niche case is that the enable bits are
> > > > defined as RW so ideally reading back those bits should get the
> > > > latest written value. But probably this can be tolerated? =20
> >=20
> > Some degree of inconsistency is likely tolerated, the guest is unlikely
> > to check that a RW bit was set or cleared.  How would we virtualize the
> > control registers for a VF and are they similarly virtualized for a PF
> > or would we allow the guest to manipulate the physical PASID control
> > registers? =20
>=20
> it's shared so the guest shouldn't be allowed to touch the physical
> register.
>=20
> Even for PF this is virtualized as the physical control is toggled by
> the iommu driver today. We discussed before whether there is a
> value moving the control to device driver but the conclusion is no.

So in both cases we virtualize the PASID bits in the vfio variant
driver in order to maintain spec compliant behavior of the register
(ie. the control bits are RW with no underlying hardware effect and
capability bits only reflect the features enabled by the host in the
control register)?

> > > 4) Userspace assembles a pasid cap and inserts it to the vconfig spac=
e.
> > >
> > > For PF, step 1) is enough. For VF, it needs to go through all the 4 s=
teps.
> > > This is a bit different from what we planned at the beginning. But so=
unds
> > > doable if we want to pursue the staging direction. =20
> >=20
> > Seems like if we decide that we can just expose the PASID capability
> > for a PF then we should just have any VF variant drivers also implement
> > a virtual PASID capability.  In this case DVSEC would only be used to =
=20
>=20
> I'm leaning toward this direction now.
>=20
> > provide information for a purely userspace emulation of PASID (in which
> > case it also wouldn't necessarily need the vfio feature because it
> > might implicitly know the PASID capabilities of the device).  Thanks,
> >  =20
>=20
> that's a good point. Then no new contract is required.
>=20
> and allowing variant driver to implement a virtual PASID capability
> seems also make a room for making a shared variant driver to host
> a table of virtual capabilities (both offset and content) for VFs, just
> as discussed in patch4 having a shared driver to host a table for DVSEC?

Yes, vfio-pci-core would support virtualizing the PF PASID capability
mapped 1:1 at the physical PASID location.  We should architect that
support to be easily reused for a driver provided offset for the VF use
case and then we'd need to decide if a lookup table to associate an
offset to a VF vendor:device warrants a variant driver (which could be
shared by multiple devices) or if we'd accept that into vfio-pci-core.

> Along this route probably most vendors will just extend the table in
> the shared driver, leading to decreased value on DVSEC and question
> on its necessity...
>=20
> then it's back to the quirk-in-kernel approach... but if simple enough
> probably not a bad idea to pursue? =F0=9F=98=8A

A DVSEC to express unused config space could still support a generic
vfio-pci-core or variant driver implementation of PASID virtualization.
The table lookup would provide a device-specific quirk to a base
implementation of carving it from DVSEC reported free space.

The question of whether it should be in kernel or userspace is
difficult.  There are certainly other capabilities where vfio-pci
exposes RW registers as read-only and we rely on the userspace VMM to
emulate them.  We could consider this one of those cases so long as the
change of exposing PASID as a read-only capability is tolerated for old
QEMU, new kernel.

Then come VFs.  AFAIK, it would not be possible for an unprivileged
QEMU to inspect the PASID state for the PF.  Therefore I think vfio
needs to provide that information either in-band (ie. emulated PASID) or
out-of-band (device feature).  At that point, there's some kernel code
regardless, which leans me towards virtualizing in the kernel.  I'd
welcome a complete, coherent proposal that could be done in userspace
though.  Thanks,

Alex


