Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931103462B3
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 16:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhCWPXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 11:23:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232314AbhCWPXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 11:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616512983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48RhQI7dM8PBYM31SWFTDo8rYZ5aRInCyr8RJlB+PuA=;
        b=Kq5sPkxu+xBkAk3kAo9gaAvtRRYY2eEx+Y//SNmhZMkSIzJYQLBVBJ5n6S+zlAFLEehSIt
        5eMbDnygfRI7NeiQjJDZqr6Kk8B0wf4VZbK8rfnldXqlWaSBoEhJEJO5YrtP1l1e0O5SiN
        jUKb4KDFDHg8p/RUaT5xXhF/ZgBJlE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-2pAt5JXdMQCkj7KrlVM_HA-1; Tue, 23 Mar 2021 11:23:01 -0400
X-MC-Unique: 2pAt5JXdMQCkj7KrlVM_HA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E16381626
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 15:23:00 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-54.ams2.redhat.com [10.36.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 179D62C168;
        Tue, 23 Mar 2021 15:22:58 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] compiler: Add builtin overflow flag
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20210323135801.295407-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9f0b7493-bc1d-6fb7-9fd9-30fd4c294c7f@redhat.com>
Date:   Tue, 23 Mar 2021 16:22:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323135801.295407-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/2021 14.58, Andrew Jones wrote:
> Checking for overflow can difficult, but doing so may be a good
> idea to avoid difficult to debug problems. Compilers that provide
> builtins for overflow checking allow the checks to be simple
> enough that we can use them more liberally. The idea for this
> flag is to wrap a calculation that should have overflow checking,
> allowing compilers that support it to give us some extra robustness.
> For example,
> 
>    #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
>        bool overflow = __builtin_mul_overflow(x, y, &z);
>        assert(!overflow);
>    #else
>        /* Older compiler, hopefully we don't overflow... */
>        z = x * y;
>    #endif
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   lib/linux/compiler.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 2d72f18c36e5..311da9807932 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -8,6 +8,20 @@
>   
>   #ifndef __ASSEMBLY__
>   
> +#define GCC_VERSION (__GNUC__ * 10000           \
> +		     + __GNUC_MINOR__ * 100     \
> +		     + __GNUC_PATCHLEVEL__)
> +
> +#ifdef __clang__
> +#if __has_builtin(__builtin_mul_overflow) && \
> +    __has_builtin(__builtin_add_overflow) && \
> +    __has_builtin(__builtin_sub_overflow)
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +#elif GCC_VERSION >= 50100
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +
>   #include <stdint.h>
>   
>   #define barrier()	asm volatile("" : : : "memory")
> 

Acked-by: Thomas Huth <thuth@redhat.com>

... but I wonder:

1) Whether we still want to support those old compilers that do not have 
this built-in functions yet ... maybe it's time to declare the older systems 
as unsupported now?

2) Whether it would make more sense to provide static-inline functions for 
these arithmetic operations that take care of the overflow handling, so that 
we do not have #ifdefs in the .c code later all over the place?

  Thomas

