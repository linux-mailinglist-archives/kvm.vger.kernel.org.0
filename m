Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C931D60F6C2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbiJ0MHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235513AbiJ0MHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44A2ACF77
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666872439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+2zMebd+ald9q0vyrSWWXfgEqnJJ8rrovWDRcuiW1g=;
        b=S1m0NS5lNsaZEcaWQXzYxoLDX/jz8wJc6rhdMJ6ug5Txmh+0hEDLqfK72hr82AGXUkOaK7
        4uS6YslNCiMKhpC/w89WLQNC7h1uWEtWd7qoGkGp8886klb+FAPdAvEuBcsggc0a2nDg1d
        Q2zBxYwnXl+SghtR4E0BYOMXRKmqjcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-x_io6mSoOG6bsrX7uU4UQA-1; Thu, 27 Oct 2022 08:07:16 -0400
X-MC-Unique: x_io6mSoOG6bsrX7uU4UQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A2C4101A528;
        Thu, 27 Oct 2022 12:07:15 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD21E4EA4E;
        Thu, 27 Oct 2022 12:07:11 +0000 (UTC)
Message-ID: <0fdd437cfa347258de2841c4af2532e6b49751a7.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Oct 2022 15:07:09 +0300
In-Reply-To: <Y1bt5eGAOuYJINze@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-15-mlevitsk@redhat.com>
         <Y1GZu5ztBadhFphk@google.com>
         <35fe5a9c8ef5155f226df7beb24917d9b2020871.camel@redhat.com>
         <Y1bt5eGAOuYJINze@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-10-24 at 19:56 +0000, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > On Thu, 2022-10-20 at 18:55 +0000, Sean Christopherson wrote:
> > > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > > 
> > > Changelog please.  This patch in particular is extremely difficult to review
> > > without some explanation of what is being done, and why.
> > > 
> > > If it's not too much trouble, splitting this over multiple patches would be nice.
> > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  lib/x86/svm_lib.h | 58 +++++++++++++++++++++++++++++++++++++++
> > > >  x86/svm.c         | 51 ++++++++++------------------------
> > > >  x86/svm.h         | 70 ++---------------------------------------------
> > > >  x86/svm_tests.c   | 24 ++++++++++------
> > > >  4 files changed, 91 insertions(+), 112 deletions(-)
> > > > 
> > > > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > > > index 27c3b137..59db26de 100644
> > > > --- a/lib/x86/svm_lib.h
> > > > +++ b/lib/x86/svm_lib.h
> > > > @@ -71,4 +71,62 @@ u8* svm_get_io_bitmap(void);
> > > >  #define MSR_BITMAP_SIZE 8192
> > > >  
> > > >  
> > > > +struct svm_extra_regs
> > > 
> > > Why not just svm_gprs?  This could even include RAX by grabbing it from the VMCB
> > > after VMRUN.
> > 
> > I prefer to have a single source of truth - if I grab it from vmcb, then
> > it will have to be synced to vmcb on each vmrun, like the KVM does,
> > but it also has dirty registers bitmap and such.
> 
> KUT doesn't need a dirty registers bitmap.  That's purely a performance optimization
> for VMX so that KVM can avoid unnecessary VMWRITEs for RIP and RSP.  E.g. SVM
> ignores the dirty bitmap entirely:
I know that.

> 
>   static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   {
> 	struct vcpu_svm *svm = to_svm(vcpu);
> 
> 	trace_kvm_entry(vcpu);
> 
> 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
> 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
> 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
> 
> 	...
> 
>   }
> 
> And even for VMX, I can't imagine a nVMX test will ever be so performance
> sensitive that an extra VMWRITE for RSP will be a problem.
> 
> > I prefer to keep it simple.

I too. So the only other more or less clean way is to copy the RAX and RSP from vmcb to 
svm_gprs on exit, and vise versa on VM entry. Is this what you mean?

