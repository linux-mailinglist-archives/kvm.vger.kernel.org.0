Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AF8455E76
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhKROs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 09:48:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhKROs6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 09:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637246757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CFWa+ZiJCMkHOm69/Ih7nluq+4G/4TslIDnsu5s7Ph4=;
        b=GtImdbnjLISQRPY2giPkAtNtOILI+D8NHCXbeWu/vtBnAE8GBw0CJ02ANDzFOWVaxKWLR7
        7jeGwR2zFwaXL+K9sxiyNuRupoCVRVn2hg/DfqF8J14CfnLE7lQSRbhScL+N8wkyGzgR05
        Fo46JGMGBtq+kKN5Z19B/mc3r8+pS6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-fV8pHNetOXWLGZ5TmCrdfg-1; Thu, 18 Nov 2021 09:45:54 -0500
X-MC-Unique: fV8pHNetOXWLGZ5TmCrdfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3B58712D6;
        Thu, 18 Nov 2021 14:45:53 +0000 (UTC)
Received: from [10.39.194.89] (unknown [10.39.194.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 058B77092E;
        Thu, 18 Nov 2021 14:45:18 +0000 (UTC)
Message-ID: <a646aee0-dc3d-d5d6-268a-7994c7b86789@redhat.com>
Date:   Thu, 18 Nov 2021 15:45:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH v2] io: declare __cpu_is_be in generic code
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <20211118134848.336943-1-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20211118134848.336943-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 14.48, Pierre Morel wrote:
> To use the swap byte transformations in big endian architectures,
> we need to declare __cpu_is_be in the generic code.
> Let's move it from the ppc code to the generic code.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Suggested-by: Thomas Huth <thuth@redhat.com>
> ---
>   lib/asm-generic/io.h | 8 ++++++++
>   lib/ppc64/asm/io.h   | 8 --------
>   2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
> index 88972f3b..9fa76ddb 100644
> --- a/lib/asm-generic/io.h
> +++ b/lib/asm-generic/io.h
> @@ -13,6 +13,14 @@
>   #include "asm/page.h"
>   #include "asm/barrier.h"
>   
> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +#define __cpu_is_be() (0)
> +#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +#define __cpu_is_be() (1)
> +#else
> +#error Undefined byte order
> +#endif

Please remove these three later lines in that file now:

#ifndef __cpu_is_be
#define __cpu_is_be() (0)
#endif

  Thomas


>   #ifndef __raw_readb
>   static inline u8 __raw_readb(const volatile void *addr)
>   {
> diff --git a/lib/ppc64/asm/io.h b/lib/ppc64/asm/io.h
> index 2b4dd2be..08d7297c 100644
> --- a/lib/ppc64/asm/io.h
> +++ b/lib/ppc64/asm/io.h
> @@ -1,14 +1,6 @@
>   #ifndef _ASMPPC64_IO_H_
>   #define _ASMPPC64_IO_H_
>   
> -#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> -#define __cpu_is_be() (0)
> -#elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> -#define __cpu_is_be() (1)
> -#else
> -#error Undefined byte order
> -#endif
> -
>   #define __iomem
>   
>   #include <asm-generic/io.h>
> 

