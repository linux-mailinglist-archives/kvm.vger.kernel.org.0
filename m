Return-Path: <kvm+bounces-22475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3D493E9E9
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 00:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B388281A83
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 22:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0152F7BAEC;
	Sun, 28 Jul 2024 22:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6JxWZj7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7F28399;
	Sun, 28 Jul 2024 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722204388; cv=none; b=l3LMhxZmNsuoFohSpPwswzWCyBfh5XUD9XkCZoh9vBeNgQMoYLtPXkFV5DxaPXky1sZvcEEfdShR5kIvNaiRA7aTQffZi9s+UCNrD4O0PL04MZ7mpZ3hqMEq0vstq1lZWYxDmqJ4a2QS3QUTrGkWIXJdrLBJ+y77r1cZLLNzyWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722204388; c=relaxed/simple;
	bh=/Om46CZc4PtsVwKq9RtMi4ggxQSke4GiB3ovayUyC2U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lycAHM6crCmNDi2eoDGWepqOW7mqoXVhuagHga1f4LFqVxlP9DlihwvlyUpJ8ZOVjDTG35+XBLVxhf6Fgu6h8iQ0GX2fUQG8ID8o6ZxIQxI0J5Gdrr/Xpu/EK04skLfD5ut/xQkM5nG1nIb06eaAg+dQAGnnlOVK9xq4KVLtyy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6JxWZj7; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-260e5b2dfb5so1950937fac.3;
        Sun, 28 Jul 2024 15:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722204385; x=1722809185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2PlRW1dSG2ar0Zr3x1aqaupGL6BKGnqIl5mXFxckCJI=;
        b=m6JxWZj7uVJvNp2sqHw8D8TwrI6cvDfnsz5sHU/a1AI3x+2L7yxvI736oWjUOaQwmd
         Lm57GmGFvEpnZiT6Ddrs9Vv4cKwhIH0ok+RM2j+/NyEcGl+Aupz12Q2TGJjcsQM6EvER
         SKMM8M2RGOhSqli/YpAuDiJ5R9KyJEJATNeLYCSCff7BjMxeQ6vGXgUjIz5rhfc7LorR
         OgG3UHV+bXXOpCsPVTH3tkdAqz8g0i3NLNFEqF7NndVv6fgsHgm35IjM046zNhEXpNJA
         ztZhbnnEG86WrB/4L6NGAMTx2KaGQqpVQMg+37ELfoy6udavi+eX6Uwy9oQgoFN8L/LM
         cLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722204385; x=1722809185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2PlRW1dSG2ar0Zr3x1aqaupGL6BKGnqIl5mXFxckCJI=;
        b=bnzdnI8+BamovbSqFdC3pc/f3OGNeYirqWkwEoivhc1+NeDgp1/beM6zklDpFy/daV
         iY8LQXgqJPemhWpyoz+mumTcfz25t9apFSl702VuGtKD++udlsjnlApczfuWHHU5HSka
         P/xiLwWIH1F/35ADRwh5KhsFs2KzaUY2L6zZ62Z3VoHd7fcblbkgHaamiNs/kPIrALxb
         pNHhSjMYlDGyecBhKnXCVPk/gwVxm6Hc9cgyKlciDvHfCT0vmQRXayiHKBHnX477dwXg
         etdPhxZ0L2lbNHT3Uw8VBA02X6ewqbdHU2s3LgwzCGQpImvZkhWp/02svFw1PNv02TJl
         QFjw==
