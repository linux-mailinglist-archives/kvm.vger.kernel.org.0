Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4B66204DD
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 01:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiKHAqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 19:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiKHAqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 19:46:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EF662E3
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 16:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667868305;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IotnmIrGGMYVPeqt1/PtjDRIRr0DMmv+ieSK1ksw2Wc=;
        b=ZAuoBvWzyZheIYsUtUgzZnqjM7tL9low3rubl1Q4Qxeee9uXIwR/JWWXnwQiUtLSSYzher
        g812PyV7K3eB6nG+r23Sar7LMExkxOQVo8bP2P0xMizegVd5uiFLt/+7v1MJg6fJpWPpC/
        Jg6OoWTj/KD0K6ZvuoGBbb5OuP4We3w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-wRPGKFJ_Pm265KfX806ahg-1; Mon, 07 Nov 2022 19:45:01 -0500
X-MC-Unique: wRPGKFJ_Pm265KfX806ahg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33A3F3817964;
        Tue,  8 Nov 2022 00:45:01 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B897140EBF5;
        Tue,  8 Nov 2022 00:44:54 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com> <Y2ks0NWEEfN8bWV1@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <1816d557-1546-f5f9-f2c3-25086c0826fa@redhat.com>
Date:   Tue, 8 Nov 2022 08:44:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2ks0NWEEfN8bWV1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 11/8/22 12:05 AM, Sean Christopherson wrote:
> On Sat, Nov 05, 2022, Gavin Shan wrote:
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index fecbb7d75ad2..758679724447 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -21,6 +21,16 @@ u32 kvm_dirty_ring_get_rsvd_entries(void)
>>   	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
>>   }
>>   
>> +bool kvm_use_dirty_bitmap(struct kvm *kvm)
>> +{
> 
> 	lockdep_assert_held(&kvm->slots_lock);
> 
> To guard against accessing kvm->dirty_ring_with_bitmap without holding slots_lock.
> 

Right, it makes sense to do so :)

>> +	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
>> +}
>> +
>> @@ -4588,6 +4594,31 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>   			return -EINVAL;
>>   
>>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
>> +		struct kvm_memslots *slots;
>> +		int r = -EINVAL;
>> +
>> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>> +		    !kvm->dirty_ring_size)
>> +			return r;
>> +
>> +		mutex_lock(&kvm->slots_lock);
>> +
>> +		slots = kvm_memslots(kvm);
> 
> Sadly, this needs to iterate over all possible memslots thanks to x86's SMM
> address space.  Might be worth adding a separate helper (that's local to kvm_main.c
> to discourage use), e.g.
> 
> static bool kvm_are_all_memslots_empty(struct kvm *kvm)
> {
> 	int i;
> 
> 	lockdep_assert_held(&kvm->slots_lock);
> 
> 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> 		if (!kvm_memslots_empty(__kvm_memslots(kvm, i)))
> 			return false;
> 	}
> 
> 	return true;
> }
> 

Strictly speaking, x86 doesn't reach to this point because we bail
on !CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP. However, it's still nice
to make the check complete. Besides, the lockdep_assert_held() is
duplicate to that one inside __kvm_memslots(). I would move the whole
hunk of code into kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap().
In this way, kvm_vm_ioctl_enable_cap_generic() looks clean at least.

>> +
>> +		/*
>> +		 * Avoid a race between memslot creation and enabling the ring +
>> +		 * bitmap capability to guarantee that no memslots have been
>> +		 * created without a bitmap.
> 
> Nit, it's not just enabling, the below also allows disabling the bitmap.  The
> enabling case is definitely the most interesting, but the above wording makes it
> sound like the enabling case is the only thing that being given protection.  That's
> kinda true since KVM frees bitmaps without checking kvm_use_dirty_bitmap(), but
> that's not a strict requirement.
> 
> And there's no race required, e.g. without this check userspace could simply create
> a memslot and then toggle on the capability.  Acquiring slots_lock above is what
> guards against races.
> 
> Might also be worth alluding to the alternative solution of allocating the bitmap
> for all memslots here, e.g. something like
> 
> 		/*
> 		 * For simplicity, allow toggling ring+bitmap if and only if
> 		 * there are no memslots, e.g. to ensure all memslots allocate a
> 		 * bitmap after the capability is enabled.
> 		 */
> 

Frankly, I don't expect the capability to be disabled. Similar to KVM_CAP_DIRTY_LOG_RING
or KVM_CAP_DIRTY_LOG_RING_ACQ_REL, it would a one-shot capability and only enablement is
allowed. The disablement was suggested by Oliver without providing a clarify, even I dropped
it for several times. I would like to see if there is particular reason why Oliver want
to disable the capability.

     kvm->dirty_ring_with_bitmap = cap->args[0];

If Oliver agrees that the capability needn't to be disabled. The whole chunk of
code can be squeezed into kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap() to
make kvm_vm_ioctl_enable_cap_generic() a bit clean, as I said above.

Sean and Oliver, could you help to confirm if the changes look good to you? :)

     static int kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap(struct kvm *kvm)
     {
         int i, r = 0;

         if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
             !kvm->dirty_ring_size)
             return -EINVAL;

         mutex_lock(&kvm->slots_lock);

         /* We only allow it to set once */
         if (kvm->dirty_ring_with_bitmap) {
             r = -EINVAL;
             goto out_unlock;
         }

         /*
          * Avoid a race between memslot creation and enabling the ring +
          * bitmap capability to guarantee that no memslots have been
          * created without a bitmap.
          */
         for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
             if (!kvm_memslots_empty(__kvm_memslots(kvm, i))) {
                 r = -EINVAL;
                 goto out_unlock;
             }
         }

         kvm->dirty_ring_with_bitmap = true;

     out_unlock:
         mutex_unlock(&kvm->slots_lock);

         return r;
     }

     static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
                                                struct kvm_enable_cap *cap)
     {
         switch (cap->cap) {
           :
         case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
             return kvm_vm_ioctl_enable_dirty_log_ring_with_bitmap(kvm);
         default:
             return kvm_vm_ioctl_enable_cap(kvm, cap);
         }
     }


>> +		 */
>> +		if (kvm_memslots_empty(slots)) {
>> +			kvm->dirty_ring_with_bitmap = cap->args[0];
>> +			r = 0;
>> +		}
>> +
>> +		mutex_unlock(&kvm->slots_lock);
>> +		return r;
>> +	}
>>   	default:
>>   		return kvm_vm_ioctl_enable_cap(kvm, cap);
>>   	}
>> -- 
> 

Thanks,
Gavin

