Return-Path: <kvm+bounces-14570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1298A3641
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 21:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14C712877FF
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 19:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA6F150981;
	Fri, 12 Apr 2024 19:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BELHwLci"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76403502A9
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 19:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712949425; cv=none; b=a0MZbarps9ugjIiYE7Myz3pbO1Fy7WHqBW8XFPOd5k+zphBWpb+MnksFZ+sWJosWpw+f10X4Ey7EpDhVwNXK7Lez7B1LJ9Wx23+wfFGjas4vNcb66lI6pU+Gz7NZuG6Vurac3jQQR0wn/YAb3Wi1a4MN/EBWf4pH0+oFIgTK5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712949425; c=relaxed/simple;
	bh=gXSq+T7XzqPxzRC/useeLBrjqvRyaotmwCPTNi4Tu1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eaYMBMbUQLoeFMJtJxpOWCjmIAm1lgKHxPPG+SXxqd3jQV8myRtodVeGsK0y94P+PJx6dkwsag2rxJD5Na4plDbyklWI00ipf5gTdo4WEqB2dCJpv8tjXKWNvdyBaUIrMuB9uCmW5RTXSUM4j5UUKzKfAw30Su+FAPc/9ZGs4J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BELHwLci; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6156cef8098so22724867b3.0
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 12:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712949422; x=1713554222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZYm+Xc9AGuPFsnQm3QDSma2dM32/YHiWtmTC7mIj98=;
        b=BELHwLciBDJOqbolC0twPLN6pusfksA9Wk1O7UW21mZKXGobDrSAWwT8s25SXaB9zn
         1gq2sgXoyJEuZyQCQPZzvDhjomvltPVTbIUGB/ArUke6Gsf5vLSxmlbVu3mKXAHNrW9n
         9DK8HP6dd/8kKRBVmYYA/7yKltD/VaXLnkBmZi2UIRSWN3m9osz/Ina1RdQefXGBhT8y
         Ysf028Idia9gOI/UNfQWcpGnEW6/pfiUozYeFAEXMrqLn9D0rhzaaW7hg7aCd+e6z3mj
         JqR8x3A6+NKplzlQqoTIh+bAK07hT8eBNM1Hzn3pdTyzrimL1CS2d1wvqD4of/FxdlTR
         NXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712949422; x=1713554222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ZYm+Xc9AGuPFsnQm3QDSma2dM32/YHiWtmTC7mIj98=;
        b=ROO+WAObAuQL+J6xPRaAKG8dseB7vvA3EhZAoQYYKkWtx1Zioi1Z/YIeUSBiznMRvB
         TigTzB+F/sE8AnbwZkNQhZSRZMAdOnoKFtYotzt7jZOI/lWf6yO4EJOmtLh6ys6hE2L4
         UmICkvZFFz0kS13U053dZVkxpRxI3SzklgZLyNcpMTKVphReu1AIleCQMQy9jbqDU7Mz
         9lsirrZj4wKWlTJRgEi7AA+yzlbYg//DFiw/tAqewX7XufDe1HoTQFym9Pux151GITPt
         WGiINHWquUU4f6ikY9kXeovQNG78Aa5IXFRFTkopXHgsVD/Jnk2WmsH8RKmvpHsBYI3/
         FtiA==
X-Forwarded-Encrypted: i=1; AJvYcCXZuwYh8xhWqVetlXZBfAG9517h6yL3vVZvMMETOrMozYKfKf/lcXvdrjA3dlDrKQonWctNA1jAs29oia9PKRM5RRsI
X-Gm-Message-State: AOJu0YxNI0GcQwHCS5lJ2DRMaYlJlSd5CRHq9jnidE2srRWVGhAJY2WL
	YNy//XpKKMlMbyloNvXrhw2fE1Y1Xi/z8l5yHbIOPYVCdTap0e0tP9sitH7TjDTlqaPB5CuGmqy
	nWA==
X-Google-Smtp-Source: AGHT+IFLnup6JSKkiSb0UzDwD6karEhA7d20IDFCl5FKvYbjyr3ssyUHXmtdP3hCGhAQnldQxZ8f2unxvjc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:480d:0:b0:614:e20c:d3ef with SMTP id
 v13-20020a81480d000000b00614e20cd3efmr785979ywa.10.1712949422548; Fri, 12 Apr
 2024 12:17:02 -0700 (PDT)
Date: Fri, 12 Apr 2024 12:17:01 -0700
In-Reply-To: <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-3-xiong.y.zhang@linux.intel.com> <ZhgmrczGpccfU-cI@google.com>
 <23af8648-ca9f-41d2-8782-f2ffc3c11e9e@linux.intel.com>
