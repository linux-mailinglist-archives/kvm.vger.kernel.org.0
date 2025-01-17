Return-Path: <kvm+bounces-35843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E838A155FE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CFE1168766
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13EF1A23AA;
	Fri, 17 Jan 2025 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z3Y2pmGY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA986324
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737136306; cv=none; b=LfoZskbvKzpIhXTpL0J2CDJ49zBogc4eImLMIimPIqcSgV42JzL+eCiXpmv04VAM5U8cYlcBI1b64rza8Qlhqvuy5cNYnVzoiJ54SUW65u46nGXYmsw8oz86Q71rgDeRcLqfInb042KIDuLm9IDA1yMkB9yvmpvtlG/pDa0n+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737136306; c=relaxed/simple;
	bh=Wct9HCwUPCVIG+BBVfvCW6z2/NZWOtyjf01kvXutEJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fykGxNdYbAlS8+r8GK+AS7jSH9rFbmKBxcIhXaPMZWb99s5mUvUyO4w1AKdixAZvSEuerbZCzXK1aIkzTQDhTDFhkayZA0JeQxuFbNQmwzCMGGL9jL4epcnm+V1QPcI9tiVDx08zhMD6NoWNsPp+/4K+aEA2QZYyQdopmrsB7dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z3Y2pmGY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef91d5c863so4738502a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 09:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737136303; x=1737741103; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H7k5xoXdCenaUvwTYHoCS9O0hkrxJj/QWVxA1v+hnUQ=;
        b=Z3Y2pmGYnLIXP2et6Eh8LiyRk1a2cQ4PLHUFgxoooSjzbm5d/pOuy6yrjEiHD+NAyy
         vEDht9kM5xEuvgnlU97Hb/uCEwiQBtIoNr7V302SDn6ijVxPKr1Oo9NjHVKIheBOu3Pe
         vfqQf44IShGKAz6IXWNaHgSGRjwbeJ0AuTH45BjazpOl/PH5XjvGU9DrtsWrLEr4zDJY
         xuNzkcWumQwMWBH2CXUzdI5z0u4VWyrWvP5BqLIdlxCwHqTNAd7M41n8CLaESDlSl/g7
         S79h4QAb0L3MdGnXc+U57+p2Ba090EC0se2JAy2UgNY+HUCPPq5t3R2HyDUlwSZRoqyP
         B+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737136303; x=1737741103;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H7k5xoXdCenaUvwTYHoCS9O0hkrxJj/QWVxA1v+hnUQ=;
        b=ksRGAZmUQrqf9+gd6IOytN3Gl3U8GJTXO6EoSCnVXjMFha+U7PCkDjgApYc7pSv7DF
         czptO/KFdzTWZpbdKANoD98D7amhuq3NOHwNCowcYS3IGBEZRZbqzBmNQ25n0Tm9WHNc
         kI//1DzOLDRFuD+4XqSCQo1/7+JbmhLxKNcluGMvjVe0rRa8szhjXmT0B59ieCyj3IKC
         0OhkIsxfJv46B5jU1WFQtZy58FHUwLHYTWtIiSHgxqiOjhpYIncc4XiYIO0HBiUp1XyF
         DwXgYu1pB15WhoKsX2072tmah5b2vLi/uG3YmoqXr4/ZQmLNHcNImq2E604JNIPzDyrj
         kqaA==
X-Gm-Message-State: AOJu0Yw28Kb708tvhunE+n9FU4XCkXhV/Baye96Wlm72iPwvvvHEK+5U
	wlj9W9gk87fn6XoggDmRPhL1Z10emI5vnNEoCMc1kNi95vDx3w1BwSmzO753Bodn15kUnMonegv
	izw==
X-Google-Smtp-Source: AGHT+IE+6C+HICgHPyQFwpWVGVWdEAQv1R4pIztlLJmzMOMRKD6iUi4cmrlkQ+r7zcps7U+HAUbzXsZcO9I=
X-Received: from pjbta14.prod.google.com ([2002:a17:90b:4ece:b0:2f5:5240:4f0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568e:b0:2ee:e158:125b
 with SMTP id 98e67ed59e1d1-2f782d3238cmr4211446a91.26.1737136302993; Fri, 17
 Jan 2025 09:51:42 -0800 (PST)
Date: Fri, 17 Jan 2025 09:51:41 -0800
In-Reply-To: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
Message-ID: <Z4qYrXJ4YtvpNztT@google.com>
Subject: Re: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
From: Sean Christopherson <seanjc@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kvm@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "Michal =?utf-8?Q?Koutn=C3=BD?=" <mkoutny@suse.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset="us-ascii"

+sched folks

On Fri, Jan 17, 2025, Dan Carpenter wrote:
> I don't know why I'm seeing this static checker warning only now.  All
> this code looks to be about 15 years old...
> 
> Commit e48672fa25e8 ("KVM: x86: Unify TSC logic") from Aug 19, 2010
> (linux-next), leads to the following Smatch static checker warning:

That's not the problematic commit.  This popped because commit 8722903cbb8f
("sched: Define sched_clock_irqtime as static key") in the tip tree turned
sched_clock_irqtime into a static key (it was a simple "int").

https://lore.kernel.org/all/20250103022409.2544-2-laoar.shao@gmail.com

> 	arch/x86/kernel/tsc.c:1214 mark_tsc_unstable()
> 	warn: sleeping in atomic context
> 
> The code path is:
> 
> vcpu_load() <- disables preempt
> -> kvm_arch_vcpu_load()
>    -> mark_tsc_unstable() <- sleeps
> 
> virt/kvm/kvm_main.c
>    166  void vcpu_load(struct kvm_vcpu *vcpu)
>    167  {
>    168          int cpu = get_cpu();
>                           ^^^^^^^^^^
> This get_cpu() disables preemption.
> 
>    169  
>    170          __this_cpu_write(kvm_running_vcpu, vcpu);
>    171          preempt_notifier_register(&vcpu->preempt_notifier);
>    172          kvm_arch_vcpu_load(vcpu, cpu);
>    173          put_cpu();
>    174  }
> 
> arch/x86/kvm/x86.c
>   4979          if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
>   4980                  s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>   4981                                  rdtsc() - vcpu->arch.last_host_tsc;
>   4982                  if (tsc_delta < 0)
>   4983                          mark_tsc_unstable("KVM discovered backwards TSC");
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> It seems pretty unlikely that we'll get a backwards tsc.

TSC will go "backwards" if the host is suspended, in which case host TSC gets
reset to 0.

>     1215         pr_info("Marking TSC unstable due to %s\n", reason);
>     1216 
>     1217         clocksource_mark_unstable(&clocksource_tsc_early);
>     1218         clocksource_mark_unstable(&clocksource_tsc);
>     1219 }
> 
> kernel/jump_label.c
>    245  void static_key_disable(struct static_key *key)
>    246  {
>    247          cpus_read_lock();
>                 ^^^^^^^^^^^^^^^^
> This lock has a might_sleep() in it which triggers the static checker
> warning.
> 
>    248          static_key_disable_cpuslocked(key);
>    249          cpus_read_unlock();
>    250  }
> 
> regards,
> dan carpenter

