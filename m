Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8CE343BDD
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 09:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCVIfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 04:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229472AbhCVIfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 04:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616402131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f2kH5Qs9TO6wQ2zJNEOYcGOk5qqIYlLIYWvFJcc+FIU=;
        b=d6JkvjZ0R7YlLfTCLQIKHR8yUOszU2Ea8OBwOC6ZjBTDMy+hTxkD9tI8UcBrEi2w8j3crr
        JNe0Tu9lk/+wMQLCq7yL0l4bnfYLN1NaK+q6LaF1aVSi7YqZICnm97w74LsHhqF3jSs/cj
        jMkXWz6wY1n4ZPWMJUpX5h6XC/D+PIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-zHJKwRcUM2unY3Du_BafSA-1; Mon, 22 Mar 2021 04:35:29 -0400
X-MC-Unique: zHJKwRcUM2unY3Du_BafSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 556CB84B9A2;
        Mon, 22 Mar 2021 08:35:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CDCB6A03C;
        Mon, 22 Mar 2021 08:35:26 +0000 (UTC)
Date:   Mon, 22 Mar 2021 09:35:23 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318180727.116004-2-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 06:07:24PM +0000, Nikos Nikoleris wrote:
> This change adds two functions from <string.h> and one from <stdlib.h>
> in preparation for an update in libfdt.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/stdlib.h | 12 +++++++++
>  lib/string.h |  4 ++-
>  lib/string.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 77 insertions(+), 9 deletions(-)
>  create mode 100644 lib/stdlib.h
> 
> diff --git a/lib/stdlib.h b/lib/stdlib.h
> new file mode 100644
> index 0000000..e8abe75
> --- /dev/null
> +++ b/lib/stdlib.h
> @@ -0,0 +1,12 @@
> +/*
> + * Header for libc stdlib functions
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + */
> +#ifndef _STDLIB_H_
> +#define _STDLIB_H_
> +
> +unsigned long int strtoul(const char *nptr, char **endptr, int base);
> +
> +#endif /* _STDLIB_H_ */
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
> index 75257f5..f77881f 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -6,16 +6,26 @@
>   */
>  
>  #include "libcflat.h"
> +#include "stdlib.h"
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
> @@ -55,6 +65,16 @@ char *strchr(const char *s, int c)
>      return (char *)s;
>  }
>  
> +char *strrchr(const char *s, int c)
> +{
> +    const char *last = NULL;
> +    do {
> +        if (*s == (char)c)
> +            last = s;
> +    } while (*s++);
> +    return (char *)last;
> +}
> +
>  char *strstr(const char *s1, const char *s2)
>  {
>      size_t l1, l2;
> @@ -135,13 +155,21 @@ void *memchr(const void *s, int c, size_t n)
>      return NULL;
>  }
>  
> -long atol(const char *ptr)
> +static int isspace(int c)
> +{
> +    return c == ' ' || c == '\t' || c == '\f' || c == '\n' || c == '\r';

I added \v. We don't need to do it for this patch, but at some point we
should consider adding a ctype.h file and consolidating all these is*
functions. There's a few in lib/argv.c too.

> +}
> +
> +unsigned long int strtoul(const char *nptr, char **endptr, int base)
>  {
>      long acc = 0;
> -    const char *s = ptr;
> +    const char *s = nptr;
>      int neg, c;
>  
> -    while (*s == ' ' || *s == '\t')
> +    if (base < 0 || base == 1 || base > 32)
> +        goto out; // errno = EINVAL

I changed this to

 assert(base == 0 || (base >= 2 && base <= 36));

Any reason why you weren't allowing bases 33 - 36?

> +
> +    while (isspace(*s))
>          s++;
>      if (*s == '-'){
>          neg = 1;
> @@ -152,20 +180,46 @@ long atol(const char *ptr)
>              s++;
>      }
>  
> +    if (base == 0 || base == 16) {
> +        if (*s == '0') {
> +            s++;
> +            if (*s == 'x') {

I changed this to (*s == 'x' || *s == 'X')

> +                 s++;
> +                 base = 16;
> +            } else if (base == 0)
> +                 base = 8;
> +        } else if (base == 0)
> +            base = 10;
> +    }
> +
>      while (*s) {
> -        if (*s < '0' || *s > '9')
> +        if (*s >= '0' && *s < '0' + base && *s <= '9')
> +            c = *s - '0';
> +        else if (*s >= 'a' && *s < 'a' + base - 10)
> +            c = *s - 'a' + 10;
> +        else if (*s >= 'A' && *s < 'A' + base - 10)
> +            c = *s - 'A' + 10;
> +        else
>              break;
> -        c = *s - '0';
> -        acc = acc * 10 + c;
> +        acc = acc * base + c;

I changed this to catch overflow.

>          s++;
>      }
>  
>      if (neg)
>          acc = -acc;
>  
> + out:
> +    if (endptr)
> +        *endptr = (char *)s;
> +
>      return acc;
>  }
>  
> +long atol(const char *ptr)
> +{
> +    return strtoul(ptr, NULL, 10);

Since atol should be strtol, I went ahead and also added strtol.

> +}
> +
>  extern char **environ;
>  
>  char *getenv(const char *name)
> -- 
> 2.25.1
> 

