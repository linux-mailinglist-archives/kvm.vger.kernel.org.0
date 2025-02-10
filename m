Return-Path: <kvm+bounces-37700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85666A2F2F5
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 17:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D8A71889FDB
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 002552580ED;
	Mon, 10 Feb 2025 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LcFwr1QN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4E02580C8
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 16:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739204176; cv=none; b=ijoD5X1+pqoAnSyvoAi+ZxjvU72mW+98EkFg06TEl8vDPPn2Ngp/ZbdTKn0r26qAOU98kIq3w9vfDKLC0SZRlsaI9iISOXW02axtmMcgAueOG+2r1791KQNHZFcUYlL+UNzSKXSBQnDZWXaQCgRXAkfKSfj6vUEbKMEw2fxU59I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739204176; c=relaxed/simple;
	bh=1jcS+7FsjGMJ5ImWaUmKT2uzq8IjSodR7EIZMko9OZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JNQs/NQFIsJUf0fm69J2ZZbOXsNkgVww4iWLLhAVOWniuHH3l3BcEKTVAHRntzY2uyGitotQcxnl09zOAC/pgAP6F7s249riIcTzRAXG2W+R/4qh2SxfgQ2YMSc0gN26302AWgfE1YcPbvo3UV9B2TT2QcH5qXCGJxo4dzgZt9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LcFwr1QN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739204173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FNXSpIDMbsYdI6rFjnVldoS4vIPojHfA/xPTtZaSU8I=;
	b=LcFwr1QNjPd7S0g3BF49cufrIjn9j4JlghdgWE2vcrNTiqbYODvC2ueqmkWqDeXdNx34ba
	9A3V6SQ8a/kUUVaTESai7TmtuTNEcnBuCOME0pJ9qS5qym8ZbI2rF+JoAbFf8a09UxcJLI
	0TXfI32GoJgkWukQmGFAMVOzXAFmlik=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-B3_pv4SqOqCetguWl5gclw-1; Mon, 10 Feb 2025 11:16:11 -0500
X-MC-Unique: B3_pv4SqOqCetguWl5gclw-1
X-Mimecast-MFC-AGG-ID: B3_pv4SqOqCetguWl5gclw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43942e82719so8733555e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 08:16:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739204170; x=1739808970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNXSpIDMbsYdI6rFjnVldoS4vIPojHfA/xPTtZaSU8I=;
        b=XSUsBP/C914GG5Izc9Cg4H8KshkhQYxpwSTpSm2qlFKgSumNWmm7KEUZkeEW/LG9x6
         6OlJmPYJL8C1OmGBOefezzUNViXLHmLDhU2sx20ects9j4uX1UOdTm7LPOkdj1lBcjb7
         ogOquFZotzCjIojrbmkvn6zN1qvY/FjWNEbnA1zskt2zqwNlezv+EqqxNOBlo25dX6md
         QfftxvfweCVLHbHAEaU32N/YQT9cEsdNfyHa7qmZ72vVFrPNPrTCjZns3qniR8Z2jCsj
         1bTutY9VeeP4stis9ObweyK3x6pP0LJk+4raNnJXLW/3sTV90OxVEsQdftz94OvamZsu
         82tw==
X-Forwarded-Encrypted: i=1; AJvYcCVjWp0YFAodDBaowztaot8CDisaO96Kuic89vGiPWh6LAHqA8Yl85nFeK81U4nteh98vY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQEvWcwBwlZlorQf7ZMPb7UBzUtD+nPORpPND+c2gcum7bac3
	WXj1bwgtxq/ApjTk2iFnSwRjz7ZQANCM7cRRHQSUmQIjQ3pYjrvw1wUY3MkKuTPmwGSXS0S7lNJ
	j+pRqG+spnmaSZFgFfX8hisiogXPXEX5mLgmSTn/9LdaGkO5t2w==
X-Gm-Gg: ASbGncvI2v/lPKteZQMB6CQ+i7zxoGU3OMm3tiDjvM7m0vKPQsE/ksGweCl8HqTjTEv
	Gu+uDZN7xYVwYIG9N1WgYJjS07YbLlGNPSa/4Pbx6yaf16n/eQs8BwqKWdKj/i/dF38xfZwdSBO
	budawO8dijgJ9CxOkb34jwcI1ZeMFK31v5aGgsQD3sRj8xuz7k+ScCfp74kgSYbY3fuXRwd/bES
	N93GhlXfepcyqlVIR45+RCvNkOmzzGPZ6IO8ZQ0fQO1oj2Dn5yYl48HRDB2+Fu+MimkDLZCeW6t
	FhvITk86VLo+5Ta8QTv70H6DKJbQuD2eSOpBTOEX6xDCvrRunQbN3A==
