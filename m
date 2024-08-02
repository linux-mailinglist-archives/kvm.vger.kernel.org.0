Return-Path: <kvm+bounces-23003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D971A9456B0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 05:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38DB8B21FDD
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 03:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063C322626;
	Fri,  2 Aug 2024 03:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KRF6Zm7K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183C81C2BD
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 03:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722569416; cv=none; b=ZdKfQ/R1Bakrmx8AltLTj1xEoBQcBLa4LRb/xU7U+lTYNx4IhfkCjiGSphy3nYE1x+4JjNB9/MVmkvlOj+2ggpaL8lmSmlQFVo/Pmx0MULNfLAoI7IXvwSn4nBAP0yHptmoXZyp38pw4t41AERYSGud8C+7fgwUUf/toefPDlJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722569416; c=relaxed/simple;
	bh=fkuBZ/9voPFfArgs0u7ovfz/ciJcaqzcoeTD7gUud+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=awf91PSu66HzeqRCF3MmdgZ5RS13MHX5pypKLoz+9lZyiSCxSMQmTu8wkHXcLA3mtpWZZCkknk1M/WDL9HWvUo1QJ7WBWQlk9bPRTF/hvkBY4XIrpnJTGxVUyIyhBXhL0pRYtqUsIc2p+PENpQ6WzsmNgpcbDrTD8MBn8cosPfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KRF6Zm7K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722569411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uYs07gX+68Fkga6CWEyd0P9TjFrALens7Dug0RaQ20I=;
	b=KRF6Zm7KQ8WIST7QpFC0lt2DTcOcZKftBdbJK0UAUrgbPiPfqfxKW/qzytmUBXoPT1Ab4l
	lzwZbN6bCi26czYx2aCvyVbA1ilriT6lyAQZClC8iebHy3IF2ZYMV2mHg0AJQJAW50iXSZ
	RnmyP9FCcOS7ZLqEBg+YdEYWJ9jEqNo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-c1Cu_QciMDyhWvw2eQ3TVg-1; Thu, 01 Aug 2024 23:30:08 -0400
X-MC-Unique: c1Cu_QciMDyhWvw2eQ3TVg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2cfe41af75eso2433694a91.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 20:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722569406; x=1723174206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYs07gX+68Fkga6CWEyd0P9TjFrALens7Dug0RaQ20I=;
        b=nQ1cCTTP04Sa2Dy9J1ZhxxWS6trPYP3ty0bHZ3mz9jy6IYss5Oq5Ua5CJy5sjM+Vng
         Yxl5jitsCWjCwSGk3KztykKxscsrjFzdPIoEVh0M1AIAlwV8FqPKTU3XaJZhn1sCZ5Xa
         q+/v62kTD1JKbKcdkc/t1rS1xHi0YYVmf9DLsNS2bBB+7882NWF0NaYSTdh8KyD3GVlA
         eKlB9H7Klb0cA+lnbO6IqTVaKQHWrsxuujR07dQ6nQ/bycQuvPzmLFCesKH9Fv+KX9rK
         YGW2u+ygGz+g2eZgm4fuIbPeZjR8GJxqAPrk1254M+4Y99V81sMk/Ynvz4sSTENlTBu+
         ZXmA==
X-Forwarded-Encrypted: i=1; AJvYcCXsk0qnFP2WuI9qO/lcI0jRmk7cwpNP9IuTOxGT0UMFQvIGjV5tk+q/mNfeE+KVQ5vuXS4OGbnjd/buGuieNvRtbUOv
X-Gm-Message-State: AOJu0YwGfKwfg7E08xf44i0OqTDvn0UPEa4CcfYMkYc0q+cpvgwlLpI+
	G1cst9+rYMPIGtd9X6NjhjaTKK7GCpC6uac2tQSs4/K7h5NDzM8NJa9JuLIM0LTptkBvzRWZWDG
	vgF/6WE014U4efK5den0EqUezyolTxtCpkF2XjQoU7sGQ/bJA8ZdSFmAUjDTneLCHCxsVmnLyoU
	eTnNFwwvCPVgzIfT4EaJfH7QeBlLjx0IMvFEY=
X-Received: by 2002:a17:90b:4a92:b0:2c9:79d3:a15d with SMTP id 98e67ed59e1d1-2cff955990fmr2790965a91.29.1722569405872;
        Thu, 01 Aug 2024 20:30:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQRQ/W2bxUZ4fmyFACsHHugct/QvZY7SyEDi/cN1+lFTUmIsWbE6ZPpM3HrIrS6ZKxQliTy3j6BqHAbqnrVdM=
