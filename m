Return-Path: <kvm+bounces-37690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFEFCA2EA85
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 12:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9B2E1883624
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 11:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8041EDA18;
	Mon, 10 Feb 2025 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxpeVWpS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250D1E3DEC
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739185368; cv=none; b=YrGC0lLd2nhgxqqWiD0BQ1NlYjNFdWb9KW/Kct0WH215B8ljnHlpnoAQN4Tr6QsqZ+TzEfuWyl7vRv4p5Gqcuyrpd2COjOp/cBWVbd1fQEcvz+0cJFBczEXSq0zh9spctPvImDyTA8A1xpirYTE5U6TOn1/SD2QupRz8j2Qt2uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739185368; c=relaxed/simple;
	bh=LvOQH9ItK5kpkHdcctmHoeElePYbHQ6SeuUkBY4RotA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjZqJ26gvWJzj91nZi9WCWR1Sn4ntDMdk9bPPIqzwY0rL8x08tOzrX9K3tDmVJ2GBaeYvH73r6Rw/wvF5Pixtdq5NUV258AXpIDvapomuIAPP9ZYRtlrWCqymwemXjUpAImit9kMLh5nPGysBUQqtSrf7Yp9Y0F3cRp6jDxCq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fxpeVWpS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739185365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=swYAcnuiVW6RK8Ul+P0fcMd3U5CHMNqoVkyi4ViV2Rw=;
	b=fxpeVWpS5qxB+o+gZJBtGz4WMrxypHZG3EHezx95xV71VjZxEDgzRfLd846jrTH9sPQQU6
	Z92jXE/UYYNgLg09YeTsV54vT4n2puoxKEbPWrVNx6qjMXrWtUUwPvIqt6Zcv9hSo8XE1L
	tF0B9MUe660O62wcrWpqVQVpSG2YBFo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-eJEc7YwHPO6Fm0w3y4jAig-1; Mon, 10 Feb 2025 06:02:43 -0500
X-MC-Unique: eJEc7YwHPO6Fm0w3y4jAig-1
X-Mimecast-MFC-AGG-ID: eJEc7YwHPO6Fm0w3y4jAig
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38de0201961so441354f8f.2
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 03:02:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739185363; x=1739790163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swYAcnuiVW6RK8Ul+P0fcMd3U5CHMNqoVkyi4ViV2Rw=;
        b=V1oCeEvqGPJiO5cRUF70B8Bx6R+eilvHEivET7+6pluLF8h+xgoQ1iZ85HYmC+8kr5
         VHuxnOMGj6oIsiah7rvmJ6OQlW6+5D6jh1SSFjj5PUsa8PFAp6laXwc3xxYQV04B/3wH
         BKrh75bs9288KUvkxuBv5tEkS5iLb8fjdb3jXgOg+MMHvUVcp2/Aww3ZahNMQqZWhonk
         mWari0Mm93VSne1f9GE9ulDz3gVU9Z5EQZnmVeU984kK2aFNpbR4SZxXRgdJmMmT+BX3
         g5enppS+jY4ycdGaNqmh4x2enPqIT78VhjufMkyaAlzC1fuV8aPncFomhlVSUfGaZ9Po
         XNXA==
X-Forwarded-Encrypted: i=1; AJvYcCUQPteO1OA24SUIshqlWbBf+xrhziuG4NOBmWMjEJL+zAIuqvu1BHzhJGIEbOGb59cG+a0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpa9vOSgevaxilyx/CXk8CHqag+LGgmGsmVW77zehwkUGk7jEN
	q0xNMOkda0jTqepylQYdvFP7rOw6+OFfk19Hp6VJHpsc9pP9uZRENufj3YKG52v66q+te7iFfEe
	qiWSSsaLRl3/71EI6l5lIjDqbBe2Lay/qyiWct86B6gjlgwl2HQ==
X-Gm-Gg: ASbGncsDUGA8nNMQj8mN2jmAFsJTWw5YKcoBPOyjYwnoDEF9TKNptfrIFYmLyLITNGg
	5HMCbQRwQYU/aOHoZLNYVXW2m7NsyfQBLPOv+nx0C40K6DgXI8q4EyQAty6qH45ycROM3I0AKo3
	wSAclJinG9FA1THP+TSjKmS1D7iqvRU5sPX5rI1/qPwBkga4mAXriaN+FxgRT7wM4x7YPAR4lAo
	xUuVaWHgCtXQb77BfmjkZE5745dw0JfhDwpVbLietMocI2kpiLEq3OGeBFo5jfQ5WJAu9FHyWzp
	PiGE4JJb
X-Received: by 2002:a05:6000:2ac:b0:38d:e02d:5f42 with SMTP id ffacd0b85a97d-38de02d609bmr1377018f8f.6.1739185362720;
        Mon, 10 Feb 2025 03:02:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVcih5C2q2EoxQo6V3rYfBXB/mX6hEY2CIHU/jm3irE77jPqNtIp7mAAXfge1kKv0X5WGlbw==
X-Received: by 2002:a05:6000:2ac:b0:38d:e02d:5f42 with SMTP id ffacd0b85a97d-38de02d609bmr1376986f8f.6.1739185362281;
        Mon, 10 Feb 2025 03:02:42 -0800 (PST)
Received: from leonardi-redhat ([176.206.32.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43939db5eeasm31376925e9.0.2025.02.10.03.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 03:02:41 -0800 (PST)
Date: Mon, 10 Feb 2025 12:02:38 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, mindong.zhao@samsung.com, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: [PATCH 1/2] vsock/virtio: Move rx_buf_nr and rx_buf_max_nr
 initialization position
Message-ID: <eebvrzx7zjbc326ycs3coskq5cajaoxcblp3wvcxfqaics2a2z@342wvb6zexs6>
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

Hi Junnan, Ying

Thank you for the contribution!

A few minor comments on the process:

I think this series is missing a cover letter, not all the maintainers 
have been CCd, and you should add the tag net (because it's a fix) to 
the subject. (e.g. [PATCH net 1/2]).
Here you can find some useful information[1].

[1]https://www.kernel.org/doc/html/latest/process/submitting-patches.html

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
I guess "s2r" is "suspend to resume" but is not that clear to me.

>initializing rx_buf_nr and rx_buf_max_nr,
>the rx_buf_max_nr increased to three times vq->num_free,
>at this time, in function virtio_transport_rx_work,
>the conditions to fill rx buffer
>(rx_buf_nr < rx_buf_max_nr / 2) can't be met.
>
>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>

Maybe you need a "Co-Developed-by"?

>---
> net/vmw_vsock/virtio_transport.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index b58c3818f284..9eefd0fba92b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -688,6 +688,8 @@ static void virtio_vsock_vqs_start(struct virtio_vsock *vsock)
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
>
> 	mutex_init(&vsock->tx_lock);
>-- 
>2.34.1
>

Code LGTM.

Thank you,
Luigi


