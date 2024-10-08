Return-Path: <kvm+bounces-28117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75822994128
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:21:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 994181C21A5D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 08:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B3D1DFD87;
	Tue,  8 Oct 2024 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="So5Z7XkR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313D61D27BA
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728373677; cv=none; b=koA0YM+N7fcxTnC5Mlkt7ro9N8Wm5mw/Z2/uF2i2H5dgYYczxpPLhr9gmhmNUgU6S8cWzrauamo76vJ1wpbW6f8ACEGnS30DZE5Hrxlkw7BKjsh1wI/FqHwgH37JHp1zQyPoA/WHlt5VP+9bWcf+hshwv+nd7RSWVVwe6TIsoiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728373677; c=relaxed/simple;
	bh=KacrONSbhmhewewU/gu315ddq3zC0RufrWewYF0miNY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FZKadqD4f8T5TjiBrhLcn78z8L8XzKMN4w7pMIdciWgp3UZ6uHjpBRWnrAJ5FYo25p24waN3LzndNk4VdReHtPeuFop6nKVe9llct1NtH44dk9n7b5XVs86gE1BhhuSRkvL2z6hDw6IHBnTZOaMe06DqOkuuQW2pRZ2jK8LoEiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=So5Z7XkR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728373673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ccukHkwtjpL6eSJNhCykeUOWCFvXciXd/kKxvlhDKa4=;
	b=So5Z7XkRYIAHpElAcpO2msSiGTJtPqWx2PH92F3WYIt9eY/dsr2Z8mw3fTAQzgSSsEJOLR
	4YFpgTThxdZvn8ySRkEw+zW9eSUxTN0GFYgOFGaqtlCG9IUdh4TA9a46xKJSNb9653BqME
	CXpmnMiK6TVJcqI04sTjuxmMLNgArN0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-RWXDJytLM_OChWXcv1J20w-1; Tue,
 08 Oct 2024 03:47:49 -0400
X-MC-Unique: RWXDJytLM_OChWXcv1J20w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 082621954B1F;
	Tue,  8 Oct 2024 07:47:47 +0000 (UTC)
Received: from localhost (dhcp-192-244.str.redhat.com [10.33.192.244])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 063EF19560A7;
	Tue,  8 Oct 2024 07:47:44 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Halil Pasic <pasic@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Robin Murphy
 <robin.murphy@arm.com>, Ulf Hansson <ulf.hansson@linaro.org>,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/virtio_ccw: fix dma_parm pointer not set up
In-Reply-To: <20241007201030.204028-1-pasic@linux.ibm.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20241007201030.204028-1-pasic@linux.ibm.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Tue, 08 Oct 2024 09:47:40 +0200
Message-ID: <87set7qbmr.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Oct 07 2024, Halil Pasic <pasic@linux.ibm.com> wrote:

> At least since commit 334304ac2bac ("dma-mapping: don't return errors
> from dma_set_max_seg_size") setting up device.dma_parms is basically
> mandated by the DMA API. As of now Channel (CCW) I/O in general does not
> utilize the DMA API, except for virtio. For virtio-ccw however the
> common virtio DMA infrastructure is such that most of the DMA stuff
> hinges on the virtio parent device, which is a CCW device.
>
> So lets set up the dma_parms pointer for the CCW parent device and hope
> for the best!
>
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 334304ac2bac ("dma-mapping: don't return errors from dma_set_max_seg_size")
> Reported-by: "Marc Hartmayer" <mhartmay@linux.ibm.com>
> Closes: https://bugzilla.linux.ibm.com/show_bug.cgi?id=209131
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> ---
>
> In the long run it may make sense to move dma_parms into struct
> ccw_device, since layering-wise it is much cleaner. I decided
> to put it in virtio_ccw_device because currently it is only used for
> virtio.

Yes, ccw_device would make more sense as a resting place; no idea what
other devices (dasd, QDIO based, ...) would do with it ATM -- I agree
that if adding it to virtio_ccw_device get things going again, we should
do that and consider the possible generic case later.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

[I assume this one can be picked up together with other s390 patches?]

>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 62eca9419ad7..21fa7ac849e5 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -58,6 +58,8 @@ struct virtio_ccw_device {
>  	struct virtio_device vdev;
>  	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
>  	struct ccw_device *cdev;
> +	/* we make cdev->dev.dma_parms point to this */
> +	struct device_dma_parameters dma_parms;
>  	__u32 curr_io;
>  	int err;
>  	unsigned int revision; /* Transport revision */
> @@ -1303,6 +1305,7 @@ static int virtio_ccw_offline(struct ccw_device *cdev)
>  	unregister_virtio_device(&vcdev->vdev);
>  	spin_lock_irqsave(get_ccwdev_lock(cdev), flags);
>  	dev_set_drvdata(&cdev->dev, NULL);
> +	cdev->dev.dma_parms = NULL;
>  	spin_unlock_irqrestore(get_ccwdev_lock(cdev), flags);
>  	return 0;
>  }
> @@ -1366,6 +1369,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
>  	}
>  	vcdev->vdev.dev.parent = &cdev->dev;
>  	vcdev->cdev = cdev;
> +	cdev->dev.dma_parms = &vcdev->dma_parms;
>  	vcdev->dma_area = ccw_device_dma_zalloc(vcdev->cdev,
>  						sizeof(*vcdev->dma_area),
>  						&vcdev->dma_area_addr);
>
> base-commit: 87d6aab2389e5ce0197d8257d5f8ee965a67c4cd


