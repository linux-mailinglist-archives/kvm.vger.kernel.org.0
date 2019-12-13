Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE611DE6B
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 08:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfLMHIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 02:08:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38607 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725799AbfLMHIc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 02:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576220910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oBlv4ywWgkJYXtDeeADcPj7WCyLjtwh55MItuKZW2P0=;
        b=EBFWUdWeOh9yPc12cXkPu7i8YRaOWHj6aBmcY0CGfbiS0YeVumSmdHPnEW5S8hTeW64f4P
        R7aYpBk1taMvQrp1O4A7KYcaFgiFoRtLm1D82i+Hu2NhBuHF7reqf/R18vrPXi225JHH8w
        EmIU+AseqIZRDpXkCHvziY3LBRpha68=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-Iy2dGsTKNfeDgXO_FdlgYA-1; Fri, 13 Dec 2019 02:08:29 -0500
X-MC-Unique: Iy2dGsTKNfeDgXO_FdlgYA-1
Received: by mail-qk1-f199.google.com with SMTP id d1so854828qkk.15
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 23:08:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oBlv4ywWgkJYXtDeeADcPj7WCyLjtwh55MItuKZW2P0=;
        b=GAhNoNVhxQH+FXrpwMUCZ4825CnFYqoGUcKvFw7/AT4x+9sIY/fAZgXrDgYq6Tblqd
         C2S8NT38CS6X2BnjHGQCITaYgmoxrVTX9SfAQDsRDtnDmQbNZvlR7WCPj2R6BRL6Y4gm
         zp5S1uzIg4n7FgD8Yq8h7tgTN3SM4SEyCkDGmjfpzHC+7/Hr8Oguq0DsBhHdGC1c9fha
         PgFnigIfu1paJpMFz/3/Xtcgh2VHa4USeCtt1GH1NgDxUxueJppxrdSUQL0D4XdtyGQ2
         7ioPLP42f3fdluxwDYfePDwqrT4Jy4pgVcWy4YK50rCGQMqhJfytRvxFwgB+1mSF2/D2
         toMQ==
X-Gm-Message-State: APjAAAUuzJfp51vkDXh3yTYjnGksyFCDd1qqNHNpaOzvLdS3fUPcYpgV
        2ch1T4pHiUj0ZfvUb1S01cpiM/OHrNpralEyjkblTJIPFFpWobcDezr+QFy2Er6Hx4W8o7TnnjY
        ugJ7eQiIn43w2
X-Received: by 2002:a37:9a46:: with SMTP id c67mr12240590qke.308.1576220908597;
        Thu, 12 Dec 2019 23:08:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyt3kva4WsUrDCrBsJ2k7DQlxNrX76Ho1G+4kNuMA/uA1IN7qHBnmRB2pDTUOOR1aMxEC4LtA==
X-Received: by 2002:a37:9a46:: with SMTP id c67mr12240558qke.308.1576220908241;
        Thu, 12 Dec 2019 23:08:28 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id c20sm3186746qtc.13.2019.12.12.23.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 23:08:27 -0800 (PST)
Date:   Fri, 13 Dec 2019 02:08:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz, yang.zhang.wz@gmail.com, nitesh@redhat.com,
        konrad.wilk@oracle.com, david@redhat.com, pagupta@redhat.com,
        riel@surriel.com, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Subject: Re: [PATCH v15 6/7] virtio-balloon: Add support for providing free
 page reports to host
Message-ID: <20191213020553-mutt-send-email-mst@kernel.org>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
 <20191205162255.19548.63866.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205162255.19548.63866.stgit@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 08:22:55AM -0800, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Add support for the page reporting feature provided by virtio-balloon.
> Reporting differs from the regular balloon functionality in that is is
> much less durable than a standard memory balloon. Instead of creating a
> list of pages that cannot be accessed the pages are only inaccessible
> while they are being indicated to the virtio interface. Once the
> interface has acknowledged them they are placed back into their respective
> free lists and are once again accessible by the guest system.
> 
> Unlike a standard balloon we don't inflate and deflate the pages. Instead
> we perform the reporting, and once the reporting is completed it is
> assumed that the page has been dropped from the guest and will be faulted
> back in the next time the page is accessed.
> 
> For this reason when I had originally introduced the patch set I referred
> to this behavior as a "bubble" instead of a "balloon" since the duration
> is short lived, and when the page is touched the "bubble" is popped and
> the page is faulted back in.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>


virtio POV is fine here:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

However please copy virtio-comment on UAPI changes.
If possible isolate the last chunk in a patch by itself
to make it easier for non-kernel developers to review.

