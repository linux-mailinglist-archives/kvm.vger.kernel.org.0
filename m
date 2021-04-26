Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C595136BA24
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhDZTjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbhDZTjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:39:24 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2D9C061756
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:38:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id i190so101736pfc.12
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ab2HES6R0vCLyUYQvcY8/tnqqG94WlRNIsnH2B1gsKI=;
        b=ocwCBcwt2VCpKKeAqYQfJueYG8T5dZBsg0BzfmEJ4kC9MQSlmlps94SflUGmK2mVr/
         WzULuKECHKMXaVeHed4EbwbPTktOzC/Pgk43oq9BfjiNl9DYJSHZ1DjOc/t8kknhwyos
         MLA6+f66wmN8WT0jaM98sT3w7onjO+15DTtIVIU9N1eRRoPOc9oSYvB9YPwvlTSSN382
         w/vLzw0csN6NyA/H8UVawatOlVRmxH5k629uNs1QdMfjlzpbu89hGYSXQs+rLnsaR5Y+
         hKRsz7CWwC/aEpbIK3hfzxMLEx31bnYkEZGrBGbc5BwYLNwMwWnf/JocYnjRsdjsO1Ts
         h9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ab2HES6R0vCLyUYQvcY8/tnqqG94WlRNIsnH2B1gsKI=;
        b=pqrXr3MfUg/8hOhtY0GkJDeCywdK0HIm52YLbfpCGIRbCcj++Gh8aSmb3gi80N2IGg
         fBPNN/geKmJwaNhOJqh4BSMv2Ljicn+Em3ZCNQ6VuEJ2peZNGMyQJ6CeZjPRHj0yX5vk
         ZLSfRWrt0TfS+FS1kxxvz2e4gqMTDB95nCVK0JFChqLTtgeEiDm1m4ySboWX+94ldNxa
         OJillTRci4KaMrIPznSCzvW7bVwBxr4qYbWXb34joKid8bxTUZEyDZS7CeCjk3eW4mhV
         8wVdmqx8SOczxCanNRqc1MyInrFtknOJ4q2M9It9klWSEaGwcXPI0PBTAPiScZ2ZTFKx
         e3sA==
X-Gm-Message-State: AOAM533R6TybHaGApDq6hvI+lekOSx2CJVmT8hdnGRYuMizLcjB5Kmbt
        Rvy5NAUe8sSkBMH4Qolqo9G/+Q==
X-Google-Smtp-Source: ABdhPJztxC5SloYTECJjkMsRvF+ShsNNhZmA75v6JRX/HbJXKVDT7MiEtBeZrvKKaM/GdXl/GO+XxQ==
X-Received: by 2002:a62:65c7:0:b029:278:e19f:f838 with SMTP id z190-20020a6265c70000b0290278e19ff838mr2848137pfb.64.1619465922089;
        Mon, 26 Apr 2021 12:38:42 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i18sm439912pfq.59.2021.04.26.12.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 12:38:41 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:38:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
Message-ID: <YIcWvcneHWA9OPxv@google.com>
References: <20210423223404.3860547-1-seanjc@google.com>
 <20210423223404.3860547-4-seanjc@google.com>
 <CAAeT=FxhkRhwysd4mQa=iqEaje7R5nHew8ougtoyDEhL2sYxGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxhkRhwysd4mQa=iqEaje7R5nHew8ougtoyDEhL2sYxGA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 24, 2021, Reiji Watanabe wrote:
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1610,6 +1610,29 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
> >                  * invokes 64-bit SYSENTER.
> >                  */
> >                 data = get_canonical(data, vcpu_virt_addr_bits(vcpu));
> > +               break;
> > +       case MSR_TSC_AUX:
> > +               if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> > +                       return 1;
> > +
> > +               if (!host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > +                       return 1;
> > +
> > +               /*
> > +                * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
> > +                * incomplete and conflicting architectural behavior.  Current
> > +                * AMD CPUs completely ignore bits 63:32, i.e. they aren't
> > +                * reserved and always read as zeros.  Enforce Intel's reserved
> > +                * bits check if and only if the guest CPU is Intel, and clear
> > +                * the bits in all other cases.  This ensures cross-vendor
> > +                * migration will provide consistent behavior for the guest.
> > +                */
> > +               if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
> > +                       return 1;
> > +
> > +               data = (u32)data;
> > +               break;
> >         }
> >
> >         msr.data = data;
> > @@ -1646,6 +1669,17 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
> >         if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
> >                 return KVM_MSR_RET_FILTERED;
> >
> > +       switch (index) {
> > +       case MSR_TSC_AUX:
> > +               if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> > +                       return 1;
> > +
> > +               if (!host_initiated &&
> > +                   !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > +                       return 1;
> 
> 
> It looks Table 2-2 of the Intel SDM Vol4 (April 2021) says
> TSC_AUX is supported:
> 
>    If CPUID.80000001H:EDX[27] = 1 or CPUID.(EAX=7,ECX=0):ECX[22] = 1
> 
> Should we also check X86_FEATURE_RDPID before returning 1
> due to no RDTSCP support ?

Yep.  VMX should also clear RDPID if the ENABLE_RDTSCP control isn't supported.
That bug isn't fatal because KVM emulates RDPID on #UD, but it would be a
notieable performance hit for the guest.

There is also a kernel bug lurking; vgetcpu_cpu_init() doesn't check
X86_FEATURE_RDPID and will fail to initialize MSR_TSC_AUX if RDPID is supported
but RDTSCP is not, and __getcpu() uses RDPID.  I'll verify that's broken and
send a patch for that one too.

> There doesn't seem to be a similar description in the APM though.

AMD also documents this in Appendix E:

  CPUID Fn0000_0007_EBX_x0 Structured Extended Feature Identifiers (ECX=0)
  Bits   Field   Name
  ...
  22     RDPID   RDPID instruction and TSC_AUX MSR support.


