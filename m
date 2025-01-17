Return-Path: <kvm+bounces-35875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E19FA15907
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05B91670B4
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454CA1AAE2E;
	Fri, 17 Jan 2025 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NCsUAaem"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E951714A1
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737149490; cv=none; b=CJFBUDh4ahf2juJpmbGMkNqgVuNGOc87hjlc4lWu8A0neoqEVDIalbgLAPxUOmy4cnZCID/US5NHBvajSRM0BAoWV2kT4mUdzYjpBDiO8qeS3vmWODCmPQauGSXFCLMMqFM3aSl+4Z9rz3ZRBKUaY0w2VCWcq5G9vNLq4SmodJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737149490; c=relaxed/simple;
	bh=URYtzwHaqHyyjSm8MWg+z/STBcL3q1UIAPmgvFW+drw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4oJldDekeyJx1aAhphAWsnuJUzsp9TFAHcT3V7Pqb3St7+tzL+nuQ0L09ki9zyPWzwyEwnfCGSdrfNm7sx/vyMujiiBYS2RFs90BlMWlHEYuRzxXnSprrpRY2m8fx1JaqneEkqOFTQsixy+vjKQq3ZLQrauumS2rZf7Fc5/TOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NCsUAaem; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737149488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXkX6EUOkHpV3m0oGcaG/021SThKCpwYilAQGnGl0XA=;
	b=NCsUAaemnXFa0FquC9YNEEOWglt5nV2eXKSgRpNaXtH+4knTfUvho4CcUQCeWhVHHOTB/4
	mUyiVy0dUIOPeeX3w6Kqu7EBTYHcWxviYx6FKavdsRxekSWmVYr1EKjMZIx6Qis0z/e+Ph
	T0Z5MKkexBtrBq9QeRSb7t3JjWjikD0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-SS3ftlHhMuixCjha_61Xcw-1; Fri, 17 Jan 2025 16:31:26 -0500
X-MC-Unique: SS3ftlHhMuixCjha_61Xcw-1
X-Mimecast-MFC-AGG-ID: SS3ftlHhMuixCjha_61Xcw
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-849cc81984eso12941939f.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 13:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737149486; x=1737754286;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXkX6EUOkHpV3m0oGcaG/021SThKCpwYilAQGnGl0XA=;
        b=lRE0k6fDBYcshiaoZBBVtN4gdK1gxXagygtQ/0nUUdr1ZjNVdhh5iDqqxKN7SPk8lR
         rAigqCfGUpeHlZNRhRm74+lhNpJ49zpwqi0CGXmZuNnqjp9IwJXct9lLBMLQew3MIa0s
         /A8rss7PVNKPgOfpi+kqkhIPezrE3srK7yFZ+sMMHq+hfU7yaCcvE8lAkcNQnXxCp3rm
         1feSDVvxaDk41hS8vOmWAUJVf73SVdh+7DP/I+1fzGd3j+yxrqefn9l8/8EaZl8V1P5e
         zNtOL64oGT8g5iymig/IMre8JTJ5turDmXsuhnPsGjmAQhBQd5YBCEHuG7SmgZ+JZlzF
         ygBg==
X-Forwarded-Encrypted: i=1; AJvYcCU5CWzONACJnrFPxnROKVfdjKTHg9JIFZLuYpt+v9oOhkXTj92KvVDKiS7vfIo9jxa9AWI=@vger.kernel.org
X-Gm-Message-State: AOJu0YydmPDkTWEh+NozcHbT6tyzv8/4iDDBdHnMBUl8agJLzQXqCpxR
	k31MZqN5zI1hjHgx7E9aCQfcwXeD8dL2h7Zb15RUdBRkpeEnTkpvi1zyrvEf7jU7xrdStb7b2/O
	imjGBGR8m6yaY0TmR1uZhrvaiEcAViw2NYCbtSMzjLK2rkGv/QA==
