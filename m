Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0249059A41A
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354771AbiHSRne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 13:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353077AbiHSRnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 13:43:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089A0133B85
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:02:45 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r69so4156250pgr.2
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 10:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=RHK5G9JAHhgGCkTg4CkDfYb1xqntg9knbs5lZi1RIbo=;
        b=eMWi9bQ3cPenIuHSE1JOvmJB1dVh9t7Cp2IJZLR8XpIFrkabsBA8LbFNcDtuMHKGYk
         lO7RbJFzqoDBs8EjujmnOcJLHZooX1hawuVMA0ma5VUzEKGcpOXnOLS2CFUw/oVsO866
         0U4urqsAvRT98P0gP48YbFe9EjKkLcaYDUAWnRX3saxFTQj2ISyRC9CepELsXY6jT3Hh
         /m0YC3rHZ9ky4EwtbhCtLhtDgckjSwQPxdm3Jtsw1cZD3VWrOfQyewqtdSQZbGRZDNBH
         MtELkwWWbG0wjmDUT2Z7RpO5lj/fJ9WfntfjsrQnMmBL0x9OGKnU7886JMJzb5PGqGyj
         Nubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=RHK5G9JAHhgGCkTg4CkDfYb1xqntg9knbs5lZi1RIbo=;
        b=b1YgI3LgNfjd/Dc4EdjyxV3pPpsPx3P2mMXlsOG4U69j7jbV7EfvSHLI/PfXNyyDiB
         T48vVorsqUBPTpScS8sB0nXS9XCXukVfWmTR5K3k1aZjd3uUm/k2WQtKsM+2L2PKiKAJ
         xkZVdOtkWZns+ApCtz0m8jpsZQKzh+/Y9bqvJKy5hhGANrAnVe2rLkjBtRnFQi8rRfgz
         myHYpyNC7ap9KiYoJ7kDsghDtB5rixQ6+W3DMhJ5rrGv0a67m5+HFXO0i/jyjvOy/RnC
         fu8ThV4oksCSu9dA1hBHNLSFXUkMi3BNBoR38gNjMqw/IWV9puT7qbdJfFV0XlrqN3pP
         Id8g==
X-Gm-Message-State: ACgBeo0NAX2lLRiR6t45Ya4qziB7gcBbdNIKlNbjiSr1hbBbyE8Be1Eg
        GEBj7qk+KREkTherUP9t+dz5bNy5Y3T0mw==
X-Google-Smtp-Source: AA6agR5G2Yn1si0Ny8aEgUM18mGUOU921TVyadVX4vrrgP4oahkPCcwlt/K0QNMZO1CXlnVbKd1jxQ==
X-Received: by 2002:a05:6a00:13a2:b0:52e:128a:23dd with SMTP id t34-20020a056a0013a200b0052e128a23ddmr8879857pfg.54.1660928564333;
        Fri, 19 Aug 2022 10:02:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x1-20020aa79ac1000000b00535d3caa66fsm3469048pfp.197.2022.08.19.10.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 10:02:43 -0700 (PDT)
Date:   Fri, 19 Aug 2022 17:02:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and
 PERF_GLOBAL_CTRL with enlightened VMCS
Message-ID: <Yv/CME8B1ueOMY5M@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-10-vkuznets@redhat.com>
 <Yv5zn4qTl0aiaQvh@google.com>
 <87sflssllu.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sflssllu.fsf@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> >> +static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
> >> +				      enum evmcs_unsupported_ctrl_type ctrl_type)
> >> +{
> >> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> >> +	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
> >> +
> >> +	if (!hv_vcpu)
> >
> > This is a functiontal change, and I don't think it's correct either.  Previously,
> > KVM would apply the EVMCSv1_2016 filter irrespective of whether or not
> > vcpu->arch.hyperv is non-NULL.  nested_enable_evmcs() doesn't require a Hyper-V
> > vCPU, and AFAICT nothing requires a Hyper-V vCPU to use eVMCS.
> 
> Indeed, this *is* correct after PATCH11 when we get rid of VMX feature
> MSR filtering for KVM-on-Hyper-V as the remaining use for
> evmcs_get_unsupported_ctls() is Hyper-V on KVM and hv_vcpu is not NULL
> there.

Hmm, nested_vmx_handle_enlightened_vmptrld() will fail without a Hyper-V vCPU, so
filtering eVMCS control iff there's a Hyper-V vCPU makes sense.  But that's a guest
visible change and should be a separate patch.

But that also raises the question of whether or not KVM should honor hyperv_enabled
when filtering MSRs.  Same question for nested VM-Enter.  nested_enlightened_vmentry()
will "fail" without an assist page, and the guest can't set the assist page without
hyperv_enabled==true, but nothing prevents the host from stuffing the assist page.

And on a very related topic, the handling of kvm_hv_vcpu_init() in kvm_hv_set_cpuid()
is buggy.  KVM will not report an error to userspace for KVM_SET_CPUID2 if allocation
fails.  If a later operation successfully create a Hyper-V vCPU, KVM will chug along
with Hyper-V enabled but without having cached the relevant Hyper-V CPUID info.

Less important is that kvm_hv_set_cpuid() should also zero out the CPUID cache if
Hyper-V is disabled.  I'm pretty sure sure all paths check hyperv_enabled before
consuming cpuid_cache, but it's unnecessarily risky.

If we fix the kvm_hv_set_cpuid() allocation failure, then we can also guarantee
that vcpu->arch.hyperv is non-NULL if vcpu->arch.hyperv_enabled==true.  And then
we can add gate guest eVMCS flow on hyperv_enabled, and evmcs_get_unsupported_ctls()
can then WARN if hv_vcpu is NULL.

Assuming I'm not overlooking something, I'll fold in yet more patches.
