Return-Path: <kvm+bounces-38027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B396A343E5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 15:58:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC2C53A7BF5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 14:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853ED245034;
	Thu, 13 Feb 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TNNv4Imk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D918923F403
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458043; cv=none; b=TQY42didQNPtF3GfrJkExz36Wi8SL7AeXeimHaIYvlR2BqiYAUJt4NwMTCqXjDvxIXee8h0vp0TlCXGqhv6LSXKdVrWG7Vb/RivJCqWEUeeXBj9kHAdYFa5lPk0TIE7/LAUsSbTNFE2yuUK2IZtbzic6OTtCfZCSZd752Zzzsr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458043; c=relaxed/simple;
	bh=tPhyVVJDg+eB9kkF+HosG3iztKpJSHNf3iCVuHVuR0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cl0m+f5AkyNz9m765nxNPlq2EyU1eEU1S8t1QYq9iDcY5kmMqzgYGl4N6sGqvFaceW+zUrS16OJHYNEeqi62XmdNeX6+qtLuRcS+PlXahckywCCD1xoyGaFflXx/1N4Zj7vL/pSUbbl1UQD0Vmykaaw8eSCSImcg1MYyHHdqOSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TNNv4Imk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739458040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAKfOutKaK2ALg6/h1nMfRqlupNtDP/2Xy+rsmNojjc=;
	b=TNNv4Imk8497K+yOnhAEaegy/3l5KkC+xYfBc2h5RngpdFpEnKyyBGPx7Jhp38IKk5SV07
	ie2ilDLuQ6zzKkgMtJHPlSKxh2NAnlqiUmML3doDjXbX3CfmxFq6If0IyaEitZFVp/IgvB
	N8aE50Ci2N29FC3m0FNLFGqCGGcjExU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-ImVPxp1XOz25DocLGTgQzA-1; Thu, 13 Feb 2025 09:47:19 -0500
X-MC-Unique: ImVPxp1XOz25DocLGTgQzA-1
X-Mimecast-MFC-AGG-ID: ImVPxp1XOz25DocLGTgQzA
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-6f2793679ebso14365177b3.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 06:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739458038; x=1740062838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZAKfOutKaK2ALg6/h1nMfRqlupNtDP/2Xy+rsmNojjc=;
        b=SAlqWNFgYo1XVnGPygZAAaN7P1kGvyLF7JdqC2Z59Rbs8qJ6RNSwvgD+COenxKCF5Y
         R9/Aej9pvdtVaVd426VyRCnEj7bzbI/P+a37wHqQdbEVevWAINjp198nST5GkoyNAzLL
         SoYJvi69NWDdNspo3TF0/GQkPiLUo2E/IcgznK/KpdJqLMjmZ7nhs5N1B05RzqHmQUSm
         foYbs36J/Dme+p6WsohNvm16w3IDaFR+HWyekDYClUjaPuxodrb5tLdKxPHTdKuVSh3Q
         hNtD9yyf6yCHNeHphhliHbAkvSpDbAIvhNMLEhcTiFMduh9NdXvBVzJygXZ7Y8k99o5R
         EGrw==
X-Forwarded-Encrypted: i=1; AJvYcCXrc80Xai0OArapXfDzqUeo2zS6SqpVPjzQ73l1P2GXvP4TvWhE3aDHAROuvtVNU4GN/nA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwySYVhVnbe6vNKeOEX5sjO9tjQ7ajuTBA0Asqd705DVXMvMih3
	Al89ELOWTITzZeM3WUCwbgnnkVOb1OBXiKgpRaRfgdPdV0Q51+FT4k3/dYWWRunQ7lrGa5jK/J+
	EZhhUgsrnFGiumOMpiqHfCd4fQGj/ZuGyWBqSvuj+M4ztUT8XsieHJS7KQNUQHhHJSwy8bbJQzd
	dFzbOXDcJdqhwbwqKD07686uSs
X-Gm-Gg: ASbGncu31pLLQ/hW8po4f3A7SPKGvadRrKCBNJTt7g1DHk/DxRgfiU6EByt7wpP+IKb
	ZGF7aTJk0YoCITkFTHDfgtYnqlhhPvUrTr1zQTAfmwvuT+XVkntuT7ZdNaDaI
