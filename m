Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2951434D8A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfFDQdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:33:40 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45286 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbfFDQdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:33:40 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so17825356ioc.12;
        Tue, 04 Jun 2019 09:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFDCs9ixPwmop20pIDVV+hNZcExzVIIYIAvpTPqNIqM=;
        b=cx9qF2XoM0ItvPLKYrfQK/oiAqbik/wsSMBvAMrHL8fu8Fx/K523FWLP62Taq5dCW+
         GeVE1uM0MXw54dG4FfQpsBSSfIqJt+BeDwEtP+TaTJsYOGWnVZaxK6WHMMZEiIQCr7c1
         29YRdE5YPlokMDEIYL8ZBSnQ9QFPiJckpS2Wm8iIFdCBR0HfTI2T0TOimv6v4CP1imSF
         sOro/P3hwPspStkLZljA33Ma0X+9ae5JeNqKCeX5SHWY6K1oJDWZaC3n5E0+gY6UeDRI
         PFhuNkiD8tQcLaUt1Hocggi8IY4A2cYLgXOSolXgPJu2RHVtQPEIXlj/1p468yO7GvqA
         grtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFDCs9ixPwmop20pIDVV+hNZcExzVIIYIAvpTPqNIqM=;
        b=RjSBrSLlWd71CTKBLx1tRwJ2fZPW9aCCvTqr7pGXc0UTy/VP72CPSfww569TTD5TKg
         UJUULe+2cDWBb5tZNvlQAxZwg4eK4UhDhZbc5liiZUTTTThzOfOcYB5cVA/9p87xAhTe
         0aFebzWmVwp0XmESznMQEEcZICnGCfHTcnSbCVpMBI2SyCGLQbzSWoaS5Ou/etXCTaNB
         OEULfdJPkiBwttK05xzcnASUs+XqEI8A0sNJgWWoeR62S1m8bNVXqOxUA8VZkJFYudJo
         C0E+jSIQ8Ve3nfWEwZQaDirCBMEfMGdm2sTGbF2mTLEmKj/6M2nl2vfwIBISFRNkRjeT
         i18g==
X-Gm-Message-State: APjAAAVWjSZ2YqbDrD+kfrFlb/4g9vGh6xVrrR8kyUXnSzb6s9g4ULMj
        8ndliXqGjYm9lFIfO9pIl+z8GcvZ3Pb9u3CCOrA=
X-Google-Smtp-Source: APXvYqwJ2HUxS4FKK1XU93wJyd+x/7qURmSpYcNyYnkbHrNeudxQf8vE6jo+0sLFKE/Co6I3WhWb6ZA1CNw3cpjacA4=
X-Received: by 2002:a6b:901:: with SMTP id t1mr14703305ioi.42.1559666019686;
 Tue, 04 Jun 2019 09:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603170306.49099-3-nitesh@redhat.com>
In-Reply-To: <20190603170306.49099-3-nitesh@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 4 Jun 2019 09:33:28 -0700
Message-ID: <CAKgT0UeRkG0FyESjjQQWeOs3x2O=BUzFYZAdDkjjLyXRiJMnCQ@mail.gmail.com>
Subject: Re: [RFC][Patch v10 2/2] virtio-balloon: page_hinting: reporting to
 the host
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 3, 2019 at 10:04 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Enables the kernel to negotiate VIRTIO_BALLOON_F_HINTING feature with the
> host. If it is available and page_hinting_flag is set to true, page_hinting
> is enabled and its callbacks are configured along with the max_pages count
> which indicates the maximum number of pages that can be isolated and hinted
> at a time. Currently, only free pages of order >= (MAX_ORDER - 2) are
> reported. To prevent any false OOM max_pages count is set to 16.
>
> By default page_hinting feature is enabled and gets loaded as soon
> as the virtio-balloon driver is loaded. However, it could be disabled
> by writing the page_hinting_flag which is a virtio-balloon parameter.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c     | 112 +++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_balloon.h |  14 ++++
>  2 files changed, 125 insertions(+), 1 deletion(-)

<snip>

> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index a1966cd7b677..25e4f817c660 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -29,6 +29,7 @@
>  #include <linux/virtio_types.h>
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
> +#include <linux/page_hinting.h>

So this include breaks the build and from what I can tell it isn't
really needed. I deleted it in order to be able to build without
warnings about the file not being included in UAPI.

>  /* The feature bitmap for virtio balloon */
>  #define VIRTIO_BALLOON_F_MUST_TELL_HOST        0 /* Tell before reclaiming pages */
> @@ -36,6 +37,7 @@
>  #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM        2 /* Deflate balloon on OOM */
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT        3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON   4 /* Guest is using page poisoning */
> +#define VIRTIO_BALLOON_F_HINTING       5 /* Page hinting virtqueue */
>
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> @@ -108,4 +110,16 @@ struct virtio_balloon_stat {
>         __virtio64 val;
>  } __attribute__((packed));
>
> +#ifdef CONFIG_PAGE_HINTING
> +/*
> + * struct hinting_data- holds the information associated with hinting.
> + * @phys_add:  physical address associated with a page or the array holding
> + *             the array of isolated pages.
> + * @size:      total size associated with the phys_addr.
> + */
> +struct hinting_data {
> +       __virtio64 phys_addr;
> +       __virtio32 size;
> +};
> +#endif
>  #endif /* _LINUX_VIRTIO_BALLOON_H */
> --
> 2.21.0
>
