Return-Path: <kvm+bounces-37329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48027A2895D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 12:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1477E1888125
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E324D22B5B8;
	Wed,  5 Feb 2025 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0Rz7uZk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E315E22A4F2
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755391; cv=none; b=LndWXaRTqoynWPkzcSwNPld2z+oV8WeDA6SAIOurn2o5tsCfp1qBjW2vq7Y+qiEy81n4g5Ya001kC3+YCuGXtyjprMigqwdQz9qRqrruXWebEnt5ncT0I65JVBdjyJ9Acezbx4EehOQ8qwjlZ7PJLowaI93yayOGdftq0GQeyiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755391; c=relaxed/simple;
	bh=H3o9FXGg8OoUfC/IaZKaofv7l61uXqzyCtcz1HVqrrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+ayLBDNW1DwrWCDn/993sHJn/pVhRBw1h4uB3fLPnqxkAYeDcsCBYAGtqKSlJAyTn+JUKgxAnbXbOSXIAaSEpjxKDuNaWlSJndW/iWJZ22v4PMLUwj2s6+CHfCspRHCfurowKICDrXY68UQhsz9zApt9eD/W9ZKarPtY+QfQ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0Rz7uZk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738755387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cjfHY65x/nR1yr0qlrbwdy8v+H9m3LpaMSO+gaLzO1w=;
	b=K0Rz7uZk1vYV3qNjjAZwqjScgvmQNcuEpwNp7Exu2gYk0fhU4l156Se3WGWA8ssmahIR6F
	SnASwHXM0MKn2i+8hmdXBtyVWHzRQpQDol1br4a4mdEujs1XnA2J21Nb8SJ7Dlz3KGCYt/
	uTmq3T+adyLZkPwUmuOgCXydNWZ0bXo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-_crf_sVzPPqkkeQWOynVgQ-1; Wed, 05 Feb 2025 06:36:26 -0500
X-MC-Unique: _crf_sVzPPqkkeQWOynVgQ-1
X-Mimecast-MFC-AGG-ID: _crf_sVzPPqkkeQWOynVgQ
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa67855b3deso550842366b.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 03:36:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755385; x=1739360185;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cjfHY65x/nR1yr0qlrbwdy8v+H9m3LpaMSO+gaLzO1w=;
        b=BvGmynX8uuClLUaAdyPaNCWcvIdS4ziaPhmtB5hOQ0sryB4z4/hRmik92jIrWrr4wb
         jrChW+iND4tWoYxkv4iAJp8tVC8IkxPChg/YuKkll59YQsLv2cu91ld2/DvumBuTsoQV
         FlDsi20MyRBO5aDqJN1q4n6Nus4+VB21jB7i2ukaCSAYYh8lmQ+we0njeCPb93q3sttd
         F9JW2f3fK9detLhUwL9B8WqPjuD+Tqo/joDCi/hvbmyuXs/GIjkmb5Y9PKp1FPQrUCX3
         7lP0b4ju7oWXwoAv6CzOJxlVW1+flO7KEjRzntmfbRHoPKLTaeTs1FLFbwIcTupElJB1
         bHhA==
X-Forwarded-Encrypted: i=1; AJvYcCWPO4hlFRDjw322EqFlEtKzCZQUZsqDn/jflYs+oEo6KJHVdxvKUS5jByPBzxu2XCSDCUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMWLNcv5abFEtHNdk1fUxT/xXzx+z/jVNHxSQuqiAj/ApsQBah
	p1vNseOcvwqlofW3N+3W5KhTJCIhs8vt7YXZA6+inGY8pZDGxiRCutywmP6mce452Rgsa9ZqByr
	fLnAU1A/bikSF1YbJ+PIgYxKcxNCDRcx3dLvGPihCp0nWkl2TUA==
X-Gm-Gg: ASbGncuRJIkWvJtfRiiYlcEhtlXmVQY0fU75n7el3tAveAX/anNwswMmzCcR6femh4Y
	3yitPeqzlxPjMH+KRZ4XYW46n8VOC7xn9u2rPhKw3OaQscO+Rdx6auFccBqzVseEHJpfeyhB+J9
	G3e7nshVSQU0W316G8ND0ESEWme6vI3emz5tqu+4oDycreCjolNjkCJ2DBIszp/bYiwTsxrOIKy
	3Bh2/s8iMJJf4ZqCjhCJwkwuwrjUg2tE4DswZwWVczkypCdwhDGumLt0Bf19BMGA6nHMXXbAGcy
	W93sks0=
