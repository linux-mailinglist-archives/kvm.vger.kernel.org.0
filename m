Return-Path: <kvm+bounces-67390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A32ED03A74
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 16:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 899D43079E8A
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B5D414644;
	Thu,  8 Jan 2026 14:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYspJI45";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ipTnwXHD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEC840F8C3
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881520; cv=none; b=sRGQkjApxjUhcLWGF6+P+lTRHmgDBmodYqQ1X3X+tZ4NnYHFk2ieI/W4/OoLTGfAtVHNxpNbs5wf+n0RyTvgjpwlSAEsQQ48k8lnOU0aslAb3CKlRHLohUwJi7m97cO/kTm3dKD1XvcidytuiQL5SptDKZxbzZp5fw5/f2BiBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881520; c=relaxed/simple;
	bh=AFb8yUemGFVP+E1zn7JOJ8f6bE4z7sRVkT9bi0zm4eY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYByD3zuv9UPeBCTV4blt/CUXXdm+OHdOMvTiJUQIxCsn8A+8i7nGCL63dVFAwVKBqSzuiM5m5mqdwJccRnmvGjpXRExR1fn+QFLXDI7WrYs6WZhUN47i2Y1EpGrPgNRzKMAV+q29HYxF9CwUgIP8iyf66PEqjrVpPmFqPKBoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYspJI45; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ipTnwXHD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767881517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
	b=ZYspJI45MQXRGPwBNwrGxvfCjkovRKzgFgCIXO04g+MC7fzQ/mRUgXP33W8kcSxODQ03Zc
	WB2RHv3gQjC5gfPZA5S6UL0jbDykQhTo9QlELw/mQbj6iy8JcV9qge1EXlAM8SCPLHQTZG
	buFs+XeR97qOt8QZL5+Gs6q5wP0t790=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-ypqZAiCBMJeaiTeODhql5A-1; Thu, 08 Jan 2026 09:11:56 -0500
X-MC-Unique: ypqZAiCBMJeaiTeODhql5A-1
X-Mimecast-MFC-AGG-ID: ypqZAiCBMJeaiTeODhql5A_1767881515
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-64c7242a456so4681377a12.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767881515; x=1768486315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=ipTnwXHD+dLvDSmgaJopVLl/1O8dnyQsR1tZk+lqtAATXWbvS/P0QG+tojhsdu5HPI
         pv5SSJgMhShvO/6FGq1gyrxXpQRtHTmRjq3kjiQi9db2f/u50YyurFdq2eA3tMPFMu83
         7b8j8EaUsH6N949qWInjMDr7NqkFx/UWgc43C0n1jTdBjSsmOFeiF1PCSICFd/n0TZgm
         x6dZC343KryZI6rn/qDuvOHK5pI4LEQYtoBQ5GqsLvA1BeDZ2DYxZE+Og3+3EgLCiSOU
         /aQrIKL82HTc/43aEnyErBjIAbEEsAVicFXAYKgmaOPlK63fvd6vWuHbAo46exB5OpAR
         5ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881515; x=1768486315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PajL1D9j4AF6hqkkrLXFCZ4j8C7K2WP8fPkzMuDGb9E=;
        b=OyeT3AYcw7yrp6EHjPHhFVa9WfGJ4FRT2HdzcP9TowRLe7HROraeFly6qUKVB9Xydm
         7cKGxe7vlOoAvMDlDH/L9/+bzNacycjWGQripfPDcEjmn/IaeHEC8f7QAI8AuCuGFmiW
         EaSeVG+foCOgznD0qu0X99ba4p6UZBdJtru1nlOpritaR9ygtjzqRiKBF0IZF7Jbp9uq
         kAOACfNPQQn4XtOfW/tTHNBp+F1EaCurURl32nWzPzsD3aYHQB+Mn04gkCcAza4A5dfz
         lRZOOgZOfEsbLaj2P0sRd8or2d8pLyoqVAoKRe0rubpFaJkoIjx7bAag9L5+mgSeS8b4
         T8Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWz8z7vn3zZPcHOZm7K/Xu/KtMXGsoIAtyufOQQ7uaxNlre+ZMmLOKNUEd/uJKBOW1yr7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEJM66nurFCTNuA8vtcSO27HkDrlW2/KUG3cfykRcNlxB1ywIX
	hWZvlMvFaaFIUboMdlR18LzOHhCBgIaBhu6PTtzV69iQgq8/Y3RSDYTVNNwRa6eeGvRrOK/3Diz
	W1uSFVsPTs63MGCbnfdzUrIjmRMEweh7h+IrUmaJbFuQwUz1k7hGWWQ==
X-Gm-Gg: AY/fxX7yNkdnRCXexphhEWZlEYgrRTeYyhDQ2mOGaSroIYK4HrMJeZ86Ki9iRe4ZXE+
	ThCeVgdXf/qXts4m6Ww0+L+iilfiWR7DkX1qsdXQTszPqHDUHYqngaehE4Zg+ICjzj+l9ToQifw
	vP5rkRrLJv8xdvXZKEPqw8CtEQ9IkRuHfcKFP5PMtvNWnEda4+k84cJ2a+q2Y9/FNzg4H/gZRnu
	USnYdt0H8QJAFwewHQSR2ClzhPA2UkQqP8HQ/7IzD904217qTAVBCtav5Cxka8978VlQvs21OEz
	3/nIxLvq0/C7uXUMZ4fLx11c9f281EMDL8RQakCzMSFmipgEyZkG2qZ8PMINZ9h0TLPsxA30zOh
	zOfsiTnDs0bsppYI5
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010685a12.15.1767881514753;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH4GSSsuHOuOKzAWjnLjL93ZyftULQdKpADud0o+HUDbYN/JI+jAlKmTdijyyr2Y36a7d4Rw==
X-Received: by 2002:a05:6402:358c:b0:64d:1bbf:954a with SMTP id 4fb4d7f45d1cf-65097e01237mr6010647a12.15.1767881514187;
        Thu, 08 Jan 2026 06:11:54 -0800 (PST)
Received: from sgarzare-redhat ([193.207.223.215])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf65ca0sm7641163a12.24.2026.01.08.06.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:11:53 -0800 (PST)
Date: Thu, 8 Jan 2026 15:11:36 +0100
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
Message-ID: <aV-6gniRnZlNvkwc@sgarzare-redhat>
References: <cover.1767601130.git.mst@redhat.com>
 <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>

On Mon, Jan 05, 2026 at 03:23:41AM -0500, Michael S. Tsirkin wrote:
>Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
>last. This eliminates the padding from aligning the struct size on
>ARCH_DMA_MINALIGN.
>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
> net/vmw_vsock/virtio_transport.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ef983c36cb66..964d25e11858 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -60,9 +60,7 @@ struct virtio_vsock {
> 	 */
> 	struct mutex event_lock;
> 	bool event_run;
>-	__dma_from_device_group_begin();
>-	struct virtio_vsock_event event_list[8];
>-	__dma_from_device_group_end();
>+
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>
>@@ -76,6 +74,10 @@ struct virtio_vsock {
> 	 */
> 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
> 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
>+

IIUC we would like to have these fields always on the bottom of this 
struct, so would be better to add a comment here to make sure we will 
not add other fields in the future after this?

Maybe we should also add a comment about the `event_lock` requirement we 
have in the section above.

Thanks,
Stefano

>+	__dma_from_device_group_begin();
>+	struct virtio_vsock_event event_list[8];
>+	__dma_from_device_group_end();
> };
>
> static u32 virtio_transport_get_local_cid(void)
>-- 
>MST
>


