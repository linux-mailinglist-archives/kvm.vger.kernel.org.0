Return-Path: <kvm+bounces-67401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C0BBD03BE4
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 16:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98BAE312F981
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30382274B55;
	Thu,  8 Jan 2026 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cEGkcdDU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQQ6ujfu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC4C200110
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767883536; cv=none; b=j2uxKlWaNVCf8+DUSD1mI45EWgzoT8PkKjmXEqVNwCSo3qH7mvwXeDvIZ6aDyVaFGu1LCAFddKOnbXxJ9pyed8qDtVOfQo7hoWqKrfmAHUil1ygr74WUqDGPLHDXdbgJZSY5WKMHxJ1yTciBC1B2uQZna4QwLrkscnTUcgV+aJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767883536; c=relaxed/simple;
	bh=ScTKP+c2rR672BgupG9wm67XF9gVvJQXcIgn+/1V/bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQKqby6BHi/V9alueVyLh9q0xnOHhxG2IrODI1gy/AuZ1e2B0R/hqGBjHeOwb1bjmLMhAZVIw+Wd/olThEBNRvyUsgzjYJMaQb+nLMim1dqm0dS5/lYZvrInFQGXr7cgVWGvXLQFIdD2iyB2GIw/bDapE2Lr5p+YanGhkg6wXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cEGkcdDU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQQ6ujfu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767883533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WfT1Va6tq1fm9ghByqfjKPhOxaDhZdEa8+dMcUknkTw=;
	b=cEGkcdDUtwCQAciuSSLPqYzZQLxzlTFaGDIdEP0X8UFn5G8Y/D6hxjUZg6yiUflE7EN2k4
	J2U1U795kp1zBtn1Tn6S8CWBMwNd3tkOmU7bmO8HpD+flpM/BpJphL2Hil55M32c8aQq2e
	Amn28rycEmRtPiKgq24J22/GVIogvmI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-syswMJlPO1qqLf_WxVE-3A-1; Thu, 08 Jan 2026 09:45:31 -0500
X-MC-Unique: syswMJlPO1qqLf_WxVE-3A-1
X-Mimecast-MFC-AGG-ID: syswMJlPO1qqLf_WxVE-3A_1767883531
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7d282ac8aaso477515366b.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767883530; x=1768488330; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WfT1Va6tq1fm9ghByqfjKPhOxaDhZdEa8+dMcUknkTw=;
        b=gQQ6ujfuJzml/KBLnIXj54BCYc2nxgPB9t6/LuLljS1IStToOxMznbLUwwhwhude1h
         LajIcqp998QUdwdsmhb/KJumfrf3fXJjcJmMb3DBzxNEJb4GMI0/oU0SAdU6OPukTRCG
         57y21KggPCE37un7p2LPQlbGx/Ls1HMBrivsc3J48sCUGcl1c2BwYRp2xFw47Swya7/H
         kf3UQnb8AM2jqE/Ab4ApPIRojNXxeWq844Hde4dt+QyqwwW+QNHNGgMCLTHakCDo/qcc
         YbBQ9lVJq3s7930WfljUVMOt+BSdMWh4G0xXChs6jn2Nj65FMbNI2Ca5jv83uCN6TN7t
         LuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767883530; x=1768488330;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WfT1Va6tq1fm9ghByqfjKPhOxaDhZdEa8+dMcUknkTw=;
        b=ZktI4e49IArevA4Fce8snZbEyf7wb09+xyP9RNVcREoU9GXiLytMdOexC411Qja6Kf
         bCH4nsnjA47OaxJmrv8wDHsaX/YHmg+Vz1XYXgF6PeUe2M/EgM1DAbnI2QklfSQc7UD9
         poqo3jozC4lAOf00LihSh/od94bWqvvw+V340V2fnAyViptjj3zDbVBVEC6WBd3S2tQH
         s30MCoWe5eU/iMN8JejrIe/yQaCSyEqqc2YEaMvNeA/QDammZBVGfS0eIsMoXcsP0eNU
         4FoFHq16ZcQGEhtUZOA+HIQ0isI2q13USo8iCKv+EYapI3K7BTVEpS+/CVnal6HxOwHd
         lPLA==
X-Forwarded-Encrypted: i=1; AJvYcCWz5jW31uBtlDL8K7zUbwWRK21WB6DULqFtjigFtVEZaEkIjsoTAfsNCUptmLj2D7MfIfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaT8GFalT9tjFxXncfJxuxIO4HpoexBGL12WEIgU/X63Y1HXpo
	4jN1MFsJz9z8GI4SBXP8ZASx32imoJO6MNk7iX2qv+jHDPf7iPlVYWJqCdgDCwhsy2XeOtkoCYo
	EtXlRXXIP7vZzm12ESSQr+IWu8xzKMVfGqPjsr1bBM86kikpUVddaAA==
