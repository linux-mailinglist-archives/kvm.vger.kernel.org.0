Return-Path: <kvm+bounces-67392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 483DAD035E7
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5C26B3007916
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4365F37F8BD;
	Thu,  8 Jan 2026 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LR/nXuzw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g7sjFu/e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340823EA8C
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881880; cv=none; b=XkflUOd2Nhcboj+bsqdpR593pTidals5RD0wg+nlM1Dgw2lMjEbiKmWfE7HF+HR/keNj6U6y8aUc3KH9uCnPRsDbyR1M3LEplx9fedtDZOnWbBWVAX9+l4VvJDUuCvHvqef28AsDpBVq9jOH/f+yzuq24D33pExzEN2vBOVKj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881880; c=relaxed/simple;
	bh=OyIQ4x46NnhuAF46QiC0P1xvTdYkXW0VaN1yOEbVEDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=POfTDjyLnbJYvypyuoR3gK6QFP1XQgjTaMV6lZUZm+alB4oYy/LUldP/yqduDjnAtPXrdx53yn7FNDCAFtx6h7WXappZeIXKhbJG1CI6N9kdfVsxPrgMOoDpOuFoFvsF9cS4j61xvYAhLbvBujs9q4X7Wi7+iIHM/6EB4CSoXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LR/nXuzw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g7sjFu/e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fJ1lT1EolLhB5JifwSURg3jL1WOY3ilSvQ0LTyMqODM=;
	b=LR/nXuzwop/FXzYCptdu4OOiq9sC3521JW2+LXEkxN/lUr5IwaNlZD/6UimSJt1m6gxeBD
	lB7QbyX2z8bVdRHRJv6oOFIszLGwLh6VqbO40t9znAg9vBzizZv6dWGSifYoud15A6ovfH
	ZAqlftreaEAyOM95ouDMq2ilQkrIhak=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-rNwMlGvdN7qzEkx9QhNRug-1; Thu, 08 Jan 2026 09:17:55 -0500
X-MC-Unique: rNwMlGvdN7qzEkx9QhNRug-1
X-Mimecast-MFC-AGG-ID: rNwMlGvdN7qzEkx9QhNRug_1767881875
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43009df5ab3so2102161f8f.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881874; x=1768486674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ1lT1EolLhB5JifwSURg3jL1WOY3ilSvQ0LTyMqODM=;
        b=g7sjFu/eqYd8CduJmJi5LBL/NthqffZdBfVYNP9sT9LiRma1mmPz+uA55dl8r3o+P2
         9aBN8RtpmX+EPt+OSU70NItWuFCpzVP9lTzO0S3kjaEAW0RFCE4C7CO2Ltl1cdLuMs3p
         W8sWdOuDHqIBIt0/cnPwvqgIdzHzd87cOZFurOKy2x8JxaKVsuYFUzU7ZK+2zl8wtf9T
         Tb7WN5/aoUOwSPnXG3rg8+yL4DHPmPSzDFUEmdDn5I8bj2p8nMFEBa2BpHH2YHRdGGOh
         Et33RI16Zoj2qaq8Cp0r6TJxLtyzonv2QFxTt5Bsh4ILImaEXYrqpadVDKj6B2lb4ABZ
         4AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881874; x=1768486674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fJ1lT1EolLhB5JifwSURg3jL1WOY3ilSvQ0LTyMqODM=;
        b=BEwyckqtsCRCiSN8V4zgcIL9sc9l33nLW7mmFOSrsrpxhmNkssQWB6bz/0kcb1pEyj
         2RNj9ZBhSxakQ4uu9KWRxYgVCBhEPKLUxv1nai0o2XfPbQ2EID4nrxCz80YgHEz9PgjV
         BPu6viLO9ccLd1Gjk4ZVrHfcp3V3OP90cFzGAdJ+InDEdDM9DY4QjwZN/XCLzlcAbtaK
         WiYF6Ak737hjKwZBwfUTDomElhV6GqSBk3O4tlWBrqpfiIoD4v1fho1aVZmIjO7fjFcF
         rvNN4eJHXWJIOaFlwhf621tmYfLtL4aEf7ZES3jiQX7I/RtpOqTJcNihqSs34a5RNt5M
         0w6w==
