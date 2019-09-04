Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE06A924D
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfIDT2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 15:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfIDT2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 15:28:51 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B839820260
        for <kvm@vger.kernel.org>; Wed,  4 Sep 2019 19:28:50 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id h18so23934583qto.18
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 12:28:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yjhFuNGCVVnCVt6KGmnRVbp0O4Ubgc+nm3QiXx2UytM=;
        b=BKG4C+Y0ZcWzHRK6+L+WPsiUDKUpZJg4JGBDzp7vgQ05VObrJxwAo+Lh3OLfWP/HdZ
         Di5188bqnwv+AywW6iT8afYpMXdHqgxSeQJ27Uvi+70iG/a5iw32kBCeMurPDyVGkVEo
         7JOm7+5nYMEeIUmwKf0syVMDB8dOIyDoaLYsQjlZTg6PfCWttyBdZnB6b9/o7fvA777c
         dYXe892OxybHqionECtD/jMhSLEJ9uJ+xOuIM6LMIv/+i6R2S00ZWm2lfTtrqeVZ4rVH
         o//J75JUph7ymb7+Jwqws7E/LZF0VZdeOthnvjWaszxNH5XTP8czKUyNE7mtPYcr65Rb
         qOAg==
X-Gm-Message-State: APjAAAX+bhHb11LBtycD+themmm8JlsPNIBvgsqAkSLfw2+dONiZ+Cs1
        rZl/Cg9m24PhLY+2tiQNx7eKbuh6WAPcBIgXASfxobs11WKnVP+e1AK7MrDlEhSJW8mPliRAo8k
        l8KIZ0ja4t5lm
X-Received: by 2002:a37:6789:: with SMTP id b131mr26895334qkc.314.1567625330115;
        Wed, 04 Sep 2019 12:28:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyTcr7UOJ02wFSH/Lm77j8LHfMvnSXy+Cmzc6fLXR0bnU9M8nbYOhGrXWD3d2+DWPFbWpj1zA==
X-Received: by 2002:a37:6789:: with SMTP id b131mr26895315qkc.314.1567625329847;
        Wed, 04 Sep 2019 12:28:49 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id c137sm3451372qkg.110.2019.09.04.12.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 12:28:48 -0700 (PDT)
Date:   Wed, 4 Sep 2019 15:28:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        dave.hansen@intel.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, virtio-dev@lists.oasis-open.org,
        osalvador@suse.de, yang.zhang.wz@gmail.com, pagupta@redhat.com,
        riel@surriel.com, konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v7 5/6] virtio-balloon: Pull page poisoning config out of
 free page hinting
Message-ID: <20190904152244-mutt-send-email-mst@kernel.org>
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
 <20190904151055.13848.27351.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904151055.13848.27351.stgit@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 08:10:55AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Currently the page poisoning setting wasn't being enabled unless free page
> hinting was enabled. However we will need the page poisoning tracking logic
> as well for unused page reporting. As such pull it out and make it a
> separate bit of config in the probe function.
> 
> In addition we can actually wrap the code in a check for NO_SANITY. If we
> don't care what is actually in the page we can just default to 0 and leave
> it there.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/virtio/virtio_balloon.c |   19 +++++++++++++------
>  mm/page_reporting.c             |    4 ++++
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 226fbb995fb0..2c19457ab573 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -842,7 +842,6 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
>  static int virtballoon_probe(struct virtio_device *vdev)
>  {
>  	struct virtio_balloon *vb;
> -	__u32 poison_val;
>  	int err;
>  
>  	if (!vdev->config->get) {
> @@ -909,11 +908,19 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  						  VIRTIO_BALLOON_CMD_ID_STOP);
>  		spin_lock_init(&vb->free_page_list_lock);
>  		INIT_LIST_HEAD(&vb->free_page_list);
> -		if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
> -			memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> -			virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> -				      poison_val, &poison_val);
> -		}
> +	}
> +	if (virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
> +		__u32 poison_val = 0;
> +
> +#if !defined(CONFIG_PAGE_POISONING_NO_SANITY)
> +		/*
> +		 * Let hypervisor know that we are expecting a specific
> +		 * value to be written back in unused pages.
> +		 */
> +		memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> +#endif
> +		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> +			      poison_val, &poison_val);
>  	}
>  	/*
>  	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a

I'm a bit confused by this part. Should we not just clear
VIRTIO_BALLOON_F_PAGE_POISON completely?

In my mind the value written should be what guest puts in
free pages - and possibly what it expects to find there later.

If it doesn't expect anything there then it makes sense
to clear VIRTIO_BALLOON_F_PAGE_POISON so that host does
not try to put the poison value there.
But I think that it does not make sense to lie to host about the poison
value - I think that if we do send poison value to
host it's reasonable for host to expect free pages
have that value - and even possibly to validate that.

So I think that the hack belongs in virtballoon_validate,
near the page_poisoning_enabled check.



> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 5006b08d5eec..35c0fe4c4471 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -299,6 +299,10 @@ int page_reporting_startup(struct page_reporting_dev_info *phdev)
>  	struct zone *zone;
>  	int err = 0;
>  
> +	/* No point in enabling this if it cannot handle any pages */
> +	if (!phdev->capacity)
> +		return -EINVAL;
> +
>  	mutex_lock(&page_reporting_mutex);
>  
>  	/* nothing to do if already in use */
