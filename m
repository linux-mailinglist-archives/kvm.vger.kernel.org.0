Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DEE37C7EC
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhELQDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbhELPlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 11:41:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E52C034624
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:19:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g24so13689398pji.4
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wQuM+8vl8RXXi53GN0Bxev1KdO1+AOXUsVXjVxgXMEU=;
        b=Gk8wYyrGJM70yGgKGKycvu8PnplDnEkH+5OEJt1C22vqGyiKdmOFlPZPA4wckvHBET
         axKUrRx6NchuLk8scPXGEtyWZbrMUjktcZzI6IZPZASxILpdMBJY9viFlOVfgQP+1ofj
         8ivalJAblF5A9U1KeFVPm+l1DehzV8utNI6wKbpOuN7sn4EZN8l3nmYK2Ha5b48ec5bb
         PkHE+RTHRPw+V6q8eeejDJZEcjybkgbXPBTAM2+IDQN41aZzgX59kh/WAZuc3y+C8UdB
         J2rzs7xhcqLwFjt6Y8n8OyNF+VMCIidkgeRuEkVzMx5kEVTsP34xSAFxgk40tFKJQiJ0
         dlug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQuM+8vl8RXXi53GN0Bxev1KdO1+AOXUsVXjVxgXMEU=;
        b=c8/X5YoV9oT9StkBh/Ihu65v+5l7sr4iffK60V0WaBWQ52ArYq2d+xln5XldrMx/2U
         vxVbgut+ZbndUKvvvp3rNeE2WRZmObcyl/6KxTOAdVymYKNzunIjGQBdVCgjBDCVishr
         iKZ6owUpd1vvWqPMKOSlzNBPsRcIoPkdx+xjML4MyopkHHlE+n02SMb5MUdly8k8CA/L
         Sc6mMx0iAlFJSrl6X6Lk4VDIWmeFhLxAjlt1+v6pigCbAzIyNnfpx9XbtyDgvfd8I83z
         zqnrzJp5WlXtBwwEoGZ/aV49DrVzi8SNga7Zx9O+tGgDIeBvLIm3hnVKKqVUD1qpZRgC
         HYzw==
X-Gm-Message-State: AOAM532gAoJVqW6jAtDkfYZsj1zowT+W3mSIWjh4apxpD4riY47ZgU8I
        DfX5kAC0yyv8AlIAXnj2FqWyNQ==
X-Google-Smtp-Source: ABdhPJxh8LL59gW6hhs773DJVJAXhM8iujV6qd8DtWRXyM/hNNcnsGmWDL4gazXHGRThy8NlUzuz3Q==
X-Received: by 2002:a17:90a:4503:: with SMTP id u3mr41532313pjg.214.1620832742442;
        Wed, 12 May 2021 08:19:02 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id m3sm174335pfh.174.2021.05.12.08.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 08:19:01 -0700 (PDT)
Date:   Wed, 12 May 2021 15:18:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Venkatesh Srinivas <venkateshs@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Yao Yuan <yuan.yao@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
Message-ID: <YJvx4tr2iXo4bQ/d@google.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com>
 <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Xu, Like wrote:
> Hi Venkatesh Srinivas,
> 
> On 2021/5/12 9:58, Venkatesh Srinivas wrote:
> > On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
> > > On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> > > detect whether the processor supports performance monitoring facility.
> > > 
> > > It depends on the PMU is enabled for the guest, and a software write
> > > operation to this available bit will be ignored.
> > Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
> > documented someplace?
> 
> The bit[7] behavior of the real hardware on the native host is quite
> suspicious.

Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
current phrasing is a mess:

  Performance Monitoring Available (R)
  1 = Performance monitoring enabled.
  0 = Performance monitoring disabled.

The (R) is ambiguous because most other entries that are read-only use (RO), and
the "enabled vs. disabled" implies the bit is writable and really does control
the PMU.  But on my Haswell system, it's read-only.  Assuming the bit is supposed
to be a read-only "PMU supported bit", the SDM should be:

  Performance Monitoring Available (RO)
  1 = Performance monitoring supported.
  0 = Performance monitoring not supported.

And please update the changelog to explain the "why" of whatever the behavior
ends up being.  The "what" is obvious from the code.

> To keep the semantics consistent and simple, we propose ignoring write
> operation in the virtualized world, since whether or not to expose PMU is
> configured by the hypervisor user space and not by the guest side.

Making up our own architectural behavior because it's convient is not a good
idea.

> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index 9efc1a6b8693..d9dbebe03cae 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> > >   	if (!pmu->version)
> > >   		return;
> > > 
> > > +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;

Hmm, normally I would say overwriting the guest's value is a bad idea, but if
the bit really is a read-only "PMU supported" bit, then this is the correct
behavior, albeit weird if userspace does a late CPUID update (though that's
weird no matter what).

> > >   	perf_get_x86_pmu_capability(&x86_pmu);
> > > 
> > >   	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5bd550eaf683..abe3ea69078c 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
> > > msr_data *msr_info)
> > >   		}
> > >   		break;
> > >   	case MSR_IA32_MISC_ENABLE:
> > > +		data &= ~MSR_IA32_MISC_ENABLE_EMON;

However, this is not.  If it's a read-only bit, then toggling the bit should
cause a #GP.

> > >   		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
> > > &&
> > >   		    ((vcpu->arch.ia32_misc_enable_msr ^ data) &
> > > MSR_IA32_MISC_ENABLE_MWAIT)) {
> > >   			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> > > --
