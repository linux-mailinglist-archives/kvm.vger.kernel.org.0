Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51FB5F7246
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 02:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiJGAfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 20:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJGAfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 20:35:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C43F89ADE
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 17:35:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so3279268pjf.5
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 17:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/nUtPNH9cAmS3UynohvEaec3ujUc8/ZWwuBU0SxLEA=;
        b=M96dR0N5/xd8/QXRwKXf8wosG16h3YYjyNMWQzw4xSKT1aH71Gccv65hU2Lj9L4YX2
         apTslenYaTFSF2zSS4mfX/UuZjB0Dqg/NhlbL+3rk7ruG3sz4n2pKBptDvd32XjwXzDW
         UCTWLNPXlHX0GZaQ3CTrnvbLMAGmMtTBPSAzq+Tb8ofbLh4r6nGi+Qg6gxCp7FeASgny
         EFQRVR/rLM6Cq++HfBA7/SR5p2O/yEcKd/uaqtbYy2u+3/67+74IwVaL2x1aR7u1P2v9
         R4wtkfLBPfCG3+Dm+LIIStdS1ZyHwxAmDbO9hMEkOP01syAA5RsLpmPp9Z4HCX3Wcy48
         cJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/nUtPNH9cAmS3UynohvEaec3ujUc8/ZWwuBU0SxLEA=;
        b=wOV8UMuqJpczq9c3iYERgzZ/KiKMhL0FZ9zs/1377wKk30B8aHC7kUUDj9QzMOaEhy
         eXWAG6bwZM/JGb0dgbSqEu9ejV8rk2jgBfETPwbHBmyu4rdW3vp00AQAj3ok9z47hqNP
         Lb8YPxnuydBN00BapI0wy9T5/qkYW9Wz8+3dx5QguqITSW/IvGnyACXlfHCd9r8CezsL
         Hg1mQjNcKukQ+BTbCabN/kl6ShXk14asp9lNtb2qIAQbeG3YdAKVpEHiEee6uY5dY2ZY
         F+3Q/ZpFuc2bJVLzlmvbiz2OOBvFeN2AMoMnW4DXHrBeiNp31HmAUDiVBrHIRLnEgOCA
         Z+DQ==
X-Gm-Message-State: ACrzQf11ZaaoIlkZX0vm1cP0PTosBmQ4PEiE6ApsG5UzI8YgGZk6gIB7
        spzEeqhNIEAnKKpBy4jfgNFfIPcK4BWOrg==
X-Google-Smtp-Source: AMsMyM7b1e2x4zgxMgpk2Ex0v5IM2paRPvDMLPCCoVcJMDY2zuLMOOcF8mwqLX+HaZ0o2ivERqHe1Q==
X-Received: by 2002:a17:903:246:b0:179:96b5:1ad2 with SMTP id j6-20020a170903024600b0017996b51ad2mr2357980plh.37.1665102918538;
        Thu, 06 Oct 2022 17:35:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a17-20020aa794b1000000b00553d5920a29sm226544pfl.101.2022.10.06.17.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 17:35:17 -0700 (PDT)
Date:   Fri, 7 Oct 2022 00:35:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when
 guest has IBRS
Message-ID: <Yz90B/mdrOLO2nyl@google.com>
References: <20220928235351.1668844-1-jmattson@google.com>
 <20220928235351.1668844-2-jmattson@google.com>
 <CALMp9eRRgw=SBMTY=LtBG6zPRt4Swk_0kW4NdeTS=zVeV+UbQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRRgw=SBMTY=LtBG6zPRt4Swk_0kW4NdeTS=zVeV+UbQg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022, Jim Mattson wrote:
> On Wed, Sep 28, 2022 at 4:53 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > According to Intel's document on Indirect Branch Restricted
> > Speculation, "Enabling IBRS does not prevent software from controlling
> > the predicted targets of indirect branches of unrelated software
> > executed later at the same predictor mode (for example, between two
> > different user applications, or two different virtual machines). Such
> > isolation can be ensured through use of the Indirect Branch Predictor
> > Barrier (IBPB) command." This applies to both basic and enhanced IBRS.
> >
> > Since L1 and L2 VMs share hardware predictor modes (guest-user and
> > guest-kernel), hardware IBRS is not sufficient to virtualize
> > IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
> > hardware IBRS is actually sufficient in practice, even though it isn't
> > sufficient architecturally.)
> >
> > For virtual CPUs that support IBRS, add an indirect branch prediction
> > barrier on emulated VM-exit, to ensure that the predicted targets of
> > indirect branches executed in L1 cannot be controlled by software that
> > was executed in L2.
> >
> > Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
> > perform the IBPB at emulated VM-exit regardless of the current
> > IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
> > deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
> > clear at emulated VM-exit.
> >
> > This is CVE-2022-2196.
> >
> > Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jim Mattson <jmattson@google.com>

Code looks good, just some whining about the comments.

> > ---
> >  arch/x86/kvm/vmx/nested.c | 8 ++++++++
> >  arch/x86/kvm/vmx/vmx.c    | 8 +++++---
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index ddd4367d4826..87993951fe47 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -4604,6 +4604,14 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> >
> >         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> >
> > +       /*
> > +        * For virtual IBRS,

The "virtual" part confused me (even more so than usual for all this mitigation
stuff).  At first I thought "virtual" was referring to some specialized hardware.

> we have to flush the indirect branch

Avoid pronouns please.  

> > +        * predictors, since L1 and L2 share hardware predictor
> > +        * modes.

Wrap at 80 chars, this easily fits on two lines.  Though I'd prefer to make this
comment much longer, I have a terrible time keeping track of this stuff (obviously).

Is this accurate?

	/*
	 * If IBRS is advertised to the guest, KVM must flush the indirect
	 * branch predictors when transitioning from L2 to L1, as L1 expects
	 * hardware (KVM in this case) to provide separate predictor modes.
	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
	 * doesn't isolate different VMs, i.e. in this case, doesn't provide
	 * separate modes for L2 vs L1.
	 */

> > +        */
> > +       if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> > +               indirect_branch_prediction_barrier();
> > +
> >         /* Update any VMCS fields that might have changed while L2 ran */
> >         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> >         vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ffe552a82044..bf8b5c9c56ae 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1347,9 +1347,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
> >                 vmcs_load(vmx->loaded_vmcs->vmcs);
> >
> >                 /*
> > -                * No indirect branch prediction barrier needed when switching
> > -                * the active VMCS within a guest, e.g. on nested VM-Enter.
> > -                * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
> > +                * No indirect branch prediction barrier needed when
> > +                * switching the active VMCS within a guest, except

Wrap at 80.

> > +                * for virtual IBRS. To minimize the number of IBPBs

Same nit on "virtual IBRS".

> > +                * executed, the one to support virtual IBRS is
> > +                * handled specially in nested_vmx_vmexit().

"nested VM-Exit" instead of nested_vmx_vmexit() to avoid rename hell, though that
one is unlikely to get renamed.

This work?

		/*
		 * No indirect branch prediction barrier needed when switching
		 * the active VMCS within a guest, except if IBRS is advertised
		 * to the guest.  To minimize the number of IBPBs executed, KVM
		 * performs IBPB on nested VM-Exit (a single nested transition
		 * may switch the active VMCS multiple times).
		 */

> >                  */
> >                 if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
> >                         indirect_branch_prediction_barrier();
> > --
> > 2.37.3.998.g577e59143f-goog
> >
> Ping.
