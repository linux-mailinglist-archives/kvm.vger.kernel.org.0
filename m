Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716203169EF
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 16:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhBJPRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 10:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229839AbhBJPRQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 10:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612970149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUmvVMvAvYIwqlomGlCTTR4gDfNwX2CSnq9kV4m6kT4=;
        b=WJeH7XIx5GAsyOTHnmmL5lkBVS5bpHkOP09slWNEUG/sofywOZpKWgzy4PJpM/4SLW/cTU
        HUPvq5B1cxfPBYB9MLzUCMvMUKmQ1ZcikKJfvkWdOAmWkojNtyJECT4Ebat/GoBnLsDPHM
        q4JDdsQKSGdxEb72/d8A9WXVqXLBgo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-yxmXs3rGO_iKldY_Cl-SBA-1; Wed, 10 Feb 2021 10:15:47 -0500
X-MC-Unique: yxmXs3rGO_iKldY_Cl-SBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 059D1BBEE8;
        Wed, 10 Feb 2021 15:15:45 +0000 (UTC)
Received: from llong.remote.csb (ovpn-115-20.rdu2.redhat.com [10.10.115.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7712960657;
        Wed, 10 Feb 2021 15:15:39 +0000 (UTC)
Subject: Re: [PATCH v2 06/28] locking/rwlocks: Add contention detection for
 rwlocks
From:   Waiman Long <longman@redhat.com>
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20210202185734.1680553-1-bgardon@google.com>
 <20210202185734.1680553-7-bgardon@google.com>
 <6287ff89-d869-e5ed-3e64-11621cc4796a@redhat.com>
Organization: Red Hat
Message-ID: <058d416d-e137-056f-e81b-823cd770a3ff@redhat.com>
Date:   Wed, 10 Feb 2021 10:15:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6287ff89-d869-e5ed-3e64-11621cc4796a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/21 10:32 PM, Waiman Long wrote:
> On 2/2/21 1:57 PM, Ben Gardon wrote:
>> rwlocks do not currently have any facility to detect contention
>> like spinlocks do. In order to allow users of rwlocks to better manage
>> latency, add contention detection for queued rwlocks.
>>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: Will Deacon <will@kernel.org>
>> Acked-by: Peter Zijlstra <peterz@infradead.org>
>> Acked-by: Davidlohr Bueso <dbueso@suse.de>
>> Acked-by: Waiman Long <longman@redhat.com>
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Ben Gardon <bgardon@google.com>
>> ---
>>   include/asm-generic/qrwlock.h | 24 ++++++++++++++++++------
>>   include/linux/rwlock.h        |  7 +++++++
>>   2 files changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/asm-generic/qrwlock.h 
>> b/include/asm-generic/qrwlock.h
>> index 84ce841ce735..0020d3b820a7 100644
>> --- a/include/asm-generic/qrwlock.h
>> +++ b/include/asm-generic/qrwlock.h
>> @@ -14,6 +14,7 @@
>>   #include <asm/processor.h>
>>     #include <asm-generic/qrwlock_types.h>
>> +#include <asm-generic/qspinlock.h>
>
> As said in another thread, qspinlock and qrwlock can be independently 
> enabled for an architecture. So we shouldn't include qspinlock.h here. 
> Instead, just include the regular linux/spinlock.h file to make sure 
> that arch_spin_is_locked() is available.

The csky architecture uses qrwlock but not qspinlock. So this patch can 
be problematic when compiling for csky.

Cheers,
Longman

