Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1276C6C72E4
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjCWWRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjCWWRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:17:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047201E1DA
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:17:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x3-20020a62fb03000000b00622df3f5d0cso95454pfm.10
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TIiBp5BGNgFTIRnkHm2xY3d1SyVAPfDW94ZyxK04aC4=;
        b=ckajWlyMg++jM+H8gI52Unc8CjT3H8X+4PNZvTjyJNSuh1Emp0jmob87xU9DFaE12F
         GTgXIKFjKHM8NnvsDag2XVSLWucdAnCUwhFFKErqmYfc21QjdkKzwHYWljXOvcv5MAXs
         swHD/Ut1PwQJUbqJl8f2b1aKYTmxawpXa+2nMQ//gBBkdATc+ZSbwPPNHXfzput4uCJI
         mfp5lt0G5UJwxDoHPH+JJMYBfkmIqSDhRi/Egd4HFukhvv5EfGuZuAVO1k710D6DLb71
         1uy5bt9L30fiJGrdEr4MZNP3s4BrkKdpaTGE392tkSa/oMndDkKBHF7UTbU1zeXC2nix
         v1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIiBp5BGNgFTIRnkHm2xY3d1SyVAPfDW94ZyxK04aC4=;
        b=k6jT6mf6s4oVaVS5+vOCnDfPQYj05Ygnd2sARtpe2ZaTitauHnKyJtMbjSzuQvcOvy
         UgMPnB8SNZL7tsUjTKvInW2VaZHjsqZ1fQUpUEKqyUtCshGoY6o/x9qEqFKnGLD+b5CA
         Bko0JCjGE3zhwWuhbIXzpez7fEMXxUzyt2+p3ccOYGuR2lWaN4TFDT8Zng4l8rqpSL+s
         t9uvtuDx8oCVqm7TnMepMEC29WD6BNdN812P0aaKwb4Yg6HDn7aP7bgg5y69XLhVtRBj
         n8gToj9AUYStCOarciSq+tJPnyhXohmJZA6m2HdMjHy4PKMy/Qx+t/tyPCJTiE6V3MfU
         4WuA==
X-Gm-Message-State: AAQBX9fkTHQ3IeymDspM1lh2cNb2KNe1DO2NP9C5SOigAnfh00h97s4q
        /eUtwtftghcOCNQ8fgGs5o5ZR2PYh70=
X-Google-Smtp-Source: AKy350bVfRkMqMfjU/A868W81C1TxjgdzKx0787lHE5UD9xmdPOaCkB3jN5vH8vUKBRVGNQODCtlk7MMmkw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4920:0:b0:50b:cf00:7d2e with SMTP id
 w32-20020a634920000000b0050bcf007d2emr4779pga.11.1679609871543; Thu, 23 Mar
 2023 15:17:51 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:17:50 -0700
In-Reply-To: <20230323050753.rufixzrzt2sf3avv@desk>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com> <20230322011440.2195485-6-seanjc@google.com>
 <20230323050753.rufixzrzt2sf3avv@desk>
Message-ID: <ZBzQDv9gIHIhOP8Y@google.com>
Subject: Re: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough MSR_IA32_FLUSH_CMD
From:   Sean Christopherson <seanjc@google.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jim Mattson <jmattson@google.com>
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

On Wed, Mar 22, 2023, Pawan Gupta wrote:
> On Tue, Mar 21, 2023 at 06:14:39PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 85bb535fc321..b32edaf5a74b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -95,6 +95,7 @@ static const struct svm_direct_access_msrs {
> >  #endif
> >  	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
> >  	{ .index = MSR_IA32_PRED_CMD,			.always = false },
> > +	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
> >  	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
> >  	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
> >  	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> > @@ -4140,6 +4141,10 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
> >  				     !!guest_has_pred_cmd_msr(vcpu));
> >  
> > +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
> 
> Just curious, will this ever be true on AMD hardware? AFAIK,
> X86_FEATURE_FLUSH_L1D is Intel-defined CPU feature.

Don't know myself, but I assume/home there was actual motivation behind adding
support for AMD.