X-Received: by 2002:a05:690c:690e:b0:6f7:406e:48d with SMTP id 00721157ae682-6fb1f29bcfdmr76979627b3.35.1739458038740;
        Thu, 13 Feb 2025 06:47:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEeHYNZFDgV2vgtp07+EXLG6diJ0WLxws7MaPqF2P91HH13rbU2aou20GjoSl6bzof2WHxUqurRf5pGgUAIn4=
X-Received: by 2002:a05:690c:690e:b0:6f7:406e:48d with SMTP id
 00721157ae682-6fb1f29bcfdmr76979187b3.35.1739458038365; Thu, 13 Feb 2025
 06:47:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <gr5rqfwb4qgc23dadpfwe74jvsq37udpeqwhpokhnvvin6biv2@6v5npbxf6kbn>
 <CGME20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8@epcas5p2.samsung.com>
 <20250213012805.2379064-1-junnan01.wu@samsung.com> <4n2lobgp2wb7v5vywbkuxwyd5cxldd2g4lxb6ox3qomphra2gd@zhrnboczbrbw>
In-Reply-To: <4n2lobgp2wb7v5vywbkuxwyd5cxldd2g4lxb6ox3qomphra2gd@zhrnboczbrbw>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 13 Feb 2025 15:47:07 +0100
X-Gm-Features: AWEUYZk5_r-tBhZvoaLYlDqhO9_sUVYkjzi-JYbjI9o8ZFZY67uC4S7eLbX9jnQ
Message-ID: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
Subject: Re: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	lei19.wang@samsung.com, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, q1.huang@samsung.com, 
	stefanha@redhat.com, virtualization@lists.linux.dev, 
	xuanzhuo@linux.alibaba.com, ying01.gao@samsung.com, ying123.xu@samsung.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Feb 2025 at 10:25, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Thu, Feb 13, 2025 at 09:28:05AM +0800, Junnan Wu wrote:
> >>You need to update the title now that you're moving also queued_replies.
> >>
> >
> >Well, I will update the title in V3 version.
> >
> >>On Tue, Feb 11, 2025 at 03:19:21PM +0800, Junnan Wu wrote:
> >>>When executing suspend to ram twice in a row,
> >>>the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
> >>>Then after virtqueue_get_buf and `rx_buf_nr` decreased
> >>>in function virtio_transport_rx_work,
> >>>the condition to fill rx buffer
> >>>(rx_buf_nr < rx_buf_max_nr / 2) will never be met.
> >>>
> >>>It is because that `rx_buf_nr` and `rx_buf_max_nr`
> >>>are initialized only in virtio_vsock_probe(),
> >>>but they should be reset whenever virtqueues are recreated,
> >>>like after a suspend/resume.
> >>>
> >>>Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
> >>>virtio_vsock_vqs_init(), so we are sure that they are properly
> >>>initialized, every time we initialize the virtqueues, either when we
> >>>load the driver or after a suspend/resume.
> >>>At the same time, also move `queued_replies`.
> >>
> >>Why?
> >>
> >>As I mentioned the commit description should explain why the changes are
> >>being made for both reviewers and future references to this patch.
> >>
> >
> >After your kindly remind, I have double checked all locations where `queued_replies`
> >used, and we think for order to prevent erroneous atomic load operations
> >on the `queued_replies` in the virtio_transport_send_pkt_work() function
> >which may disrupt the scheduling of vsock->rx_work
> >when transmitting reply-required socket packets,
> >this atomic variable must undergo synchronized initialization
> >alongside the preceding two variables after a suspend/resume.
>
> Yes, that was my concern!
>
> >
> >If we reach agreement on it, I will add this description in V3 version.
>
> Yes, please, I just wanted to point out that we need to add an
> explanation in the commit description.
>
> And in the title, in this case though listing all the variables would
> get too long, so you can do something like that:
>
>      vsock/virtio: fix variables initialization during resuming

I forgot to mention that IMHO it's better to split this series.
This first patch (this one) seems ready, without controversy, and it's
a real fix, so for me v3 should be a version ready to be merged.

While the other patch is more controversial and especially not a fix
but more of a new feature, so I don't think it makes sense to continue
to have these two patches in a single series.

Thanks,
Stefano


