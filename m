Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5156176B9D4
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjHAQmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 12:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbjHAQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 12:42:12 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22F21FEF
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 09:42:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5847479b559so67946157b3.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 09:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690908131; x=1691512931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XUkAY/G/q5Go/69C7MwOXOdE9yrJPl7PpisITyFDd7Q=;
        b=vhto38kKYsPdVVOHWc+ZBPW7FpOxrmqsDyRdd3iekHwbpqM9jTuedcsQ7ppkaW0Bew
         gYdHqHY6dJZoezPC+mh3LkCz1BhVpz+Ct22mtdbox/cKulplQa4IIgw9T1YuFviXb+8U
         DN8g+TN5+ZHMPyLWjX9oOzt5zpHDPlVlRuQ2AiFo9r3qONUfOdrs4sunTJmXNoA5aZls
         OkmULIY/eeT1Kww64TRQ5hNx2xAF98wnIk8C6/esTS3gpa3VHja5piqdyorRpoKSktwz
         GGyhuBG3UZwwZBp8uFJSnUccnV5IHAndTwFexDWkad/u+xmG4K7nr+4MfHJMYq1DibSG
         JW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690908131; x=1691512931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUkAY/G/q5Go/69C7MwOXOdE9yrJPl7PpisITyFDd7Q=;
        b=gEzV2I8dmXo4Xp5PX9iDZjpfol2ZByFodCAnlU2fhEXGEuZSg/7EEKhGGG0cyk27t+
         sp3NuSk/K1gr2CleIRAentLgA+7HYDeSY75F821j4EuZKEfU0zF9wj6jbwqw3zFARZ9N
         K90n7WTsPpSwRXDMMhitQL0VqTonwewf/32p03Kst+e4UGsT/t3cNTsawajn0L2DI0PI
         QImEg7W4OMDJrnE+Ia/FQOwOWii+MRj35MtH8it+dey/TR9NIvy+hZVZrNUKvyFA+F1O
         p+SgqBizk/HS/c2jfsvrMQDvXabivhIF2bzTJD9MwK5I4U+/nFY5bBTDdyOHdF5XzFGk
         xl7Q==
X-Gm-Message-State: ABy/qLak/Y68wfXRBPFlEzbj5qbjPHWFcH+cXUT0IZF5d2+nIv/Fie/K
        ZlJ9ia57WlbG+2MdzXYR/mWYNp00dgs=
X-Google-Smtp-Source: APBJJlFnVpRXHxBMAAzeylgAR/wCk5R6kUAg+WwTz3hroE3BN30v08zKPdv7SyECwdp4asKLZEgPjNk/wi4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:258d:0:b0:d0a:324c:2c67 with SMTP id
 l135-20020a25258d000000b00d0a324c2c67mr81296ybl.13.1690908131108; Tue, 01 Aug
 2023 09:42:11 -0700 (PDT)
Date:   Tue, 1 Aug 2023 09:42:09 -0700
In-Reply-To: <ZMkj/HORmSy685cH@johallen-workstation>
Mime-Version: 1.0
References: <20230524155339.415820-1-john.allen@amd.com> <20230524155339.415820-4-john.allen@amd.com>
 <ZJYzPn7ipYfO0fLZ@google.com> <ZMkj/HORmSy685cH@johallen-workstation>
Message-ID: <ZMk14YiPw9l7ZTXP@google.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: x86: SVM: Pass through shadow stack MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org,
        thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023, John Allen wrote:
> On Fri, Jun 23, 2023 at 05:05:18PM -0700, Sean Christopherson wrote:
> > On Wed, May 24, 2023, John Allen wrote:
> > > If kvm supports shadow stack, pass through shadow stack MSRs to improve
> > > guest performance.
> > > 
> > > Signed-off-by: John Allen <john.allen@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
> > >  arch/x86/kvm/svm/svm.h |  2 +-
> > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 6df486bb1ac4..cdbce20989b8 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -136,6 +136,13 @@ static const struct svm_direct_access_msrs {
> > >  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> > >  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> > >  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> > > +	{ .index = MSR_IA32_U_CET,                      .always = false },
> > > +	{ .index = MSR_IA32_S_CET,                      .always = false },
> > > +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> > > +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> > > +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> > > +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> > > +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> > >  	{ .index = MSR_INVALID,				.always = false },
> > >  };
> > >  
> > > @@ -1181,6 +1188,16 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
> > >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> > >  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> > >  	}
> > > +
> > > +	if (kvm_cet_user_supported() && guest_cpuid_has(vcpu, X86_FEATURE_SHSTK)) {
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP, 1, 1);
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP, 1, 1);
> > > +	}
> > 
> > This is wrong, KVM needs to set/clear interception based on SHSKT, i.e. it can't
> > be a one-way street.  Userspace *probably* won't toggle SHSTK in guest CPUID, but
> > weirder things have happened.
> 
> Can you clarify what you mean by that? Do you mean that we need to check
> both guest_cpuid_has and kvm_cpu_cap_has like the guest_can_use function
> that is used in Weijiang Yang's series? Or is there something else I'm
> omitting here?

When init_vmcb_after_set_cpuid() is called, KVM must not assume that the MSRs are
currently intercepted, i.e. KVM can't just handle the case where userspace enables
SHSTK, KVM must also handle the case where userspace disables SHSTK.

Using guest_can_use() is also a good idea, but it would likely lead to extra work
on CPUs that don't support CET/SHSTK.  This isn't a fastpath, but toggling
interception for MSRs that don't exist would be odd.  It's probably better to
effectively open code guest_can_use(), which the KVM check gating the MSR toggling.

E.g. something like

	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
		bool shstk_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

		set_msr_inteception(vcpu, svm->msrpm, MSR_IA32_BLAH,
				    shstk_enabled, shstk_enabled);
	}
