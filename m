Return-Path: <kvm+bounces-54688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F3E4B26DF9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 19:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80E015E0224
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 17:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185BA310772;
	Thu, 14 Aug 2025 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MpOoDbzN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970FB30E848
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755193976; cv=none; b=A8rSXbCX0CQbxjQMQbcExAZx7JM1uKyYmb72sarEaV8J5NDfBjqLETR/5jz9ez3uuwATEHEpskHc0I6elg0VY0kkG5YkrY4SFX8pey4QCn4qt0MrzqiXWBC7VYl3CbXpUkQS7JnOw7B3QdE9T/FiYjLBkW0CEe3Tkg3uIOGOmXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755193976; c=relaxed/simple;
	bh=5AXMAHtgSY3kGFo/8RIc4Xfc76KO5VPZj6UaYE27jPU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OzV5g+AXqFjC1srWeiIoG7zQyFRely4PnG6WY5Q3C6r4flB9OmbkOXk3LT4fVaFQxpJDm9A2wp17nOwJVURFdgfixHMY5B/xNU+Ih7d+e0V7hCFeI2U0BomkKjJOV7neKzGJevGRCGUWtAdmzOQ0ArmrQDWJiP+2CsnNEKy1VlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MpOoDbzN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755193973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afaa+Ttiy+6bJd212ACVlG8vIlclb/LYuy8F+ALkIxo=;
	b=MpOoDbzNkWn9mxo0TWXRRLKDfe3E22nQWnuzZIo93tBHx679+O4dhgGHDd7dez8mHkwIM3
	6uaLycgkBWbx8XGXf/r6ijVv0N6CGHzQ0rjNDRXhxiINGvS4m392D5Wkgc5zRMshX8ZNmQ
	Fn3fLHpZL8Gj6dxSS2dS0MEm7LDYXBM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-p5QYsMPwP1W3n0KUfd9G_w-1; Thu, 14 Aug 2025 13:52:52 -0400
X-MC-Unique: p5QYsMPwP1W3n0KUfd9G_w-1
X-Mimecast-MFC-AGG-ID: p5QYsMPwP1W3n0KUfd9G_w_1755193971
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e56fe7d3deso3198375ab.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 10:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755193971; x=1755798771;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=afaa+Ttiy+6bJd212ACVlG8vIlclb/LYuy8F+ALkIxo=;
        b=JCa2dzsWEYdVys+0NXhnfxHuQxWvudnwqVg0KHrq5Y/DsKyKVOh/ks39P+ddW+8L+o
         TIQHcpmXm3nGGXMvVLhN9eYmnfCyW3Ims7XIlv1JTJSSWta/sQRP1s2HcLZV6CdTa8lR
         xkS5eW8RSAbxKSXEf+ZaSmOnhilkyVGgwPoPcOQq/n5sQwb/5t/pXSabCfnOHUJ6u8Dd
         u5Xe+QVgY8KlepnmxAsqogvGk048DthtRWGUol2lp1OsghHG8oLN5Bs8VBQlYkgxrxAA
         yEKkJwx26+1w6/UXAy9qGeyF4NaZaDXlqR4BniLrJqvNhOGfFJ5sVDR6SVYEpdowvDgo
         9huw==
X-Forwarded-Encrypted: i=1; AJvYcCWiCZ7RrS2Nud8EtMpmqLnDgnxeOD7Ug8PAqmQai7S2duvXA0a72PQHjDxeTDGzphkLtNc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yylr/79qiFeDo18yE20LwUQxA7l13WGld0PIw9l39mBNHs5IOWd
	nopN534abOBHIVkbwW6uWpoY+Nqh8neXTMaJ5c8vKSopyUTbktrKGPUBzJEcRWuXLnxgbwlg0/Y
	Z47a3dL0IXsFwEtpA5nFaNxSLaTxiXIQtbFNS4ykE+J5D2A9K8aeoRg==
X-Gm-Gg: ASbGncspclls7Yv1gLMM7LGYx8szVCy68JNj/A4McPeElMT8ZR9ikvMNtezuOir56pp
	8FfN6m347afGA3Q9nU+GfpEZFklW8BNOUIG8j76lVVBbfjTz1AxOJYCrtOeHeelXWSi+FMKUYH/
	AM73Amm/Jl4NiLbKMeuPKmaL1h9h5IajJhjIP/sM8wuhU/euWfhIpL2OjLMToXE+duY0NLyd4br
	kjOdykgHRhNRtlbjpEHp5fRmBNTQUy22gVGCZ06A5sUufHJHOBP24ocjt6dsszLcFDR/pvlYgIN
	fwzlme8ruaOrmTMY2B31BfT0an4i3HBnvCxyOu5Mju4=
X-Received: by 2002:a05:6602:2b88:b0:881:982b:9963 with SMTP id ca18e2360f4ac-884339a49a1mr218633739f.3.1755193971213;
        Thu, 14 Aug 2025 10:52:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVDcT6P7UI8d62akowuwc8tY/d9YpZeehaTUjRBqyUowCNHyf47OXTP3WPKB7t8/XiFPKezw==
