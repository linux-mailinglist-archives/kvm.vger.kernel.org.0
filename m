Return-Path: <kvm+bounces-15118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAAD8AA02C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42FCC28600D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27654176FB1;
	Thu, 18 Apr 2024 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9Zu8iDp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB8174ECA
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713458065; cv=none; b=tWBDRpx9n9lcacSG6aFrUTJAGjSDFkygIn3noO9j3raDJHeHAuUqDmETsFqzTw/AzkOSYcC4mEghbdvEoh1SDNsadJH5IitNiQaox4I+2xfOm8fJxKILMj+n9toeFbUN5BAvRM2HLUzlK5/PJLkNJGcTYC8uvJnhKnzpcz9p9Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713458065; c=relaxed/simple;
	bh=1+AdbJ5Lxh+2MJcMeAGMpvmNWKFnjssdyIOO0MlkRZg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FByFf8MYwHllH3bcwtOnxu7tdawGlhuo00u7RSfKkU+QSQoIPRBzzU8Cvk9p6SueIc5vD1SHkL1bnkInmkkVjVQUA7wMP93vencsQ54XOUxh+MhZfvrvXrgHBHoDhC3z+MjoAds1Hc7goe3ZZYS69vcQZZ8po4+cqDi64+uVk00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9Zu8iDp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713458062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IyZ7eL+TPDe8DrRzLhnZ1fjxA8pQ2o6gDhBK4FPtkyQ=;
	b=X9Zu8iDpLBKOkx253kullVwC43QwzFHQqa95tvq/ITd0EK25FuzQnaGYusYOp335GE3dWS
	IMxer7AvJw/jRrEX4UJAuJMqlEAga+wM0e0SPQBrB+iMdTACHP28na+XF1jVljeXVR6NkD
	qTBcStE5jl37xpJH4FWneBrZArkPBJc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-BZdZo4LGNVaKvQIxUIx34w-1; Thu, 18 Apr 2024 12:34:21 -0400
X-MC-Unique: BZdZo4LGNVaKvQIxUIx34w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36b3157ffb1so15127445ab.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 09:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713458060; x=1714062860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IyZ7eL+TPDe8DrRzLhnZ1fjxA8pQ2o6gDhBK4FPtkyQ=;
        b=flVM0MTAJg59QvocL7Kzx0Kd9sepn2NlcmVqRryKCvSHyvfh4gPPFfm9d7/9smh5mx
         qxp3InYnh/ZeSTeWo2QtMcGgyGkJ2vpyfVi5xX3mIk660kPN7mflO2F5wwZJWiu1EFSg
         DJvbDeiymg71g9jSs9tEkbuYZMmqnkI+Blk156y5Ljfsv9Vc7ln1mpiwVGB6OoIIpZU9
         gp3Ii3vBeSc145MqvXyDF9IBegDvMdVF7L5eviduW20zfdID6iOxMoQ8cNeBb1R/ox85
         NT2mMPK1QYQprtDB48kca7jRDFhCyb4xSMs26+DuVSEt66VFbaVKcItSMU2YB96+pEE2
         yEhg==
X-Forwarded-Encrypted: i=1; AJvYcCWS5dbeELNvfRsln7oQT8HvCo3PDeZQDNGtDc07RjD0f0DYYrTRkkRWoP2PpSRuDEbfOTTuVOBo8UniNNpU9bpEWeTt
X-Gm-Message-State: AOJu0YxAMEzzYzBdkeuOMQCPo2kAeAkgPvlMUgoGNcvD81LeZyMLGuIu
	zfGv4sGpElh+/2AYlOVzRQ/j67LMqsdrkFTOUeQYB8KaM9hAMrJ33uun3XUFnADz/0t29rRr5hv
	pk7foSdzJiq3ZpT5AmiWO9+XETorBwdwPmrDc7P2zgDqZx4sXWA==
X-Received: by 2002:a05:6e02:310e:b0:36b:2731:83d9 with SMTP id bg14-20020a056e02310e00b0036b273183d9mr4692370ilb.0.1713458060356;
        Thu, 18 Apr 2024 09:34:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxGlBQXtZaJePA86yuNk/gcuBisTFIFCVKioJCy+fZB4CnT+ERD/gXB8EaQr5zL2SbIzE9Sg==
X-Received: by 2002:a05:6e02:310e:b0:36b:2731:83d9 with SMTP id bg14-20020a056e02310e00b0036b273183d9mr4692334ilb.0.1713458060045;
        Thu, 18 Apr 2024 09:34:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id v14-20020a056638250e00b004849340e49csm499689jat.178.2024.04.18.09.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 09:34:19 -0700 (PDT)
Date: Thu, 18 Apr 2024 10:34:18 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
 <robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
 <chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
 <baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
 "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 4/4] vfio: Report PASID capability via
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20240418103418.1755365a.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB527690902C6D7D479C16DB3C8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-5-yi.l.liu@intel.com>
	<20240416115722.78d4509f.alex.williamson@redhat.com>
	<BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240417142552.44382198.alex.williamson@redhat.com>
	<BN9PR11MB527690902C6D7D479C16DB3C8C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Apr 2024 00:21:36 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, April 18, 2024 4:26 AM
