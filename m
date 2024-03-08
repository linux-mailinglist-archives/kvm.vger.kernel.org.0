Return-Path: <kvm+bounces-11377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 771E0876944
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:04:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 17666B23C13
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FA4250F6;
	Fri,  8 Mar 2024 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKPJyPPj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858E520B0E
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709917407; cv=none; b=FSW8aKTKu+sOf4mVsPu8HARsqxbTVuHFz1U4w7gvM8xS9K6+XTYELnEg5oec5WRCHvG9banivr0PBd6tjHKbMamP/DkWWU/MUPCev5d2Eri8EXAtjxk82x/tfRxCiCbCY/tP//o+ZWyYQ/Xnr4+4IaCW4jGQcwpXSc9juHof7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709917407; c=relaxed/simple;
	bh=9o4nZMfiF5m3PN48FoxnPM8zda5E9vwoK8CgRygIp9o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRLgjXyLKSm6RhJFXGENexmZlcVDny1/OHnX/VZoIarbiE+mLkWzkfM5fU7L8oAZfrW1IFX/Jg8OtQqLZ6iyBfjGg5fd0JGW02PCCHf9iwm7NlmAziMnUpLFwKw344KneaFLskxBTXQVYmylpQQ84x6ktieI5ac4/uzTASYIhgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKPJyPPj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709917404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0t8lZDXK/Q+Ew6d4a5Ak8Cmmg3FTPVKzcfM3TVR9H9g=;
	b=MKPJyPPjiPc55CcXKJ/ZhmG6qbm4NGHvOJ4fJdjrwsss3Kig+Gv3ILAOeiJ0MtRoiTFkQ6
	N9IOrZXBfeYq8iAOSedKzx+GYFCTTY7mMXp4AW2duidg7oWnEWEwr1yLa/ssDqOE+/ch4F
	lrfeZF6PDvvTo+6/awhHB0K+Ny5vIOo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-E1Gdcy27OjqmoK6lUpBSjA-1; Fri, 08 Mar 2024 12:03:22 -0500
X-MC-Unique: E1Gdcy27OjqmoK6lUpBSjA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3662d8ed7c5so6660535ab.3
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 09:03:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709917402; x=1710522202;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0t8lZDXK/Q+Ew6d4a5Ak8Cmmg3FTPVKzcfM3TVR9H9g=;
        b=i8re/Q4/JcsMqchJp9sttL4NXdx1W9e8Tq3hLd1x9k9ww6C6PWmoUXomNKIkEO7S0+
         cQFrVgVfEfn7plXcqxIE2qyJcSE2Eq13mjGv2xbfdZhXyJN02J92CgKoM0+PR/8e/FHi
         kmhOWraqV3Qjs06hpr+hX2z7TwZ1YeGaMpddZijdcdU76fwujbTpPj6FcbwYGDh67sq8
         GdIi2wKYjpp1AK39opPQ4L3jbuHW5kHYsE9phEpqEfhklbhmpmiP9GkE64Wbh+gzIG4e
         YS/F1Pk50dX6W2PJA2lrLw6Wwx9AVGEFMCrHn9+S8Mt5nW8zWnkbQizgkLoMDehXuZe9
         w8uQ==
X-Gm-Message-State: AOJu0Yy/fqhyOpMDOldDRJoZVElnQ5t0r/TldUyVvXdw9CNC/YEmDKZl
	0PvM9NT6/mUR1pN/oeo5Dq7KmapxMZaOn6uMMtbmHIJB7NDcA7Voi6FHTnpGq4xxJgBOA/9RW/a
	mtN1fTBnOkb7YjvnGkyp+dr8MBORfMeMtOJD6CEyiv++m5L6kMw==
X-Received: by 2002:a05:6e02:218c:b0:365:4b91:7cf9 with SMTP id j12-20020a056e02218c00b003654b917cf9mr27359741ila.26.1709917402014;
        Fri, 08 Mar 2024 09:03:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEJAjtnPLKpEVq7+6yKBXjDWb/D3zaCEqh9nOflsX7LqSElSm/ct2ufYbJRUyjZbrxlyuV7Dg==
X-Received: by 2002:a05:6e02:218c:b0:365:4b91:7cf9 with SMTP id j12-20020a056e02218c00b003654b917cf9mr27359721ila.26.1709917401783;
        Fri, 08 Mar 2024 09:03:21 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id f22-20020a056638023600b00474506c900esm4525713jaq.145.2024.03.08.09.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 09:03:21 -0800 (PST)
Date: Fri, 8 Mar 2024 10:03:18 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
 <eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Message-ID: <20240308100318.0794f51a.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276DBB5FBC36939EB39A3CA8C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-2-alex.williamson@redhat.com>
	<BL1PR11MB527189373E8756AA8697E8D78C202@BL1PR11MB5271.namprd11.prod.outlook.com>
	<20240307132348.5dbc57dc.alex.williamson@redhat.com>
	<BN9PR11MB5276DBB5FBC36939EB39A3CA8C272@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Mar 2024 07:23:21 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, March 8, 2024 4:24 AM
> >=20
> > On Thu, 7 Mar 2024 08:39:16 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >  =20
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, March 7, 2024 5:15 AM
> > > >
> > > > Currently for devices requiring masking at the irqchip for INTx, ie.
> > > > devices without DisINTx support, the IRQ is enabled in request_irq()
> > > > and subsequently disabled as necessary to align with the masked sta=
tus
> > > > flag.  This presents a window where the interrupt could fire between
> > > > these events, resulting in the IRQ incrementing the disable depth t=
wice.
> > > > This would be unrecoverable for a user since the masked flag preven=
ts
> > > > nested enables through vfio.
> > > >
> > > > Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive =
INTx
> > > > is never auto-enabled, then unmask as required.
> > > >
> > > > Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com> =20
> > >
> > > CC stable? =20
> >=20
> > I've always found that having a Fixes: tag is sufficient to get picked
> > up for stable, so I typically don't do both.  If it helps out someone's
> > process I'd be happy to though.  Thanks,
> >  =20
>=20
> According to "Documentation/process/submitting-patches.rst":
>=20
>   Note: Attaching a Fixes: tag does not subvert the stable kernel rules
>   process nor the requirement to Cc: stable@vger.kernel.org on all stable
>   patch candidates. For more information, please read
>   Documentation/process/stable-kernel-rules.rst.
>=20
> Probably it's fine as long as the stable kernel maintainers don't complai=
n. =F0=9F=98=8A

I think the stable maintainers are far more aggressive than the
documentation would suggest, but it doesn't hurt to include the Cc,
I'll add it next version.  Thanks,

Alex