X-Forwarded-Encrypted: i=1; AJvYcCXD2lK94v0nJDGqDxb9Q38068fiwQT/Vm/piPrBLKul3sGLFsPeiVb28lQsB3sEiIdZ7Gs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCEal7x5btWUpMegjdaC+O9VM5C5IyDG6Gbjb0KvAuy4qFJEaN
	ukB4b+0G/r5tlM3sbe7bw9aJf5uMBj69CnM8Vf5hO+yY8Kmwi3u5thhossKF3zDUu0PYZxQzBbf
	LItAZ8vCKViormgx2z7dz206KO5x4H943Sv663ej8C23OP+nNwgzFjQ==
X-Gm-Gg: AY/fxX4kOy3dJtj3vpY5sT8cl/0qWeC1aWlwkZyVODGU+jKu/Kx0+C/SMHgggqQgddf
	yQ3VkFFVSBR9IPCthN2u+cE4UkPHtSnV3ScmMia3wy7MptiZl+vxxbqbPm/EhikW213dYrjeE7R
	D4aI+gWOiMK2wuK7TcICFc4Ndmyq408PTd/0eKB6+h9wAnIfNE6Jmo5/DHP0DsHR4IS8ZzDQvPC
	ykzhFFKcmkQ3NoWZuAYC49pN/awDa9jgaUXj4D3Jc4okKMJqgL93PnuLnpizLNmLD+7mYVk1zlU
	zYBHPR7RB3xXiSeOa+x+rcHsDRGlhKIDuKTwI+J4ItLIt8uFahc1RDb4KBvp1YTkJR+hcRkQ2rt
	S0EWdR5oow/nL++Hs+b/QgfZCPk3/crbnJw==
X-Received: by 2002:a05:6000:2483:b0:42f:b0ab:7b48 with SMTP id ffacd0b85a97d-432c3627fbamr7468094f8f.1.1767881874573;
        Thu, 08 Jan 2026 06:17:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlUVHuOj7/HPTlOMU0+NpCVpFuCnGhMJ1KC00yBihfngclSciPQ4cpm1QXhZzj17NQ1UZXYA==
X-Received: by 2002:a05:6000:2483:b0:42f:b0ab:7b48 with SMTP id ffacd0b85a97d-432c3627fbamr7468022f8f.1.1767881873896;
        Thu, 08 Jan 2026 06:17:53 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee5eesm16735262f8f.34.2026.01.08.06.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:17:53 -0800 (PST)
Date: Thu, 8 Jan 2026 09:17:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <20260108091514-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
 <aV-6gniRnZlNvkwc@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV-6gniRnZlNvkwc@sgarzare-redhat>

On Thu, Jan 08, 2026 at 03:11:36PM +0100, Stefano Garzarella wrote:
> On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
> > Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
> > last. This eliminates the padding from aligning the struct size on
> > ARCH_DMA_MINALIGN.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > net/vmw_vsock/virtio_transport.c | 8 +++++---
> > 1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index ef983c36cb66..964d25e11858 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -60,9 +60,7 @@ struct virtio_vsock {
> > 	 */
> > 	struct mutex event_lock;
> > 	bool event_run;
> > -	__dma_from_device_group_begin();
> > -	struct virtio_vsock_event event_list[8];
> > -	__dma_from_device_group_end();
> > +
> > 	u32 guest_cid;
> > 	bool seqpacket_allow;
> > 
> > @@ -76,6 +74,10 @@ struct virtio_vsock {
> > 	 */
> > 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> > 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
> > +
> 
> IIUC we would like to have these fields always on the bottom of this struct,
> so would be better to add a comment here to make sure we will not add other
> fields in the future after this?

not necessarily - you can add fields after, too - it's just that
__dma_from_device_group_begin already adds a bunch of padding, so adding
fields in this padding is cheaper.


do we really need to add comments to teach people about the art of
struct packing?

> Maybe we should also add a comment about the `event_lock` requirement we
> have in the section above.
> 
> Thanks,
> Stefano

hmm which requirement do you mean?

> 
> > +	__dma_from_device_group_begin();
> > +	struct virtio_vsock_event event_list[8];
> > +	__dma_from_device_group_end();
> > };
> > 
> > static u32 virtio_transport_get_local_cid(void)
> > -- 
> > MST
> > 


