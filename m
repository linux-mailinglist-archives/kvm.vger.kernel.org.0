Return-Path: <kvm+bounces-36472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 37267A1B29A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 10:29:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33E51884162
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 09:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5F5219A89;
	Fri, 24 Jan 2025 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpLfyw7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD09218E91;
	Fri, 24 Jan 2025 09:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737710966; cv=none; b=sec4N+/rGSjq2G6tMAQF2pf/AE1IZQgW+B/mmRe2DTUQbZZqsNwcGGqBpx+rg90PqrlMgpOXW8paaCt3wgxpL3dPh7nNvaUXBOKavkYaCiU/p0sqoJvZPZNc/nKZDkhLz4v8d6YOZy4Id5QaDU25fUb4gkBaPYSdWb09YOz74Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737710966; c=relaxed/simple;
	bh=0AkQpPJmCBs//CaOlcFfYdOW7wemauTfeM9vMZzpxD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFagN/YBedkKvADaL1TENca/H5dp+5NOEbPdCMx6IKCJ/OY8GiNnK0Z79LZEtFVGEQ3b40TfVRMfjOYWFhDuLl870Q27aPh6ozYq6G7BPpTUILv23sgQwRbqJAJsq32ejhLK9BNEf2Fes6ean8So/Jm/7T04p60uc4p/Sy0jD80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UpLfyw7Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-436249df846so12209685e9.3;
        Fri, 24 Jan 2025 01:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737710963; x=1738315763; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jqyH6bhzvdcnBDUw10mu9jMZ7GZ86MpW0+sReCtDL8g=;
        b=UpLfyw7YmFtpT8iCaJDUj4ivPbqg9ejsM8CJhM15gEdNxd8cdrRkpupUcYfP84dXeS
         zXAb8hKKkZq/Ku4xPpeWaB5FmZIMzh4KpV8FNz97+A6uRk1VcoVAzOElBBeylGGRGaeu
         bG0OyuuAgfnuy/7HEgguQmo/r2je6BOPiaXvl+xh7L+QrggLqqbDU/ahwubfblkwOWCv
         jUKem+YjtxqmS+cwcPvw9tsscwiO8X8OVPgD2J66fsPNDeUoLFQpQAJ3tKR3I941d/dY
         P/31cMOmN9mFz4rjhB4k+ACTo+qeU6jSO5V8yQSvz+AJZ2ec2A5yWXbMVIdB+3tWRhrF
         uH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737710963; x=1738315763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jqyH6bhzvdcnBDUw10mu9jMZ7GZ86MpW0+sReCtDL8g=;
        b=NvJCiHffth3BQr+NSvYs6QTUath6Q169TzmFr/ymnSHRsvUzbtpClm3AKFwIsZS7yw
         AoLEJDbUAHnliE6RiWr0X43978ygo7teRN/8hB9F4XAaIV+RTPoMhvEftpgBbQz4/3FN
         gGFOEhLOQkJRDZwzouUEEvAugQH85s8bBwK0Gw54UtNdmBfKxpZEz5Phnt0dhuTYpC8Y
         ZH4QjFE7/09LISKpNcMHDy73wF0Wn1d54HYUXMu4vTxUqNNCu1eH1IHzOztaxmKCn8bK
         x7Ag18tPdMBpPGLoEDEdKxzRLJ7xpvd9AsB1vtdvHy4n75Ns2GJGTLPXBpTZg3BfjQ3n
         3ecw==
X-Forwarded-Encrypted: i=1; AJvYcCVnBhauTlyLJIq45Ncv8vitVWY3czx2riIzKavcIpGK+s8FHj+7PXlmeusss4w6JNgyKQ9SMGYRyunJet/k@vger.kernel.org, AJvYcCW8U9gWaVbXrCMoBq5EBVlluSynUBqKuKaFt+nn4KJrwps8euTrmG6ZuLhiHYSgrdSMlHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+uxb41Shncd2dP8ZmwfCPs2fqPgz6o+9u2jlWdQS7aF6pptb0
	LRDmKVqK3u/sGQkZP1jS95e5aRAuv7zyPiOQw/iULl5b77ijsGSFq7xkQli/eBg=
