Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2278A30402A
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391341AbhAZOOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:14:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405770AbhAZONb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 09:13:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611670324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=luVuk1cRAL+7Q2eUjgakIFwdD5rSmc2UE4vCSNPJNEA=;
        b=Wuev/DbYBmQh7Nfmb8gJU/LBdmXQcMltf/Q9l5ZxPQRJE8CFVhq9OmEyL6gViLNHIAq5Qz
        wfM8if7anGnLGIuPRCmDfMQnPcR1HAgAHvquo0Dg8/1hy2FQZgWmtxs6FUaisM4DJrkcM1
        Gayx6vlqGLIvGP4qPJL13THZC0IxqRI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-gZy-t2LhPNSjvlbW5h5qYw-1; Tue, 26 Jan 2021 09:12:01 -0500
X-MC-Unique: gZy-t2LhPNSjvlbW5h5qYw-1
Received: by mail-ed1-f70.google.com with SMTP id f4so9424269eds.5
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 06:12:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=luVuk1cRAL+7Q2eUjgakIFwdD5rSmc2UE4vCSNPJNEA=;
        b=dHsaNLFF4Kuv30b34kZ5mzAf+Mv7b77vKSiMprFTOd2WO1Fpqr8QsF00LswG7aAdpt
         gu5TT8wvA/7qKCKACJOc2gI/0Xht1H8ivSzDRc1U9W77WrI7lVnqkcXBB/myUPShJbwA
         CKNVwXi/GiMEFT/2I/LLiPkPXff9SEqu3h6STEptVjyCumpMDQaYOWAOj2M8J+oQL2fs
         //YMLafq6fybC1QFYpwtyh/5UIlfLnBrBRlRFEkwhcnxt7mKnjKsiRHg8nR/sJvk/E9m
         S2KGMyxqwiqsArqeL4kSIbqupETSpZrjPI/ZJ0ainuFQ4Y2PaiWqHE8pu41LwbTkuccP
         Xb9g==
X-Gm-Message-State: AOAM533wI54WwifcbMkMBw4uHEG0aaCink4TYmwdU5+lVRKTBv7nuVej
        4B+GHqpO1su19ecCdwyDqE/9e7xnKG1Q9Ggu+64by5/PTYoE9E0l0jaoyIOiqHvUD9y+2FQf/LW
        OPCVmYim0GqMU
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr3600698ejv.509.1611670320089;
        Tue, 26 Jan 2021 06:12:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCJ1LNx+SciTYQByGY/JLdzQfbc2VNXHX5KlpA+OCW5j2jOX6LxTShuyFErV9N+j1jycMd0Q==
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr3600675ejv.509.1611670319866;
        Tue, 26 Jan 2021 06:11:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v20sm5948278edt.3.2021.01.26.06.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:11:58 -0800 (PST)
Subject: Re: [PATCH 04/24] kvm: x86/mmu: change TDP MMU yield function returns
 to match cond_resched
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-5-bgardon@google.com> <YAh4q6ZCOw3qDzHP@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2fd3afe-0345-7275-1bcc-32e7258ccd72@redhat.com>
Date:   Tue, 26 Jan 2021 15:11:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAh4q6ZCOw3qDzHP@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/21 19:38, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Ben Gardon wrote:
>> Currently the TDP MMU yield / cond_resched functions either return
>> nothing or return true if the TLBs were not flushed. These are confusing
>> semantics, especially when making control flow decisions in calling
>> functions.
>>
>> To clean things up, change both functions to have the same
>> return value semantics as cond_resched: true if the thread yielded,
>> false if it did not. If the function yielded in the _flush_ version,
>> then the TLBs will have been flushed.
>>
>> Reviewed-by: Peter Feiner <pfeiner@google.com>
>> Signed-off-by: Ben Gardon <bgardon@google.com>
>> ---
>>   arch/x86/kvm/mmu/tdp_mmu.c | 38 +++++++++++++++++++++++++++++---------
>>   1 file changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>> index 2ef8615f9dba..b2784514ca2d 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.c
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
>> @@ -413,8 +413,15 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>>   			 _mmu->shadow_root_level, _start, _end)
>>   
>>   /*
>> - * Flush the TLB if the process should drop kvm->mmu_lock.
>> - * Return whether the caller still needs to flush the tlb.
>> + * Flush the TLB and yield if the MMU lock is contended or this thread needs to
>> + * return control to the scheduler.
>> + *
>> + * If this function yields, it will also reset the tdp_iter's walk over the
>> + * paging structure and the calling function should allow the iterator to
>> + * continue its traversal from the paging structure root.
>> + *
>> + * Return true if this function yielded, the TLBs were flushed, and the
>> + * iterator's traversal was reset. Return false if a yield was not needed.
>>    */
>>   static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>>   {
>> @@ -422,18 +429,30 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
>>   		kvm_flush_remote_tlbs(kvm);
>>   		cond_resched_lock(&kvm->mmu_lock);
>>   		tdp_iter_refresh_walk(iter);
>> -		return false;
>> -	} else {
>>   		return true;
>> -	}
>> +	} else
>> +		return false;
> 
> Kernel style is to have curly braces on all branches if any branch has 'em.  Or,
> omit the else since the taken branch always returns.  I think I prefer the latter?
> 
>>   }
>>   
>> -static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>> +/*
>> + * Yield if the MMU lock is contended or this thread needs to return control
>> + * to the scheduler.
>> + *
>> + * If this function yields, it will also reset the tdp_iter's walk over the
>> + * paging structure and the calling function should allow the iterator to
>> + * continue its traversal from the paging structure root.
>> + *
>> + * Return true if this function yielded and the iterator's traversal was reset.
>> + * Return false if a yield was not needed.
>> + */
>> +static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>>   {
>>   	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
>>   		cond_resched_lock(&kvm->mmu_lock);
>>   		tdp_iter_refresh_walk(iter);
>> -	}
>> +		return true;
>> +	} else
>> +		return false;
> 
> Same here.
> 
>>   }
>>   
>>   /*
>> @@ -470,7 +489,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>>   		tdp_mmu_set_spte(kvm, &iter, 0);
>>   
>>   		if (can_yield)
>> -			flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>> +			flush_needed = !tdp_mmu_iter_flush_cond_resched(kvm,
>> +									&iter);
> 
> As with the existing code, I'd let this poke out.  Alternatively, this could be
> written as:
> 
> 		flush_needed = !can_yield ||
> 			       !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
> 
>>   		else
>>   			flush_needed = true;
>>   	}
>> @@ -1072,7 +1092,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>>   
>>   		tdp_mmu_set_spte(kvm, &iter, 0);
>>   
>> -		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>> +		spte_set = !tdp_mmu_iter_flush_cond_resched(kvm, &iter);
>>   	}
>>   
>>   	if (spte_set)
>> -- 
>> 2.30.0.284.gd98b1dd5eaa7-goog
>>
> 

Tweaked and queued, thanks.

Paolo

