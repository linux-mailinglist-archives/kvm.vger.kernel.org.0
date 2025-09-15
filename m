Return-Path: <kvm+bounces-57540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63603B57767
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3615D200C34
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD89E2FF16D;
	Mon, 15 Sep 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iXmRGYED"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D9E2FD7D3
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 11:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757934007; cv=none; b=iQOkQYuJA6LB1jmVuQ0E1Sekvr0A5nzUnWEqjn40SNhUCC8uolLlt0ShsL8j5ys9tn44b/aM4qDXazSiIKkytHZQo29GVXGqgDMsyqFyAHKcy7tJCFMM1ijDf0qIjDUWKJgEvOYuO892jXEyTvlGeYYKSwpnjsdmLKsf4kQaL1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757934007; c=relaxed/simple;
	bh=MZ2Lk0VILdWqbc27hgBRyrK0F859ToA8uD4l4sEkcHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8/VeHZX8v5E6FpgArnSY5tS1Lw0KaQk78EsQtfQydICgbmZhx9XQSZLAUSAOtA8pU0UaVxEHLuxLvpIv0GzdjkE9qEM8B7NQN+ApWzUFdUnaknP56rdjutBRLX1TdpRuqD4H7QJpnCrtYr86K20HDCeUi4hQx0KLrD6pBOaEtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iXmRGYED; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757934004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LG/krU4VzCXhXDYZfOJeBrVjlSMl4dB2Tr4WvxEGIU=;
	b=iXmRGYEDVo+R0Xbe3h0VbVvnPRQN7ADHHkVVPNEd+0zYB1HUWHAw7onxovwqaQIGU0dFvs
	4IqI6x30ZaAicQWYiY/Jo+jaYDP4rUUY2ghv75O+WEX/VjXt9VIWO2irapQKwHlboOPmpO
	ENCBF7jrbUODMa3VvFZ4hg8SanLX00U=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-tm91tbljO2qysiXgZBk4pg-1; Mon, 15 Sep 2025 07:00:02 -0400
X-MC-Unique: tm91tbljO2qysiXgZBk4pg-1
X-Mimecast-MFC-AGG-ID: tm91tbljO2qysiXgZBk4pg_1757934002
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-62ef8d95301so1632145a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 04:00:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757934001; x=1758538801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LG/krU4VzCXhXDYZfOJeBrVjlSMl4dB2Tr4WvxEGIU=;
        b=vAYDGTdVi+onxJmLuH96vVWwGcKppTxt8QKjJCBiCesLo9Nzu7i0p21COYCfqSc7Q9
         n9bW1/zXgLvPTlK0hZpJDbbrg4BPTMt6CFbCQtyyujeroMUeKma8nQCvzwhA6kFNQVBD
         zZ4gauthkuq6djhCGFF2memNlbmr5hpUS/gPFrKpBozsKdiuH+DHCIzbyAPxhowa8xFv
         ORDeMrvQFBlmAx3X0vhvSEEPlL9eYz7Rq8BP6WbUq4ZnddbaZPKvbeomcqvi+aNxjGQ2
         1FtkBnl9VZbZycmTET0i5scQfTEB4+zn4aEbycz7n4Z4ZBFd6mvOfp665TspTN5Jzckx
         Sosw==
X-Forwarded-Encrypted: i=1; AJvYcCWUFsjRGs4adVsUJF/4/rQwMrbBJRzlHROUlTHmEa1PYIrNg1snFz8XUGAlcb2j7kcH2jA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdVFB3BDr7RMoRtDwN1j9ck/kYZvz1og5KZHajwdXYD55eAwui
	irir3rH5yHajkWv7jzGJd9nxdugaK2mMwmboa3U8g6Is+AsWqsbnn4jalrqT4RL5yprGZspQZAl
	3CMjnzMhGN0xuMqucUIB9Tn9UgX8RlIhFHQ6FPKxc2hnCskQ1GkeMR5KLb5QlLFnuJKnPme4MGr
	psAAPf18aRtXa3U1+hbOFfzqwk8kPz
X-Gm-Gg: ASbGncsc9pgOXTKemfraysfDqqVil4dlfBRxuwvLAVekdA86uG4Qf7pjhJJz8ZbOJtk
	xc7W8GunfMiXs+CFBkCWg2o1LatqCWd5SdxCQQTQJ8G4sv6/jYGYTlULciGzFxet1OXu3eV08BJ
	rk7kNp3VMlHECdJ0AoyjOQ9w==
X-Received: by 2002:a05:6402:52c3:b0:61c:7090:c7de with SMTP id 4fb4d7f45d1cf-62ed827180amr11199636a12.13.1757934001636;
        Mon, 15 Sep 2025 04:00:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0FWS9+V2U6bS/hOunbJ92IvHyg28KU7vhAZPMSgU3NL7FZESOiBEKSGMh/3whVebsghh7ajGMdMYOU7jOcHY=
X-Received: by 2002:a05:6402:52c3:b0:61c:7090:c7de with SMTP id
 4fb4d7f45d1cf-62ed827180amr11199617a12.13.1757934001266; Mon, 15 Sep 2025
 04:00:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
In-Reply-To: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
From: Lei Yang <leiyang@redhat.com>
Date: Mon, 15 Sep 2025 18:59:24 +0800
X-Gm-Features: AS18NWCQ7fEFMgYdBUr25gcH_J-F5Mf8bPzgSCwAQZlFId0nTXghskAr0ksqVWA
Message-ID: <CAPpAL=wGgYsEcvR5Vy7F-FdnArbOu6VNy4Y_Syc=9qDM9P-VRQ@mail.gmail.com>
Subject: Re: [PATCH] vhost: vringh: Modify the return value check
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested this patch with virtio-net regression tests, everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Wed, Sep 10, 2025 at 5:18=E2=80=AFPM zhangjiao2
<zhangjiao2@cmss.chinamobile.com> wrote:
>
> From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
>
> The return value of copy_from_iter and copy_to_iter can't be negative,
> check whether the copied lengths are equal.
>
> Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> ---
>  drivers/vhost/vringh.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 9f27c3f6091b..0c8a17cbb22e 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1115,6 +1115,7 @@ static inline int copy_from_iotlb(const struct vrin=
gh *vrh, void *dst,
>                 struct iov_iter iter;
>                 u64 translated;
>                 int ret;
> +               size_t size;
>
>                 ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
>                                       len - total_translated, &translated=
,
> @@ -1132,9 +1133,9 @@ static inline int copy_from_iotlb(const struct vrin=
gh *vrh, void *dst,
>                                       translated);
>                 }
>
> -               ret =3D copy_from_iter(dst, translated, &iter);
> -               if (ret < 0)
> -                       return ret;
> +               size =3D copy_from_iter(dst, translated, &iter);
> +               if (size !=3D translated)
> +                       return -EFAULT;
>
>                 src +=3D translated;
>                 dst +=3D translated;
> --
> 2.33.0
>
>
>
>


