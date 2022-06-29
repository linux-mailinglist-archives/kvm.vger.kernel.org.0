Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607C8560CFD
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiF2XKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 19:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiF2XKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 19:10:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921EF1EEC9
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 16:10:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x20so9839435plx.6
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 16:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KDhjdcDSRxP+mz6Pbu+cpQyCGlJF95POpbmEjxFkLoU=;
        b=iN/BpWX43Q7E+ahNF0T8KfQXtE7PolBbrrAO6FlZufDN+N9Pa92ACYTnJMGmRmh+Tv
         5nnAUbw4RuLmdKxGgT62pM5i1XjYtJeOkvtCUh7myZawv5PYENa6zhycbFKdrHTzXfEu
         rPMMivdpZcTXm2DSAqcQB2bFOzUK+6+akn9T28xOU+NUlW/DgzcUgNyxyOvQDZJoKc11
         eCnzsZ1dod6n0MCL4JFCr7j5dBG5NR2U5KQ8DMyk0gT47l3P1kygOi2OQXO2UYjbFE8t
         5/lLyWuZrfq7cgOORNsOJhMxDi1dhGkb75Plk79I+DP6/EUzpAwd8a7WxW+ngGiQAhg8
         613Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KDhjdcDSRxP+mz6Pbu+cpQyCGlJF95POpbmEjxFkLoU=;
        b=VYEfxLUmcZGGdYPgDas/gX4Ou1c7P7TA4hq6mltcUPaQbyPdjiYOACL1BDY6RPwuvz
         EZrLmJr3zsexHxJO/0MuBmSxGoddJFdjAus77m9bcBaRJ77AJ9mmTWOtxi5bEfXRat5L
         GxBxnGXEHxrOx3UgV56LTMBGnUvflNEPH8doUVDO5IrQZc8mRkv59G1Ub6JIbaWbUqbK
         FAF+5bE0a+nQoxpEnsxXCym7disPzTtp8FRG3f6GmXnUsVPNIZ0qxmDi7Vwt9tyA+gky
         3aOFaYdeeT9LMo/5ijb3EEBGPVERLbphPh6B0P58wYsnT6bXHjZoN65xvEyzB3QYQzlk
         f9Jw==
X-Gm-Message-State: AJIora+6aE6HVtlDd2uCWDGOW/P6qdvetfOnhquopUgF41DyV+wP9QRp
        TlRhXPEjmadotKEZyYnXXKZnsA==
X-Google-Smtp-Source: AGRyM1tAU0Se7sspH/gusJ+whjxPvMVYys+mpJiq2alTztU1asj1KHlYoFxZh7LjTNKpXqmAxr62/Q==
X-Received: by 2002:a17:902:ab8a:b0:16a:7cf2:a394 with SMTP id f10-20020a170902ab8a00b0016a7cf2a394mr11305142plr.26.1656544245936;
        Wed, 29 Jun 2022 16:10:45 -0700 (PDT)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id jf17-20020a17090b175100b001ec86a0490csm2668543pjb.32.2022.06.29.16.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 16:10:45 -0700 (PDT)
Date:   Wed, 29 Jun 2022 23:10:41 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] kvm: nVMX: add tracepoint for kvm:kvm_nested_vmrun
Message-ID: <Yrzb8c3g6C/aL8+B@google.com>
References: <20220626200538.3210528-1-mizhang@google.com>
 <YrnBLLRljyHCyeOe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnBLLRljyHCyeOe@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index f5cb18e00e78..29cc36cf2568 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3367,6 +3367,13 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >       };
> >       u32 failed_index;
> >
> > +     trace_kvm_nested_vmrun(
> > +             kvm_rip_read(vcpu), vmx->nested.current_vmptr,
> > +             vmcs12->guest_rip,
>
> Be consistent; either put each parameter on it's own line or wrap only when
> necessary.

will do.

>
> > +             vmcs12->guest_intr_status,
> > +             vmcs12->vm_entry_intr_info_field,
> > +             vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT);
> > +
>
> Align the parameters to the opening '(', that "rule" trumps the 80 char soft limit.

will do.

>
>         trace_kvm_nested_vmrun(kvm_rip_read(vcpu),
>                                vmx->nested.current_vmptr,
>                                vmcs12->guest_rip,
>                                vmcs12->guest_intr_status,
>                                vmcs12->vm_entry_intr_info_field,
>                                vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_ENABLE_EPT);
>
> And if we're going to add nVMX, we should clean up the tracepoint output.  E.g.
> pass in KVM_ISA_{SVM,VMX} to different VMCB vs. VMCS and npt vs. ept (and maybe
> print nNPT and nEPT to make it obvious it's the vmcs12 setting?).  The "nrip"
> field is wrong even for SVM; the tracepoint prints the L2 rip, not the next_rip
> field in vmcs12.  Maybe "L2 rip"?

I can change the 'nrip' to 'nested rip', since it may not necessarily
the 'L2 rip'.

For the others, will do.

