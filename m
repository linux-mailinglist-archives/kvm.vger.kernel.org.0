Return-Path: <kvm+bounces-32186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C138A9D406D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8147C281F9D
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD5F1A0BDC;
	Wed, 20 Nov 2024 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gTY9dj5s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9280150994
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 16:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732121133; cv=none; b=NSCu/1OFC5ip9chJtXxFskKPYaa2M4T9wke8nXoXuS2sg01DOaAmHLUOR+x0C4dUIYUHZvhcYrj28RacOTnA3s6KcJ9XMR+ndY4YX0QdbmO+ABLGzMgxqDrXIxzni47wQ8vDkHer8dekAawhRI/wdLKAGo3Grl3BgvP8nwmxIWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732121133; c=relaxed/simple;
	bh=atBL+bq6+6djW/2Iaq1n5OzAjtgj/78bksKGJWYuQ1I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hxbemg0WKLFNAJfxQZrrNmt0X19M+yDv6nCLMQTwisJ1YCmQuzCFUioIJpxWwqCrhkfoW7EFlmeplN+3JvN0z1df5oACWT5hoE2Q//SR92R2ct7C36m6QJYszxG+oD7D0jIeIfDpvqV0jta1lEpiSCM4/dvkaBrhltASwq5jRyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gTY9dj5s; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e38aae1bdb8so5167170276.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 08:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732121130; x=1732725930; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tygqKFbg+ArMhOWF5Yig1w6NXblyM3/JZLFP5+5GacQ=;
        b=gTY9dj5skMgeeJ+GFfKi94Z4ifJMyKjexzIQ9GFMT0KBUP+UkVcLTeQWg+7Wh3AunE
         AO6lEMQz2SKurfERzp60DNXmb9GMTSGALMlRV7YvJ++gWt7uO3sgbGACC6xETR6vyBVr
         vUC1Kj1Vdc6RUDBWUCv8/j8VSfgQobBJdmY/96lpkyBNDPpwO2rFNyqsbolzFS+Tt60w
         Idi/fk1JHqlzwY5ohQ4CHAQKO+NDmfZyqpFaRT3pGItbwr9kSCLIOLDjk/2Ovegrf/29
         /J8WWZrr9RoA1edo7iB9gHa/reTRvJy0X6l7m7/N/wBHMw45rcTETOIhC8MW3CZI5u8d
         hHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732121130; x=1732725930;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tygqKFbg+ArMhOWF5Yig1w6NXblyM3/JZLFP5+5GacQ=;
        b=nj9DpXs3NNpvyYyDg7DKjqqMWfU7z/MfIeaF2rrKDRN+tm6mZYdSKknpzsiYXGDAML
         OiL47V3dhp3lH2g0wwkneHeUnnr6/NESO7+B6cUs7aVYllDsGk1HzlkIxlyXipknFoTg
         hMuumuVutKueeQNuKfe1Hz01vCbT6GaTztDXbZG9DML2t0679lyz01xsMpGYm7zW8JQc
         lZ3sofqgRoRdFM5osuS46zaWOPC33UXuJgtxqSW9zJYcLi7/PObmLcVzGCv1jMgkkIim
         wLIz7YX8nEnxpXJRzGlAy9yNkF7o7DqSQLWOdCloM8hoMF0GG6lCG5/RK59lamk5vkvU
         zRCg==
X-Forwarded-Encrypted: i=1; AJvYcCWTDNKSNRuy1EpCetPT1yr9REHrpRxb/iAAtwmc9dHCVUS2KDvJUXMjRViw/3k4v54kBPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOPtwU0zppWAYu9MRhDZph1pbDWsRf0sK8tcswgZb142TL7Jzt
	renvV4WQDH52RZHXc5gDpzmwsm3Igk5yN9gD7qbEgJJIH4QpSo3NPXaOfWhfFNk1sXzzJpWg1Gm
	1bQ==
X-Google-Smtp-Source: AGHT+IFYE+jm3yiya0/yDKPXKQmXpVzHcYjlo1U85vuIz90XeZaFiWv84vDiWNxcprGDNlPAvHLOb3hc2Zw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:698a:0:b0:e38:bf01:4df9 with SMTP id
 3f1490d57ef6-e38cb718fa0mr10347276.9.1732121130735; Wed, 20 Nov 2024 08:45:30
 -0800 (PST)
Date: Wed, 20 Nov 2024 08:45:29 -0800
In-Reply-To: <2ec98cd1-e96e-4f17-a615-a5eac54a7004@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-20-mizhang@google.com>
 <ZzymmUKlPk7gHtup@google.com> <2ec98cd1-e96e-4f17-a615-a5eac54a7004@linux.intel.com>
Message-ID: <Zz4K0VhK5_6N307s@google.com>
Subject: Re: [RFC PATCH v3 19/58] KVM: x86/pmu: Plumb through pass-through PMU
 to vcpu for Intel CPUs
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
> 
> On 11/19/2024 10:54 PM, Sean Christopherson wrote:
> > On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> >> Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
> >> vcpu created. Note that enabling PMU is decided by VMM when it sets the
> >> CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
> >> in intel_pmu_refresh().
> > Why?  As with the per-VM snapshot, I see zero reason for this to exist, it's
> > simply:
> >
> >   kvm->arch.enable_pmu && enable_mediated_pmu && pmu->version;
> >
> > And in literally every correct usage of pmu->passthrough, kvm->arch.enable_pmu
> > and pmu->version have been checked (though implicitly), i.e. KVM can check
> > enable_mediated_pmu and nothing else.
> 
> Ok, too many passthrough_pmu flags indeed confuse readers. Besides these
> dependencies, mediated vPMU also depends on lapic_in_kernel(). We need to
> set enable_mediated_pmu to false as well if lapic_in_kernel() returns false.

No, just kill the entire vPMU.

Also, the need for an in-kernel APIC isn't unique to the mediated PMU.  KVM simply
drops PMIs if there's no APIC.

If we're feeling lucky, we could try a breaking change like so:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index fcd188cc389a..bb08155f6198 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -817,7 +817,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
        pmu->pebs_data_cfg_mask = ~0ull;
        bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 
-       if (!vcpu->kvm->arch.enable_pmu)
+       if (!vcpu->kvm->arch.enable_pmu || !lapic_in_kernel(vcpu))
                return;
 
        static_call(kvm_x86_pmu_refresh)(vcpu);


If we don't want to risk breaking weird setups, we could restrict the behavior
to the mediated PMU being enabled:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index fcd188cc389a..bc9673190574 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -817,7 +817,8 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
        pmu->pebs_data_cfg_mask = ~0ull;
        bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
 
-       if (!vcpu->kvm->arch.enable_pmu)
+       if (!vcpu->kvm->arch.enable_pmu ||
+           (!lapic_in_kernel(vcpu) && enable_mediated_pmu))
                return;
 
        static_call(kvm_x86_pmu_refresh)(vcpu);

