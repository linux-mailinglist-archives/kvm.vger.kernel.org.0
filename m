Return-Path: <kvm+bounces-53971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDBEB1B1A5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B50B9188B0F0
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 10:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87B626CE12;
	Tue,  5 Aug 2025 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Htu8OPjR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAB721FF30
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 10:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754388134; cv=none; b=MvfbE19cVnjZVBWvxzLMJyzSPw83khyO/EkUgdFia8a9Du/XJoOfAeMHC0WWTrWxUBhqRzuQuH1Bu3+RkBFDhzkjftR9Polq6IhM7McRjrLbX4PAcT68gy4AwIjgzbtiTGgov5eQh5HVQBxRsYb4uys3koPV/tODGvWLq7IikhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754388134; c=relaxed/simple;
	bh=ghVc4jUywvAFQR8Cbgq1AJpVrOuHaExsk9z8LbGUnck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4SkLOODYd4L/R1r+mQ++r1jDJxEb0e0aRsfGn+WlXx1ORLMnpBvbFWmdpwCgD405GRILyP/lI63Efk8GbuShEd7TEJ28aEb6lJ+9oimDBbJQMh2ZM7PaWh7wRJT9nJNlqODBtLOzTX6mJ8YE7sVimXhhc9QRNl4zb68b8D8Etw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Htu8OPjR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754388132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C8iq3DcQDje5KaWsGWyrnSm7HvAQMMkFMgKVgyZHegI=;
	b=Htu8OPjRr5bBkF38LFbvl+GZ0pjYb46eSN5NmvaAazadzt26NRdx1WEDuRH68LD0BpfNDK
	uI/8mc499/++6P3Cn/6xnzvuI2K0GqJKRET88Ze2eVVO9ncgQYu/oyD+NQyVQqtDogCVCV
	DkOEbCUyHvDM53DIykjQbACNwnhLKNg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-tDDLRap0NlSAo0hE6e4WdA-1; Tue, 05 Aug 2025 06:02:10 -0400
X-MC-Unique: tDDLRap0NlSAo0hE6e4WdA-1
X-Mimecast-MFC-AGG-ID: tDDLRap0NlSAo0hE6e4WdA_1754388129
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d7da3647so13115665e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 03:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754388129; x=1754992929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8iq3DcQDje5KaWsGWyrnSm7HvAQMMkFMgKVgyZHegI=;
        b=P8FbGFRfHI6QLuKjID/QIc7OH/CqfHME0XUPD5oOPY+9DHgHTywrZP4ZnI9xMljH9v
         hC2gJgu3s3FvUFT2EW2RC2xmoCAg7qA+Km2hEuOIHYhdf2rullRdoDqZhxmukdQTe5hi
         H6YkJSH0FYQe5g6+JIH97luZEM09z8Kz6cfcq/t8/JnkR655jnXlWEe6KJe9xgxCggDc
         ypHnXj0W9S/feVg8Wq+UawKHUZePiKtVP0MWGtiGlX5w02F7HTcVdH3MVTe09WFw23I/
         UEhvxrOTGMIsK6TCZsNzsY2cd87F3iu5cBjZTI6lWWgoeJTkme0ESgwQy/KxrEgsNsK1
         H3Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVSXC9JgzNw+CXBFQXQK/DHbNSC5reavZ8P9pjQk/QlHGtf9RTTDVcuRRpcnAvKBL2GLjY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2rdtbMO1Ue6KbE9SRJfpQ+zvvyhOsLzCmciSFdHIeinYrQggK
	u4ojSbzzWa+PeWCeF6TPFXMN87od34f6Ajo2Nsjo5kVtrVz1mS4fbvE/59ytcQbcRHnqIImy2wg
	IU+7T4p3DDHxKtoe7AHFsTHdpOWJJyw61/lkheBKo+NjUjYfBkPRzNQ==
X-Gm-Gg: ASbGnctxWFGwuFZrFAv2LWelF/Ivbr9/4Dn5kRUEKDIwtfBG7Ik2EBT2836OBdgU+l8
	kdl9f2Wew5M8HlgY8CxL5WfEX9a8qkm9yLWVmeJEfuj4jyX0cYZOvQXae/KzrO+uDID0JdE+zhk
	NQxfbhN/qf2dVEmt30L2/eyoReHNuJPqcMVsiGLarc30FhrdinQmoZX6Nmec1gtlPWBYlZO9FyH
	77p0OjRYpFRcWRq/g00bSWMBSsuv6nCLful/rzWtfxdZwY4APe6LS+lCyEa8WtdMXdyHtlUgmrQ
	zyPQp1oLOLKLrxpZ1ObnqYcKxICj33Tc
X-Received: by 2002:a5d:584b:0:b0:3b7:924a:998f with SMTP id ffacd0b85a97d-3b8d946b3a2mr10486259f8f.5.1754388128672;
        Tue, 05 Aug 2025 03:02:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0h3EuzIaMa9Wir/mQMI0EF1I5NZk8tEiHqXjJLyBPOFpTj+sXNt2uVT98K1ru7T8YB22hmw==
