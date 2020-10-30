Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF742A09E2
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgJ3P37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgJ3P37 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 11:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604071798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b0W7QMQzHbpC22wVvKeK+U/xelKfT4N9vj2I59aNa5o=;
        b=SFklcGZObyIG34720uYwhhuNp3yJlXgv+WVsbFBcFG1SiPMHI9WuQVlm+df9IcRAEM4uE1
        vYvdCRxQ25kylJXQDJEbmSWxZcZMg2bGjs62PMin7wakLKvHypSbJ4MPBnse80mxF9ouHy
        Nwgard+Heyi7csgarviWIHFZm+gX97U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-FbkiMC06OMK-jBPuqMqXUQ-1; Fri, 30 Oct 2020 11:29:53 -0400
X-MC-Unique: FbkiMC06OMK-jBPuqMqXUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8BA8F62E4;
        Fri, 30 Oct 2020 15:29:52 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1074F55772;
        Fri, 30 Oct 2020 15:29:50 +0000 (UTC)
From:   Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests RFC PATCH v2 2/5] lib/{bitops, alloc_page}.h: Add
 missing headers
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-3-alexandru.elisei@arm.com>
Message-ID: <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
Date:   Fri, 30 Oct 2020 16:29:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,
On 10/27/20 6:19 PM, Alexandru Elisei wrote:
> bitops.h uses the 'bool' and 'size_t' types, but doesn't include the
> stddef.h and stdbool.h headers, where the types are defined. This can cause
> the following error when compiling:
> 
> In file included from arm/new-test.c:9:
> /path/to/kvm-unit-tests/lib/bitops.h:77:15: error: unknown type name 'bool'
>    77 | static inline bool is_power_of_2(unsigned long n)
>       |               ^~~~
> /path/to/kvm-unit-tests/lib/bitops.h:82:38: error: unknown type name 'size_t'
>    82 | static inline unsigned int get_order(size_t size)
>       |                                      ^~~~~~
> /path/to/kvm-unit-tests/lib/bitops.h:24:1: note: 'size_t' is defined in header '<stddef.h>'; did you forget to '#include <stddef.h>'?
>    23 | #include <asm/bitops.h>
>   +++ |+#include <stddef.h>
>    24 |
> make: *** [<builtin>: arm/new-test.o] Error 1
> 
> The same errors were observed when including alloc_page.h. Fix both files
> by including stddef.h and stdbool.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/alloc_page.h | 2 ++
>  lib/bitops.h     | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
> index 88540d1def06..182862c43363 100644
> --- a/lib/alloc_page.h
> +++ b/lib/alloc_page.h
> @@ -4,6 +4,8 @@
>   * This is a simple allocator that provides contiguous physical addresses
>   * with byte granularity.
>   */
> +#include <stdbool.h>
> +#include <stddef.h>
nit: you may move those includes after the #ifndef ALLOC_PAGE_H as it is
usually done.
>  
>  #ifndef ALLOC_PAGE_H
>  #define ALLOC_PAGE_H 1
> diff --git a/lib/bitops.h b/lib/bitops.h
> index 308aa86514a8..5aeea0b998b1 100644
> --- a/lib/bitops.h
> +++ b/lib/bitops.h
> @@ -1,5 +1,7 @@
>  #ifndef _BITOPS_H_
>  #define _BITOPS_H_
> +#include <stdbool.h>
> +#include <stddef.h>
>  
>  /*
>   * Adapted from
> 
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


