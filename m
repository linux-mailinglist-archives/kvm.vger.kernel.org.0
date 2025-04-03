Return-Path: <kvm+bounces-42580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FFB2A7A32D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0640E7A5F0D
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 12:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4587624E00F;
	Thu,  3 Apr 2025 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixRK5UJD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761424CED7
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 12:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743685060; cv=none; b=uYCbhkgqTn7CGPE9u+C4ax6I7/rv3fOwqqCH7g++0vAruqZsvUkGmGJO+XORvwkr2fRPVyNkOuidjRkLp0lm2iQXelifjjRROKoQW1MzlsofKZsAcRk/lFWfc7iaTqZi6hS9ART7aMa/LtrwRvOakIzB+uIGCfEya9CizZ+ZZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743685060; c=relaxed/simple;
	bh=h6upok2UNXu6a8hbwBmkOZ2QnnvGNGbvXHfvfrECD7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIr4dn3zte2TVUhXy8bGNcnQOZZYzztzdah7ubRydfw9wmN3a1V8Ii9V76LvQ+bjendNdZfJzwrWS424PP0QyeBcKBDfnAoq/KzR9i1TsV+3ovjb9TMXsGohL793jA/nt7F+GiYbYEPskeLGaEFTz3Va7SQj7I7hFk+1sxuM9nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixRK5UJD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743685056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=07cCSo2B9aIbwxRVd8sNELEM0nr6NT8ZeyBNS30RCy8=;
	b=ixRK5UJDxtngDfasRUo/HRtLyEu5fQ8CvlOdV8I6TMUW7gakpFgtWFEb1Fa9ZB/tllB6ad
	aEoryZzHhwSTpPX0Ls94MdnCcmizuCLIQVjqEOU7KohSfOGZ83n1EXxvU5QLxMsgcnztOd
	sHfb3PEpinVF82wzIx0JOfCrs5tCZAk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-H4b4OF6YNXu7DbwDXTFM4A-1; Thu, 03 Apr 2025 08:57:34 -0400
X-MC-Unique: H4b4OF6YNXu7DbwDXTFM4A-1
X-Mimecast-MFC-AGG-ID: H4b4OF6YNXu7DbwDXTFM4A_1743685052
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4394c489babso4582455e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 05:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743685052; x=1744289852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07cCSo2B9aIbwxRVd8sNELEM0nr6NT8ZeyBNS30RCy8=;
        b=wuqQ4YkYSAje0ysBEpUiMtArV77OJZkscEIMhi9aEjupRctxHrut0LTxRbhMySu+Rx
         RBdWAvtGUJnji8iUzSYskkS8g1BXtXPT0NFQlSds7nAIp0rS6whloaENb20wqByCNPLS
         ZoUYMEk+3Ui5rp/rehO4APjip5eyGVYRBJjF+cZxxDKNCvleIen6gYibhgrKfofIgQ4c
         pI+r7YNJC6YZ4VefSX19zNT5IsT6iXBcwgVwunDga2WLc2e5SkciFQfJvlniaEa+pPCI
         SrGV++i0PrLecjvIbZR537gJckYZ2/5F+qnauHSHXPABOjVTWfpBnGXDfPn5cfecgwa+
         jIOA==
X-Forwarded-Encrypted: i=1; AJvYcCVKkSQysKmDRGz6U8RUTL0UnoWqF8iyT97PPom95c5LD4ulBzC/KcK+UPfb1TwAvFAfbcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQpaOe1wuFLtlKud6a3E1nkz6F/bbfWWE0VOM89jCEBB/iabDv
	LgoO5bYyj84+gCEWAegKCo+3yaOh1nDN9SrFtiqhXRfrY1BbNqNvyaKMq7oV5uoRY4B2Adf9xxo
	CYYpMCBadOFCn6AlzPpOZtp29FKq4oYx9kOfy/sU2Qzm1Bx9m4w==