Here's a diff of my changes on top of your patch


diff --git a/lib/string.c b/lib/string.c
index 30592c5603c5..b684271bb18f 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -164,21 +164,22 @@ void *memchr(const void *s, int c, size_t n)
 
 static int isspace(int c)
 {
-    return c == ' ' || c == '\t' || c == '\f' || c == '\n' || c == '\r';
+    return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
 }
 
-unsigned long int strtoul(const char *nptr, char **endptr, int base)
-{
-    long acc = 0;
+static unsigned long __strtol(const char *nptr, char **endptr,
+                              int base, bool is_signed) {
+    unsigned long acc = 0;
     const char *s = nptr;
+    bool overflow;
     int neg, c;
 
-    if (base < 0 || base == 1 || base > 32)
-        goto out; // errno = EINVAL
+    assert(base == 0 || (base >= 2 && base <= 36));
 
     while (isspace(*s))
         s++;
-    if (*s == '-'){
+
+    if (*s == '-') {
         neg = 1;
         s++;
     } else {
@@ -190,7 +191,7 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
     if (base == 0 || base == 16) {
         if (*s == '0') {
             s++;
-            if (*s == 'x') {
+            if (*s == 'x' || *s == 'X') {
                  s++;
                  base = 16;
             } else if (base == 0)
@@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
             c = *s - 'A' + 10;
         else
             break;
-        acc = acc * base + c;
+
+        if (is_signed) {
+            long __acc = (long)acc;
+            overflow = __builtin_smull_overflow(__acc, base, &__acc);
+            assert(!overflow);
+            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
+            assert(!overflow);
+            acc = (unsigned long)__acc;
+        } else {
+            overflow = __builtin_umull_overflow(acc, base, &acc);
+            assert(!overflow);
+            overflow = __builtin_uaddl_overflow(acc, c, &acc);
+            assert(!overflow);
+        }
+
         s++;
     }
 
     if (neg)
         acc = -acc;
 
- out:
     if (endptr)
         *endptr = (char *)s;
 
     return acc;
 }
 
+long int strtol(const char *nptr, char **endptr, int base)
+{
+    return __strtol(nptr, endptr, base, true);
+}
+
+unsigned long int strtoul(const char *nptr, char **endptr, int base)
+{
+    return __strtol(nptr, endptr, base, false);
+}
+
 long atol(const char *ptr)
 {
-    return strtoul(ptr, NULL, 10);
+    return strtol(ptr, NULL, 10);
 }
 
 extern char **environ;


Thanks,
drew

