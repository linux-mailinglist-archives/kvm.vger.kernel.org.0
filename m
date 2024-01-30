Return-Path: <kvm+bounces-7408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4293841998
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C6CE288619
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF2436AFD;
	Tue, 30 Jan 2024 02:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVKMemRU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4D93716D
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 02:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583058; cv=none; b=SsUnqZ+rLI5A8xel+u0DWeZsh3iJuYOW8uyi0I8Hwg9xo/Hp8fZ2wzJn48eauvM5R9afbww8yL2WZSJOIRKuJgrp/00pBIct4uR/HiMiCKw0tEyUlQogH4GdTjGmQwLB2z5HimuXyckGlryJnnoVyIT7Z9gIv6pyyB2cLn5VzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583058; c=relaxed/simple;
	bh=7/4OOmT0P01j47RMj7+gCYaiskBPgI0I+DKiyvwAdv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zy6jyMtugfAd81RnA5BXnwkM1z6584HpA10CjJNZ8C0iRGD8Vf/F7dNQsUbFy/9g7LyBYgoPcU99ap2wT1zq3LCYLQZVjBgN5/Ojgn3FwBwlifuKw19RAaeoKnAOf/bEmDKXzHGXDC1XvHuxycquI4V3x9w8MVNY5TS0K2oXLpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVKMemRU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706583056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PCU7cgSJXt8eqbIH0viYPN7vEYcJ8K/tx6HHt1Qm1ig=;
	b=TVKMemRUzNprPYtG6pIhGlUoiWX9YULfvzt3/SV0uoUyvVFQ7WJmJYaR4GkwqVmG8Z7suZ
	Hgh4mCzEnI5vRFVVaVuhVQT47shZdY2NDsJt3pCTJXBwScSce7UvR8sfLWxNWOJnBNRckL
	8ATnnbT/qkPiGnfzz5FuFdN0slWKidY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-6uEGJgzHNieTRaHmpAGG1w-1; Mon, 29 Jan 2024 21:50:54 -0500
X-MC-Unique: 6uEGJgzHNieTRaHmpAGG1w-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6dddd3e3263so2305046b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 18:50:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706583053; x=1707187853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCU7cgSJXt8eqbIH0viYPN7vEYcJ8K/tx6HHt1Qm1ig=;
        b=CF8yLNB1tgWQfyUi2bt0HDrz7bJpCp3EdVBB/3CNOCBYeBTf/gMF3o4DET2QAWlri2
         5v6T1/dt7g20zw65TyMG7WoOvSgPZe5HcITfbA9FLoTSvkmzcuA28jFIa+Zhn24ZX21M
         4/D0aZYhcZ6uLrsU1/n+piyDaUCzHHZn9+pleK1zjlBg4ldeCaRnjkN4tjfeIPmBCOhu
         NWVI3gTk0LwgYiP1Vpgqndn34uBH8cg13Q99449r+wiCsDoyV+BhKrrSvrMi0ijRc9Iu
         p2A5+icipA3ItG8+tBgprmYkpAZVzExKToegk/zJE2c90jacR4Zm5c7ouB5RYUAA1gUQ
         mOCw==
X-Gm-Message-State: AOJu0YydkXwocAHwK4pHHNo8/FnIOKREoHaq+RNVGyLGpPVg4J2VEeqf
	P1HC1u+q2WJBEkcVqlAu6Sv3HkgLXQ8y11aXPPyX6wm1mcGuWX/+xmKIschXz9I6X6q4uBm6hcq
	l4rpFYZYZ1SxJfeAUcrvvNJXLwIvlo5XeDf1/QRnnGy24Wam92lv2tP/bjA1VhaP6HcD7Y/tix2
	8G2lWv+t16nym/zzF+HuP0U/q8
X-Received: by 2002:a05:6a00:be4:b0:6db:7073:f845 with SMTP id x36-20020a056a000be400b006db7073f845mr3665898pfu.18.1706583053112;
        Mon, 29 Jan 2024 18:50:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGm5Itgw8YJiSPgIZ0ocMlecuXm83mHLHvX+aoPWUkQQ+32MJb0boVV1sfx4sU6lrRD47v7bJs7prWQkWvVf4w=
