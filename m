Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E1B33D8A3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbhCPQFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:05:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238435AbhCPQEq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 12:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615910686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qe0T/JXsi2U8/6D1edA2MRWlyLrlwNaNQ4IVy+IgYKI=;
        b=FGKCYlJKvo/GWInqGlnrIjW4RxfA8vcZwyk0968bwCfm4ukaU7eUlZaGl1cRse9+in9C44
        7TKDF3D/smQZuWODIiweCRMT0LZaa93WMx5AXO3XgVKhMANV11UeS9e43yLnfD8Rozgn/A
        mtYKt/57GUut3WBJAF8muX3ynCdR8Q0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-clvbvTUNPgariYt3KAl3qQ-1; Tue, 16 Mar 2021 12:04:44 -0400
X-MC-Unique: clvbvTUNPgariYt3KAl3qQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53F5F1B2C983;
        Tue, 16 Mar 2021 16:04:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D65351F05D;
        Tue, 16 Mar 2021 16:04:41 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:04:39 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] lib/string: add strnlen and strrchr
Message-ID: <20210316160439.s5ivip2j5zc5sop5@kamzik.brq.redhat.com>
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
 <20210316152405.50363-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316152405.50363-2-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:24:02PM +0000, Nikos Nikoleris wrote:
> This change adds two functions from <string.h> in preparation for an
> update in the libfdt.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/string.h |  4 +++-
>  lib/string.c | 23 +++++++++++++++++++++--
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/string.h b/lib/string.h
> index 493d51b..8da687e 100644
> --- a/lib/string.h
> +++ b/lib/string.h
> @@ -7,12 +7,14 @@
>  #ifndef __STRING_H
>  #define __STRING_H
>  
> -extern unsigned long strlen(const char *buf);
> +extern size_t strlen(const char *buf);
> +extern size_t strnlen(const char *buf, size_t maxlen);
>  extern char *strcat(char *dest, const char *src);
>  extern char *strcpy(char *dest, const char *src);
>  extern int strcmp(const char *a, const char *b);
>  extern int strncmp(const char *a, const char *b, size_t n);
>  extern char *strchr(const char *s, int c);
> +extern char *strrchr(const char *s, int c);
>  extern char *strstr(const char *haystack, const char *needle);
>  extern void *memset(void *s, int c, size_t n);
>  extern void *memcpy(void *dest, const void *src, size_t n);
> diff --git a/lib/string.c b/lib/string.c
> index 75257f5..9cd626f 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -7,15 +7,24 @@
>  
>  #include "libcflat.h"
>  
> -unsigned long strlen(const char *buf)
> +size_t strlen(const char *buf)
>  {
> -    unsigned long len = 0;
> +    size_t len = 0;
>  
>      while (*buf++)
>  	++len;
>      return len;
>  }
>  
> +size_t strnlen(const char *buf, size_t maxlen)
> +{
> +    const char *sc;
> +
> +    for (sc = buf; maxlen-- && *sc != '\0'; ++sc)
> +        /* nothing */;
> +    return sc - buf;
> +}
> +
>  char *strcat(char *dest, const char *src)
>  {
>      char *p = dest;
> @@ -55,6 +64,16 @@ char *strchr(const char *s, int c)
>      return (char *)s;
>  }
>  
> +char *strrchr(const char *s, int c)
> +{
> +    const char *last = NULL;
> +    do {
> +        if (*s != (char)c)

This should be ==

> +            last = s;
> +    } while (*s++);
> +    return (char *)last;
> +}
> +
>  char *strstr(const char *s1, const char *s2)
>  {
>      size_t l1, l2;
> -- 
> 2.25.1
>

Thanks,
drew

