Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06A85EE2A3
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbiI1RMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiI1RMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:12:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC65EBBF8
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664385124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bP9+xy9pEpEEZfRNIBincGMZRHmli7unEWEFcnvOvfI=;
        b=CWC8gTNxlpkS2nYfNja7SCV5oCroBb6d07jEZNXBT8I1vDKLa3d92cNDMoZzNwR1H3Gr7v
        wOZN8CkcTuJK2tejKHK8EoSrQK2+009AVe6KcS8D1NAla2Iu/M700DT2aaQFHTRNeW+xO9
        i5C8IVoiLiGKehTX3zH/EXeRrb22FlM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-nA_iD8-KMreXsGBnzVXnOA-1; Wed, 28 Sep 2022 13:12:02 -0400
X-MC-Unique: nA_iD8-KMreXsGBnzVXnOA-1
Received: by mail-ed1-f70.google.com with SMTP id c6-20020a05640227c600b004521382116dso10971805ede.22
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:12:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bP9+xy9pEpEEZfRNIBincGMZRHmli7unEWEFcnvOvfI=;
        b=u+/sFLx5sPOtj/2/FNaCN6FsoJvP0z6HCnHLeByA+65TGe/x6aABQKVIXrnaGKsy0l
         TYhpRtQlWtnl0PyBKxsmDY8O0JigSIj1jFSjzSOnEWSca02s3Unf0V4slxqriXkOI6Wl
         S9/e2R4SKWArhjeRZ6E/vhAJA3Co7E8D81Eg6n01vMxxDluzR6v1u/ZHghE8uCAxrK8l
         arN3R+IEMbQjF3wtDDij7AxjFf67bNWEWus4eWkLNj0JvVkaTuGMeabVOegpBmLTxj97
         kSNLx+nBEKVM3x1TCBqXo5Z19beWUU1jmGkPdqu+3FJSXX0qr784Lhh9g33+Wc1WiNy5
         JPvA==
X-Gm-Message-State: ACrzQf3u+kr8fNMXK/l2WEisBttLqd48v3CDHPyTq/zht5wmUSZWG7Yc
        ugwzAuOoaMY2fHOPw4k1NYk/Pf5LJtJIKXVu2fe7U2Rxn2h9L2iX6JVpFyy7j6XQySSIjlgaIqd
        FAfahkb9Tcmg2
X-Received: by 2002:a17:906:5d16:b0:787:a9ee:3c9c with SMTP id g22-20020a1709065d1600b00787a9ee3c9cmr1151641ejt.467.1664385121704;
        Wed, 28 Sep 2022 10:12:01 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5oSbazWpUDSL6M39Ky2UKZNvGvgUNrSnGUmod/VQwxCYyZbqUNN75zpJYoa0XaARZHMtkh1A==
X-Received: by 2002:a17:906:5d16:b0:787:a9ee:3c9c with SMTP id g22-20020a1709065d1600b00787a9ee3c9cmr1151621ejt.467.1664385121427;
        Wed, 28 Sep 2022 10:12:01 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id d8-20020a170906304800b0078167cb4536sm2642428ejd.118.2022.09.28.10.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:12:00 -0700 (PDT)
Message-ID: <e4692910-489f-f824-104c-8ad5d99e8f08@redhat.com>
Date:   Wed, 28 Sep 2022 19:11:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-6-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 5/9] kvm_main.c: split __kvm_set_memory_region logic
 in kvm_check_mem and kvm_prepare_batch