X-Gm-Gg: ASbGncuomCFoxFr8qpXd7w7Mb0R87tr7CLNAqLnKXKL+zYjl/Mfrv1328r7I4tHkPcb
	mWxBhxIKAaNiaZPbGUmaf72wQyMOuNGLwYXgnBHubLL32JJzlfIpzTQSEcJNqzL2PqslsgOfXRY
	MQ4mQcevmDcgKihhUp9f7iB9LaXOufUD99hhzwC95K6R4FMlbXyvBFk1KHpQVMyBs0MjQfgI/fc
	7d8aihcb7XPsw5QUdW9LdhPsi1s8nUymQ/1IcqEqqZXPBWpD/a3p3pczRfsI7gwopnRFsxaNy7v
	6LPyvR3217AdvhYweyHr+5+dBql61tRT7v+/qx0EFUWRb1Q=
X-Google-Smtp-Source: AGHT+IFziflbIefi1sIJaXB3yllWsc0XeGXMYUj0xGF6k2cK1obeh3fpvU6wVdjbUP+nzYtCVCQalg==
X-Received: by 2002:a05:600c:310a:b0:434:f335:855 with SMTP id 5b1f17b1804b1-43891440ab1mr245946755e9.28.1737710962385;
        Fri, 24 Jan 2025 01:29:22 -0800 (PST)
Received: from [192.168.18.210] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd501721sm19562045e9.9.2025.01.24.01.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 01:29:22 -0800 (PST)
Message-ID: <336f5623-b380-49e4-8dbe-ffa98f5aee19@gmail.com>
Date: Fri, 24 Jan 2025 09:29:20 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86: Update Xen TSC leaves during CPUID emulation
To: Sean Christopherson <seanjc@google.com>,
 David Woodhouse <dwmw2@infradead.org>
Cc: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org,
 griffoul@gmail.com, vkuznets@redhat.com, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>,
 linux-kernel@vger.kernel.org
References: <20250123190253.25891-1-fgriffo@amazon.co.uk>
 <c7b494d34d3e14531337311c286a9c06a99c9295.camel@infradead.org>
 <Z5LqeGa_G_NZ_boC@google.com>
