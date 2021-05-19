Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C832E3892CD
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 17:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354912AbhESPlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 11:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354902AbhESPlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 11:41:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB14C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 08:40:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so3715067pjb.3
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 08:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5bEuxX2X8bBUVqC8o4ZD8af+cxfwPYrie2CqQyfE1eg=;
        b=qRETapL+guGrCRWWx8ib5azlaovGzEPYrmFu8ScRF6zwzGS2UvHzB6A+78Bc9WOqMk
         5PZf+y5DdzbsF/6aJ/EnoKVI6P2fSFypZV5Xj7ldUSA0YCNHcEetvdfVjjqNWvfvjzcU
         i7gUDbjdg0HsEzBNE1LDFaPyh7c8IAxpusJdwH3WzvMtO5e5hsuPayfq510JlllOKjnJ
         9mrnsIS0LICp0CZjeJdV1RK9lB4sfHFNUumZvRFT1i2nJE81MyPL63u1EibjDpXpz2CY
         r4h6cJYviHXpX83OC9OGoyszfc/cwRtDFdQ1gOd376N6Dsfhr22asd2BvpA9lwG2kq70
         XmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5bEuxX2X8bBUVqC8o4ZD8af+cxfwPYrie2CqQyfE1eg=;
        b=IVStLILfT+XQ7u13llRwfwZ+bHiBBTVufsjHadyx3qfJpeaeQaA6WEre4QSpS5phiG
         EMWugKVgAXktSUGuW11PE5BM4cLLBiuHmj+Nq14dTs6iCzDD0sm58GDiPLfmN5SjIwdx
         8DsCEPe2LlpOCtR7vesL5InBUBu09Fz7BQ7zjRsDwjBUYbt6ybMuef1s0Yg+ZrNHwFES
         rOWsPfbbJP62RlU7e+Uphqxjy1Wrr8UmE2fiO//xyfUYb+w8DzT3QV4HNe88bWMKRSnT
         ZAwfgDGfEDN8MeCA/7XC7URE58KWGllJaDGFGZyKBZLBHhdrHR/6uI9n3a+wTmywWlzj
         cTDw==
X-Gm-Message-State: AOAM532qjQHmRbTmelefiBgtG8gjBb5gyaChNUANoDCUd/DN06PzxxTe
        eNfKK4YZMPwz6cHf9XLg55ZdQg==
X-Google-Smtp-Source: ABdhPJxhN0z+Kc4wpNsbbohN9nkWE0iRXUWhsGpnxbGaJuuoAihs6TJvhqtMh2V9Dpv4p6HEvC9WRA==
X-Received: by 2002:a17:90a:a386:: with SMTP id x6mr12059847pjp.193.1621438814276;
        Wed, 19 May 2021 08:40:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u19sm8076836pfn.158.2021.05.19.08.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 08:40:13 -0700 (PDT)
Date:   Wed, 19 May 2021 15:40:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v2 03/10] KVM: X86: Add kvm_scale_tsc_l1() and
 kvm_compute_tsc_offset_l1()
Message-ID: <YKUxWh1Blu7rLZR9@google.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
 <20210512150945.4591-4-ilstam@amazon.com>
 <YKRH7qVHpow6kwi5@google.com>
 <772e232c27d180f876a5b49d7f188c0c3acd7560.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <772e232c27d180f876a5b49d7f188c0c3acd7560.camel@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Stamatis, Ilias wrote:
> On Tue, 2021-05-18 at 23:04 +0000, Sean Christopherson wrote:
> > On Wed, May 12, 2021, Ilias Stamatis wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 07cf5d7ece38..84af1af7a2cc 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2319,18 +2319,30 @@ u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_scale_tsc);
> > > 
> > > -static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
> > > +u64 kvm_scale_tsc_l1(struct kvm_vcpu *vcpu, u64 tsc)
> > > +{
> > > +     u64 _tsc = tsc;
> > > +     u64 ratio = vcpu->arch.l1_tsc_scaling_ratio;
> > > +
> > > +     if (ratio != kvm_default_tsc_scaling_ratio)
> > > +             _tsc = __scale_tsc(ratio, tsc);
> > > +
> > > +     return _tsc;
> > > +}
> > 
> > Just make the ratio a param.  This is complete copy+paste of kvm_scale_tsc(),
> > with 3 characters added.  And all of the callers are already in an L1-specific
> > function or have L1 vs. L2 awareness.  IMO, that makes the code less magical, too,
> > as I don't have to dive into a helper to see that it reads l1_tsc_scaling_ratio
> > versus tsc_scaling_ratio.
> > 
> 
> That's how I did it initially but changed it into a separate function after
> receiving feedback on v1. I'm neutral, I don't mind changing it back.

Ah, I see the conundrum.  The vendor code isn't straightforward because of all
the enabling checks against vmcs12 controls.

Given that, I don't terribly mind the callbacks, but I do think the connection
between the computation and the VMWRITE needs to be more explicit.

Poking around the code, the other thing that would help would be to get rid of
the awful decache_tsc_multiplier().  That helper was added to paper over the
completely broken logic of commit ff2c3a180377 ("KVM: VMX: Setup TSC scaling
ratio when a vcpu is loaded").  Its use in vmx_vcpu_load_vmcs() is basically
"write the VMCS if we forgot to earlier", which is all kinds of wrong.

If we get rid of that stupidity as prep work at the beginning of this series,
and have the "setters" return the computed value, the nested VMX code can
consume the value directly instead of having the subtle dependency on the helpers.

	vmcs_write64(TSC_OFFSET, kvm_calc_l2_tsc_offset(vcpu));

	if (kvm_has_tsc_control)
		vmcs_write64(TSC_MULTIPLIER, kvm_calc_l2_tsc_multiplier(vcpu));


Side topic, the checks against the vmcs12 controls are wrong.  Specifically,
when checking a secondary execution control, KVM needs to first check that the
secondary control is enabled in the primary control.  But, we helpers for that.
The primary control should use its helper, too.  And while you're at it, drop
the local variable in the getter.  I.e.:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3c4eb14a1e86..8735f2d71e17 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1801,13 +1801,12 @@ static u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
 static u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 {
        struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-       u64 multiplier = kvm_default_tsc_scaling_ratio;

-       if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING &&
-           vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
-               multiplier = vmcs12->tsc_multiplier;
+       if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING) &&
+           nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
+               return vmcs12->tsc_multiplier;

-       return multiplier;
+       return kvm_default_tsc_scaling_ratio;
 }

Side topic #2: I now see why the x86.c helpers skip the math if the multiplier
is kvm_default_tsc_scaling_ratio.
