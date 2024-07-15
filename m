Return-Path: <kvm+bounces-21655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 441C09319B8
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 19:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74F9E1C21D11
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301965589A;
	Mon, 15 Jul 2024 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMZaXl0d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F74364D6;
	Mon, 15 Jul 2024 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721065314; cv=none; b=YmlXDbNjZodKXWqrMS6/r6xkPg0shopPBlkVwNGH0OsL8lll/YfwJjeiabbKrdGbK++7YcbefaHexS89DI5d/iEA2Y2AlKi0TbnPPxSBmSppXg3wABK5a70b7S9wiDJYnYurJQlb8VzOl9X8d28PL3IVK+Ni/FCS8vae6NZVQmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721065314; c=relaxed/simple;
	bh=b42JSvuywZe+7wglo+K7VO6xLJINq/9FZ8Q+hh/Syfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rLB8xHymDizbyBYx8lqxKrLMECvDwMnzEaQvl2T6WEYiRx0fG7b9ZcSyfgQEvuF7FzEfvCxAT6Pc7CZE2OwBddulgjTLb2HdmLAqnRtjE0++Bm9sYd+2p4iUzGBD/TW8PX2ioZtx6TMzO2Glc7tEuiI30twU/bs74BJqoJ/GQhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YMZaXl0d; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e04196b7603so4633048276.0;
        Mon, 15 Jul 2024 10:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721065311; x=1721670111; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xEV5pedtY2Y2FeTPODdvM+/ZX+4nHrD94jMR2RlwhT4=;
        b=YMZaXl0dP4AHdLxHhS8hluEiCfkZ/a9t9Zw6eN6kNG4YoMz/njoeJW6X6jau9yGeFj
         ypjOOMS2OixEIFNUqqYeFFxd52KntJWDfoBSJFg7ii+6Ts9jgUo9O1guIVGvU2sT+3dD
         jrsMwuKDdY90BowjBlltmx/CBFi3uxr76VF8RjKt7GJ1y94NCfArnv65awV27ZstDrgE
         qfb4vF4EfeU9xu0xRpCXacSevydh7SzQn/1N82qMRROJPQVyZPUEhOskXpn3LyedMJ6d
         /wxnd8/tiJYoLKnIGgMhy/3rWYeR1U8HxSuDlBYvRbE9JNA1NbbpHiomLSPVRJz0KAbt
         ImFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721065311; x=1721670111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xEV5pedtY2Y2FeTPODdvM+/ZX+4nHrD94jMR2RlwhT4=;
        b=MPach5nFH8Ra8LlXSiafe/FHydsHLOSmBNAfaLcoavHWB6Ev+U8bTX+0Z8trE+Wcdu
         dQ7Iceak0idJkX6YqX2rvYsP5Mh1Ae1pRbN+EkkEawFYBcVYSWgbdcQSXt4vnIdPDpTe
         dgT6/gLKUFm+3rm1lj1Oprk77B0G9lahN65mCK0Scw7zptizd0ADKxq6Ev/ga2v3QK3a
         4tJK6Rz9UIhstwaXu5ASMWV6Ii6Bnly7p7EwkKkSRkTINQigriNQKQZqn+/hs7Wlgqm/
         PlDyJq/twzWVmE7IJDvVkZjyn7SFco6SyLqy4ErsuqIL3ixX3k/GCEEB4OM38HEYIpG7
         a7bg==
X-Forwarded-Encrypted: i=1; AJvYcCVoh8jh6pncCfudksKsVPVD5ZaylurJ67ym19B/fUN8fsja1KG2AkScx2agseP5a6VX6rXJTMzge78CFFQSBqxdpgFPbM21QX7/6ctVar+qVcb1oqhVXrlra6kMHMidkGosxIPL+1xsFRi/qgmZ6k2NOa095j+9+hc9lXa2moOmEjy6FYIw59Vj5d/N+VvnL7H3J01bFErWXJEYQK55fNgcDnaBMwUPStrQ+qZA
X-Gm-Message-State: AOJu0YyCfVrfAfSbqAibVEnEXdg2+Cac3n7HapZcWZ+aMxmwXt4epPBj
	242saFqI5Jh7Sr2uxoA9CE9EBN/Q0l9G91Mq/RuZS2NFOKRkJXpPeosrlN1l42uSCtexhPviiaL
	a1c1kIGOwsmKmoRtudCAJpNmFJ5k=
X-Google-Smtp-Source: AGHT+IHIN6/eBpniYpqerz8db8xwfOTyovfSRjDMk7JvYfmegjzpFKzgDJtBVYAnhNHbomijkTgVUKTNkbIU54dFkr4=
X-Received: by 2002:a05:6902:702:b0:dca:c369:fac2 with SMTP id
 3f1490d57ef6-e05d3aae365mr381626276.3.1721065311277; Mon, 15 Jul 2024
 10:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710212555.1617795-4-amery.hung@bytedance.com> <85d64656-d8ff-1133-175f-b12f4913fccf@salutedevices.com>
In-Reply-To: <85d64656-d8ff-1133-175f-b12f4913fccf@salutedevices.com>
From: Amery Hung <ameryhung@gmail.com>
Date: Mon, 15 Jul 2024 10:41:40 -0700
Message-ID: <CAMB2axN5jJ_uabb-rd=wdcbX9DQYvENxQjK_7ZWhM60+5fVLKA@mail.gmail.com>
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
	amery.hung@bytedance.com, xiyou.wangcong@gmail.com, 
	kernel <kernel@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 1:25=E2=80=AFAM Arseniy Krasnov
<avkrasnov@salutedevices.com> wrote:
>
> Hi! Sorry, i was not in cc, so I'll reply in this way :)

Ope. I will copy you in the next version.

>
> +static const struct vsock_transport *
> +vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
> +{
> +       const struct vsock_transport *transport;
> +
> +       transport =3D vsock_connectible_lookup_transport(cid, flags);
> +       if (transport)
> +               return transport;
> +
> +       return transport_dgram_fallback;
> +}
> +
> ^^^
>
> I guess this must be under EXPORT_SYMBOL, because it is called from
> virtio_transport_common.c, so module build fails.
>
> Thanks

Right. I will fix it by exporting vsock_dgram_lookup_transport() in patch 7=
.

Thanks!
Amery

