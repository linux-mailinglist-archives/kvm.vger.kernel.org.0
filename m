Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366FD446147
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 10:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhKEJXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 05:23:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhKEJXL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 05:23:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636104032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bun09NetE7JDJNJGbFv6Ho3fgYq2bCHVvzWF7zeutlg=;
        b=ibf7puZ6CZXVqwWARfe0yTgAkWNLd19jSCBKwZ0i50iGgQL01peFRZQyK3SGre6GTVKOpE
        ty6xoyI/bklOPe/21hTjatN7p57gPRs4zaCrbtHZS83aUqyzPAjyzyXN35zNkibx0y0aip
        LsdX8KB2JXdvptw/Vpv3DEdO9/WfDuw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-RW7vFkx8PHmKiiWxLGHDFw-1; Fri, 05 Nov 2021 05:20:31 -0400
X-MC-Unique: RW7vFkx8PHmKiiWxLGHDFw-1
Received: by mail-wr1-f69.google.com with SMTP id p3-20020a056000018300b00186b195d4ddso2092568wrx.15
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 02:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bun09NetE7JDJNJGbFv6Ho3fgYq2bCHVvzWF7zeutlg=;
        b=ANCoRkU+ViVflLjIubHb5Y91i/E25YPGwoZwrlwrNIbIj/4BFqL0KY5YgNXbYNA30b
         0BPO4VmZLt0NP8O8zHJ12iG6kZOC6awDjpRRn34FEpl3RyNmoJ6dyAKvkhPfM4pOAl3H
         pRB2dC8X/e1Ul1gAs4TetK6cTAqk7Fy2YSh+Vjl574Q9PMbqkHZZ0/h8esOAeMDmxOLq
         Q9NfEQYCEs+bBGm/j3SAsXiqusFdx+WInBIbkmcrpkJeIxgbCHB+EuiC+04a/y9AnlJp
         +1oGjnIW4iQ9hhCboLTAflWTFAga4LJQNRv0OKcMXkwd7xqhcU5IsbL7HWyvMPI2HxDr
         vF9g==
X-Gm-Message-State: AOAM531tAaVjvQpDTMX+3oxjWygS+JIWDzvTwlsTmBlO2mGstcdT2ny7
        f+luJ+W4+V5nOJzz4DbnvhVJyPPb/19zAc4MEHPjYmNmX5wKJduUozaRR8vXhBzvDov6kdoBJej
        eGF7TBHmeNrAb
X-Received: by 2002:a5d:47a9:: with SMTP id 9mr19168485wrb.42.1636104029965;
        Fri, 05 Nov 2021 02:20:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznjqHAZgw2ZU0GJAKmvawcs5UDGrCQ6HEHmIFCdiHmH+MLjAlL24qq0fPR/LEagdZ0NJTm2A==
X-Received: by 2002:a5d:47a9:: with SMTP id 9mr19168473wrb.42.1636104029780;
        Fri, 05 Nov 2021 02:20:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y10sm9312145wrd.84.2021.11.05.02.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 02:20:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paul Durrant <paul@xen.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: Make sure KVM_CPUID_FEATURES really are
 KVM_CPUID_FEATURES
