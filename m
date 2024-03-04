Return-Path: <kvm+bounces-10805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FD687037F
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 14:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA241B23508
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 13:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37AD3F9FD;
	Mon,  4 Mar 2024 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTSXzAjr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468E93D3BD;
	Mon,  4 Mar 2024 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709560705; cv=none; b=Cr6IeApt5l7BRsQ95ABICjhl0fLPV7FpvH9SkdNIQFFtyyujrwF6D0yJiFVftdifXtCaQJWf/6iTDi0lHxmWBWzMdk46m4Fkx0M5LnsFt4D1M0Qhw+I8p3nJdc9ocN1Q2qwxH3u5AqgLEuxZlWie23CnHgPItdPIM9w/WWx36so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709560705; c=relaxed/simple;
	bh=GIIoMXTb+jubmj3EvUmA/6kXLnrIGswSSlxeQCgWaHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CVCtZCQ1E1DBLKH7VaW7w3wEW+fIZ6R6qKxwNjuR++Ibn0L1bdt/hAJoc6+naAbNpcmghuuYQS0yuv/wXs78TZK1hYWpob0N07GyylnkuWThcEc6v9dI/V4KS+xJfeslnxKdL6wxAHg9HjNyPmk5vcJyH4Z6NExtutYWJF31AEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LTSXzAjr; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-68f5d962aadso2100526d6.1;
        Mon, 04 Mar 2024 05:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709560702; x=1710165502; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Plfy//rsylxMHB4eQxxysPEOJTihZRQSC1sBjCrslCI=;
        b=LTSXzAjr5T2pA1fLBXSUmg9IqBFqVc2Trw45wOJkGun2tiX125T5P1St2wC3xvhKdr
         hoGWPm2Z+hJXg4RloQ9oigePEt9yZqOuNd8m8TFklhkKIoXwCgfn5I1txeDqzR0J1uVB
         ITOGvTKyTJKf1jkEwnGB/EQHEqzep0wWw7p9lLwTrGIDbLIN6NuX8cFv41zOwYheoGH9
         1CnayWgPreFY1e6FMzHpIF3a7ruyWG1uT1JXQPbmrpTUvQxDXbfqKJdiOoAEJSW/HYgL
         QiVcLx4WcC6KlINUt1OhsrSf7voPmuVeGmwEhrrWaDAiyzCibbzhtciZ0vAhzFnp7h0n
         MlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709560702; x=1710165502;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Plfy//rsylxMHB4eQxxysPEOJTihZRQSC1sBjCrslCI=;
        b=sulBeOy8qnQQB4+3cJm3rn5X9EC3bEQ2g0hHXVe52kNWJ/5jIR/vY4/8pwVtUkNHsO
         ROE2Px7gJMU0E62+PC24r11BHyRDsS8YkMdTAGhyXNlnJs3ADaVO8Jr6ke/x5HoTM0zp
         7CUzHPrLP5AIDWljuKw8oGE62e1hyrpufIN6CNnC7M0azSckviofiOiv028ZVUidPfi8
         ZKrz+ugWqG+X1GwMA9zO6P0/wXU9QLribHrWIhH++OSe+IspyoJVzIO+AM+irwDW/2IE
         bRFWF4NAL4QcdA45YrnaQTXYQs2Ukc2W2CqHv/Lqznoa3RvtyvlcaNbGPY1aMAL1U/MA
         5a2A==
X-Forwarded-Encrypted: i=1; AJvYcCUgblLIh2cOFGLVs3EXTFIjsiX4Dm3tPFXwvUiuxUXG4gPTccg3JpJwrUSl4gESv32CmOOU+EgbIL8z94VS3udPy/PuZvUxJkHgi3/zgQNGthY+WdydUjUpTWlTuI8RH+hZ07teq6D0FXnTOBlFPCsF/zGGgPbRLhwk0pWPc4+Ju2Q5QwUiDi+PfeWArowZ
X-Gm-Message-State: AOJu0YyPGLfwWKJ2LZIhQ9eR0jTjlltzu5ReXTsqES9AkTpVSW4SNqC6
	soJpaDAUxl1Sjjb0jumyiSZi1096cRqsd+jC3tlLRcmo03JXkH/hKnRmvrBVhW9S7xyEat7Bvyh
	+shJNgTLnGr1Z4aYh5FD+q7fwzVk=
