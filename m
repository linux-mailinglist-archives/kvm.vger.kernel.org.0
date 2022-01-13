Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10948D30E
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 08:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiAMHmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 02:42:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232328AbiAMHmh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 02:42:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642059757;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ue1d/msd5vIMJ1AqIu2LNoBMek//LGkHnqyUgH09KUQ=;
        b=JRXNO2tX9VLrb345kSVdv/Qm/SaKHgttigzFN5rgwqSfyZhLa9LdAvzU5cH1sd49MxKyqX
        fSyQIQPtCcoJOkI1LOWwKlDuHWG5ZFcA9FCdEBnmaqbMieYmc8v++jY2H7x9qCv8HNLUVL
        cbCetkGIi7ErCMPjHQF3SpiVhAgCa1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-4QNDXphRPzy9ZrcT1PZEhw-1; Thu, 13 Jan 2022 02:42:33 -0500
X-MC-Unique: 4QNDXphRPzy9ZrcT1PZEhw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70C4C193F560;
        Thu, 13 Jan 2022 07:42:32 +0000 (UTC)
Received: from [10.72.13.202] (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 727AB5F917;
        Thu, 13 Jan 2022 07:42:23 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 03/15] KVM: async_pf: Make GFN slot management generic
To:     Eric Auger <eauger@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-4-gshan@redhat.com>
 <06cb06c0-13e7-906b-9b88-543a58bb5590@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <8bc39e08-abb9-91ba-3862-d5b2ccb0b7f5@redhat.com>
Date:   Thu, 13 Jan 2022 15:42:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <06cb06c0-13e7-906b-9b88-543a58bb5590@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 11/11/21 1:00 AM, Eric Auger wrote:
> On 8/15/21 2:59 AM, Gavin Shan wrote:
>> It's not allowed to fire duplicate notification for same GFN on
>> x86 platform, with help of a hash table. This mechanism is going
> s/, with help of a hash table/this is achieved through a hash table
>> to be used by arm64 and this makes the code generic and shareable
> s/and this makes/.\n Turn the code generic
>> by multiple platforms.
>>
>>     * As this mechanism isn't needed by all platforms, a new kernel
>>       config option (CONFIG_ASYNC_PF_SLOT) is introduced so that it
>>       can be disabled at compiling time.
> compile time

Ok.

>>
>>     * The code is basically copied from x86 platform and the functions
>>       are renamed to reflect the fact: (a) the input parameters are
>>       vCPU and GFN.
> not for reset
> (b) The operations are resetting, searching, adding

Ok.

>>       and removing.
> find, add, remove ops are renamed with _slot suffix

Ok. The commit log will be improved based on your suggestions in
next respin :)

