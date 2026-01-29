Return-Path: <kvm+bounces-69523-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EIBFK4fe2lPBgIAu9opvQ
	(envelope-from <kvm+bounces-69523-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:51:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70392ADC28
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 09:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4C7843018BAA
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 08:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCEF37C0F1;
	Thu, 29 Jan 2026 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VWMB9joG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mq5aWqvy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F6E31ED6B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676139; cv=none; b=fGn9FN/cEEEKPIL36SdGT5P4w8JbUAcrY/4Ra2wwg/D1zD1tNas7ib7sP1m8SARdT+bLeLNQ2RuKjEMYPemUoTFw82bkhT/4oCTIBfKMv2RhoUImjnbRF/MJMtv2G8RRNOQ8Dn6fkmAi51inWZSDnR9w/8qhoCNHqx0gGk7lEXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676139; c=relaxed/simple;
	bh=Bs6mTjUeA5qkWiBJBxqsJFMQQCY3VsRZlZa2vBfNivk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVM+cz77pn41BxC6aneVuhIiU8aEcNCtMGRoYwhMddLURURvnV8ooJQXbr7R5q8Ww9mD2eZOYaGlnoLgkydiAErz89bv0ocWs5KhdkwFvjiJB9QpSAOirDbHleWdJcBNP8mvynA8y5AWvt18YGOCjNeq2TI7Nlxqj0KOL43thXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VWMB9joG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mq5aWqvy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769676137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
	b=VWMB9joGXYC7p4SXDrqZ3kZ3eOqnv+1+GtytduFRo7jVG9Ybe1PWzU0Bt8QeKVgfkfWdz6
	zmGDLVMkEvnLW0E9bRuhO3BQN7RGMB8HvHXXW10KrTRrtR3xoELejQ01NarfC09UEGnnFN
	zyLUAx/s2WOiULXH4ByRf/0obMLKfDs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-nFvos-3JNa635fMm14KfyA-1; Thu, 29 Jan 2026 03:42:15 -0500
X-MC-Unique: nFvos-3JNa635fMm14KfyA-1
X-Mimecast-MFC-AGG-ID: nFvos-3JNa635fMm14KfyA_1769676134
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso399632f8f.2
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 00:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769676134; x=1770280934; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
        b=mq5aWqvyQmv8XKxcpsL05xFNhP61yPx8mUM6PcbPlav9+2J+a2Asd7Xk5Xzvo/A/D8
         YADLhS4VMYeN+3paz47G30CRdVTA6Ogaltn2PsoOPaJ+d55xEIJ/OqgOUBd6pxZBmcl1
         yQ3/6bJ7YzwirFNvFH4c7GsCYJoB0QtVW3p8TUQLSoBk3NbBGlcxi7WINp0jDJG76yXv
         ilLWC8irwCt8KlWWqe8LuhFPQYPHtZUZDIYYcIjDNB1r6KNgfP7VRlZUWuiyx8Cis1Vj
         +L6SWkm3ku2hbUf67agmgdb+aUldVPeyCA5ksesY7AGlPwv2nqiduFy+F0BylQenQr1P
         +doA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769676134; x=1770280934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THtu/B0OMAesHMQ0Tb4jSeVco+ToRrfio4hfGUipZDw=;
        b=ljny58ynzRKhuaJECiyuhVPvK1d/GxtlOfTTisstq+arPrIBIXuMqtZnD4S4eINeUO
         +q0XjfskZ2umCzgF5qlIlV8FCD837R8qfg0me99DETjnKd87VXYXFondwh/Phu4SlaKh
         LM5S+WUgdWH0VvG25bMF3rvdY+TH+go9+nEULG0Rw4KhRc7OX1BxnX+tXAx3lbahro6q
         mY1nZhzWcEh8eafNa0j3s4cOJ6qmdJ+4kjALkjMrGAnC0h9jZAMJ/q0cy477BH+X243/
         LUA4P1Kxcr+p7NXbkSimn55sQaHse5pfjDp0qCvuM9oQO59yKA11aQOWulSAgFV5KbGk
         goZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4jdsfGxPzatN1wXnP/bpV35cNeKgguTRvm2ayG9WXrFZ2niwBjwRmk4vM88kFvbgq7lI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ9xpORjxG7wPfBJA7PxFlworxUxt98DYSmggTZlNZc7tU8Bj/
	aFiSFNPXcfPQvXe+l1NxrJyxTxayTDh4kgxmRy/k/5LwCiET7Jxl2yO2RCziu4ySvS7SvYMdxNQ
	0TGNRWn5qCPYa6VHlpSkN4JBZciGXVWuj0n1Di8u5ymufopdUBH23Vg==
X-Gm-Gg: AZuq6aIVZH6hYNVhSUuRekEtUVqASjntZ6o9IKFfJ/qcJ0fKhUcbP2i/p8aVLGw+7Fm
	7k9u95TKF7hLr27sq65hczbxZFtbthpMp2sW/JPqSh4hoSPAxiUpVPGWrZ4OoUZX2HmxX096Akb
	PWLdFefRJMX2wY1hHLO1yOcLFDMm1eIgUfiuZtQ7HlDRharPRXu3uix9GSn60aEWePGzMSLMvJK
	KwnQWa4MYjKNzpthzQ30B9OhciOdbgHfvF/+GFCa5ypocy4+UfY85U/0qrd+UObzP9g0o3thLFd
	Nn8efFSY15EAxE/1Zt+bN2Q4xEqrbB4G02NXez9opMOCHNSSMPh01a1hqqNcKzUrNH6f+xs+kcl
	m+bOxy30BOaGnCXxR0NBkvlySVGekEVyaO+pWHVoHHlFWnYLZuhzU
X-Received: by 2002:a05:6000:178b:b0:435:9116:c713 with SMTP id ffacd0b85a97d-435dd02db27mr12237793f8f.5.1769676133916;
        Thu, 29 Jan 2026 00:42:13 -0800 (PST)
X-Received: by 2002:a05:6000:178b:b0:435:9116:c713 with SMTP id ffacd0b85a97d-435dd02db27mr12237753f8f.5.1769676133482;
        Thu, 29 Jan 2026 00:42:13 -0800 (PST)
Received: from sgarzare-redhat (ip110-139-192-82.pool-bba.aruba.it. [82.192.139.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee040sm12807318f8f.11.2026.01.29.00.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 00:42:12 -0800 (PST)
Date: Thu, 29 Jan 2026 09:42:06 +0100
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
Subject: Re: [PATCH v3 15/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <aXsclvInQFIuFe5i@sgarzare-redhat>
References: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
 <ce44f61af415521e00ab7492aa16d3d19f00bd5e.1769632071.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ce44f61af415521e00ab7492aa16d3d19f00bd5e.1769632071.git.mst@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69523-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,lwn.net,selenic.com,gondor.apana.org.au,redhat.com,hansenpartnership.com,oracle.com,linux.alibaba.com,samsung.com,arm.com,davemloft.net,google.com,kernel.org,suse.com,ziepe.ca,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 70392ADC28
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:31:21PM -0500, Michael S. Tsirkin wrote:
>Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>last. This eliminates the padding from aligning the struct size on
>ARCH_DMA_MINALIGN.
>
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
>
>changes from v2:
>	move event_lock and event_run too, to keep
>	event things logically together, as suggested by
>	Stefano Garzarella.

Thanks for that!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Note: this is the only change in v3 and it's cosmetic, so I am
>not reposting the whole patchset.
>
>
> net/vmw_vsock/virtio_transport.c | 18 +++++++++---------
> 1 file changed, 9 insertions(+), 9 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 999a0839726a..b333a7591b26 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -55,15 +55,6 @@ struct virtio_vsock {
> 	int rx_buf_nr;
> 	int rx_buf_max_nr;
>
>-	/* The following fields are protected by event_lock.
>-	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>-	 */
>-	struct mutex event_lock;
>-	bool event_run;
>-	__dma_from_device_group_begin();
>-	struct virtio_vsock_event event_list[8];
>-	__dma_from_device_group_end();
>-
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>@@ -77,6 +68,15 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+
>+	/* The following fields are protected by event_lock.
>+	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>+	 */
>+	struct mutex event_lock;
>+	bool event_run;
>+	__dma_from_device_group_begin();
>+	struct virtio_vsock_event event_list[8];
>+	__dma_from_device_group_end();
> };
>
> static u32 virtio_transport_get_local_cid(void)
>-- 
>MST
>


