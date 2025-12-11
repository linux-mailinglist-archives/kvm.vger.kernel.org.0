Return-Path: <kvm+bounces-65741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F83CB51CE
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7A153016999
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774FD1A23AC;
	Thu, 11 Dec 2025 08:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHiJIiDd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fc+tieC6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF8328467C
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765441820; cv=none; b=SbwNlBWuRhUPetm72mS8ST5zMX56fC8oL8XC5JL8DYVwozO90b8LgQejxi67FMDJCpN8EfjqTqvXW/MT6MG19JI/SX6S8rRjCXHhJ5QwR6VWBzz2dkoq7t3uyMg3uuYSHiU1GWml3nKYLHhNqJVjXd3yDVB4LKt4U4PixFC/CQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765441820; c=relaxed/simple;
	bh=vx2flSiC2ZzOI6DHmbaRJhsf8cDKzOr34NF/08N2QWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGwAa8f1JUEDJ6RLEEprsWKwrKHMhgDvYcODiKB6R488cAyc580Wu6qE/uNGXaNTgDUEOODZCh0P5pVFXYkRzXIKLIVjOgF02YfQHWLcZQMnyKF7X4usluCNZvafqEF8tKNGFeQk4N3mov3hlAYBm3G+wnunr/pyNqmRUNhs8VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHiJIiDd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fc+tieC6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765441816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3idtZY7mSmwvuTMlPGQ2Fz6MYA6aCNvj4wJ0sTbDzCg=;
	b=EHiJIiDdHyvOSAmmcGX3t5foQ8vZrG5kgY926VSPQ2ABvUO+4k8JTjWdKddnf3+CjeTrlr
	jLhiMGmPN/49YjiqHaHTHdleFTPUyCa7I/Z7a0Amhk90ZNJm0wZMFJFAPYIYRcbH4tZVdS
	0p7zlcB7uIJkKpTKgy6T25FKUSxDQ1k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-gNpUxmNDO6q_jlOvLmt_AA-1; Thu, 11 Dec 2025 03:30:14 -0500
X-MC-Unique: gNpUxmNDO6q_jlOvLmt_AA-1
X-Mimecast-MFC-AGG-ID: gNpUxmNDO6q_jlOvLmt_AA_1765441814
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6460725c6a9so920092a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 00:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765441814; x=1766046614; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3idtZY7mSmwvuTMlPGQ2Fz6MYA6aCNvj4wJ0sTbDzCg=;
        b=fc+tieC6P1z/rzyYPxLlVmEYMkUXnQAMEKDI9pDDyBUSDUiGFcJQplFZupXzqtFUzE
         +Nn2BxymCc5bkjrzdHcPZURYKv11aexFu4/MIiH3at1MLvL8JeOhlyNim158q9gSNsPl
         JvzS7yUZwfwJhhf2DMd67xHHQX/zT4dZXCwtgqpLBj2B5NfYLGvQD8nxwdEsP9se8Wm7
         1BHiZyorGTdLMg1bLRkQ0hcKGDUCupXmkaqPRO3qWbNB2nHh2Qkay9H9cR+fliKY0AGs
         NAKwXyAN4/dVubSks5KGltoheIDnsZmNLvkzGknua0WFY34Ct/0zs8h3VGxx3QxX2wXt
         vd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765441814; x=1766046614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3idtZY7mSmwvuTMlPGQ2Fz6MYA6aCNvj4wJ0sTbDzCg=;
        b=gnFlNKtBeVxzDVavR5IiyRrn1Ay/amyOtc/+7VI7RTh2sMYBR+c9X1JPvgvaBfXIhr
         3lKUBTB2wUvwH6ufIMevD3H5FsH795midM6SeL1Qkgrn9wYXRjyxYm0/lZTThYz+Ym86
         7DfXUVG1Xeaev/ilkMUcfTjtaGupi93KmBbNKAfi0saAZUe1HpRlxj3K1cj+N8eR2Clf
         gHk3V0PJrXxQwn72ktJ93qLGhookDozXWpCc0AYDsZ4M3gnYNudVlT7RZBkvmD6N4IX7
         kuOMqYGi9zzNdeH/2tQlbJ26Ds6VHk/D8ysgTOoz+bZVtQF/UcvHnm3me723WkkorXLy
         Q4Rg==
