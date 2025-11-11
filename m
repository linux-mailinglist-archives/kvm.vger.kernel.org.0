Return-Path: <kvm+bounces-62780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 577BCC4EC46
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BEBF24FC59D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 15:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB16035028E;
	Tue, 11 Nov 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKgYKUTq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E2363C4D
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762874118; cv=none; b=jTfHcqTwX9qRqBqNBxZ1JoYBF9vmjGlvIY9EOZzXNvnpblNXUJzFIuvv74FLW2zgc1YLu8m7ZaeZN0hReB8BM2yDhMQCcqjKOn4GXmx3/Kq7wa0LztBO28a7vD2ZVeZuWygX8OjkHu2jdBXFlSyDxyJa1+cr3QNBKJKycqNrZIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762874118; c=relaxed/simple;
	bh=M8FnmF1LuduMskcLWNRFiRCfNY7mztPAtm71RZ+b/70=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QaGO2nhmbSg2xmBXJxCvYKOYCWRu3YFFZp82hKvR8Flp539aBQVTekZGfZ6jW1nsep48BaFpy02U9VKFVklc14jPyW5m+SVCDJzR8DH8B+zgu3eKp3SO04/1Br68JVc9dX14PmKM5lB6dbJhTlsa5FGYLzaRMu896yqpkAZNsCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKgYKUTq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297d50cd8c4so89257085ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 07:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762874114; x=1763478914; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAnQxZAKQsfrq9oNGV2MTQzc7zfbDE/qBeAJ+I4fygg=;
        b=sKgYKUTqYs9EDDqW2cljvdYBcv3HEiYBh39/8caUuXYrJ3ER8NvZAvdVgke2H8xrxS
         CdU1Z8nOky9CSuW8oKfjVFMcy+FoF3ToguSrNrU0MmsMtZrndQl5kSqvaiAcD6ktx8aC
         akMachiBi3fPXGUc6mD4qvyJ1JjjuWcYCzulZHaCaJJUCFENhLPRgBDfI9ozAfIDqQ1N
         PejpsWRYQbzczSxRIW6wqIv0GZBcOklOGhcoXKWOq9epFF/1nOz6xOMO+hUpq0D3hxsm
         knAmuI0wRxr6XDos3/ysvZWx4ewnyHfIZ2Qz+bcrSDuR5mKDVwiwnFzdJkdLhVUNWGmf
         KE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762874114; x=1763478914;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAnQxZAKQsfrq9oNGV2MTQzc7zfbDE/qBeAJ+I4fygg=;
        b=wVy6oIWNwAv6EjkrFc/dPYg/7D/qY5JgbeHr8fdhOaAacbre4yhKZ3xz4W6PcvO6/G
         sfeOU9HIe5i+y/f4ixP7gY4vTmS2APiZStFkS27yW3pTZQyU2lcX4CtP46tHEtrEBRFY
         DFDZsp7IbwKRjSMtuQT74twcndZejUJcxmdUsY5zwJkGbhbXpASvJlAtq3tXxhv3J2HD
         qXtMfscM9s0z48jY7fGTTzLxbnUftY5+sUNSSPoeNsBuNcsuLc7gxhmCQbenkcPwCbfG
         4FicwfoIuoUYHDjBmvwnHk4ZwJ/u+6c46iXfVM4zX3dehdELChLssnnnHktYvlOQtuKg
         q54Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwr7rfG3lP/Eu9LeH3rtt0doAZwcH9lyA+94JzzQwKLvjBtthftn7kGd3RxGWZMOzqYLc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrLVcRmHQTCDt6bOhZuOsLeIQT+iLC7jF5/w+42W2VbqcXKOhe
	PLK3w0SFU3fQmF2nq0DjXD2AUBT8GwZ3KWCXR09qRUeR5fm/ohleplJ6Xx7I+nyY2apABYSALNy
	y9kdDBw==
