Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F8757A72F
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbiGSTX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 15:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239135AbiGSTX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 15:23:26 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06354AEF
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:23:25 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id bh13so14381365pgb.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MTnX2TeXpHP7v1pQxn3jS/+EWjEsPRUgfU3phyOX21s=;
        b=AVYzqlSpLLX+2Dh2JJv/wP4Ov9MEYgY3fi0PRUL7nSg3XVbabk8dvbL2NdBEwLmCyi
         mlVYk6VbJIjFad4GBo9iwP4A0HvfVJy+x95dh1iz+tr1KLKSOg96SU4e4bBmNOYHQqMn
         iD7upg/MAIcOg7fRaddKNxPBOYxU60iqvJankRN8WAXhDo3SgHITdGG85DEfJsz81NUo
         vGPBeDydYt/J1BKbFCc54iJaKo8lCh6oK3XNLNEIR5TetdUnJqH1dyWShevXuDDcenBA
         zea/ahSlzqaT1zVqmJPBa7WzyDYVBKAS46wqnZRJCeiwN8JqLzc1eQ9KMNKEFDn3WTng
         xxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MTnX2TeXpHP7v1pQxn3jS/+EWjEsPRUgfU3phyOX21s=;
        b=2k7fxdtoJqMaAbJfLNK0DaOip7dZSzCHDqou4+6C2RPa32ltUnSGZTV2jZnhR3FyVX
         bkcueU45mufypz+yZIwjXhdXjwbNtTvVzaGYRwT8VA9+LTrQO2RVqBeqoS4FHvRqyPAI
         lQshROdPVsinT0qRRdeM1hprokG7gv8UG5BXVX55+LHQyVutmrS7xVpfIN9/ZZrQ0esQ
         1knGn844nRSR1bFMGFU2VEAx9KLC9wvX8lli6IOPcgDFZ/lsFUoiWNbnRI4mvlzX/6Ik
         UqirGSlM25O9R8IwcNVmq8fapxjKgG5bF7LbW/vFraJMLcivjSaE+qG0+cvmgxC6ZmMt
         nPXQ==
X-Gm-Message-State: AJIora+pTmGLLVOQWQ/sDS4iXPJEP1eKMwj3P2P0Xmi0osN0fYI0b+4x
        VaixuSG1+RMvuIlyNqxVzRl1dQ==
X-Google-Smtp-Source: AGRyM1tdTRACG72ok5+gvUICVuap9dPfxWpcLRXvvt7dtpUivNWDJzFklYwXVDWM4t7qR09jo914hw==
X-Received: by 2002:a05:6a00:1781:b0:528:c839:9886 with SMTP id s1-20020a056a00178100b00528c8399886mr35174494pfg.71.1658258605007;
        Tue, 19 Jul 2022 12:23:25 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id n5-20020a17090a394500b001f1694dafb1sm8292616pjf.44.2022.07.19.12.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 12:23:24 -0700 (PDT)
Date:   Tue, 19 Jul 2022 19:23:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>
Subject: Re: [RFC PATCH v6 090/104] KVM: TDX: Handle TDX PV CPUID hypercall
Message-ID: <YtcEqMtjAHQ61ZR9@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <98939c0ec83a109c8f49045e82096d6cdd5dafa3.1651774251.git.isaku.yamahata@intel.com>
 <CAAhR5DHPk2no0PVFX6P1NnZdwtVccjmdn4RLg4wKSmfpjD6Qkg@mail.gmail.com>
 <20220629101356.GA882746@ls.amr.corp.intel.com>
 <CAAhR5DF82HO4yEmOjywXXR-_wcXT7hctib2yfRaS-nb6sGPsLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DF82HO4yEmOjywXXR-_wcXT7hctib2yfRaS-nb6sGPsLw@mail.gmail.com>
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

On Mon, Jul 18, 2022, Sagi Shahar wrote:
> On Wed, Jun 29, 2022 at 3:14 AM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> >
> > On Tue, Jun 14, 2022 at 11:15:00AM -0700,
> > Sagi Shahar <sagis@google.com> wrote:
> >
> > > On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
> > > >
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > >
> > > > Wire up TDX PV CPUID hypercall to the KVM backend function.
> > > >
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
> > > >  1 file changed, 22 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 9c712f661a7c..c7cdfee397ec 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -946,12 +946,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> > > >         return 1;
> > > >  }
> > > >
> > > > +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       u32 eax, ebx, ecx, edx;
> > > > +
> > > > +       /* EAX and ECX for cpuid is stored in R12 and R13. */
> > > > +       eax = tdvmcall_a0_read(vcpu);
> > > > +       ecx = tdvmcall_a1_read(vcpu);
> > > > +
> > > > +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> > >
> > > According to the GHCI spec section 3.6
> > > (TDG.VP.VMCALL<Instruction.CPUID>) we should return
> > > VMCALL_INVALID_OPERAND if an invalid CPUID is requested.
> > >
> > > kvm_cpuid already returns false in this case so we should use that
> > > return value to set the tdvmcall return code in case of invalid leaf.
> >
> > Based on CPUID instruction, cpuid results in #UD when lock prefix is used or
> > earlier CPU that doesn't support cpuid instruction.
> > So I'm not sure what CPUID input result in INVALID_OPERAND error.
> > Does the following make sense for you?
> >
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1347,7 +1347,7 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> >         eax = tdvmcall_a0_read(vcpu);
> >         ecx = tdvmcall_a1_read(vcpu);
> >
> > -       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> > +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);

Barring new verbiage in the GHCI, this change is correct.  CPUID behavior is
different for AMD vs. Intel, but the behavior is architectural and well-defined
for each vendor.  KVM handles this by emulating the AMD vs. Intel behavior based
on the configured vCPU model.

Forcing an exact match would make TDX follow AMD behavior, not Intel behavior.

> >         tdvmcall_a0_write(vcpu, eax);
> >         tdvmcall_a1_write(vcpu, ebx);
> >
> > thanks,
> 
> If any CPUID request is considered valid, then perhaps the spec itself
> needs to be updated.

Agreed.  Documenting that "Invalid CPUID requested" is a legal return value implies
that TDX is creating a _third_ variant of CPUID behavior.  Dropping the error return
seems like the simplest approach, unless it was added for a specific reason?