Content-Language: en-US
From: "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <Z5LqeGa_G_NZ_boC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 24/01/2025 01:18, Sean Christopherson wrote:
> On Thu, Jan 23, 2025, David Woodhouse wrote:
>> On Thu, 2025-01-23 at 19:02 +0000, Fred Griffoul wrote:
>>
>>> +static inline void kvm_xen_may_update_tsc_info(struct kvm_vcpu *vcpu,
>>> +					       u32 function, u32 index,
>>> +					       u32 *eax, u32 *ecx, u32 *edx)
>>
>> Should this be called kvm_xen_maybe_update_tsc_info() ?
>>
>> Is it worth adding if (static_branch_unlikely(&kvm_xen_enabled.key))?
> 
> Or add a helper?  Especially if we end up processing KVM_REQ_CLOCK_UPDATE.
> 
> static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
> {
> 	return static_branch_unlikely(&kvm_xen_enabled.key) &&
> 	       vcpu->arch.xen.cpuid.base &&
> 	       function < vcpu->arch.xen.cpuid.limit;
> 	       function == (vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3));
> }
> 
>>
>>> +{
>>> +	u32 base = vcpu->arch.xen.cpuid.base;
>>> +
>>> +	if (base && (function == (base | XEN_CPUID_LEAF(3)))) {
> 
> Pretty sure cpuid.limit needs to be checked, e.g. to avoid a false positive in
> the unlikely scenario that userspace advertised a lower limit but still filled
> the CPUID entry.
> 
>>> +		if (index == 1) {
>>> +			*ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
>>> +			*edx = vcpu->arch.hv_clock.tsc_shift;
>>
>> Are these fields in vcpu->arch.hv_clock definitely going to be set?
> 
> Set, yes.  Up-to-date, no.  If there is a pending KVM_REQ_CLOCK_UPDATE, e.g. due
> to frequency change, KVM could emulate CPUID before processing the request if
> the CPUID VM-Exit occurred before the request was made.
> 
>> If so, can we have a comment to that effect? And perhaps a warning to
>> assert the truth of that claim?
>>
>> Before this patch, if the hv_clock isn't yet set then the guest would
>> see the original content of the leaves as set by userspace?
> 
> In theory, yes, but in practice that can't happen because KVM always pends a
> KVM_REQ_CLOCK_UPDATE before entering the guest (it's stupidly hard to see).
> 
> On the first kvm_arch_vcpu_load(), vcpu->cpu will be -1, which results in
> KVM_REQ_GLOBAL_CLOCK_UPDATE being pending.
> 
>    	if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
> 		...
> 
> 		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
> 			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> 
> 	}
> 
> That in turn triggers a KVM_REQ_CLOCK_UPDATE.
> 
> 		if (kvm_check_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu))
> 			kvm_gen_kvmclock_update(vcpu);
> 
>    static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
>    {
> 	struct kvm *kvm = v->kvm;
> 
> 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> 	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
> 					KVMCLOCK_UPDATE_DELAY);
>    }
> 
> And in the extremely unlikely failure path, which I assume handles the case where
> TSC calibration hasn't completed, KVM requests another KVM_REQ_CLOCK_UPDATE and
> aborts VM-Enter.  So AFAICT, it's impossible to trigger CPUID emulation without
> first stuffing Xen CPUID.
> 
> 	/* Keep irq disabled to prevent changes to the clock */
> 	local_irq_save(flags);
> 	tgt_tsc_khz = get_cpu_tsc_khz();
> 	if (unlikely(tgt_tsc_khz == 0)) {
> 		local_irq_restore(flags);
> 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
> 		return 1;
> 	}
> 
>> Now it gets zeroes if that happens?
> 
> Somewhat of a tangent, if userspace is providing non-zero values, commit f422f853af03
> ("KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present") would
> have broken userspace.  QEMU doesn't appear to stuff non-zero values and no one
> has complained, so I think we escaped this time.
> 
> Jumping back to the code, if we add kvm_xen_is_tsc_leaf(), I would be a-ok with
> handling the CPUID manipulations in kvm_cpuid().  I'd probably even prefer it,
> because overall I think bleeding a few Xen details into common code is worth
> making the flow easier to follow.
> 
> Putting it all together, something like this?  Compile tested only.
> 
> ---
>   arch/x86/kvm/cpuid.c | 16 ++++++++++++++++
>   arch/x86/kvm/x86.c   |  3 +--
>   arch/x86/kvm/x86.h   |  1 +
>   arch/x86/kvm/xen.c   | 23 -----------------------
>   arch/x86/kvm/xen.h   | 13 +++++++++++--
>   5 files changed, 29 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index edef30359c19..689882326618 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -2005,6 +2005,22 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   		} else if (function == 0x80000007) {
>   			if (kvm_hv_invtsc_suppressed(vcpu))
>   				*edx &= ~feature_bit(CONSTANT_TSC);
> +		} else if (IS_ENABLED(CONFIG_KVM_XEN) &&
> +			   kvm_xen_is_tsc_leaf(vcpu, function)) {
> +			/*
> +			 * Update guest TSC frequency information is necessary.
> +			 * Ignore failures, there is no sane value that can be
> +			 * provided if KVM can't get the TSC frequency.
> +			 */
> +			if (kvm_check_request(KVM_REQ_CLOCK_UPDATE, vcpu))
> +				kvm_guest_time_update(vcpu);
> +
> +			if (index == 1) {
> +				*ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
> +				*edx = vcpu->arch.hv_clock.tsc_shift;
> +			} else if (index == 2) {
> +				*eax = vcpu->arch.hw_tsc_khz;
> +			}
>   		}
>   	} else {
>   		*eax = *ebx = *ecx = *edx = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f61d71783d07..817a7e522935 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3173,7 +3173,7 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
>   	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
>   }
>   
> -static int kvm_guest_time_update(struct kvm_vcpu *v)
> +int kvm_guest_time_update(struct kvm_vcpu *v)
>   {
>   	unsigned long flags, tgt_tsc_khz;
>   	unsigned seq;
> @@ -3256,7 +3256,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   				   &vcpu->hv_clock.tsc_shift,
>   				   &vcpu->hv_clock.tsc_to_system_mul);
>   		vcpu->hw_tsc_khz = tgt_tsc_khz;
> -		kvm_xen_update_tsc_info(v);
>   	}
>   
>   	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 7a87c5fc57f1..5fdf32ba9406 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -362,6 +362,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>   u64 get_kvmclock_ns(struct kvm *kvm);
>   uint64_t kvm_get_wall_clock_epoch(struct kvm *kvm);
>   bool kvm_get_monotonic_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
> +int kvm_guest_time_update(struct kvm_vcpu *v);
>   
>   int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>   	gva_t addr, void *val, unsigned int bytes,
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index a909b817b9c0..ed5c2f088361 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -2247,29 +2247,6 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
>   	del_timer_sync(&vcpu->arch.xen.poll_timer);
>   }
>   
> -void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_cpuid_entry2 *entry;
> -	u32 function;
> -
> -	if (!vcpu->arch.xen.cpuid.base)
> -		return;
> -
> -	function = vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3);
> -	if (function > vcpu->arch.xen.cpuid.limit)
> -		return;
> -
> -	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
> -	if (entry) {
> -		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
> -		entry->edx = vcpu->arch.hv_clock.tsc_shift;
> -	}
> -
> -	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
> -	if (entry)
> -		entry->eax = vcpu->arch.hw_tsc_khz;
> -}

