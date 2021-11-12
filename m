Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC87C44E4D9
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 11:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhKLKwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 05:52:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhKLKwK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 05:52:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636714158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSB+hziHCVUVfKj3GVmF50q3DVzkCSjsN9N4V9o4mA0=;
        b=Zon2gMUuLP2RBOIc0NyHBGzjocNsJSc8bEQZk/CLif9TYuQfkzbrZRypMPQ3lMIoXuLL4V
        eLnCek9OBRwtMeRjxtQJ51PJF2ny2ZEKiar5CYHGmwnlu37tzcjkqhXPEK1tpbdtzvy862
        C5G8daLocnoikUv8kX10GMBpd+Mx9zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-M9SaZYi1N3ujnGlRDpVceg-1; Fri, 12 Nov 2021 05:49:15 -0500
X-MC-Unique: M9SaZYi1N3ujnGlRDpVceg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A2AC8799ED;
        Fri, 12 Nov 2021 10:49:13 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD5AA19C59;
        Fri, 12 Nov 2021 10:49:10 +0000 (UTC)
Message-ID: <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
Date:   Fri, 12 Nov 2021 11:49:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
 <309f61f7-72fd-06a2-84b4-97dfc3fab587@redhat.com>
 <96cef64bf7927b6a0af2173b0521032f620551e4.camel@infradead.org>
 <40d7d808-dce6-a541-18dc-b0c7f4d6586c@redhat.com>
 <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 10:54, David Woodhouse wrote:
>>> I'm also slightly less comfortable with having the MMU notifier work
>>> through an arbitrary *list* of gfn_to_pfn caches that it potentially
>>> needs to invalidate, but that is very much a minor concern compared
>>> with the first.
>>>
>>> I started looking through the nested code which is the big user of this
>>> facility.
>>
>> Yes, that's also where I got stuck in my first attempt a few months ago.
>>    I agree that it can be changed to use gfn-to-hva caches, except for
>> the vmcs12->posted_intr_desc_addr and vmcs12->virtual_apic_page_addr.
> 
> ... that anything accessing these will *still* need to do so in atomic
> context. There's an atomic access which might fail, and then you fall
> back to a context in which you can sleep to refresh the mapping. and
> you *still* need to perform the actual access with the spinlock held to
> protect against concurrent invalidation.
> 
> So let's take a look... for posted_intr_desc_addr, that host physical
> address is actually written to the VMCS02, isn't it?
> 
> Thinking about the case where the target page is being invalidated
> while the vCPU is running... surely in that case the only 'correct'
> solution is that the vCPU needs to be kicked out of non-root mode
> before the invalidate_range() notifier completes?

Yes.

> That would have worked nicely if the MMU notifier could call
> scru_synchronize() on invalidation. Can it kick the vCPU and wait for
> it to exit though?

Yes, there's kvm_make_all_cpus_request (see 
kvm_arch_mmu_notifier_invalidate_range).  It can sleep, which is 
theoretically wrong---but in practice non-blockable invalidations only 
occur from the OOM reaper, so no CPU can be running.  If we care, we can 
return early from kvm_arch_mmu_notifier_invalidate_range for 
non-blockable invalidations.

> Don't get me wrong, a big part of me *loves* the idea that the hairiest
> part of my Xen event channel delivery is actually a bug fix that we
> need in the kernel anyway, and then the rest of it is simple and
> uncontentious.
> 
> (ISTR the virtual apic page is a bit different because it's only an
> *address* and it doesn't even have to be backed by real memory at the
> corresponding HPA? Otherwise it's basically the same issue?)

We do back it by real memory anyway, so it's the same.

Paolo

