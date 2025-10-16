Return-Path: <kvm+bounces-60142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E33BE4956
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 891B8400723
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46CD23EABA;
	Thu, 16 Oct 2025 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMdcuIVE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237D132D0E8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760632116; cv=none; b=hb7Sm44mjBnMMMYHyLHFOTE1kqSKEzGzcHOQy3JqT+Ga0bK7tH3Qav3COF53mwPVuRPRi2+94ZI2lv8XTlbnidwr1bQNZmyIDSPDwWx4rsmScaq2rhm0mwexAfR10ZewUJ/eC3yNiUpNA0YxWBng7zNvbwxXcY71f3/gdoohMWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760632116; c=relaxed/simple;
	bh=FjVpoWGv6GPVJRB9yeW4QLEHb8pWvSjkcJMfHKRVAdQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DRT6zzS0qNjvYWOh4tiQCi3J3uADKFnbyvJkQ6hQy4cVytevisd6gQmUg4v8efoYsdd8QaDu/Do31a4j0RGaSoELJG/WsHYpYy6jpE4/Exw8XMjs052WjKLdk15KOD4xReDvG2MpxbkYkHcXGMZmugHFN8dVQoaAYMNGXmHQFK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMdcuIVE; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3f030846a41so617705f8f.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 09:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760632112; x=1761236912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZctlYZjcVfC1+MlR0sp+XM0r7q1XTeaaRhcJmr7aR4=;
        b=JMdcuIVEaBluvev5sUmUK6v8SJUqydYTX/mvFjsyUnIcCxAAIy53bx1azQKqwmhbcP
         EpMj8nLrGWD6EbojQ+iWHTGgadXuD9o4GjJkUXMgigFhiXshgOYrpytxn2QrpUIwElNX
         V7OE/7ceuHKKPiEMxl8P2629NNJhz2iT0I579liYUmQXFmctCZoDRHHcRNO9KaQynih+
         t6Alr+cw2k7QkfJ4A+weDgZHxUGJhmCroz7n9p1pSLLK/D2OOKlTbCwVpFLze6oiDqGA
         VU+y665jl2i2Q7UrDgbCO8yU/DgdFV4r0gMfkcmHyZHoPwTAV6xmVZMHvkFU7pvURSjS
         WYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760632112; x=1761236912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZctlYZjcVfC1+MlR0sp+XM0r7q1XTeaaRhcJmr7aR4=;
        b=WN+YCFb3RSZ+TT+fonHfpaAMzJhSZ70oN02BFkJpwHSHBHfxakozhj9wehk7O5gpyR
         s4UfdsMeybh5mK7adYqWuPpWoXh+85qc0rD5PmmD7WTTsa8vsyXGzaaStg3ty62l/dxA
         mE7kZbk2KWqiyb35GErNVwEtak108VnL09KQrhlABHGjzhPx+UJLY0MdMiaw4GE3+80w
         UJiQ9SxE2OAKGFwo7BSfsyFfciplnTzgjqeCU7U+w3JlEVNDWiZQNumaGcPY8LFknXkG
         V2f7V5c2SYkZY66H6NNDuT7AgVmJv89N/uDVYbw4OoThWQl0fv+fTfMwVKR1JqZt+Bv1
         FIQg==
X-Forwarded-Encrypted: i=1; AJvYcCVYTMfa4obBE1E67PsPa6FK0AqjIDOh7SombQ0drXIhYWlxNJAOaKixM6dmt5lQx0Mj6Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuvEDBBdy+AU7G0382PFLibYJvGeiPESMAizbxxk+G02KTIScr
	yJQSnOxoIkQZiv+Ujls2vZICrOGjwzP/meRaPd6kZNkzw/c9Qutuf9M5cc+4b/WWne1G9guXzbb
	VNjkSR/rRM33VZg==
X-Google-Smtp-Source: AGHT+IEkgxIfttf92pExoYBo7KohqBzXHMskcIxmLZcWhPYU1oVTgvunhusq1ktj9gTY8Us7Cr+te5yOCiK3Ng==
X-Received: from wmgg6.prod.google.com ([2002:a05:600d:6:b0:46f:aafc:e6d4])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:22c6:b0:3ff:d5c5:6b0d with SMTP id ffacd0b85a97d-42704d497eemr516676f8f.4.1760632112484;
 Thu, 16 Oct 2025 09:28:32 -0700 (PDT)
