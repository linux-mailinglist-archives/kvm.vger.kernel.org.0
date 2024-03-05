Return-Path: <kvm+bounces-11061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C4B872691
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2588B28C187
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F43D199B9;
	Tue,  5 Mar 2024 18:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oKmQIFTL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C8112E70
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709663491; cv=none; b=NbjIZQ3ZwwksmVkwKw/tx/+uHY/GSIHX9U6JosUvqQYb/505eR6HUU4Mbv6SAq+JecXImaJQRRm5wFPKvafo5eMxL2SCpU9Dh7OhuJ8CUfrnV0ijugt4ouIJaSubmck/eIq21nefgelUsuV9tiRq0wR58JwGv9LFyTNjosAa7A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709663491; c=relaxed/simple;
	bh=6e4RQ/zZF0nuA79N7nCfJ/8Itu/N9ppQhCFZQB2XfD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZvBi0iHjGnqfnOKIFzM56WM664xRYHDouA0OwyTCpzoeGbCEab+F1AH0IgMpZ/O+5aRDYS0LYw1Mmr+AzLFbHpQazjEKGIWOJDz9LafmZlIDduWreyp/GgW9Du53IJObJnVECplzJ/F5n5eW4UArLmBO0j5qzJCK9lie5MBw4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oKmQIFTL; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d944e8f367so41721575ad.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 10:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709663489; x=1710268289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikksnMYVs1Gg6hYyDAjEo6Ig2VkOOvTHqTs/Rnh5Euk=;
        b=oKmQIFTLaJO8dnHnYoyEq5yY9PjBBOtC7v+irzzJKSiFLsfHL3uotiwH3AvAUqZ7vL
         blt1jCNfeOTlvc5gz5JoEw8Sivq6QZq9HhtztqlyElVK5yUN7m/fx17k4LgodLFldiPH
         65riXrnDQTEk3rxYmf9QtZzKt9GXKieWMwBYDRgODfyvQqWPxXytk8nojP8A9AmtkDbc
         asVn8b+E+gQPycTzpxp0Ba4q0DVKovmAY20BFB7A8l22khmNyRodzd2+F4vQDidH17L9
         d/dLT3bwGH8XIBMvJscJMwVtpYHN7zEr9lhhAS0eUpjLTJAzdKpK5oMsDw/MvEo63Aei
         gGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709663489; x=1710268289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikksnMYVs1Gg6hYyDAjEo6Ig2VkOOvTHqTs/Rnh5Euk=;
        b=WCAbvy4h/tgbKgUMRLMERqR1TZHQJokxmRxNOLSjMKRGzMcCL+SSjMePAJRpjpVBRu
         mCm4y0PNcBqmrZibttbAZY15aR4iKeUgiTH0nIQEDLose4m0PMl5YeIuMGlXzd6jE+YO
         pnlW/N4LNJB5buEEegZ4qgrjIXloIvp3pFtbBdNanaeXeeO7VDT8kCDTR42kb7+0D349
         KWQD7pnf8DC4xq0VZNRQxRLqVkhBpJf+no438teI9RP9EYQmbO7tQjf+YPJJqCIOOlVG
         Ankp/NIrxvtTdSuyn5qHQIPpEd2cwuEWjjBe6OoB9rFQsgxqEScwhmw+CCoeWKADaHVF
         0SZw==
X-Forwarded-Encrypted: i=1; AJvYcCXT4v6gDJP8sOW5CRnhNW+/r9oVZSLV60TTAVaY8qGlrFai7aiToo1cc3Oyh96rVlv/GN856xxlNPP4RJTYnM1pRgcr
X-Gm-Message-State: AOJu0YzM6Qt0n+rfeTDiw7PkJYshgVrkkXxmJH7B8lza71oUcQzMoaNz
	ydH8Z3Z8ULSm2HHSC2d5X/IA0VOopPxim7etBzBCZiZjY2tkF8sVrKQLdUNjCg==
X-Google-Smtp-Source: AGHT+IEGC/IRLGlm7P/7w/8sH7dyZdfBnZ8FWcjAaW4rYyf2s3Ow3+QQ0veOoCfIPZmqiTBSgqSMgA==
X-Received: by 2002:a17:903:124b:b0:1dc:fae0:9073 with SMTP id u11-20020a170903124b00b001dcfae09073mr3403849plh.32.1709663488958;
        Tue, 05 Mar 2024 10:31:28 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090264c900b001dcdfbad420sm10314243pli.149.2024.03.05.10.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 10:31:28 -0800 (PST)