This LGTM. My only concern is whether vcpu->arch.hv_clock will be 
updated by anything other than a KVM_REQ_CLOCK_UPDATE? I don't think so 
but the crucial thing is that the values match what is in the vcpu_info 
struct... so maybe a safer option is to pull the values directly from that.

> -
>   void kvm_xen_init_vm(struct kvm *kvm)
>   {
>   	mutex_init(&kvm->arch.xen.xen_lock);
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index f5841d9000ae..5ee7f3f1b45f 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -9,6 +9,7 @@
>   #ifndef __ARCH_X86_KVM_XEN_H__
>   #define __ARCH_X86_KVM_XEN_H__
>   
> +#include <asm/xen/cpuid.h>
>   #include <asm/xen/hypervisor.h>
>   
>   #ifdef CONFIG_KVM_XEN
> @@ -35,7 +36,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
>   int kvm_xen_setup_evtchn(struct kvm *kvm,
>   			 struct kvm_kernel_irq_routing_entry *e,
>   			 const struct kvm_irq_routing_entry *ue);
> -void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
>   
>   static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
>   {
> @@ -50,6 +50,14 @@ static inline void kvm_xen_sw_enable_lapic(struct kvm_vcpu *vcpu)
>   		kvm_xen_inject_vcpu_vector(vcpu);
>   }
>   
> +static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
> +{
> +	return static_branch_unlikely(&kvm_xen_enabled.key) &&
> +	       vcpu->arch.xen.cpuid.base &&
> +	       function < vcpu->arch.xen.cpuid.limit &&
> +	       function == (vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3));
> +}
> +
>   static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
>   {
>   	return static_branch_unlikely(&kvm_xen_enabled.key) &&
> @@ -157,8 +165,9 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
>   	return false;
>   }
>   
> -static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
> +static inline bool kvm_xen_is_tsc_leaf(struct kvm_vcpu *vcpu, u32 function)
>   {
> +	return false;
>   }
>   #endif
>   
> 
> base-commit: 84be94b5b6490e29a6f386cec90f8d5c6d14f0df