Date: Thu, 16 Oct 2025 16:28:31 +0000
In-Reply-To: <aPEULoJUUadbb3nn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com> <aPEULoJUUadbb3nn@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDJVZU914RVD.1HXRX01BELY4L@google.com>
Subject: Re: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, 
	<kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu Oct 16, 2025 at 3:50 PM UTC, Sean Christopherson wrote:
> On Wed, Oct 15, 2025, Brendan Jackman wrote:
>> Currently the tracking of the need to flush L1D for L1TF is tracked by
>> two bits: one per-CPU and one per-vCPU.
>> 
>> The per-vCPU bit is always set when the vCPU shows up on a core, so
>> there is no interesting state that's truly per-vCPU. Indeed, this is a
>> requirement, since L1D is a part of the physical CPU.
>> 
>> So simplify this by combining the two bits.
>> 
>> The vCPU bit was being written from preemption-enabled regions. For
>> those cases, use raw_cpu_write() (via a variant of the setter function)
>> to avoid DEBUG_PREEMPT failures. If the vCPU is getting migrated, the
>> CPU that gets its bit set in these paths is not important; vcpu_load()
>> must always set it on the destination CPU before the guest is resumed.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>
> ...
>
>> @@ -78,6 +79,11 @@ static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
>>  	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
>>  }
>>  
>> +static __always_inline void kvm_set_cpu_l1tf_flush_l1d_raw(void)
>> +{
>> +	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
>> +}
>
> TL;DR: I'll post a v3 with a slightly tweaked version of this patch at the end.
>
> Rather than add a "raw" variant, I would rather have a wrapper in arch/x86/kvm/x86.h
> that disables preemption, with a comment explaining why it's ok to enable preemption
> after setting the per-CPU flag.  Without such a comment, choosing between the two
> variants looks entirely random
>
> Alternatively, all writes could be raw, but that
> feels wrong/weird, and in practice disabling preemption in the relevant paths is a
> complete non-issue.

Hm, why does making every write _raw feel weird but adding
preempt_disable() to every write doesn't? Both feel equally weird to me.
But the latter has the additional weirdness of using preempt_disable()
as a way to signal "I know what I'm doing", when that signal is already
explicitly documented as the purpose of raw_cpu_write().

> <me rummages around>
>
> Gah, I followed a tangential thought about the "cost" of disabling/enabling preemtion
> and ended up with a 4-patch series.  All of this code really should be conditioned
> on CONFIG_CPU_MITIGATIONS=y.  With that, the wrapper can be:
>
> static __always_inline void kvm_request_l1tf_flush_l1d(void)
> {
> #if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
> 	/*
> 	 * Temporarily disable preemption (if necessary) as the tracking is
> 	 * per-CPU.  If the current vCPU task is migrated to a different CPU
> 	 * before the next VM-Entry, then kvm_arch_vcpu_load() will pend a
> 	 * flush on the new CPU.
> 	 */
> 	guard(preempt)();
> 	kvm_set_cpu_l1tf_flush_l1d();
> #endif
> }

Having a nice place to hang the comment definitely seems worthwhile, but
couldn't we just put it in the _raw varant?

> and kvm_set_cpu_l1tf_flush_l1d() and irq_cpustat_t.kvm_cpu_l1tf_flush_l1d can
> likewise be gated on CONFIG_CPU_MITIGATIONS && CONFIG_KVM_INTEL.
>
>
>> +
>>  static __always_inline void kvm_clear_cpu_l1tf_flush_l1d(void)
>>  {
>>  	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 0);
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 48598d017d6f3f07263a2ffffe670be2658eb9cb..fcdc65ab13d8383018577aacf19e832e6c4ceb0b 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1055,9 +1055,6 @@ struct kvm_vcpu_arch {
>>  	/* be preempted when it's in kernel-mode(cpl=0) */
>>  	bool preempted_in_kernel;
>>  
>> -	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
>> -	bool l1tf_flush_l1d;
>> -
>>  	/* Host CPU on which VM-entry was most recently attempted */
>>  	int last_vmentry_cpu;
>>  
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 667d66cf76d5e52c22f9517914307244ae868eea..8c0dce401a42d977756ca82d249bb33c858b9c9f 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4859,7 +4859,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>>  	 */
>>  	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
>>  
>> -	vcpu->arch.l1tf_flush_l1d = true;
>> +	kvm_set_cpu_l1tf_flush_l1d();
>
> This is wrong, kvm_handle_page_fault() runs with preemption enabled.

Ah, thanks.

