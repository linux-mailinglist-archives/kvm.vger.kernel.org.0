Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A5338C050
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235123AbhEUHFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:05:25 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:46922 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhEUHFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:05:17 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ljzCG-000549-5O; Fri, 21 May 2021 09:03:48 +0200
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <b8258ced64a81c7d90320c2921fe08b11eb47362.1621191551.git.maciej.szmigiero@oracle.com>
 <YKWB9bPyyFfo0uhf@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 2/8] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
Message-ID: <4e24f674-6250-626d-48cd-4e0fe60defa4@maciej.szmigiero.name>
Date:   Fri, 21 May 2021 09:03:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKWB9bPyyFfo0uhf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.05.2021 23:24, Sean Christopherson wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 8895b95b6a22..3c40c7d32f7e 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -1091,10 +1091,14 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>>    * gfn_to_memslot() itself isn't here as an inline because that would
>>    * bloat other code too much.
>>    *
>> + * With "approx" set returns the memslot also when the address falls
>> + * in a hole. In that case one of the memslots bordering the hole is
>> + * returned.
>> + *
>>    * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
>>    */
>>   static inline struct kvm_memory_slot *
>> -search_memslots(struct kvm_memslots *slots, gfn_t gfn)
>> +search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
> 
> An alternative to modifying the PPC code would be to make the existing
> search_memslots() a wrapper to __search_memslots(), with the latter taking
> @approx.

I guess you mean that if search_memslots() only does an exact search
(like the current code does) its 3 callers won't have to be modified.
Will do it then.

> We might also want to make this __always_inline to improve the likelihood of the
> compiler optimizing away @approx.  I doubt it matters in practice...

Sounds like a good idea, will do.

Thanks,
Maciej
