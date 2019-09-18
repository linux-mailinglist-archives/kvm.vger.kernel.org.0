Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB348B6A1C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 19:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfIRR7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 13:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfIRR7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 13:59:06 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F08442BF02
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 17:59:05 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id g16so913494qtq.15
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 10:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=95uHNXLpbAw8Te8P7uq0ffZGCmMKa4Edsq7nRG4mv4c=;
        b=LIbsVsw1JLomGKw1cYLbwVH77detjchNX92AVO521iUIaW8vnMtzW+IsiXbAKSXQEC
         GH0Mcu1AnHGgU1876jA5OxqUnYiqui2C1NzhZjST730P9H+xdrfeO4O6z129+0vVqVNT
         E3m8SIQKlonoSUbY/azMSbj9DbZgLbOcuCcpPtKftAL5n9A5d3VF9uXKikpaBgmd8QIX
         7xBEOd5/tatooiS6CFP9Ae9qJUdn3/U0j6JiCl3Oyb0hfqwNw71IE0QnmJQmTpXAUjyO
         v7YLa8NS4jpfjvIgmPPHxtGn7fdcr3IRFFrXB4Ch92JERpRZBEDXZfvquOHR1P2Ayl7M
         gVXg==
X-Gm-Message-State: APjAAAXi9tZb1nrof99OOfcPKixaswazydBj/2adnKS3SqmXYy9gcKKn
        mIvXLELGQHd0DQOQdG9BpobcsitGklE+SL97k5jW4Nbsk+lDFp7Uel/ry8EYB8Q7YqlbGLs2Kuk
        YqzpNgAa7K3Ou
X-Received: by 2002:ac8:7b2a:: with SMTP id l10mr5571351qtu.115.1568829545307;
        Wed, 18 Sep 2019 10:59:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwp4kWwOScH3+FsPGYP96mLuwlTyG0LsIAHV0yLqSSN4DKzmnPp2MGayN7dp76k/rTEPpJp8A==
X-Received: by 2002:ac8:7b2a:: with SMTP id l10mr5571319qtu.115.1568829545135;
        Wed, 18 Sep 2019 10:59:05 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id q126sm3855323qkf.47.2019.09.18.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 10:59:04 -0700 (PDT)
Date:   Wed, 18 Sep 2019 13:58:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        linux-arm-kernel@lists.infradead.org, osalvador@suse.de,
        yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH v10 5/6] virtio-balloon: Pull page poisoning config out
 of free page hinting
Message-ID: <20190918135833-mutt-send-email-mst@kernel.org>
References: <20190918175109.23474.67039.stgit@localhost.localdomain>
 <20190918175305.23474.34783.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918175305.23474.34783.stgit@localhost.localdomain>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 10:53:05AM -0700, Alexander Duyck wrote:
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
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

I think this one can go in directly. Do you want me to merge it now?

> ---
>  drivers/virtio/virtio_balloon.c |   22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 226fbb995fb0..501a8d0ebf86 100644
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
> @@ -909,11 +908,18 @@ static int virtballoon_probe(struct virtio_device *vdev)
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
> +		__u32 poison_val;
> +
> +		/*
> +		 * Let the hypervisor know that we are expecting a
> +		 * specific value to be written back in unused pages.
> +		 */
> +		memset(&poison_val, PAGE_POISON, sizeof(poison_val));
> +
> +		virtio_cwrite(vb->vdev, struct virtio_balloon_config,
> +			      poison_val, &poison_val);
>  	}
>  	/*
>  	 * We continue to use VIRTIO_BALLOON_F_DEFLATE_ON_OOM to decide if a
> @@ -1014,7 +1020,9 @@ static int virtballoon_restore(struct virtio_device *vdev)
>  
>  static int virtballoon_validate(struct virtio_device *vdev)
>  {
> -	if (!page_poisoning_enabled())
> +	/* Tell the host whether we care about poisoned pages. */
> +	if (IS_ENABLED(CONFIG_PAGE_POISONING_NO_SANITY) ||
> +	    !page_poisoning_enabled())
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
>  
>  	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
