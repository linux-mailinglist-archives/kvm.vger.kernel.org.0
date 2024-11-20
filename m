Return-Path: <kvm+bounces-32189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 360E89D40D1
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 18:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 978442811F0
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A46B15697B;
	Wed, 20 Nov 2024 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKN/8LXC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1892514831E
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732122548; cv=none; b=Ngk1S0aMwbhyt70lASxxSJ+if/beDHOOIJFzT9VBNrl6tjVf3cet3FxGYI5upuuWmjkDC+6wrSavz8EWsweVS3AXLXL5xe1gXoLSpafVa3/uoS4ksUugWxw6t4R5xKZOSMUkQbufoYb0/BIwsRGOjbjKxFFlUiY5F22ZfRBiEP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732122548; c=relaxed/simple;
	bh=j8VRFGumKX/UFj41MRnixH39domf2NksbUbVVoBAff0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lFNEGorNAfkKhezx5vFeVNZ8GXoA/m3vUgFRIunRQGNkgAwoLfaFQ8GJ2ryFKiJ9EWpKHlGlyZloPOR972tANSKvDjsxrupcfKafr3ccqZ+nNwgbZC43vH6NsTjGfSYLsNeAWF+JTWs8ylYjhHm5JVc7lkOBKZtJsb3LTLcdhz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKN/8LXC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea45ba6b9aso31438a91.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 09:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732122546; x=1732727346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rl9pCQ7SjN1WAGbb/iemBcf8VdMPCjyFB0oi6ydVENA=;
        b=SKN/8LXCKU4i3zoKyn1bhLT5dW2R0zH5QlL7Lz7E2eaZnpn5VzNHn7VDCQNW8h+bkJ
         Y371V4oWaMJe1jifs+1Z+jBmUq6nY2jKVMBxIrB6aNGxHmRQmvmai6HepscQEqsnrCUB
         LI6ZsL7uT4lWfP3bz3wlFR/e9udN5KtywRLVv+J4HJiPMwsR7jav3HXFqzJR0WLoiZY8
         QHzlxf9R4LQaxJrcNzhlH11MxSMmbbV1l/lLEABiJXkGCBlv2gZHi84D99UHSGdg/CVz
         jB4uWrhpM4XKW64dBD4aeI1PysP+RdskMmSZPeRwNeTu3CAjGKcMyShzJx+QLaWC7YeM
         EHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732122546; x=1732727346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rl9pCQ7SjN1WAGbb/iemBcf8VdMPCjyFB0oi6ydVENA=;
        b=UfvS7YlZNsrRJGUa1wPb9GQCjHYhcI9foz+m41I6QiYIlM1jBe9qvUcxaQaLoXK7rY
         u0SRs2KbdUxGRjoYfH2uYqLs8clSHqgVacKiuEBu2tT3XKfVPGfIypooNSaTBRdWUnxT
         6njoP8p3Jp9zQhRpCRVEuKotf5dDti8yIFLyyBet5OlxjKkYIl9blcj7aGwXNle2/TzB
         jRXr5ieIhM89VgFdYN2+wnsoZ6JFEPy+jiQHjIxajR6azQLbZue6CWV/sGAkSr66wQrE
         PkZP3cf29CyAewRsVI5IfNxRY1rdOdiLRm3hehNY0FnPV2wP776wnoOwaQiQuwxwmtkF
         Ab2A==
X-Forwarded-Encrypted: i=1; AJvYcCUZ00krV4nnz7OlvWRVWWY7J2+WCQn3fKpabqRzsLVtV0Rl/XE64MPi4YjwhXodetNsPcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiQljhDKt3H2Ljh/NgwyVdNpsPKmPEFT+kEFdxiH9dTYOUJNCf
	sJHVXSanGGKyu1KX8AJLtfy3yEb8DDUF6SYOcj4BQfqyIKhC6hlBGBfVLvocSwozmRUOvL1ey2q
	Z2g==