>>
>>     * Helper stub is also added on !CONFIG_KVM_ASYNC_PF because we're
>>       going to use IS_ENABLED() instead of #ifdef on arm64 when the
>>       asynchronous page fault is supported.
>>
>> This is preparatory work to use the newly introduced functions on x86
>> platform and arm64 in subsequent patches.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   include/linux/kvm_host.h | 18 +++++++++
>>   virt/kvm/Kconfig         |  3 ++
>>   virt/kvm/async_pf.c      | 85 ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 106 insertions(+)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index a5f990f6dc35..a9685c2b2250 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -298,6 +298,9 @@ struct kvm_vcpu {
>>   
>>   #ifdef CONFIG_KVM_ASYNC_PF
>>   	struct {
>> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
>> +		gfn_t gfns[ASYNC_PF_PER_VCPU];
>> +#endif
>>   		u32 queued;
>>   		struct list_head queue;
>>   		struct list_head done;
>> @@ -339,6 +342,13 @@ struct kvm_async_pf {
>>   	bool				notpresent_injected;
>>   };
>>   
>> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
>> +void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu);
> this does not reset a "slot" but the whole hash table. So to me this
> shouldn't be renamed with _slot suffix. reset_hash or reset_all_slots?

Sure, lets have kvm_async_pf_reset_all_slots() in next respin.

>> +void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
>> +void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
>> +bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
>> +#endif
>> +
>>   static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>>   {
>>   	return !list_empty_careful(&vcpu->async_pf.done);
>> @@ -350,6 +360,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>   			unsigned long hva, struct kvm_arch_async_pf *arch);
>>   int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>>   #else
>> +static inline void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu) { }
>> +static inline void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
>> +static inline void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
>> +static inline bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +{
>> +	return false;
>> +}
>> +
>>   static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>>   {
>>   	return false;
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index 62b39149b8c8..59b518c8c205 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -23,6 +23,9 @@ config KVM_MMIO
>>   config KVM_ASYNC_PF
>>          bool
>>   
>> +config KVM_ASYNC_PF_SLOT
>> +	bool
>> +
>>   # Toggle to switch between direct notification and batch job
>>   config KVM_ASYNC_PF_SYNC
>>          bool
>> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
>> index d145a61a046a..0d1fdb2932af 100644
>> --- a/virt/kvm/async_pf.c
>> +++ b/virt/kvm/async_pf.c
>> @@ -13,12 +13,97 @@
>>   #include <linux/module.h>
>>   #include <linux/mmu_context.h>
>>   #include <linux/sched/mm.h>
>> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
>> +#include <linux/hash.h>
>> +#endif
>>   
>>   #include "async_pf.h"
>>   #include <trace/events/kvm.h>
>>   
>>   static struct kmem_cache *async_pf_cache;
>>   
>> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
>> +static inline u32 kvm_async_pf_hash(gfn_t gfn)
>> +{
>> +	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
>> +
>> +	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
>> +}
>> +
>> +static inline u32 kvm_async_pf_next_slot(u32 key)
>> +{
>> +	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
>> +}
>> +
>> +static u32 kvm_async_pf_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +{
>> +	u32 key = kvm_async_pf_hash(gfn);
>> +	int i;
>> +
>> +	for (i = 0; i < ASYNC_PF_PER_VCPU &&
>> +		(vcpu->async_pf.gfns[key] != gfn &&
>> +		vcpu->async_pf.gfns[key] != ~0); i++)
>> +		key = kvm_async_pf_next_slot(key);
>> +
>> +	return key;
>> +}
>> +
>> +void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
>> +		vcpu->async_pf.gfns[i] = ~0;
>> +}
>> +
>> +void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +{
>> +	u32 key = kvm_async_pf_hash(gfn);
>> +
>> +	while (vcpu->async_pf.gfns[key] != ~0)
>> +		key = kvm_async_pf_next_slot(key);
>> +
>> +	vcpu->async_pf.gfns[key] = gfn;
>> +}
>> +
>> +void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +{
>> +	u32 i, j, k;
>> +
>> +	i = j = kvm_async_pf_slot(vcpu, gfn);
>> +
>> +	if (WARN_ON_ONCE(vcpu->async_pf.gfns[i] != gfn))
>> +		return;
>> +
>> +	while (true) {
>> +		vcpu->async_pf.gfns[i] = ~0;
>> +
>> +		do {
>> +			j = kvm_async_pf_next_slot(j);
>> +			if (vcpu->async_pf.gfns[j] == ~0)
>> +				return;
>> +
>> +			k = kvm_async_pf_hash(vcpu->async_pf.gfns[j]);
>> +			/*
>> +			 * k lies cyclically in ]i,j]
>> +			 * |    i.k.j |
>> +			 * |....j i.k.| or  |.k..j i...|
>> +			 */
>> +		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
>> +
>> +		vcpu->async_pf.gfns[i] = vcpu->async_pf.gfns[j];
>> +		i = j;
>> +	}
>> +}
>> +
>> +bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +{
>> +	u32 key = kvm_async_pf_slot(vcpu, gfn);
>> +
>> +	return vcpu->async_pf.gfns[key] == gfn;
>> +}
>> +#endif /* CONFIG_KVM_ASYNC_PF_SLOT */
>> +
>>   int kvm_async_pf_init(void)
>>   {
>>   	async_pf_cache = KMEM_CACHE(kvm_async_pf, 0);
>>

Thanks,
Gavin

