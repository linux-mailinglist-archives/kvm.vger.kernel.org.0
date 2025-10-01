Return-Path: <kvm+bounces-59364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3016BB175A
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 20:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2411F192358F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 18:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32612D46BB;
	Wed,  1 Oct 2025 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yQE79kpl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304EB2D3EDB
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759342467; cv=none; b=bdGOEQ5wJC+r0QJYgfFLWIMz1hY1xBDT65fsSufIidAbAtkFd472vI/MW3OrUrYlJ9j2Ebz9StV0Cu8ezWhsda3p169oQWHbzTXTx+HQ2jc2l76mvpnRU51Ks2K8i8dQBDIIXH9tWYFMn8W6bpUg2w5GqM3iOiPvEJERc9v1R64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759342467; c=relaxed/simple;
	bh=F7w6+iS6qdAPIESuSb4CMj9IywBNbDaDryHHYM/oA78=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OE2tMd+XzMDcFQvxw3L/c9WCdsvuXQhbHdkqqdSB5BlJwXl0zHQWs5UH0VBaGMhUkUhPukXClNFoDXrv1VO9H6s1CE0LJtFjgurSG17EZ2gNzzVaZVTeiNgTceMTuQRhbxt7y72T3XNJPacZYP7F9r01KwlIcy/2da5BS18z+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yQE79kpl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3352a336ee1so441250a91.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 11:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759342465; x=1759947265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LOBNzl0piewZaB0fEWYxjiNzOXTgJ+Q2XdYBWxqPDCY=;
        b=yQE79kplB7uZHUaS6AKBx7uc5se/NhiAM8HFXDQXk9lxkKuQlijhsoIDLZvTXgYKTZ
         vknpYiSrUGz5TdHO5et9Xa80EdfNM+z2ytZGZ8055/rsrfcS67Y7ue4BsthLObMod39K
         RkWY5dtVPIJ85nmNrknoVpH6EGkEJCu8oyXLD5rRY45KyMB5N3dL6d7tKAWmZDzsIWFo
         4Van496uBUJdoxPWIIlgfhwr/j2pSOtuJjSHvxJ/HBumoTCiNPhfKWhpqrh3ivk3yi0c
         faUFe+y4RJVi4+dkOKfb/qEV2MurDz+1WaDyPqToHCKh4KYTT3qniJQP7hOs69NZBVhw
         szgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759342465; x=1759947265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOBNzl0piewZaB0fEWYxjiNzOXTgJ+Q2XdYBWxqPDCY=;
        b=ZKSuCcGs7p6E0mwPeh5utE8ym9Iy+psUBaUDQM2uCL0tHYk57OlUL+r0iN0qv3d8qc
         fRLNRy8+AJFOZj6SJEZXQQ7gmWAYyHw0xnGxP4xC+9ihlrzuhwR0CzX31RkN05MI1rSo
         8uy95m9WNvshhiE59Z6G+1qh6+k76S+HW62gmfDnhWIGQF30029KhF34OXYs1CPGe62J
         iKmA4wxlSzi+S4eGkXwGeuh7meov2wMPGU61d57a3FPh6d6j5z2fbyQGwfrn9kvXbukg
         wX2sxS771XgbVIbPrNUvnfHyYbYUX5tUD0Vwg9TXwuF5w4FtGoUcNxixa+lDI+QhG1Kr
         H5fw==
X-Forwarded-Encrypted: i=1; AJvYcCUQYL3ZChvDOiPuVAd792YVEvL2Z1twwWHLskXSet5GY6DtpN3pRQKcI9UXsOJN+JcrIs4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4FJBkwK3potjFz81tuBAoH/oyJl9i3XdSRiPS7MRBkpEsTl/s
	k6+OgtP1/PSoOby/vB/O2o/u9oiE5L7jVh9seusGN78EnX/ksWVsh8arxhZYLMSqnSFRZiD7zPG
	yncQ5Ng==
X-Google-Smtp-Source: AGHT+IGJbul18z2pAriB4M9Dv7xuCXJyXC/vErDTd2EuWuyjJTHyZFET/F4MY3SeMRgMCYc9TSFDnBqrzsg=
X-Received: from pjbjs19.prod.google.com ([2002:a17:90b:1493:b0:327:7035:d848])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:33cf:b0:32b:8b8d:c2d1
 with SMTP id 98e67ed59e1d1-339a6f076edmr5249061a91.21.1759342465480; Wed, 01
 Oct 2025 11:14:25 -0700 (PDT)
Date: Wed, 1 Oct 2025 11:14:23 -0700
In-Reply-To: <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com> <20250806195706.1650976-33-seanjc@google.com>
 <f896966e-8925-4b4f-8f0d-f1ae8aa197f7@amd.com>