X-Received: by 2002:a05:6a00:be4:b0:6db:7073:f845 with SMTP id
 x36-20020a056a000be400b006db7073f845mr3665879pfu.18.1706583052830; Mon, 29
 Jan 2024 18:50:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com> <CACGkMEvvdfBhNXPSxEgpPGAaTrNZr83nyw35bvuZoHLf+k85Yg@mail.gmail.com>
 <0141ea1c5b834503837df5db6aa5c92a@huawei.com>
In-Reply-To: <0141ea1c5b834503837df5db6aa5c92a@huawei.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 30 Jan 2024 10:50:41 +0800
Message-ID: <CACGkMEsyvgnezk2DXX-Z7Wt9zHV9o=w_wcN8z+dyoZ9LB1qqjA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
To: wangyunjian <wangyunjian@huawei.com>
Cc: "mst@redhat.com" <mst@redhat.com>, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>, 
	"magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke <xudingke@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 7:40=E2=80=AFPM wangyunjian <wangyunjian@huawei.com=
> wrote:
>
> > -----Original Message-----
> > From: Jason Wang [mailto:jasowang@redhat.com]
> > Sent: Monday, January 29, 2024 11:03 AM
> > To: wangyunjian <wangyunjian@huawei.com>
> > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com; kuba@kernel.org;
> > davem@davemloft.net; magnus.karlsson@intel.com; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>
> > Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
> >
> > On Thu, Jan 25, 2024 at 8:54=E2=80=AFPM wangyunjian <wangyunjian@huawei=
.com>
> > wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jason Wang [mailto:jasowang@redhat.com]
> > > > Sent: Thursday, January 25, 2024 12:49 PM
> > > > To: wangyunjian <wangyunjian@huawei.com>
> > > > Cc: mst@redhat.com; willemdebruijn.kernel@gmail.com;
> > > > kuba@kernel.org; davem@davemloft.net; magnus.karlsson@intel.com;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > kvm@vger.kernel.org; virtualization@lists.linux.dev; xudingke
> > > > <xudingke@huawei.com>
> > > > Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
> > > >
> > > > On Wed, Jan 24, 2024 at 5:38=E2=80=AFPM Yunjian Wang
> > > > <wangyunjian@huawei.com>
> > > > wrote:
> > > > >
> > > > > Now the zero-copy feature of AF_XDP socket is supported by some
> > > > > drivers, which can reduce CPU utilization on the xdp program.
> > > > > This patch set allows tun to support AF_XDP Rx zero-copy feature.
> > > > >
> > > > > This patch tries to address this by:
> > > > > - Use peek_len to consume a xsk->desc and get xsk->desc length.
> > > > > - When the tun support AF_XDP Rx zero-copy, the vq's array maybe =
empty.
> > > > > So add a check for empty vq's array in vhost_net_buf_produce().
> > > > > - add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
> > > > > - add tun_put_user_desc function to copy the Rx data to VM
> > > >
> > > > Code explains themselves, let's explain why you need to do this.
> > > >
> > > > 1) why you want to use peek_len
> > > > 2) for "vq's array", what does it mean?
> > > > 3) from the view of TUN/TAP tun_put_user_desc() is the TX path, so =
I
> > > > guess you meant TX zerocopy instead of RX (as I don't see codes for
> > > > RX?)
> > >
> > > OK, I agree and use TX zerocopy instead of RX zerocopy. I meant RX
> > > zerocopy from the view of vhost-net.
> >
> > Ok.
> >
> > >
> > > >
> > > > A big question is how could you handle GSO packets from
> > userspace/guests?
> > >
> > > Now by disabling VM's TSO and csum feature.
> >
> > Btw, how could you do that?
>
> By set network backend-specific options:
> <driver name=3D'vhost'>
>         <host csum=3D'off' gso=3D'off' tso4=3D'off' tso6=3D'off' ecn=3D'o=
ff' ufo=3D'off' mrg_rxbuf=3D'off'/>
>     <guest csum=3D'off' tso4=3D'off' tso6=3D'off' ecn=3D'off' ufo=3D'off'=
/>
> </driver>

This is the mgmt work, but the problem is what happens if GSO is not
disabled in the guest, or is there a way to:

1) forcing the guest GSO to be off
2) a graceful fallback

Thanks

>
> Thanks
>
> >
> > Thanks
> >
>


