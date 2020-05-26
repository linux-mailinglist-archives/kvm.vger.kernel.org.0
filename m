Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8BD1E2E45
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 21:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391275AbgEZT2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391202AbgEZT2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 15:28:18 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73119C03E96D;
        Tue, 26 May 2020 12:28:18 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d7so1844518lfi.12;
        Tue, 26 May 2020 12:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrcGKTg+lKbJyhERjQv/zxn6Uu3KQSzIsUaJsnqYfyc=;
        b=mTkq7n/TLagy92SuI0VEMoZ+njzOoBXS3XFdNx+YwnbU81pmdX2Ju15JrHVkneV9qx
         qARhi4X9mjfzmHxel+9an7U36kJB3aTUiz3doUi+JtR4oz8L/f5yh9N2Y5MxNaeUCeCk
         cXzBlrzk6+NqpPDzyavPqj+S86CYNetEb09h7uvzxyHA3eO7nB+nfAKE/IG5Gc9cJ9sG
         Z/S78wDM29J2TUIWxlO2ErzKrn45YNlGTqK8p05LdbEHjDv7DBykL0s8Z7wCxG4gQSS1
         /nWv9cjA4yhq49kCJrqc3LBQkw37at5A28Y3oA/Ozp2p/OsY9Ah8UVgomYWFzc4Znr3V
         lp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrcGKTg+lKbJyhERjQv/zxn6Uu3KQSzIsUaJsnqYfyc=;
        b=GvhYi3eSLClZQl5iCsItLdbaQD5Lvi3z1664T2bk1S6v7AxIBQKeYJXSzjjB/qGZdd
         dWBErGDvC8qwikkpd7VRyO+qxHS9b+4ItfdUsUbLCXQ6k442TM08fQ1cbBjXoL/i6I00
         R67Zv+SvWzQGQ5YAT7oBPA5zPp+ad9dPk0guUlmQCzcn4p+qNog8lmPYuLbsOLoCWR1l
         U3Am+bgR1j1LdsJTWpv9MzNH1EVcgtH0yJGJXwoJh2hPbuOs3MD31ThGpl1INZZ2ifck
         otVosijEOquYNUKlM09Bz87JrIdRS1oTI9BeZkPGuS4G13duv8HKweSq/WsIDyW0f2ld
         pqbQ==
X-Gm-Message-State: AOAM530vV2amv/VgqkHFO4WZkbiOpOxFzlqoFRD9YjwfAYNPpGzAQGAc
        D6EJIbu5Ly9N7Q72XLKqPqAURVE0yaKWmSuGbBU=
X-Google-Smtp-Source: ABdhPJzzgZIK9MYtnILHFWXqommHhyqNi1MobdmTz+W3sHVTlNfIdxpWNgsxv2PqOGLjN4V1MfBjjwFESNwU5fLaa+8=
X-Received: by 2002:ac2:53a2:: with SMTP id j2mr1167787lfh.139.1590521296780;
 Tue, 26 May 2020 12:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200523014347.193290-1-jhubbard@nvidia.com>
In-Reply-To: <20200523014347.193290-1-jhubbard@nvidia.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 27 May 2020 00:58:05 +0530
Message-ID: <CAFqt6zYmYQ93jbKNAjDpiH7exjyGv8E-2xHW++yV5CiYMyL5ew@mail.gmail.com>
Subject: Re: [PATCH 1/1] vfio/spapr_tce: convert get_user_pages() --> pin_user_pages()
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi John,

On Sat, May 23, 2020 at 7:13 AM John Hubbard <jhubbard@nvidia.com> wrote:
>
> This code was using get_user_pages*(), in a "Case 2" scenario
> (DMA/RDMA), using the categorization from [1]. That means that it's
> time to convert the get_user_pages*() + put_page() calls to
> pin_user_pages*() + unpin_user_pages() calls.
>
> There is some helpful background in [2]: basically, this is a small
> part of fixing a long-standing disconnect between pinning pages, and
> file systems' use of those pages.
>
> [1] Documentation/core-api/pin_user_pages.rst
>
> [2] "Explicit pinning of user-space pages":
>     https://lwn.net/Articles/807108/
>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>
> Hi,
>
> I'm compile-tested this, but am not able to run-time test, so any
> testing help is much appreciated!
>
> thanks,
> John Hubbard
> NVIDIA
>
>  drivers/vfio/vfio_iommu_spapr_tce.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 16b3adc508db..fe888b5dcc00 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -383,7 +383,7 @@ static void tce_iommu_unuse_page(struct tce_container *container,
>         struct page *page;
>
>         page = pfn_to_page(hpa >> PAGE_SHIFT);
> -       put_page(page);
> +       unpin_user_page(page);
>  }
>
>  static int tce_iommu_prereg_ua_to_hpa(struct tce_container *container,
> @@ -486,7 +486,7 @@ static int tce_iommu_use_page(unsigned long tce, unsigned long *hpa)
>         struct page *page = NULL;
>         enum dma_data_direction direction = iommu_tce_direction(tce);
>
> -       if (get_user_pages_fast(tce & PAGE_MASK, 1,
> +       if (pin_user_pages_fast(tce & PAGE_MASK, 1,
>                         direction != DMA_TO_DEVICE ? FOLL_WRITE : 0,
>                         &page) != 1)
>                 return -EFAULT;

There are few places where nr_pages is passed as 1 to get_user_pages_fast().
With similar conversion those will be changed to pin_user_pages_fast().

Does it make sense to add an inline like - pin_user_page_fast(), similar to
get_user_page_fast_only() ( now merged in linux-next) ?
