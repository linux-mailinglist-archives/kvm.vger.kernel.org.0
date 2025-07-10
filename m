Return-Path: <kvm+bounces-52047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02360B007F4
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 18:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C08485E13AE
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 15:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A92279907;
	Thu, 10 Jul 2025 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UUKVKHrG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4613D539
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752162906; cv=none; b=L3MfkXNYfsEAUcE+l2a1qJascE+t3MM96vv717heCQnjIjBzzqk/OPX23D9ySf0IR+n7xxoorOyl8ddtlumD0ekRBj0iCngduaO9BSijfgl2sNkSx+z5MOXPYZM5xdj+N6dA+gN8g/4gv+BtnmERC9o0CIYcwhqBKiK51MF0Sug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752162906; c=relaxed/simple;
	bh=1CHakeN939WXJljcdK5RSIiATSuAmDz37pZp0chk3uo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZRtsLwHfcBYYZsXCcwEjf5u7Q+nLJtlfX5LzXoloCB7IFt+gergrI8mdIqHeSunBCegSuigBn3Yh8kJjD8OX9sPWeI2AYkqRboW+V2msbkTfomY6ydd958f4FjLKYpAin9Os8lG205oika8oJR24bOXM/poWcODRRJcGW5LDAWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UUKVKHrG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b00e4358a34so859924a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752162904; x=1752767704; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nV1olJ9SZ90DwgRNYjXjgenr93Qe34BEuVW+pd4gRI8=;
        b=UUKVKHrGBofe9xHOAHYXC2C3BRKNHTAJ0jcCrkQ3b8UJrVk4mlgWlrOw0u7s9DebG1
         ViJJBIt3onZXOlqyGFJaBUklvs5rSz6MMKobR48QAd7Htyo0n5PiPOu+aQX1YKdJfWd8
         54nJf/CeLlyzN9zbTT+z+Ok3X/UJ+RHZn1ng+CpU01/y/4MdB6W+hzYxOH5ZVL2dWXEB
         rYLTt1fgEu4ewZxv9fvEs3oi1uYoMLnBeiRjfJyNCYV1bTrMmzYCT+kCV3V8bsAGvAZq
         C4W8p7Mth5wDCIPWVVkbXD17D71shXM9e/h1mKCsN+X/SohhuLjAzORdBo2VdL6MchA9
         FvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752162904; x=1752767704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nV1olJ9SZ90DwgRNYjXjgenr93Qe34BEuVW+pd4gRI8=;
        b=s5lczZ3M0ZxqLTBOt4X3yEc2XgE0+oQ3eFFh9gkNZTZh+wDJ0/NOyDMIFSe50rW76i
         xsrIsarJICmGoOoD4qfQ9K4CQ/9THekRyox+hn5TU8N4SYob1FjG0tRk/ZxNVBe9hsvD
         icyekJDquXtS9H2YLuWRrKdGomXvLslhws6YkszuIwjT8gs6nJBe3GqTGcjcnmPddAbJ
         KMOAFUTzEvdiwg1lNwFY8Le+hYjUvwrTaasO+RiaejVRjgmHZSj2AkiGBrYqJxi3D+Qg
         hq/kawHSXfQa6IgPyvOHc210hfXKftSGXbcs1sD3iDlQUwwkrsIehb2wQqVJRQY1A2KT
         nWpw==
X-Forwarded-Encrypted: i=1; AJvYcCWf/zuE6g/I5tqXSByVXqKIuE3wbahV82MTHDvVLmXhBuckavOk1mn16h0edI2wN+Koipg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA0sgRlJmfXvszDqNyrspgzyu47HKse1J+/rzrnfEwGBhhoKLI
	9TtJ1xKeHZ6rt83a3hZbDtJINyivIRo6WL75r0pWHfdUKwMdXxs/QptFsIrGQirBxl+s817p7Sr
	TPIJmsA==
X-Google-Smtp-Source: AGHT+IFICyjT9NXq9BtYtyMoFZr6GhrLdcBIWlvwDgWHmErMpo1E4lmn/+/4G6o3U8umnLwC4rTugmVEgfI=
X-Received: from pjb12.prod.google.com ([2002:a17:90b:2f0c:b0:31c:15e1:d04])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d89:b0:311:c1ec:7cfb
 with SMTP id 98e67ed59e1d1-31c4cce03acmr45281a91.21.1752162904337; Thu, 10
 Jul 2025 08:55:04 -0700 (PDT)
Date: Thu, 10 Jul 2025 08:55:02 -0700
In-Reply-To: <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com> <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local> <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
 <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
