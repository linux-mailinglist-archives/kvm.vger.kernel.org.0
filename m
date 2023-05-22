Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762F270C59E
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 21:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjEVTBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 15:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbjEVTBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 15:01:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2A2CA
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 12:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684782037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEdSZfvbZO+EhCCmXRIUmzTZEn//g4Gjj2xDSD4w9qo=;
        b=UIjyAyR6ryOf+EUUMth9bFibcW8Wr0VfiQ8kNd23fDp+12WvWQtNUeglYUdu6fg5JfGq9B
        158AmQ3FJS2c9KYm/t1uWKhIDqvZNJwjllrbcLiDMDReN7sFK15ImAzFXmgjZLnxKjJtKt
        YJSadBP2qz5wVmVG+pph3fftLbsfCrc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-vtbKpSFMNDmTuyM9O7CSsQ-1; Mon, 22 May 2023 15:00:33 -0400
X-MC-Unique: vtbKpSFMNDmTuyM9O7CSsQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3385a30067fso38994465ab.2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 12:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684782032; x=1687374032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rEdSZfvbZO+EhCCmXRIUmzTZEn//g4Gjj2xDSD4w9qo=;
        b=ItyjIV1j58tbI+m4tk0REuKuiFTBIoy+go+wqfRrGrxM3cldIOcCtrdcLFBsqmvI03
         iLF1SbrnmXNaF7GNnyXSjTVQNXO7HM5N6+caGZkZr+Z5LDWDGyYrSnIdSqPTdhTNVBjm
         zYdUuZEywPJPS9ZuCqlSQyWEQLZLSYqKo6dUbXoigpf77YZPUDjLL74i8iVoI6u+6Bch
         W0zc2uzqkHZy0rlNo6tKNkH1XT2ZXMr2tj/Lal4fwHuQec55MZ5opXmvGDjWtfvB56dk
         SjMkDtU5hj+i2gAVogbbaYwXm1AyJ7itd2Nfpr9bSoltBgAjTtMOIm4DzkMueqC1SV98
         /aMQ==
X-Gm-Message-State: AC+VfDwcrrMhLgyb0kvslmS4PZsb2onkn5+1s3jsINnRH8GlBvj3p1TN
        hNqVXEVVmlEmoIR9PNz3BE02O8kxiZU8D89G5NtgdAEq8xr/z/+v3wxWHf3Clff8ahtdTlwcZkl
        s5LZXv3SiozXW
X-Received: by 2002:a92:c70e:0:b0:335:38b:e734 with SMTP id a14-20020a92c70e000000b00335038be734mr6587201ilp.28.1684782032346;
        Mon, 22 May 2023 12:00:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7YQ+ECS6de+PurjamzC27suSNV0n/CZhf01g4wobY35E8M9AaSfoteJFN3ptWeCzMGLKW7/A==
X-Received: by 2002:a92:c70e:0:b0:335:38b:e734 with SMTP id a14-20020a92c70e000000b00335038be734mr6587179ilp.28.1684782032004;
        Mon, 22 May 2023 12:00:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id do16-20020a0566384c9000b0041abd81975bsm1882825jab.153.2023.05.22.12.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 12:00:31 -0700 (PDT)
Date:   Mon, 22 May 2023 13:00:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.tian@intel.com, jgg@nvidia.com,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] vfio/type1: check pfn valid before converting to
 struct page
Message-ID: <20230522130030.44c6c5c2.alex.williamson@redhat.com>
In-Reply-To: <20230519065843.10653-1-yan.y.zhao@intel.com>
References: <20230519065843.10653-1-yan.y.zhao@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 May 2023 14:58:43 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> Check physical PFN is valid before converting the PFN to a struct page
> pointer to be returned to caller of vfio_pin_pages().
> 
> vfio_pin_pages() pins user pages with contiguous IOVA.
> If the IOVA of a user page to be pinned belongs to vma of vm_flags
> VM_PFNMAP, pin_user_pages_remote() will return -EFAULT without returning
> struct page address for this PFN. This is because usually this kind of PFN
> (e.g. MMIO PFN) has no valid struct page address associated.
> Upon this error, vaddr_get_pfns() will obtain the physical PFN directly.
> 
> While previously vfio_pin_pages() returns to caller PFN arrays directly,
> after commit
> 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()"),
> PFNs will be converted to "struct page *" unconditionally and therefore
> the returned "struct page *" array may contain invalid struct page
> addresses.
> 
> Given current in-tree users of vfio_pin_pages() only expect "struct page *
> returned, check PFN validity and return -EINVAL to let the caller be
> aware of IOVAs to be pinned containing PFN not able to be returned in
> "struct page *" array. So that, the caller will not consume the returned
> pointer (e.g. test PageReserved()) and avoid error like "supervisor read
> access in kernel mode".
> 
> Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
> Cc: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> 
> ---
> v2: update commit message to explain background/problem clearly. (Sean)
> ---
>  drivers/vfio/vfio_iommu_type1.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 493c31de0edb..0620dbe5cca0 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -860,6 +860,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  		if (ret)
>  			goto pin_unwind;
>  
> +		if (!pfn_valid(phys_pfn)) {

Why wouldn't we use our is_invalid_reserved_pfn() test here?  Doing
so would also make it more consistent why we don't need to call
put_pfn() or rewind accounting for this page.  Thanks,

Alex

> +			ret = -EINVAL;
> +			goto pin_unwind;
> +		}
> +
>  		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
>  		if (ret) {
>  			if (put_pfn(phys_pfn, dma->prot) && do_accounting)
> 
> base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac

