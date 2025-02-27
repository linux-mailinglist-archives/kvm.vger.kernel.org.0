Return-Path: <kvm+bounces-39617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADE97A4867D
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8762169722
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0200B1DE2A8;
	Thu, 27 Feb 2025 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4adwljok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB10E1ABEC5
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740676819; cv=none; b=BHC4yrlTA12r0vbLPQZMbSai4Aas/CS5qny8EohOZEYbtbOHZqQKX/jBLKPTzdPCGq6eW1bwAidy8Wa6VJtjWCZr2arvE2xKMT0c0XAew/s46B45vYPAiqGDJ8QReL09mIDJP9MthAvyxFM3ESWHdFQ+OV6ot4+ytkfsodK7+HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740676819; c=relaxed/simple;
	bh=FNuFdGFmxVDIbxqbjjO/bdKtmO+AEtCtsWpJhY1AABg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Evmb4v5cjqHxHdmZXnfuge8QZq7NCB3e3iUh1A+Hko7peRtzMJtMNRHlPJjbnM2smh1uhg2B5qE45dIpKsKwG+OylZH74iJpgGdUhOOXC7fnxfJM3+wF0Cd+VDyZQvPTSDVVG3yBg7/JEg9J5So1I9st+irKd+1/3Xd6g0PrPzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4adwljok; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe916ba298so2601001a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 09:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740676816; x=1741281616; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SNMA4trWnehuMgsqPa3chlXCB6mGTInwBrgSw5o5+p8=;
        b=4adwljokrC9RQ3PdxqWpEiJuKyYVDj3pWdgFWbkwnvY/pODNOh/oIvqp7oynaEheYt
         pDtxxNJkApbQOEWQOJr/QFMUP6cqTUo/G1aQnedVbSSDp8B+RBjLs7fSijAY0uoq1GD+
         U8zrwncu4r4O+IJjwLzCuKnR4q2yopvK9imsgpj7fCQVeLs96Ra/jOAdyBBoT5vEodkE
         Xf+/rTqqKgf8ITykiTosCvbSaGWoh8mMDJYRtU05WO3znO3Fx4zrtiyDpchlQIxjnHxI
         8tE8pHmSOmunx+6Oo3LKoIb85hjnjB++K+VGAEJEwZJbxsnfdrBGzmliXQMWvFZ+fDsO
         xQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740676816; x=1741281616;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SNMA4trWnehuMgsqPa3chlXCB6mGTInwBrgSw5o5+p8=;
        b=KA5mFADagl5Lg8DfHj5d968hPNZcoEoXvqSyMi8z+jDm9CGk2Kb/s578lpR8ZsS9rt
         DNH2/OOw+sGA3bHKPbQ0r5s3GukHU1Q9zYpUzjTknGv1CtfyDLri5j3aQ7m7ZY+P8sEM
         ynQ1/7A9P+Z601yoVs8OIkMDAPR7GakFAJf5HP+pchfxgZspqAo9Fw16zOl6oGZWVj43
         +BzxadnnOoShvCrGBFDjcZz0XpDvwxXDFULcVgHEfJ9vMSSz3tA0nyKnz5QtZHRMVu0G
         WxIjdruJLKIU+F9bdLWirB9Uci5EcrmPJEPRJmLW8QiM1jsZYxmY6s0JWTuR0IwzH1XD
         6QNA==
X-Forwarded-Encrypted: i=1; AJvYcCU+BGA2TlUlVg7P67/Iyk781ii0aRmaBmR9ytzRRos+5BPTNQoEytOLdz93ozd1eGRa9kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeAgWxGE/jYfDHb2Q2S3AhW0bDEUsT4m/WGha6L572OFWPIRjW
	xlRQsMvIQuQzEbo6rXAXdJfiZGtLEViOqFmjGifh1ou/oWEeCTJ/m4/OAo269sOdcyQ0buPsbq+
	grg==
X-Google-Smtp-Source: AGHT+IE1PsZJy5ZgwT+4gbnQZXY1CnCPk9dS3lO75sAQsyNz+eP7hhJlun0UE9on2aTeYx2OnaI1rpNPfbc=
X-Received: from pfld12.prod.google.com ([2002:a05:6a00:198c:b0:732:7e28:8f7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:807:b0:732:a24:734b
 with SMTP id d2e1a72fcca58-734ac3f3a92mr271052b3a.15.1740676816019; Thu, 27
 Feb 2025 09:20:16 -0800 (PST)
Date: Thu, 27 Feb 2025 09:20:14 -0800
In-Reply-To: <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com> <20250227011321.3229622-4-seanjc@google.com>
 <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com> <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
Message-ID: <Z8CezusUHEzOCYBF@google.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Ravi Bangoria wrote:
> > Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
> > on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
> > LBR virtualization is disabled), it's KVM's responsibility to clear
> > DEBUGCTL[BTF].
> 
> Found this with below KUT test.
> 
> (I wasn't sure whether I should send a separate series for kernel fix + KUT
> patch, or you can squash kernel fix in your patch and I shall send only KUT
> patch. So for now, sending it as a reply here.)

Actualy, I'll post this along with some other cleanups to the test, and a fix
for Intel if needed (it _should_ pass on Intel).  All the open-coded EFLAGS.TF
literals can be replaced, and clobbering arithmetic flags with SS is really, really,
gross.

> ---
> diff --git a/x86/debug.c b/x86/debug.c
> index f493567c..2d204c63 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -409,6 +409,45 @@ static noinline unsigned long singlestep_with_sti_hlt(void)
>  	return start_rip;
>  }
>  
> +static noinline unsigned long __run_basic_block_ss_test(void)
> +{
> +	unsigned long start_rip;
> +
> +	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_BTF);
> +
> +	asm volatile(
> +		"pushf\n\t"
> +		"pop %%rax\n\t"
> +		"or $(1<<8),%%rax\n\t"
> +		"push %%rax\n\t"
> +		"popf\n\t"
> +		"1: nop\n\t"
> +		"jmp 2f\n\t"
> +		"nop\n\t"
> +		"2: lea 1b(%%rip), %0\n\t"
> +		: "=r" (start_rip) : : "rax"
> +	);
> +
> +	return start_rip;
> +}
> +
> +static void run_basic_block_ss_test(void)
> +{
> +	unsigned long jmp_target;
> +	unsigned long debugctl;
> +
> +	write_dr6(0);
> +	jmp_target = __run_basic_block_ss_test() + 4;
> +
> +	report(is_single_step_db(dr6[0]) && db_addr[0] == jmp_target,
> +	       "Basic Block Single-step #DB: 0x%lx == 0x%lx", db_addr[0],
> +	       jmp_target);
> +
> +	debugctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	/* CPU should automatically clear DEBUGCTL[BTF] on #DB exception */
> +	report(debugctl == 0, "DebugCtl[BTF] reset post #DB. 0x%lx", debugctl);
> +}
> +
>  int main(int ac, char **av)
>  {
>  	unsigned long cr4;
> @@ -475,6 +514,12 @@ int main(int ac, char **av)
>  	run_ss_db_test(singlestep_with_movss_blocking_and_dr7_gd);
>  	run_ss_db_test(singlestep_with_sti_hlt);
>  
> +	/* Seems DEBUGCTL[BTF] is not supported on Intel. Run it only on AMD */
> +	if (this_cpu_has(X86_FEATURE_SVM)) {
> +		n = 0;
> +		run_basic_block_ss_test();
> +	}
> +
>  	n = 0;
>  	write_dr1((void *)&value);
>  	write_dr6(DR6_BS);
> ---
> 
> Thanks,
> Ravi