> ---
>  drivers/virtio/Kconfig              |    1 +
>  drivers/virtio/virtio_balloon.c     |   64 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_balloon.h |    1 +
>  3 files changed, 66 insertions(+)
> 
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 078615cf2afc..4b2dd8259ff5 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -58,6 +58,7 @@ config VIRTIO_BALLOON
>  	tristate "Virtio balloon driver"
>  	depends on VIRTIO
>  	select MEMORY_BALLOON
> +	select PAGE_REPORTING
>  	---help---
>  	 This driver supports increasing and decreasing the amount
>  	 of memory within a KVM guest.
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 252591bc7e01..ecd54edba968 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -19,6 +19,7 @@
>  #include <linux/mount.h>
>  #include <linux/magic.h>
>  #include <linux/pseudo_fs.h>
> +#include <linux/page_reporting.h>
>  
>  /*
>   * Balloon device works in 4K page units.  So each page is pointed to by
> @@ -47,6 +48,7 @@ enum virtio_balloon_vq {
>  	VIRTIO_BALLOON_VQ_DEFLATE,
>  	VIRTIO_BALLOON_VQ_STATS,
>  	VIRTIO_BALLOON_VQ_FREE_PAGE,
> +	VIRTIO_BALLOON_VQ_REPORTING,
>  	VIRTIO_BALLOON_VQ_MAX
>  };
>  
> @@ -114,6 +116,10 @@ struct virtio_balloon {
>  
>  	/* To register a shrinker to shrink memory upon memory pressure */
>  	struct shrinker shrinker;
> +
> +	/* Free page reporting device */
> +	struct virtqueue *reporting_vq;
> +	struct page_reporting_dev_info pr_dev_info;
>  };
>  
>  static struct virtio_device_id id_table[] = {
> @@ -153,6 +159,33 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
>  
>  }
>  
> +int virtballoon_free_page_report(struct page_reporting_dev_info *pr_dev_info,
> +				   struct scatterlist *sg, unsigned int nents)
> +{
> +	struct virtio_balloon *vb =
> +		container_of(pr_dev_info, struct virtio_balloon, pr_dev_info);
> +	struct virtqueue *vq = vb->reporting_vq;
> +	unsigned int unused, err;
> +
> +	/* We should always be able to add these buffers to an empty queue. */
> +	err = virtqueue_add_inbuf(vq, sg, nents, vb, GFP_NOWAIT | __GFP_NOWARN);
> +
> +	/*
> +	 * In the extremely unlikely case that something has occurred and we
> +	 * are able to trigger an error we will simply display a warning
> +	 * and exit without actually processing the pages.
> +	 */
> +	if (WARN_ON_ONCE(err))
> +		return err;
> +
> +	virtqueue_kick(vq);
> +
> +	/* When host has read buffer, this completes via balloon_ack */
> +	wait_event(vb->acked, virtqueue_get_buf(vq, &unused));
> +
> +	return 0;
> +}
> +
>  static void set_page_pfns(struct virtio_balloon *vb,
>  			  __virtio32 pfns[], struct page *page)
>  {
> @@ -477,6 +510,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";
>  	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
>  	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> +	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
>  
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>  		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> @@ -488,6 +522,11 @@ static int init_vqs(struct virtio_balloon *vb)
>  		callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
>  	}
>  
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +		names[VIRTIO_BALLOON_VQ_REPORTING] = "reporting_vq";
> +		callbacks[VIRTIO_BALLOON_VQ_REPORTING] = balloon_ack;
> +	}
> +
>  	err = vb->vdev->config->find_vqs(vb->vdev, VIRTIO_BALLOON_VQ_MAX,
>  					 vqs, callbacks, names, NULL, NULL);
>  	if (err)
> @@ -520,6 +559,9 @@ static int init_vqs(struct virtio_balloon *vb)
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
>  
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> +
>  	return 0;
>  }
>  
> @@ -939,12 +981,31 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  		if (err)
>  			goto out_del_balloon_wq;
>  	}
> +
> +	vb->pr_dev_info.report = virtballoon_free_page_report;
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +		unsigned int capacity;
> +
> +		capacity = virtqueue_get_vring_size(vb->reporting_vq);
> +		if (capacity < PAGE_REPORTING_CAPACITY) {
> +			err = -ENOSPC;
> +			goto out_unregister_shrinker;
> +		}
> +
> +		err = page_reporting_register(&vb->pr_dev_info);
> +		if (err)
> +			goto out_unregister_shrinker;
> +	}
> +
>  	virtio_device_ready(vdev);
>  
>  	if (towards_target(vb))
>  		virtballoon_changed(vdev);
>  	return 0;
>  
> +out_unregister_shrinker:
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> +		virtio_balloon_unregister_shrinker(vb);
>  out_del_balloon_wq:
>  	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  		destroy_workqueue(vb->balloon_wq);
> @@ -973,6 +1034,8 @@ static void virtballoon_remove(struct virtio_device *vdev)
>  {
>  	struct virtio_balloon *vb = vdev->priv;
>  
> +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +		page_reporting_unregister(&vb->pr_dev_info);
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
>  		virtio_balloon_unregister_shrinker(vb);
>  	spin_lock_irq(&vb->stop_update_lock);
> @@ -1045,6 +1108,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
>  	VIRTIO_BALLOON_F_DEFLATE_ON_OOM,
>  	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
>  	VIRTIO_BALLOON_F_PAGE_POISON,
> +	VIRTIO_BALLOON_F_REPORTING,
>  };
>  
>  static struct virtio_driver virtio_balloon_driver = {
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index a1966cd7b677..19974392d324 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -36,6 +36,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
> +#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
>  
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12

