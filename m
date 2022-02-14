Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBD34B5650
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 17:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355975AbiBNQeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 11:34:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343512AbiBNQeR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 11:34:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EBBAB30
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644856448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnJv2ShJTmuSWk3H5y3+1wz11d3NYIxxQwywrLGlhvI=;
        b=NrYNl3mksT/ZY8hcvdcfc8DEB6nzJNQbgfNmYOqtYAd5HIZobUlJaA2Yx9BqZGBeiGjmmW
        HyUW0mWJWHXZFXzwbSrqWT9Zknr3UP1KY2kWw+fe9Hcu2ZXx2E/NPXQOgLYqJu9gJWQB6o
        znUx8Cun60A5IlhQXtht3t5XK84nWz0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-Nw8vLcHNNgWsO1o5_fwIdA-1; Mon, 14 Feb 2022 11:34:06 -0500
X-MC-Unique: Nw8vLcHNNgWsO1o5_fwIdA-1
Received: by mail-ej1-f69.google.com with SMTP id r18-20020a17090609d200b006a6e943d09eso6081273eje.20
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 08:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bnJv2ShJTmuSWk3H5y3+1wz11d3NYIxxQwywrLGlhvI=;
        b=iNw10mLE1+LjxvojLpSRRSy2i9KMoWieVEzk0vyAwL+QUj/GiIZKU88HKgXH85o2De
         cqLbS6JqOW/cJk0W0rjACe1RNGzh1qr1soSqVdXg5tdOrCQZoPbiwTMAMOiYD6sGnIi4
         nxKvNCsej91zHRhqibT82+QL/ZExooVr16d2Oprv2iYZmKBNYPJbrRnbF0lwLXv+qoAg
         6yT2hVYmAs/a99SOyrB4uKHzRyZfIU9r5PR5xaUf9FfXI2pCzoXEFoFbYmmXz/mkvluJ
         VNoaeQhmRs0sEg7Vap7SSXBCniVuQ7rGMOmfRUTuSkynyJYXkb+TAZQs5EuPekkbKuM/
         quCA==
X-Gm-Message-State: AOAM530QQg0haZ0NV60cYo+Oeemw+oSGeKdLNOJON3lhjR4i+7H5/0We
        8x9ieoIfoEdBfqta4Qr3hk2L3JN2C/1ZXSrRs4Qw9I4BmGtGR8rgNo6cElvQXbByJ4ePPRh3xsf
        zWnXjLSd0R4Yi
X-Received: by 2002:a05:6402:50cf:: with SMTP id h15mr459256edb.102.1644856444496;
        Mon, 14 Feb 2022 08:34:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHDn0Qv6ErJnLxfiZUYl0VnR3xG3LEH29KUSclXdk6hXFCyl8l4gAulUVbddEil5pByefsPw==
X-Received: by 2002:a05:6402:50cf:: with SMTP id h15mr459230edb.102.1644856444130;
        Mon, 14 Feb 2022 08:34:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u2sm10727962ejb.127.2022.02.14.08.34.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 08:34:03 -0800 (PST)
