Return-Path: <kvm+bounces-40542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D81A58B05
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685773A933F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D251C1F13;
	Mon, 10 Mar 2025 04:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqFPCmp6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D79199FBA
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741579278; cv=none; b=uHD6tPjs+DW9nsNf8Qv0r2tqRT8grXeOzSJ5pGH53p9xAc9a6u04DAFft3iBnt5pWIsMDP3Wyuieid/b9yAAlCmeVvRYdqWFbBAMrkgK1yrAoxrsIePqT/bNQAY1lpN9Ov/Kvx0It8c6US6KJ1cM/z9DOlxVRl4BCijjXw7Cors=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741579278; c=relaxed/simple;
	bh=y2jgmxgCkCS0866p0uhw4Z/wKL7ZAlvCJDAr0KB4Wp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nNw5y96uKBeqzTBg5f7SSK6waCqqMINWSfJtt/BDdabQVcHsSjD9YCyATrxvMMTG9JN7dWtIZZ9RvP5V2ySyIu49BSLoMrQaH5nov1GKxCRYFTL2xuYf09xzfhmIlVPEblO2j99/jCMLhHsiwWSmGPS1yG8HT/ofiALIcAAHSLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TqFPCmp6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741579274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baDSD60KKAXA2YV4cwTHazyMng6zqZ9j6/BH6ENwQIo=;
	b=TqFPCmp6FldnTqNHM9ffUXFPQbuMHMY+8uF5yS4iUpfs1qGhIFxWR2DWxPevrGMRgjWfuy
	fW9doVJlPPFzhPvMq/3s14KwPYPw4x//GlcMa6sIPw8rQvlT0B8r2I5IdMQZ5i+i5yN4uO
	gDt5RGpKIqfwCQId4tnYJfed5FyuRrc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-jU-WkZcKOCGmi51sEEqXbg-1; Mon, 10 Mar 2025 00:01:13 -0400
X-MC-Unique: jU-WkZcKOCGmi51sEEqXbg-1
X-Mimecast-MFC-AGG-ID: jU-WkZcKOCGmi51sEEqXbg_1741579272
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2ff5296726fso11475653a91.0
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741579271; x=1742184071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=baDSD60KKAXA2YV4cwTHazyMng6zqZ9j6/BH6ENwQIo=;
        b=MOEpIqFz0Hy17ItGAmsQUoHalr6jPzYu3YJgLUBRmi/S0NOqtsF4FIoV/rDGfDWUpw
         iAR9wTS60OQ0P9tj/cv8RkJpT4E0hY8s4+JgIZ0MHDVHNdSl/nYf34n0xxOwlskDJo9q
         +fsl3jWq+n0Ccfxa4XRCWvFmTAortgR32vGlvF9Ve9+QjwSRvhDmFGg6/J+nHCvajzeG
         1A837SMB451ERVILL2tllTrpioq7fFMODKILhW/D/EKQOc1gbPA3PpyowrKVINd0q62+
         b4PhZTzpc3RfXWeyazX8CidCCnUJJOY1YMXnsiru0V2O9q/1/8ze3VlCml7fgVWk/Z/q
         I5iw==
X-Forwarded-Encrypted: i=1; AJvYcCUxsQElEVicXs2YEWdwDyq44bVByVsIas3q1k4Ibe5svwxfiE2GyEjDc16HdayRg1qSKow=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvrdGPlXou5qF0YrzsduaIUsZv5LqXBScOoDoezFJJ54kXGsWH
	z5twhYcZ0Tk/bpueBubNJwI9mECU9tLEvzjulVYXl58/IRAgRS63RdSj0V6Cvm4QQ1PDqIFHsju
	7HGGtaOdDsOErkOESuQ8PYwMeXATcvCxIWtTsT139YW1VokdCjULfgRFO6A0PcaBpbX5vbz8kqX
	m4YonObxqGwz3aOLVUEgq2NJuAiWdNsAePuoNVMVBx
X-Gm-Gg: ASbGnctzcCKAqq8XZ7ANkQcf2segaEpdtoIaZmVEPpStBXNAmd64eOFfuBY66wWLt6F
	0vJx3dkV1BpplT9LCHYF+lV1zUUK/+e+YKQvSmquDhPuJEfF+f2IynNlzmQR3and5MEy8MxQSJg
	==