Message-ID: <aN1vfykNs8Dmv_g0@google.com>
Subject: Re: [PATCH v5 32/44] KVM: x86/pmu: Disable interception of select PMU
 MSRs for mediated vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Sandipan Das <sandidas@amd.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 26, 2025, Sandipan Das wrote:
> On 8/7/2025 1:26 AM, Sean Christopherson wrote:
> > From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > 
> > For vCPUs with a mediated vPMU, disable interception of counter MSRs for
> > PMCs that are exposed to the guest, and for GLOBAL_CTRL and related MSRs
> > if they are fully supported according to the vCPU model, i.e. if the MSRs
> > and all bits supported by hardware exist from the guest's point of view.
> > 
> > Do NOT passthrough event selector or fixed counter control MSRs, so that
> > KVM can enforce userspace-defined event filters, e.g. to prevent use of
> > AnyThread events (which is unfortunately a setting in the fixed counter
> > control MSR).
> > 
> > Defer support for nested passthrough of mediated PMU MSRs to the future,
> > as the logic for nested MSR interception is unfortunately vendor specific.

...

> >  #define MSR_AMD64_LBR_SELECT			0xc000010e
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 4246e1d2cfcc..817ef852bdf9 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -715,18 +715,14 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
> >  	return 0;
> >  }
> >  
> > -bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> > +bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >  
> >  	if (!kvm_vcpu_has_mediated_pmu(vcpu))
> >  		return true;
> >  
> > -	/*
> > -	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
> > -	 * in Ring3 when CR4.PCE=0.
> > -	 */
> > -	if (enable_vmware_backdoor)
> > +	if (!kvm_pmu_has_perf_global_ctrl(pmu))
> >  		return true;
> >  
> >  	/*
> > @@ -735,7 +731,22 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> >  	 * capabilities themselves may be a subset of hardware capabilities.
> >  	 */
> >  	return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
> > -	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed ||
> > +	       pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
> > +
> > +bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +
> > +	/*
> > +	 * VMware allows access to these Pseduo-PMCs even when read via RDPMC
> > +	 * in Ring3 when CR4.PCE=0.
> > +	 */
> > +	if (enable_vmware_backdoor)
> > +		return true;
> > +
> > +	return kvm_need_perf_global_ctrl_intercept(vcpu) ||
> >  	       pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
> >  	       pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
> >  }
> 
> There is a case for AMD processors where the global MSRs are absent in the guest
> but the guest still uses the same number of counters as what is advertised by the
> host capabilities. So RDPMC interception is not necessary for all cases where
> global control is unavailable.o

Hmm, I think Intel would be the same?  Ah, no, because the host will have fixed
counters, but the guest will not.  However, that's not directly related to
kvm_pmu_has_perf_global_ctrl(), so I think this would be correct?

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4414d070c4f9..4c5b2712ee4c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -744,16 +744,13 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
        return 0;
 }
 
-bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
+static bool kvm_need_pmc_intercept(struct kvm_vcpu *vcpu)
 {
        struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
        if (!kvm_vcpu_has_mediated_pmu(vcpu))
                return true;
 
-       if (!kvm_pmu_has_perf_global_ctrl(pmu))
-               return true;
-
        /*
         * Note!  Check *host* PMU capabilities, not KVM's PMU capabilities, as
         * KVM's capabilities are constrained based on KVM support, i.e. KVM's
@@ -762,6 +759,13 @@ bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
        return pmu->nr_arch_gp_counters != kvm_host_pmu.num_counters_gp ||
               pmu->nr_arch_fixed_counters != kvm_host_pmu.num_counters_fixed;
 }
+
+bool kvm_need_perf_global_ctrl_intercept(struct kvm_vcpu *vcpu)
+{
+
+       return kvm_need_pmc_intercept(vcpu) ||
+              !kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
+}
 EXPORT_SYMBOL_GPL(kvm_need_perf_global_ctrl_intercept);
 
 bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
@@ -775,7 +779,7 @@ bool kvm_need_rdpmc_intercept(struct kvm_vcpu *vcpu)
        if (enable_vmware_backdoor)
                return true;
 
-       return kvm_need_perf_global_ctrl_intercept(vcpu) ||
+       return kvm_need_pmc_intercept(vcpu) ||
               pmu->counter_bitmask[KVM_PMC_GP] != (BIT_ULL(kvm_host_pmu.bit_width_gp) - 1) ||
               pmu->counter_bitmask[KVM_PMC_FIXED] != (BIT_ULL(kvm_host_pmu.bit_width_fixed) - 1);
 }

