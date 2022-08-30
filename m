Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E975A5D8A
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 10:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiH3IAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 04:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbiH3H7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 03:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AE2D2771
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 00:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661846377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCfrLsUUliFZAsT7cuTFQ+KKBb55P+r5AzSlUp1Nkos=;
        b=YGrFVMlaAkw+NBUw8cfQgpuVZI62rugemmdZN7GOQ1FOuQ8ImEvXg748uHB2+AGHa5mORR
        9LZtN10QkQ2zyFP918lNLXk7zRz2o3RXx5/ltTjmbuU8E8uam+6rBFAsDoCKSSTddauuE6
        KktHpDLrMxq/yy6YoZQGUAqSBndoBxw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-cEvAzmeDNc2_1VNdLsDCXQ-1; Tue, 30 Aug 2022 03:59:36 -0400
X-MC-Unique: cEvAzmeDNc2_1VNdLsDCXQ-1
Received: by mail-wm1-f70.google.com with SMTP id j3-20020a05600c1c0300b003a5e72421c2so422911wms.1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 00:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=KCfrLsUUliFZAsT7cuTFQ+KKBb55P+r5AzSlUp1Nkos=;
        b=OaAkWzHLYtt2bDIrFSHLVIMQoyYI21aDzaCDstglgM5NxZW2iIKIYvPqJY5QgLKHDC
         LcPUdavmQt0h/1qzMcv1vFtTMmhoPck8+t0gYloWzc2J2pTYrHt+REE2u2rQDYPakGIg
         OYV1bqT1tTNUw6YgUtcb1rtYlNIAGj6W5TGWWTBkL9+OCXOYeC5Df+vV47BfDSdIIF06
         aQ7DmJDPxuMKr1VjgjLWnxjXJfJTGPArSiCiV7l1aF4SWZyhNJRPVQFyljxPhRFL9qRw
         CmOWUTGqWbX4XCcsflKgkVMaM6dNi3VxJeyDgjzBRGNRfqiuW2YftIijjYGjQKBhlENM
         5Nmg==
X-Gm-Message-State: ACgBeo2x7wKhprplGTRLb7UTgvcbSURDxmQyA1/LTUCstbDo5nEZD9Av
        2vPsgljcfXgFa4carKuZeNNydsZeoSYA2XXtVk5QaJ88xoFpHrAxnKnsYwlje3djTb0/MyD7I09
        TxG/MHq7Apsw9
X-Received: by 2002:a05:600c:1992:b0:3a6:23f6:8417 with SMTP id t18-20020a05600c199200b003a623f68417mr8373208wmq.14.1661846374817;
        Tue, 30 Aug 2022 00:59:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6G+HNENoZbk/kP0Upti13ajYwcNsvPHgO3ZJjPM9lTCEmTs9Are0AGapPE11SllUCzKZrfKw==
X-Received: by 2002:a05:600c:1992:b0:3a6:23f6:8417 with SMTP id t18-20020a05600c199200b003a623f68417mr8373198wmq.14.1661846374508;
        Tue, 30 Aug 2022 00:59:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:1000:ecb4:919b:e3d3:e20b? (p200300cbc70a1000ecb4919be3d3e20b.dip0.t-ipconnect.de. [2003:cb:c70a:1000:ecb4:919b:e3d3:e20b])
        by smtp.gmail.com with ESMTPSA id l14-20020a05600c4f0e00b003a83d5f3678sm11136280wmq.7.2022.08.30.00.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 00:59:34 -0700 (PDT)
Message-ID: <39145649-c378-d027-8856-81b4f09050fc@redhat.com>
Date:   Tue, 30 Aug 2022 09:59:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lpivarc@redhat.com
References: <166182871735.3518559.8884121293045337358.stgit@omen>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <166182871735.3518559.8884121293045337358.stgit@omen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.08.22 05:05, Alex Williamson wrote:
> There's currently a reference count leak on the zero page.  We increment
> the reference via pin_user_pages_remote(), but the page is later handled
> as an invalid/reserved page, therefore it's not accounted against the
> user and not unpinned by our put_pfn().
> 
> Introducing special zero page handling in put_pfn() would resolve the
> leak, but without accounting of the zero page, a single user could
> still create enough mappings to generate a reference count overflow.
> 
> The zero page is always resident, so for our purposes there's no reason
> to keep it pinned.  Therefore, add a loop to walk pages returned from
> pin_user_pages_remote() and unpin any zero pages.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: stable@vger.kernel.org
> Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index db516c90a977..8706482665d1 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -558,6 +558,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>  	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
>  				    pages, NULL, NULL);
>  	if (ret > 0) {
> +		int i;
> +
> +		/*
> +		 * The zero page is always resident, we don't need to pin it
> +		 * and it falls into our invalid/reserved test so we don't
> +		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
> +		 */
> +		for (i = 0 ; i < ret; i++) {
> +			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
> +				unpin_user_page(pages[i]);
> +		}
> +
>  		*pfn = page_to_pfn(pages[0]);
>  		goto done;
>  	}
> 
> 

As discussed offline, for the shared zeropage (that's not even
refcounted when mapped into a process), this makes perfect sense to me.

Good question raised by Sean if ZONE_DEVICE pages might similarly be
problematic. But for them, we cannot simply always unpin here.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

