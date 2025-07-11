Return-Path: <kvm+bounces-52105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACC0B016D3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 10:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9B737600D3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96AF21ABCB;
	Fri, 11 Jul 2025 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="K4OQB0am"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702341F8722
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 08:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752223873; cv=none; b=UA864qBsg/oH3+S1SUhGso+HB6RNhjoW3xYhsPdUX6lfL9bR5KXp2O2RRzqtTKe2/JVVwjMi9OpNPddH90QOC0tHCJvMMlNt4lQpYxCy9PvHno1VT5Tfs7OC/1/WGtHhu/8XQR4bvgOd0nRRG6GxhXYW2dx6JjAQo8SciM5tNyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752223873; c=relaxed/simple;
	bh=z8h37/P+/Go2N/WRw7N3Bh2YW9ttrIhdTMNeQsayI1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1XtkfS7T95PqIFka+xwvY805UetJl1wi4wepdKZlmBJ+kdSLCMhClaSppZ7K9xCI5rG6rx0s82QG0MilYlzAsCLssTHfERP0jr+bNb/o8eQO3xLQecLMudvdCv4+wXMJ5qYrD0xhyK60ZAWJKhdpVHaMlgP1nGZQ2pJop/eZ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch; spf=none smtp.mailfrom=ffwll.ch; dkim=pass (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b=K4OQB0am; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ffwll.ch
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ffwll.ch
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3b49ffbb31bso1121615f8f.3
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 01:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google; t=1752223869; x=1752828669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLc+yAyLpgSsVL0DY27MbVKG7PMR2I1NMPg5UEUaSYE=;
        b=K4OQB0amdd4XDc0xIgjIUKIA7KOpnYL9ZnXtzWEcHVqy40zZ1qwYMH+78nAFS36fgP
         ZKN3ucEg2YGZAcesweH3KkV5sh4kDxbi7HcWjq5ZBVXTZOgPU8OULctVcQNksPgazee9
         AkahTFw+vforK/0KBuWkEC3gd2rycTIcQ2+lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752223869; x=1752828669;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wLc+yAyLpgSsVL0DY27MbVKG7PMR2I1NMPg5UEUaSYE=;
        b=o+SxCixhi+sDQq1tBYWX4/V2GXEi8gErzFCUyy2ERiQ0EHkp+HWE6/Sob+UvUatHuP
         xy18AnJg5aWRuqzCq2EluVaszPbuwd2qXVGl0A817LvwIZ8E8+liDOXEPvMOTY0NMxGU
         G3v2pJ83NJfRWw9FG3/UNPvpJiuBe3Y/YungevGS4vyKv67ci9PVCpZ14oZh4SJRWoJ6
         GYH1VT00XNh8MA0Lnt011YWkjSFErb+n+lpyh0tCN3nxV3y1F6W4oYn6b0zpUp0MfEiM
         pQFpMkLS0C3YBSFy76bP6pWynx20QwxzE7xTrm/rd0lCJbiRSM9rv0t2a5D5/3X8Ik10
         jcjA==
X-Forwarded-Encrypted: i=1; AJvYcCWfgId+2kzSb45aEoloHJoNUMdsWU0PMK3lVLfR9Ah7+Us4auDT/7z1U9ntCtNAEFldAO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqKO1XB+T7pHiz5nFc0av2dZzg6h3DWkhdaiwteA7rqsOpNEbq
	6uYpU4Ly8AvgvKnN+mXvgnHcrcudusKksMvsEIf8hV8fZThOZF/eHIg4MUxS4QuvpZc=
X-Gm-Gg: ASbGnctdQjkrJRT8CHw1msq8XbIQlm5Mkv+nhFhj9Iiyz27ov73f4vygkdWjzLE18M5
	aakAYstu5QrN4kekRAkLcAV4lGO2zX1F7onhd9nj5NdT3arEIBfe7SK1pMfx28ZDcgYp0NoqKGF
	ha4CoTGac4Bc7dhMEDwOr1aFNo18zFqHOHkUjK5dEAhs71nCFVsIOeh/jii9H5tYrg8Cb3HNo0s
	OhGXMgbkan5OtPCRtkMVj7hV3Z000IE0aUAqstuwX3XXHqH3FQL59w5sYNCbn3BPdcDs8VfbJFV
	J386sme4sBxb8/L2VB+DdAVzg90jLyrpedhWSkOa2ba3BzMhFlMn9h6FHoNJl4Szg72C4mqf0Ou
	J6TmejcvwQZKai3SUOdm+DbWqgG+SOBNQCg==
X-Google-Smtp-Source: AGHT+IF/p5JseJYyVQuyUwqnGmfxYrQbso5K+hNI8FrIUfZsi1LkIHNT8yNbMfG/FKzdOjwH5E48Pg==
X-Received: by 2002:adf:9c84:0:b0:3a5:1f2:68f3 with SMTP id ffacd0b85a97d-3b5f18d2e76mr2229476f8f.46.1752223868625;
        Fri, 11 Jul 2025 01:51:08 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:5485:d4b2:c087:b497])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc2087sm3957272f8f.30.2025.07.11.01.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 01:51:08 -0700 (PDT)
Date: Fri, 11 Jul 2025 10:51:06 +0200
From: Simona Vetter <simona.vetter@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Kevin Loughlin <kevinloughlin@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Mingwei Zhang <mizhang@google.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>
Subject: Re: [PATCH v3 3/8] x86, lib: Add WBNOINVD helper functions
Message-ID: <aHDQersZPA9D8fJb@phenom.ffwll.local>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Kevin Loughlin <kevinloughlin@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Zheyun Shen <szy0127@sjtu.edu.cn>,
	Mingwei Zhang <mizhang@google.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>
References: <20250522233733.3176144-1-seanjc@google.com>
 <20250522233733.3176144-4-seanjc@google.com>
 <20250710112902.GCaG-j_l-K6LYRzZsb@fat_crate.local>
 <20250710143729.GL1613200@noisy.programming.kicks-ass.net>
 <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710154704.GJ1613633@noisy.programming.kicks-ass.net>
X-Operating-System: Linux phenom 6.12.30-amd64 

On Thu, Jul 10, 2025 at 05:47:04PM +0200, Peter Zijlstra wrote:
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

There's some ancient pentium M where clflush is a no-op (or at least not
getting stuff flushed enough for the gpu to see it), but we still need to
ensure cache coherency with the non-coherent gpu, and wbinvd does the job.
I figured this out with sheer desperation over a decade ago myself,
it's pain.

There shouldn't be any other reason for i915 to wbinvd.
-Sima

> 
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

-- 
Simona Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

