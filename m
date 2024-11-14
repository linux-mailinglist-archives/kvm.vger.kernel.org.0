Return-Path: <kvm+bounces-31881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661CC9C918E
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 19:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F47B282209
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 18:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9EF198E81;
	Thu, 14 Nov 2024 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdMPeE3K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A524119597F
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 18:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731608408; cv=none; b=hMsiJPr132S8KHExZaRg903CA+Ot+xlzpd16/P4JT8vdKHyD7bjhl4J2RQDZ6tQHCW3JNwhGb4xjFGfDOjpfgwaKLBnsNKjWINg6mh/R+G3RqP9RXvacgDuGCc3fKj16xWZ6njvRmog8OCFg6r/r2kq1wnSFv5TxCgWDts3OTvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731608408; c=relaxed/simple;
	bh=gdYiz4EYboxznjgxtAlMOSRCBIOKxqXxvw/mJr9wo0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqsNxLyeTCl1wh5Fl8uObCELI/v0Nv5Hv4DbEBtJx/f2Tzs6tg3r2mTfwPBiYtvYmR3qvPB8W6S3U467DDJG1VHZ8Yl+PV382XtpS4HPsyISOtF9cw3N3i7zM7lIwsHkWXx8vyFq47rsOGBhUYIUErj3mugav8jUNUxzcKuIqVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdMPeE3K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731608404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s15vRddefejG6fhwQ57mKyTAs3rkfSslp/KnwL6dr28=;
	b=PdMPeE3KuNuK9cy9Ewe2rcqK7Ie/ty4zVzcP5bvQj+6Lg5R9JI95GUx2NOL9tmACys9KXc
	P8SKqQgQg/ov/8VqagbeCeRTk8VCWLV0QwG7+Ng//RPmdVD0HEeAZiZxN5MSln/k86YXmn
	4PnE998IDv/hyG6kh3yv4zLbtYc51gc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-MgcxUDb3Ofej3CwN1ewz5g-1; Thu, 14 Nov 2024 13:20:03 -0500
X-MC-Unique: MgcxUDb3Ofej3CwN1ewz5g-1
X-Mimecast-MFC-AGG-ID: MgcxUDb3Ofej3CwN1ewz5g
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4dad0a63bso2234675ab.0
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 10:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731608402; x=1732213202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s15vRddefejG6fhwQ57mKyTAs3rkfSslp/KnwL6dr28=;
        b=dlfPp/G1BPJwReWv9wFtnezL4yUOxQOKB7OVGsuLDLWuHO3O/NUUN7Aj0XIngttXm7
         G5GvUNS/Gy+q4cGoqeBd6t88cJNMckKLVAbuuxNPDJ47FevNIP0wkFuThWMvs7otB13H
         h7mlf1M9CnCPsezO8iYiP7lqh0bKUAHzDQ/D7jWKegu7gNAwW+xYMLM+rWIVu5UftGqK
         IiFi13g8SFL9G7E3Z1qcWyKqw9NPAsEvlC/edt2RJwYoFKsFtLR+x05btbZFRN2Z4Kdd
         tG9TBIXDIGUEbqm80ZvvUy5VC9vwSHIU7tLOxftQwAAl9e1vEFhBKxx09rhb0slkGaYV
         nERw==
X-Forwarded-Encrypted: i=1; AJvYcCVljXHz1zMoSHsjW0xLMZn2ddh8445cSG0yuWrTKWIGWPGeGh1V9wDbbF9kvXkHrMLMj6E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy25Jv/Wqx4XIWAMZt8KCQlC7Ns6r42Ny0ZYmVADwsXGwPwl/Qc
	7Y03yECE0JEfktZI6GNY7KVoLmO20li4eG3X5esGBjdGEbvAj/kzkGJ1YOemgXEoBz8egyXuW1B
	BV3Nu3fHVdZAGdcqpzZWyPaOIyFJcCmKJJK1Oep/q7IX0FLjc/g==
X-Received: by 2002:a05:6602:2dc3:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83e6bf4cd52mr4148739f.0.1731608402421;
        Thu, 14 Nov 2024 10:20:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvRjOBHJy7qQH++XUG5nfwskcvDFSYilImpnQa2boVQelR3q3PEExN9cFszyyb1hYMDs9x6A==
X-Received: by 2002:a05:6602:2dc3:b0:83a:9350:68b with SMTP id ca18e2360f4ac-83e6bf4cd52mr4146739f.0.1731608401912;
        Thu, 14 Nov 2024 10:20:01 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e02fc542b5sm366816173.30.2024.11.14.10.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 10:20:01 -0800 (PST)
