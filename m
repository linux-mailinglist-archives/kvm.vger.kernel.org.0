Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711022A0A7F
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgJ3P5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:57:05 -0400
Received: from foss.arm.com ([217.140.110.172]:38378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgJ3P5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 11:57:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16A9E30E;
        Fri, 30 Oct 2020 08:57:04 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 689D23F719;
        Fri, 30 Oct 2020 08:57:03 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 2/5] lib/{bitops, alloc_page}.h: Add
 missing headers
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-3-alexandru.elisei@arm.com>
 <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <44e2651a-58a0-000c-719d-b3f9c0791c03@arm.com>
Date:   Fri, 30 Oct 2020 15:58:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8474ba0a-ab47-9b83-5f30-0418cf6f0b24@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 10/30/20 3:29 PM, Auger Eric wrote:
> Hi Alexandru,
> On 10/27/20 6:19 PM, Alexandru Elisei wrote:
>> bitops.h uses the 'bool' and 'size_t' types, but doesn't include the
>> stddef.h and stdbool.h headers, where the types are defined. This can cause
>> the following error when compiling:
>>
>> In file included from arm/new-test.c:9:
>> /path/to/kvm-unit-tests/lib/bitops.h:77:15: error: unknown type name 'bool'
>>    77 | static inline bool is_power_of_2(unsigned long n)
>>       |               ^~~~
>> /path/to/kvm-unit-tests/lib/bitops.h:82:38: error: unknown type name 'size_t'
>>    82 | static inline unsigned int get_order(size_t size)
>>       |                                      ^~~~~~
>> /path/to/kvm-unit-tests/lib/bitops.h:24:1: note: 'size_t' is defined in header '<stddef.h>'; did you forget to '#include <stddef.h>'?
>>    23 | #include <asm/bitops.h>
>>   +++ |+#include <stddef.h>
>>    24 |
>> make: *** [<builtin>: arm/new-test.o] Error 1
>>
>> The same errors were observed when including alloc_page.h. Fix both files
>> by including stddef.h and stdbool.h.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/alloc_page.h | 2 ++
>>  lib/bitops.h     | 2 ++
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/lib/alloc_page.h b/lib/alloc_page.h
>> index 88540d1def06..182862c43363 100644
>> --- a/lib/alloc_page.h
>> +++ b/lib/alloc_page.h
>> @@ -4,6 +4,8 @@
>>   * This is a simple allocator that provides contiguous physical addresses
>>   * with byte granularity.
>>   */
>> +#include <stdbool.h>
>> +#include <stddef.h>
> nit: you may move those includes after the #ifndef ALLOC_PAGE_H as it is
> usually done.

Oops, you're right, I missed that, will change.

>>  
>>  #ifndef ALLOC_PAGE_H
>>  #define ALLOC_PAGE_H 1
>> diff --git a/lib/bitops.h b/lib/bitops.h
>> index 308aa86514a8..5aeea0b998b1 100644
>> --- a/lib/bitops.h
>> +++ b/lib/bitops.h
>> @@ -1,5 +1,7 @@
>>  #ifndef _BITOPS_H_
>>  #define _BITOPS_H_
>> +#include <stdbool.h>
>> +#include <stddef.h>
>>  
>>  /*
>>   * Adapted from
>>
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks,

Alex

