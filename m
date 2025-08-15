Return-Path: <kvm+bounces-54796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 504EAB2831C
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05B9A1C86FFE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A8A307AEC;
	Fri, 15 Aug 2025 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WOTKy4Fz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C182307AC4
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272515; cv=none; b=dB9oAyz54Zd3C2WP/SxiKWrmbv2ldEPGMdFXsIyEn48b6myiMLzzMdDUKQOxg64IHQESQzBjU4yVRvG9MvRBTm0/L/rrAgH3eRKVJftwIn8helpfX6k0+aLgIeoZy9ppYdLcQKJIsvqcIohmLxBrFlh02C4OVeiaS0VTdfuHuvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272515; c=relaxed/simple;
	bh=V0iQe0wXHiwXgNwjclXLeqc33EIkx7ymZ0WlHmqsCas=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kjt1cTUISsFeP5Veq60QBgqmxotnCggOwBQqB6d2EVYkDZLdZ4eXq4j9FZTFZVZsrClKvy04B6SsywJMKEDu6QuXiP/sysI8x4ZCxfFnhy4rkwXqNQDH5c+nd/yj4ZUuSjx9bUuxwVmM8DyzvWAkXpfyk7XHnNmSwMLKLOipvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WOTKy4Fz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e09c5fso2119289a91.2
        for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755272514; x=1755877314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mZHHNj6EVbfkylJhuGEQxcUJR48ZbvWbqL/aI2BJPfo=;
        b=WOTKy4Fzr8j76uGrXmViWQk7NVhJ3MKW/n7YCHbkduDT5nTapFfpZsBpari+WiLAVH
         obkT2Wxd1GDp55Sx8Cqvu/CBoAOgXtIxmZdkG1XBti5sIg46nLyqVehcIDCZH9zTT29E
         ODLtS+t8cBm+IfYS/oXch0j0dlngfnRAZor8cQgDdchy3ho4IgErKsH/ksvBDW6/y85B
         KJDG/BCuh5mSmD5uOhQXo6qVkpm2txXqiLZ28d9u2U5F1RpWAUwjj/5v4qiNwHMUOAWx
         iS+48TBZaKRcIZpaPnyvrNEx36TMsVT25sVGU0/q2DBQnMPdayJSkZ/F0ku8R9d42V/w
         X6QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755272514; x=1755877314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZHHNj6EVbfkylJhuGEQxcUJR48ZbvWbqL/aI2BJPfo=;
        b=RDYZjdLZUpsPTqTcqFbrlf6RseFfGno6C9En4uB+MEvotCIUx7VoACozObGFmUzFM7
         4IDLEDR0W8JjomIhC1xW+atIb9GL/5QUw0r8GI/OmqAH+yEca4znKojcKieAWikWkfJ0
         nEGxFDKyML8QYJOl+ZWB51u+2qXS0d6K5kDvk6Uit0TAPK7/LT8fdAmsjST6BODYvb6p
         ltv+edfnWQf4H80XkeVD+S/pHv22tEaJv3VvWPNcLGzXuiZUc2swPHy/dFNjb74kougi
         lVaZ0PjQKKMEit1kzMVYRmFUaeMW9ffLH9TYDilHamNHYAOTb5F43iIYNpR4ktH96wQF
         8uGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNGlRoaDc17+gCaU+ApCOj7rAwOHrDSKlEGJmNCQOop+kGBtYIhruAx+XMdafHucx4RHA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxod4NFbEk1lfL42jan1qIoFefVJMxJEqlQnp3fWPIZgcgK/xUM
	yduNriP6V8FDGO0XuOk3zgz6CQ2R2mU7oFtcr5GfQn9WUJ9OnHIcham+pzxst8epMDVM6JZftNR
	lsA1ZyQ==
X-Google-Smtp-Source: AGHT+IF1xhNBmkTpZib3NykIL4xlxFbGkhXK+/yjF5LGvtuWFmTYgkxBDJw0+uZkCmQyO/RrRqfOrKLRso0=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:31e:a094:a39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5104:b0:31e:4492:af48
 with SMTP id 98e67ed59e1d1-32342238d44mr3660367a91.28.1755272513579; Fri, 15
 Aug 2025 08:41:53 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:41:52 -0700
In-Reply-To: <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-10-seanjc@google.com>
 <20250815113951.GC4067720@noisy.programming.kicks-ass.net>
Message-ID: <aJ9VQH87ytkWf1dH@google.com>
Subject: Re: [PATCH v5 09/44] perf/x86: Switch LVTPC to/from mediated PMI
 vector on guest load/put context
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 15, 2025, Peter Zijlstra wrote:
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index e1df3c3bfc0d..ad22b182762e 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6408,6 +6408,8 @@ void perf_load_guest_context(unsigned long data)
> >  		task_ctx_sched_out(cpuctx->task_ctx, NULL, EVENT_GUEST);
> >  	}
> >  
> > +	arch_perf_load_guest_context(data);
> 
> So I still don't understand why this ever needs to reach the generic
> code. x86 pmu driver and x86 kvm can surely sort this out inside of x86,
> no?

It's definitely possible to handle this entirely within x86, I just don't love
switching the LVTPC without the protection of perf_ctx_lock and perf_ctx_disable().
It's not a sticking point for me if you strongly prefer something like this: 

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0e5048ae86fa..86b81c217b97 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1319,7 +1319,9 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
 
        lockdep_assert_irqs_disabled();
 
-       perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
+       perf_load_guest_context();
+
+       perf_load_guest_lvtpc(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
 
        /*
         * Disable all counters before loading event selectors and PMCs so that
@@ -1380,5 +1382,7 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
 
        kvm_pmu_put_guest_pmcs(vcpu);
 
+       perf_put_guest_lvtpc();
+
        perf_put_guest_context();
 }


