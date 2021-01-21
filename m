Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB232FE670
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbhAUJfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:35:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728672AbhAUJeX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:34:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611221559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h15i3oRqbPajIDp3Hf4t0yJtps2/rlNf2y9isim5H+0=;
        b=TmmimLGlujGuuUspnizl7vs9nw6y4Br7CZt3W1pmAvIY0u4/4YXswVCB+zyg8sJTTdHs8h
        wfrAgRYMyl5jQp+EGbBa7kw6x13+jMNPlc+TRxxMhg/v6Ky34vWiXZ1YUIffdcKGrAiTC6
        5i82y+suk7tnCMuZvhutGruEM0pEJHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-J9IydxwYO1SOp692lnU3xw-1; Thu, 21 Jan 2021 04:32:37 -0500
X-MC-Unique: J9IydxwYO1SOp692lnU3xw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFA9F8030B0;
        Thu, 21 Jan 2021 09:32:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-82.ams2.redhat.com [10.36.112.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5022169320;
        Thu, 21 Jan 2021 09:32:30 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 2/3] s390x: define UV compatible I/O
 allocation
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
 <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a50c9d35-4a67-4adc-4647-98df14300ada@redhat.com>
Date:   Thu, 21 Jan 2021 10:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611220392-22628-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2021 10.13, Pierre Morel wrote:
> To centralize the memory allocation for I/O we define
> the alloc_io_page/free_io_page functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   MAINTAINERS           |  1 +
>   lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
>   s390x/Makefile        |  1 +
>   4 files changed, 117 insertions(+)
>   create mode 100644 lib/s390x/malloc_io.c
>   create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 54124f6..89cb01e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -82,6 +82,7 @@ M: Thomas Huth <thuth@redhat.com>
>   M: David Hildenbrand <david@redhat.com>
>   M: Janosch Frank <frankja@linux.ibm.com>
>   R: Cornelia Huck <cohuck@redhat.com>
> +R: Pierre Morel <pmorel@linux.ibm.com>
>   L: kvm@vger.kernel.org
>   L: linux-s390@vger.kernel.org
>   F: s390x/*
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..bfe8c6a
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0

"GPL-2.0" is deprecated according to https://spdx.org/licenses/ ... please 
use "GPL-2.0-only" instead.

> +/*
> + * I/O page allocation
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * Using this interface provide host access to the allocated pages in
> + * case the guest is a secure guest.
> + * This is needed for I/O buffers.
> + *
> + */
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/uv.h>
> +#include <malloc_io.h>
> +#include <alloc_page.h>
> +#include <asm/facility.h>
> +
> +static int share_pages(void *p, int count)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < count; i++, p += PAGE_SIZE)
> +		if (uv_set_shared((unsigned long)p))
> +			return i;

Just a matter of taste, but you could replace the "return i" here also with 
a "break" since you're returning i below anyway.

> +	return i;
> +}
> +
> +static void unshare_pages(void *p, int count)
> +{
> +	int i;
> +
> +	for (i = count; i > 0; i--, p += PAGE_SIZE)
> +		uv_remove_shared((unsigned long)p);
> +}
> +
> +void *alloc_io_pages(int size, int flags)

I still think the naming or size parameter is confusing here. If I read 
something like alloc_io_pages(), I'd expect a "num_pages" parameter. So if 
you want to keep the "size" in bytes, I'd suggest to rename the function to 
"alloc_io_mem" instead.

> +{
> +	int order = (size >> PAGE_SHIFT);

I think this is wrong. According to the description of alloc_pages_flag, it 
allocates "1ull << order" pages.
So you likely want to do this instead here:

         int order = get_order(size >> PAGE_SHIFT);

> +	void *p;
> +	int n;
> +
> +	assert(size);
> +
> +	p = alloc_pages_flags(order, AREA_DMA31 | flags);
> +	if (!p || !test_facility(158))
> +		return p;
> +
> +	n = share_pages(p, 1 << order);
> +	if (n == 1 << order)
> +		return p;
> +
> +	unshare_pages(p, n);
> +	free_pages(p);
> +	return NULL;
> +}
> +
> +void free_io_pages(void *p, int size)
> +{
> +	int order = size >> PAGE_SHIFT;

dito?

> +	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
> +
> +	if (test_facility(158))
> +		unshare_pages(p, 1 << order);
> +	free_pages(p);
> +}
> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
> new file mode 100644
> index 0000000..494dfe9
> --- /dev/null
> +++ b/lib/s390x/malloc_io.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

GPL-2.0-only please.

> +/*
> + * I/O allocations
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + */
> +#ifndef _S390X_MALLOC_IO_H_
> +#define _S390X_MALLOC_IO_H_
> +
> +/*
> + * Allocates a page aligned page bound range of contiguous real or
> + * absolute memory in the DMA31 region large enough to contain size
> + * bytes.
> + * If Protected Virtualization facility is present, shares the pages
> + * with the host.
> + * If all the pages for the specified size cannot be reserved,
> + * the function rewinds the partial allocation and a NULL pointer
> + * is returned.
> + *
> + * @size: the minimal size allocated in byte.
> + * @flags: the flags used for the underlying page allocator.
> + *
> + * Errors:
> + *   The allocation will assert the size parameter, will fail if the
> + *   underlying page allocator fail or in the case of protected
> + *   virtualisation if the sharing of the pages fails.

I think "virtualization" (with an z) is more common than "virtualisation".

> + *
> + * Returns a pointer to the first page in case of success, NULL otherwise.
> + */
> +void *alloc_io_pages(int size, int flags);
> +
> +/*
> + * Frees a previously memory space allocated by alloc_io_pages.
> + * If Protected Virtualization facility is present, unshares the pages
> + * with the host.
> + * The address must be aligned on a page boundary otherwise an assertion
> + * breaks the program.
> + */
> +void free_io_pages(void *p, int size);
> +
> +#endif /* _S390X_MALLOC_IO_H_ */
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b079a26..4b6301c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -63,6 +63,7 @@ cflatobjs += lib/s390x/smp.o
>   cflatobjs += lib/s390x/vm.o
>   cflatobjs += lib/s390x/css_dump.o
>   cflatobjs += lib/s390x/css_lib.o
> +cflatobjs += lib/s390x/malloc_io.o
>   
>   OBJDIRS += lib/s390x

  Thomas


