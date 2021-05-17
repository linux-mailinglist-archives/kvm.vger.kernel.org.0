Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13AA386C17
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 23:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhEQVRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 17:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbhEQVRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 17:17:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16AEC061756
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:16:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m124so5491300pgm.13
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 14:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VS/d1ygvax/ecc40AMqCMRIidrRC6z+MW9ukoKSz1kY=;
        b=cShCEvxr/sMuoFEP+hdg6OA2vj7ephjyPaPcbARJSZUPafU/opm6bend3SFFJGF5Cp
         vVM05172lfJur21aBwDSgpcyganE4q1KDigXFxnPf3JP8u/kWrycWKtUXT9EbOQx1BiH
         CRZvtWJ1CduUWVAKtPLflybQwnrNvPFg2F8Aifl09VLPzV5xLJ6qkVkMwcGmMFKZRWHa
         b3EsQwpwT6LVMFAWvzg8cFfLfXT6gg34k7eRJUR8qSXuGILEs7LEpedn7/WRT+0NUfxi
         B+WTPdHXjndOHx69gZh3dnp4N+1DZVQwmNoIE2v7Zy6HpvJ1iaxTf397i7fRbSamKYZ9
         KAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VS/d1ygvax/ecc40AMqCMRIidrRC6z+MW9ukoKSz1kY=;
        b=NnJeG8PNASeT6XQ7blSwThu9mB65zieAdqFX008/XeSCc1JUnenuIfhpqeUaQq4IW/
         Qew1PalGFFn0evxCbF+bug2cQUFsjJNDQxzrQkDsdgoTam/ZkkQtCVKQ5SE2Sw3uBNWb
         HoHKI7kfRlKMPi3GGgYjsllCruLdnbHHJhDWFv6DPg7s5coK932LgIIk3Ruzr3L3t71c
         DPDlq3tl+TUmdOmLLnWQ5JzMuWwGzdC2HQHwNExHLcTaGYleQsMMlznyuUzRye0Adstq
         NpClAWukd2C1nGQ2th6hlNwowcHrAc5KxnEVeeOX2tXPGkSnLWU+OX9T4NADJknLNxAt
         M+aw==
X-Gm-Message-State: AOAM530BMy2jqmJ3xn814q3AGGcCGSXAg0Pm24FnYWj78KZE+/h4a33P
        KTN9bTOnNaAHw/iGa5jJwGek/w==
X-Google-Smtp-Source: ABdhPJwViqzdF1b5ZHIm0m6FKKG55Ddy/a6H3A1E+amWE89xToL2mXygjvgt37C8Pe6IcCUVgmJHxQ==
X-Received: by 2002:a63:d312:: with SMTP id b18mr1460857pgg.89.1621286165987;
        Mon, 17 May 2021 14:16:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w127sm10520673pfw.4.2021.05.17.14.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 14:16:05 -0700 (PDT)
Date:   Mon, 17 May 2021 21:16:01 +0000
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
Message-ID: <YKLdETM7NgjKEa6z@google.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-5-like.xu@linux.intel.com>
 <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
 <ead61a83-1534-a8a6-13ee-646898a6d1a9@intel.com>
 <YJvx4tr2iXo4bQ/d@google.com>
 <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ef2215b-1c43-fc8a-42ef-46c22e093f40@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021, Xu, Like wrote:
> On 2021/5/12 23:18, Sean Christopherson wrote:
> > On Wed, May 12, 2021, Xu, Like wrote:
> > > Hi Venkatesh Srinivas,
> > > 
> > > On 2021/5/12 9:58, Venkatesh Srinivas wrote:
> > > > On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
> > > > > On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> > > > > detect whether the processor supports performance monitoring facility.
> > > > > 
> > > > > It depends on the PMU is enabled for the guest, and a software write
> > > > > operation to this available bit will be ignored.
> > > > Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
> > > > documented someplace?
> > > The bit[7] behavior of the real hardware on the native host is quite
> > > suspicious.
> > Ugh.  Can you file an SDM bug to get the wording and accessibility updated?  The
> > current phrasing is a mess:
> > 
> >    Performance Monitoring Available (R)
> >    1 = Performance monitoring enabled.
> >    0 = Performance monitoring disabled.
> > 
> > The (R) is ambiguous because most other entries that are read-only use (RO), and
> > the "enabled vs. disabled" implies the bit is writable and really does control
> > the PMU.  But on my Haswell system, it's read-only.
> 
> On your Haswell system, does it cause #GP or just silent if you change this
> bit ?

Attempting to clear the bit generates a #GP.

> > Assuming the bit is supposed
> > to be a read-only "PMU supported bit", the SDM should be:
> > 
> >    Performance Monitoring Available (RO)
> >    1 = Performance monitoring supported.
> >    0 = Performance monitoring not supported.
> > 
> > And please update the changelog to explain the "why" of whatever the behavior
> > ends up being.  The "what" is obvious from the code.
> 
> Thanks for your "why" comment.
> 
> > 
> > > To keep the semantics consistent and simple, we propose ignoring write
> > > operation in the virtualized world, since whether or not to expose PMU is
> > > configured by the hypervisor user space and not by the guest side.
> > Making up our own architectural behavior because it's convient is not a good
> > idea.
> 
> Sometime we do change it.
> 
> For example, the scope of some msrs may be "core level share"
> but we likely keep it as a "thread level" variable in the KVM out of
> convenience.

Thread vs. core scope is not architectural behavior.  Maybe you could argue that
it is for architectural MSRs, but even that is tenuous, e.g. SPEC_CTRL has this:

  The MSR bits are defined as logical processor scope. On some core
  implementations, the bits may impact sibling logical processors on the same core.

Regardless, the flaws of an inaccurate virtual CPU topology are well known, and
are a far cry from directly violating the SDM (assuming the SDM is fixed...).

> > > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > index 9efc1a6b8693..d9dbebe03cae 100644
> > > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> > > > >    	if (!pmu->version)
> > > > >    		return;
> > > > > 
> > > > > +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
> > Hmm, normally I would say overwriting the guest's value is a bad idea, but if
> > the bit really is a read-only "PMU supported" bit, then this is the correct
> > behavior, albeit weird if userspace does a late CPUID update (though that's
> > weird no matter what).
> > 
> > > > >    	perf_get_x86_pmu_capability(&x86_pmu);
> > > > > 
> > > > >    	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 5bd550eaf683..abe3ea69078c 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
> > > > > msr_data *msr_info)
> > > > >    		}
> > > > >    		break;
> > > > >    	case MSR_IA32_MISC_ENABLE:
> > > > > +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
> > However, this is not.  If it's a read-only bit, then toggling the bit should
> > cause a #GP.
> 
> The proposal here is trying to make it as an unchangeable bit and don't make
> it #GP if guest changes it.
> 
> It may different from the host behavior but it doesn't cause potential issue
> if some guest code changes it during the use of performance monitoring.
> 
> Does this make sense to you or do you want to keep it strictly the same as
> the host side?

Strictly the same as bare metal.  I don't see any reason to eat writes from the
guest.