X-Received: by 2002:a5d:584b:0:b0:3b7:924a:998f with SMTP id ffacd0b85a97d-3b8d946b3a2mr10486210f8f.5.1754388128107;
        Tue, 05 Aug 2025 03:02:08 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1515:7300:62e6:253a:2a96:5e3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48de68sm18532205f8f.67.2025.08.05.03.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 03:02:07 -0700 (PDT)
Date: Tue, 5 Aug 2025 06:02:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Nikolay Kuratov <kniv@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Lei Yang <leiyang@redhat.com>, Hillf Danton <hdanton@sina.com>,
	stable@vger.kernel.org, Andrey Ryabinin <arbn@yandex-team.com>,
	Andrey Smetanin <asmetanin@yandex-team.ru>
Subject: Re: [PATCH v2] vhost/net: Replace wait_queue with completion in
 ubufs reference
Message-ID: <20250805060149-mutt-send-email-mst@kernel.org>
References: <20250718110355.1550454-1-kniv@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718110355.1550454-1-kniv@yandex-team.ru>

On Fri, Jul 18, 2025 at 02:03:55PM +0300, Nikolay Kuratov wrote:
> When operating on struct vhost_net_ubuf_ref, the following execution
> sequence is theoretically possible:
> CPU0 is finalizing DMA operation                   CPU1 is doing VHOST_NET_SET_BACKEND
>                              // &ubufs->refcount == 2
> vhost_net_ubuf_put()                               vhost_net_ubuf_put_wait_and_free(oldubufs)
>                                                      vhost_net_ubuf_put_and_wait()
>                                                        vhost_net_ubuf_put()
>                                                          int r = atomic_sub_return(1, &ubufs->refcount);
>                                                          // r = 1
> int r = atomic_sub_return(1, &ubufs->refcount);
> // r = 0
>                                                       wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
>                                                       // no wait occurs here because condition is already true
>                                                     kfree(ubufs);
> if (unlikely(!r))
>   wake_up(&ubufs->wait);  // use-after-free
> 
> This leads to use-after-free on ubufs access. This happens because CPU1
> skips waiting for wake_up() when refcount is already zero.
> 
> To prevent that use a completion instead of wait_queue as the ubufs
> notification mechanism. wait_for_completion() guarantees that there will
> be complete() call prior to its return.
> 
> We also need to reinit completion in vhost_net_flush(), because
> refcnt == 0 does not mean freeing in that case.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0ad8b480d6ee9 ("vhost: fix ref cnt checking deadlock")
> Reported-by: Andrey Ryabinin <arbn@yandex-team.com>
> Suggested-by: Andrey Smetanin <asmetanin@yandex-team.ru>
> Suggested-by: Hillf Danton <hdanton@sina.com>
> Tested-by: Lei Yang <leiyang@redhat.com> (v1)
> Signed-off-by: Nikolay Kuratov <kniv@yandex-team.ru>


Nikolay should I expect v3?

> ---
> v2:
> * move reinit_completion() into vhost_net_flush(), thanks
>   to Hillf Danton
> * add Tested-by: Lei Yang
> * check that usages of put_and_wait() are consistent across
>   LTS kernels
> 
>  drivers/vhost/net.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 7cbfc7d718b3..69e1bfb9627e 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -94,7 +94,7 @@ struct vhost_net_ubuf_ref {
>  	 * >1: outstanding ubufs
>  	 */
>  	atomic_t refcount;
> -	wait_queue_head_t wait;
> +	struct completion wait;
>  	struct vhost_virtqueue *vq;
>  };
>  
> @@ -240,7 +240,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  	if (!ubufs)
>  		return ERR_PTR(-ENOMEM);
>  	atomic_set(&ubufs->refcount, 1);
> -	init_waitqueue_head(&ubufs->wait);
> +	init_completion(&ubufs->wait);
>  	ubufs->vq = vq;
>  	return ubufs;
>  }
> @@ -249,14 +249,14 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
>  {
>  	int r = atomic_sub_return(1, &ubufs->refcount);
>  	if (unlikely(!r))
> -		wake_up(&ubufs->wait);
> +		complete_all(&ubufs->wait);
>  	return r;
>  }
>  
>  static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
>  {
>  	vhost_net_ubuf_put(ubufs);
> -	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
> +	wait_for_completion(&ubufs->wait);
>  }
>  
>  static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
> @@ -1381,6 +1381,7 @@ static void vhost_net_flush(struct vhost_net *n)
>  		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  		n->tx_flush = false;
>  		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
> +		reinit_completion(&n->vqs[VHOST_NET_VQ_TX].ubufs->wait);
>  		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  	}
>  }
> -- 
> 2.34.1