X-Received: by 2002:a17:906:f59c:b0:ab7:5985:5bad with SMTP id a640c23a62f3a-ab75e245043mr257596966b.4.1738755383658;
        Wed, 05 Feb 2025 03:36:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFw17iDZYKUU6z9Z8iwoUay3A2Vnjuk8PPif7ETLu1KZ9X1rrGNn8lTxFxbUu2zbOT6bzcXXg==
X-Received: by 2002:a17:906:f59c:b0:ab7:5985:5bad with SMTP id a640c23a62f3a-ab75e245043mr257592066b.4.1738755383099;
        Wed, 05 Feb 2025 03:36:23 -0800 (PST)
Received: from [192.168.10.48] ([151.62.97.55])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ab6e47f1db3sm1082653866b.83.2025.02.05.03.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 03:36:22 -0800 (PST)
Message-ID: <604c0d57-ed91-44d2-80d7-4d3710b04142@redhat.com>
Date: Wed, 5 Feb 2025 12:36:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
 <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z6JoInXNntIoHLQ8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 20:18, Sean Christopherson wrote:
> On Mon, Feb 03, 2025, Maxim Levitsky wrote:
>> On Mon, 2025-02-03 at 15:46 -0800, Sean Christopherson wrote:
>>> On Mon, Feb 03, 2025, Paolo Bonzini wrote:
>>>> On 2/3/25 19:45, Sean Christopherson wrote:
>>>>> Unless there's a very, very good reason to support a use case that generates
>>>>> ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
>>>>> ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
>>>>> clear it.
>>>>
>>>> BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
>>>> of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
>>>> it to APICV_INHIBIT_REASON_PIT_REINJ.
>>>
>>> That won't work, at least not with yet more changes, because KVM creates the
>>> in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
>>> if a bit is set and can never be cleared, then there's no need to track new
>>> updates.  Since userspace needs to explicitly disable reinjection, the inhibit
>>> can't be sticky.
>> I confirmed this with a trace, this is indeed the case.
>>
>>>
>>> I assume We could fudge around that easily enough by deferring the inhibit until
>>> a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
>>> I/O APIC case.
>>>
>>>> I don't love adding another inhibit reason but, together, these two should
>>>> remove the contention on apicv_update_lock.  Another idea could be to move
>>>> IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.
>>
>> I retract this statement, it was based on my knowledge from back when I
>> implemented it.
>>
>> Looking at the current code again, this should be possible and can be a nice
>> cleanup regardless.
>>
>> (Or I just might have forgotten the reason that made me think back then that
>> this is not worth it, because I do remember well that I wanted to make IRQWIN
>> inhibit to be per vcpu)
> 
> The complication is the APIC page.  That's not a problem for vCPUs running in L2
> because they'll use a different MMU, i.e. a different set of SPTEs that never map
> the APIC backing page.  At least, that's how it's supposed to work[*].  ;-)
> 
> For IRQWIN, turning off APICv for the current vCPU will leave the APIC SPTEs in
> place and so KVM will fail to intercept accesses to the APIC page.  And making
> IRQWIN a per-vCPU inhibit won't help performance in the case where there is no
> other inhibit, because (a) toggling it on/off requires taking mmu_lock for writing
> and doing a remote TLB flush, and (b) unless the guest is doing something bizarre,
> only one vCPU will be receiving ExtInt IRQs.  I.e. I don't think trying to make
> IRQWIN a pure per-vCPU inhibit is necessary for performance.
> 
> After fiddling with a bunch of ideas, I think the best approach to address both
> issues is to add a counter for the IRQ window (addresses the per-vCPU aspect of
> IRQ windows), set/clear the IRQWIN inhibit according to the counter when *any*
> inhibit changes, and then force an immediate update if and only if the count hits
> a 0<=>1 transition *and* there is no other inhibit.  That would address the flaw
> Naveen found without needing to make PIT_REINJ sticky.
> 
> Guarding the count with apicv_update_lock held for read ensures that if there is
> a racing change to a different inhibit, that either kvm_inc_or_dec_irq_window_inhibit()
> will see no inhibits and go down the slow path, or __kvm_set_or_clear_apicv_inhibit()
> will set IRQWIN accordingly.
> 
> Compile tested only (and probably needs to be split into multiple patches).  I'll
> try to take it for a spin later today.
> 
> [*] https://lore.kernel.org/all/20250130010825.220346-1-seanjc@google.com
> 
> ---
>   arch/x86/include/asm/kvm_host.h | 13 ++++++++++
>   arch/x86/kvm/svm/svm.c          | 43 +++++++++------------------------
>   arch/x86/kvm/svm/svm.h          |  1 +
>   arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++++-
>   4 files changed, 61 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5193c3dfbce1..9e3465e70a0a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1365,6 +1365,7 @@ struct kvm_arch {
>   	/* Protects apicv_inhibit_reasons */
>   	struct rw_semaphore apicv_update_lock;
>   	unsigned long apicv_inhibit_reasons;
> +	atomic_t apicv_irq_window;
>   
>   	gpa_t wall_clock;
>   
> @@ -2203,6 +2204,18 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> +void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc);
> +
> +static inline void kvm_inc_apicv_irq_window(struct kvm *kvm)
> +{
> +	kvm_inc_or_dec_irq_window_inhibit(kvm, true);
> +}
> +
> +static inline void kvm_dec_apicv_irq_window(struct kvm *kvm)
> +{
> +	kvm_inc_or_dec_irq_window_inhibit(kvm, false);
> +}
> +
>   unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   				      unsigned long a0, unsigned long a1,
>   				      unsigned long a2, unsigned long a3,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..668db3bfff3d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1636,9 +1636,13 @@ static void svm_set_vintr(struct vcpu_svm *svm)
>   	struct vmcb_control_area *control;
>   
>   	/*
> -	 * The following fields are ignored when AVIC is enabled
> +	 * vIRQ is ignored by hardware AVIC is enabled, and so AVIC must be
> +	 * inhibited to detect the interrupt window.
>   	 */
> -	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));
> +	if (enable_apicv && !is_guest_mode(&svm->vcpu)) {
> +		svm->avic_irq_window = true;
> +		kvm_inc_apicv_irq_window(svm->vcpu.kvm);
> +	}
>   
>   	svm_set_intercept(svm, INTERCEPT_VINTR);
>   
> @@ -1666,6 +1670,11 @@ static void svm_set_vintr(struct vcpu_svm *svm)
>   
>   static void svm_clear_vintr(struct vcpu_svm *svm)
>   {
> +	if (svm->avic_irq_window && !is_guest_mode(&svm->vcpu)) {
> +		svm->avic_irq_window = false;
> +		kvm_dec_apicv_irq_window(svm->vcpu.kvm);
> +	}
> +
>   	svm_clr_intercept(svm, INTERCEPT_VINTR);
>   
>   	/* Drop int_ctl fields related to VINTR injection.  */
> @@ -3219,20 +3228,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
>   	kvm_make_request(KVM_REQ_EVENT, vcpu);
>   	svm_clear_vintr(to_svm(vcpu));
>   
> -	/*
> -	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
> -	 * In this case AVIC was temporarily disabled for
> -	 * requesting the IRQ window and we have to re-enable it.
> -	 *
> -	 * If running nested, still remove the VM wide AVIC inhibit to
> -	 * support case in which the interrupt window was requested when the
> -	 * vCPU was not running nested.
> -
> -	 * All vCPUs which run still run nested, will remain to have their
> -	 * AVIC still inhibited due to per-cpu AVIC inhibition.
> -	 */
> -	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> -
>   	++vcpu->stat.irq_window_exits;
>   	return 1;
>   }
> @@ -3879,22 +3874,8 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
>   	 * enabled, the STGI interception will not occur. Enable the irq
>   	 * window under the assumption that the hardware will set the GIF.
>   	 */
> -	if (vgif || gif_set(svm)) {
> -		/*
> -		 * IRQ window is not needed when AVIC is enabled,
> -		 * unless we have pending ExtINT since it cannot be injected
> -		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
> -		 * and fallback to injecting IRQ via V_IRQ.
> -		 *
> -		 * If running nested, AVIC is already locally inhibited
> -		 * on this vCPU, therefore there is no need to request
> -		 * the VM wide AVIC inhibition.
> -		 */
> -		if (!is_guest_mode(vcpu))
> -			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> -
> +	if (vgif || gif_set(svm))
>   		svm_set_vintr(svm);
> -	}
>   }
>   
>   static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..8eefed0a865a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -323,6 +323,7 @@ struct vcpu_svm {
>   
>   	bool guest_state_loaded;
>   
> +	bool avic_irq_window;
>   	bool x2avic_msrs_intercepted;
>   
>   	/* Guest GIF value, used when vGIF is not enabled */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b2d9a16fd4d3..7388f4cfe468 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10604,7 +10604,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   
>   	old = new = kvm->arch.apicv_inhibit_reasons;
>   
> -	set_or_clear_apicv_inhibit(&new, reason, set);
> +	if (reason != APICV_INHIBIT_REASON_IRQWIN)
> +		set_or_clear_apicv_inhibit(&new, reason, set);
> +
> +	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
> +				   atomic_read(&kvm->arch.apicv_irq_window));
>   
>   	if (!!old != !!new) {
>   		/*
> @@ -10645,6 +10649,36 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
>   
> +void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
> +{
> +	bool toggle;
> +
> +	/*
> +	 * The IRQ window inhibit has a cyclical dependency of sorts, as KVM
> +	 * needs to manually inject IRQs and thus detect interrupt windows if
> +	 * APICv is disabled/inhibitied.  To avoid thrashing if the IRQ window
> +	 * is being requested because APICv is already inhibited, toggle the
> +	 * actual inhibit (and take the lock for write) if and only if there's
> +	 * no other inhibit.  KVM evaluates the IRQ window count when _any_
> +	 * inhibit changes, i.e. the IRQ window inhibit can be lazily updated
> +	 * on the next inhibit change (if one ever occurs).
> +	 */
> +	down_read(&kvm->arch.apicv_update_lock);
> +
> +	if (inc)
> +		toggle = atomic_inc_return(&kvm->arch.apicv_irq_window) == 1;
> +	else
> +		toggle = atomic_dec_return(&kvm->arch.apicv_irq_window) == 0;
> +
> +	toggle = toggle && !(kvm->arch.apicv_inhibit_reasons & ~BIT(APICV_INHIBIT_REASON_IRQWIN));
> +
> +	up_read(&kvm->arch.apicv_update_lock);
> +
> +	if (toggle)
> +		kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);

