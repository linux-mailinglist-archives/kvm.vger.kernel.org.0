Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB24B4DDFF1
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiCRRaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbiCRRaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:30:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C90539693;
        Fri, 18 Mar 2022 10:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vga+VUB1xbVQ2AIXdGqGRfNajpKT5maC9LEyJ/DlmKc=; b=oPDtOvDxgIw9zDrdY2X9mkugTv
        YGGbCJ2ibwPqRKTF32K9yDOEklcdjC/tbot9NOJWW9Hvo8rQEb7cKeRA0kvqCueg2vdmakrLODL7w
        SKshlo5SYXLSWI1m5ccGBdFeYVMr314zkrIUjOQBNS4PXDbMB+pry3Tnw6O+8E47PSoGUxffzMdRG
        VtgkmpU79vsc6vbATipFIEOTJp2uAa5m+YN8zvNukq4Dgcoyi9W66ZvDVpUkhodw1fusuLWZ5X3rH
        lEPmDufNdsREUcoeIbXWj+39n2X4KlxZYihNCW9K1uAW4f2jQtIYpwKDMs5EF8VhHwgzpZB3eV26r
        SWI0I6Mw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nVGP1-0088sh-Jk; Fri, 18 Mar 2022 17:28:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id DD1A698841D; Fri, 18 Mar 2022 18:28:37 +0100 (CET)
Date:   Fri, 18 Mar 2022 18:28:37 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, seanjc@google.com
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Message-ID: <20220318172837.GQ8939@worktop.programming.kicks-ass.net>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com>
 <3bbe3f8717cdf122f909a48e117dab6c09d8e0c8.camel@redhat.com>
 <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dc56110-5f1b-6140-937c-bf4a28ddbe87@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 05:29:20PM +0100, Paolo Bonzini wrote:
> On 3/17/22 18:43, Maxim Levitsky wrote:
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 20f64e07e359..3388072b2e3b 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -88,7 +88,7 @@ KVM_X86_OP(deliver_interrupt)
> >   KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > -KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > +KVM_X86_OP(get_mt_mask)
> >   KVM_X86_OP(load_mmu_pgd)
> >   KVM_X86_OP(has_wbinvd_exit)
> >   KVM_X86_OP(get_l2_tsc_offset)
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index a09b4f1a18f6..0c09292b0611 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4057,6 +4057,11 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
> >          return true;
> >   }
> > +static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +       return 0;
> > +}
> > +
> >   static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >   {
> >          struct vcpu_svm *svm = to_svm(vcpu);
> > @@ -4718,6 +4723,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >          .check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
> >          .apicv_post_state_restore = avic_apicv_post_state_restore,
> > +       .get_mt_mask = svm_get_mt_mask,
> >          .get_exit_info = svm_get_exit_info,
> >          .vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
> 
> Thanks, I'll send it as a complete patch.  Please reply there with your
> Signed-off-by.

Yeah, ret0 should only be used with up-to 'long' return values.

So ACK on that patch.

> Related to this, I don't see anything in arch/x86/kernel/static_call.c that
> limits this code to x86-64:
> 
>                 if (func == &__static_call_return0) {
>                         emulate = code;
>                         code = &xor5rax;
>                 }
> 
> 
> On 32-bit, it will be patched as "dec ax; xor eax, eax" or something like
> that.  Fortunately it doesn't corrupt any callee-save register but it is not
> just a bit funky, it's also not a single instruction.

Urggghh.. that's fairly yuck. So there's two options I suppose:

	0x66, 0x66, 0x66, 0x31, 0xc0

Which is a tripple prefix xor %eax, %eax, which, IIRC should still clear
the whole 64bit on 64bit and *should* still not trigger the prefix
decoding penalty some frontends have (which is >3 IIRC).

Or we can emit:

	0xb8, 0x00, 0x00, 0x00, 0x00

which decodes to: mov $0x0,%eax, which is less efficient in some
front-ends since it doesn't always get picked up in register rename
stage.


