Return-Path: <kvm+bounces-19680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4559B908DA6
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EACF61F244F0
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C8BD10A0D;
	Fri, 14 Jun 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJftpeaU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EC8EAE5
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376014; cv=none; b=Ryyb1EjEojqyzI01F1cGXmuVnRwfdyS88ZrkhtkwWOvBVlfcAq10sP3GKNwhQokyxGnsveUGKLRVWfOeaJaq0p5a7zQm5okSJP1FCBHBtCqjZYQ3HyuV2dr2iGavch6qGUmBY0ozkpdnncn7mlPvZqgd+aszcOTyuCTM4Zff8oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376014; c=relaxed/simple;
	bh=V+j0eTBGfNMTjfAN5fGbwz4kgOLveZl9pdrHD3yNXXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgYP827Q9wsCXPGti94ipdE7Yd76WnmQrNO3JNHAjEpir57Qp/1oeU9AxiQsB4GOLKt/eS/v+glzb8wNa9mE7m2dWaB59A107bCMnIcLYBYeprUFtUJJp/Dxba70fVyuqJQoNuO3u8gX2pUY7GHffSkCVTjClG1rrgI4lyNpEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJftpeaU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718376011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qt5NcoDJbY+6/rjcnHVm1O4k+qFDbB1MVLu9nqhSjFs=;
	b=YJftpeaU95fEI+KyXSthC50JQTqHHzfhggwykE1/tZo4GSH4ezD32crAe/+9g7kmMS2iYw
	XJ1o6/hwLM3U5y9HWXK69XmX5bNvqLB4jJNC1h/d4meGcrS1Rrn+ptDb2KOYt2A+jkkewy
	cdKQRPK/dxHJhcPugN5vWLZlQ34rLRY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-vS-gkHk3NkaJHHW8XxurKA-1; Fri, 14 Jun 2024 10:40:10 -0400
X-MC-Unique: vS-gkHk3NkaJHHW8XxurKA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52c091e4413so2102652e87.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 07:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718376008; x=1718980808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qt5NcoDJbY+6/rjcnHVm1O4k+qFDbB1MVLu9nqhSjFs=;
        b=LxqjBtxhmS8n6ttkKcBgQJLV1k72Bj3SQg1DXpQhkuVCSo3XDlIysE4dFcVl/tshWA
         p8NkorSoDBWB0qdQc0Y6vf7s7r9SbcqfWYhLPnQl8UhI4pmhLfV+b0L7r5yw7oQzUq6V
         Yb4utosVHxXLoaIDDKz/s07smsQmzroMq2sUx64g5oFf3jU4vPp0ZSTqFuaisNcEYe1I
         y08MC12VZ4/SKyv0Mrbytk3Yuicc7VZpSvDHfUKtdVrIQPDhX9RxfkCweCS+PxhS4bef
         IWjdh8ZLx9cS5RaXo0kxdP6DwhdCAwLyq5CQ1S/7z9jlJkU+ZXC7G9Gcv1ORCsqlOT3d
         BHNw==
X-Forwarded-Encrypted: i=1; AJvYcCV2L+p+J/HYJUp9OcLLPUiR6jrxK8Q/S7u93HlrMjb9uebEkoQOKXz8l46AR2riJi63aIJQ/zvCg3phUVhH5PadSDL3
X-Gm-Message-State: AOJu0Yy/nBgFyj6Bp9CGmke1WPkLSyqU7boBkXcLWlfLnvBpOpXzDtWM
	DXGpW2zCfz1OfC3dH8z0Wc40Zl8MM63PIYgYKUBmUJ3pblk5ap0zGpdCIas5GNEgV9CzicN5PTi
	E4XI+k+kGC/KJtNWzycCbpkP7d01vSABd2jMAKQLJW2Nw6Surnw==
X-Received: by 2002:a19:e014:0:b0:52c:98b1:36d9 with SMTP id 2adb3069b0e04-52ca6e9da28mr2241957e87.62.1718376008742;
        Fri, 14 Jun 2024 07:40:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEX3v8Wn+67KK53vRvZL7N4S0NTRO/vH3/5y85IBEbKT1mz68C2tnhNAWikvnfX+3y8Ft3XvQ==
X-Received: by 2002:a19:e014:0:b0:52c:98b1:36d9 with SMTP id 2adb3069b0e04-52ca6e9da28mr2241946e87.62.1718376008400;
        Fri, 14 Jun 2024 07:40:08 -0700 (PDT)
Received: from sgarzare-redhat ([147.229.117.1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed39ddsm196069566b.142.2024.06.14.07.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 07:40:07 -0700 (PDT)
Date: Fri, 14 Jun 2024 16:40:03 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>
Cc: edumazet@google.com, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org, stefanha@redhat.com, 
	pabeni@redhat.com, davem@davemloft.net
Subject: Re: [PATCH net-next 0/2] vsock: avoid queuing on workqueue if
 possible
Message-ID: <mfhi5is5533xyt4nlbpifrg6mpx3rye4n4vfg736irsae5tfx6@2aiorapp2uos>
References: <AS2P194MB2170EB1827729FB1666311FA9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AS2P194MB2170EB1827729FB1666311FA9AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>

On Fri, Jun 14, 2024 at 03:55:41PM GMT, Luigi Leonardi wrote:
>This patch series introduces an optimization for vsock/virtio to reduce latency:
>When the guest sends a packet to the host, and the workqueue is empty,
>if there is enough space, the packet is put directly in the virtqueue.

Thanks for working on this!!

I left few small comments.
I'm at DevConf this weekend, so I'll do a better review and some testing
next week.

Stefano

>
>The first one contains some code refactoring.
>More details and some performance tests in the second patch.
>
>Marco Pinna (2):
>  vsock/virtio: refactor virtio_transport_send_pkt_work
>  vsock/virtio: avoid enqueue packets when work queue is empty
>
> net/vmw_vsock/virtio_transport.c | 166 +++++++++++++++++++------------
> 1 file changed, 104 insertions(+), 62 deletions(-)
>
>-- 
>2.45.2
>


