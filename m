Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7122691BE
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgINQhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:37:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgINQhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 12:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600101458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+3QS63D+O/2zgPLajVkL8jiLkR9pFOoYe0VFZID1jM=;
        b=gJ+stXMqRffdqzlt81KPL/Vd3puje+Z8uoNmio1n0jvGPwk3vjlPx1tQpuy4JzyPjo0G7c
        JJBjMbHPxieQtM9CPa828Ij6VHcCtXHaaEptRzQh327U7H/rf4a+ua3VumL5WENNohRF7u
        rNzZs4d+tcdwQaaxDGGbKEJurthDcak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-FHUtroSZN-unya36LyVG3Q-1; Mon, 14 Sep 2020 12:37:36 -0400
X-MC-Unique: FHUtroSZN-unya36LyVG3Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8684D802B7C;
        Mon, 14 Sep 2020 16:37:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-134.ams2.redhat.com [10.36.112.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9304F75149;
        Mon, 14 Sep 2020 16:37:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
 <20200914144502.GB52559@SPB-NB-133.local>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
Date:   Mon, 14 Sep 2020 18:37:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200914144502.GB52559@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2020 16.45, Roman Bolshakov wrote:
> On Fri, Sep 04, 2020 at 04:31:03PM +0200, Thomas Huth wrote:
>> On 01/09/2020 10.50, Roman Bolshakov wrote:
>>> .gitlab-ci.yml already has a job to build the tests with clang but it's
>>> not clear how to set it up on a personal github repo.
>>
>> You can't use gitlab-ci from a github repo, it's a separate git forge
>> system.
>>
>>> NB, realmode test is disabled because it fails immediately after start
>>> if compiled with clang-10.
>>>
>>> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
>>> ---
>>>  .travis.yml | 10 ++++++++++
>>>  1 file changed, 10 insertions(+)
>>>
>>> diff --git a/.travis.yml b/.travis.yml
>>> index f3a8899..ae4ed08 100644
>>> --- a/.travis.yml
>>> +++ b/.travis.yml
>>> @@ -17,6 +17,16 @@ jobs:
>>>                 kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp umip"
>>>        - ACCEL="kvm"
>>>  
>>> +    - addons:
>>> +        apt_packages: clang-10 qemu-system-x86
>>> +      env:
>>> +      - CONFIG="--cc=clang-10"
>>> +      - BUILD_DIR="."
>>> +      - TESTS="access asyncpf debug emulator ept hypercall hyperv_stimer
>>> +               hyperv_synic idt_test intel_iommu ioapic ioapic-split
>>> +               kvmclock_test msr pcid rdpru rmap_chain s3 setjmp umip"
>>> +      - ACCEL="kvm"
>>
>> We already have two jobs for compiling on x86, one for testing in-tree
>> builds and one for testing out-of-tree builds ... I wonder whether we
>> should simply switch one of those two jobs to use clang-10 instead of
>> gcc (since the in/out-of-tree stuff should be hopefully independent of
>> the compiler type)? Since Travis limits the amount of jobs that run at
>> the same time, that would not increase the total testing time, I think.
>>
> 
> Hi Thomas,
> 
> sure, that works for me.
> 
>>  Thomas
>>
>>
>> PS: Maybe we could update from bionic to focal now, too, and see whether
>> some more tests are working with the newer version of QEMU there...
>>
> 
> no problem, here're results for focal/kvm on IBM x3500 M3 (Nehalem) if
> the tests are built with clang:
[...]

Thanks for checking, that looks promising!

> The difference is only realmode test which doesn't work if built by
> clang.

Hmm, if you got some spare minutes, could you check if it works when
replacing the asm() statements there with asm volatile() ?
(Otherwise I'll check it if I got some spare time again ... so likely
not this week ;-))

 Thomas