X-Received: by 2002:a17:90b:4a92:b0:2c9:79d3:a15d with SMTP id
 98e67ed59e1d1-2cff955990fmr2790948a91.29.1722569405302; Thu, 01 Aug 2024
 20:30:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801153722.191797-2-dtatulea@nvidia.com>
In-Reply-To: <20240801153722.191797-2-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 2 Aug 2024 11:29:54 +0800
Message-ID: <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 11:38=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> The following workflow triggers the crash referenced below:
>
> 1) vhost_vdpa_unsetup_vq_irq() unregisters the irq bypass producer
>    but the producer->token is still valid.
> 2) vq context gets released and reassigned to another vq.

Just to make sure I understand here, which structure is referred to as
"vq context" here? I guess it's not call_ctx as it is a part of the vq
itself.

> 3) That other vq registers it's producer with the same vq context
>    pointer as token in vhost_vdpa_setup_vq_irq().

Or did you mean when a single eventfd is shared among different vqs?

> 4) The original vq tries to unregister it's producer which it has
>    already unlinked in step 1. irq_bypass_unregister_producer() will go
>    ahead and unlink the producer once again. That happens because:
>       a) The producer has a token.
>       b) An element with that token is found. But that element comes
>          from step 3.
>
> I see 3 ways to fix this:
> 1) Fix the vhost-vdpa part. What this patch does. vfio has a different
>    workflow.
> 2) Set the token to NULL directly in irq_bypass_unregister_producer()
>    after unlinking the producer. But that makes the API asymmetrical.
> 3) Make irq_bypass_unregister_producer() also compare the pointer
>    elements not just the tokens and do the unlink only on match.
>
> Any thoughts?
>
> Oops: general protection fault, probably for non-canonical address 0xdead=
000000000108: 0000 [#1] SMP
> CPU: 8 PID: 5190 Comm: qemu-system-x86 Not tainted 6.10.0-rc7+ #6
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf2=
1b5a4aeb02-prebuilt.qemu.org 04/01/2014
> RIP: 0010:irq_bypass_unregister_producer+0xa5/0xd0
> RSP: 0018:ffffc900034d7e50 EFLAGS: 00010246
> RAX: dead000000000122 RBX: ffff888353d12718 RCX: ffff88810336a000
> RDX: dead000000000100 RSI: ffffffff829243a0 RDI: 0000000000000000
> RBP: ffff888353c42000 R08: ffff888104882738 R09: ffff88810336a000
> R10: ffff888448ab2050 R11: 0000000000000000 R12: ffff888353d126a0
> R13: 0000000000000004 R14: 0000000000000055 R15: 0000000000000004
> FS:  00007f9df9403c80(0000) GS:ffff88852cc00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000562dffc6b568 CR3: 000000012efbb006 CR4: 0000000000772ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? die_addr+0x36/0x90
>  ? exc_general_protection+0x1a8/0x390
>  ? asm_exc_general_protection+0x26/0x30
>  ? irq_bypass_unregister_producer+0xa5/0xd0
>  vhost_vdpa_setup_vq_irq+0x5a/0xc0 [vhost_vdpa]
>  vhost_vdpa_unlocked_ioctl+0xdcd/0xe00 [vhost_vdpa]
>  ? vhost_vdpa_config_cb+0x30/0x30 [vhost_vdpa]
>  __x64_sys_ioctl+0x90/0xc0
>  do_syscall_64+0x4f/0x110
>  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> RIP: 0033:0x7f9df930774f
> RSP: 002b:00007ffc55013080 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000562dfe134d20 RCX: 00007f9df930774f
> RDX: 00007ffc55013200 RSI: 000000004008af21 RDI: 0000000000000011
> RBP: 00007ffc55013200 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000562dfe134360
> R13: 0000562dfe134d20 R14: 0000000000000000 R15: 00007f9df801e190
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 478cd46a49ed..d4a7a3918d86 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -226,6 +226,7 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vd=
pa *v, u16 qid)
>         struct vhost_virtqueue *vq =3D &v->vqs[qid];
>
>         irq_bypass_unregister_producer(&vq->call_ctx.producer);
> +       vq->call_ctx.producer.token =3D NULL;
>  }
>
>  static int _compat_vdpa_reset(struct vhost_vdpa *v)
> --
> 2.45.2
>

Thanks


