Return-Path: <kvm+bounces-60144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A4007BE4A9B
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2512C4863C8
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 16:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089DE3314CE;
	Thu, 16 Oct 2025 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3yXPGU4u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EAF32D452
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 16:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633226; cv=none; b=NcY06i0kGk7N7pCvea6ka82twWJ5BcH3DFn6/c1iap4aGAPumZef7licV6+3hjqCkWs+goGPJvFPkj+BSzztbCdPT736aitbCiPiheD/PNFfMg1pakSjGjZ1/x4z6Ux+et6qUkAcjgBBnCnnb2fVpCBQ5/sVuOqgovZiNs+VaHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633226; c=relaxed/simple;
	bh=/5RTxVjF0G6irKYsLlz4ZbBm7+5Do4c5REN7Mem7vMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hFR1ZXEVRVPdFjpregJxyUAF2AZhpjrs2jzEwSGfR4oVFyzjn7HHTFx3iIecq32bRugMvJAyxJABvcJxvbfbmRe8ARjCJhd/XaqiK8Cur7FH0/WW+Y4TP0zLQ6ARm5hzAdXqExVLncS0pyouWij2Qafd30IZAY3KnyQBpXbKv3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3yXPGU4u; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-426ede1d66fso650547f8f.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760633223; x=1761238023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BH6iB9yTl4fk0GH7d0wlAo5lBLVhqDhIbHp2taDAclg=;
        b=3yXPGU4u2k1EeiLEwAGxMItkdznv3pFh/XCH6M00rBiQw7I1LfqOvTHSJdmgFN2TiT
         fydLu/UB2Sl90aiTArMqwjGsOdjyHsTrYWqo+uJDnortops3llc9d0IRvZpeaXitz01s
         d0FhFimCReY7haAtrpQ14icVzz467O/0k187dAG+F1tDjEZrpppXgozsttGMe2Id5U5z
         8aOXHUE8F0gTI8ZjY1NZ5nFgefZhvGh7Xt6fYRmo5FuFHgPObV6oiFlc/Ue/6g9y+Wvf
         StG+8db2TLMOj63RDP/sK4EX9ePidpvEIEXKcVtsTyYQOuMwG6e3M56BPWhqvfCN5se2
         EdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760633223; x=1761238023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BH6iB9yTl4fk0GH7d0wlAo5lBLVhqDhIbHp2taDAclg=;
        b=KjCc8nPFGWep355re/yjFUjvq9aPAHQSwtsw2SxAin/d0te8mTKFJOGoBCTy5UToaq
         L1Uu1327WPrVCPPqda+7mmExTLJm25tuFcOvjNaePClREY0JyBu9td+oRQhkATpZFDJG
         Lo2kAWQwGlrpe6S6xxFSdkoZ96pkQKcd7I96Q2kloPiiHCBOD9+Za8qK8/L2WoifMK+S
         qLAlflV9rYJmXqboDPyRn4VSvkT0atGMnh78lMIKB8zoFDJfkciFSUg1HoZRRKwRdeP5
         Hyxj6gDOVxfIGyfR5J6fTgo9gxqp2hGTmVnOm68gv5cGrBHCwicPbe3nnA/O7AgGcqNZ
         pJVg==
X-Forwarded-Encrypted: i=1; AJvYcCVWlzpJDrZvmjsWwUWc7iikN8YOZfjpEdS8EVGhFPA4EBwpaIReyxwIM0yfFX9Y1LqRQw4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3EGR7w6ORjXeeK1jtwyHkM8lMn2zmf1JN86CY8XoGB7mcwYp8
	eil9VEw9RaW3m2XLAFI50FUKAo88A4qoLkeIU4sqjmxBbDXvo8V6o4syzXresKbQmzsMkZf5CnI
	MT7Zp7TPx45O3hA==
X-Google-Smtp-Source: AGHT+IHcD3DhvFIyEIdQBqcildJVHXf0ma0Sjcc8HSeY6Y1WeeaInmnjzCLZSpJkSvdkYUcwmyWxkDHjxlOUqw==
X-Received: from wrwd5.prod.google.com ([2002:a5d:6445:0:b0:427:352:6d90])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2891:b0:3da:37de:a38e with SMTP id ffacd0b85a97d-42704da2c9cmr689217f8f.54.1760633222807;
 Thu, 16 Oct 2025 09:47:02 -0700 (PDT)
