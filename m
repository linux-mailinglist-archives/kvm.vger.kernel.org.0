Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB763B1D9
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 20:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiK1TFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 14:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiK1TFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 14:05:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7962C27FE9
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:05:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso6934362pjb.1
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 11:05:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WfuhYom5NLV9dwVUIo9LgETuWQiG7AHZPA/dC/vEDtc=;
        b=SToTjJq2xOY4pN9teb36zcTUmTNuGzBQ/uI9cacZyXww3pn0WZ2wfZeV2cEvT/vtpR
         jLNTD1c0/cHwcRX0DWtx8BrhqqRat+PYUUwU0lWrF8/40PYsdx2fsvCGN6B5dAu86vU4
         2J6ff7xuoAsQJgoKkf70bwFSzj10Ws+IuZYG7XOO4+lGUY+DHG5FMVF8/bVIjvStEnDG
         5BMO4p3P1K8DA/MJAVlQU/wGn17AnCJmcAyawq65TjfmD1e2SJZ82rRyCho0xWGAGG+W
         m8g2EwAH1fWQgfDhRAWtg3SUCM0fYE6+iU/yEu2JCb5N8tbMTHoyqX2pqPvvl811ekHa
         xlww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WfuhYom5NLV9dwVUIo9LgETuWQiG7AHZPA/dC/vEDtc=;
        b=sj0scn+h92spUq1c0vPdnONhWRBVltO1V3L8J1bzi8+SV5YjPXjHBgKh6PiDervJNU
         WocNKTytQoAmYklEoVZjfxmwWwXH0kY8K3987mHVm8H4g6LESScMH3MuUz2PP7lcjQv/
         cKYlh82FHkJULtGk8joMHEe2rrmYjKgYAwzbNyNhhPXBHrI00djLcmXaR7p60nMC2wf8
         2/ZJg8euwZ5+4Ig8x77ioIwaKWNAnbqOX6febfCJ8A/JUndfKlgeje8yrP2jufsa7+4z
         S9zz2zCUNlzyS8+lRT73gWqGTLBONze1lffN6eD6d8+Ak+eZIeVqv1gv3eYlgSNeF5qW
         vNOg==
X-Gm-Message-State: ANoB5plObZMOh1zNt8p+gXPQ7G030nVzccslT7Jj2fVY8OrzMxIn3zCC
        TJNxgka3FnI2NWdNHj1BiDWeJw==
X-Google-Smtp-Source: AA0mqf6A4DG/1u0UctwI/ftuMbKzkvuxKlagtz6vUYpkrGjbzUPDI8JWUW6VyGAFqpGG+UmZN9FbwQ==
X-Received: by 2002:a17:902:a718:b0:189:7722:99d7 with SMTP id w24-20020a170902a71800b00189772299d7mr12536216plq.96.1669662347851;
        Mon, 28 Nov 2022 11:05:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a656705000000b004767bc37e03sm7180615pgf.39.2022.11.28.11.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 11:05:47 -0800 (PST)
Date:   Mon, 28 Nov 2022 19:05:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Li, Xin3" <xin3.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [RESEND PATCH 5/6] KVM: x86/VMX: add kvm_vmx_reinject_nmi_irq()
 for NMI/IRQ reinjection
Message-ID: <Y4UGh9yxt24Rn3rS@google.com>
References: <BN6PR1101MB2161299749E12D484DE9302BA8049@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y3NZQBJugRt07udw@hirez.programming.kicks-ass.net>
 <DM5PR1101MB2172D7D7BC49255DB3752802A8069@DM5PR1101MB2172.namprd11.prod.outlook.com>
 <Y3ZYiKbJacmejY3K@google.com>
 <BN6PR1101MB21611347D37CF40403B974EDA8099@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <BN6PR1101MB2161FCA1989E3C6499192028A80D9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y302kxLEhcp20d65@google.com>
 <BN6PR1101MB216162F44664713802201FAFA80C9@BN6PR1101MB2161.namprd11.prod.outlook.com>
 <Y36Fy/OYO5u0AzEG@google.com>
 <Y389WnT9BKPhTsgM@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y389WnT9BKPhTsgM@hirez.programming.kicks-ass.net>
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

On Thu, Nov 24, 2022, Peter Zijlstra wrote:
> On Wed, Nov 23, 2022 at 08:42:51PM +0000, Sean Christopherson wrote:
> >  arch/x86/kvm/kvm_cache_regs.h | 16 +++++------
> >  arch/x86/kvm/vmx/vmenter.S    |  4 +--
> >  arch/x86/kvm/vmx/vmx.c        | 51 ++++++++++++++++++-----------------
> >  arch/x86/kvm/vmx/vmx.h        |  2 +-
> >  arch/x86/kvm/x86.h            |  6 ++---
> >  5 files changed, 41 insertions(+), 38 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> > index c09174f73a34..af9bd0374915 100644
> > --- a/arch/x86/kvm/kvm_cache_regs.h
> > +++ b/arch/x86/kvm/kvm_cache_regs.h
> > @@ -50,26 +50,26 @@ BUILD_KVM_GPR_ACCESSORS(r15, R15)
> >   * 1	  0	  register in vcpu->arch
> >   * 1	  1	  register in vcpu->arch, needs to be stored back
> >   */
> > -static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> > -					     enum kvm_reg reg)
> > +static __always_inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
> > +						      enum kvm_reg reg)
> >  {
> >  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> >  }
> >  
> > -static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> > -					 enum kvm_reg reg)
> > +static __always_inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
> > +						  enum kvm_reg reg)
> >  {
> >  	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> >  }
> >  
> > -static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> > -					       enum kvm_reg reg)
> > +static __always_inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
> > +							enum kvm_reg reg)
> >  {
> >  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> >  }
> >  
> > -static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> > -					   enum kvm_reg reg)
> > +static __always_inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
> > +						    enum kvm_reg reg)
> >  {
> >  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
> >  	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
> 
> You'll have to consider include/asm-generic/bitops/instrumented-non-atomic.h
> and friend, and the above should probably switch to using:
> 
>   arch_test_bit(), arch___set_bit() resp.
> 
> to avoid the explicit instrumentation.

Well that's just mean.  I'll figure out a solution, thanks for the heads up!