X-Gm-Gg: ASbGncs3qJ610XfHA1PZlHkz7bXTB0iQz2W6n17jLLkcGTgj2Ox0HtyWpxL9lWQGBLk
	gYNbEz0yILbybzy/rrrwyeAOVKgGuG0bxvhLIWU/edqWcvdMRgDBXU+1c9hRaLh9LsdDi0NJNUS
	o0frJEQYo1BKMypE/6Vy1RcaYiz/PfYOmPZBI2D/+TnMLnQ0VAYYq2oM6FUFwHQIJclJHHYqQJ7
	PrB4s8qFMofLc7jxrJo2jFh12oqXXmHZN2ZNRkJ2oRWqmpk47hBxqeWeZTuIMvnZNusCMHTxA+g
	EO7iHZk1Zw==
X-Received: by 2002:a05:600c:4708:b0:43d:7588:667b with SMTP id 5b1f17b1804b1-43ec139b6admr28421745e9.10.1743685052164;
        Thu, 03 Apr 2025 05:57:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFj3KdFXqOkrApLxIkl3uzI14klWQC5RUU1qjAJxrr83aJQ/gFpzH2cPz5OLOhh6nW1riyB2Q==
X-Received: by 2002:a05:600c:4708:b0:43d:7588:667b with SMTP id 5b1f17b1804b1-43ec139b6admr28421515e9.10.1743685051709;
        Thu, 03 Apr 2025 05:57:31 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34be2f4sm17636075e9.19.2025.04.03.05.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 05:57:31 -0700 (PDT)
Date: Thu, 3 Apr 2025 08:57:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
	Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250403085637-mutt-send-email-mst@kernel.org>
References: <20250402203621.940090-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402203621.940090-1-david@redhat.com>

On Wed, Apr 02, 2025 at 10:36:21PM +0200, David Hildenbrand wrote:
> If we finds a vq without a name in our input array in
> virtio_ccw_find_vqs(), we treat it as "non-existing" and set the vq pointer
> to NULL; we will not call virtio_ccw_setup_vq() to allocate/setup a vq.
> 
> Consequently, we create only a queue if it actually exists (name != NULL)
> and assign an incremental queue index to each such existing queue.
> 
> However, in virtio_ccw_register_adapter_ind()->get_airq_indicator() we
> will not ignore these "non-existing queues", but instead assign an airq
> indicator to them.
> 
> Besides never releasing them in virtio_ccw_drop_indicators() (because
> there is no virtqueue), the bigger issue seems to be that there will be a
> disagreement between the device and the Linux guest about the airq
> indicator to be used for notifying a queue, because the indicator bit
> for adapter I/O interrupt is derived from the queue index.
> 
> The virtio spec states under "Setting Up Two-Stage Queue Indicators":
> 
> 	... indicator contains the guest address of an area wherein the
> 	indicators for the devices are contained, starting at bit_nr, one
> 	bit per virtqueue of the device.
> 
> And further in "Notification via Adapter I/O Interrupts":
> 
> 	For notifying the driver of virtqueue buffers, the device sets the
> 	bit in the guest-provided indicator area at the corresponding
> 	offset.
> 
> For example, QEMU uses in virtio_ccw_notify() the queue index (passed as
> "vector") to select the relevant indicator bit. If a queue does not exist,
> it does not have a corresponding indicator bit assigned, because it
> effectively doesn't have a queue index.
> 
> Using a virtio-balloon-ccw device under QEMU with free-page-hinting
> disabled ("free-page-hint=off") but free-page-reporting enabled
> ("free-page-reporting=on") will result in free page reporting
> not working as expected: in the virtio_balloon driver, we'll be stuck
> forever in virtballoon_free_page_report()->wait_event(), because the
> waitqueue will not be woken up as the notification from the device is
> lost: it would use the wrong indicator bit.
> 
> Free page reporting stops working and we get splats (when configured to
> detect hung wqs) like:
> 
>  INFO: task kworker/1:3:463 blocked for more than 61 seconds.
>        Not tainted 6.14.0 #4
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  task:kworker/1:3 [...]
>  Workqueue: events page_reporting_process
>  Call Trace:
>   [<000002f404e6dfb2>] __schedule+0x402/0x1640
>   [<000002f404e6f22e>] schedule+0x3e/0xe0
>   [<000002f3846a88fa>] virtballoon_free_page_report+0xaa/0x110 [virtio_balloon]
>   [<000002f40435c8a4>] page_reporting_process+0x2e4/0x740
>   [<000002f403fd3ee2>] process_one_work+0x1c2/0x400
>   [<000002f403fd4b96>] worker_thread+0x296/0x420
>   [<000002f403fe10b4>] kthread+0x124/0x290
>   [<000002f403f4e0dc>] __ret_from_fork+0x3c/0x60
>   [<000002f404e77272>] ret_from_fork+0xa/0x38
> 
> There was recently a discussion [1] whether the "holes" should be
> treated differently again, effectively assigning also non-existing
> queues a queue index: that should also fix the issue, but requires other
> workarounds to not break existing setups.
> 
> Let's fix it without affecting existing setups for now by properly ignoring
> the non-existing queues, so the indicator bits will match the queue
> indexes.
> 
> [1] https://lore.kernel.org/all/cover.1720611677.git.mst@redhat.com/
> 
> Fixes: a229989d975e ("virtio: don't allocate vqs when names[i] = NULL")
> Reported-by: Chandra Merla <cmerla@redhat.com>
> Cc: <Stable@vger.kernel.org>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Wei Wang <wei.w.wang@intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