Message-ID: <5f42d1ef-f6b7-c339-32b9-f4cf48c21841@redhat.com>
Date:   Mon, 14 Feb 2022 17:34:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role
 changes
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-13-pbonzini@redhat.com> <YgavcP/jb5njjKKn@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgavcP/jb5njjKKn@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 19:48, Sean Christopherson wrote:
> On Wed, Feb 09, 2022, Paolo Bonzini wrote:
>> kvm_mmu_reset_context is called on all role changes and right now it
>> calls kvm_mmu_unload.  With the legacy MMU this is a relatively cheap
>> operation; the previous PGDs remains in the hash table and is picked
>> up immediately on the next page fault.  With the TDP MMU, however, the
>> roots are thrown away for good and a full rebuild of the page tables is
>> necessary, which is many times more expensive.
>>
>> Fortunately, throwing away the roots is not necessary except when
>> the manual says a TLB flush is required:
>>
>> - changing CR0.PG from 1 to 0 (because it flushes the TLB according to
>>    the x86 architecture specification)
>>
>> - changing CPUID (which changes the interpretation of page tables in
>>    ways not reflected by the role).
>>
>> - changing CR4.SMEP from 0 to 1 (not doing so actually breaks access.c!)
>>
>> Except for these cases, once the MMU has updated the CPU/MMU roles
>> and metadata it is enough to force-reload the current value of CR3.
>> KVM will look up the cached roots for an entry with the right role and
>> PGD, and only if the cache misses a new root will be created.
>>
>> Measuring with vmexit.flat from kvm-unit-tests shows the following
>> improvement:
>>
>>               TDP         legacy       shadow
>>     before    46754       5096         5150
>>     after     4879        4875         5006
>>
>> which is for very small page tables.  The impact is however much larger
>> when running as an L1 hypervisor, because the new page tables cause
>> extra work for L0 to shadow them.
>>
>> Reported-by: Brad Spengler <spender@grsecurity.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c |  7 ++++---
>>   arch/x86/kvm/x86.c     | 27 ++++++++++++++++++---------
>>   2 files changed, 22 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 38b40ddcaad7..dbd4e98ba426 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5020,8 +5020,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
>>   void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   {
>>   	/*
>> -	 * Invalidate all MMU roles to force them to reinitialize as CPUID
>> -	 * information is factored into reserved bit calculations.
>> +	 * Invalidate all MMU roles and roots to force them to reinitialize,
>> +	 * as CPUID information is factored into reserved bit calculations.
>>   	 *
>>   	 * Correctly handling multiple vCPU models with respect to paging and
>>   	 * physical address properties) in a single VM would require tracking
>> @@ -5034,6 +5034,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
>>   	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
>>   	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
>> +	kvm_mmu_unload(vcpu);
>>   	kvm_mmu_reset_context(vcpu);
>>   
>>   	/*
>> @@ -5045,8 +5046,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   
>>   void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
>>   {
>> -	kvm_mmu_unload(vcpu);
>>   	kvm_init_mmu(vcpu);
>> +	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
> 
> This is too risky IMO, there are far more flows than just MOV CR0/CR4 that are
> affected, e.g. SMM transitions, KVM_SET_SREG, etc...

SMM exit does flush the TLB because RSM clears CR0.PG (I did check this 
:)).  SMM re-entry then does not need to flush.  But I don't think SMM 
exit should flush the TLB *for non-SMM roles*.

For KVM_SET_SREGS I'm not sure if it should flush the TLB, but I agree 
it is certainly safer to keep it that way.

> Given that kvm_post_set_cr{0,4}() and kvm_vcpu_reset() explicitly handle CR0.PG
> and CR4.SMEP toggling, I highly doubt the other flows are correct in all instances.
> The call to kvm_mmu_new_pgd() is also

*white noise*

> To minimize risk, we should leave kvm_mmu_reset_context() as is (rename it if
> necessary) and instead add a new helper to handle kvm_post_set_cr{0,4}().  In
> the future we can/should work on avoiding unload in all paths, but again, future
> problem.

I disagree on this.  There aren't many calls to kvm_mmu_reset_context.

>>   
>> -	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
>> +	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
>> +		/* Flush the TLB if CR0 is changed 1 -> 0.  */
>> +		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
>> +			kvm_mmu_unload(vcpu);
> 
> Calling kvm_mmu_unload() instead of requesting a flush isn't coherent with respect
> to the comment, or with SMEP handling.  And the SMEP handling isn't coherent with
> respect to the changelog.  Please elaborate :-)

Yep, will do (the CR0.PG=0 case is similar to the CR0.PCIDE=0 case 
below).  Using kvm_mmu_unload() avoids loading a cached root just to 
throw it away immediately after, but I can change this to a new 
KVM_REQ_MMU_UPDATE_ROOT flag that does

	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);

By the way, I have a possibly stupid question.  In kvm_set_cr3 (called 
e.g. from emulator_set_cr()) there is

  	if (cr3 != kvm_read_cr3(vcpu))
		kvm_mmu_new_pgd(vcpu, cr3);

What makes this work if mmu_is_nested(vcpu)?  Should this also have an 
"if (... & !tdp_enabled)"?