X-Google-Smtp-Source: AGHT+IHVsvq0lEKFqn6fHC7GP6xP5UnPXqrWeVUiUt2RohzlqrCuJl+Isr9qbkGFJVhgPQdYWTGuml8Vs9zhghbXs5M=
X-Received: by 2002:a05:6214:1bc7:b0:690:3c85:c5b with SMTP id
 m7-20020a0562141bc700b006903c850c5bmr10351360qvc.3.1709560702082; Mon, 04 Mar
 2024 05:58:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1709118325-120336-1-git-send-email-wangyunjian@huawei.com>
 <75b6f7686c03519a1aaeb461618070747890143b.camel@redhat.com> <55ef319de7084614b1883018f69de1eb@huawei.com>
In-Reply-To: <55ef319de7084614b1883018f69de1eb@huawei.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 4 Mar 2024 14:58:11 +0100
Message-ID: <CAJ8uoz0xjdw7iHjP9=9wFPq21A6LdcYuGZBgwUKRemzkB5XoNg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check in xp_assign_dev
To: wangyunjian <wangyunjian@huawei.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "mst@redhat.com" <mst@redhat.com>, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"bjorn@kernel.org" <bjorn@kernel.org>, "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>, 
	"maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>, 
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke <xudingke@huawei.com>, 
	"liwei (DT)" <liwei395@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Feb 2024 at 13:52, wangyunjian <wangyunjian@huawei.com> wrote:
>
> > -----Original Message-----
> > From: Paolo Abeni [mailto:pabeni@redhat.com]
> > Sent: Thursday, February 29, 2024 6:43 PM
> > To: wangyunjian <wangyunjian@huawei.com>; mst@redhat.com;
> > willemdebruijn.kernel@gmail.com; jasowang@redhat.com; kuba@kernel.org;
> > bjorn@kernel.org; magnus.karlsson@intel.com; maciej.fijalkowski@intel.com;
> > jonathan.lemon@gmail.com; davem@davemloft.net
> > Cc: bpf@vger.kernel.org; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> > virtualization@lists.linux.dev; xudingke <xudingke@huawei.com>; liwei (DT)
> > <liwei395@huawei.com>
> > Subject: Re: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check in
> > xp_assign_dev
> >
> > On Wed, 2024-02-28 at 19:05 +0800, Yunjian Wang wrote:
> > > Now dma mappings are used by the physical NICs. However the vNIC maybe
> > > do not need them. So remove non-zero 'dma_page' check in
> > > xp_assign_dev.
> > >
> > > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > > ---
> > >  net/xdp/xsk_buff_pool.c | 7 -------
> > >  1 file changed, 7 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c index
> > > ce60ecd48a4d..a5af75b1f43c 100644
> > > --- a/net/xdp/xsk_buff_pool.c
> > > +++ b/net/xdp/xsk_buff_pool.c
> > > @@ -219,16 +219,9 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> > >     if (err)
> > >             goto err_unreg_pool;
> > >
> > > -   if (!pool->dma_pages) {
> > > -           WARN(1, "Driver did not DMA map zero-copy buffers");
> > > -           err = -EINVAL;
> > > -           goto err_unreg_xsk;
> > > -   }
> >
> > This would unconditionally remove an otherwise valid check for most NIC. What
> > about let the driver declare it wont need DMA map with a
> > (pool?) flag.
>
> This check is redundant. The NIC's driver determines whether a DMA map is required.
> If the NIC'driver requires the DMA map, it uses the xsk_pool_dma_map function, which
> initializes the DMA map and performs a check.

Just to provide some context: I put this check there many years ago to
guard against a zero-copy driver writer forgetting to call
xsk_pool_dma_map() during the implementation phase. A working driver
will always have pool->dma_pages != NULL. If you both think that this
check is too much of a precaution, then I have no problem getting rid
of it. Just thought that a text warning would be nicer than a crash
later.

Thanks: Magnus

> Thanks
>
> >
> > Cheers,
> >
> > Paolo
>

