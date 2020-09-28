Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF1F27B0F6
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 17:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgI1PcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 11:32:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgI1PcF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 11:32:05 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601307124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=beL9t0gk7ZluU92hP0lHlD3fOLIAiTCYRCjZ8keb7lA=;
        b=JE2VGOYIAP1M+Y8QkhqXCfvDL8Xz6Xyvd1lcK8MyXjKuAUuJq2kICBiABnBFgW2RqvD26A
        yUg0Umg4cgmkDxjp7K05XNaGUydzNYR24tJbnie3ueErrX95WvPmOnYI1MfC8hfjSnPvB0
        5G1s/jt0/Z24rSFo4v2MUTL2MASVIA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-lFoU5dxKOh-pvZ28Se_LBw-1; Mon, 28 Sep 2020 11:31:55 -0400
X-MC-Unique: lFoU5dxKOh-pvZ28Se_LBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E455801ADC;
        Mon, 28 Sep 2020 15:31:54 +0000 (UTC)
Received: from gondolin (ovpn-113-21.ams2.redhat.com [10.36.113.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A28B678828;
        Mon, 28 Sep 2020 15:31:49 +0000 (UTC)
Date:   Mon, 28 Sep 2020 17:31:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
Message-ID: <20200928173147.750e7358.cohuck@redhat.com>
In-Reply-To: <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
        <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Sep 2020 16:23:34 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Some architectures need allocations to be done under a
> specific address limit to allow DMA from I/O.
> 
> We propose here a very simple page allocator to get
> pages allocated under this specific limit.
> 
> The DMA page allocator will only use part of the available memory
> under the DMA address limit to let room for the standard allocator.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/alloc_dma_page.c | 57 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/alloc_dma_page.h | 24 +++++++++++++++++++
>  lib/s390x/sclp.c     |  2 ++
>  s390x/Makefile       |  1 +
>  4 files changed, 84 insertions(+)
>  create mode 100644 lib/alloc_dma_page.c
>  create mode 100644 lib/alloc_dma_page.h

(...)

> diff --git a/lib/alloc_dma_page.h b/lib/alloc_dma_page.h
> new file mode 100644
> index 0000000..85e1d2f
> --- /dev/null
> +++ b/lib/alloc_dma_page.h
> @@ -0,0 +1,24 @@
> +/*
> + * Page allocator for DMA definitions
> + *
> + * Copyright (c) IBM, Corp. 2020
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + */
> +#ifndef _ALLOC_DMA_PAGE_H_
> +#define _ALLOC_DMA_PAGE_H_
> +
> +#include <asm/page.h>
> +
> +void put_dma_page(void *dma_page);
> +void *get_dma_page(void);
> +phys_addr_t dma_page_alloc_init(phys_addr_t start_pfn, phys_addr_t nb_pages);
> +
> +#define DMA_MAX_PFN	(0x80000000 >> PAGE_SHIFT)
> +#define DMA_ALLOC_RATIO	8

Hm, shouldn't the architecture be able to decide where a dma page can
be located? Or am I misunderstanding?

> +
> +#endif /* _ALLOC_DMA_PAGE_H_ */
(...)