X-Google-Smtp-Source: AGHT+IEoAkC2h+iYko3IpB7U/mZnVavVsqzVUg9Nq3+wG63gWQho2zHdn04p22f+iDLFqDiyRdkS2WIwuDY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c7c4:b0:2ea:837a:b9f3 with SMTP id
 98e67ed59e1d1-2eaca6bf379mr1846a91.1.1732122546420; Wed, 20 Nov 2024 09:09:06
 -0800 (PST)
Date: Wed, 20 Nov 2024 09:09:05 -0800
In-Reply-To: <b08075d5-1190-44f7-bccc-04f3273c13f3@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-21-mizhang@google.com>
 <Zzyw1UyapXDNpc-c@google.com> <b08075d5-1190-44f7-bccc-04f3273c13f3@linux.intel.com>
Message-ID: <Zz4XsR6v2PKb-yvX@google.com>
Subject: Re: [RFC PATCH v3 20/58] KVM: x86/pmu: Always set global enable bits
 in passthrough mode
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 20, 2024, Dapeng Mi wrote:
> On 11/19/2024 11:37 PM, Sean Christopherson wrote:
> >> ---
> >>  arch/x86/kvm/pmu.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> >> index 5768ea2935e9..e656f72fdace 100644
> >> --- a/arch/x86/kvm/pmu.c
> >> +++ b/arch/x86/kvm/pmu.c
> >> @@ -787,7 +787,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
> >>  	 * in the global controls).  Emulate that behavior when refreshing the
> >>  	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
> >>  	 */
> >> -	if (kvm_pmu_has_perf_global_ctrl(pmu) && pmu->nr_arch_gp_counters)
> >> +	if ((pmu->passthrough || kvm_pmu_has_perf_global_ctrl(pmu)) && pmu->nr_arch_gp_counters)
> >>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
> > This is wrong and confusing.  From the guest's perspective, and therefore from
> > host userspace's perspective, PERF_GLOBAL_CTRL does not exist.  Therefore, the
> > value that is tracked for the guest must be '0'.
> >
> > I see that intel_passthrough_pmu_msrs() and amd_passthrough_pmu_msrs() intercept
> > accesses to PERF_GLOBAL_CTRL if "pmu->version > 1" (which, by the by, needs to be
> > kvm_pmu_has_perf_global_ctrl()), so there's no weirdness with the guest being able
> > to access MSRs that shouldn't exist.
> >
> > But KVM shouldn't stuff pmu->global_ctrl, and doing so is a symptom of another
> > flaw.  Unless I'm missing something, KVM stuffs pmu->global_ctrl so that the
> > correct value is loaded on VM-Enter, but loading and saving PERF_GLOBAL_CTRL on
> > entry/exit is unnecessary and confusing, as is loading the associated MSRs when
> > restoring (loading) the guest context.
> >
> > For PERF_GLOBAL_CTRL on Intel, KVM needs to ensure all GP counters are enabled in
> > VMCS.GUEST_IA32_PERF_GLOBAL_CTRL, but that's a "set once and forget" operation,
> > not something that needs to be done on every entry and exit.  Of course, loading
> > and saving PERF_GLOBAL_CTRL on every entry/exit is unnecessary for other reasons,
> > but that's largely orthogonal.
> >
> > On AMD, amd_restore_pmu_context()[*] needs to enable a maximal value for
> > PERF_GLOBAL_CTRL, but I don't think there's any need to load the other MSRs,
> > and the maximal value should come from the above logic, not pmu->global_ctrl.
> 
> Sean, just double confirm, you are suggesting to do one-shot initialization
> for guest PERF_GLOBAL_CTRL (VMCS.GUEST_IA32_PERF_GLOBAL_CTRL for Intel)
> after vCPU resets, right?

No, it would need to be written during refresh().  VMCS.GUEST_IA32_PERF_GLOBAL_CTRL
is only static (because it's unreachable) if the guest does NOT have version > 1.