In-Reply-To: <20220909104506.738478-6-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/22 12:45, Emanuele Giuseppe Esposito wrote:
> Just a function split. No functional change intended,
> except for the fact that kvm_prepare_batch() does not
> immediately call kvm_set_memslot() if batch->change is
> KVM_MR_DELETE, but delegates the caller (__kvm_set_memory_region).
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   virt/kvm/kvm_main.c | 120 +++++++++++++++++++++++++++++---------------
>   1 file changed, 79 insertions(+), 41 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 17f07546d591..9d917af30593 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1927,19 +1927,9 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
>   	return false;
>   }
>   
> -/*
> - * Allocate some memory and give it an address in the guest physical address
> - * space.
> - *
> - * Discontiguous memory is allowed, mostly for framebuffers.
> - * This function takes also care of initializing batch->new/old/invalid/change
> - * fields.
> - *
> - * Must be called holding kvm->slots_lock for write.
> - */
> -int __kvm_set_memory_region(struct kvm *kvm,
> -			    const struct kvm_userspace_memory_region *mem,
> -			    struct kvm_internal_memory_region_list *batch)
> +static int kvm_prepare_batch(struct kvm *kvm,
> +			     const struct kvm_userspace_memory_region *mem,
> +			     struct kvm_internal_memory_region_list *batch)
>   {
>   	struct kvm_memory_slot *old, *new;
>   	struct kvm_memslots *slots;
> @@ -1947,34 +1937,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   	unsigned long npages;
>   	gfn_t base_gfn;
>   	int as_id, id;
> -	int r;
> -
> -	r = check_memory_region_flags(mem);
> -	if (r)
> -		return r;
>   
>   	as_id = mem->slot >> 16;
>   	id = (u16)mem->slot;
>   
> -	/* General sanity checks */
> -	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
> -	    (mem->memory_size != (unsigned long)mem->memory_size))
> -		return -EINVAL;
> -	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
> -		return -EINVAL;
> -	/* We can read the guest memory with __xxx_user() later on. */
> -	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> -	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
> -	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
> -			mem->memory_size))
> -		return -EINVAL;
> -	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
> -		return -EINVAL;
> -	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> -		return -EINVAL;
> -	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
> -		return -EINVAL;
> -
>   	slots = __kvm_memslots(kvm, as_id);
>   
>   	/*
> @@ -1993,7 +1959,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   
>   		batch->change = KVM_MR_DELETE;
>   		batch->new = NULL;
> -		return kvm_set_memslot(kvm, batch);
> +		return 0;
>   	}
>   
>   	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
> @@ -2020,7 +1986,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   		else if (mem->flags != old->flags)
>   			change = KVM_MR_FLAGS_ONLY;
>   		else /* Nothing to change. */
> -			return 0;
> +			return 1;
>   	}
>   
>   	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
> @@ -2041,12 +2007,81 @@ int __kvm_set_memory_region(struct kvm *kvm,
>   
>   	batch->new = new;
>   	batch->change = change;
> +	return 0;
> +}
> +
> +static int kvm_check_mem(const struct kvm_userspace_memory_region *mem)
> +{
> +	int as_id, id;
> +
> +	as_id = mem->slot >> 16;
> +	id = (u16)mem->slot;
> +
> +	/* General sanity checks */
> +	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
> +	    (mem->memory_size != (unsigned long)mem->memory_size))
> +		return -EINVAL;
> +	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
> +		return -EINVAL;
> +	/* We can read the guest memory with __xxx_user() later on. */
> +	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
> +	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
> +	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
> +			mem->memory_size))
> +		return -EINVAL;
> +	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
> +		return -EINVAL;
> +	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
> +		return -EINVAL;
> +	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int kvm_check_memory_region(struct kvm *kvm,
> +				const struct kvm_userspace_memory_region *mem,
> +				struct kvm_internal_memory_region_list *batch)
> +{
> +	int r;
> +
> +	r = check_memory_region_flags(mem);
> +	if (r)
> +		return r;
>   
> -	r = kvm_set_memslot(kvm, batch);
> +	r = kvm_check_mem(mem);
>   	if (r)
> -		kfree(new);
> +		return r;
> +
> +	r = kvm_prepare_batch(kvm, mem, batch);
> +	if (r && batch->new)
> +		kfree(batch->new);
> +
>   	return r;
>   }
> +
> +/*
> + * Allocate some memory and give it an address in the guest physical address
> + * space.
> + *
> + * Discontiguous memory is allowed, mostly for framebuffers.
> + * This function takes also care of initializing batch->new/old/invalid/change
> + * fields.
> + *
> + * Must be called holding kvm->slots_lock for write.
> + */
> +int __kvm_set_memory_region(struct kvm *kvm,
> +			    const struct kvm_userspace_memory_region *mem,
> +			    struct kvm_internal_memory_region_list *batch)
> +{
> +	int r;
> +
> +	r = kvm_check_memory_region(kvm, mem, batch);
> +	if (r)
> +		return r;
> +
> +	return kvm_set_memslot(kvm, batch);
> +}
>   EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
>   
>   static int kvm_set_memory_region(struct kvm *kvm,
> @@ -2061,6 +2096,9 @@ static int kvm_set_memory_region(struct kvm *kvm,
>   	mutex_lock(&kvm->slots_lock);
>   	r = __kvm_set_memory_region(kvm, mem, batch);
>   	mutex_unlock(&kvm->slots_lock);
> +	/* r == 1 means empty request, nothing to do but no error */
> +	if (r == 1)
> +		r = 0;

This is weird...  I think you have the order of the split slightly 
messed up.  Doing this check earlier, roughly at the same time as the 
introduction of the new struct, is probably clearer.

After having reviewed more of the code, I do think you should 
disaggregate __kvm_set_memory_region() in separate functions (check, 
build entry, prepare, commit) completely.  kvm_set_memory_region() calls 
them  and __kvm_set_memory_region() disappears completely.

Paolo

>   	return r;
>   }
>   