Message-ID: <aG_iVqMkeIUELiTX@google.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Kevin Loughlin <kevinloughlin@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Mingwei Zhang <mizhang@google.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 10, 2025, Peter Zijlstra wrote:
> On Thu, Jul 10, 2025 at 04:37:29PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 10, 2025 at 01:29:02PM +0200, Borislav Petkov wrote:
> > > On Thu, May 22, 2025 at 04:37:27PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> > > > index 079c3f3cd32c..1789db5d8825 100644
> > > > --- a/arch/x86/lib/cache-smp.c
> > > > +++ b/arch/x86/lib/cache-smp.c
> > > > @@ -19,3 +19,14 @@ void wbinvd_on_all_cpus(void)
> > > >  	on_each_cpu(__wbinvd, NULL, 1);
> > > >  }
> > > >  EXPORT_SYMBOL(wbinvd_on_all_cpus);
> > > > +
> > > > +static void __wbnoinvd(void *dummy)
> > > > +{
> > > > +	wbnoinvd();
> > > > +}
> > > > +
> > > > +void wbnoinvd_on_all_cpus(void)
> > > > +{
> > > > +	on_each_cpu(__wbnoinvd, NULL, 1);
> > > > +}
> > > > +EXPORT_SYMBOL(wbnoinvd_on_all_cpus);
> > > 
> > > If there's no particular reason for the non-GPL export besides being
> > > consistent with the rest - yes, I did the change for wbinvd_on_all_cpus() but
> > > that was loooong time ago - I'd simply make this export _GPL.
> > 
> > Uhhhh, how about we use this fancy export to known modules only thing
> > for this?
> > 
> > These are typical things we do *NOT* want people to actually use.
> 
> So kvm-amd is the SEV stuff, AGPGART is the ancient crap nobody cares
> about, CCP is more SEV stuff, DRM actually does CLFLUSH loops, but has a
> WBINVD fallback. i915 is rude and actually does WBINVD. Could they
> pretty please also do CLFLUSH loops?

FWIW, doing CLFLUSH in KVM isn't feasible.  In multiple flows, KVM doesn't have
a valid virtual mapping, and hardware *requires* a WBINVD for at least one of the
SEV paths.

> Anyway, the below seems to survive an allmodconfig.
> 
> ---
> diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
> index c5c60d07308c..ac3cc32a4054 100644
> --- a/arch/x86/lib/cache-smp.c
> +++ b/arch/x86/lib/cache-smp.c
> @@ -12,19 +12,19 @@ void wbinvd_on_cpu(int cpu)
>  {
>  	smp_call_function_single(cpu, __wbinvd, NULL, 1);
>  }
> -EXPORT_SYMBOL(wbinvd_on_cpu);
> +EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_cpu, "kvm-amd,agpgart,ccp,drm,i915");

Patch 5 of this series drops KVM's homebrewed version of WBINVD-on-CPU, so this
one at least would need to export the symbol for "kvm" as well.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1d0e9180148d..d63a2c27e058 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4965,11 +4965,6 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	return r;
 }
 
-static void wbinvd_ipi(void *garbage)
-{
-	wbinvd();
-}
-
 static bool need_emulate_wbinvd(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_has_noncoherent_dma(vcpu->kvm);
@@ -4991,8 +4986,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		if (kvm_x86_call(has_wbinvd_exit)())
 			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
 		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
-			smp_call_function_single(vcpu->cpu,
-					wbinvd_ipi, NULL, 1);
+			wbinvd_on_cpu(vcpu->cpu);
 	}
 
 	kvm_x86_call(vcpu_load)(vcpu, cpu);
-- 

>  
>  void wbinvd_on_all_cpus(void)
>  {
>  	on_each_cpu(__wbinvd, NULL, 1);
>  }
> -EXPORT_SYMBOL(wbinvd_on_all_cpus);
> +EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_all_cpus, "kvm-amd,agpgart,ccp,drm,i915,intel-gtt");
>  
>  void wbinvd_on_cpus_mask(struct cpumask *cpus)
>  {
>  	on_each_cpu_mask(cpus, __wbinvd, NULL, 1);
>  }
> -EXPORT_SYMBOL_GPL(wbinvd_on_cpus_mask);
> +EXPORT_SYMBOL_GPL_FOR_MODULES(wbinvd_on_cpus_mask, "kvm,kvm-amd,agpgart,ccp,drm,i915");
>  
>  static void __wbnoinvd(void *dummy)
>  {
> @@ -35,10 +35,10 @@ void wbnoinvd_on_all_cpus(void)
>  {
>  	on_each_cpu(__wbnoinvd, NULL, 1);
>  }
> -EXPORT_SYMBOL_GPL(wbnoinvd_on_all_cpus);
> +EXPORT_SYMBOL_GPL_FOR_MODULES(wbnoinvd_on_all_cpus, "kvm-amd,agpgart,ccp,drm,i915");
>  
>  void wbnoinvd_on_cpus_mask(struct cpumask *cpus)
>  {
>  	on_each_cpu_mask(cpus, __wbnoinvd, NULL, 1);
>  }
> -EXPORT_SYMBOL_GPL(wbnoinvd_on_cpus_mask);
> +EXPORT_SYMBOL_GPL_FOR_MODULES(wbnoinvd_on_cpus_mask, "kvm-amd,agpgart,ccp,drm,i915");

