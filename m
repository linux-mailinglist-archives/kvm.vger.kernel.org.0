Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63E2569273
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiGFTPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiGFTPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 15:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BF54237CC
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 12:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657134901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fe2Xwz5G0SOLEGSbWZeizefklyOtEuVCF/HmgAiG5W8=;
        b=NOClT1bnzEoubqinkjt6Ke9Hy9ieDcOFJAa9+eIkZtytdYPX5DzL7JLmT+cAaJ4pjlKykF
        fl+oAzh3mgqJxfa6ODwvoNtEewtRYT1q6meLl4XpvrNWJgenXRz4+7G//CPgLCvxs2q/DA
        Q0VXi75W0gnaP8Mag0SyxWpp7onrTsY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-QKprkdCsNtSh16LqRem9ZQ-1; Wed, 06 Jul 2022 15:15:00 -0400
X-MC-Unique: QKprkdCsNtSh16LqRem9ZQ-1
Received: by mail-il1-f199.google.com with SMTP id i2-20020a056e021d0200b002d8ff49e7c4so8085024ila.8
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 12:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fe2Xwz5G0SOLEGSbWZeizefklyOtEuVCF/HmgAiG5W8=;
        b=QLT2+XJF5/p8UNYn5mIGy7gRHuiG/5yC3QQwyRlT8xOKBpml84e2g18iJfacMnCFeu
         //+wDrWnzWN2IEGZuqY/q0OGP4VANoh3e1ICqcZHDZEB0p3u2ZAaosvT4qTClFNC4xFY
         lYqD/1CQbZo42gQK9qjkC5HlBEWV9DrW1SoNgFNZxY45Pw9sSp/igHhQBUkySZ2hgp2R
         px1DxyN8PBTH0iPsdynGTDnXM6JJTwYujKQ6NM/Gz3HRtTXEiJkKxxJXtdg5qCWpSU+z
         9XfB3IzxIiMMl1RYEAETrWdszwJ4+f95NMjvZ+z4JxXJ2gD7lCsSNsUxSUtGFXYXIUCh
         Exng==
X-Gm-Message-State: AJIora9JdxhgYNg4VRH+UIMQ+J7F76w744nIqNTEwsP/aBVqDjulnMCY
        29iE+l181WJOWhpoyoKHQL6W714IucgSnzuvpLzzqk62z6h/ySt9q1u9oMl+2S7EClxV03qFFXJ
        IfYCxvz93Rg8B
X-Received: by 2002:a05:6638:f81:b0:33c:5393:c0ff with SMTP id h1-20020a0566380f8100b0033c5393c0ffmr25986099jal.231.1657134899820;
        Wed, 06 Jul 2022 12:14:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uU5DNOvzd0f8YLcM9RN/fjk8aTWDGW1pdOba6lI2hg5z6GFsfHePI/n1aNOqFJfFXMJ9bwLg==
X-Received: by 2002:a05:6638:f81:b0:33c:5393:c0ff with SMTP id h1-20020a0566380f8100b0033c5393c0ffmr25986091jal.231.1657134899640;
        Wed, 06 Jul 2022 12:14:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g93-20020a028566000000b003319a68d2f5sm16176468jai.125.2022.07.06.12.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 12:14:58 -0700 (PDT)
Date:   Wed, 6 Jul 2022 13:14:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Deming Wang <wangdeming@inspur.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] vfio/spapr_tce: Remove the unused parameters container
Message-ID: <20220706131456.3c08c2b7.alex.williamson@redhat.com>
In-Reply-To: <20220702064613.5293-1-wangdeming@inspur.com>
References: <20220702064613.5293-1-wangdeming@inspur.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2 Jul 2022 02:46:13 -0400
Deming Wang <wangdeming@inspur.com> wrote:

> The parameter of container has been unused for tce_iommu_unuse_page.
> So, we should delete it.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

I'll give Alexey a chance to ack this, but agree that it seems this arg
has never had any purpose.  Perhaps a debugging remnant.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 708a95e61831..ea3d17a94e94 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -378,8 +378,7 @@ static void tce_iommu_release(void *iommu_data)
>  	kfree(container);
>  }
>  
> -static void tce_iommu_unuse_page(struct tce_container *container,
> -		unsigned long hpa)
> +static void tce_iommu_unuse_page(unsigned long hpa)
>  {
>  	struct page *page;
>  
> @@ -474,7 +473,7 @@ static int tce_iommu_clear(struct tce_container *container,
>  			continue;
>  		}
>  
> -		tce_iommu_unuse_page(container, oldhpa);
> +		tce_iommu_unuse_page(oldhpa);
>  	}
>  
>  	iommu_tce_kill(tbl, firstentry, pages);
> @@ -524,7 +523,7 @@ static long tce_iommu_build(struct tce_container *container,
>  		ret = iommu_tce_xchg_no_kill(container->mm, tbl, entry + i,
>  				&hpa, &dirtmp);
>  		if (ret) {
> -			tce_iommu_unuse_page(container, hpa);
> +			tce_iommu_unuse_page(hpa);
>  			pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
>  					__func__, entry << tbl->it_page_shift,
>  					tce, ret);
> @@ -532,7 +531,7 @@ static long tce_iommu_build(struct tce_container *container,
>  		}
>  
>  		if (dirtmp != DMA_NONE)
> -			tce_iommu_unuse_page(container, hpa);
> +			tce_iommu_unuse_page(hpa);
>  
>  		tce += IOMMU_PAGE_SIZE(tbl);
>  	}

