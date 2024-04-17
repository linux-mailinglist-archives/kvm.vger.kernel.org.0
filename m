Return-Path: <kvm+bounces-15009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0748A8CDE
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B9C91C21906
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1C238F94;
	Wed, 17 Apr 2024 20:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFRGkQ5B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A88D37703
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 20:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385563; cv=none; b=FecVn5pfDlFtwX4jqMsKLU819mVVvyc8JIhhifIfEA/C+n2fWxX0GQT57H23PamUKWtKCNmmVuGGI6CcRJUWcp4/QCZkTeljE8hYuHZUjGCsEgudymsBDle3tpFYNtR9KsvqcHbsAFfTs2xUemQxlRU+1vlWiM5h850xXZblvck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385563; c=relaxed/simple;
	bh=7BZHgF3W5ZZE54WPCFL5+Yv9SFz3jbsd5fEweJQ2Yk4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+0LGb12EPsvhsSH1I4IXjoVLJkgzb2aSiCFe+lRZUwjYalLID322wcWiHUqusZXfQexAVBv3V7vPZQ9+25YKKMKqztRITz84EwZ8rgQo23Jrwb+yCkP1666VP5E/BK6WeT4ZmRwdc5HUs5CZ+LEF8VeM+2sbzFZ36AboJMtn2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFRGkQ5B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713385559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4IOnfC4A0RohZ6kwMqfDoY6+tZsEAo9YyC45xU6vlkc=;
	b=WFRGkQ5Byh1XCRZltRCJgSPIfU27SODNismT0y8UnUKx0WKhYP1e0wg/Kfw4MXnScFbbdF
	i9H9oFm+7qkcyvE5vbJQeGtPHQqlCMtG2sUjAuc9gIiGgiAsHrW7cwukY/JjpHx4XBK11X
	QM+XWmLirpTntj/R/dhQ07D2BlvszqU=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-eRLpzgWBOa6AbKWB6W1-dg-1; Wed, 17 Apr 2024 16:25:57 -0400
X-MC-Unique: eRLpzgWBOa6AbKWB6W1-dg-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6eb5968cdc8so114713a34.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 13:25:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713385557; x=1713990357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IOnfC4A0RohZ6kwMqfDoY6+tZsEAo9YyC45xU6vlkc=;
        b=VFqvB3jL2ycfg96qgXHMw8fKEH1nbdC+wJ+EOmDq1BAbeN+C/NusdAK89r8puWVN8q
         jAf/LkO8EHdGSTMjbrC2xrURkyPT/1o5Wgkjw/Oyrv+22cKc2tGhtzLLXZxXResbiuWM
         1Jb0Km0GnHVschgqfo0g3YaWDY6BSdTcu42E2lB3DIWEYppUXISKb2sREIzuuf5YKJE1
         Pn+AhadqH7fFEI/loozAhLxHB74L9SJxnT8HD8sULqBAR988adJwlCePy6UXTFifQONn
         Yi23+d55VBttqnMSx8LKBqiFyem2ASfnZMZvgFHOU4DaXfDU1HnONxiJ/0kUUWDOBpmn
         RD/A==
X-Forwarded-Encrypted: i=1; AJvYcCV547DYZr6y7YFu29sQuMG9BWXnYdBwCLNF/k4aT3Ttcv0nG4veKWyw+N4oQlUrjTdySIExRBfOMMuZzwaliXZfpZk/
X-Gm-Message-State: AOJu0YxBulc1FZjpIw2l7hJDY3oio/7epaKGlNIFtPZDplYc4fZflxi0
	GxFGJdKgMZuSUPwHdh6eW2UeUU2k6r/t8GjKyJ9zhQSewbiLtPnnDhjVC+pS3RbxNIeqtkkIjRr
	V/7shkPEV41hwgej+HjyGYy7mFoGSKjyM7E5j4Z4pGLDOBvbW8g==
X-Received: by 2002:a9d:69c7:0:b0:6eb:7685:f230 with SMTP id v7-20020a9d69c7000000b006eb7685f230mr605425oto.28.1713385556796;
        Wed, 17 Apr 2024 13:25:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAA5+8BHEzfd8XxwBjBN2DsH0fwZ0zsVuy97fzw0ylgtBKgn+V148PXZFfakl/bTMjiYFHUw==
