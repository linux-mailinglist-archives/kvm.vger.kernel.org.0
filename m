Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE444E943
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 15:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhKLO7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 09:59:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhKLO7F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 09:59:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636728974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/rDLT5gKfQArDzXtzy0W3AX7Pc1otYYMv1fncFFLLo=;
        b=bswGNYcvJx92rQpkkZs6mlgFWEhw9K2JuuVkwKIJdcJzf/rRJWFYpcW9nF9fqk8SnXLIhL
        NwiIQS3y5cBiKM2tQCHosnLYZdrRJkR67Yc7eYtxV3iVCQgxqDcXlvWNTgh/0zbf7HewPP
        JSITpg0MSJJfrbQ9xdDs7mxmXlaFleI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-KIdHFzd7MSK78lOUmrh5PQ-1; Fri, 12 Nov 2021 09:56:11 -0500
X-MC-Unique: KIdHFzd7MSK78lOUmrh5PQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 764D387D541;
        Fri, 12 Nov 2021 14:56:09 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 730507944B;
        Fri, 12 Nov 2021 14:56:03 +0000 (UTC)
Message-ID: <7e4b895b-8f36-69cb-10a9-0b4139b9eb79@redhat.com>
Date:   Fri, 12 Nov 2021 15:56:02 +0100
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
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
 <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
 <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <537fdcc6af80ba6285ae0cdecdb615face25426f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 14:28, David Woodhouse wrote:
> A back-to-back write_lock/write_unlock*without*  setting the address to
> KVM_UNMAPPED_PAGE? I'm not sure I see how that protects the IRQ
> delivery from accessing the (now stale) physical page after the MMU
> notifier has completed? Not unless it's going to call hva_to_pfn again
> for itself under the read_lock, every time it delivers an IRQ?

Yeah, you're right, it still has to invalidate it somehow.  So
KVM_UNMAPPED_PAGE would go in the hva field of the gfn_to_pfn cache
(merged with kvm_host_map).  Or maybe one can use an invalid generation,
too.

I was under the mistaken impression that with MMU notifiers one could
make atomic kvm_vcpu_map never fail, but now I think that makes no sense;
it could always encounter stale memslots.

>> 2) for memremap/memunmap, all you really care about is reacting to
>> changes in the memslots, so the MMU notifier integration has nothing
>> to do.  You still need to call the same hook as
>> kvm_mmu_notifier_invalidate_range() when memslots change, so that
>> the update is done outside atomic context.
> 
> Hm, we definitely *do* care about reacting to MMU notifiers in this
> case too. Userspace can do memory overcommit / ballooning etc.
> *without* changing the memslots, and only mmap/munmap/userfault_fd on
> the corresponding HVA ranges.

Can it do so for VM_IO/VM_PFNMAP memory?

> I think we want to kill the struct kvm_host_map completely, merge its
> extra 'hva' and 'page' fields into the (possibly renamed)
> gfn_to_pfn_cache along with your 'guest_uses_pa' flag, and take it from
> there.

Yes, that makes sense.

Paolo

