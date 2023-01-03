Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6564765C546
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbjACRod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbjACRob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:44:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037DBE27
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672767823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jO6Zl402uF1R5RJR+aDfFIjsGFP/yqalvVW+NL65RNM=;
        b=A09Foso3tZUCqMiNJZcMvg6dYytvjYOxsUthAoTAdI0r5uCJbJX9X1X6BMllHg7/WLh1R6
        Iwpnc/SLNOW6gdqWsGLaHapoVwJiYHPgWBZywnYd8XROKOMeJl8lrXydigiTKWFQ4wzHYj
        Ru3aAVsMN4hoac1XFhV691LUpYCk21o=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-uPlXUiy3M-yscl37Kdya1Q-1; Tue, 03 Jan 2023 12:43:42 -0500
X-MC-Unique: uPlXUiy3M-yscl37Kdya1Q-1
Received: by mail-io1-f69.google.com with SMTP id u24-20020a6be918000000b006ed1e9ad302so8768718iof.22
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:43:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jO6Zl402uF1R5RJR+aDfFIjsGFP/yqalvVW+NL65RNM=;
        b=TsxTlJ9D+5ODtmFMuRfcbZ0pW7fJQsbt+SSiAzWvFmINdJdc9e47PKidw6Yv3pSiOy
         HBERAwoMGuxewmybqAiARYvixkGoC0oBzGjM1Oisn6DvKF1w+jVG5ozAH0ipjgWoAqZa
         HAVoLqnnW3Xxy5MttaQNiYxER9KEARgzDjcpyp0WCNTgr0/LYV6+XHU2TWrSsdij5RXx
         Sthc5/2+mVG2gRmCQBcikPH0BLUR6/EzNK1SZvUBtwbS/yLaJq0vzld5UnEqvYJb6ulW
         qN2WDAfT1FdZ3wHby0UCjzLO1Gnp9UUg0vy/TAE5sUeuWtm2oAh2+XuKCASh80bniMJz
         8uSg==
X-Gm-Message-State: AFqh2kpnW9jsVPWnuXdMd5sRUgUrQcA4ESaZmi9j+C95KQ48ri7cYrL2
        GYdQ1Vxg1fgcSJZKUtBDYqRxVVrXj7yXtfGQuvpar7nFXucCo11cwvnoViEpW4Dj3YlPx7Lj2aF
        jLhIKP3g/4Ilo
X-Received: by 2002:a6b:6310:0:b0:6d6:4daf:623f with SMTP id p16-20020a6b6310000000b006d64daf623fmr27685232iog.6.1672767821067;
        Tue, 03 Jan 2023 09:43:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXum1NkGfbp5wP/yTi/4H0MnD8Iv6ksddlNLbXCBrWU4pLdAWOiz5nI4pkUUR+nGBnIUSJw+7A==
X-Received: by 2002:a6b:6310:0:b0:6d6:4daf:623f with SMTP id p16-20020a6b6310000000b006d64daf623fmr27685220iog.6.1672767820803;
        Tue, 03 Jan 2023 09:43:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r6-20020a02aa06000000b00389b6c71347sm10422648jam.60.2023.01.03.09.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:43:40 -0800 (PST)
Date:   Tue, 3 Jan 2023 10:43:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shachar Raindel <shacharr@google.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Convert backwards goto into a while loop
Message-ID: <20230103104338.4371e012.alex.williamson@redhat.com>
In-Reply-To: <20221228213212.628636-1-shacharr@google.com>
References: <20221228213212.628636-1-shacharr@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Dec 2022 21:32:12 +0000
Shachar Raindel <shacharr@google.com> wrote:

> The function vaddr_get_pfns used a goto retry structure to implement
> retrying.  This is discouraged by the coding style guide (which is
> only recommending goto for handling function exits). Convert the code
> to a while loop, making it explicit that the follow block only runs
> when the pin attempt failed.

What coding style guide are you referring to?  In
Documentation/process/coding-style.rst I only see goto mentioned in 7)
Centralized exiting of functions, which suggests it's a useful
mechanism for creating centralized cleanup code, while noting "[a]lbeit
deprecated by *some people*", emphasis added.  This doesn't suggest to
me such a strong statement as implied in this commit log.
 
> Signed-off-by: Shachar Raindel <shacharr@google.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c index 23c24fe98c00..7f38d7fc3f62
> 100644 --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -570,27 +570,28 @@ static int vaddr_get_pfns(struct mm_struct *mm,
> unsigned long vaddr, }
>  
>  		*pfn = page_to_pfn(pages[0]);
> -		goto done;
> -	}
> +	} else

Coding style would however discourage skipping the braces around this
half of the branch, as done here, as a) they're used around the former
half and b) the below is not a single simple statement.  Thanks,

Alex

> +		do {
> +
> +			/* This is not a normal page, lookup PFN for P2P DMA */
> +			vaddr = untagged_addr(vaddr);
>  
> -	vaddr = untagged_addr(vaddr);
> +			vma = vma_lookup(mm, vaddr);
>  
> -retry:
> -	vma = vma_lookup(mm, vaddr);
> +			if (!vma || !(vma->vm_flags & VM_PFNMAP))
> +				break;
>  
> -	if (vma && vma->vm_flags & VM_PFNMAP) {
> -		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> -		if (ret == -EAGAIN)
> -			goto retry;
> +			ret = follow_fault_pfn(vma, mm, vaddr, pfn,
> +					       prot & IOMMU_WRITE);
> +			if (ret)
> +				continue; /* Retry for EAGAIN, otherwise bail */
>  
> -		if (!ret) {
>  			if (is_invalid_reserved_pfn(*pfn))
>  				ret = 1;
>  			else
>  				ret = -EFAULT;
> -		}
> -	}
> -done:
> +		} while (ret == -EAGAIN);
> +
>  	mmap_read_unlock(mm);
>  	return ret;
>  }

