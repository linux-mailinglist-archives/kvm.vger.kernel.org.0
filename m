Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F99477659
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 16:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbhLPPsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 10:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbhLPPse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 10:48:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE62C061574
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:48:34 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so466879pjj.2
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 07:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ezi/caBJl2i4eI7LH4KdLkWBEsHo9ynhHqXr0f1eK30=;
        b=I2ks2WiPn93u/j+iDcTqyGAlCxIqK6tz6FZleGRtI/CNc2BxvfxVhLGSvw9XZpojMT
         UxexSmNxTB0FmDwZTNR4DuRJ6mPaUzQ+fl61LzYZFVMQgp0CUCIZWa46nvXYmGoxxoGg
         LM8EZ+Ay1+Ymqbt8DgLCmvSOFh9wUARDbiNtHD+rT3NEth62KcXnz/Q7be++IlAz5VsQ
         6E+q5M4W+3MgpRZUn5BWzJe0dDttHfh9cDFfYP/riOp1BdtoLg7LHoNDn4aPV8Bco/mF
         cT4tbF/x0XaCsP6rtF3Mat5MNrvTnKu8+Q/pSyiR9SEDzqaUD1Dy9oahLrcSz2an1v6K
         4U0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ezi/caBJl2i4eI7LH4KdLkWBEsHo9ynhHqXr0f1eK30=;
        b=Oyy9fhF8Za96qHqyC/ZpzDmCloUW4X4vUlYx9epEs2IEXzm3vEMrPrm/VoGw1MmJ7R
         p+/156AUOALBhs7Pq5Y7aGz3eHBxgu+z3W6Bp4bMAYvbDUso5oVsl9hcJMjMBXxhUuxi
         Ith4q/wlrviWpbIzvvpPRMk+gcvtE0vfvSceXa03WW2ugaurSrvZ1bK2NawB+My1R1uU
         vYcMPLMPGi+/KLKQiKKq5tMbslsADk40cGLBqf4InGQS4l1WlExplfjQ+ifA1mrAoEv0
         Wpquv9r0BVNHYvK/452x6gfm8Z4BwDXsgcqAN2OcQkvgTwZRiRRlk5D/hRrBjdhC+rkS
         lcGw==
X-Gm-Message-State: AOAM530B3d7dyQm8Ox480mq/GxLTXWVy8uBXrjLkV6gEIsr+MdGiNonJ
        zloRPaGvBQxaL50ZGqIwsAnGhg==
X-Google-Smtp-Source: ABdhPJwXJ2BdU7mXNLVn66CWsR9ai6kDIs+aM7Uhvpk84nE/3cQYOE6aJiacfLkhQnOxlW1NhWjIow==
X-Received: by 2002:a17:903:1d2:b0:142:24f1:1213 with SMTP id e18-20020a17090301d200b0014224f11213mr17040987plh.81.1639669713954;
        Thu, 16 Dec 2021 07:48:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gk13sm9128336pjb.43.2021.12.16.07.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 07:48:33 -0800 (PST)
Date:   Thu, 16 Dec 2021 15:48:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in
 vmx_pmu_msrs_test
Message-ID: <Ybtfzo6Fx6KLfK3V@google.com>
References: <20211215161617.246563-1-vkuznets@redhat.com>
 <YbotG5neKyzhv22Z@google.com>
 <87a6h0vs36.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6h0vs36.fsf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 16, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 85127b3e3690..65e297875405 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3424,7 +3424,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >
> >                 if (!msr_info->host_initiated)
> >                         return 1;
> > -               if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
> > +               if (kvm_get_msr_feature(&msr_ent))
> >                         return 1;
> >                 if (data & ~msr_ent.data)
> >                         return 1;
> 
> This looks OK.
> 
> > @@ -3779,14 +3779,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                 msr_info->data = vcpu->arch.microcode_version;
> >                 break;
> >         case MSR_IA32_ARCH_CAPABILITIES:
> > -               if (!msr_info->host_initiated &&
> > -                   !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
> > +               if (!msr_info->host_initiated)
> >                         return 1;
> >                 msr_info->data = vcpu->arch.arch_capabilities;
> >                 break;
> >         case MSR_IA32_PERF_CAPABILITIES:
> > -               if (!msr_info->host_initiated &&
> > -                   !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > +               if (!msr_info->host_initiated)
> >                         return 1;
> >                 msr_info->data = vcpu->arch.perf_capabilities;
> >                 break;
> >
> 
> Hm, this change will unconditionally forbid reading
> MSR_IA32_ARCH_CAPABILITIES/MSR_IA32_PERF_CAPABILITIES from the guest. Is
> this what we want?

No, I completely misread the code.  The kvm_set_msr_common() goof seems to be
the only bug, and that would also explain the selftest's bad testcase.
