Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1478F691640
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 02:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjBJBcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 20:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjBJBcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 20:32:24 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C10298C9
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 17:32:23 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id o8so2576875pls.11
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 17:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYnD9chKHCWtyrpf49b2NsC5WdY8A7zHhx6W+ZzkgKw=;
        b=WP6iSEQiMxh6VldKHayGB98be8LoQ/yb8XWZbSqG9VeD9akqVGKxJArMKzpw8s/jx7
         /Ju7rPJsFAxO+u5IjbDf7UkjNFv1rTt0O9uu2YelgQEtpS+h14QR/rBe5da9KJAKQ6Nw
         Q5+jgSrGNGAj9JOLSDIjv6WKfO1xfFyvJDsbaiLfRgelDk4dxvkTAiW3DUsxW69HP6Vv
         OpZlaQPxA4rGNsUMwe74eXwx+VumBbAPB+EXR1vgXRjZoF8k235egypDx4UxNrqQNuDm
         eyTm9rtZiq8ZHkfh5cyLAGOguo3v+PlQ4UaOE7bvGBLwqoZxBxCrHa2YMyiEQjFBjanD
         c/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYnD9chKHCWtyrpf49b2NsC5WdY8A7zHhx6W+ZzkgKw=;
        b=BcKOo0Pz+xewpW2nEaYPLiGsqo3UzLav20FWTFMW6+Y0uwGT3rXlVuXsN3Td2wMGXz
         b/UMfvHt5DOpjSzrj4Ydls6uQJ+x1eHdNeTE8s3+Kt3P0vwWpZkkmRxuz9p7VQolkI5e
         juqXgE2+a5eKVyFxzzYOwQNFUNrLHiH0n2K22tM3L6eJEbF1Mde9wZ+rdJlDl31YtKAh
         I8+nT71thoYcfRGk4i1cH8rj2InzjhmRN5YtRDvEiuMfc8L6k+6OLjCuqs1FcjxPzlBn
         zKx0musN3bnJbPdS9HgAnVLLWdPEx3Q45I5DH7FLf2DDESOYExjecnGLo8swP5NyJV34
         LZJw==
X-Gm-Message-State: AO0yUKWa6KmLFRvynXZwNcImIhI14zne4X4mvV8KVAXOaRN8uXzYhG4s
        CDcCkC0HKfHwdq3X38HrMtL8+w==
X-Google-Smtp-Source: AK7set+j2ckj55z67zfyaU2KvLlcVNTuY86fxaemeG8af8QPBKtxZ84UbhJG4xnOx+mED0d+Y8pKcg==
X-Received: by 2002:a17:902:b115:b0:198:d5cc:44a8 with SMTP id q21-20020a170902b11500b00198d5cc44a8mr44674plr.19.1675992742406;
        Thu, 09 Feb 2023 17:32:22 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q26-20020a63bc1a000000b004cd2eebc551sm1856822pge.62.2023.02.09.17.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 17:32:21 -0800 (PST)
Date:   Fri, 10 Feb 2023 01:32:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/8] KVM: x86/cpuid: Add X86_FEATURE_AMD_PMU_V2 as a
 KVM-only leaf entry
Message-ID: <Y+WeoeEmY4pJCFFi@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-6-likexu@tencent.com>
 <Y9A13G5b1tuoIRUq@google.com>
 <4a7fb3b6-f9eb-6cde-7120-7d256d9d288e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a7fb3b6-f9eb-6cde-7120-7d256d9d288e@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023, Like Xu wrote:
> On 25/1/2023 3:47 am, Sean Christopherson wrote:
> > On Fri, Nov 11, 2022, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > 
> > > Alias X86_FEATURE_AMD_PMU_V2 for feature AMD_PMU_V2 in KVM-only leafs that
> > > aren't scattered by cpufeatures.h so that it can be used in KVM, e.g. to
> > > query guest CPUID.  As a bonus, no translation is needed for these features
> > > in __feature_translate().
> > > 
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Like Xu <likexu@tencent.com>
> > > ---
> > >   arch/x86/kvm/reverse_cpuid.h | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> > > index a19d473d0184..7cfedb3e47c0 100644
> > > --- a/arch/x86/kvm/reverse_cpuid.h
> > > +++ b/arch/x86/kvm/reverse_cpuid.h
> > > @@ -13,6 +13,7 @@
> > >    */
> > >   enum kvm_only_cpuid_leafs {
> > >   	CPUID_12_EAX	 = NCAPINTS,
> > > +	CPUID_8000_0022_EAX,
> > >   	NR_KVM_CPU_CAPS,
> > >   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> > > @@ -23,7 +24,15 @@ enum kvm_only_cpuid_leafs {
> > >   /* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
> > >   #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
> > >   #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
> > > +#define KVM_X86_FEATURE_AMD_PMU_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
> > > +/*
> > > + * Alias X86_FEATURE_* to the KVM variant for features in KVM-only leafs that
> > > + * aren't scattered by cpufeatures.h so that X86_FEATURE_* can be used in KVM,
> > > + * e.g. to query guest CPUID.  As a bonus, no translation is needed for these
> > > + * features in __feature_translate().
> > > + */
> > > +#define X86_FEATURE_AMD_PMU_V2      KVM_X86_FEATURE_AMD_PMU_V2
> > 
> > I gave you bad input earlier, for purely KVM-defined flags there's no need for an
> > intermediate KVM_X86_FEATURE_AMD_PMU_V2, this could simply be:
> > 
> >    #define X86_FEATURE_AMD_PMU_V2         KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
> > 
> > That's a moot point though because, after much searching because I had a very hard
> > time believing the kernel wouldn't want to know about this flag, I found commit
> > 
> >    d6d0c7f681fd ("x86/cpufeatures: Add PerfMonV2 feature bit")
> > 
> > from nearly a year ago.  I.e. to avoid confusiong, this needs to be a scattered
> > flag, not a purely KVM flag.
> > 
> > ---
> >   arch/x86/kvm/reverse_cpuid.h | 7 +++++++
> >   1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
> > index 4945456fd646..333e28b0a13c 100644
> > --- a/arch/x86/kvm/reverse_cpuid.h
> > +++ b/arch/x86/kvm/reverse_cpuid.h
> > @@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
> >   	CPUID_12_EAX	 = NCAPINTS,
> >   	CPUID_7_1_EDX,
> >   	CPUID_8000_0007_EDX,
> > +	CPUID_8000_0022_EAX,
> >   	NR_KVM_CPU_CAPS,
> >   	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> > @@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
> >   /* CPUID level 0x80000007 (EDX). */
> >   #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
> > +/* CPUID level 0x80000022 (EAX) */
> > +#define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
> 
> I'm very confused and is this the usage you want to see:
> 
> 	kvm_cpu_cap_set(KVM_X86_FEATURE_PERFMON_V2)
> 	kvm_cpu_cap_has(KVM_X86_FEATURE_PERFMON_V2)
> 	guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)
> 
> ?

No, all of those should just use X86_FEATURE_PERFMON_V2, i.e. the existing flag
from cpufeatures.h.

> then what about X86_FEATURE_PERFMON_V2 ?

Not sure I follow.  As above, it's scattered, thus KVM needs to redirect it to
the hardware-defined bit position, which is the role of __feature_translate()
and KVM_X86_FEATURE_PERFMON_V2.