X-Google-Smtp-Source: AGHT+IGNSbX2YVdJ7FQ7XRLA0GH4GQy5nJgIYxD7PeArNdMdG8wjAi25AL1qFpCs/b+Z/TWOo4u9ZLErU2s=
X-Received: from plav13.prod.google.com ([2002:a17:902:f0cd:b0:292:5d48:6269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e888:b0:295:1a5b:f406
 with SMTP id d9443c01a7336-297e564f99emr148498115ad.25.1762874114507; Tue, 11
 Nov 2025 07:15:14 -0800 (PST)
Date: Tue, 11 Nov 2025 07:15:12 -0800
In-Reply-To: <a704b1f7-a550-4c38-b58d-9bc0783019f1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240808062937.1149-1-ravi.bangoria@amd.com> <20240808062937.1149-5-ravi.bangoria@amd.com>
 <Zr_rIrJpWmuipInQ@google.com> <a704b1f7-a550-4c38-b58d-9bc0783019f1@amd.com>
Message-ID: <aRNTADUbIGze6Vyt@google.com>
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, jmattson@google.com, hpa@zytor.com, 
	rmk+kernel@armlinux.org.uk, peterz@infradead.org, james.morse@arm.com, 
	lukas.bulwahn@gmail.com, arjan@linux.intel.com, j.granados@samsung.com, 
	sibs@chinatelecom.cn, nik.borisov@suse.com, michael.roth@amd.com, 
	nikunj.dadhania@amd.com, babu.moger@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com, 
	ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 11, 2025, Shivansh Dhiman wrote:
> On 17-08-2024 05:43, Sean Christopherson wrote:
> > On Thu, Aug 08, 2024, Ravi Bangoria wrote:
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index e1b6a16e97c0..9f3d31a5d231 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct vcpu_svm *svm = to_svm(vcpu);
> >>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
> >> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> >> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
> >> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
> >>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
> >>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
> > 
> > Out of sight, but this leads to calling svm_enable_lbrv() even when the guest
> > just wants to enable BUS_LOCK_DETECT.  Ignoring SEV-ES guests, KVM will intercept
> > writes to DEBUGCTL, so can't KVM defer mucking with the intercepts and
> > svm_copy_lbrs() until the guest actually wants to use LBRs?
> > 
> > Hmm, and I think the existing code is broken.  If L1 passes DEBUGCTL through to
> > L2, then KVM will handles writes to L1's effective value.  And if L1 also passes
> > through the LBRs, then KVM will fail to update the MSR bitmaps for vmcb02.
> > 
> > Ah, it's just a performance issue though, because KVM will still emulate RDMSR.
> > 
> > Ugh, this code is silly.  The LBR MSRs are read-only, yet KVM passes them through
> > for write.
> > 
> > Anyways, I'm thinking something like this?  Note, using msr_write_intercepted()
> > is wrong, because that'll check L2's bitmap if is_guest_mode(), and the idea is
> > to use L1's bitmap as the canary.

...

> ===========================================================
> Issue 1: Interception still enabled after enabling LBRV
> ===========================================================
> Using the 6.16 upstream kernel (unpatched) I ran the KUT tests and they passed
> when run from both the bare metal and from inside a L1 guest. However for L2
> guest, when looking at the logs I found that RDMSR interception of LBR MSRs is
> still enabled despite the LBRV is enabled for the L2 guest. Effectively, the
> reads are emulated instead of being virtualized, which is not the intended
> behaviour. KUT cannot distinguish between emulated and virtualized RDMSR, and
> hence the test passes regardless.

I haven't looked closely at your patch or at Yosry's patches, but I suspect this
was _just_ fixed:

https://lore.kernel.org/all/20251108004524.1600006-1-yosry.ahmed@linux.dev

> ===========================================================
> Issue 2: Basic LBR KUT fails with Sean's implementation
> ===========================================================
> After using your implementation, all KUTs passed on the bare metal. With LBRV
> enabled for L2, RDMSR interception of LBR MSRs is disabled as intended.
> However, when running KUT tests inside an L1 guest, the tests fail.

Same story here: I haven't had cycles to actually look at code, but Yosry also
posted a pile of changes for KUT:

https://lore.kernel.org/all/20251110232642.633672-1-yosry.ahmed@linux.dev