Message-ID: <ZhmIrQQVgblrhCZs@google.com>
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 11, 2024, Kan Liang wrote:
> >> +/*
> >> + * When a guest enters, force all active events of the PMU, which supports
> >> + * the VPMU_PASSTHROUGH feature, to be scheduled out. The events of other
> >> + * PMUs, such as uncore PMU, should not be impacted. The guest can
> >> + * temporarily own all counters of the PMU.
> >> + * During the period, all the creation of the new event of the PMU with
> >> + * !exclude_guest are error out.
> >> + */
> >> +void perf_guest_enter(void)
> >> +{
> >> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> >> +
> >> +	lockdep_assert_irqs_disabled();
> >> +
> >> +	if (__this_cpu_read(__perf_force_exclude_guest))
> > 
> > This should be a WARN_ON_ONCE, no?
> 
> To debug the improper behavior of KVM?

Not so much "debug" as ensure that the platform owner noticies that KVM is buggy.

> >> +static inline int perf_force_exclude_guest_check(struct perf_event *event,
> >> +						 int cpu, struct task_struct *task)
> >> +{
> >> +	bool *force_exclude_guest = NULL;
> >> +
> >> +	if (!has_vpmu_passthrough_cap(event->pmu))
> >> +		return 0;
> >> +
> >> +	if (event->attr.exclude_guest)
> >> +		return 0;
> >> +
> >> +	if (cpu != -1) {
> >> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
> >> +	} else if (task && (task->flags & PF_VCPU)) {
> >> +		/*
> >> +		 * Just need to check the running CPU in the event creation. If the
> >> +		 * task is moved to another CPU which supports the force_exclude_guest.
> >> +		 * The event will filtered out and be moved to the error stage. See
> >> +		 * merge_sched_in().
> >> +		 */
> >> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
> >> +	}
> > 
> > These checks are extremely racy, I don't see how this can possibly do the
> > right thing.  PF_VCPU isn't a "this is a vCPU task", it's a "this task is about
> > to do VM-Enter, or just took a VM-Exit" (the "I'm a virtual CPU" comment in
> > include/linux/sched.h is wildly misleading, as it's _only_ valid when accounting
> > time slices).
> >
> 
> This is to reject an !exclude_guest event creation for a running
> "passthrough" guest from host perf tool.
> Could you please suggest a way to detect it via the struct task_struct?
> 
> > Digging deeper, I think __perf_force_exclude_guest has similar problems, e.g.
> > perf_event_create_kernel_counter() calls perf_event_alloc() before acquiring the
> > per-CPU context mutex.
> 
> Do you mean that the perf_guest_enter() check could be happened right
> after the perf_force_exclude_guest_check()?
> It's possible. For this case, the event can still be created. It will be
> treated as an existing event and handled in merge_sched_in(). It will
> never be scheduled when a guest is running.
> 
> The perf_force_exclude_guest_check() is to make sure most of the cases
> can be rejected at the creation place. For the corner cases, they will
> be rejected in the schedule stage.

Ah, the "rejected in the schedule stage" is what I'm missing.  But that creates
a gross ABI, because IIUC, event creation will "randomly" succeed based on whether
or not a CPU happens to be running in a KVM guest.  I.e. it's not just the kernel
code that has races, the entire event creation is one big race.

What if perf had a global knob to enable/disable mediate PMU support?  Then when
KVM is loaded with enable_mediated_true, call into perf to (a) check that there
are no existing !exclude_guest events (this part could be optional), and (b) set
the global knob to reject all new !exclude_guest events (for the core PMU?).

Hmm, or probably better, do it at VM creation.  That has the advantage of playing
nice with CONFIG_KVM=y (perf could reject the enabling without completely breaking
KVM), and not causing problems if KVM is auto-probed but the user doesn't actually
want to run VMs.

E.g. (very roughly)

int x86_perf_get_mediated_pmu(void)
{
	if (refcount_inc_not_zero(...))
		return 0;

	if (<system wide events>)
		return -EBUSY;

	<slow path with locking>
}

void x86_perf_put_mediated_pmu(void)
{
	if (!refcount_dec_and_test(...))
		return;

	<slow path with locking>
}

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1bbf312cbd73..f2994377ef44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12467,6 +12467,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        if (type)
                return -EINVAL;
 
+       if (enable_mediated_pmu)
+               ret = x86_perf_get_mediated_pmu();
+               if (ret)
+                       return ret;
+       }
+
        ret = kvm_page_track_init(kvm);
        if (ret)
                goto out;
@@ -12518,6 +12524,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
        kvm_mmu_uninit_vm(kvm);
        kvm_page_track_cleanup(kvm);
 out:
+       x86_perf_put_mediated_pmu();
        return ret;
 }
 
@@ -12659,6 +12666,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
        kvm_page_track_cleanup(kvm);
        kvm_xen_destroy_vm(kvm);
        kvm_hv_destroy_vm(kvm);
+       x86_perf_put_mediated_pmu();
 }
 
 static void memslot_rmap_free(struct kvm_memory_slot *slot)


