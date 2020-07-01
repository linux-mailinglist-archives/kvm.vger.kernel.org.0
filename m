Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050322104C4
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 09:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGAHOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 03:14:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727981AbgGAHO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 03:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593587667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDri2wVbiZD6ehChmeSXuSPV/fqPWCU1uyCnw8k16cM=;
        b=c8dieeoesqfzQW/TAfiq8gDyJT9RXU5kyQ5rIvHYonBHbecqO3nKq2dgOw9Jts1ryHoPv4
        GKGOeEYIDBQ0wMdMFuA9yFKR3rzQMki5E+isbMKEp0GjhhLTuf1DOTjHX2eku/ZPDtXC8s
        LoL5YHClUNl/nnEVWcLJTIWzJxDPdO8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-kdkOSaEAOV2HqfwecqAQoQ-1; Wed, 01 Jul 2020 03:14:26 -0400
X-MC-Unique: kdkOSaEAOV2HqfwecqAQoQ-1
Received: by mail-ed1-f69.google.com with SMTP id 92so18729466edl.8
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 00:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VDri2wVbiZD6ehChmeSXuSPV/fqPWCU1uyCnw8k16cM=;
        b=cop6J4EzUj/5v5/dQnWX8APxg8EEagXtvqbFeVQWuOnC1Ch5r4bRNJIYnAqjIvPK+j
         KFbUzkcSaijcaediYH42t3c8PJfH5dRZDoD8zirsU8Y3RNFOvJlWNnHg0EA28HYCy8Q4
         kxuwbvbV5ymUiGWZ9/6TDtXnNVbvKTZXyaUo6ILwsuwnn2bq/OrpXvqCwitNSc20GX9G
         y1Nn45zdVVrmpdAL6LqB6cCU/rX3N2l9xS6ziNyqdSSGgOrfiW4AhpePMKIJ14yo/mIR
         EckJftnkDxuh/iVdXtZF7Tg0w41ZCDv/5iWXlOojPvWhLVfWMA76snDBsvPg+4K7/JBS
         HE/Q==
X-Gm-Message-State: AOAM530pSPKXruqwvfhz8i59SGl8HY5zfd1N42wfuhaiXp22BX2s2iE6
        XOybOK1b4rMr/NlnpW3v7kYRu8sZDoN9HI2mG6hnWnyYbWLc71Nb6sr03xszABvQ9PoW1R8hZiR
        AQpSoQ9AMIh/e
X-Received: by 2002:a17:906:c452:: with SMTP id ck18mr22807598ejb.415.1593587665077;
        Wed, 01 Jul 2020 00:14:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLfSJIpDI6snfHAvpom7GIuiRRpE4Ll1MJoMLi7Z9Bn0wYmhwULtCfStE/67tvD3y0dWiOZg==
X-Received: by 2002:a17:906:c452:: with SMTP id ck18mr22807579ejb.415.1593587664814;
        Wed, 01 Jul 2020 00:14:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o21sm3847754eja.37.2020.07.01.00.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 00:14:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: drop erroneous mmu_check_root() from fast_pgd_switch()
In-Reply-To: <a8f60652-c419-58bc-fe78-67954fc6d4c1@google.com>
References: <20200630100742.1167961-1-vkuznets@redhat.com> <a8f60652-c419-58bc-fe78-67954fc6d4c1@google.com>
Date:   Wed, 01 Jul 2020 09:14:23 +0200
Message-ID: <87eepvbtbk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Junaid Shahid <junaids@google.com> writes:

> On 6/30/20 3:07 AM, Vitaly Kuznetsov wrote:
>> Undesired triple fault gets injected to L1 guest on SVM when L2 is
>> launched with certain CR3 values. It seems the mmu_check_root()
>> check in fast_pgd_switch() is wrong: first of all we don't know
>> if 'new_pgd' is a GPA or a nested GPA and, in case it is a nested
>> GPA, we can't check it with kvm_is_visible_gfn().
>> 
>> The problematic code path is:
>> nested_svm_vmrun()
>>    ...
>>    nested_prepare_vmcb_save()
>>      kvm_set_cr3(..., nested_vmcb->save.cr3)
>>        kvm_mmu_new_pgd()
>>          ...
>>          mmu_check_root() -> TRIPLE FAULT
>> 
>> The mmu_check_root() check in fast_pgd_switch() seems to be
>> superfluous even for non-nested case: when GPA is outside of the
>> visible range cached_root_available() will fail for non-direct
>> roots (as we can't have a matching one on the list) and we don't
>> seem to care for direct ones.
>> 
>> Also, raising #TF immediately when a non-existent GFN is written to CR3
>> doesn't seem to mach architecture behavior.
>> 
>> Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> - The patch fixes the immediate issue and doesn't seem to break any
>>    tests even with shadow PT but I'm not sure I properly understood
>>    why the check was there in the first place. Please review!
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 76817d13c86e..286c74d2ae8d 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4277,8 +4277,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>>   	 */
>>   	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
>>   	    mmu->root_level >= PT64_ROOT_4LEVEL)
>> -		return !mmu_check_root(vcpu, new_pgd >> PAGE_SHIFT) &&
>> -		       cached_root_available(vcpu, new_pgd, new_role);
>> +		return cached_root_available(vcpu, new_pgd, new_role);
>>   
>>   	return false;
>>   }
>> 
>
> The check does seem superfluous, so should be ok to remove. Though I
> think that fast_pgd_switch() really should be getting only L1
> GPAs. Otherwise, there could be confusion between the same GPAs from
> two different L2s.
>
> IIUC, at least on Intel, only L1 CR3s (including shadow L1 CR3s for
> L2) or L1 EPTPs should get to fast_pgd_switch(). But I am not familiar
> enough with SVM to see why an L2 GPA would end up there. From a
> cursory look, it seems that until "978ce5837c7e KVM: SVM: always
> update CR3 in VMCB", enter_svm_guest_mode() was calling kvm_set_cr3()
> only when using shadow paging, in which case I assume that
> nested_vmcb->save.cr3 would have been an L1 CR3 shadowing the L2 CR3,
> correct? But now kvm_set_cr3() is called even when not using shadow
> paging, which I suppose is how we are getting the L2 CR3. Should we
> skip calling fast_pgd_switch() in that particular case?

Thank you for your thoughts, this is helpful indeed.

As far as I can see, nVMX calls kvm_mmu_new_pgd() directly in two cases:

1) nested_ept_init_mmu_context() -> kvm_init_shadow_ept_mmu() when
switching to L2 (and 'new_pgd' is EPTP)

2) nested_vmx_load_cr3() when !nested_ept (and 'new_pgd' is 'cr3')

I think we need to do something similar for nSVM to make the root cache
work and work correctly:

1) supplement nested_svm_init_mmu_context() -> kvm_init_shadow_mmu()
with kvm_mmu_new_pgd()

2) stop doing kvm_mmu_new_pgd() from nested_prepare_vmcb_save() ->
kvm_set_cr3() when npt_enabled

Let me try to experiment here a bit.

Thanks again!

-- 
Vitaly