In-Reply-To: <YYQzDLLE4WavR2Q6@google.com>
References: <20211104183020.4341-1-paul@xen.org> <YYQzDLLE4WavR2Q6@google.com>
Date:   Fri, 05 Nov 2021 10:20:28 +0100
Message-ID: <87sfwbklgj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Nov 04, 2021, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>> 
>> Currently when kvm_update_cpuid_runtime() runs, it assumes that the
>> KVM_CPUID_FEATURES leaf is located at 0x40000001. This is not true,
>> however, if Hyper-V support is enabled. In this case the KVM leaves will
>> be offset.
>> 
>> This patch introdues as new 'kvm_cpuid_base' field into struct
>> kvm_vcpu_arch to track the location of the KVM leaves and function
>> kvm_update_cpuid_base() (called from kvm_update_cpuid_runtime()) to locate
>> the leaves using the 'KVMKVMKVM\0\0\0' signature. Adjustment of
>> KVM_CPUID_FEATURES will hence now target the correct leaf.
>> 
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>> ---
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>
> scripts/get_maintainer.pl is your friend :-)
>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 +
>>  arch/x86/kvm/cpuid.c            | 50 +++++++++++++++++++++++++++++----
>>  2 files changed, 46 insertions(+), 5 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 88fce6ab4bbd..21133ffa23e9 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -725,6 +725,7 @@ struct kvm_vcpu_arch {
>>  
>>  	int cpuid_nent;
>>  	struct kvm_cpuid_entry2 *cpuid_entries;
>> +	u32 kvm_cpuid_base;
>>  
>>  	u64 reserved_gpa_bits;
>>  	int maxphyaddr;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 2d70edb0f323..2cfb8ec4f570 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -99,11 +99,46 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
>>  	return 0;
>>  }
>>  
>> +static void kvm_update_cpuid_base(struct kvm_vcpu *vcpu)
>> +{
>> +	u32 function;
>> +
>> +	for (function = 0x40000000; function < 0x40010000; function += 0x100) {
>
> No small part of me wants to turn hypervisor_cpuid_base() into a macro, but that's
> probably more pain than gain.  But I do think it would be worth providing a macro
> to iterate over possible bases and share that with the guest-side code.
>
>> +		struct kvm_cpuid_entry2 *best = kvm_find_cpuid_entry(vcpu, function, 0);
>
> Declare "struct kvm_cpuid_entry2 *best" outside of the loop to shorten this line.
> I'd also vote to rename "best" to "entry".  KVM's "best" terminology is a remnant
> of misguided logic that applied Intel's bizarre out-of-range behavior to internal
> KVM lookups.
>
>> +
>> +		if (best) {
>> +			char signature[12];
>> +
>> +			*(u32 *)&signature[0] = best->ebx;
>
> Just make signature a u32[3], then the casting craziness goes away.
>
>> +			*(u32 *)&signature[4] = best->ecx;
>> +			*(u32 *)&signature[8] = best->edx;
>> +
>> +			if (!memcmp(signature, "KVMKVMKVM\0\0\0", 12))
>
> The "KVMKVMKVM\0\0\0" magic string belongs in a #define that's shared with the
> guest-side code.  I
>
>> +				break;
>> +		}
>> +	}
>> +	vcpu->arch.kvm_cpuid_base = function;
>
> Unconditionally setting kvm_cpuid_base is silly because then kvm_get_cpuid_base()
> needs to check multiple "error" values.
>
> E.g. all of the above can be done as:
>
> 	struct kvm_cpuid_entry2 *entry;
> 	u32 base, signature[3];
>
> 	vcpu->arch.kvm_cpuid_base = 0;
>
> 	virt_for_each_possible_hypervisor_base(base) {
> 		entry = kvm_find_cpuid_entry(vcpu, base, 0);
> 		if (!entry)
> 			continue;
>
> 		signature[0] = entry->ebx;
> 		signature[1] = entry->ecx;
> 		signature[2] = entry->edx;
>
> 		if (!memcmp(signature, KVM_CPUID_SIG, sizeof(signature))) {
> 			vcpu->arch.kvm_cpuid_base = base;
> 			break;
> 		}
> 	}
>
>> +}
>> +
>> +static inline bool kvm_get_cpuid_base(struct kvm_vcpu *vcpu, u32 *function)
>> +{
>> +	if (vcpu->arch.kvm_cpuid_base < 0x40000000 ||
>> +	    vcpu->arch.kvm_cpuid_base >= 0x40010000)
>> +		return false;
>> +
>> +	*function = vcpu->arch.kvm_cpuid_base;
>> +	return true;
>
> If '0' is the "doesn't exist" value, then this helper goes away.
>
>> +}
>> +
>>  void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>>  {
>> +	u32 base;
>>  	struct kvm_cpuid_entry2 *best;
>>  
>> -	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
>> +	if (!kvm_get_cpuid_base(vcpu, &base))
>> +		return;
>
> ... and then this becomes:
>
> 	if (!vcpu->arch.kvm_cpuid_base)
> 		return;
>
> Actually, since this is a repated pattern and is likely going to be limited to
> getting KVM_CPUID_FEATURES, just add:
>
> struct kvm_find_cpuid_entry kvm_find_kvm_cpuid_features(void)

FWIW, if 'kvm_find_kvm_*' sounds too weird we can probably use
'kvm_find_pv_*' instead.

> {
> 	u32 base = vcpu->arch.kvm_cpuid_base;
>
> 	if (!base)
> 		return NULL;
>
> 	return kvm_find_cpuid_entry(vcpu, base | KVM_CPUID_FEATURES, 0);
> }
>
> and then all of the indentation churn goes away.
>
>> +
>> +	best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);
>>  
>>  	/*
>>  	 * save the feature bitmap to avoid cpuid lookup for every PV
>> @@ -116,6 +151,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
>>  void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_cpuid_entry2 *best;
>> +	u32 base;
>>  
>>  	best = kvm_find_cpuid_entry(vcpu, 1, 0);
>>  	if (best) {
>> @@ -142,10 +178,14 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>>  		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>>  		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>>  
>> -	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
>> -	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> -		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>> -		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>> +	kvm_update_cpuid_base(vcpu);
>
> The KVM base doesn't need to be rechecked for runtime updates.  Runtime updates
> are to handle changes in guest state, e.g. reported XSAVE size in response to a
> CR4.OSXSAVE change.  The raw CPUID entries themselves cannot change at runtime.
> I suspect you did this here because kvm_update_cpuid_runtime() is called before
> kvm_vcpu_after_set_cpuid(), but that has the very bad side effect of doing an
> _expensive_ lookup on every runtime update, which can get very painful if there's
> no KVM_CPUID_FEATURES to be found.
>
> If you include the prep patch (pasted at the bottom), then this can simply be
> (note the somewhat silly name; I think it's worth clarifying that it's the
> KVM_CPUID_* base that's being updated):
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0c99d2731076..5dd8c26e9f86 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -245,6 +245,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>         vcpu->arch.cpuid_entries = e2;
>         vcpu->arch.cpuid_nent = nent;
>  
> +       kvm_update_kvm_cpuid_base(vcpu);
>         kvm_update_cpuid_runtime(vcpu);
>         kvm_vcpu_after_set_cpuid(vcpu);
>  
>> +
>> +	if (kvm_get_cpuid_base(vcpu, &base)) {
>> +		best = kvm_find_cpuid_entry(vcpu, base + KVM_CPUID_FEATURES, 0);
>
> This is wrong.  base will be >0x40000000 and <0x40010000, and KVM_CPUID_FEATURES
> is 0x40000001, i.e. this will lookup 0x80000001 for the default base.  The '+'
> needs to be an '|'.
>
>> +		if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> +		    (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>> +			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
>> +	}
>>  
>>  	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
>>  		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
>> -- 
>> 2.20.1
>
>
> From 02d58c124f5aab1b0ef28cfc8a6ff6b6c58df969 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 4 Nov 2021 12:17:23 -0700
> Subject: [PATCH] KVM: x86: Add helper to consolidate core logic of
>  SET_CPUID{2} flows
>
> Move the core logic of SET_CPUID and SET_CPUID2 to a common helper, the
> only difference between the two ioctls() is the format of the userspace
> struct.  A future fix will add yet more code to the core logic.
>
> No functional change intended.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 47 ++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 751aa85a3001..0c99d2731076 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -232,6 +232,25 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
>  	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
>  }
>
> +static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> +			 int nent)
> +{
> +	int r;
> +
> +	r = kvm_check_cpuid(e2, nent);
> +	if (r)
> +		return r;
> +
> +	kvfree(vcpu->arch.cpuid_entries);
> +	vcpu->arch.cpuid_entries = e2;
> +	vcpu->arch.cpuid_nent = nent;
> +
> +	kvm_update_cpuid_runtime(vcpu);
> +	kvm_vcpu_after_set_cpuid(vcpu);
> +
> +	return 0;
> +}
> +
>  /* when an old userspace process fills a new kernel module */
>  int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  			     struct kvm_cpuid *cpuid,
> @@ -268,18 +287,9 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  		e2[i].padding[2] = 0;
>  	}
>
> -	r = kvm_check_cpuid(e2, cpuid->nent);
> -	if (r) {
> +	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
> +	if (r)
>  		kvfree(e2);
> -		goto out_free_cpuid;
> -	}
> -
> -	kvfree(vcpu->arch.cpuid_entries);
> -	vcpu->arch.cpuid_entries = e2;
> -	vcpu->arch.cpuid_nent = cpuid->nent;
> -
> -	kvm_update_cpuid_runtime(vcpu);
> -	kvm_vcpu_after_set_cpuid(vcpu);
>
>  out_free_cpuid:
>  	kvfree(e);
> @@ -303,20 +313,11 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  			return PTR_ERR(e2);
>  	}
>
> -	r = kvm_check_cpuid(e2, cpuid->nent);
> -	if (r) {
> +	r = kvm_set_cpuid(vcpu, e2, cpuid->nent);
> +	if (r)
>  		kvfree(e2);
> -		return r;
> -	}
>
> -	kvfree(vcpu->arch.cpuid_entries);
> -	vcpu->arch.cpuid_entries = e2;
> -	vcpu->arch.cpuid_nent = cpuid->nent;
> -
> -	kvm_update_cpuid_runtime(vcpu);
> -	kvm_vcpu_after_set_cpuid(vcpu);
> -
> -	return 0;
> +	return r;
>  }
>
>  int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
> --
>

-- 
Vitaly