X-Gm-Gg: AY/fxX7LYFQT6yIO+II/18KOrNsUqQi1tkpKXwW9qyL2czpwQeMmVLxaEsufPV6+ZKh
	7bUfyj64Mayx+xGrbqEFIP2TwUZOlLadfo0hnpMv/WBnzLzB3g8yB7hNKKzi6kQryDxFbQEVZJn
	ro+chB4f3p1uIzOQybyq0iZv9oxOjO1q80OmcJN5bNHVUv82eN8H/fRs6LvY5D2/CjhRpdEsL5+
	ftoq9ytSw0InsrKvNhpzjiznJ80JkDHfRC2nWzLrj7+njk+kJ1NZMLxi7H0cTVIIiu+nz6GoLAH
	rf8pD8En7DwOf0eME0FFx1ef3srasxwDc01Giuil3wjkFK3yFIBbdpbu6FE07kbITWxQ6rPb0A7
	Z/FZFAM2ad6/f0gjr
X-Received: by 2002:a17:906:c103:b0:b79:e974:4060 with SMTP id a640c23a62f3a-b8444fd41a2mr660534366b.48.1767883530420;
        Thu, 08 Jan 2026 06:45:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEy4t9xkgOZMs7kPUcCm9yBAey59kExadAcY+9phGlSdjSpATKGUSBjtzXbWCkzKn2HKwCwkQ==
X-Received: by 2002:a17:906:c103:b0:b79:e974:4060 with SMTP id a640c23a62f3a-b8444fd41a2mr660529166b.48.1767883529753;
        Thu, 08 Jan 2026 06:45:29 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a564255sm848076466b.63.2026.01.08.06.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:45:28 -0800 (PST)
Date: Thu, 8 Jan 2026 15:45:20 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <aV_Cr_f47qqc2JoP@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
 <aV-6gniRnZlNvkwc@sgarzare-redhat>
 <20260108091514-mutt-send-email-mst@kernel.org>
 <aV-9F42fMfKGP4Rg@sgarzare-redhat>
 <20260108092931-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260108092931-mutt-send-email-mst@kernel.org>

On Thu, Jan 08, 2026 at 09:32:23AM -0500, Michael S. Tsirkin wrote:
>On Thu, Jan 08, 2026 at 03:27:04PM +0100, Stefano Garzarella wrote:
>> On Thu, Jan 08, 2026 at 09:17:49AM -0500, Michael S. Tsirkin wrote:
>> > On Thu, Jan 08, 2026 at 03:11:36PM +0100, Stefano Garzarella wrote:
>> > > On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
>> > > > Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>> > > > last. This eliminates the padding from aligning the struct size on
>> > > > ARCH_DMA_MINALIGN.
>> > > >
>> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > > > ---
>> > > > net/vmw_vsock/virtio_transport.c | 8 +++++---
>> > > > 1 file changed, 5 insertions(+), 3 deletions(-)
>> > > >
>> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > > > index ef983c36cb66..964d25e11858 100644
>> > > > --- a/net/vmw_vsock/virtio_transport.c
>> > > > +++ b/net/vmw_vsock/virtio_transport.c
>> > > > @@ -60,9 +60,7 @@ struct virtio_vsock {
>> > > > 	 */
>> > > > 	struct mutex event_lock;
>> > > > 	bool event_run;
>> > > > -	__dma_from_device_group_begin();
>> > > > -	struct virtio_vsock_event event_list[8];
>> > > > -	__dma_from_device_group_end();
>> > > > +
>> > > > 	u32 guest_cid;
>> > > > 	bool seqpacket_allow;
>> > > >
>> > > > @@ -76,6 +74,10 @@ struct virtio_vsock {
>> > > > 	 */
>> > > > 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
>> > > > 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>> > > > +
>> > >
>> > > IIUC we would like to have these fields always on the bottom of this struct,
>> > > so would be better to add a comment here to make sure we will not add other
>> > > fields in the future after this?
>> >
>> > not necessarily - you can add fields after, too - it's just that
>> > __dma_from_device_group_begin already adds a bunch of padding, so adding
>> > fields in this padding is cheaper.
>> >
>>
>> Okay, I see.
>>
>> >
>> > do we really need to add comments to teach people about the art of
>> > struct packing?
>>
>> I can do it later if you prefer, I don't want to block this work, but yes,
>> I'd prefer to have a comment because otherwise I'll have to ask every time
>> to avoid, especially for new contributors xD
>
>On the one hand you are right on the other I don't want it
>duplicated each time __dma_from_device_group_begin is invoked.

yeah, I see.

>Pls come up with something you like, and we'll discuss.

sure, I'll check a bit similar cases to have some inspiration.

>
>> >
>> > > Maybe we should also add a comment about the `ev`nt_lock`
>> > > requirement we
>> > > have in the section above.
>> > >
>> > > Thanks,
>> > > Stefano
>> >
>> > hmm which requirement do you mean?
>>
>> That `event_list` must be accessed with `event_lock`.
>>
>> So maybe we can move also `event_lock` and `event_run`, so we can just move
>> that comment. I mean something like this:
>>
>>
>> @@ -74,6 +67,15 @@ struct virtio_vsock {
>>          */
>>         struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
>>         struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>> +
>> +       /* The following fields are protected by event_lock.
>> +        * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>> +        */
>> +       struct mutex event_lock;
>> +       bool event_run;
>> +       __dma_from_device_group_begin();
>> +       struct virtio_vsock_event event_list[8];
>> +       __dma_from_device_group_end();
>>  };
>>
>>  static u32 virtio_transport_get_local_cid(void)
>
>Yea this makes sense.

Thanks for that!
Stefano


