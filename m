Return-Path: <kvm+bounces-24303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 33EAB9537CC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DFBB1F21B05
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78C01B4C2D;
	Thu, 15 Aug 2024 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k2Ce3tGK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844272A8D0
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737608; cv=none; b=jKunzIic/bxARIL4I7qX+uStF6YjDRdgRAHhIcEB7XFCOt/Q6rjmbCwEajW8beF8pEwQdAV/YTPr2ITXbaF2gznutMGWJ2WB5299Cqsj87L+IN1SNfb6t4PDVtOf1hIk0Sl46TKtcE3c94FbPFnmctR+76Rql7OWEUPXJ+uI2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737608; c=relaxed/simple;
	bh=8LOB4hMOsdMgF4WbkQ49wP5IJlz8nKKjriUyn+4jDsE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=acPmMphPfkjZBqgftkr+kxdD7lk6aM3oCk24uJ6aDiNQfy5jsQwkHhuJA3CExiS7xCcSkRLEExN/1LCbd3gCsT10BGcrAujMacqPfv96g9EmKo+IB/5261x95Oxo4q/9L2yKJGeOIKZ1soGkbZdDp284TzRJi0c7duCDGfJ4n5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k2Ce3tGK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso834229a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723737606; x=1724342406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M8NnW+ymJPO/5j9ioWkpEO+FljjLsToFL+mCOZ9DuZ8=;
        b=k2Ce3tGKvAagcinHeUztFYH7OCI3WMGz/YeWB2Nrbcz6uD+TzyvA077Gl9Ifh50Cyy
         01rGtL6ciEnPLrRUzhccZXrczauI7kYWWU8ghB8zJ+aZZIfzK9vKLl9Z7rYiP5SUcNOt
         RPQx2VFdnlYqE8qDuavlABzXwMgmVgR/eVk6urr8K5Yp7BP7R5vAYhCcUx9aHrwOlZqM
         Oozn8GPVo7+A7mki8sCoQtKjVhAQ2bbmXHtGCexm9WTg40lOxNFlrJjVNeb2QZIdF0NL
         Hk0MBGDoddQukfiMbXt/mYuQDSWE/7pgQhx3IrGy3dhErmkMGEqXHGxBodsBxSgnGe+s
         4jwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723737606; x=1724342406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M8NnW+ymJPO/5j9ioWkpEO+FljjLsToFL+mCOZ9DuZ8=;
        b=HDH14RvltlIbwFWevn9qwv2tTGCoKEikj7j3yfjohHKkTeHeaRxqsflRWObD9thD/9
         fF3BP9NnD1fhBx+A+Vxxjb00nll6iK85FoNK9NumS6J07A+EiXTZISkpJ/EFpWJ7NK0k
         5yekt42wrUNyFryaog0EPyRp+al9m+FG8ZbhFZrsJomwOsaHkqlXejQEgAdVVqh4ivtn
         9tSanxxUlmfPeoVhag8RTDV5MxefnskCISFC6m+90Ala7SFAfMVq8kjPOO8KCfKCQOmZ
         9hEnTiHZ6u7jb2d8gy5KL/4uG73rENIo3jEVaNfCZtoBcz+Su6/kP6R6YNQGpZ4ts63r
         masQ==
X-Gm-Message-State: AOJu0YzDJekpRAORYzb+DiNckmSNmN6B5lcE02G9xIyvoIu2SMC9qQeM
	9Lcyu9VH55a/wl3Czz94hmZz6T/8P9Z67iNaXU2d7IsYbz10YXxSweMDu5RizS/5X91W/SqGpF+
	MIQ==
X-Google-Smtp-Source: AGHT+IGU1fKO78A5yr12VP/rYnQq2ySJsTi2GH/BAWbZmuduEGVPVlZ8I3b0WIj9vqu/ONJN8tWWO0QlPaE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:90a:b0:7b8:b174:3200 with SMTP id
 41be03b00d2f7-7c6b2c6857cmr9343a12.5.1723737605562; Thu, 15 Aug 2024 09:00:05
 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:00:04 -0700
In-Reply-To: <20240522001817.619072-14-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-14-dwmw2@infradead.org>
Message-ID: <Zr4mBNTSquDqOtfw@google.com>
Subject: Re: [RFC PATCH v3 13/21] KVM: x86: Improve synchronization in kvm_synchronize_tsc()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When synchronizing to an existing TSC (either by explicitly writing zero,
> or the legacy hack where the TSC is written within one second's worth of
> the previously written TSC), the last_tsc_write and last_tsc_nsec values
> were being misrecorded by __kvm_synchronize_tsc(). The *unsynchronized*
> value of the TSC (perhaps even zero) was bring recorded, along with the
> current time at which kvm_synchronize_tsc() was called. This could cause
> *subsequent* writes to fail to synchronize correctly.
> 
> Fix that by resetting {data, ns} to the previous values before passing
> them to __kvm_synchronize_tsc() when synchronization is detected. Except
> in the case where the TSC is unstable and *has* to be synthesised from
> the host clock, in which case attempt to create a nsec/tsc pair which is
> on the correct line.
> 
> Furthermore, there were *three* different TSC reads used for calculating
> the "current" time, all slightly different from each other. Fix that by
> using kvm_get_time_and_clockread() where possible and using the same
> host_tsc value in all cases.

Please split this into two patches, one to switch to a single RDTSC, and another
do fix the other stuff.

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 32 ++++++++++++++++++++++++++++----
>  1 file changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ea59694d712a..6ec43f39bdb0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -201,6 +201,10 @@ module_param(eager_page_split, bool, 0644);
>  static bool __read_mostly mitigate_smt_rsb;
>  module_param(mitigate_smt_rsb, bool, 0444);
>  
> +#ifdef CONFIG_X86_64
> +static bool kvm_get_time_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
> +#endif
> +
>  /*
>   * Restoring the host value for MSRs that are only consumed when running in
>   * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
> @@ -2753,14 +2757,22 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
>  {
>  	u64 data = user_value ? *user_value : 0;
>  	struct kvm *kvm = vcpu->kvm;
> -	u64 offset, ns, elapsed;
> +	u64 offset, host_tsc, ns, elapsed;
>  	unsigned long flags;
>  	bool matched = false;
>  	bool synchronizing = false;
>  
> +#ifdef CONFIG_X86_64
> +	if (!kvm_get_time_and_clockread(&ns, &host_tsc))
> +#endif

I'm pretty sure we can unconditionally declare kvm_get_time_and_clockread() above,
and then do

	if (!IS_ENABLED(CONFIG_X86_64) ||
	    !kvm_get_time_and_clockread(&ns, &host_tsc))

and let dead code elimintation do its thing to avoid a linker error.

> +	{
> +		ns = get_kvmclock_base_ns();
> +		host_tsc = rdtsc();
> +	}
> +

