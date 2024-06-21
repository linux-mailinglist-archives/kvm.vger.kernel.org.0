Return-Path: <kvm+bounces-20283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5735C9126FA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC958B280B4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612A84688;
	Fri, 21 Jun 2024 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bEcB1Dch"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146E01C14
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977727; cv=none; b=TH9Yax4JUyGWkMdIPF6FBV+NTx3TOn+amqjEVwWiwFGgLtOVW+95vocqP+to4W7xeK/Rk8pctNSlfIBzSnzCT6802hW/m22kX/td+9NPwzP26OD+449C7hpZprPCVAcXN8/gunVmXu24r0B39se+JCfAnA3UdPZ4TZRezrqJUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977727; c=relaxed/simple;
	bh=AtF26wu5ITxZOmMyjwHLWmi4RNRt+/mPchc574Gfba0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7vTz9bIUAJm8PRZF7z36cfYi3VUXW1eJQuZf/bcZlh1nMJiRtpbhlutlrfDNT4q/zWfXx6rOhZzbPE/yrygavqwB/VdOzaG1mKu6tX9EhGcdJQQN14vfueeuNiB6vvJUwEwOHG+jj2cXBVWiey7AIIqXsOKO9hCu0WTR6oiVm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bEcB1Dch; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-630be5053caso34844027b3.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 06:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718977725; x=1719582525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xDDye/k9/SNfrM9XoCrmDhP+LFS11J4ZCLTae62jGvM=;
        b=bEcB1DchcqDqzju2M4J638owblNZ7ccHGXK/O8L3keSqpOoGulZ+Q8oMTm4OUJvE0W
         JGjHb1OQjz4i2Ye4R1MsN/Il/loF4ok1jLHqttam/C0oA7OeBkHnnR3H2BJPCjGwyb7B
         F2t2EILtdSR5kMGONs4tKiGHDpQg/jBypq2UPtMMOYg//d39Wo0dKc2MyNEpzAccphH6
         +nTJSgHMMrqbFrxbVJ45Je/YWHpvdG+QP+Tx/Ft+hIkxpw4L0aGc+13f89+0mpxQcdYA
         l+wZi7ajr9F3IoNKJ8HoRklM1hhVgjqRrcgfm7z9cq4rTqyddYWO8BQoSFsne1WcVkcm
         a3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718977725; x=1719582525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDDye/k9/SNfrM9XoCrmDhP+LFS11J4ZCLTae62jGvM=;
        b=rJtL79VEboPQjbP5V19TjWmheiKzZQ7NBsU9CIBkc3fy+/UMo8siTZDonRacSJwR4s
         o4FxIROuwLaFaLdwRQ0j6676npn+jZ+a1Hk1aoySowSFfIy8c77R66ueeU3n+Oc8tB3B
         pkCp+DF5SkPT0CkrOrr+FmAgaHhYgyzSHgSkzgShln5BhMwNkhePz5fsJDe5JUa4w28V
         1pXh3grEICh2zJyoYBh9fQMfiPjicxbI6eu7KSSvnKxvWm9bvr2TgUziVhM7kSyglZub
         2ehKWNREa5RyIm7a1CWlKqatlkPme6i3RWXc0N4XygMMwil89vL0JNoU68kO507qEXky
         TAww==
X-Forwarded-Encrypted: i=1; AJvYcCXMEgJHYkA2UyYjJ+fzWb52Kzeosw3bg38Du7A0gS15pNbzmkF/YwBPzDraD83fuBBG+gIWkVhvsStxycHeyEmRkXtn
X-Gm-Message-State: AOJu0YwPCej/19AbTisJFZfM5I2W/vhdpjyMqE27XOiSnDpEuMgLr7nm
	lN4NfALsUp3c1DgWMjz6aAncUm9hDUGOfmtKKodOzTeh5Q9p2sKm+Tz0I3+GOlNKFdni3ccmOK1
	E8g==
X-Google-Smtp-Source: AGHT+IEaeDMKYP+oZ4yMiooXp15i8OqFIPHPpI4Wq8AdBiUZOqVliGDQhA+kWAKZISxz+6sCeBULcy63Vr4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1502:b0:dfa:ff27:db9 with SMTP id
 3f1490d57ef6-e02be2e9dd4mr1632880276.5.1718977725069; Fri, 21 Jun 2024
 06:48:45 -0700 (PDT)
