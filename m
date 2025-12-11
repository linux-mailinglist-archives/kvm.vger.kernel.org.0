Return-Path: <kvm+bounces-65734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 007C4CB5052
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6CA43008FB4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D652D9496;
	Thu, 11 Dec 2025 07:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVitsYzR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="smI0YqLN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433562BE04C
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 07:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765439458; cv=none; b=rpKHWJIoqst1V8aAukdh0Cb80rcDS7qtkAvbPmQkbJ7dXDdFPOpAXkYODy8ir439B3QJbrhOXnZLV4oRudA31qHF7WUgx3fWgQzlry0lWiAveDQIarcTJCH0palyLhJvHUWWvC5BymbECLU7RsvS1Q2xLse4rkOxbJcm5irP9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765439458; c=relaxed/simple;
	bh=Tdaj27oj3uUmgl9B6hjdaVnC0Z/17Xx96phCTkl90B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2I8TaURvRauyhEuv1KuEd0ExtKYHgL9uaxxs6xHKyNOf+RdUZqivEBVLXw/aZBv6vGeZ4/an276r650N5x6yyd8OtIR/PGPIdad/lzLANQIf5zjtwBMZTp43nCI7RgoFSCbKxFbl3xGVz9hlEBLUDdMbHcg9f+FMzqkLyrLGdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVitsYzR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=smI0YqLN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765439455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1julX6+lHM93SRmQtBaRqoKkJXlGzuQZ/nqcTrNS9W8=;
	b=GVitsYzRRkOluXQJQFd6zxkmyLxs38X1qvXm2hvQph0GGDq7rnc8k3ZrRTwieRh5/UQDTj
	Ld0NvuMzbOeic7uKdzZIrUP7ZZ1BzyiQyz/xiTjlT69zQ8z/gfntqTnA9Lnrbr72nHCegc
	y1C1VpviDrwiUuXxh+O5CTQlPb6JWFo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-y6kJZYobPSeLPLmBuQr6yw-1; Thu, 11 Dec 2025 02:50:53 -0500
X-MC-Unique: y6kJZYobPSeLPLmBuQr6yw-1
X-Mimecast-MFC-AGG-ID: y6kJZYobPSeLPLmBuQr6yw_1765439452
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso2789925e9.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 23:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765439452; x=1766044252; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1julX6+lHM93SRmQtBaRqoKkJXlGzuQZ/nqcTrNS9W8=;
        b=smI0YqLN0caaqEi8xK7wSUiFiGk2rr/IGovPcOkVd9MuiGJCbEYiTlohjSNhhI1Nki
         bNs24xixCkHqeeHZL9hTzuaE1oS+pn92lek342phV8TnjQh1O6FIptxR8VpfmvB0Llmd
         i7kvl1S4Xbly2xrwXv8MPQNN/cAP1IZYhFnOhdlrJBc9syjktwXRJw8yRMULuvE9bCWN
         zGNAyO94iC30BeH2ggNmj5iVMdIqt155Uj4kw4AvxW45WWK7AGUTfXSDd37OoFdiC277
         I0z1kguWE9x5jSl1QNgLKx4mUXGKTITEO2qj+Lq/Ca9GGA0qAu1RIkqMCWm+khPlrQxg
         IpBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765439452; x=1766044252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1julX6+lHM93SRmQtBaRqoKkJXlGzuQZ/nqcTrNS9W8=;
        b=rUIlu67SoTpN1uIKV5IVLuMyLaBri7rPy0yHsdwcdu3agcEi+AS3daI3845Pzv5rui
         5Sl4NjLE/wi7aWdwNUrZgtm2QWlBHTXyTcnvvEPxBpqNFjRnrLNQJljvoBulljS0Kx81
         dNfd58P0jvvD8vzT4Ixe38v49Sboz62aKK9HkB11kD0imLFzhGTGqV+jCX4N7aPoGOFV
         C7DceOMD2n3EL1LyP+0V1z47aMla20rYghdvHQ68SbJdNyFiaDhGiix5f1w9dsD6F3Rt
         ZHtpGJgvt9Uhw9ZPqa8VrY75laAKpi5MWRj71TlCeVxLeIUQw5Zt1Dras1Y5rtJ2+SaB
         8QjA==