feel free to merge.

> ---
>  drivers/s390/virtio/virtio_ccw.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 21fa7ac849e5c..4904b831c0a75 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -302,11 +302,17 @@ static struct airq_info *new_airq_info(int index)
>  static unsigned long *get_airq_indicator(struct virtqueue *vqs[], int nvqs,
>  					 u64 *first, void **airq_info)
>  {
> -	int i, j;
> +	int i, j, queue_idx, highest_queue_idx = -1;
>  	struct airq_info *info;
>  	unsigned long *indicator_addr = NULL;
>  	unsigned long bit, flags;
>  
> +	/* Array entries without an actual queue pointer must be ignored. */
> +	for (i = 0; i < nvqs; i++) {
> +		if (vqs[i])
> +			highest_queue_idx++;
> +	}
> +
>  	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
>  		mutex_lock(&airq_areas_lock);
>  		if (!airq_areas[i])
> @@ -316,7 +322,7 @@ static unsigned long *get_airq_indicator(struct virtqueue *vqs[], int nvqs,
>  		if (!info)
>  			return NULL;
>  		write_lock_irqsave(&info->lock, flags);
> -		bit = airq_iv_alloc(info->aiv, nvqs);
> +		bit = airq_iv_alloc(info->aiv, highest_queue_idx + 1);
>  		if (bit == -1UL) {
>  			/* Not enough vacancies. */
>  			write_unlock_irqrestore(&info->lock, flags);
> @@ -325,8 +331,10 @@ static unsigned long *get_airq_indicator(struct virtqueue *vqs[], int nvqs,
>  		*first = bit;
>  		*airq_info = info;
>  		indicator_addr = info->aiv->vector;
> -		for (j = 0; j < nvqs; j++) {
> -			airq_iv_set_ptr(info->aiv, bit + j,
> +		for (j = 0, queue_idx = 0; j < nvqs; j++) {
> +			if (!vqs[j])
> +				continue;
> +			airq_iv_set_ptr(info->aiv, bit + queue_idx++,
>  					(unsigned long)vqs[j]);
>  		}
>  		write_unlock_irqrestore(&info->lock, flags);
> -- 
> 2.48.1


