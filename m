Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9AB60BC71
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 23:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJXVqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 17:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiJXVqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 17:46:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE53A2EA2AD
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 12:57:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g28so9868974pfk.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 12:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kE9hMflDqJ/LUeHDyxIoFtQcbjZ6fqdhbck2IQp6qBI=;
        b=m8vzGG3xRWNDx0c+1aXHlCULK6Zc4c3b/LQrrJQWftlhBvsUH2/2vIiyyZPvBIZGmj
         bt+iqTixK1topn5ndZlQykIJQk5UpG4bco/kTi+Dq1bGYUcjVNSwRzrtIMcM9EhA2ega
         pTmLTHiTh3jz8ra8kBP5ju54tTfDtuCq3JRovUiSPmBJ/w0iDIIUEarLEfIC9Y6lWGIR
         vyKBDbGacmXejeBXxzBbyCilXlzzGCc7vG47Nd/GIpH3v3CXTSx4ItrCT9amJwMd3b5v
         G1lkyYo6Yxx1YqxyYQZu5lJyJg7CrshSslpEF1A/ano28CCHNsAvVMWXcBWDtpE20ZKu
         LRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kE9hMflDqJ/LUeHDyxIoFtQcbjZ6fqdhbck2IQp6qBI=;
        b=U/gcO2O28hMFW/d6xKhs9q0QFYKnv4QQ+4t8KQ7nXHN00zq+HtR3z+AEjScUgjgeE/
         4Q50gZXimSzNA5S6cYSwqyuVYi6gzBWfm4/0AiihMLxgtVjYVZlBboCuuzWjilhB4gvd
         kWXCEtiWT/u5Rqvw0o4ejl8rFZabxRL2tx10/HgO8qqSRwxLbNUi4pGY4dBcVfM30Wzo
         dhsOTG7ktsY6cXCmXMH1rQ9Fn+gx1PNUqcZWmT9F7/UH7GrERTQ6Mdfo8PPNwsGpDN/c
         mO4S/G4ZQj09+2kj42nRozS8B2U1DuDfgWeO0qSjd0ThUBw4UWkF9obF3EN5aapxc0+O
         +S2g==
X-Gm-Message-State: ACrzQf2UdKWcYW+F9T0iL6rvskhlB1KaKy+r/v8i8MrDKpfviBdimH1q
        d9dpYNICQ4Kr6VdfaEHGPv6WnQ==
X-Google-Smtp-Source: AMsMyM5jQWR3Nb1KZRZoBXoMvwCc78t7DtzzvrKVtOyg4HI0VKxq0ZeFkkVZuL7S3MuGnHgqhLN8vw==
X-Received: by 2002:a63:8949:0:b0:46b:2f56:a910 with SMTP id v70-20020a638949000000b0046b2f56a910mr30657799pgd.158.1666641385945;
        Mon, 24 Oct 2022 12:56:25 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b0017a04542a45sm109565plf.159.2022.10.24.12.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 12:56:25 -0700 (PDT)
Date:   Mon, 24 Oct 2022 19:56:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
Message-ID: <Y1bt5eGAOuYJINze@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-15-mlevitsk@redhat.com>
 <Y1GZu5ztBadhFphk@google.com>
 <35fe5a9c8ef5155f226df7beb24917d9b2020871.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35fe5a9c8ef5155f226df7beb24917d9b2020871.camel@redhat.com>
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

On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> On Thu, 2022-10-20 at 18:55 +0000, Sean Christopherson wrote:
> > On Thu, Oct 20, 2022, Maxim Levitsky wrote:
> > 
> > Changelog please.  This patch in particular is extremely difficult to review
> > without some explanation of what is being done, and why.
> > 
> > If it's not too much trouble, splitting this over multiple patches would be nice.
> > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  lib/x86/svm_lib.h | 58 +++++++++++++++++++++++++++++++++++++++
> > >  x86/svm.c         | 51 ++++++++++------------------------
> > >  x86/svm.h         | 70 ++---------------------------------------------
> > >  x86/svm_tests.c   | 24 ++++++++++------
> > >  4 files changed, 91 insertions(+), 112 deletions(-)
> > > 
> > > diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
> > > index 27c3b137..59db26de 100644
> > > --- a/lib/x86/svm_lib.h
> > > +++ b/lib/x86/svm_lib.h
> > > @@ -71,4 +71,62 @@ u8* svm_get_io_bitmap(void);
> > >  #define MSR_BITMAP_SIZE 8192
> > >  
> > >  
> > > +struct svm_extra_regs
> > 
> > Why not just svm_gprs?  This could even include RAX by grabbing it from the VMCB
> > after VMRUN.
> 
> I prefer to have a single source of truth - if I grab it from vmcb, then
> it will have to be synced to vmcb on each vmrun, like the KVM does,
> but it also has dirty registers bitmap and such.