Date: Tue, 5 Mar 2024 18:31:25 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sandipan Das <sandipan.das@amd.com>, pbonzini@redhat.com,
	jmattson@google.com, ravi.bangoria@amd.com, nikunj.dadhania@amd.com,
	santosh.shukla@amd.com, manali.shukla@amd.com, babu.moger@amd.com,
	kvm list <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Message-ID: <Zedk_XsGUTk-Wvde@google.com>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
 <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
 <ZedUwKWW7PNkvUH1@google.com>
 <ZedepdnKSl6oFNUq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZedepdnKSl6oFNUq@google.com>

On Tue, Mar 05, 2024, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Sean Christopherson wrote:
> > On Tue, Mar 05, 2024, Like Xu wrote:
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 87cc6c8809ad..f61ce26aeb90 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
> >  {
> > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > +
> >  	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
> >  		return;
> >  
> > @@ -750,8 +752,18 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
> >  	 */
> >  	kvm_pmu_reset(vcpu);
> >  
> > -	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> > +	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
> >  	static_call(kvm_x86_pmu_refresh)(vcpu);
> > +
> > +	/*
> > +	 * At RESET, both Intel and AMD CPUs set all enable bits for general
> > +	 * purpose counters in IA32_PERF_GLOBAL_CTRL (so that software that
> > +	 * was written for v1 PMUs don't unknowingly leave GP counters disabled
> > +	 * in the global controls).  Emulate that behavior when refreshing the
> > +	 * PMU so that userspace doesn't need to manually set PERF_GLOBAL_CTRL.
> > +	 */
> > +	if (kvm_pmu_has_perf_global_ctrl(pmu))
> > +		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
> >  }
> 
> Doh, this is based on kvm/kvm-uapi, I'll rebase to kvm-x86/next before posting.
> 
> I'll also update the changelog to call out that KVM has always clobbered global_ctrl
> during PMU refresh, i.e. there is no danger of breaking existing setups by
> clobbering a value set by userspace, e.g. during live migration.
> 
> Lastly, I'll also update the changelog to call out that KVM *did* actually set
> the general purpose counter enable bits in global_ctrl at "RESET" until v6.0,
> and that KVM intentionally removed that behavior because of what appears to be
> an Intel SDM bug.
> 
> Of course, in typical KVM fashion, that old code was also broken in its own way
> (the history of this code is a comedy of errors).  Initial vPMU support in commit
> f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests") *almost*
> got it right, but for some reason only set the bits if the guest PMU was
> advertised as v1:
> 
>         if (pmu->version == 1) {
>                 pmu->global_ctrl = (1 << pmu->nr_arch_gp_counters) - 1;
>                 return;
>         }
> 
> 
> Commit f19a0c2c2e6a ("KVM: PMU emulation: GLOBAL_CTRL MSR should be enabled on
> reset") then tried to remedy that goof, but botched things and also enabled the
> fixed counters:
> 
>         pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
>                 (((1ull << pmu->nr_arch_fixed_counters) - 1) << X86_PMC_IDX_FIXED);
>         pmu->global_ctrl_mask = ~pmu->global_ctrl;
> 
> Which was KVM's behavior up until commit c49467a45fe0 ("KVM: x86/pmu: Don't overwrite
> the pmu->global_ctrl when refreshing") incorrectly removed *everything*.  Very
> ironically, that commit came from Like.
> 
> Author: Like Xu <likexu@tencent.com>
> Date:   Tue May 10 12:44:07 2022 +0800
> 
>     KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing
>     
>     Assigning a value to pmu->global_ctrl just to set the value of
>     pmu->global_ctrl_mask is more readable but does not conform to the
>     specification. The value is reset to zero on Power up and Reset but
>     stays unchanged on INIT, like most other MSRs.
> 
> But wait, it gets even better.  Like wasn't making up that behavior, Intel's SDM
> circa December 2022 states that "Global Perf Counter Controls" is '0' at Power-Up
> and RESET.  But then the March 2023 SDM rolls out and says
> 
>   IA32_PERF_GLOBAL_CTRL: Sets bits n-1:0 and clears the upper bits.
> 
> So presumably someone at Intel noticed that what their CPUs do and what the
> documentation says didn't match.
> 

Sean, can you update your commit message with the table name of the
Intel SDM and the version of the Intel SDM (2023 version). It was quite
hard to find where exactly SDM mentioned this, since I was using the
2022 version.

Thanks.
-Mingwei
> *sigh*