Date: Thu, 14 Nov 2024 11:19:58 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
 <joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
 <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
 <iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>,
 <vasant.hegde@amd.com>, <will@kernel.org>
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
Message-ID: <20241114111958.7f6c64a8.alex.williamson@redhat.com>
In-Reply-To: <7808f8da-8932-486d-8d47-10a95bc5002d@intel.com>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
	<20241108121742.18889-5-yi.l.liu@intel.com>
	<20241111170308.0a14160f.alex.williamson@redhat.com>
	<9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
	<20241112065253.6c9a38ac.alex.williamson@redhat.com>
	<7808f8da-8932-486d-8d47-10a95bc5002d@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Nov 2024 15:22:02 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2024/11/12 21:52, Alex Williamson wrote:
>=20
> >>>> +{
> >>>> +	unsigned long xend =3D minsz;
> >>>> +	struct user_header {
> >>>> +		u32 argsz;
> >>>> +		u32 flags;
> >>>> +	} *header;
> >>>> +	unsigned long flags;
> >>>> +	u32 flag;
> >>>> +
> >>>> +	if (copy_from_user(buffer, arg, minsz))
> >>>> +		return -EFAULT;
> >>>> +
> >>>> +	header =3D (struct user_header *)buffer;
> >>>> +	if (header->argsz < minsz)
> >>>> +		return -EINVAL;
> >>>> +
> >>>> +	if (header->flags & ~flags_mask)
> >>>> +		return -EINVAL; =20
> >>>
> >>> I'm already wrestling with whether this is an over engineered solution
> >>> to remove a couple dozen lines of mostly duplicate logic between atta=
ch
> >>> and detach, but a couple points that could make it more versatile:
> >>>
> >>> (1) Test xend_array here:
> >>>
> >>> 	if (!xend_array)
> >>> 		return 0; =20
> >>
> >> Perhaps we should return error if the header->flags has any bit set. S=
uch
> >> cases require a valid xend_array. =20
> >=20
> > I don't think that's true.  For example if we want to drop this into
> > existing cases where the structure size has not expanded and flags are
> > used for other things, I don't think we want the overhead of declaring
> > an xend_array. =20
>=20
> I see. My thought was sticking with using it in the cases that have
> extended fields. Given that would it be better to return minsz as you
> suggested to return ssize_t to caller.

If the xend_array is NULL, then yes it would do the copy, validate
argsz and flags, and return minsz.
=20
> >>> (2) Return ssize_t/-errno for the caller to know the resulting copy
> >>> size.
> >>>     =20
> >>>> +
> >>>> +	/* Loop each set flag to decide the xend */
> >>>> +	flags =3D header->flags;
> >>>> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
> >>>> +		if (xend_array[flag] > xend)
> >>>> +			xend =3D xend_array[flag]; =20
> >>>
> >>> Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
> >>> least long enough to match the highest bit in flags?  Thanks, =20
> >>
> >> yes. I would add a BUILD_BUG like the below.
> >>
> >> BUILD_BUG_ON(ARRAY_SIZE(_xend_array) < ilog2(_flags_mask)); =20
> >=20
> > So this would need to account that _xend_array can be NULL regardless
> > of _flags_mask.  Thanks, =20
> yes, but I encounter a problem to account it. The below failed as when
> the _xend_array is a null pointer. It's due to the usage of ARRAY_SIZE
> macro. If it's not doable, perhaps we can have two wrappers, one for
> copying user data with array, this should enforce the array num check
> with flags. While, the another one is for copying user data without
> array, no array num check. How about your opinion?
>=20
> BUILD_BUG_ON((_xend_array !=3D NULL) && (ARRAY_SIZE(_xend_array) <=20
> ilog2(_flags_mask)));
>=20
> Compiling fail snippet:
>=20
> In file included from <command-line>:
> ./include/linux/array_size.h:11:38: warning: division =E2=80=98sizeof (lo=
ng=20
> unsigned int *) / sizeof (long unsigned int)=E2=80=99 does not compute th=
e number=20
> of array elements [-Wsizeof-pointer-div]
>     11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +=20
> __must_be_array(arr))
>        |                                      ^
> ././include/linux/compiler_types.h:497:23: note: in definition of macro=20
> =E2=80=98__compiletime_assert=E2=80=99
>    497 |                 if (!(condition))=20
>       \
>        |                       ^~~~~~~~~
> ././include/linux/compiler_types.h:517:9: note: in expansion of macro=20
> =E2=80=98_compiletime_assert=E2=80=99
>    517 |         _compiletime_assert(condition, msg, __compiletime_assert=
_,=20
> __COUNTER__)
>        |         ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro=20
> =E2=80=98compiletime_assert=E2=80=99
>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), =
msg)

TBH, I think this whole generalization is stalling the series.  We're
de-duplicating 20-ish lines of code implemented by adjacent functions
with something more complicated, I think mostly to formalize the
methodology of using flags to expand the ioctl data structure, which
has been our plan all along.  If it only addresses the duplication in
these two functions, the added complexity isn't that compelling, but
expanding it to be used more broadly is introducing scope creep.

Given the momentum on the iommufd side, if this series is intended to
be v6.13 material, we should probably defer this generalization to a
follow-on series where we can evaluate a more broadly used helper.
Thanks,

Alex


