Return-Path: <kvm+bounces-22474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0981C93E9C8
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 23:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B3201C213DF
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 21:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43C87B3F3;
	Sun, 28 Jul 2024 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0ReRI3R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2E76F2E0;
	Sun, 28 Jul 2024 21:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722203647; cv=none; b=R36cb9JEkNd2O7jhSGGkUjahvLBDFWuXRGi6JaSt6PtvY+Kxd5sQaq7R/8qKzKnbUv9jpqq7NsFo/g23KsvWqUAU3b0Wi/6EyPj6bENXFkqiBBDl2LVDRtgqsmWY3txV18J3KFePrXwKCMm1a7c/WntbWBcti0vQgxdOWramcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722203647; c=relaxed/simple;
	bh=+C/PIPaD6421joj/GWXpDjtLOsgHcGGcKsxopH953Uc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ISpYbn7oa39SjmdUT+jRJ4TaoNWFhsU/OYFANfTgSRQGGdQzpOROfhJJsA5WaNPya6vuYTLCzDrzmZOOCMhvUVj8cU3iaHzXkzYFp+Vg3TfZjd/FwH5LmLH5x4+C0gM0eYbT2YICyd6VQjcEXu79pDd1QxkYe+8qEJ0SFniwraQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0ReRI3R; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5d5af7ae388so1304764eaf.0;
        Sun, 28 Jul 2024 14:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722203645; x=1722808445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yp5X1TEr87hrQcZlApkbTdXfq9FpLIGhmw7b0AOp0ew=;
        b=K0ReRI3Ri/Jz65GLjpBWK3BYbbXBTsENxfJWVd+fpalfM1NUSaAmQZyy4lNtt2OMtf
         9lxYgAQSLFP4Vwt4hdD6U/htuNPVLBVMEZOSzZLTx24URpap0nhsWehGVUNJNUmBXnoC
         A6ZQI4SeSPYdn9yvPoKLjJXrTv9boMuAqCtmmKvoonNFrDb5EjM8hiWFcowIBUAjelkM
         UmGt/b7YotMbGID3OpVRGWggCFtBZJFZTTtZiCvP/uP2eR7QKiSYPFww0sPqvvtG3lO4
         pQOCbt8EtS9zvZCPy2FnPYCwz7O4BjWK+8w9z782yThNWzm9BcuGQnfMqkF+NmuuqEOk
         cz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722203645; x=1722808445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yp5X1TEr87hrQcZlApkbTdXfq9FpLIGhmw7b0AOp0ew=;
        b=piG66+mCv9agbjymn9l4qSFg8XMsA7iW68kIWR95abDXNM4nKHHuNdBU5zOZz7TPC1
         IpuCb+BmBQm4flmOMEz2TXNurjOLwTex3ZsU2+epVPHuGyO4kBZ5LDOJ+aCXmWYtSX15
         lNsR+6nCZJWjl8JonOvm8v8iUTfrGd/8xRuuGWGVzIjf41OWdy0xHQMomMfPkCo36be3
         wtAAFVgRZhJjI+bEgNVcHmP13AxE3vKdJmm5DpLQJXqjMP6i2vJHiiM2YAK0keopf9HS
         +qKcZ37YCtzLLwrG07xvPQ9T6ZlJWWDOl8ChbiC2GdZpPhcwcbBN7iZUaWHlerQlG2/m
         a8Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUn6ll9Fz7hM/Fci+X3xYceO1Bvh2UkEoACcCs7acdySPLOfvRURjENFPdKF/TegnHMNMait+Hf8wJZoo5t4xL73NZl/q8wM8dNJYFhkWxWLCO86fEGWeL82K9YKPOvc+2dAeAN/R2QRXAPRWuwi1FrsfnhptNiJHLR5tfatrgd8MIT8WrGzJLBHwVD1d2cLZbc9w/4nCIfMeznwUSGFEiyM7A0GwTDF7jOxLiF
X-Gm-Message-State: AOJu0Yzm+oHtziCXC2bEUJHv9QuC0mZSvFEySua/ObV//7EKc3sjUGFx
	YLvyRXirTwCHqXFp3J+RyoTlBDnohhn7Jzs8U5BhjGH00nXdkqoZ20+aOozBiiHBnDQ/mpBK/wa
	HqmF9bR9nSo7B842is+iPCCK8dTw=
X-Google-Smtp-Source: AGHT+IExiqE8SwBoar+SBdGvUoKTQ8aTZKE7dvIbMpV+Hz/pPT7kpLZKZhHhpV3bwaQ9cRA95CjTvrUaUpXJvozawmQ=
X-Received: by 2002:a05:6870:8092:b0:254:ef42:f6f7 with SMTP id
 586e51a60fabf-267d64e7210mr2447775fac.15.1722203644655; Sun, 28 Jul 2024
 14:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-4-amery.hung@bytedance.com> <ce580c81-36a1-8b3b-b73f-1d88c5ec72b6@salutedevices.com>
In-Reply-To: <ce580c81-36a1-8b3b-b73f-1d88c5ec72b6@salutedevices.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Sun, 28 Jul 2024 14:53:53 -0700
Message-ID: <CAMB2axNUbWD9=Xg8TkB8XBmjuNw9f==Njzvh4-OP8kNw40O0Lw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 03/14] af_vsock: support multi-transport datagrams
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, 
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	bryantan@vmware.com, vdasa@vmware.com, pv-drivers@vmware.com, 
	dan.carpenter@linaro.org, simon.horman@corigine.com, oxffffaa@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, bpf@vger.kernel.org, 
	bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com, kernel@sberdevices.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2024 at 1:40=E2=80=AFPM Arseniy Krasnov
<avkrasnov@salutedevices.com> wrote:
>
> Hi Amery
>
> >  /* Transport features flags */
> >  /* Transport provides host->guest communication */
> > -#define VSOCK_TRANSPORT_F_H2G                0x00000001
> > +#define VSOCK_TRANSPORT_F_H2G                        0x00000001
> >  /* Transport provides guest->host communication */
> > -#define VSOCK_TRANSPORT_F_G2H                0x00000002
> > -/* Transport provides DGRAM communication */
> > -#define VSOCK_TRANSPORT_F_DGRAM              0x00000004
> > +#define VSOCK_TRANSPORT_F_G2H                        0x00000002
> > +/* Transport provides fallback for DGRAM communication */
> > +#define VSOCK_TRANSPORT_F_DGRAM_FALLBACK     0x00000004
> >  /* Transport provides local (loopback) communication */
> > -#define VSOCK_TRANSPORT_F_LOCAL              0x00000008
> > +#define VSOCK_TRANSPORT_F_LOCAL                      0x00000008
>
> ^^^ This is refactoring ?
>

This part contains no functional change.

Since virtio dgram uses transport_h2g/g2h instead of transport_dgram
(renamed totransport_dgam_fallback to in this patch) of VMCI, we
rename the flags here to describe the transport in a more accurate
way.

For a datagram vsock, during socket creation, if VMCI is present,
transport_dgram will be registered as a fallback.

During vsock_dgram_sendmsg(), we will always try to resolve the
transport to transport_h2g/g2h/local first and then fallback on
transport_dgram.

Let me know if there is anything that is confusing here.

>
> > +             /* During vsock_create(), the transport cannot be decided=
 yet if
> > +              * using virtio. While for VMCI, it is transport_dgram_fa=
llback.
>
>
> I'm not English speaker, but 'decided' -> 'detected'/'resolved' ?
>

Not a native English speaker either, but I think resolve is also
pretty accurate.

Thanks,
Amery

>
>
> Thanks, Arseniy

