Return-Path: <kvm+bounces-11515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB41877C60
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 10:15:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9D61C20F0A
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 09:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88ED8199AD;
	Mon, 11 Mar 2024 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfrQxIV6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287A17BB2
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 09:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710148501; cv=none; b=nqNm7hVXU6gLc0nn/oMlGZCYbi61586bAeVGgh+G5PSxHfvhI+PUB60XIQAfsnZZGmv6sc5gfrvxPQGcsBwm0W7N8h5Eup+NiZzI5HNYOu92swPvG3WXmt0Ziw6nyS4U9eiBYzt9WIBthsOMNQxptrWfoMuPPslaJuftZ59Jgtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710148501; c=relaxed/simple;
	bh=dTmP7n59FaCUQQ3ImK3x9jf1hCqcfHxKJ2ZB9x5NqCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gh84XTNRZZPmaeaofMIkPzPcdTyEHCBgHmYGSqcqps0ylR02pp7017QHMbQzeb0LaUlaPdqxhDybcVsSjvkfvEMMeJfgdoRVcWLJEzGZ0wWyY07zVXrrHDXcPeJ8ASQJb6LMxF8yaXhL6gyZJ+NOnJtUEm8hNHvvRrInV/ZjOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfrQxIV6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710148497;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k643lTHeRSqr4QYf+RtUFasbXAmnhk9kZSa7ujrmtgQ=;
	b=BfrQxIV6nxtbCHttEkuCPaG3AUuI6wiKCZRp6fWzDTmGfBjq0IQVWKXRORRWeKUEFoQCCA
	QKUoYA9qBfgrV1JPb16oIP3upsAtS3WlfZNOcDIexBAF/IbB9jYLJxFEqpP4F26QAQENu3
	U6kIGRFNVIRgexg5xQf5K8DEu3XXzDE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-5kWtPZlcN56eFcgM6iy0IQ-1; Mon, 11 Mar 2024 05:14:55 -0400
X-MC-Unique: 5kWtPZlcN56eFcgM6iy0IQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-41312d583dfso17059165e9.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 02:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710148493; x=1710753293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k643lTHeRSqr4QYf+RtUFasbXAmnhk9kZSa7ujrmtgQ=;
        b=QWi3nT1MA8aSHWwo2XMMjXOe3KmUteQ5dykJCCknCjc2ClZaCWrTLExKroxpIZMxGd
         vgS8unZz+fB8fh6ND/Ierm8LsvtnCiBsMOInu0L6wT3kn6o/sHjx54Ww7bdtHpoLmpon
         BalDhWz1K1vGiIiAPve5Zg9tidviIbVZN6JrsRYec86+JoKNSLMV5MVnihjDvsAjJFv9
         QiRVWG/x3th/EVbG94ykzgCUu1bO4ohmD29KXSuggrDm+x4UNQceSiPHZNF1n+MHefa9
         U3JCzGvi+BjxmzOIO384ny/dzlWeRuOP1udjsGum0//GNYlEJKze3AsxCB95Oor6HvWE
         QvdQ==
X-Gm-Message-State: AOJu0YyEa8syuBHJGGGDR7LqO+grkQSmr/0MrwjacdG/h1kQNrkdGmXa
	ktjFqQi+pql7MGp5AdmAzYJk03jS/QdVwpcdLEBqarwdLrFUTU476s7hnKkMmWOK9ASOKxwrET7
	2P+Tu5UdGcnijcGZuW4AINCL/71Z7aGV69Ox8f13TBc3p0J7wcFoe+fHkOQ==
X-Received: by 2002:a05:600c:3ac9:b0:413:2ab0:8305 with SMTP id d9-20020a05600c3ac900b004132ab08305mr974919wms.13.1710148493511;
        Mon, 11 Mar 2024 02:14:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrobxE7nSHH4f78nQxa+KpCMwCWrli005wc4GIi67hGLEZz82HkSrLQfxBBbBqOHWRKOZGFQ==