Date: Thu, 16 Oct 2025 16:47:02 +0000
In-Reply-To: <aPEgNdjr0j4LdSYq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>
 <aPEULoJUUadbb3nn@google.com> <DDJVZU914RVD.1HXRX01BELY4L@google.com> <aPEgNdjr0j4LdSYq@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DDJWE0C6OM45.2AKEJR1EG8Z6Q@google.com>
Subject: Re: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, 
	<kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu Oct 16, 2025 at 4:41 PM UTC, Sean Christopherson wrote:
> On Thu, Oct 16, 2025, Brendan Jackman wrote:
>> On Thu Oct 16, 2025 at 3:50 PM UTC, Sean Christopherson wrote:
>> > On Wed, Oct 15, 2025, Brendan Jackman wrote:
>> >> Currently the tracking of the need to flush L1D for L1TF is tracked by
>> >> two bits: one per-CPU and one per-vCPU.
>> >> 
>> >> The per-vCPU bit is always set when the vCPU shows up on a core, so
>> >> there is no interesting state that's truly per-vCPU. Indeed, this is a
>> >> requirement, since L1D is a part of the physical CPU.
>> >> 
>> >> So simplify this by combining the two bits.
>> >> 
>> >> The vCPU bit was being written from preemption-enabled regions. For
>> >> those cases, use raw_cpu_write() (via a variant of the setter function)
>> >> to avoid DEBUG_PREEMPT failures. If the vCPU is getting migrated, the
>> >> CPU that gets its bit set in these paths is not important; vcpu_load()
>> >> must always set it on the destination CPU before the guest is resumed.
>> >> 
>> >> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> >> ---
>> >
>> > ...
>> >
>> >> @@ -78,6 +79,11 @@ static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
>> >>  	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
>> >>  }
>> >>  
>> >> +static __always_inline void kvm_set_cpu_l1tf_flush_l1d_raw(void)
>> >> +{
>> >> +	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
>> >> +}
>> >
>> > TL;DR: I'll post a v3 with a slightly tweaked version of this patch at the end.
>> >
>> > Rather than add a "raw" variant, I would rather have a wrapper in arch/x86/kvm/x86.h
>> > that disables preemption, with a comment explaining why it's ok to enable preemption
>> > after setting the per-CPU flag.  Without such a comment, choosing between the two
>> > variants looks entirely random
>> >
>> > Alternatively, all writes could be raw, but that
>> > feels wrong/weird, and in practice disabling preemption in the relevant paths is a
>> > complete non-issue.
>> 
>> Hm, why does making every write _raw feel weird but adding
>> preempt_disable() to every write doesn't? Both feel equally weird to me.
>
> I completely agree that both approaches are odd/weird.
>
>> But the latter has the additional weirdness of using preempt_disable()
>> as a way to signal "I know what I'm doing", when that signal is already
>> explicitly documented as the purpose of raw_cpu_write().
>
> True.  Aha!
>
> With the #ifdefs in place, KVM doesn't need arch/x86/include/asm/hardirq.h to
> provide a wrapper.  irq_stat is already exported, the wrapper exists purely so
> that kvm_set_cpu_l1tf_flush_l1d() can be invoked without callers having to check
> CONFIG_KVM_INTEL.
>
> Not yet tested, but how about this?
>
> static __always_inline void kvm_request_l1tf_flush_l1d(void)
> {
> #if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
> 	/*
> 	 * Use a raw write to set the per-CPU flag, as KVM will ensure a flush
> 	 * even if preemption is currently enabled..  If the current vCPU task
> 	 * is migrated to a different CPU (or userspace runs the vCPU on a
> 	 * different task) before the next VM-Entry, then kvm_arch_vcpu_load()
> 	 * will request a flush on the new CPU.
> 	 */
> 	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
> #endif
> }

Yeah, just poking irq_stat directly seems fine to me.

