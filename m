Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EC1248B14
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgHRQGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 12:06:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47081 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726952AbgHRQGp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 12:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597766801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Leo8X6TSu6zBXlfhbEWkQZSau6BKTD//LxtDsm5iZDc=;
        b=Syfi5t8Ks+/owVlvM8g9gvHs98IeJBx3jty+yJeJc4KVqXevOQD6PihNDsyDO9L2Trs/93
        0OaTWTyDhT6mhAENqUsE4wxMSk890zQn/WHIKrTfD0cSsFKgUs9VI0dSkwRAKGBXnPr7oj
        W4fXP9wgI74LgzWzkohOX7l4oAjxe+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-TuqtYbEVMXOvZNZOWJgadw-1; Tue, 18 Aug 2020 12:06:37 -0400
X-MC-Unique: TuqtYbEVMXOvZNZOWJgadw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E31D6100CFCB;
        Tue, 18 Aug 2020 16:06:36 +0000 (UTC)
Received: from gondolin (ovpn-112-221.ams2.redhat.com [10.36.112.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 431C77D91B;
        Tue, 18 Aug 2020 16:06:32 +0000 (UTC)
Date:   Tue, 18 Aug 2020 18:06:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests RFC v1 2/5] lib/alloc_page: complete rewrite of
 the page allocator
Message-ID: <20200818180629.3941ba31.cohuck@redhat.com>
In-Reply-To: <20200814151009.55845-3-imbrenda@linux.ibm.com>
References: <20200814151009.55845-1-imbrenda@linux.ibm.com>
        <20200814151009.55845-3-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Aug 2020 17:10:06 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> This is a complete rewrite of the page allocator.
> 
> This will bring a few improvements:
> * no need to specify the size when freeing
> * allocate small areas with a large alignment without wasting memory
> * ability to initialize and use multiple memory areas (e.g. DMA)
> * more sanity checks
> 
> A few things have changed:
> * initialization cannot be done with free_pages like before,
>   page_alloc_init_area has to be used instead
> 
> Arch-specific changes:
> * arm and x86 have been adapted to put all the memory in just one big
>   area (or two, for x86_64 with highmem).
> * s390x instead creates one area below 2GiB and one above; the area
>   below 2GiB is used for SMP lowcore initialization.

I was just wondering why we did not run into that problem before for
the css control blocks, but these are statically allocated.

> 
> Details:
> Each memory area has metadata at the very beginning. The metadata is a
> byte array with one entry per usable page (so, excluding the metadata
> itself). Each entry indicates if the page is special (unused for now),
> if it is allocated, and the order of the block. Both free and allocated
> pages are part of larger blocks.
> 
> Some more fixed size metadata is present in a fixed-size static array.
> This metadata contains start and end page frame numbers, the pointer to
> the metadata array, and the array of freelists. The array of freelists
> has an entry for each possible order (indicated by the macro NLISTS,
> defined as BITS_PER_LONG - PAGE_SHIFT).
> 
> On allocation, if the free list for the needed size is empty, larger
> blocks are split. When a small allocation with a large alignment is
> requested, an appropriately large block is split, to guarantee the
> alignment.
> 
> When a block is freed, an attempt will be made to merge it into the
> neighbour, iterating the process as long as possible.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/alloc_page.h |  64 ++++++-
>  lib/alloc_page.c | 451 ++++++++++++++++++++++++++++++++++++-----------
>  lib/arm/setup.c  |   2 +-
>  lib/s390x/sclp.c |  11 +-
>  lib/s390x/smp.c  |   2 +-
>  lib/vmalloc.c    |  13 +-
>  6 files changed, 427 insertions(+), 116 deletions(-)

(...)

> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 2860e9c..d954094 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -190,7 +190,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>  
>  	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
>  
> -	lc = alloc_pages(1);
> +	lc = alloc_pages_area(_AREA(1), 1);

Add a comment describing what this _AREA(1) is? Or maybe add a wrapper
for allocating below 2G? We might want to use it in other places as
well.

>  	cpu->lowcore = lc;
>  	memset(lc, 0, PAGE_SIZE * 2);
>  	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);

(...)

I'll pass on reviewing the rest of this patch :)