X-Received: by 2002:a05:600c:3ac9:b0:413:2ab0:8305 with SMTP id d9-20020a05600c3ac900b004132ab08305mr974909wms.13.1710148493278;
        Mon, 11 Mar 2024 02:14:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c4f8400b00412ff941abasm14934328wmq.21.2024.03.11.02.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 02:14:52 -0700 (PDT)
Message-ID: <e14204f8-5c25-4130-952b-d5a31edc015f@redhat.com>
Date: Mon, 11 Mar 2024 10:14:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 3/7] vfio: Introduce interface to flush virqfd inject
 workqueue
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, clg@redhat.com, reinette.chatre@intel.com,
 linux-kernel@vger.kernel.org, kevin.tian@intel.com
References: <20240308230557.805580-1-alex.williamson@redhat.com>
 <20240308230557.805580-4-alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240308230557.805580-4-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/9/24 00:05, Alex Williamson wrote:
> In order to synchronize changes that can affect the thread callback,
> introduce an interface to force a flush of the inject workqueue.  The
> irqfd pointer is only valid under spinlock, but the workqueue cannot
> be flushed under spinlock.  Therefore the flush work for the irqfd is
> queued under spinlock.  The vfio_irqfd_cleanup_wq workqueue is re-used
> for queuing this work such that flushing the workqueue is also ordered
> relative to shutdown.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/virqfd.c | 21 +++++++++++++++++++++
>  include/linux/vfio.h  |  2 ++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
> index 29c564b7a6e1..532269133801 100644
> --- a/drivers/vfio/virqfd.c
> +++ b/drivers/vfio/virqfd.c
> @@ -101,6 +101,13 @@ static void virqfd_inject(struct work_struct *work)
>  		virqfd->thread(virqfd->opaque, virqfd->data);
>  }
>  
> +static void virqfd_flush_inject(struct work_struct *work)
> +{
> +	struct virqfd *virqfd = container_of(work, struct virqfd, flush_inject);
> +
> +	flush_work(&virqfd->inject);
> +}
> +
>  int vfio_virqfd_enable(void *opaque,
>  		       int (*handler)(void *, void *),
>  		       void (*thread)(void *, void *),
> @@ -124,6 +131,7 @@ int vfio_virqfd_enable(void *opaque,
>  
>  	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
>  	INIT_WORK(&virqfd->inject, virqfd_inject);
> +	INIT_WORK(&virqfd->flush_inject, virqfd_flush_inject);
>  
>  	irqfd = fdget(fd);
>  	if (!irqfd.file) {
> @@ -213,3 +221,16 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
>  	flush_workqueue(vfio_irqfd_cleanup_wq);
>  }
>  EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
> +
> +void vfio_virqfd_flush_thread(struct virqfd **pvirqfd)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&virqfd_lock, flags);
> +	if (*pvirqfd && (*pvirqfd)->thread)
> +		queue_work(vfio_irqfd_cleanup_wq, &(*pvirqfd)->flush_inject);
> +	spin_unlock_irqrestore(&virqfd_lock, flags);
> +
> +	flush_workqueue(vfio_irqfd_cleanup_wq);
> +}
> +EXPORT_SYMBOL_GPL(vfio_virqfd_flush_thread);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 89b265bc6ec3..8b1a29820409 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -356,6 +356,7 @@ struct virqfd {
>  	wait_queue_entry_t		wait;
>  	poll_table		pt;
>  	struct work_struct	shutdown;
> +	struct work_struct	flush_inject;
>  	struct virqfd		**pvirqfd;
>  };
>  
> @@ -363,5 +364,6 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
>  		       void (*thread)(void *, void *), void *data,
>  		       struct virqfd **pvirqfd, int fd);
>  void vfio_virqfd_disable(struct virqfd **pvirqfd);
> +void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
>  
>  #endif /* VFIO_H */


