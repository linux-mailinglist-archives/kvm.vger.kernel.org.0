Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3BB6D8CE4
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 03:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbjDFBoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 21:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjDFBoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 21:44:19 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4438E2710
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 18:44:18 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l11-20020a170902d34b00b001a4ee9558fcso629909plk.8
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 18:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680745458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTPfjpgA3erDSbYpkgBCYkjxSYD+XUjNQEHsXiG0Ado=;
        b=rjiwYtQc2XVnUnURMfXmp10Rdjx/q7NfkW0lnKOJ1N5Qe3Xd2XxkuQocScnAS5/68M
         Ku32PCSyX3qyIYxlMTYvmHvv1hg7VTNCctGhJz5QaHxoUqEOMh6+LvmqsPBAt9paXQ8k
         jLI8Lp+MAYdvSupKLWamScXEqgLcsvyXj5o3psl5e0BaQPiASxdXh6SM++IQlZPh8Oc2
         49VlUH1KZ4qrKq/ZYLTZDB9xJ/mnZI2An1JFeATGJFJBmgrE7U7gkFMH8aBy5bLaHyO5
         qUMZAi+BgY+WSvKI+gMEcRyJLfsQLbCDz460GxFQe3NiEi0MYN3UZ9zMKkxxWLE8ABYt
         Snyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680745458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTPfjpgA3erDSbYpkgBCYkjxSYD+XUjNQEHsXiG0Ado=;
        b=fmwlD2RJRaWK4xzTuU2xwCQb8v2QdKfXPsC3cHOix32b4by1pyLbeUVXU39zoyo8Te
         x2OKZ8wKrQIe7a0yjMC797Db+O7Y+oxSn74KTWLUXOKP2w9zifiq1eK8Q0pu9mBDVCT7
         nUCdUlAMV8Ob2qy2JpgFVPIkQGOnSOiIuWzXSEVBHGjS68I6oZYfAWCAh+mUjtO6ksBA
         HJ9YJCELv9SOJSvRSnv4tBvEtd/v1hTBci3TZNLGDxPOdlOhQ7p8uAuG7om9o/nfuPwu
         nx9TCw4n+QXINi6wJrzM74K8Fh3OZMiOSKvl7pgKWY9LZLrB1oZQzP7kSUkBAicMz+IJ
         IoXA==
X-Gm-Message-State: AAQBX9etVvt4K0Q5BBY9Rgmn6+f64WHdb1ToRXM46iPnx0c3cLEdx2X+
        hL51EzASc/ax+UBY4zV0S+3BjoUj3TU=
X-Google-Smtp-Source: AKy350bLceE6E4UW5DCYCj4bMZDaoNcGo6GuS54kTIy2ncNEOSGqQw7f/KhyJ4331C3TYXU1F/+fIsEfymY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1483:b0:625:f78a:56f with SMTP id
 v3-20020a056a00148300b00625f78a056fmr2704007pfu.3.1680745457753; Wed, 05 Apr
 2023 18:44:17 -0700 (PDT)
Date:   Wed, 5 Apr 2023 18:44:16 -0700
In-Reply-To: <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com> <20230405005911.423699-2-seanjc@google.com>
 <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
Message-ID: <ZC4j37H2+2945xxb@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023, Huang, Kai wrote:
> On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > Explicitly check the vCPU's supported XCR0 when determining whether or not
> > the XFRM for ECREATE is valid.  Checking CPUID works because KVM updates
> > guest CPUID.0x12.1 to restrict the leaf to a subset of the guest's allowed
> > XCR0, but that is rather subtle and KVM should not modify guest CPUID
> > except for modeling true runtime behavior (allowed XFRM is most definitely
> > not "runtime" behavior).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/sgx.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> > index aa53c98034bf..362a31b19b0e 100644
> > --- a/arch/x86/kvm/vmx/sgx.c
> > +++ b/arch/x86/kvm/vmx/sgx.c
> > @@ -175,7 +175,8 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
> >  	    (u32)attributes & ~sgx_12_1->eax ||
> >  	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> >  	    (u32)xfrm & ~sgx_12_1->ecx ||
> > -	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > +	    (u32)(xfrm >> 32) & ~sgx_12_1->edx ||
> > +	    xfrm & ~vcpu->arch.guest_supported_xcr0) {
> 
> Perhaps this change is needed even without patch 2?
> 
> This is because when CPUID 0xD doesn't exist, guest_supported_xcr0 is 0.  But
> when CPUID 0xD doesn't exist, IIUC currently KVM doesn't clear SGX in CPUID, and
> sgx_12_1->ecx is always set to 0x3.

Hrm, that's a bug in this patch.  Drat.  More below.

> __handle_encls_ereate() doesn't check CPUID 0xD either, so w/o above explicit
> check xfrm against guest_supported_xcr0, it seems guest can successfully run
> ECREATE when it doesn't have CPUID 0xD?

ECREATE doesn't have a strict dependency on CPUID 0xD or XSAVE.  This exact scenario
is called out in the SDM:

  Legal values for SECS.ATTRIBUTES.XFRM conform to these requirements:
    * XFRM[1:0] must be set to 0x3.
    * If the processor does support XSAVE, XFRM must contain a value that would
      be legal if loaded into XCR0.
    * If the processor does not support XSAVE, or if the system software has not
      enabled XSAVE, then XFRM[63:2] must be zero.

So the above needs to be either

	xfrm & ~(vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE)

or

	(xfrm & ~XFEATURE_MASK_FPSSE & ~vcpu->arch.guest_supported_xcr0)


I think I prefer the first one as I find it slightly more obvious that FP+SSE are
allowed in addition to the XCR0 bits.