X-Forwarded-Encrypted: i=1; AJvYcCW0EfQ4eJ/X6zwm5kl2yb+4e2MuLctoG0J/EGcB/RCyq+QfUaui110btsWKjt68wGldtKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA4UwduyHxSTt/k4/ofayjvIp9MZizGD/G86IAFqJXHi0lfC6A
	rrBY8uFqtwMRuyxu/DQT98CK7DsSuqK1zfmiCmCDIkr/ubcNRKYIl0uwOw/Rzszd27dG6qoPw74
	OEqCJUU59UF8zN9i2c2AZRYwBjxzVheJMbru+Y8NdYUkQTzXlbV2I3w==
X-Gm-Gg: AY/fxX4K1heK6oi7E7LBlNXsbkNGm601g/9nIqKGOv3RG0zgDKXZtRuzNUIkDWs0o0B
	kVLjKFUjm/9CxVmoAnLw2+gqFvmC44ACm/NPST3YCgUXRddOfYXSb6AVdKmCgWuFh5GW8pYGovC
	l4Y877RcTbyHf1zaj82eUWyx+aARcBuLiKuK5Rki9nQTN5ErQtnJ6ns9Pah/LVwv+zUJgG2pTX1
	TNnXfRvyqykCJ5sUo95/+GdZ44032OAM6uMiHpi0qSKHXGiNkfF9pmWJD21MvOdPAzdAiVfnHJS
	xrIJlQUulrZcapp8GfJrnJb2Y/zTIfukEmKibeoskxpCx9BWtT2Q0xHXBCRobjNO5RoEFpAi3An
	2NnxzXpHxL8MWJnJzgfLMtUZI5neTPh0=
X-Received: by 2002:a05:600c:c101:b0:477:7588:c8cc with SMTP id 5b1f17b1804b1-47a89da461emr8884155e9.7.1765439452372;
        Wed, 10 Dec 2025 23:50:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEqSjcn3rTA9O8e0vbxus6mZdzQZ1RPlwK+jJom7NtOKCUAyJXsaTZy7V9armCUnMlhTK9Uqw==
X-Received: by 2002:a05:600c:c101:b0:477:7588:c8cc with SMTP id 5b1f17b1804b1-47a89da461emr8883815e9.7.1765439451922;
        Wed, 10 Dec 2025 23:50:51 -0800 (PST)
Received: from redhat.com (IGLD-80-230-32-59.inter.net.il. [80.230.32.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42fa8b96c70sm3927469f8f.37.2025.12.10.23.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 23:50:51 -0800 (PST)
Date: Thu, 11 Dec 2025 02:50:48 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] vsock/virtio: Fix error code in
 virtio_transport_recv_listen()
Message-ID: <20251211025034-mutt-send-email-mst@kernel.org>
References: <aTp2q-K4xNwiDQSW@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTp2q-K4xNwiDQSW@stanley.mountain>

On Thu, Dec 11, 2025 at 10:45:47AM +0300, Dan Carpenter wrote:
> Return a negative error code if the transport doesn't match.  Don't
> return success.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> >From static analysis.  Not tested.
> 
>  net/vmw_vsock/virtio_transport_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index dcc8a1d5851e..77fbc6c541bf 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1550,7 +1550,7 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
>  		release_sock(child);
>  		virtio_transport_reset_no_sock(t, skb);
>  		sock_put(child);
> -		return ret;
> +		return ret ?: -EINVAL;
>  	}
>  
>  	if (virtio_transport_space_update(child, skb))
> -- 
> 2.51.0


