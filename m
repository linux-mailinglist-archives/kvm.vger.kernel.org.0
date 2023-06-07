Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7287269FB
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjFGTlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjFGTl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:41:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0380F1FF7
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686166843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbU25VUQynMT3slsK2/nQ+8fSGgRHVMsd4tx/DGJLfQ=;
        b=Kj0s+6dHW9CfuFXQAz8r3xm5TeAIJLNP5gNuvwJvaAaTqfZuABH/c7YszVOl9ykH0hcMML
        YdL041P6B5jOIEGyS75G9XKj3VEqV3LEq/5VUQY1PBp8v6QnWPuXwuaihgi7G9DnXvUco/
        92gd3bAsueT2UhbJpK0TcCCDqxEmOnw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-txfuTHszOHmnWJu1prbUgA-1; Wed, 07 Jun 2023 15:40:39 -0400
X-MC-Unique: txfuTHszOHmnWJu1prbUgA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33bbffccf69so13617395ab.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686166839; x=1688758839;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xbU25VUQynMT3slsK2/nQ+8fSGgRHVMsd4tx/DGJLfQ=;
        b=bMH7dyzKMOo1N9DQiGvmTTk2US0CKh43VF3haC+tnTFLD6UJabBNiekuWAA68bp1qk
         B/31J3evAXTV8pWs+48Goc6b7RvtPthpSr4e0WTHFLzYJouTSb4N1CnGBag8LVMaxQw+
         Y6abH+6mOlUZy/y7Wy+P5OKRHxLmtpiPQjBwEIkdHeqrSW7+WlP/7/4wPmsVRYO+1USs
         Cjg5kDz7M8QEGAZmlYxBbSqCP0IKETajMPugCDThnXC7kj9t1wE/wWKI1a4Y6zAXLD6R
         wF2Qqd5hT1+eNrem/IKmIVmGY6IEMrhzXgmuXJWPGPsGYeJoNbks54H+e4X1mmR646C4
         suOQ==
X-Gm-Message-State: AC+VfDwrb3Fuj5EYruMf0CzNJFjMaCVdpOf4Y5dBtjPUfUjTK00cFkOz
        UT+fdM7p7dwH5kFKj0fx+l8EwSTeGV9wPj1v7wbMRDqNp4S6DMhwQS4Fg4b25J6NU+C8hcQ6sOu
        7qRJwq6QdKeBb
X-Received: by 2002:a92:cd09:0:b0:33a:efd3:add3 with SMTP id z9-20020a92cd09000000b0033aefd3add3mr9827693iln.14.1686166839106;
        Wed, 07 Jun 2023 12:40:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ686iaUSEVIw2mng9KjfEMkG2q1AoxviyUpqCStb+u2fAzpVxvjPUUf6+ZQ/LNPk7il5eN1Zw==
X-Received: by 2002:a92:cd09:0:b0:33a:efd3:add3 with SMTP id z9-20020a92cd09000000b0033aefd3add3mr9827681iln.14.1686166838890;
        Wed, 07 Jun 2023 12:40:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n12-20020a92d9cc000000b0032f240a0802sm3849063ilq.48.2023.06.07.12.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 12:40:38 -0700 (PDT)
Date:   Wed, 7 Jun 2023 13:40:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        khalid.aziz@oracle.com
Subject: Re: [PATCH] vfio/iommu_type1: acquire iommu lock in
 vfio_iommu_type1_release()
Message-ID: <20230607134037.6d81e288.alex.williamson@redhat.com>
In-Reply-To: <20230607190752.216801-1-sidhartha.kumar@oracle.com>
References: <20230607190752.216801-1-sidhartha.kumar@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Jun 2023 12:07:52 -0700
Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:

> From vfio_iommu_type1_release() there is a code path:
> 
> vfio_iommu_unmap_unpin_all()
>  vfio_remove_dma()
>     vfio_unmap_unpin()
>       unmap_unpin_slow()
>         vfio_unpin_pages_remote()
>           vfio_find_vpfn()
> 
> This path is taken without acquiring the iommu lock so it could lead to
> a race condition in the traversal of the pfn_list rb tree.

What's the competing thread for the race, vfio_remove_dma() tests:

	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));

The fix is not unreasonable, but is this a theoretical fix upstream
that's tickled by some downstream additions, or are we actually
competing against page pinning by an mdev driver after the container is
released?  Thanks,

Alex

> The lack of
> the iommu lock in vfio_iommu_type1_release() was confirmed by adding a
> 
> WARN_ON(!mutex_is_locked(&iommu->lock))
> 
> which was reported in dmesg. Fix this potential race by adding a iommu
> lock and release in vfio_iommu_type1_release().
> 
> Suggested-by: Khalid Aziz <khalid.aziz@oracle.com>
> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 306e6f1d1c70e..7d2fea1b483dc 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2601,7 +2601,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
>  		kfree(group);
>  	}
>  
> +	mutex_lock(&iommu->lock);
>  	vfio_iommu_unmap_unpin_all(iommu);
> +	mutex_unlock(&iommu->lock);
>  
>  	list_for_each_entry_safe(domain, domain_tmp,
>  				 &iommu->domain_list, next) {