X-Received: by 2002:a05:600c:34c2:b0:439:4a9d:aeaf with SMTP id 5b1f17b1804b1-4394a9db1ebmr15085135e9.25.1739204170034;
        Mon, 10 Feb 2025 08:16:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4uH/9bRhvTIF3vEIfyT9myGFn94vbG/HM+aXMc6HM0Pb2tHDTL/kGHkjMrZlOrAunNmfsdA==
X-Received: by 2002:a05:600c:34c2:b0:439:4a9d:aeaf with SMTP id 5b1f17b1804b1-4394a9db1ebmr15084685e9.25.1739204169320;
        Mon, 10 Feb 2025 08:16:09 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43935d4bd5csm77423835e9.6.2025.02.10.08.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 08:16:08 -0800 (PST)
Date: Mon, 10 Feb 2025 17:16:03 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, mindong.zhao@samsung.com, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: [PATCH 1/2] vsock/virtio: Move rx_buf_nr and rx_buf_max_nr
 initialization position
Message-ID: <yvdbqfahgu76eczt5c4n76akbhh4h2ofemd46kv6kia4xipeqr@tfucpayw7cqg>
References: <CGME20250207051943epcas5p4b831a4f975232d67f5849c3a2ddbcb59@epcas5p4.samsung.com>
 <20250207052033.2222629-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250207052033.2222629-1-junnan01.wu@samsung.com>

On Fri, Feb 07, 2025 at 01:20:32PM +0800, Junnan Wu wrote:
>From: Ying Gao <ying01.gao@samsung.com>
>
>In function virtio_vsock_probe, it initializes the variables
>"rx_buf_nr" and "rx_buf_max_nr",
>but in function virtio_vsock_restore it doesn't.
>
>Move the initizalition position into function virtio_vsock_vqs_start.
>
>Once executing s2r twice in a row without

s2r ? suspend 2 ram?

Please define the acronym, it was hard for me to understand (the code 
helped me).

>initializing rx_buf_nr and rx_buf_max_nr,
>the rx_buf_max_nr increased to three times vq->num_free,
>at this time, in function virtio_transport_rx_work,
>the conditions to fill rx buffer
>(rx_buf_nr < rx_buf_max_nr / 2) can't be met.
>

Please add a Fixes tag, in this case I think it should be:

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")

but please, double check.

>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>---
> net/vmw_vsock/virtio_transport.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

I find the commit title/description a bit hard to understand, please 
take a look at: 
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

In this case I'd write something like this:

   vsock/virtio: initialize rx_buf_nr and rx_buf_max_nr when resuming

   [Describe the symptom]
   When executing suspend/resume twice in a row, ...

   [Describe the issue]
   `rx_buf_nr` and `rx_buf_max_nr` are initialized only in
   virtio_vsock_probe(), but they should be reset whenever virtqueues
   are recreated, like after a suspend/resume. ...

   [Desribe the fix, what this patch does]
   Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
   virtio_vsock_vqs_init(), so we are sure that they are properly
   initialized, every time we initialize the virtqueues, either when we
   load the driver or after a suspend/resume. ...

>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index b58c3818f284..9eefd0fba92b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -688,6 +688,8 @@ static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)

I think it is better to move the initialization of those fields in 
virtio_vsock_vqs_init().

> 	mutex_unlock(&vsock->tx_lock);
>
> 	mutex_lock(&vsock->rx_lock);
>+	vsock->rx_buf_nr = 0;
>+	vsock->rx_buf_max_nr = 0;
> 	virtio_vsock_rx_fill(vsock);
> 	vsock->rx_run = true;
> 	mutex_unlock(&vsock->rx_lock);
>@@ -779,8 +781,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>
> 	vsock->vdev = vdev;
>
>-	vsock->rx_buf_nr = 0;
>-	vsock->rx_buf_max_nr = 0;
> 	atomic_set(&vsock->queued_replies, 0);

Should we also move `queued_replies` ?

Thanks,
Stefano

>
> 	mutex_init(&vsock->tx_lock);
>-- 
>2.34.1
>
>