I'm not super confident in breaking the critical section...  Another possibility:

void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
{
         int add = inc ? 1 : -1;

	if (!enable_apicv)
		return;

         /*
         * IRQ windows happen either because of ExtINT injections, or because
	* APICv is already disabled/inhibited for another reason.  While ExtINT
	* injections are rare and should not happen while the vCPU is running
	* its actual workload, it's worth avoiding thrashing if the IRQ window
         * is being requested because APICv is already inhibited.  So, toggle the
         * the actual inhibit (which requires taking the lock forwrite) if and
	* only if there's no other inhibit.  kvm_set_or_clear_apicv_inhibit()
         * always evaluates the IRQ window count; thus the IRQ window inhibit
         * call _will_ be lazily updated on the next call, if it ever happens.
         */
         if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
                 guard(rwsem_read)(&kvm->arch.apicv_update_lock);
                 if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
                         atomic_add(add, &kvm->arch.apicv_irq_window);
                         return;
                 }
         }

	/*
	 * Strictly speaking the lock is only needed if going 0->1 or 1->0,
	 * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
	 * only target a single CPU, so that is the common case; do not
	 * bother eliding the down_write()/up_write() pair.
	 */
         guard(rwsem_write)(&kvm->arch.apicv_update_lock);
         if (atomic_add_return(add, &kvm->arch.apicv_irq_window) == inc)
                 __kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
}
EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);

Paolo


