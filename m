Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FD74510DA
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 19:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242830AbhKOSzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 13:55:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243229AbhKOSx3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Nov 2021 13:53:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637002231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJmwTsIuEILSkjk0veFfkoc58Qdp3lNQEYmRycMFQ70=;
        b=WIj0LVIMyvR/HofrmTmXcijCTGjxhSWmfu0xHm/u/ypnSXKyP3j0C2aV/BjNKNQKPtnGFg
        OhTBEXtl/2aedm2CgUv2oTg8Is+ulFNnHruJFmzPyPK6ChopH7B3XD2gPxbRjbx2knfkMH
        1SoAxKkpvMmvQyBOX+eJld82sqpXrHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-wSR8FGwsPtKtBXUdq6Ue3Q-1; Mon, 15 Nov 2021 13:50:28 -0500
X-MC-Unique: wSR8FGwsPtKtBXUdq6Ue3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CFDF1922961;
        Mon, 15 Nov 2021 18:50:27 +0000 (UTC)
Received: from [10.39.195.133] (unknown [10.39.195.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56E7B5C1A1;
        Mon, 15 Nov 2021 18:50:22 +0000 (UTC)
Message-ID: <3a2a9a8c-db98-b770-78e2-79f5880ce4ed@redhat.com>
Date:   Mon, 15 Nov 2021 19:50:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/11] Rework gfn_to_pfn_cache
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
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
 <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
 <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/15/21 17:47, David Woodhouse wrote:
> So... a user of this must check the validity after setting its mode to
> IN_GUEST_MODE, and the invalidation must make a request and wake any
> vCPU(s) which might be using it.

Yes, though the check is implicit in the existing call to 
kvm_vcpu_exit_request(vcpu).

> I moved the invalidation to the invalidate_range MMU notifier, as
> discussed. But that's where the plan falls down a little bit because
> IIUC, that one can't sleep at all.

Which is a problem in the existing code, too.  It hasn't broken yet 
because invalidate_range() is _usually_ called with no spinlocks taken 
(the only caller that does call with a spinlock taken seems to be 
hugetlb_cow).

Once the dust settles, we need to add non_block_start/end around calls 
to ops->invalidate_range.

> I need to move it *back*  to
> invalidate_range_start() where I had it before, if I want to let it
> wait for vCPUs to exit. Which means... that the cache 'refresh' call
> must wait until the mmu_notifier_count reaches zero? Am I allowed to do > that, and make the "There can be only one waiter" comment in
> kvm_mmu_notifier_invalidate_range_end() no longer true?

You can also update the cache while taking the mmu_lock for read, and 
retry if mmu_notifier_retry_hva tells you to do so.  Looking at the 
scenario from commit e649b3f0188 you would have:

       (Invalidator) kvm_mmu_notifier_invalidate_range_start()
       (Invalidator) write_lock(mmu_lock)
       (Invalidator) increment mmu_notifier_count
       (Invalidator) write_unlock(mmu_lock)
       (Invalidator) request KVM_REQ_APIC_PAGE_RELOAD
       (KVM VCPU) vcpu_enter_guest()
       (KVM VCPU) kvm_vcpu_reload_apic_access_page()
    +  (KVM VCPU) read_lock(mmu_lock)
    +  (KVM VCPU) mmu_notifier_retry_hva()
    +  (KVM VCPU) read_unlock(mmu_lock)
    +  (KVM VCPU) retry! (mmu_notifier_count>1)
       (Invalidator) actually unmap page
    +  (Invalidator) kvm_mmu_notifier_invalidate_range_end()
    +  (Invalidator) write_lock(mmu_lock)
    +  (Invalidator) decrement mmu_notifier_count
    +  (Invalidator) write_unlock(mmu_lock)
    +  (KVM VCPU) vcpu_enter_guest()
    +  (KVM VCPU) kvm_vcpu_reload_apic_access_page()
    +  (KVM VCPU) mmu_notifier_retry_hva()

Changing mn_memslots_update_rcuwait to a waitq (and renaming it to 
mn_invalidate_waitq) is of course also a possibility.

Also, for the small requests: since you are at it, can you add the code 
in a new file under virt/kvm/?

Paolo

> I was also pondering whether to introduce a new arch-independent
> KVM_REQ_GPC_INVALIDATE, or let it be arch-dependent and make it a field
> of the cache, so that users can raise whatever requests they like?

