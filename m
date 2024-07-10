Return-Path: <kvm+bounces-21251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2664192C820
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 03:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1928281D45
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 01:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4678BE7;
	Wed, 10 Jul 2024 01:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lj2EOIQC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC81D1B86D6
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 01:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720576535; cv=none; b=E4IKnE9bgonAXKJZvLO5MVCrnNA/eaG5zzlalJODEDCITiwVs/LWbW7M+nHz9XEMlbITgRCnVkKxI8wa2ICGOBT735AKe6mV+sJr2w0uIt27IApg1f7WaIniTZV/3WN4cdL6p2fr8Zr151NBFVx70hIApG+afrZyVjwhhDdeKPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720576535; c=relaxed/simple;
	bh=ZMvxitN1mWZbIIojrZGjIj+i5VQMDoCce2oy9LyMnA4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poYPa6Q8QLBzzkZhvhajZoJKlkeHds8fvbmVbJ0j0jekt10bitvEEmSxFq8zMPdkojef2L4FEjfn1b/9VWaW8c1CDZ5dBCFMn6oqSityPme7z357sV1ueqYd4yHQc0dXGUGAbZVknBj8+VokQPUtpITI0DXTo5BzsS3WPi+epSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lj2EOIQC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720576531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkFuMjkUgDvhPj5D2ZXJji0doQ0Fjub5jcr2VQL28o0=;
	b=Lj2EOIQCaFd6lp6ZY1NzHNsoA+kCmZUa7occ7p8DwwUzSDr1+YQhYyaxf/Uxo+05hEjzQG
	B81oOIguwuWotH49rgu4nMBftltE6ZcicwnzekFG+9la9GwvoBsnqRhzOncGu/DqvzhIii
	4P0MSXkY2O5/oBt9eXm3KHVBls41Drc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-jX2A1s0ZMHmrbdkHrC4y_A-1; Tue, 09 Jul 2024 21:55:28 -0400
X-MC-Unique: jX2A1s0ZMHmrbdkHrC4y_A-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7fbfbfea3f6so334265139f.2
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 18:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720576527; x=1721181327;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YkFuMjkUgDvhPj5D2ZXJji0doQ0Fjub5jcr2VQL28o0=;
        b=NDZgFvg8REaca9cOJQTBwM+K0PnUnbzDkplUMSj2+LK8DyJ5yc7UuGyp/scmF1uCks
         phz4XuZZM49+sAzjK5WAABS54yGCbyWY13V0HOmtEM1bunhTK0C51oF3GD4+Q5w3O8HB
         uj0Kvmk7gFbCBAWjrPpbV21Eb1S2DLlhBEQsA8V2Q1yQdYLu8ooSmRWIMABE0ZK4cFDE
         PjRZvA/SJyC5b/3DVbqsif23mmLL7U7T4Fl5hg5JcJQdU8RRmr1iRbNgPNWTTqyvWVbR
         tfAJe73WVDSwJORNmry+cboXZp5/EN8NZwPtcSSyKpoCogBb4mOOL1fGAzsYVKRqM/1t
         NHlA==
X-Forwarded-Encrypted: i=1; AJvYcCUOtQulM0eFxo+XCtxt4ld9oN3HHlLaILlT7xKAKLjZ5hS+f2gqCNYvw95yROgS2w8qqj2no2L7L22YV9v1+yVadMEu
X-Gm-Message-State: AOJu0YzxGx1xayM/OZ3ee94O3nfaWfBCHSIlLFqTDYDllwMmysLdJ2wA
	yvHUsbjmZhkigz1Ai8kh4zXiGZsmzdaXSYI/GLpAaA0aqGWr21iNc9hlC9hIFdBp7iwDGwgrAeo
	o/ETGuOr81wv1Q5egYjyOEAnv1Q3KqtF003G4aReNU61FsyIE9w==
X-Received: by 2002:a6b:f70c:0:b0:7fa:ef21:da0a with SMTP id ca18e2360f4ac-800034fd55bmr473449839f.14.1720576527293;
        Tue, 09 Jul 2024 18:55:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0vQpVT56z1RAi92Jlt6TDbJB5kYNBAILrVaYtA69EpCYSLHXYQJ9TSrfAK49qLeeJvfIqtQ==
X-Received: by 2002:a6b:f70c:0:b0:7fa:ef21:da0a with SMTP id ca18e2360f4ac-800034fd55bmr473448839f.14.1720576526803;
        Tue, 09 Jul 2024 18:55:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ffea4712d2sm84163839f.27.2024.07.09.18.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 18:55:26 -0700 (PDT)
Date: Tue, 9 Jul 2024 19:55:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org,
 =?UTF-8?B?xb1pbHZpbmFzIMW9YWx0aWVuYQ==?= <zaltys@natrix.lt>, Beld Zhang
 <beldzhang@gmail.com>
Subject: Re: [PATCH] vfio/pci: Init the count variable in collecting
 hot-reset devices
Message-ID: <20240709195524.3c394a58.alex.williamson@redhat.com>
In-Reply-To: <20240710004150.319105-1-yi.l.liu@intel.com>
References: <20240710004150.319105-1-yi.l.liu@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  9 Jul 2024 17:41:50 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> The count variable is used without initialization, it results in mistakes
> in the device counting and crashes the userspace if the get hot reset info
> path is triggered.
>=20
> Fixes: f6944d4a0b87 ("vfio/pci: Collect hot-reset devices to local buffer=
")
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D219010
> Reported-by: =C5=BDilvinas =C5=BDaltiena <zaltys@natrix.lt>
> Cc: Beld Zhang <beldzhang@gmail.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 59af22f6f826..0a7bfdd08bc7 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1260,7 +1260,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	struct vfio_pci_hot_reset_info hdr;
>  	struct vfio_pci_fill_info fill =3D {};
>  	bool slot =3D false;
> -	int ret, count;
> +	int ret, count =3D 0;
> =20
>  	if (copy_from_user(&hdr, arg, minsz))
>  		return -EFAULT;

Thanks, Yi!  I just got back from a long weekend and was planning to
debug this.  Thanks for finding the bug!

Alex


