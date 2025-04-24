Return-Path: <kvm+bounces-44124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B7D9A9AC6B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 053261B6699E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3E523024D;
	Thu, 24 Apr 2025 11:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iKwecSQj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4222C321
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 11:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745495341; cv=none; b=hVfmelaxpP1c7kY682Ti+bMiuSQS0t+G5TJ+B4H/MSGrKqOwXwLi2BG3/FmxLrXxw4m3WJqjXgLOrUSmm6nuAYUMjN2Da76C8u9stpCd5j8WOTiXRFhMZtKbaeCYAaYTPRjySWrVUONc7FLSddV4PtB9d88lL9SELXWeSC9gEmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745495341; c=relaxed/simple;
	bh=8b1jn4QM3miujpAVj4Ao/BPpGT15pdXb8SsrQOErUjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GjHYvfhzTp3jtuVy8AGI8X9k+yJ1WbxoyTpJJ43TO+CsVkBHjVK1P1BHxwsdHG46+TzYVEc5lUgcKR7cdvM2FoIYo+wZy3b5QTDr9DsVpMHjMnv5CGzh3HDanMkYKRRuzH0/r80GTo+nvxfB3MEzCF2lViLi7eWV/rL+iduzOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iKwecSQj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745495338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4htAbypt1PAw8cs1ZfgYILn5gui78YIttCMWVT2xuTY=;
	b=iKwecSQj4yu2VFFcDETPL+F0SBFp6lwhEWPiN/F/s39NuBAvkVfsWQhNGizpkgT4Zrz0e/
	6nj1BXZYxzl2JnehFShoSXSwMkhkpMCtdiXAOnFaIYmxFz1i2SmJ/RYSm1RbrWrUOWK0vL
	1+IAbCE5nZB+V/+iaJDMALyWGQ2kA2Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-FTnFQpJ_Ozy3XSLqgfvQMw-1; Thu, 24 Apr 2025 07:48:57 -0400
X-MC-Unique: FTnFQpJ_Ozy3XSLqgfvQMw-1
X-Mimecast-MFC-AGG-ID: FTnFQpJ_Ozy3XSLqgfvQMw_1745495335
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so6749225e9.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 04:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745495335; x=1746100135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4htAbypt1PAw8cs1ZfgYILn5gui78YIttCMWVT2xuTY=;
        b=sH/LT2CyZpI+AbVqtE1VY0q1IGG6F6PYVzJmjQHagR3cVRzTOrW9dk1hKeoPSAZ+WZ
         E5S2duXynkNZORvA/jd9Jd6PPFgHUB3bJrBTTllYOebQuJ0XCuElV0l/3nuybFOhoDmw
         +sKhmxZwjNcKZjBFl2DDPvkcTcl7rOvA+ozCSh9M5XrRFAX8JSBIUZ/d/W80MP444Ef3
         mxMAdoF4yXFbRyMmOBHJ9AgfU9gIsEa0AXbu84SYbQNJ0Tyd9yNwzZLUM86541QpHYmi
         /tI26MOqjqSsAUQ9iSNoRwmY8eCCRgXI9VjtcOKxD5CJCBo18mcfhsL6eDJAVcSSV5G7
         jIfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW/+BkzbIUIbzfdNu4/6RctpzyneuFLffJi/aCrpBPLhguRC3Xn+xnV5Z+BsGmiLhXzV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVo8M3HD98kJRuJxgbfSShAS4OoHM6bdbGNnGZbVn7opNeV2Wz
	FJzm8r0LA5SmGJqnyATsNP8WYPCCcZN++V8WSgklfmf/Wn7+oadGpeNAReteIc/xpWFrnJotaeD
	h8E394sqECd137IMu9o3iCmyx87NPCf11VMjEzKiozJY0l+IuoQ==
X-Gm-Gg: ASbGncuh4Wyt8Ja0zqOdlC7kLY5GFFnvvsz7/eQnRLSApOheiZiibRWl4qAeIB3lwuU
	mtXvrSqSh0l7oHem/G8rS7praLC19J55lx3Ain3wl6hZQs4zJ7m0qB9cqL2jmV5XFghwUOyunce
	AczW+cVytpBwYF4twyqOtV2ufR9spjGT7oQmL5qYh+E3gDW0LNerz67oI4gUCnZKcNUJQjAIKbU
	cc3z919PSjVCYe7EWZwNh9W6FyI2wJWpX0VAhgzIK0q6bUJcxKJyDYjeBA0FZSKjTArcA7hLKsN
	S894kAMdXSFX7sIq4/468o+lEBeLoWR3yxNa/i4=
X-Received: by 2002:a05:600c:1d02:b0:43d:738:4a9 with SMTP id 5b1f17b1804b1-4409bdae980mr22059515e9.27.1745495335342;
        Thu, 24 Apr 2025 04:48:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUZLkMc35rnp4BTi5uk6IdrLmESnS6O2NJ+BKK5UJ777FxcQysn8JyDJpuHccKf//6qU8xMA==
X-Received: by 2002:a05:600c:1d02:b0:43d:738:4a9 with SMTP id 5b1f17b1804b1-4409bdae980mr22059295e9.27.1745495334986;
        Thu, 24 Apr 2025 04:48:54 -0700 (PDT)
Received: from [192.168.88.253] (146-241-7-183.dyn.eolo.it. [146.241.7.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29b990sm19004865e9.4.2025.04.24.04.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 04:48:54 -0700 (PDT)
Message-ID: <a0894275-6b23-4cff-9e36-a635f776c403@redhat.com>
Date: Thu, 24 Apr 2025 13:48:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
To: Jon Kohler <jon@nutanix.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250420010518.2842335-1-jon@nutanix.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250420010518.2842335-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/20/25 3:05 AM, Jon Kohler wrote:
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index b9b9e9d40951..9b04025eea66 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -769,13 +769,17 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  			break;
>  		/* Nothing new?  Wait for eventfd to tell us they refilled. */
>  		if (head == vq->num) {
> +			/* If interrupted while doing busy polling, requeue
> +			 * the handler to be fair handle_rx as well as other
> +			 * tasks waiting on cpu
> +			 */
>  			if (unlikely(busyloop_intr)) {
>  				vhost_poll_queue(&vq->poll);
> -			} else if (unlikely(vhost_enable_notify(&net->dev,
> -								vq))) {
> -				vhost_disable_notify(&net->dev, vq);
> -				continue;
>  			}
> +			/* Kicks are disabled at this point, break loop and
> +			 * process any remaining batched packets. Queue will
> +			 * be re-enabled afterwards.
> +			 */
>  			break;
>  		}

It's not clear to me why the zerocopy path does not need a similar change.

> @@ -825,7 +829,14 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  		++nvq->done_idx;
>  	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>  
> +	/* Kicks are still disabled, dispatch any remaining batched msgs. */
>  	vhost_tx_batch(net, nvq, sock, &msg);
> +
> +	/* All of our work has been completed; however, before leaving the
> +	 * TX handler, do one last check for work, and requeue handler if
> +	 * necessary. If there is no work, queue will be reenabled.
> +	 */
> +	vhost_net_busy_poll_try_queue(net, vq);

This will call vhost_poll_queue() regardless of the 'busyloop_intr' flag
value, while AFAICS prior to this patch vhost_poll_queue() is only
performed with busyloop_intr == true. Why don't we need to take care of
such flag here?

@Michael: I assume you prefer that this patch will go through the
net-next tree, right?

Thanks,

Paolo


