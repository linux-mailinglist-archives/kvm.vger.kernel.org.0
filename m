Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C41F5705
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFJOvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 10:51:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36882 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726956AbgFJOvV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 10:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591800679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=+d0A5D+aKHEy2W2BDMM73/2+Xy0Uv8ukd3DyCU4S0cg=;
        b=fVrJK5XxYOWTwnfTVzBSwEhyzNCB2XfUYaafu+zC8U4OJdRwbjvYKFhpv9ocxwbPYmZ+YX
        C2zVABl9HMBpsQWCFCbP72kiUHD/CK3PIK9XplKBBQGHq6PakkoF60xGMAvRGFe8p0K6LQ
        O3XuzOGPnHvhpgQ8cxVm0L+AS3vhhKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-RIPUKyfbPRK2W7TuduoTSQ-1; Wed, 10 Jun 2020 10:51:17 -0400
X-MC-Unique: RIPUKyfbPRK2W7TuduoTSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCA8100AA22;
        Wed, 10 Jun 2020 14:51:16 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F0AD5D9D7;
        Wed, 10 Jun 2020 14:51:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v8 09/12] s390x: Library resources for CSS
 tests
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
 <1591603981-16879-10-git-send-email-pmorel@linux.ibm.com>
 <ef5e71b6-9c4d-ac3f-7946-f67db73d740b@redhat.com>
 <17e5ccdd-f2b2-00bd-4ee2-c0a0b78a669a@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e2b1ac8d-f2cb-d913-a64d-a8237633d804@redhat.com>
Date:   Wed, 10 Jun 2020 16:51:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <17e5ccdd-f2b2-00bd-4ee2-c0a0b78a669a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/2020 17.01, Pierre Morel wrote:
> 
> 
> On 2020-06-09 09:09, Thomas Huth wrote:
>> On 08/06/2020 10.12, Pierre Morel wrote:
>>> Provide some definitions and library routines that can be used by
> 
> ...snip...
> 
>>> +static inline int ssch(unsigned long schid, struct orb *addr)
>>> +{
>>> +    register long long reg1 asm("1") = schid;
>>> +    int cc;
>>> +
>>> +    asm volatile(
>>> +        "    ssch    0(%2)\n"
>>> +        "    ipm    %0\n"
>>> +        "    srl    %0,28\n"
>>> +        : "=d" (cc)
>>> +        : "d" (reg1), "a" (addr), "m" (*addr)
>>
>> Hmm... What's the "m" (*addr) here good for? %3 is not used in the
>> assembly code?
> 
> addr is %2
> "m" (*addr) means memory pointed by addr is read
> 
>>
>>> +        : "cc", "memory");
>>
>> Why "memory" ? Can this instruction also change the orb?
> 
> The orb not but this instruction modifies memory as follow:
> orb -> ccw -> data
> 
> The CCW can be a READ or a WRITE instruction and the data my be anywhere
> in memory (<2G)
> 
> A compiler memory barrier is need to avoid write instructions started
> before the SSCH instruction to occur after for a write
> and memory read made after the instruction to be executed before for a
> read.

Ok, makes sense now, thanks!

>>> +static inline int msch(unsigned long schid, struct schib *addr)
>>> +{
>>> +    register unsigned long reg1 asm ("1") = schid;
>>> +    int cc;
>>> +
>>> +    asm volatile(
>>> +        "    msch    0(%3)\n"
>>> +        "    ipm    %0\n"
>>> +        "    srl    %0,28"
>>> +        : "=d" (cc), "=m" (*addr)
>>> +        : "d" (reg1), "a" (addr)
>>
>> I'm not an expert with these IO instructions, but this looks wrong to me
>> ... Is MSCH reading or writing the SCHIB data?
> 
> MSCH is reading the SCHIB data in memory.

So if it is reading, you don't need the  "=m" (*addr) in the output
list, do you? You should rather use "m" (*addr) in the input list instead?

 Thomas

