Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E170C343D42
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCVJwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 05:52:51 -0400
Received: from foss.arm.com ([217.140.110.172]:56762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhCVJwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 05:52:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56CB41063;
        Mon, 22 Mar 2021 02:52:46 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48B623F718;
        Mon, 22 Mar 2021 02:52:45 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <eef64e07-4862-36eb-bd79-06ec71cc510f@arm.com>
Date:   Mon, 22 Mar 2021 09:52:43 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 22/03/2021 08:35, Andrew Jones wrote:
> On Thu, Mar 18, 2021 at 06:07:24PM +0000, Nikos Nikoleris wrote:
>> This change adds two functions from <string.h> and one from <stdlib.h>
>> in preparation for an update in libfdt.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/stdlib.h | 12 +++++++++
>>   lib/string.h |  4 ++-
>>   lib/string.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++------
>>   3 files changed, 77 insertions(+), 9 deletions(-)
>>   create mode 100644 lib/stdlib.h
>>
>> diff --git a/lib/stdlib.h b/lib/stdlib.h
>> new file mode 100644
>> index 0000000..e8abe75
>> --- /dev/null
>> +++ b/lib/stdlib.h
>> @@ -0,0 +1,12 @@
>> +/*
>> + * Header for libc stdlib functions
>> + *
>> + * This code is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU Library General Public License version 2.
>> + */
>> +#ifndef _STDLIB_H_
>> +#define _STDLIB_H_
>> +
>> +unsigned long int strtoul(const char *nptr, char **endptr, int base);
>> +
>> +#endif /* _STDLIB_H_ */
>> diff --git a/lib/string.h b/lib/string.h
>> index 493d51b..8da687e 100644
>> --- a/lib/string.h
>> +++ b/lib/string.h
>> @@ -7,12 +7,14 @@
>>   #ifndef __STRING_H
>>   #define __STRING_H
>>   
>> -extern unsigned long strlen(const char *buf);
>> +extern size_t strlen(const char *buf);
>> +extern size_t strnlen(const char *buf, size_t maxlen);
>>   extern char *strcat(char *dest, const char *src);
>>   extern char *strcpy(char *dest, const char *src);
>>   extern int strcmp(const char *a, const char *b);
>>   extern int strncmp(const char *a, const char *b, size_t n);
>>   extern char *strchr(const char *s, int c);
>> +extern char *strrchr(const char *s, int c);
>>   extern char *strstr(const char *haystack, const char *needle);
>>   extern void *memset(void *s, int c, size_t n);
>>   extern void *memcpy(void *dest, const void *src, size_t n);
>> diff --git a/lib/string.c b/lib/string.c
>> index 75257f5..f77881f 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -6,16 +6,26 @@
>>    */
>>   
>>   #include "libcflat.h"
>> +#include "stdlib.h"
>>   
>> -unsigned long strlen(const char *buf)
>> +size_t strlen(const char *buf)
>>   {
>> -    unsigned long len = 0;
>> +    size_t len = 0;
>>   
>>       while (*buf++)
>>   	++len;
>>       return len;
>>   }
>>   
>> +size_t strnlen(const char *buf, size_t maxlen)
>> +{
>> +    const char *sc;
>> +
>> +    for (sc = buf; maxlen-- && *sc != '\0'; ++sc)
>> +        /* nothing */;
>> +    return sc - buf;
>> +}
>> +
>>   char *strcat(char *dest, const char *src)
>>   {
>>       char *p = dest;
>> @@ -55,6 +65,16 @@ char *strchr(const char *s, int c)
>>       return (char *)s;
>>   }
>>   
>> +char *strrchr(const char *s, int c)
>> +{
>> +    const char *last = NULL;
>> +    do {
>> +        if (*s == (char)c)
>> +            last = s;
>> +    } while (*s++);
>> +    return (char *)last;
>> +}
>> +
>>   char *strstr(const char *s1, const char *s2)
>>   {
>>       size_t l1, l2;
>> @@ -135,13 +155,21 @@ void *memchr(const void *s, int c, size_t n)
>>       return NULL;
>>   }
>>   
>> -long atol(const char *ptr)
>> +static int isspace(int c)
>> +{
>> +    return c == ' ' || c == '\t' || c == '\f' || c == '\n' || c == '\r';
> 
> I added \v. We don't need to do it for this patch, but at some point we
> should consider adding a ctype.h file and consolidating all these is*
> functions. There's a few in lib/argv.c too.
> 

I agree.

>> +}
>> +
>> +unsigned long int strtoul(const char *nptr, char **endptr, int base)
>>   {
>>       long acc = 0;
>> -    const char *s = ptr;
>> +    const char *s = nptr;
>>       int neg, c;
>>   
>> -    while (*s == ' ' || *s == '\t')
>> +    if (base < 0 || base == 1 || base > 32)
>> +        goto out; // errno = EINVAL
> 
> I changed this to
> 
>   assert(base == 0 || (base >= 2 && base <= 36));
> 
> Any reason why you weren't allowing bases 33 - 36?
> 

I was going through the manpage for strtoul and I got confused. 36 is 
the right value.

I wasn't sure if we should assert, the manpage seems to imply that it 
will return without converting and set the errno and endptr. I guess it 
might be better to assert().

>> +
>> +    while (isspace(*s))
>>           s++;
>>       if (*s == '-'){
>>           neg = 1;
>> @@ -152,20 +180,46 @@ long atol(const char *ptr)
>>               s++;
>>       }
>>   
>> +    if (base == 0 || base == 16) {
>> +        if (*s == '0') {
>> +            s++;
>> +            if (*s == 'x') {
> 
> I changed this to (*s == 'x' || *s == 'X')
> 

Here my intent was to not parse 0X as a valid prefix for base 16, 0X is 
not in the manpage.

>> +                 s++;
>> +                 base = 16;
>> +            } else if (base == 0)
>> +                 base = 8;
>> +        } else if (base == 0)
>> +            base = 10;
>> +    }
>> +
>>       while (*s) {
>> -        if (*s < '0' || *s > '9')
>> +        if (*s >= '0' && *s < '0' + base && *s <= '9')
>> +            c = *s - '0';
>> +        else if (*s >= 'a' && *s < 'a' + base - 10)
>> +            c = *s - 'a' + 10;
>> +        else if (*s >= 'A' && *s < 'A' + base - 10)
>> +            c = *s - 'A' + 10;
>> +        else
>>               break;
>> -        c = *s - '0';
>> -        acc = acc * 10 + c;
>> +        acc = acc * base + c;
> 
> I changed this to catch overflow.
> 

Thanks! Some thoughts on the assertion.

>>           s++;
>>       }
>>   
>>       if (neg)
>>           acc = -acc;
>>   
>> + out:
>> +    if (endptr)
>> +        *endptr = (char *)s;
>> +
>>       return acc;
>>   }
>>   
>> +long atol(const char *ptr)
>> +{
>> +    return strtoul(ptr, NULL, 10);
> 
> Since atol should be strtol, I went ahead and also added strtol.
>

Not very important but we could also add it to stdlib.h?


Thanks for the fixes it looks much better now!

Nikos


>> +}
>> +
>>   extern char **environ;
>>   
>>   char *getenv(const char *name)
>> -- 
>> 2.25.1
>>
> 
> Here's a diff of my changes on top of your patch
> 
> 
> diff --git a/lib/string.c b/lib/string.c
> index 30592c5603c5..b684271bb18f 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -164,21 +164,22 @@ void *memchr(const void *s, int c, size_t n)
>   
>   static int isspace(int c)
>   {
> -    return c == ' ' || c == '\t' || c == '\f' || c == '\n' || c == '\r';
> +    return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
>   }
>   
> -unsigned long int strtoul(const char *nptr, char **endptr, int base)
> -{
> -    long acc = 0;
> +static unsigned long __strtol(const char *nptr, char **endptr,
> +                              int base, bool is_signed) {
> +    unsigned long acc = 0;
>       const char *s = nptr;
> +    bool overflow;
>       int neg, c;
>   
> -    if (base < 0 || base == 1 || base > 32)
> -        goto out; // errno = EINVAL
> +    assert(base == 0 || (base >= 2 && base <= 36));
>   
>       while (isspace(*s))
>           s++;
> -    if (*s == '-'){
> +
> +    if (*s == '-') {
>           neg = 1;
>           s++;
>       } else {
> @@ -190,7 +191,7 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
>       if (base == 0 || base == 16) {
>           if (*s == '0') {
>               s++;
> -            if (*s == 'x') {
> +            if (*s == 'x' || *s == 'X') {
>                    s++;
>                    base = 16;
>               } else if (base == 0)
> @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
>               c = *s - 'A' + 10;
>           else
>               break;
> -        acc = acc * base + c;
> +
> +        if (is_signed) {
> +            long __acc = (long)acc;
> +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> +            assert(!overflow);
> +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> +            assert(!overflow);
> +            acc = (unsigned long)__acc;
> +        } else {
> +            overflow = __builtin_umull_overflow(acc, base, &acc);
> +            assert(!overflow);
> +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> +            assert(!overflow);
> +        }
> +
>           s++;
>       }
>   
>       if (neg)
>           acc = -acc;
>   
> - out:
>       if (endptr)
>           *endptr = (char *)s;
>   
>       return acc;
>   }
>   
> +long int strtol(const char *nptr, char **endptr, int base)
> +{
> +    return __strtol(nptr, endptr, base, true);
> +}
> +
> +unsigned long int strtoul(const char *nptr, char **endptr, int base)
> +{
> +    return __strtol(nptr, endptr, base, false);
> +}
> +
>   long atol(const char *ptr)
>   {
> -    return strtoul(ptr, NULL, 10);
> +    return strtol(ptr, NULL, 10);
>   }
>   
>   extern char **environ;
> 
> 
> Thanks,
> drew
> 