Date: Fri, 21 Jun 2024 06:48:43 -0700
In-Reply-To: <4b57f565-25b0-4b97-ac78-4913a8b1d225@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com>
 <20240619182128.4131355-2-dapeng1.mi@linux.intel.com> <ZnRV6XrKkVwZB2TN@google.com>
 <4b57f565-25b0-4b97-ac78-4913a8b1d225@linux.intel.com>
Message-ID: <ZnWEu13z3XOB4wjY@google.com>
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Define KVM_PMC_MAX_GENERIC for platform independence
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 21, 2024, Dapeng Mi wrote:
> >> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> >> index 6e908bdc3310..2fca247798eb 100644
> >> --- a/arch/x86/kvm/svm/pmu.c
> >> +++ b/arch/x86/kvm/svm/pmu.c
> >> @@ -218,7 +218,7 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
> >>  	int i;
> >>  
> >>  	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > AMD64_NUM_COUNTERS_CORE);
> >> -	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
> >> +	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
> >>  
> >>  	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
> >>  		pmu->gp_counters[i].type = KVM_PMC_GP;
> >> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> >> index fb5cbd6cbeff..a4b0bee04596 100644
> >> --- a/arch/x86/kvm/vmx/pmu_intel.c
> >> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> >> @@ -570,6 +570,8 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
> >>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >>  	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> >>  
> >> +	BUILD_BUG_ON(KVM_INTEL_PMC_MAX_GENERIC > KVM_PMC_MAX_GENERIC);
> > Rather than BUILD_BUG_ON() for both Intel and AMD, can't we just do?
> >
> > #define KVM_MAX_NR_GP_COUNTERS max(KVM_INTEL_PMC_MAX_GENERIC, KVM_AMD_PMC_MAX_GENERIC)
> 
> Actually I tried this, but compiler would report the below error since
> KVM_PMC_MAX_GENERIC would used to define the array
> gp_counters[KVM_PMC_MAX_GENERIC];
> 
> ./include/linux/minmax.h:48:50: error: braced-group within expression
> allowed only inside a function

Oh, right, the min/max macros are super fancy to deal with types.  How about this
(getting there over 2-3 patches)?

I don't love the "#define MAX", but I don't see a better option.  I suppose maybe
we should use __MAX or KVM_MAX since kvm_host.h is likely included outside of KVM?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c0415899a07..ce0c9191eb85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -532,13 +532,18 @@ struct kvm_pmc {
        u64 current_config;
 };
 
+#define MAX(a, b) ((a) >= (b) ? (a) : (b))
+
 /* More counters may conflict with other existing Architectural MSRs */
-#define KVM_INTEL_PMC_MAX_GENERIC      8
-#define MSR_ARCH_PERFMON_PERFCTR_MAX   (MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define MSR_ARCH_PERFMON_EVENTSEL_MAX  (MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
-#define KVM_PMC_MAX_FIXED      3
-#define MSR_ARCH_PERFMON_FIXED_CTR_MAX (MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
-#define KVM_AMD_PMC_MAX_GENERIC        6
+#define KVM_MAX_NR_INTEL_GP_COUNTERS   8
+#define KVM_MAX_NR_AMD_GP_COUNTERS     6
+#define KVM_MAX_NR_GP_COUNTERS         MAX(KVM_MAX_NR_INTEL_GP_COUNTERS, \
+                                           KVM_MAX_NR_AMD_GP_COUNTERS)
+
+#define KVM_MAX_NR_INTEL_FIXED_COUTNERS        3
+#define KVM_MAX_NR_AMD_FIXED_COUTNERS  0
+#define KVM_MAX_NR_FIXED_COUNTERS      MAX(KVM_MAX_NR_INTEL_FIXED_COUTNERS, \
+                                           KVM_MAX_NR_AMD_FIXED_COUTNERS)
 
 struct kvm_pmu {
        u8 version;
@@ -554,8 +559,8 @@ struct kvm_pmu {
        u64 global_status_rsvd;
        u64 reserved_bits;
        u64 raw_event_mask;
-       struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
-       struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
+       struct kvm_pmc gp_counters[KVM_MAX_NR_GP_COUNTERS];
+       struct kvm_pmc fixed_counters[KVM_MAX_NR_FIXED_COUNTERS];
 
        /*
         * Overlay the bitmap with a 64-bit atomic so that all bits can be

