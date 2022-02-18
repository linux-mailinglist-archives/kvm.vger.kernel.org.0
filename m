Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61454BBE79
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 18:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiBRRd4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 12:33:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238651AbiBRRdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 12:33:51 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95932B5BBF
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:33:33 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p8so2823798pfh.8
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 09:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DawLCXzSIgJxif3UfQrpoVCzlIzEfJYQjJYMKzO/mqA=;
        b=bVtGhZHOXdLJk0W06wRc9uBcovqXbMoH9SqzLAvel4sB4lBTQjw7M+OF4TKBMmyGpd
         VZ/esSYZsMef1kAycskE8+oPeO0CeUlBe+quQFZIqu/IFDww5w079ABI/XtovZhxkRGW
         IuThUHhMGXXFTvwNs75R2kKB5jWMld9KxT41vzdc0bcQVVPCAjVMzBhEJHNYDFbrWKQc
         UDUqSnPWoV42JOduUdC8T/vrnRceCTEygns9/GZ/MJwSXf5qNgflqtqYuF83JGGgOVo3
         3y/NrHemd63hmx/NTjNxMNVohpgFhYd4TaA+GaK+jQ8seJP5ab0qPPhRZHSrRsDKRgq7
         XaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DawLCXzSIgJxif3UfQrpoVCzlIzEfJYQjJYMKzO/mqA=;
        b=Q4p9o/QyG4ZiIr2Ty/yk2BFF5eiB/euAzpIDVqGNdb2xcgM6a7zR072GRZvXFrXbIJ
         AWI5HOXZKt9Y7kFK20qOSTK1HAr+j0Fjl78zezZBxLSRNmiGsRNE8gEZdoieWcdRuCLe
         8WMzLcAmMt1iJ9hV1pMYtBeqJ9R2cCCSzn1yYjOFz6ReC+LEblDpZrChwLwo6HzeHO6T
         h+LQOnqiKot4XAcQOnIeD1wvlPIxMhL5NDbaL+FzI98atHPs0TEPrLN189GlE87i2RrW
         Fdh+ZEkj5UML36yRg1w6pqtAuqWRfL3eQmQ9DoZuHu87kRPahiObdzER2Ili5oYSXJO+
         yi0g==
X-Gm-Message-State: AOAM533+403tq5hp/053gq5/owNrFaEq3aJ8Z4sR7LXJNuTphmrXcF6V
        yvEwAYPoR06IacUVlF3t1y3JDGTH68qJfw==
X-Google-Smtp-Source: ABdhPJw5eWTs2BTk05UmURA54Db71bx4mjZ+FpOAoAe2XOR2qvF9PrePoJKMFqLR+3MSyalzpy67vw==
X-Received: by 2002:a63:560a:0:b0:373:bd8f:bb6f with SMTP id k10-20020a63560a000000b00373bd8fbb6fmr5401620pgb.33.1645205613073;
        Fri, 18 Feb 2022 09:33:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e3sm8534386pga.74.2022.02.18.09.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 09:33:32 -0800 (PST)
Date:   Fri, 18 Feb 2022 17:33:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Message-ID: <Yg/YaOgTLixP2K8s@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com>
 <Yg/JZZ+i67HDKCVK@google.com>
 <8f99a6a2-b64e-0211-a7d3-8b84c668a92f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f99a6a2-b64e-0211-a7d3-8b84c668a92f@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 18, 2022, Paolo Bonzini wrote:
> On 2/18/22 17:29, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index ab1c4778824a..d3da64106685 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -131,6 +131,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
> > >   	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
> > >   				*(((struct kvm_x86_ops *)0)->func));
> > >   #define KVM_X86_OP_OPTIONAL KVM_X86_OP
> > > +#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
> > >   #include <asm/kvm-x86-ops.h>
> > >   EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
> > >   EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
> > > @@ -12016,7 +12017,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> > >   static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
> > >   {
> > >   	return (is_guest_mode(vcpu) &&
> > > -			kvm_x86_ops.guest_apic_has_interrupt &&
> > >   			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
> > 
> > Can you opportunistically align the indentation and drop the outer parantheses? I.e.
> > 
> > 	return is_guest_mode(vcpu) &&
> > 	       static_call(kvm_x86_guest_apic_has_interrupt)(vcpu);
> 
> Hmm, I like having the parentheses (despite "return not being a function")
> because editors are inconsistent in what indentation to use after return.
> 
> Some use a tab (which does the right thing just by chance with Linux because
> "return " is as long as a tab is wide), but vim for example does the totally

Uh, no, vim inserts a tab.  "return " isn't as long as a tab is wide.  That's 7
chars, tabs are 8, which is exactly the problem.

I'm ok with
	
	return (is_guest_mode(vcpu) &&
		static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));

I care more about alignment than unnecessary (), but I'd still prefer

	return is_guest_mode(vcpu) &&
	       static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));

> awkward
> 
> int f()
> {
>         return a &&
>                 b;
> }
> 
> Of course I can fix the indentation.
> 
> Paolo
> 
> > >   }
> > > diff --git a/kernel/static_call.c b/kernel/static_call.c
> > > index 43ba0b1e0edb..76abd46fe6ee 100644
> > > --- a/kernel/static_call.c
> > > +++ b/kernel/static_call.c
> > > @@ -503,6 +503,7 @@ long __static_call_return0(void)
> > >   {
> > >   	return 0;
> > >   }
> > > +EXPORT_SYMBOL_GPL(__static_call_return0)
> > 
> > This doesn't compile, it needs a semicolon.
> > 
> 