X-Forwarded-Encrypted: i=1; AJvYcCWn5gVCZOqgus2AkUglXfaahcL5bY2YTRlzHXoAv2KUs3M6QEC4kwB8OU12JLdVE4yl+Nk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2WEpx8ujqtwnAYd2v2kGgO309Pg9YYyJBsJVn23aH5hVyd10X
	tL6Zndh4Zv/kmBjGAHPKdIFjeP7bs3RMpE0Ld+R/B7xfH9gwMqd5YhP3FNlb3JGnokCFesEAuj0
	GzMn8ANp3LSkn/i99nu9LLrFz0IP+4B7Rcg6lzvkwLQu0QM9dHP4aEQ==
X-Gm-Gg: AY/fxX7a7IYzsufSmTd/F26eLT50qzzuWY+lpMiKiS+p0ipZGeO+RrAM5duWvF9P4vF
	PCSIEl41EzHORjM/VtViKkuAdN7d1VTNEd4fcJuY5X+piUA/FCgBKgQojDsI+phYqhQZz5Sh7da
	rJ50WC90D/SJvHE7A5wB/5zHkjHtPyfJytUgYyZcHmhFEo5+0gPJvE375sYF2e6HjsWcI6UR5mb
	qBCKbgx8ByA5VHHsLOIi7r3kBxTs8Lg5jf/G/Cuswo9Ryyc8kHauEhd2dezf1owykApSKWz02pk
	VaW1S5RCah88uufjlWXD3wdFiABqnIPv6lvbaVGSdH8M5buPB2m/QOiayFjVZoTik8PilRJh1Du
	57xxfKkQsfPKY9akR0EbPc7tu9rZxlBL5qyY99a9qDXm0eil6nlfuZROdMAPpZw==
X-Received: by 2002:a05:6402:2786:b0:645:1078:22aa with SMTP id 4fb4d7f45d1cf-6496cbbc23cmr4596718a12.19.1765441813634;
        Thu, 11 Dec 2025 00:30:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGuwQjT4UHTBmwDXqoTBxPbsneTQexl6Aw6I9Srmcye45B0nUYzXfaqL0GoFMZfWMLEuTvP7A==
X-Received: by 2002:a05:6402:2786:b0:645:1078:22aa with SMTP id 4fb4d7f45d1cf-6496cbbc23cmr4596676a12.19.1765441813080;
        Thu, 11 Dec 2025 00:30:13 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498204fbb3sm1831786a12.8.2025.12.11.00.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:30:12 -0800 (PST)
Date: Thu, 11 Dec 2025 09:30:06 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] vsock/virtio: Fix error code in
 virtio_transport_recv_listen()
Message-ID: <xz4ukol5bvxmk2ctrjtvpyncipntjlf4bdr7kjdam2ig5gf7ho@vuuwwu7asj7i>
References: <aTp2q-K4xNwiDQSW@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aTp2q-K4xNwiDQSW@stanley.mountain>

On Thu, Dec 11, 2025 at 10:45:47AM +0300, Dan Carpenter wrote:
>Return a negative error code if the transport doesn't match.  Don't
>return success.
>
>Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>Cc: stable@vger.kernel.org
>Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>---
>From static analysis.  Not tested.
>
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index dcc8a1d5851e..77fbc6c541bf 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1550,7 +1550,7 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
> 		release_sock(child);
> 		virtio_transport_reset_no_sock(t, skb);
> 		sock_put(child);
>-		return ret;
>+		return ret ?: -EINVAL;

Thanks for this fix. I think we have a similar issue also in 
net/vmw_vsock/vmci_transport.c introduced by the same commit.
In net/vmw_vsock/hyperv_transport.c we have a similar pattern, but the 
calling function return void, so no issue there.

Do you mind to fix also that one?

Sending a v2 to fix both or another patch just for that it's fine by me,
so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


