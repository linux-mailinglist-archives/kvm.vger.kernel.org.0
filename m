Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C9644E3D7
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhKLJen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26609 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhKLJel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636709511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prg4NGQR2t7nhu2L5lnasbr3vobcEKls2/Ssgs9+S+0=;
        b=dw6arPJskOKLJcUNFR3ymLc1S6pOS9D0HGI5YHqbo05as8x8m+155UmlKDzuYxyiSBgyiW
        L/kTq01grD+Y+c2fWzLraQZlqzsuj3jgh+ypMbEt9D42DWswzS5xCDv/bCuTIs23rkOWbi
        xOldshv+59ljB6r3mvapKnwfP3Ud2Ak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558--OjJeDNDPiCNJZtET43XTQ-1; Fri, 12 Nov 2021 04:31:47 -0500
X-MC-Unique: -OjJeDNDPiCNJZtET43XTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3943F8049C8;
        Fri, 12 Nov 2021 09:31:46 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE265E26A;
        Fri, 12 Nov 2021 09:31:43 +0000 (UTC)
Message-ID: <40d7d808-dce6-a541-18dc-b0c7f4d6586c@redhat.com>
Date:   Fri, 12 Nov 2021 10:31:42 +0100
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <96cef64bf7927b6a0af2173b0521032f620551e4.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 09:28, David Woodhouse wrote:
> I do not recall that we'd actually reached a conclusion that we *will*
> make the gfn_to_pfn cache generally usable in that fashion. The latest
> I knew of that discussion was my message at
> https://lore.kernel.org/kvm/55a5d4e3fbd29dd55e276b97eeaefd0411b3290b.camel@infradead.org/
> in which I said I'd be a whole lot happier with that if we could do it
> with RCU instead of an rwlock — but I don't think we can because we'd
> need to call synchronize_srcu() in the MMU notifier callback that might
> not be permitted to sleep?

Why do you have a problem with the rwlock?  If it's per-cache, and it's 
mostly taken within vCPU context (with the exception of Xen), contention 
should be nonexistent.

> I'm also slightly less comfortable with having the MMU notifier work
> through an arbitrary *list* of gfn_to_pfn caches that it potentially
> needs to invalidate, but that is very much a minor concern compared
> with the first.
> 
> I started looking through the nested code which is the big user of this
> facility.

Yes, that's also where I got stuck in my first attempt a few months ago. 
  I agree that it can be changed to use gfn-to-hva caches, except for 
the vmcs12->posted_intr_desc_addr and vmcs12->virtual_apic_page_addr.

Paolo

> The important part of the gfn_to_pfn mapping as I've used it
> for Xen event channel delivery is the fast path in the common case,
> falling back to a slow path that needs to sleep, to revalidate the
> mapping. That fast vs. slow path (with a workqueue) already existed for
> irqfd delivery and I just needed to hook into it in the right places.
> 
> I didn't see anything in nested code that would benefit from that same
> setup, and AFAICT it should all be running with current->mm == kvm->mm
> so surely it ought to be able to just access things using the userspace
> HVA and sleep if necessary?
> 
> (There's an *entirely* gratuitous one in nested_cache_shadow_vmcs12()
> which does a map/memcpy/unmap that really ought to be kvm_read_guest().
> I'll send a patch for that shortly)
> 
> 

