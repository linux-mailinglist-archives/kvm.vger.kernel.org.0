Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB3452BAF
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 08:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhKPHlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 02:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230425AbhKPHlq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 02:41:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637048328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++lDESyr6yuN4aQ/v0rHUKTc0CEKFV+XvirR0Pe552k=;
        b=HaUnPAaEpMmnnDYOVg9/j1H4WH7ZVNIJzfkjdCejq1ZsH5e/w2DPOthPAupHh179WR2Yhp
        gMHtgV79E9mZijq9hwlLCyJfgOm+K63ULHPAP7fQLNPR0x8O1+rr1LFo+cZ1LvZI4KU6m/
        ZgDB4O1chu16BgB7fHnyJFW//jqD5RU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-EfwjcWvDM8iCt7JQf7QlDQ-1; Tue, 16 Nov 2021 02:38:43 -0500
X-MC-Unique: EfwjcWvDM8iCt7JQf7QlDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 353F21851731;
        Tue, 16 Nov 2021 07:38:41 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9EA41B42C;
        Tue, 16 Nov 2021 07:38:35 +0000 (UTC)
Message-ID: <ce66f713-3d5f-cf3f-8813-d25ee1d2cec7@redhat.com>
Date:   Tue, 16 Nov 2021 08:38:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vihas Mak <makvihas@gmail.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211114164312.GA28736@makvihas>
 <YZJH0Hd/ETYWJGTX@hirez.programming.kicks-ass.net>
 <ab419d8b-3e5d-2879-274c-ee609254890c@redhat.com>
 <20211115204905.GQ174703@worktop.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115204905.GQ174703@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 21:49, Peter Zijlstra wrote:
> On Mon, Nov 15, 2021 at 06:06:08PM +0100, Paolo Bonzini wrote:
>> On 11/15/21 12:43, Peter Zijlstra wrote:
>>> On Sun, Nov 14, 2021 at 10:13:12PM +0530, Vihas Mak wrote:
>>>> change 0 to false and 1 to true to fix following cocci warnings:
>>>>
>>>>           arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
>>>>           arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool
>>>
>>> That script should be deleted, it's absolute garbage.
>>
>> Only a Sith deals in absolutes.
> 
> Is that a star-wars thingy?

Yes, it is.  "If you're not with me, then you're my enemy!" "Only a Sith 
deals in absolutes". :)

> In C 0 is a valid way to spell false, equally, any non-0 value is a
> valid way to spell true. Why would this rate a warn?

Because often 0 means success (if -errno means failure).  So if you 
write false/true consistently for bool and 0 only for int, it's one less 
thing that one can get wrong.  At least that's the rationale.

Paolo

> In fact, when casting _Bool to integer, you get 0 and 1. When looking at
> the memory content of the _Bool variable, you'll get 0 and 1. But we're
> not allowed to write 0 and 1?
> 

