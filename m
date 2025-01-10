Return-Path: <kvm+bounces-34975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B2BA085E7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B401882047
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 03:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22977205AA3;
	Fri, 10 Jan 2025 03:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FGoWxuua"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42B11A8F97
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 03:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736479504; cv=none; b=Hn+jrZty6ww+CUwdzMEacALQBT64SfZD1BJ4XiA/XkU51c0ql6d3tJ1/OdHqX1UFAYWZuZUGrDXoeRuybN0dtrNnqx5kvXfI7nsHOxmfy8H9SgNY85wGqKIH3FfaSag1O5m1vcN06jLe6ncuaun0xLF08MSGDAnntQ6v5jxEmAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736479504; c=relaxed/simple;
	bh=xiIZOksV9gK8x5lTS+rlahAEFaL/qj64KXL6RVencw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vp2NS5nS+zy4RYyFrqeFMT1YNjs0jT8c0QqYEK3DPM0xMPHh0kjJVCKpPrKoa2XWfN4dazZ69WG7BPyDrKna0h8Wor7DdViTAKTkWwMAmhfRNbf4mjoz8Y//HawaFf5jx++5agh+TP3TzlMy9qYUkL0gbzs7m7PtbP7521ANo6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FGoWxuua; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736479500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ux/EFJGUhHtGiPWKsNCatUDg5uRU42FVCWFIHQvV8s8=;
	b=FGoWxuua4vh9ZGE34vxHBfMXrmAA0IqaqUQSOfBG14Fh7uMn7akli2l2u5ChCY5ZzuQiai
	o3YzTmCAGJczKmJVWDj/QvsEw8WVVAySuMG3y+UmmTVj+YEtpATcoctzDK/WfsG1GDdbiF
	EMBAkw/0kZAYfn+UfNrFcYCF29oT4Qs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-fb46xUkgME-BesvnfCHivA-1; Thu, 09 Jan 2025 22:24:58 -0500
X-MC-Unique: fb46xUkgME-BesvnfCHivA-1
X-Mimecast-MFC-AGG-ID: fb46xUkgME-BesvnfCHivA
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so4250596a91.0
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 19:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736479498; x=1737084298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ux/EFJGUhHtGiPWKsNCatUDg5uRU42FVCWFIHQvV8s8=;
        b=h3nzPMq2bWMn3wSahTQ7m79X/C9WKRuQkrvC2RexWqFU37xfTjeU6Ei9XGpsRo+Swe
         Gh1hoXr9BBYFaTUVSmEqSo8rquoag+5ORKbmBLY8ucJdgTo/13VvT7d7HQarJTcfkMfF
         CD7lBs8KALRKGf3oATuO8mWwE7986m9KwGcKVSNwDrjFp7org2YTTzDVVn6isVgZFudN
         W4YA/dQOAnJlPDaMxn2DLBA4wrohEBD59/oxVQj/li4SbWqpOWPuZlEQyk4kooobvJdx
         HeObi4TznMuNccLJO1eA4Lh3z+jPMBF81jn4HIy7MJVvf1Bu3tJTTCrtGQycNdcIqmRs
         j6WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHyTKrjay1minQmQ6RGhdp2Qim8UuTp4Jk4ycabYggYdG1yUJLvx9Sx+PXoCZStNmZQBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvoNXN8IRyMjUmcL/2eBcOh9+RQayu7bqJjHTddjxqAGKVCW8I
	6QAHMTPTm5qfnbRPNR5dLk4b8Dl15VOIKoGBfohp/vMQaeBFsHmhhJ5t5vgw9ikR1+o1q5LzXLD
	vV5XS5bEptW7rNi6N5IPaax69Cz7YLzrtdMV5yr2or03hCuduoxq38y+Tq1jXTc1D/XjcjpHb+y
	qme5OsIe4qsAZaboMi1dEiBmTr
X-Gm-Gg: ASbGnctMUmp5wsvpAbepzZAIr7AXeRZJOYBZSQdKNo74Z5ZTqMOI700+nkHGRkllIqy
	GvLIyD51o+g5T2fGGZgGDPAoE5rQl+92kTNHjKRM=
X-Received: by 2002:a17:90b:2f45:b0:2ef:2f49:7d7f with SMTP id 98e67ed59e1d1-2f548ece7afmr14119966a91.18.1736479497863;
        Thu, 09 Jan 2025 19:24:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl4su9kuwxLueN6s9pabolA/u0yv9vnPxFtYkK0ZVCk201Nafu3Va6ZCJu8GUQ/vQJh85IIDkmsOql8mxd8mA=
X-Received: by 2002:a17:90b:2f45:b0:2ef:2f49:7d7f with SMTP id
 98e67ed59e1d1-2f548ece7afmr14119944a91.18.1736479497484; Thu, 09 Jan 2025
 19:24:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com> <20250109-tun-v2-1-388d7d5a287a@daynix.com>
In-Reply-To: <20250109-tun-v2-1-388d7d5a287a@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 10 Jan 2025 11:24:45 +0800
X-Gm-Features: AbW1kvayDbWMw6YuULfNbkLhEoUv0nyH0UVx2PFd5rLWnQcrUga4t_8H0CMLDNk
Message-ID: <CACGkMEs2S=G-Y077hCeFE57ar0h1A5EaySOOTcvFZUVC0oGdXQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] tun: Unify vnet implementation
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 2:59=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix.=
com> wrote:
>
> Both tun and tap exposes the same set of virtio-net-related features.
> Unify their implementations to ease future changes.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  MAINTAINERS            |   1 +
>  drivers/net/Kconfig    |   5 ++
>  drivers/net/Makefile   |   1 +
>  drivers/net/tap.c      | 172 ++++++----------------------------------
>  drivers/net/tun.c      | 208 ++++++++-----------------------------------=
------
>  drivers/net/tun_vnet.c | 186 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/tun_vnet.h |  24 ++++++
>  7 files changed, 273 insertions(+), 324 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 910305c11e8a..1be8a452d11f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23903,6 +23903,7 @@ F:      Documentation/networking/tuntap.rst
>  F:     arch/um/os-Linux/drivers/
>  F:     drivers/net/tap.c
>  F:     drivers/net/tun.c
> +F:     drivers/net/tun_vnet.h
>
>  TURBOCHANNEL SUBSYSTEM
>  M:     "Maciej W. Rozycki" <macro@orcam.me.uk>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 1fd5acdc73c6..255c8f9f1d7c 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -395,6 +395,7 @@ config TUN
>         tristate "Universal TUN/TAP device driver support"
>         depends on INET
>         select CRC32
> +       select TUN_VNET

I don't think we need a dedicated Kconfig option here.

Btw, fixes should come first as it simplifies the backporting.

Thanks