KUT doesn't need a dirty registers bitmap.  That's purely a performance optimization
for VMX so that KVM can avoid unnecessary VMWRITEs for RIP and RSP.  E.g. SVM
ignores the dirty bitmap entirely:

  static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
  {
	struct vcpu_svm *svm = to_svm(vcpu);

	trace_kvm_entry(vcpu);

	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];

	...

  }

And even for VMX, I can't imagine a nVMX test will ever be so performance
sensitive that an extra VMWRITE for RSP will be a problem.

> I prefer to keep it simple.

The issue is simplifying the assembly code increases the complexity of the users.
E.g. users and readers need to understand what "extra regs", which means documenting
what is included and what's not.  On the other hand, the assembly is already quite
complex, adding a few lines to swap RAX and RSP doesn't really change the overall
of complexity of that low level code.

The other bit of complexity is that if a test wants to access all GPRs, it needs
both this struct and the VMCB.  RSP is unlikely to be problematic, but I can see
guest.RAX being something a test wants access to.

> Plus there is also RSP in vmcb, and RFLAGS, and even RIP to some extent is a GPR.

RIP is definitely not a GPR, it has no assigned index.  RFLAGS is also not a GPR.

> To call this struct svm_gprs, I would have to include them there as well.

RAX and RSP are the only GPRs that need to be moved to/from the VMCB.  

> And also there is segment registers, etc, etc.

Which aren't GPRs.

> So instead of pretending that this struct contains all the GPRs of the guest
> (or host while guest is running) I renamed it to state that it contains only
> some gprs that SVM doesn't context switch.

...

> > > +               "xchg %%rdx, 0x10(%%" reg ")\n\t"       \
> > > +               "xchg %%rbp, 0x18(%%" reg ")\n\t"       \
> > > +               "xchg %%rsi, 0x20(%%" reg ")\n\t"       \
> > > +               "xchg %%rdi, 0x28(%%" reg ")\n\t"       \
> > > +               "xchg %%r8,  0x30(%%" reg ")\n\t"       \
> > > +               "xchg %%r9,  0x38(%%" reg ")\n\t"       \
> > > +               "xchg %%r10, 0x40(%%" reg ")\n\t"       \
> > > +               "xchg %%r11, 0x48(%%" reg ")\n\t"       \
> > > +               "xchg %%r12, 0x50(%%" reg ")\n\t"       \
> > > +               "xchg %%r13, 0x58(%%" reg ")\n\t"       \
> > > +               "xchg %%r14, 0x60(%%" reg ")\n\t"       \
> > > +               "xchg %%r15, 0x68(%%" reg ")\n\t"       \
> > > +               \
> > 
> > Extra line.
> > 
> > > +               "xchg %%rbx, 0x00(%%" reg ")\n\t"       \
> > 
> > Why is RBX last here, but first in the struct?  Ah, because the initial swap uses
> > RBX as the scratch register.  Why use RAX for the post-VMRUN swap?  AFAICT, that's
> > completely arbitrary.
> 
> Let me explain:
> 
> On entry to the guest the code has to save the host GPRs and then load the guest GPRs.
> 
> Host RAX and RBX are set by the gcc as I requested with "a" and "b"
> modifiers, but even these should not be changed by the assembly code from the
> values set in the input.
> (At least I haven't found a way to mark a register as both input and clobber)

The way to achive input+clobber is to use input+output, i.e. "+b" (regs), but I
think that's a moot point...

> Now RAX is the hardcoded input to VMRUN, thus I leave it alone, and use RBX
> as regs pointer, which is restored to the guest value (and host value stored
> in the regs) at the end of SWAP_GPRs.

...because SWAP_GPRs isn't the end of the asm blob.  As long as RBX holds the
same value (regs) at the end of the asm blob, no clobbering is necessary even if
RBX is changed within the blob.

> If I switch to full blown assembly function for this, then I could do it.
> 
> Note though that my LBR tests do still need this as a macro because they must
> not do any extra jumps/calls as these clobber the LBR registers.

Shouldn't it be fairly easy to account for the CALL in the asm routine?  Taking
on that sort of dependency is quite gross, but it'd likely be less maintenance
in the long run than an inline asm blob.
