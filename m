Return-Path: <kvm+bounces-12956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F01E488F61F
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3565297B29
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1443339FC5;
	Thu, 28 Mar 2024 04:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7PrkXeM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5213770B
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 04:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711598593; cv=none; b=BX0+yRxxlus7CVWpK16I4nHQlvEoBVpPj3F4fUDPbxfv+VBJzpLT3Lp9zmI3+gMB31gTTbQB8vz67WvbOkmj7mhvdT6xqwTM9jo5IrZb/EaGtQ+oq0WaeFnwyGkg9DpvfSft+ZyzxYq1A0UvMGv/2mE81kHmR/0Unl5XAUUfCT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711598593; c=relaxed/simple;
	bh=MA0vU3W1LZn4Qn1ileNbbCmxahwffPLbnt6IdvVY1DQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bpLbeE4ix8b3cH7tJRwCxTFRCsFGkYeCkp5xXT4KIROnZ//aBlnU0BhU/aDUVr9YkUsyp5T5mNsKDcJa4ifVJXLfZf41Zyr7R8BJQ16NyK/iDj1/9qk0BHjz/XoFmkFaZuP0BAQv1Rkctf3OuZhcw7pxvMbhQ0bvkI/3q4Vii+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B7PrkXeM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711598590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VR9QH5sWK+/AEwJzme4Yl+zpIsFT2eAe45QtEGaUS2M=;
	b=B7PrkXeMjXYJd3sz8LJvTss3rJ3wUd+CvFohOslqWVpQJU2L1CdDtF+RS7mA8Yv8Aose1A
	36v/WfCRiqZTgAV/8HHPxKqLDhbxxNmrMkOynCML4LEWGDStfetZ1OO+FkdW3/IJ1vN8f4
	a534PWI4HyZLgzeR1RHpw6mSq1Kupks=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-J3AXaJ73PeWJEMFmC86DNg-1; Thu, 28 Mar 2024 00:03:06 -0400
X-MC-Unique: J3AXaJ73PeWJEMFmC86DNg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29df4ec4304so466984a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 21:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711598586; x=1712203386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VR9QH5sWK+/AEwJzme4Yl+zpIsFT2eAe45QtEGaUS2M=;
        b=DDL+RNfHzoTtm9RuWhah45pOuPkH+WB1LuTxca1wbjCvmv0hVFURkCVQaL2jBWhDm4
         FGCulgWfYt81L7uOHhbgcCoJY5Jo7tzI7kt/nZETkLxd5LGweCkhHBAhAF+BS9Fgbzqf
         S2zUDyNlUCAGfkmDEwBdL9PdHN/sLsrcpcWgSoJNFabwKmWoOl0kBJQwhV+29t8JLBJd
         EwOkJ4ryDcQRIsVohmxPuLos+hccILF9dtdN4Px03TEK0F3n2RyNf/eTNdJizOI6fS2l
         PINl3Uh6xm2+Z15dQT7haJrsMQx3ggZqRxIFaeC1RIjyR82soyzT1V03yuDVknOzjnzc
         HayA==
X-Forwarded-Encrypted: i=1; AJvYcCVwfAOv5RZw7WIYGM6RVB3eVGC30HrJASFYDVIPmnOkwpnbg5eyk+laZsvvN2rVGFhq6ZWKCucO4zUiP6+auYwgxmeO
X-Gm-Message-State: AOJu0Yyw+i2GFPFiYN7rajyvzpylSG3t0IF8wIfnAOk5Xze4BGRLPeeq
	qC54OJ+A9E2f3me1ibp15I+NsJ3YL0wFhIgQ/BfTJMMYerFm7UQENLeSW5jtG1osXZYnDEmWTC9
	rmZ9bTdbFab5L8duvZSpW2UitgCuftFiEgI7HCiN04OEwh5ueAIhNv3jc2T6zM2jeD7ijJjOKT/
	6cKXsZPL2+vSNnCHGc7moY0XQS
X-Received: by 2002:a17:90b:14a:b0:2a0:7815:dd25 with SMTP id em10-20020a17090b014a00b002a07815dd25mr1734989pjb.20.1711598585814;
        Wed, 27 Mar 2024 21:03:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/veJ62gWCxJH+rJXD0BAZFk49zg7RYhlAQmbs4vW7XEiQGECvkaoiOerml1BopvTt9smdmlPuOr7dLI1u01k=
X-Received: by 2002:a17:90b:14a:b0:2a0:7815:dd25 with SMTP id
 em10-20020a17090b014a00b002a07815dd25mr1734975pjb.20.1711598585557; Wed, 27
 Mar 2024 21:03:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327231826.1725488-1-andrew@daynix.com>
In-Reply-To: <20240327231826.1725488-1-andrew@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 28 Mar 2024 12:02:54 +0800
Message-ID: <CACGkMEuW8jLvje0_oqCT=-ih9JEgxOrWRsvjvfwQXw=OWT_RtQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] vhost: Added pad cleanup if vnet_hdr is not present.
To: Andrew Melnychenko <andrew@daynix.com>
Cc: mst@redhat.com, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	yuri.benditovich@daynix.com, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 7:44=E2=80=AFAM Andrew Melnychenko <andrew@daynix.c=
om> wrote:
>
> When the Qemu launched with vhost but without tap vnet_hdr,
> vhost tries to copy vnet_hdr from socket iter with size 0
> to the page that may contain some trash.
> That trash can be interpreted as unpredictable values for
> vnet_hdr.
> That leads to dropping some packets and in some cases to
> stalling vhost routine when the vhost_net tries to process
> packets and fails in a loop.
>
> Qemu options:
>   -netdev tap,vhost=3Don,vnet_hdr=3Doff,...
>
> From security point of view, wrong values on field used later
> tap's tap_get_user_xdp() and will affect skb gso and options.
> Later the header(and data in headroom) should not be used by the stack.
> Using custom socket as a backend to vhost_net can reveal some data
> in the vnet_hdr, although it would require kernel access to implement.
>
> The issue happens because the value of sock_len in virtqueue is 0.
> That value is set at vhost_net_set_features() with
> VHOST_NET_F_VIRTIO_NET_HDR, also it's set to zero at device open()
> and reset() routine.
> So, currently, to trigger the issue, we need to set up qemu with
> vhost=3Don,vnet_hdr=3Doff, or do not configure vhost in the custom progra=
m.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>

Acked-by: Jason Wang <jasowang@redhat.com>

It seems it has been merged by Michael.

Thanks

> ---
>  drivers/vhost/net.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index f2ed7167c848..57411ac2d08b 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -735,6 +735,9 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
>         hdr =3D buf;
>         gso =3D &hdr->gso;
>
> +       if (!sock_hlen)
> +               memset(buf, 0, pad);
> +
>         if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
>             vhost16_to_cpu(vq, gso->csum_start) +
>             vhost16_to_cpu(vq, gso->csum_offset) + 2 >
> --
> 2.43.0
>


