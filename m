Return-Path: <kvm+bounces-64612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4E9C883E0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B4AE4E3854
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD5530DEA6;
	Wed, 26 Nov 2025 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OGSfXKH9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="swFWGOBn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA82219E8D
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764137925; cv=none; b=cAvfVbuVelgJbGSr+VQWY4OVig8itsBHb9QeH1cEJaxEb6eLHJ7xk9euXp54cb35bC2pANQv0dgA3bHCdnyJKaDEQ8WwGQx/JKJhe0Rl36aWMZZPgGdCphTlCTTe8Bc+/PKcDTF1/Uj4Y0ZNGEgseULw8T6QBsuzqnTaBno6bUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764137925; c=relaxed/simple;
	bh=9IyvSK4NGPHO4fuFRUIAoekh2Pyy3yq0MdSh3GgP3u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=etDZZ4zcdwbthNtWE1Yv2I4HfDPlgFghnrG62xxZXzT8UZmPSMcDi4BNAiyJoWTKFK7XJOrwoVrHlCb4e2Nd35/RCDN//xAd2jXu6iOKAkVHTe2u+bXzpWUA8fGj07tifX3jK5R9qwI/15GV0CUH+d4GIXQOaM+P6TOhgPiZp24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OGSfXKH9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=swFWGOBn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764137922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4EAaBQUbKXStRQ2aorpN5sb6DcjtPj0E0lOttGJD0E=;
	b=OGSfXKH9GL+D7bhVC43zsE+Oic4BIYpGDS43JnS/uCaFauqpSCqufMvrxuyxwjU0rY0V+9
	0zH/IEpSWP7QyH0DJdW5RBCP0ouJTcB2+mOf1kSuH9qxV/KLOZB6bSz+bEgS/I9SbXF+Nt
	2hS1497hkv2WUvW1QMzt/57KbQIZSlY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-32nihg--MJGcS9TpoTmg9w-1; Wed, 26 Nov 2025 01:18:40 -0500
X-MC-Unique: 32nihg--MJGcS9TpoTmg9w-1
X-Mimecast-MFC-AGG-ID: 32nihg--MJGcS9TpoTmg9w_1764137919
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34374bfbcccso5846246a91.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764137919; x=1764742719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4EAaBQUbKXStRQ2aorpN5sb6DcjtPj0E0lOttGJD0E=;
        b=swFWGOBn3vVHCYFwL35fL63bcPfobOWfrFQUJOpORH8m+T09XEy87gHcD4eiN5C+0j
         qf2ouvR56rldegVgXkc28VVQmPX7k1i74DXw3U8HhOjzWmRnrfYfjiRolKPvPjgIm1O5
         KRwcOo57HxgA2W4ZKSRCrUh1GJOC5IJM7vd/IyUOn4z2hiBFbloOqXVon94yBg2qgefR
         eFwns6zD+vbxwzwhYXyf/POCVrytjKyZxllaRvdJqw8o50aFTIouCPcZ0SXDY9epn0zy
         dK617O4bOk+wfgn8FcMp7YD1C/RZLZWS+Sq9Q6YVVCvI9uVCpfpxIwwyMtTKfu6NnV4c
         ztZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764137919; x=1764742719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k4EAaBQUbKXStRQ2aorpN5sb6DcjtPj0E0lOttGJD0E=;
        b=s3tuY4Nn2CrGyvk8vjMTDgWCLtUc7NWQSA4fogYj9dQD/ghYpz8IajRRZmOCTaa/9j
         2fAzK+jZ9RL3pZFOBViIQfrjYNndvTkKWNyB1n7zjJglUGq3lwMFXtDYPuN+DTe/RfzY
         FPntP3r26vzhlKGuQd0Q6aMdkLNxPa9ny700TBaJvmiysfOCDVeXqeqokwgglpkwxyuY
         khgeUob3PtfMw2AYsIuoBXe52OZkQGORPIUB//9u07DLKfuP9eQR9mRztX9d2gxU3RUO
         Ch2TrXVuWsoh3hnzWI8BMYzDTMbAkG4hCHFDCZ90zLHP6A0cX9aYmusJAixLJfTq8TmI
         5bOA==
X-Forwarded-Encrypted: i=1; AJvYcCVLcrhwT6KExl4FJ+zCCq6JaKrNes8JgzNRKTlfjR2NDU1/B2z2O8Gv9PATDZuQMIzQKKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YykV9Wayd0qC9E6E0/rNgEXJVVDX5ag2YGk/RTwjrOxOVPXZGOB
	6tXyy8uUGMx0s1u9ZUzcoO5BnBL9s+GFyKzDeRc0IPJZVehAFaC8aag2ilsHaS9Uw93rzY5/mlg
	ODkqrmE0CkIJjdVTBWEWx+45BvYR3SQ1i8ucXlq5KNl2p0DZIskbaOXfWtHMpHHDwrLOvyRb+x/
	v4Tby+f0wojvf5klKJLsX5M5A6SV+V
X-Gm-Gg: ASbGncsstUiNSO0PBpoXn6E1HaCMkIx71PK21tFPyDO9ypSqJ4zE0YnKL8FNLw3hZ7a
	fWGBLMOuG1/1FiQ1WiDJcqyarSa0CK5SvnNDu9hjIEZzh+5N+ErPhSSEfm4dZFfLQnr37MoVdov
	2DMoZCV6kxQZMO84CkV4tgl8eN4AEOsvR0hlbNkGGJ5nX81PH+kNAzG/L1a2bCbAFbWlM=
X-Received: by 2002:a17:90b:280d:b0:32e:3829:a71c with SMTP id 98e67ed59e1d1-3475ec0f397mr5733497a91.16.1764137919251;
        Tue, 25 Nov 2025 22:18:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhRJldpd1OviU1vEEpkzZI2Tkr6ToasHRbqSGmjMSAi+R/5zZDXEphzASNpDnCWhFCs+nIjE+SnB6J4DOjgAg=
X-Received: by 2002:a17:90b:280d:b0:32e:3829:a71c with SMTP id
 98e67ed59e1d1-3475ec0f397mr5733479a91.16.1764137918886; Tue, 25 Nov 2025
 22:18:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120022950.10117-1-jasowang@redhat.com> <20251125194202.49e0eec7@kernel.org>
In-Reply-To: <20251125194202.49e0eec7@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 26 Nov 2025 14:18:25 +0800
X-Gm-Features: AWmQ_bn5sM2oyO_hdA7aO1WikB4cbE8JxiHO9Gu_Ovx5iCRUVPSo0zJRLtZg_zg
Message-ID: <CACGkMEuCgSVpshsdfeTwvRnMiY8WMEt8pT=gJ2A_=oiV188X0Q@mail.gmail.com>
Subject: Re: [PATCH net V2] vhost: rewind next_avail_head while discarding descriptors
To: Jakub Kicinski <kuba@kernel.org>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 11:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 20 Nov 2025 10:29:50 +0800 Jason Wang wrote:
> > Subject: [PATCH net V2] vhost: rewind next_avail_head while discarding =
descriptors
>
> >  drivers/vhost/net.c   | 53 ++++++++++++++++++------------
> >  drivers/vhost/vhost.c | 76 +++++++++++++++++++++++++++++++++++--------
> >  drivers/vhost/vhost.h | 10 +++++-
>
> Hm, is this targeting net because Michael is not planning any more PRs
> for the 6.18 season?

Basically because it touches vhost-net. I need inputs for which tree
we should go for this and future modifications that touch both vhost
core and vhost-net.

Thanks

>