X-Received: by 2002:a05:6602:2b88:b0:881:982b:9963 with SMTP id ca18e2360f4ac-884339a49a1mr218631739f.3.1755193970717;
        Thu, 14 Aug 2025 10:52:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ae997ea94sm4370937173.1.2025.08.14.10.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 10:52:49 -0700 (PDT)
Date: Thu, 14 Aug 2025 11:52:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt
 <benh@kernel.crashing.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Kumar, Praveen" <pravkmr@amazon.de>, "Woodhouse, David"
 <dwmw@amazon.co.uk>, "nagy@khwaternagy.com" <nagy@khwaternagy.com>
Subject: Re: [RFC PATCH 0/9] vfio: Introduce mmap maple tree
Message-ID: <20250814115247.4458764a.alex.williamson@redhat.com>
In-Reply-To: <lrkyq349uut66.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
References: <20250804104012.87915-1-mngyadam@amazon.de>
	<20250804124909.67462343.alex.williamson@redhat.com>
	<lrkyq5xf27ss7.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805143134.GP26511@ziepe.ca>
	<lrkyqpld96a8a.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
	<20250805130046.0527d0c7.alex.williamson@redhat.com>
	<80dc87730f694b2d6e6aabbd29df49cf3c7c44fb.camel@amazon.com>
	<20250806115224.GB377696@ziepe.ca>
	<cec694f109f705ab9e20c2641c1558aa19bcb25b.camel@amazon.com>
	<20250807130605.644ac9f6.alex.williamson@redhat.com>
	<20250811155558.GF377696@ziepe.ca>
	<20250811160710.174ca708.alex.williamson@redhat.com>
	<lrkyq349uut66.fsf_-_@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2025 11:52:17 +0200
Mahmoud Nagy Adam <mngyadam@amazon.de> wrote:

> The last email was a draft sent by mistake. This is the full version.
>=20
> Alex Williamson <alex.williamson@redhat.com> writes:
>=20
> > Currently we have a struct vfio_pci_region stored in an array that we
> > dynamically resize for device specific regions and the offset is
> > determined statically from the array index.  We could easily specify an
> > offset and alias field on that object if we wanted to make the address
> > space more compact (without a maple tree) and facilitate multiple
> > regions referencing the same device resource.  This is all just
> > implementation decisions.  We also don't need to support read/write on
> > new regions, we could have them exist advertising only mmap support via
> > REGION_INFO, which simplifies and is consistent with the existing API.
> > =20
>=20
> What I understand is that you=E2=80=99re proposing an API to create a new
> region.  The user would then fetch a new index and use it with
> REGION_INFO to obtain the pgoff.  This feels like adding another layer
> on top of the pgoff, while the end goal remains the same.
>=20
> I'm not sure an alias region offers more value than simply creating an
> alias pgoff.  It may even be more confusing, since=E2=80=94AFAIU=E2=80=94=
users expect
> indexes to align with PCI BAR indexes in the PCI case.  We would also
> need either a new API or an additional REGION_INFO member to tell the
> user which index the alias refers to and what extra attributes it has.
>=20
> Ultimately, both approaches are very similar: one creates a full alias
> region, the other just a pgoff alias, but both would require nearly the
> same internal implementation for pgoff handling.
>=20
> The key question is: does a full region alias provide any tangible
> benefits over a pgoff alias?
>=20
> In my opinion, it=E2=80=99s clearer to simply have the user call e.g
> REQUEST_REGION_MMAP (which returns a pgoff for mmap) rather than request
> full region creation.

In part this is the argument we've already discussed, creating a new
region and then getting REGION_INFO adds a step for the user, but we
already have REGION_INFO as the standard mechanism for introspection of
regions.  We also have capabilities available as a mechanism within the
REGION_INFO ioctl to describe the mapping flags or region alias
relationship.

If we're this concerned about one additional step for the user, design
the DEVICE_FEATURE ioctl to return both the new region index and the
file offset, the user can ignore the region index if they choose.

To me, regions are just segments of the device fd address space,
regions have a unique offset.  Regions have a vfio-pci specific
convention where a fixed set of region indexes refer to fixed device
resources but never is there a statement in the uAPI that region 0
_uniquely_ indexes BAR 0 and there will never be another region index
mapping this device resource.  The convention exists only to bootstrap
standard device resources.  Adding a mechanism to get a file offset
which is an alias of a region, but not itself reported as a region is
to me, splitting up the device fd address space into two different
allocation methods.

The argument that userspace drivers will get confused if region N
aliases region 0 makes no sense to me.  The user has actively brought
region N into existence knowing in advance that it's addressing the
same device resource as region 0.  Exactly in the same way they'd know
the file offset they get back from REQUEST_REGION_MMAP is an alias to
the requested region.  BUT, since we're invoking a new region, we have
mechanisms to allow persistent introspection of that new region.

The tangible benefit to me is that a new region better aligns with the
existing API and has that introspection/debug'ability aspect, versus
creating an alternate mechanism for making allocations from the device
fd address space.  Thanks,

Alex


