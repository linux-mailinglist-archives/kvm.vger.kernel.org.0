Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBF54352D4
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhJTSnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:43:40 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40862 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhJTSnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:43:39 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGWd-0002ei-Ab; Wed, 20 Oct 2021 20:41:19 +0200
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
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <2a4ceee16546deeab7090efea2ee9c0db5444b84.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9IzAQuQ+oMP61N@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 04/13] KVM: x86: Move n_memslots_pages recalc to
 kvm_arch_prepare_memory_region()
Message-ID: <9fc65b5d-a0fe-4ff2-1683-99ce9ec072bf@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:41:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9IzAQuQ+oMP61N@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 00:38, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> This allows us to return a proper error code in case we spot an underflow.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++--------------------
>>   1 file changed, 28 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 97d86223427d..0fffb8414009 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11511,9 +11511,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>   				const struct kvm_userspace_memory_region *mem,
>>   				enum kvm_mr_change change)
>>   {
>> -	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
>> -		return kvm_alloc_memslot_metadata(kvm, new,
>> -						  mem->memory_size >> PAGE_SHIFT);
>> +	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
>> +		int ret;
>> +
>> +		ret = kvm_alloc_memslot_metadata(kvm, new,
>> +						 mem->memory_size >> PAGE_SHIFT);
>> +		if (ret)
>> +			return ret;
>> +
>> +		if (change == KVM_MR_CREATE)
>> +			kvm->arch.n_memslots_pages += new->npages;
>> +	} else if (change == KVM_MR_DELETE) {
>> +		if (WARN_ON(kvm->arch.n_memslots_pages < old->npages))
>> +			return -EIO;
> 
> This is not worth the churn.  In a way, it's worse because userspace can spam
> the living snot out of the kernel log by retrying the ioctl().
> 
> Since underflow can happen if and only if there's a KVM bug, and a pretty bad one
> at that, just make the original WARN_ON a KVM_BUG_ON.  That will kill the VM and
> also provide the WARN_ON_ONCE behavior that we probably want.

Will do.

Thanks,
Maciej