> >=20
> > On Wed, 17 Apr 2024 07:09:52 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Wednesday, April 17, 2024 1:57 AM
> > > >
> > > > On Fri, 12 Apr 2024 01:21:21 -0700
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > > =20
> > > > > + */
> > > > > +struct vfio_device_feature_pasid {
> > > > > +	__u16 capabilities;
> > > > > +#define VFIO_DEVICE_PASID_CAP_EXEC	(1 << 0)
> > > > > +#define VFIO_DEVICE_PASID_CAP_PRIV	(1 << 1)
> > > > > +	__u8 width;
> > > > > +	__u8 __reserved;
> > > > > +}; =20
> > > >
> > > > Building on Kevin's comment on the cover letter, if we could descri=
be
> > > > an offset for emulating a PASID capability, this seems like the pla=
ce
> > > > we'd do it.  I think we're not doing that because we'd like an in-b=
and
> > > > mechanism for a device to report unused config space, such as a DVS=
EC
> > > > capability, so that it can be implemented on a physical device.  As
> > > > noted in the commit log here, we'd also prefer not to bloat the ker=
nel
> > > > with more device quirks.
> > > >
> > > > In an ideal world we might be able to jump start support of that DV=
SEC
> > > > option by emulating the DVSEC capability on top of the PASID capabi=
lity
> > > > for PFs, but unfortunately the PASID capability is 8 bytes while the
> > > > DVSEC capability is at least 12 bytes, so we can't implement that
> > > > generically either. =20
> > >
> > > Yeah, that's a problem.
> > > =20
> > > >
> > > > I don't know there's any good solution here or whether there's actu=
ally
> > > > any value to the PASID capability on a PF, but do we need to consid=
er
> > > > leaving a field+flag here to describe the offset for that scenario?=
 =20
> > >
> > > Yes, I prefer to this way.
> > > =20
> > > > Would we then allow variant drivers to take advantage of it?  Does =
this
> > > > then turn into the quirk that we're trying to avoid in the kernel
> > > > rather than userspace and is that a problem?  Thanks,
> > > > =20
> > >
> > > We don't want to proactively pursue quirks in the kernel.
> > >
> > > But if a variant driver exists for other reasons, I don't see why it
> > > should be prohibited from deciding an offset to ease the
> > > userspace. =F0=9F=98=8A =20
> >=20
> > At that point we've turned the corner into an arbitrary policy decision
> > that I can't defend.  A "worthy" variant driver can implement something
> > through a side channel vfio API, but implementing that side channel
> > itself is not enough to justify a variant driver?  It doesn't make
> > sense.
> >=20
> > Further, if we have a variant driver, why do we need a side channel for
> > the purpose of describing available config space when we expect devices
> > themselves to eventually describe the same through a DVSEC capability?
> > The purpose of enabling variant drivers is to enhance the functionality
> > of the device.  Adding an emulated DVSEC capability seems like a valid
> > enhancement to justify a variant driver to me.
> >=20
> > So the more I think about it, it would be easy to add something here
> > that hints a location for an emulated PASID capability in the VMM, but
> > it would also be counterproductive to an end goal of having a DVSEC
> > capability that describes unused config space.  The very narrow scope
> > where that side-band channel would be useful is an unknown PF device
> > which doesn't implement a DVSEC capability and without intervention
> > simply behaves as it always has, without PASID support.
> >=20
> > A vendor desiring such support can a) implement DVSEC in the hardware,
> > b) implement a variant driver emulating a DVSEC capability, or c)
> > directly modify the VMM to tell it where to place the PASID capability.
> > I also don't think we should exclude the possibility that b) could turn
> > into a shared variant driver that knows about multiple devices and has
> > a table of free config space for each.  Option c) is only the last
> > resort if there's not already 12 bytes of contiguous, aligned free
> > space to place a DVSEC capability.  That seems unlikely. =20
>=20
> or b) could be a table in vfio_pci_config.c i.e. kind of making vfio-pci
> as the shared variant driver.

We've kind of made the statement that variant drivers should be used
for any device specific quirks rather than further extending vfio-pci.
That's not to say that there couldn't be a shared variant driver that
binds to devices across vendors with device specific knowledge to
insert a DVSEC capability.

> > At some point we need to define the format and use of this DVSEC.  Do
> > we allow (not require) one at every gap in config space that's at least
> > 12-bytes long and adjust the DVSEC Length to describe longer gaps, or d=
o =20
>=20
> Does PCI spec allows multiple same-type capabilities co-existing?

As Yi notes, yes.

> > we use a single DVSEC to describe a table of ranges throughout extended
> > (maybe even conventional) config space?  The former seems easier, =20
>=20
> this might be challenging as the table itself requires a contiguous
> large free block.

Yes, but DVSEC is an extended capability, so we have a fair bit of
address space to work with and the table could always collapse to zero
entries to indicate only the DVSEC capability itself is available, so
it's really no different in minimum described size to the other
approach.  Thanks,

Alex

> > especially if we expect a device has a large block of free space,
> > enough for multiple emulated capabilities and described by a single
> > DVSEC.  Thanks,
> >  =20
>=20
> yes that sounds simpler.