X-Forwarded-Encrypted: i=1; AJvYcCU/NPfexldDKlP/VhBCVJSC+Zt3fG8oZYuWhwmP6n2u/4+acIr4DWlCvPGzyUzosonK+04vXTCpGHnfJXaBiHu825Rea/3Og7B41sPC5Xv7PYa3mLim+Xa4ArqNK1Y8GC7Hd+UjS3XX91MRhzldR5BpPyXMnD73OTy6bOOGW4SRGw1UsFu+3hZS+hvJ7/R3qm1wVQh25Kz7L3F8CFAUy8A11dT7Xo0ysB1w8JAh
X-Gm-Message-State: AOJu0YwHkZ1Qk7VfdGn0nqvA8u3bl8PNxGL06iAAkytgO/LUzpwhCxF1
	Flb8Ev3LPEB4cJu4ucenkvUJatvPWVBgpJJFzqvlvxUbNa9VLfhOamr1Xp4g2eLtgBeP9oAexqM
	nATUu23iMBwuxXbxYGz9CbswuTeY=
X-Google-Smtp-Source: AGHT+IF3/AMl+VL5PHR/DpM82Ipap8UKg9+sdjntJk+s+YWO/Ff8gSb9JdRn1a75fyaaDpHxZSylfC0YOgiPdWqx72U=
X-Received: by 2002:a05:6870:e310:b0:261:858:1982 with SMTP id
 586e51a60fabf-267d4ef3b36mr7816424fac.36.1722204385516; Sun, 28 Jul 2024
 15:06:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
 <20240710212555.1617795-15-amery.hung@bytedance.com> <3ajts54ndduloqhl2uf7viyy7n5azu63i6waptvf3mzzwkrzr7@jebnovap7xxz>
In-Reply-To: <3ajts54ndduloqhl2uf7viyy7n5azu63i6waptvf3mzzwkrzr7@jebnovap7xxz>
From: Amery Hung <ameryhung@gmail.com>
Date: Sun, 28 Jul 2024 15:06:14 -0700
Message-ID: <CAMB2axNS6QEBuj1vMToy80fXvtJEzo_MzTgYQ1xc7__6jXNAVA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 14/14] test/vsock: add vsock dgram tests
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	xuanzhuo@linux.alibaba.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com, 
	wei.liu@kernel.org, decui@microsoft.com, bryantan@vmware.com, 
	vdasa@vmware.com, pv-drivers@vmware.com, dan.carpenter@linaro.org, 
	simon.horman@corigine.com, oxffffaa@gmail.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	bpf@vger.kernel.org, bobby.eshleman@bytedance.com, jiang.wang@bytedance.com, 
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 7:43=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Wed, Jul 10, 2024 at 09:25:55PM GMT, Amery Hung wrote:
> >From: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >
> >From: Jiang Wang <jiang.wang@bytedance.com>
> >
> >This commit adds tests for vsock datagram.
> >
> >Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >Signed-off-by: Amery Hung <amery.hung@bytedance.com>
> >---
> > tools/testing/vsock/util.c       |  177 ++++-
> > tools/testing/vsock/util.h       |   10 +
> > tools/testing/vsock/vsock_test.c | 1032 ++++++++++++++++++++++++++----
> > 3 files changed, 1099 insertions(+), 120 deletions(-)
> >
> >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> >index 554b290fefdc..14d6cd90ca15 100644
> >--- a/tools/testing/vsock/util.c
> >+++ b/tools/testing/vsock/util.c
> >@@ -154,7 +154,8 @@ static int vsock_connect(unsigned int cid, unsigned =
int port, int type)
> >       int ret;
> >       int fd;
> >
> >-      control_expectln("LISTENING");
> >+      if (type !=3D SOCK_DGRAM)
> >+              control_expectln("LISTENING");
>
> Why it is not needed?
>

I think we actually need it. I will add control_write("LISTENING") in
vsock_dgram_bind().

> BTW this patch is too big to be reviewed, please split it.

Will do.

Thank you,
Amery

>
> Thanks,
> Stefano
>
> >
> >       fd =3D socket(AF_VSOCK, type, 0);
> >       if (fd < 0) {
> >@@ -189,6 +190,11 @@ int vsock_seqpacket_connect(unsigned int cid, unsig=
ned int port)
> >       return vsock_connect(cid, port, SOCK_SEQPACKET);
> > }
> >

[...]

