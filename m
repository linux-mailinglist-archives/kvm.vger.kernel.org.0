Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF752FCEEE
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388947AbhATLOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 06:14:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732260AbhATLDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611140512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+z2tcwO7de5N4TVau2AL14xxCOhlqfPxup9LRCqTy94=;
        b=jWfTe1L0EPN/OoFwHZg2DppnlIZeidOINpUm03B+LBN83CzyxY+/cEP0gnQAQBkNzXgwwz
        zJnjvdyIdhRvnY9XNA0oSDNcCz86A+EYdxUZOltTQawMq1SlS3uKX0d8nCCz6At6zIbBUS
        49+mfrTwA51cE+805DkXnSBY5zCRr54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-5bVKMRbcNqO1rsUPK-hbrA-1; Wed, 20 Jan 2021 06:01:50 -0500
X-MC-Unique: 5bVKMRbcNqO1rsUPK-hbrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B296559;
        Wed, 20 Jan 2021 11:01:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 101445C8AB;
        Wed, 20 Jan 2021 11:01:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: define UV compatible I/O
 allocation
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
 <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2558695f-4ab7-d6e9-c857-0e8473ada775@redhat.com>
Date:   Wed, 20 Jan 2021 12:01:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/01/2021 20.52, Pierre Morel wrote:
> To centralize the memory allocation for I/O we define
> the alloc_io_page/free_io_page functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/malloc_io.c | 50 +++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/malloc_io.h | 18 ++++++++++++++++
>   s390x/Makefile        |  1 +
>   3 files changed, 69 insertions(+)
>   create mode 100644 lib/s390x/malloc_io.c
>   create mode 100644 lib/s390x/malloc_io.h
> 
> diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
> new file mode 100644
> index 0000000..2a946e0
> --- /dev/null
> +++ b/lib/s390x/malloc_io.c
> @@ -0,0 +1,50 @@
> +/*
> + * I/O page allocation
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.

Janosch recently started to introduce SPDX identifieres to the s390x code, 
so I think it would be good to use them here, too.

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
> +void *alloc_io_page(int size)
> +{
> +	void *p;
> +
> +	assert(size <= PAGE_SIZE);

Apart from the assert() statement, the size parameter seems to be completely 
unused. It's also weird to have the function named alloc_something_page() 
and then have a parameter that takes bytes. Thus I'd suggest to either drop 
the size parameter completely, or to rename the function to alloc_io_mem and 
then to alloc multiple pages below in case the size is bigger than 
PAGE_SIZE. Or maybe even to name the function alloc_io_pages and then use 
"int num_pages" as a parameter, allowing to allocate multiple pages at once?

> +
> +	p = alloc_pages_flags(1, AREA_DMA31);
> +	if (!p)
> +		return NULL;
> +	memset(p, 0, PAGE_SIZE);
> +
> +	if (!test_facility(158))
> +		return p;
> +
> +	if (uv_set_shared((unsigned long)p) == 0)
> +		return p;
> +
> +	free_pages(p);
> +	return NULL;
> +}
> +
> +void free_io_page(void *p)
> +{
> +	if (test_facility(158))
> +		uv_remove_shared((unsigned long)p);
> +	free_pages(p);
> +}
> diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
> new file mode 100644
> index 0000000..f780191
> --- /dev/null
> +++ b/lib/s390x/malloc_io.h
> @@ -0,0 +1,18 @@
> +/*
> + * I/O allocations
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
Please also add SPDX license information here.

  Thomas

