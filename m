Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA34345EDC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCWNCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231260AbhCWNB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Mar 2021 09:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616504515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRWcOx4dEk1OZdkM5dZDcgA03Zh7tzRnPPLTLDtGprk=;
        b=I8BmNZ+msjw8mLvN9vK9wabTSyRpgK6QJdV5aWHCTLNJnsNGpEu1QQ/kGGCpd8JWEpqTeE
        XzbeAS27I3AdwdkWXFTEeu+n2weBZfur7uH4svIii9OVc1RDB3PCl4k0M9ctNyr5FvFLaH
        RKHy/46Sj/LqdeUQqAP/5kUgcmh6GK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-madxJTR2MJS4OI7C_7vhhA-1; Tue, 23 Mar 2021 09:01:51 -0400
X-MC-Unique: madxJTR2MJS4OI7C_7vhhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A488A18C8C06;
        Tue, 23 Mar 2021 13:01:50 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-54.ams2.redhat.com [10.36.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2007E5C1CF;
        Tue, 23 Mar 2021 13:01:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
To:     Andrew Jones <drjones@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210318180727.116004-2-nikos.nikoleris@arm.com>
 <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
 <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <f60f2012-b007-b9db-e680-1ecf110e343d@redhat.com>
Date:   Tue, 23 Mar 2021 14:01:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/2021 13.14, Andrew Jones wrote:
> On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:
>> @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
>>               c = *s - 'A' + 10;
>>           else
>>               break;
>> -        acc = acc * base + c;
>> +
>> +        if (is_signed) {
>> +            long __acc = (long)acc;
>> +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
>> +            assert(!overflow);
>> +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
>> +            assert(!overflow);
>> +            acc = (unsigned long)__acc;
>> +        } else {
>> +            overflow = __builtin_umull_overflow(acc, base, &acc);
>> +            assert(!overflow);
>> +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
>> +            assert(!overflow);
>> +        }
>> +
> 
> Unfortunately my use of these builtins isn't loved by older compilers,
> like the one used by the build-centos7 pipeline in our gitlab CI. I
> could wrap them in an #if GCC_VERSION >= 50100 and just have the old
> 'acc = acc * base + c' as the fallback, but that's not pretty and
> would also mean that clang would use the fallback too. Maybe we can
> try and make our compiler.h more fancy in order to provide a
> COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
> both gcc and clang. Or, we could just forgot the overflow checking.
> 
> Anybody else have suggestions? Paolo? Thomas?

What does a "normal" libc implementation do (e.g. glibc)? If it is also not 
doing overflow checking, I think we also don't need it in the kvm-unit-tests.

  Thomas

