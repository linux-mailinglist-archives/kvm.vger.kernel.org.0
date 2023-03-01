Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FAB6A644A
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCAAfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCAAfR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:35:17 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5BD1C7E2;
        Tue, 28 Feb 2023 16:35:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 16so6750921pge.11;
        Tue, 28 Feb 2023 16:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677630915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=12E6WZ1uQDuJF7O0sKfjo9/zPymvgvIz70T1IzK3hvY=;
        b=cyT4RvGaTlk8dkfZrW6STBZKdA/2YEzPpcySK8S0mshrIbyTdfUxnPrL2eAQd9A6yq
         dJkb843E/YWqlpKCB5Hx9/00OqgaPtXRJovrgj3lUx/OtqoCWDlDmCjahzN92gA/YNR5
         Id0rvCVZ0tWn8A1sAZ+E8wnBFKQhPsixUhV9wDQs/kc/Wp2DwEPSwMzYofc9VKRFGF0c
         mcqgmrxNNcGmvzJfckU9oeWS1TutfBJHwD7GK/fTIKFKFR4LTcUrtdecr3q+4jX/Nh2c
         FQyGBGEQocrd9xQ1B2pPDD1gomcdZW5qbVsySy+CM4Uq9VysEj1DfIfnuOK1OJ0PAInC
         +BjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677630915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12E6WZ1uQDuJF7O0sKfjo9/zPymvgvIz70T1IzK3hvY=;
        b=MWV9UBg3tf4BD2qupxR+rcczusQNphGjelitMh6QssbNYeO6ASdLcE6/Em9ds4eMUM
         jzkSH749wdPATfD3kh7Ehwt9lKRe37/lt24ReU7Ac8se+uJbY3P7Tua6DHErO7Op1mcw
         wguEZcvkS/ep9j6IiEbt3dZtxv29xBsfZycZ6Ozs4jl8ijWmt1RM2wBQ+4wKaxyd/5aa
         gPfyIqWPnfP45/BEgIqNy928VF6MWKCxHeSE0N7/PZf1KDKiX4bg4oVn4Oky0uOsTbQx
         vayBp3eaAiHJHnpbICEUfRa347EiQfTV7j1abj43KCQGUZs+hZkjrhM3wAhWHbD/hrZ7
         abHQ==
X-Gm-Message-State: AO0yUKUJ3A1Q9xSvPo0hR7gjjWFfK32sMhYbbZDbK9oYtWTcSfY6RU3X
        R62nOCasOyrBErMIFd2Zh80=
X-Google-Smtp-Source: AK7set8hEEamSF1f4n0e5mk2+3b5zDaVAPLCQ7IBQ1IXXc1mjwoSxbhvCwjj91/aYFTpYsdyGkNXEQ==
X-Received: by 2002:aa7:952f:0:b0:5dc:6a64:6704 with SMTP id c15-20020aa7952f000000b005dc6a646704mr3820679pfp.7.1677630915114;
        Tue, 28 Feb 2023 16:35:15 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id l12-20020a62be0c000000b005821c109cebsm6586000pff.199.2023.02.28.16.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 16:35:14 -0800 (PST)
Date:   Tue, 28 Feb 2023 16:35:12 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 023/113] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <20230301003512.GA3852341@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <db53b2c6c7718df7df89bb36b83257a2588b58e1.1673539699.git.isaku.yamahata@intel.com>
 <76cd219cadf3f5e06eb10b592de121ed0db056eb.camel@intel.com>
 <20230228110632.GV4175971@ls.amr.corp.intel.com>
 <7dd3b2a9406bdfd574ae12f0f4651e3fe6c4b82a.camel@intel.com>
 <20230228201858.GY4175971@ls.amr.corp.intel.com>
 <a455c53dc1cdf81790f2996056cdd13cff482d9b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a455c53dc1cdf81790f2996056cdd13cff482d9b.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 09:49:10PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2023-02-28 at 12:18 -0800, Isaku Yamahata wrote:
> > On Tue, Feb 28, 2023 at 11:52:59AM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On Tue, 2023-02-28 at 03:06 -0800, Isaku Yamahata wrote:
> > > > > > +	if (!e)
> > > > > > +		return -ENOMEM;
> > > > > > +	*e  = (struct kvm_cpuid_entry2) {
> > > > > > +		.function = 1,	/* Features for X2APIC */
> > > > > > +		.index = 0,
> > > > > > +		.eax = 0,
> > > > > > +		.ebx = 0,
> > > > > > +		.ecx = 1ULL << 21,	/* X2APIC */
> > > > > > +		.edx = 0,
> > > > > > +	};
> > > > > > +	vcpu->arch.cpuid_entries = e;
> > > > > > +	vcpu->arch.cpuid_nent = 1;
> > > > > 
> > > > > As mentioned above, why doing it here? Won't be this be overwritten later in
> > > > > KVM_SET_CPUID2?
> > > > 
> > > > Yes, user space VMM can overwrite cpuid[0x1] and APIC base MSR.  But it
> > > > doesn't
> > > > matter because it's a bug of user space VMM. user space VMM has to keep the
> > > > consistency of cpuid and MSRs.
> > > > Because TDX module virtualizes cpuid[0x1].x2apic to fixed 1, KVM value doesn't
> > > > matter after vcpu creation.
> > > > Because KVM virtualizes APIC base as read only to guest, cpuid[0x1].x2apic
> > > > doesn't matter after vcpu creation as long as user space VMM keeps KVM APIC
> > > > BASE
> > > > value.
> > > > 
> > > 
> > > Contrary, can we depend on userspace VMM to set x2APIC in CPUID, but not do this
> > > in KVM?  If userspace doesn't do it, we treat it as userspace's bug.
> > > 
> > > Plus, userspace anyway needs to set x2APIC in CPUID regardless whether you have
> > > done above here, correct?
> > > 
> > > I don't see the point of doing above in KVM because you are neither enforcing
> > > anything in KVM, nor you are reducing effort of userspace.
> > 
> > Good idea. I can drop cpuid part from tdx_vcpu_create() and apic base part from
> > tdx_vcpu_reset(). It needs to modify tdx_has_emulated_msr() to allow user space
> > VMM to update APIC BASE MSR.
> 
> My personal preference would be:
> 
> 1) In KVM_SET_CPUID2, we do sanity check of CPUIDs provided by userspace, and
> return error if not met (i.e X2APIC isn't advertised).  We already have cases
> that KVM_SET_CPUID2 can fail, so extending to do TDX-specific check seems
> reasonable to me too.

This is moot. The current check does only check maxphys address bit size and
specified xfeatures are supported by host.  It's bare minimum for kvm to work.
It doesn't try to check consistency.


> 2) For APIC_BASE, you can just initialize the MSR in tdx_vcpu_reset() and ignore
> any update (+pr_warn()?) to MSR_IA32_APIC_BASE.

The x86 common code for KVM_CREATE_VCPU, kvm_arch_vcpu_create(), calls vcpu_create,
creates lapic, and calls vcpu_reset(). 

Setting ACPI BASE MSR with X2APIC enabled, checks if cpuid x2apic bit is set.
Please notice guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) in kvm_set_apic_base().
To work around it, one way is set cpuid artificially in create method as this
patch does.  Other way would be to introduce another version of
kvm_set_apic_base() that doesn't check cpuid dedicated for this purpose.
The third option is to make it user space responsibility to set initial reset
value of APIC BASE MSR.

Which option do you prefer?

Thanks,

> 
> 
> But Sean may have different opinion especially for the CPUID part.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