X-Received: by 2002:a9d:69c7:0:b0:6eb:7685:f230 with SMTP id v7-20020a9d69c7000000b006eb7685f230mr605407oto.28.1713385556512;
        Wed, 17 Apr 2024 13:25:56 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id m6-20020a9d7ac6000000b006eb7e6d2f3dsm30683otn.37.2024.04.17.13.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 13:25:55 -0700 (PDT)
Date: Wed, 17 Apr 2024 14:25:52 -0600
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
Message-ID: <20240417142552.44382198.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
	<20240412082121.33382-5-yi.l.liu@intel.com>
	<20240416115722.78d4509f.alex.williamson@redhat.com>
	<BN9PR11MB5276D245515E81844B5EC1068C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Apr 2024 07:09:52 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, April 17, 2024 1:57 AM
> >=20
> > On Fri, 12 Apr 2024 01:21:21 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >  =20
> > > + */
> > > +struct vfio_device_feature_pasid {
> > > +	__u16 capabilities;
> > > +#define VFIO_DEVICE_PASID_CAP_EXEC	(1 << 0)
> > > +#define VFIO_DEVICE_PASID_CAP_PRIV	(1 << 1)
> > > +	__u8 width;
> > > +	__u8 __reserved;
> > > +}; =20
> >=20
> > Building on Kevin's comment on the cover letter, if we could describe
> > an offset for emulating a PASID capability, this seems like the place
> > we'd do it.  I think we're not doing that because we'd like an in-band
> > mechanism for a device to report unused config space, such as a DVSEC
> > capability, so that it can be implemented on a physical device.  As
> > noted in the commit log here, we'd also prefer not to bloat the kernel
> > with more device quirks.
> >=20
> > In an ideal world we might be able to jump start support of that DVSEC
> > option by emulating the DVSEC capability on top of the PASID capability
> > for PFs, but unfortunately the PASID capability is 8 bytes while the
> > DVSEC capability is at least 12 bytes, so we can't implement that
> > generically either. =20
>=20
> Yeah, that's a problem.
>=20
> >=20
> > I don't know there's any good solution here or whether there's actually
> > any value to the PASID capability on a PF, but do we need to consider
> > leaving a field+flag here to describe the offset for that scenario? =20
>=20
> Yes, I prefer to this way.
>=20
> > Would we then allow variant drivers to take advantage of it?  Does this
> > then turn into the quirk that we're trying to avoid in the kernel
> > rather than userspace and is that a problem?  Thanks,
> >  =20
>=20
> We don't want to proactively pursue quirks in the kernel.
>=20
> But if a variant driver exists for other reasons, I don't see why it=20
> should be prohibited from deciding an offset to ease the
> userspace. =F0=9F=98=8A

At that point we've turned the corner into an arbitrary policy decision
that I can't defend.  A "worthy" variant driver can implement something
through a side channel vfio API, but implementing that side channel
itself is not enough to justify a variant driver?  It doesn't make
sense.

Further, if we have a variant driver, why do we need a side channel for
the purpose of describing available config space when we expect devices
themselves to eventually describe the same through a DVSEC capability?
The purpose of enabling variant drivers is to enhance the functionality
of the device.  Adding an emulated DVSEC capability seems like a valid
enhancement to justify a variant driver to me.

So the more I think about it, it would be easy to add something here
that hints a location for an emulated PASID capability in the VMM, but
it would also be counterproductive to an end goal of having a DVSEC
capability that describes unused config space.  The very narrow scope
where that side-band channel would be useful is an unknown PF device
which doesn't implement a DVSEC capability and without intervention
simply behaves as it always has, without PASID support.

A vendor desiring such support can a) implement DVSEC in the hardware,
b) implement a variant driver emulating a DVSEC capability, or c)
directly modify the VMM to tell it where to place the PASID capability.
I also don't think we should exclude the possibility that b) could turn
into a shared variant driver that knows about multiple devices and has
a table of free config space for each.  Option c) is only the last
resort if there's not already 12 bytes of contiguous, aligned free
space to place a DVSEC capability.  That seems unlikely.

At some point we need to define the format and use of this DVSEC.  Do
we allow (not require) one at every gap in config space that's at least
12-bytes long and adjust the DVSEC Length to describe longer gaps, or do
we use a single DVSEC to describe a table of ranges throughout extended
(maybe even conventional) config space?  The former seems easier,
especially if we expect a device has a large block of free space,
enough for multiple emulated capabilities and described by a single
DVSEC.  Thanks,

Alex