> 
> The issue is simplifying the assembly code increases the complexity of the users.
> E.g. users and readers need to understand what "extra regs", which means documenting
> what is included and what's not.  On the other hand, the assembly is already quite
> complex, adding a few lines to swap RAX and RSP doesn't really change the overall
> of complexity of that low level code.
> 
> The other bit of complexity is that if a test wants to access all GPRs, it needs
> both this struct and the VMCB.  RSP is unlikely to be problematic, but I can see
> guest.RAX being something a test wants access to.
> 
> > Plus there is also RSP in vmcb, and RFLAGS, and even RIP to some extent is a GPR.
> 
> RIP is definitely not a GPR, it has no assigned index.  RFLAGS is also not a GPR.
> 
> > To call this struct svm_gprs, I would have to include them there as well.
> 
> RAX and RSP are the only GPRs that need to be moved to/from the VMCB.  
> 
> > And also there is segment registers, etc, etc.
> 
> Which aren't GPRs.

But user can want to use them too.

> 
> > So instead of pretending that this struct contains all the GPRs of the guest
> > (or host while guest is running) I renamed it to state that it contains only
> > some gprs that SVM doesn't context switch.
> 
> ...
> 
> > > > +               "xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> > > > +               "xchg %%rbp, 0x18(%%" reg ")\n\t"       \
> > > > +               "xchg %%rsi, 0x20(%%" reg ")\n\t"       \
> > > > +               "xchg %%rdi, 0x28(%%" reg ")\n\t"       \
> > > > +               "xchg %%r8,  0x30(%%" reg ")\n\t"       \
> > > > +               "xchg %%r9,  0x38(%%" reg ")\n\t"       \
> > > > +               "xchg %%r10, 0x40(%%" reg ")\n\t"       \
> > > > +               "xchg %%r11, 0x48(%%" reg ")\n\t"       \
> > > > +               "xchg %%r12, 0x50(%%" reg ")\n\t"       \
> > > > +               "xchg %%r13, 0x58(%%" reg ")\n\t"       \
> > > > +               "xchg %%r14, 0x60(%%" reg ")\n\t"       \
> > > > +               "xchg %%r15, 0x68(%%" reg ")\n\t"       \
> > > > +               \
> > > 
> > > Extra line.
> > > 
> > > > +               "xchg %%rbx, 0x00(%%" reg ")\n\t"       \
> > > 
> > > Why is RBX last here, but first in the struct?  Ah, because the initial swap uses
> > > RBX as the scratch register.  Why use RAX for the post-VMRUN swap?  AFAICT, that's
> > > completely arbitrary.
> > 
> > Let me explain:
> > 
> > On entry to the guest the code has to save the host GPRs and then load the guest GPRs.
> > 
> > Host RAX and RBX are set by the gcc as I requested with "a" and "b"
> > modifiers, but even these should not be changed by the assembly code from the
> > values set in the input.
> > (At least I haven't found a way to mark a register as both input and clobber)
> 
> The way to achive input+clobber is to use input+output, i.e. "+b" (regs), but I
> think that's a moot point...
I'll try that.

> 
> > Now RAX is the hardcoded input to VMRUN, thus I leave it alone, and use RBX
> > as regs pointer, which is restored to the guest value (and host value stored
> > in the regs) at the end of SWAP_GPRs.
> 
> ...because SWAP_GPRs isn't the end of the asm blob.  As long as RBX holds the
> same value (regs) at the end of the asm blob, no clobbering is necessary even if
> RBX is changed within the blob.
Exactly - I preserved it over the stack, but if I can tell gcc that my macro
clobbers it, then I won't need to.


> 
> > If I switch to full blown assembly function for this, then I could do it.
> > 
> > Note though that my LBR tests do still need this as a macro because they must
> > not do any extra jumps/calls as these clobber the LBR registers.
> 
> Shouldn't it be fairly easy to account for the CALL in the asm routine?  Taking
> on that sort of dependency is quite gross, but it'd likely be less maintenance
> in the long run than an inline asm blob.

That is not possible - the SVM has just one LBR - so doing call will erase it.

I'll think of something, I also do want to turn this into a function.

Best regards,
	Maxim Levitsky

> 