X-Gm-Gg: ASbGncsQoiY/Eidm/Vhx/19wCfsIQ//OGLBiQjWnQjUljXw0sNW5FRCksUZBawYTw6q
	Nn4yFTGha3cXISIaY7ndS2dTm1mn6Y6VaLSLV88KZcUInARQXnw1XjGf7LqH83Lxo9oJXPm/+nC
	oB+XxHepJeqg75escyxcdaV2NHbMpvvJ3rDK/YlZCPWSyDMwkJVYoGzhttW/IOUHbK3IYgwVxs6
	hMPOtegZhidt7a05QcjuTi5HF6vmrW6/J+BGhQcwxgbqRWHHylhNK7oV4cyoKh2FbA36DtNOQ==
X-Received: by 2002:a05:6602:8c1:b0:84a:51e2:6642 with SMTP id ca18e2360f4ac-851b618ab9emr88637539f.2.1737149485612;
        Fri, 17 Jan 2025 13:31:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSd0M5RX2RVoKaQYO0/jLbCWOntW3vlF4ULNemQk85jweN5ABdI5zEy20LoW6yTsGZ24C9fA==
X-Received: by 2002:a05:6602:8c1:b0:84a:51e2:6642 with SMTP id ca18e2360f4ac-851b618ab9emr88636939f.2.1737149485273;
        Fri, 17 Jan 2025 13:31:25 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea753f64b4sm821316173.28.2025.01.17.13.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 13:31:24 -0800 (PST)
Date: Fri, 17 Jan 2025 16:31:08 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 "shameerali.kolothum.thodi@huawei.com"
 <shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
 <kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
 <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Dan Williams <danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)"
 <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Message-ID: <20250117163108.3f817d4d.alex.williamson@redhat.com>
In-Reply-To: <SA1PR12MB7199624F639518D3CA59C7F4B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
	<20250117152334.2786-4-ankita@nvidia.com>
	<20250117132736.408954ac.alex.williamson@redhat.com>
	<SA1PR12MB7199C77BE13F375ACFE4377EB01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
	<20250117143928.13edc014.alex.williamson@redhat.com>
	<SA1PR12MB7199624F639518D3CA59C7F4B01B2@SA1PR12MB7199.namprd12.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jan 2025 21:13:52 +0000
Ankit Agrawal <ankita@nvidia.com> wrote:

> >> > We're accessing device memory here but afaict the memory enable bit =
of
> >> > the command register is in an indeterminate state.=C2=A0 What happen=
s if you
> >> > use setpci to clear the memory enable bit or 'echo 0 > enable' before
> >> > binding the driver?=C2=A0 Thanks,
> >> >
> >> > Alex =20
> >>
> >> Hi Alex, sorry I didn't understand how we are accessing device memory =
here if
> >> the C2C_LINK_BAR0_OFFSET and HBM_TRAINING_BAR0_OFFSET are BAR0 regs.
> >> But anyways, I tried 'echo 0 > <sysfs_path>/enable' before device bind=
. I am not
> >> observing any issue and the bind goes through.
> >>
> >> Or am I missing something? =20
> >
> > BAR0 is what I'm referring to as device memory.=C2=A0 We cannot access
> > registers in BAR0 unless the memory space enable bit of the command
> > register is set.=C2=A0 The nvgrace-gpu driver makes no effort to enable=
 this
> > and I don't think the PCI core does before probe either.=C2=A0 Disabling
> > through sysfs will only disable if it was previously enabled, so
> > possibly that test was invalid.=C2=A0 Please try with setpci:
> >
> > # Read command register
> > $ setpci -s xxxx:xx:xx.x COMMAND
> > # Clear memory enable
> > $ setpci -s xxxx:xx:xx.x COMMAND=3D0:2
> > # Re-read command register
> > $ setpci -s xxxx:xx:xx.x COMMAND
> >
> > Probe driver here now that the memory enable bit should re--back as
> > unset.=C2=A0 Thanks,
> >
> > Alex =20
>=20
> Ok, yeah. I tried to disable through setpci, and the probe is failing wit=
h ETIME.
> Should we check if disabled and return -EIO for such situation to differe=
ntiate
> from timeout?

No, the driver needs to enable memory on the device around the iomap
rather than assuming the initial state.  Thanks,

Alex