>> -	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
>> +		if ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP))
>> +			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
> 
> This mishandles CR4.PGE.  Per the comment above, the if-elif-elif sequence relies
> on kvm_mmu_reset_context being a superset of KVM_REQ_TLB_FLUSH_GUEST.
> 
> For both CR0 and CR4, I think we should disassociate the TLB flush logic from the
> MMU role logic, e.g. CR4.PGE _could_ be part of the role, but it's not because KVM
> doesn't emulate global pages.

Makes sense, yes.  It also needs to handle flushing the current PCID 
when changing CR4.PAE (previously done for "free" by 
kvm_mmu_reset_context), but I agree with the idea.

Paolo

> This is what I'm thinking, assuming CR0.PG 1=>0 really only needs a flush.
> 
> 
> ---
>   arch/x86/kvm/mmu/mmu.c |  4 ++--
>   arch/x86/kvm/x86.c     | 42 +++++++++++++++++++++++++++++-------------
>   2 files changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e41834748d52..c477c519c784 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5041,8 +5041,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
>   void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   {
>   	/*
> -	 * Invalidate all MMU roles to force them to reinitialize as CPUID
> -	 * information is factored into reserved bit calculations.
> +	 * Invalidate all MMU roles and roots to force them to reinitialize,
> +	 * as CPUID information is factored into reserved bit calculations.
>   	 *
>   	 * Correctly handling multiple vCPU models with respect to paging and
>   	 * physical address properties) in a single VM would require tracking
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 782dc9cd31d8..b8dad04301ee 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -863,15 +863,28 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
>   }
>   EXPORT_SYMBOL_GPL(load_pdptrs);
> 
> +static void kvm_post_set_cr_reinit_mmu(struct kvm_vcpu *vcpu)
> +{
> +	kvm_mmu_init(vcpu);
> +	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
> +}
> +
>   void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
>   {
>   	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>   		kvm_clear_async_pf_completion_queue(vcpu);
>   		kvm_async_pf_hash_reset(vcpu);
> +
> +		/*
> +		 * Clearing CR0.PG is architecturally defined as flushing the
> +		 * TLB from the guest's perspective.
> +		 */
> +		if (!(cr0 & X86_CR0_PG))
> +			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>   	}
> 
>   	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
> -		kvm_mmu_reset_context(vcpu);
> +		kvm_post_set_cr_reinit_mmu(vcpu);
> 
>   	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
>   	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
> @@ -1055,26 +1068,29 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
>   void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
>   {
>   	/*
> -	 * If any role bit is changed, the MMU needs to be reset.
> -	 *
>   	 * If CR4.PCIDE is changed 1 -> 0, the guest TLB must be flushed.
>   	 * If CR4.PCIDE is changed 0 -> 1, there is no need to flush the TLB
>   	 * according to the SDM; however, stale prev_roots could be reused
>   	 * incorrectly in the future after a MOV to CR3 with NOFLUSH=1, so we
>   	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
>   	 * is slow, but changing CR4.PCIDE is a rare case.
> -	 *
> -	 * If CR4.PGE is changed, the guest TLB must be flushed.
> -	 *
> -	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
> -	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
> -	 * the usage of "else if".
>   	 */
> -	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> -		kvm_mmu_reset_context(vcpu);
> -	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
> +	if ((cr4 ^ old_cr4) & X86_CR4_PCIDE) {
>   		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
> -	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
> +		return;
> +	}
> +
> +	/* If any role bit is changed, the MMU needs to be reinitialized. */
> +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> +		kvm_post_set_cr_reinit_mmu(vcpu);
> +
> +	/*
> +	 * Setting SMEP or toggling PGE is architecturally defined as flushing
> +	 * the TLB from the guest's perspective.  Note, because the shadow MMU
> +	 * ignores global pages, CR4.PGE is not part of KVM_MMU_CR4_ROLE_BITS.
> +	 */
> +	if (((cr4 ^ old_cr4) & X86_CR4_PGE) ||
> +	    ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP)))
>   		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_post_set_cr4);
> 
> base-commit: a8c36d04d70d0b15e696561e1a2134fcbdd3a3bd
> --
> 

