Return-Path: <kvm+bounces-30763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A819BD430
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFEEF1F2389E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AD91E7653;
	Tue,  5 Nov 2024 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVxrRF8J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6235F70826
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730830224; cv=none; b=qNMlb9mrivQDZSJPNKoGyS4dL8KK4t2ufBLEvrXXHfswJ+Fjl/HWZrNP7Kp9au9JnBfhZGea2Dfcx6Rgvc4QMNMDKPvCRn+FRln3S8zklzQ8V7opD2lw+GJIzA5eZjQraGGsnXfLfX4e89ekNOMT4B2Tu9cJP8OmBMSvO80fIaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730830224; c=relaxed/simple;
	bh=fz6xeFnmysicpSDpNhy8mDv8wbsXDHiThab+QK7p088=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KBxItX4i5QtkQRuSx+q1+8SvR6BFkErz6qAl82+USmbTs7tl/ggpV4DEwZVI7zHI/s8ZUjp1Tfsk2BkFBMogJbZ8NetCWTaPHGUGGbpcfE6AuxjK7bwAdk59ZtzOWb6DZfRvRDlS6Ye2bZ8PyqsKJqJOjNX+aL0zEZBwqC7Cdgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVxrRF8J; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2d396c77fso7325793a91.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730830222; x=1731435022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkEGd4+bukWRAG7FqtPkBnT4uJ2GJNJY6UkTabicd3E=;
        b=wVxrRF8JzyV56iMyNMJJku9fxJrpcXZAzw1ZzvnHmO8EYsSaVKV8vnFLruSCkQ5znH
         fqry5oVlIWawZw8WS9LfHP5pnONM/4//0TGsj8bFkSXUe6C6YcT3kti+VkvyvFNbZ8jP
         NhwDDm3nUpQHCLGf9xxMMI6ub8IYuD+EqoMP8r7O9ozERk6MhzFbYI6BRfp1KozGwTyq
         J9tC2gPpsLsCGaKLVWBXaDyfD3jH68euAdMx1hjS8gEdPpSf4/UJR/ZfzlQPvHekuSfx
         Oq9SxaWbBXliJv3oYo8tas54WFF8vDaZQZYyjF2LmZWmGPPqM3Jg1heGjNhy36waqoww
         AmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730830222; x=1731435022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkEGd4+bukWRAG7FqtPkBnT4uJ2GJNJY6UkTabicd3E=;
        b=m3THDoDSHG4GJMO/KjmCLDG+jihls3Ja/+T//eyiVtbfEqQUHye+qUbfBOKqOQxJsa
         TNF4yQ4Lrb/assveh+jmNrhg75SARqwNfB6Aq+WsiwLWA5slDZW3/0pvC5zBFimh5Rr1
         jXIXnbWSWT8RGhrRa4TrUMS/HLjVOT4GfDgZYTI/M2L8Rcphor6wqOrnk5WjUWwBp2se
         jphsv1YbNAmaL9wfRq6VHSlH6nVPwDJMWR8S/bejTxVnSrRuQ/aBDgY6lFF/UzVUuApb
         6ec9X4QWZaK8YOYbNurmxOkLRqdyCNCxokecPOZfhhneYs8kgKfZcAsu4KlwO+CN9B/Z
         x23Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwG36+EiJJyXSZyAwatCOQzxjG5dhT/qDopsTfWBwriumz4/TX8Fx7lZRSU6rH2YWObJM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9VL/h3pmoBZzUDIDr8sye/i+22uCSopFTF2lWsZ7caGh36P5c
	ToNLIigdZvVi6p+qaFrSlRKKydUkYpe+NC0eKU1VcqEesxT/wrwrDaxmatBtR7ZWYb03ZBw2Ltw
	Aww==
X-Google-Smtp-Source: AGHT+IFUTkbcBRXmscHo1q+zQgvZfi61AWn7KTfXysjzi6xAhC8CxkXctNHnMeSmNRFbvvBhxsiJcV0Leg8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1fce:b0:2e2:d434:8540 with SMTP id
 98e67ed59e1d1-2e94c532745mr50926a91.6.1730830221685; Tue, 05 Nov 2024
 10:10:21 -0800 (PST)
Date: Tue, 5 Nov 2024 10:10:20 -0800
In-Reply-To: <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241104101543.31885-1-bp@kernel.org> <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local>
Message-ID: <ZypfjFjk5XVL-Grv@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, Borislav Petkov wrote:
> On Mon, Nov 04, 2024 at 04:57:20PM -0800, Sean Christopherson wrote:
> > scripts/get_maintainer.pl :-)
> 
> That's what I used but I pruned the list.
> 
> Why, did I miss anyone?

All of the actual maintainers.  AFAIK, Paolo doesn't subscribe to kvm@.

> > But why do this in KVM?  E.g. why not set-and-forget in init_amd_zen4()?
> 
> Because there's no need to impose an unnecessary - albeit small - perf impact
> on users who don't do virt.
> 
> I'm currently gravitating towards the MSR toggling thing, i.e., only when the
> VMs number goes 0=>1 but I'm not sure. If udev rules *always* load kvm.ko then
> yes, the toggling thing sounds better. I.e., set it only when really needed.
> 
> > Shouldn't these be two separate patches?  AFAICT, while the two are related,
> > there are no strict dependencies between SRSO_USER_KERNEL_NO and
> > SRSO_MSR_FIX.
> 
> Meh, I can split them if you really want me to.

I do.

> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 9df3e1e5ae81..03f29912a638 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -608,6 +608,9 @@ static void svm_disable_virtualization_cpu(void)
> > >  	kvm_cpu_svm_disable();
> > >  
> > >  	amd_pmu_disable_virt();
> > > +
> > > +	if (cpu_feature_enabled(X86_FEATURE_SRSO_MSR_FIX))
> > > +		msr_clear_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT);
> > 
> > I don't like assuming the state of hardware.  E.g. if MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT
> > was already set, then KVM shouldn't clear it.
> 
> Right, I don't see that happening tho. If we have to sync the toggling of this
> bit between different places, we'll have to do some dance but so far its only
> user is KVM.
> 
> > KVM's usual method of restoring host MSRs is to snapshot the MSR into
> > "struct kvm_host_values" on module load, and then restore from there as
> > needed.  But that assumes all CPUs have the same value, which might not be
> > the case here?
> 
> Yes, the default value is 0 out of reset and it should be set on each logical
> CPU whenever we run VMs on it. I'd love to make it part of the VMRUN microcode
> but... :-)
> 
> > All that said, I'd still prefer that MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT is set
> > during boot, unless there's a good reason not to do so.
> 
> Yeah, unnecessary penalty on machines not running virt.

What does the bit actually do?  I can't find any useful documentation, and the
changelog is equally useless.

