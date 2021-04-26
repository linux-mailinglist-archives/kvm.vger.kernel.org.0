Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93C36B9E1
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240204AbhDZTTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240180AbhDZTTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:19:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9B1C061756
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:18:33 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y62so7029716pfg.4
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 12:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yGSzz776qWLo2L8utoHd+WLD41PUYluYds/uPI29vQw=;
        b=o/H1HCK/ZfoOKIEtqGWPlA0oHo2/6vw2ro8xx/AXD/+4Cnqz3vjteOTz+IfhfLx3uo
         jJ7a3UdX/bpHiq0nBjOrHYmiKWPPIGMwLie5Nh8LJLQQCqhNbhAsJN81NSsRNBb5n1Z9
         52tp4TzLL6COWifHuX/9JJWmg6EJfdo5uHecCz2fExyiUJi2GWCw/DoQeFYWm/loXKHs
         693qsxZCNn9BYYGVYv5ek6lkVwfHuafg7exP4xZIyQ55cY9zho6jXVCEJEdX9+1E3J3P
         pZvj0e2cB/Ltit1ITgH6/UO+qSXcEC5Y/EL2z3zJTUAq+kPZhq4dbI13SSf72+xEFbZc
         r1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yGSzz776qWLo2L8utoHd+WLD41PUYluYds/uPI29vQw=;
        b=uoNZ9MEVkSK9unjMA0nwb6xLezxgxPvoIjzWPJz5LzHaMcLQiRurCREbTSxOCFo5ym
         HN2wNOkC9XOOc2WW88ur7JcOOFbzoVrnXSzK21mpVs+AD/93IaZXKjK2oHGJkEKhAoPu
         SoLo+x3FYmLO3JTJqgla2msekNlxpYPXepJNNpK9hO6CV55nCARRbl2cRWCNGztEoGLW
         OKTJc0ZpSJlSfGRy0reoB2TX4wmARTd6UwOuLDHKGnWwYde9pC0i5lfzW0vxz54YacaW
         oIf4Z+B5vN29fvAuIjE/KQIV6+vn6RN8JFA5YJ7Yb12DABFypsdg+8iIq2dR7hq59rWT
         fdQQ==
X-Gm-Message-State: AOAM531V4nKOYSHBD1NfMfmq6NRFd0jyM7nKZeeEXBRmyHru6g3BKhPt
        uegZDD7pTgTFfW3cT89PveYlmg==
X-Google-Smtp-Source: ABdhPJyhcZeW/t/tbwc74eaq23ccXQlLId5i7WwKiC/xqPWf5Sg12EEt5qIDbSZQXF2007zRY87+uA==
X-Received: by 2002:a65:6643:: with SMTP id z3mr17853825pgv.387.1619464713143;
        Mon, 26 Apr 2021 12:18:33 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v123sm409175pfb.80.2021.04.26.12.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 12:18:32 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:18:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
Message-ID: <YIcSBIeLpqQ0sDF7@google.com>
References: <20210423223404.3860547-1-seanjc@google.com>
 <20210423223404.3860547-3-seanjc@google.com>
 <87k0opfmo9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0opfmo9.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Force clear bits 63:32 of MSR_TSC_AUX on write to emulate current AMD
> > CPUs, which completely ignore the upper 32 bits, including dropping them
> > on write.  Emulating AMD hardware will also allow migrating a vCPU from
> > AMD hardware to Intel hardware without requiring userspace to manually
> > clear the upper bits, which are reserved on Intel hardware.
> >
> > Presumably, MSR_TSC_AUX[63:32] are intended to be reserved on AMD, but
> > sadly the APM doesn't say _anything_ about those bits in the context of
> > MSR access.  The RDTSCP entry simply states that RCX contains bits 31:0
> > of the MSR, zero extended.  And even worse is that the RDPID description
> > implies that it can consume all 64 bits of the MSR:
> >
> >   RDPID reads the value of TSC_AUX MSR used by the RDTSCP instruction
> >   into the specified destination register. Normal operand size prefixes
> >   do not apply and the update is either 32 bit or 64 bit based on the
> >   current mode.
> >
> > Emulate current hardware behavior to give KVM the best odds of playing
> > nice with whatever the behavior of future AMD CPUs happens to be.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9ed9c7bd7cfd..71d704f8d569 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -2904,8 +2904,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> >  		 * direct_access_msrs.  Doing that would require a rdmsr in
> >  		 * svm_vcpu_put.
> >  		 */
> > -		svm->tsc_aux = data;
> >  		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
> 
> Hm, shouldn't this be 
> 
> wrmsrl(MSR_TSC_AUX, data) or wrmsrl(MSR_TSC_AUX, (u32)data)
> 
> then? As svm->tsc_aux wasn't updated yet.
> 
> > +
> > +		/*
> > +		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
> > +		 * incomplete and conflicting architectural behavior.  Current
> > +		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
> > +		 * reserved and always read as zeros.  Emulate AMD CPU behavior
> > +		 * to avoid explosions if the vCPU is migrated from an AMD host
> > +		 * to an Intel host.
> > +		 */
> > +		svm->tsc_aux = (u32)data;
> 
> Actually, shouldn't we just move wrmsrl() here? Assuming we're not sure
> how (and if) upper 32 bits are going to be used, it would probably make
> sense to not write them to the actual MSR...

Argh.  I got too clever in trying to minimize the patch deltas and "broke" this
intermediate patch.  Once the user return framework is used, the result of
setting the MSR is checked before setting svm->tsc_aux, i.e. don't set the
virtual state if the real state could not be set.

I'm very tempted to add yet another patch to this mess to do:

		if (wrmsrl_safe(MSR_TSC_AUX, data))
			return 1;

		svm->tsc_aux = data;

And then this patch becomes:

		data = (u32)data;

		if (wrmsrl_safe(MSR_TSC_AUX, data))
			return 1;

		svm->tsc_aux = data;

The above will also make patch 3 cleaner as it will preserve the ordering of
truncating data and the wrmsr.

> >  		break;
> >  	case MSR_IA32_DEBUGCTLMSR:
> >  		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
> 
> -- 
> Vitaly
> 