X-Received: by 2002:a17:90b:1b0b:b0:2fc:c262:ef4b with SMTP id 98e67ed59e1d1-2ff7cea9a99mr22401425a91.18.1741579271540;
        Sun, 09 Mar 2025 21:01:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9DOsUxA9Z0UU+zFKp4XwB12kvLD6PT8eYjbCh1DLy1GK1oX1uE/LbhxDyNJ0rRDiXuxTT1vCPASJg6+fMr/4=
X-Received: by 2002:a17:90b:1b0b:b0:2fc:c262:ef4b with SMTP id
 98e67ed59e1d1-2ff7cea9a99mr22401364a91.18.1741579271097; Sun, 09 Mar 2025
 21:01:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307-rss-v9-0-df76624025eb@daynix.com> <20250307-rss-v9-3-df76624025eb@daynix.com>
 <CACGkMEsNHba=PY5UQoH1zdGQRiHC8FugMG1nkXqOj1TBdOQrww@mail.gmail.com>
In-Reply-To: <CACGkMEsNHba=PY5UQoH1zdGQRiHC8FugMG1nkXqOj1TBdOQrww@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 10 Mar 2025 12:01:00 +0800
X-Gm-Features: AQ5f1JpaV-Y2lOTdTlLng-Bakedv0t_hz074LEAN3YdWqqKw7pRKMp2RrCa8b3E
Message-ID: <CACGkMEtCEwSB7XvCg7_8ebkcM8o2s8JB2Err2f153L-_i2KtxA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 3/6] tun: Introduce virtio-net hash feature
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 11:55=E2=80=AFAM Jason Wang <jasowang@redhat.com> w=
rote:
>
> On Fri, Mar 7, 2025 at 7:01=E2=80=AFPM Akihiko Odaki <akihiko.odaki@dayni=
x.com> wrote:
> >
> > Hash reporting
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Allow the guest to reuse the hash value to make receive steering
> > consistent between the host and guest, and to save hash computation.
> >
> > RSS
> > =3D=3D=3D
> >
> > RSS is a receive steering algorithm that can be negotiated to use with
> > virtio_net. Conventionally the hash calculation was done by the VMM.
> > However, computing the hash after the queue was chosen defeats the
> > purpose of RSS.
> >
> > Another approach is to use eBPF steering program. This approach has
> > another downside: it cannot report the calculated hash due to the
> > restrictive nature of eBPF steering program.
> >
> > Introduce the code to perform RSS to the kernel in order to overcome
> > thse challenges. An alternative solution is to extend the eBPF steering
> > program so that it will be able to report to the userspace, but I didn'=
t
> > opt for it because extending the current mechanism of eBPF steering
> > program as is because it relies on legacy context rewriting, and
> > introducing kfunc-based eBPF will result in non-UAPI dependency while
> > the other relevant virtualization APIs such as KVM and vhost_net are
> > UAPIs.
> >
> > Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > Tested-by: Lei Yang <leiyang@redhat.com>
> > ---
> >  Documentation/networking/tuntap.rst |   7 ++
> >  drivers/net/Kconfig                 |   1 +
> >  drivers/net/tap.c                   |  68 ++++++++++++++-
> >  drivers/net/tun.c                   |  98 +++++++++++++++++-----
> >  drivers/net/tun_vnet.h              | 159 ++++++++++++++++++++++++++++=
++++++--
> >  include/linux/if_tap.h              |   2 +
> >  include/linux/skbuff.h              |   3 +
> >  include/uapi/linux/if_tun.h         |  75 +++++++++++++++++
> >  net/core/skbuff.c                   |   4 +
> >  9 files changed, 386 insertions(+), 31 deletions(-)

[...]

> > + *
> > + * The %TUN_VNET_HASH_REPORT flag set with this ioctl will be effectiv=
e only
> > + * after calling the %TUNSETVNETHDRSZ ioctl with a number greater than=
 or equal
> > + * to the size of &struct virtio_net_hdr_v1_hash.
>
> So you had a dependency check already for vnet hdr len. I'd still
> suggest to split this into rss and hash as they are separated
> features. Then we can use separate data structure for them instead of
> a container struct.
>

Besides this, I think we still need to add new bits to TUNGETIFF to
let userspace know about the new ability.

Thanks


