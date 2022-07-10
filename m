Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E66956CFEB
	for <lists+kvm@lfdr.de>; Sun, 10 Jul 2022 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGJQFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Jul 2022 12:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGJQFw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Jul 2022 12:05:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AED135F7D
        for <kvm@vger.kernel.org>; Sun, 10 Jul 2022 09:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657469150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wskyByu9vfUYbXwLovGZiKAunGMntFPKpAVJnY9YMJY=;
        b=EILpvXyktq3ri+YKSfRqOPzoYC32QHuuUjnmdsQUBJKtgKTF70VjAtCc3eK5MkogqdS7rr
        HdrSTzv7lG1ynPfrmtFxJs25PvGjZ8363lz/06w4SgGNLmcU8xCxy5DErYDDAQe/8Mk5Cd
        o+YSh3M/tNN8KeVTtvaycvmBUrWXUCc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-9CLLJVfWONOGbR3ctIFSjw-1; Sun, 10 Jul 2022 12:05:47 -0400
X-MC-Unique: 9CLLJVfWONOGbR3ctIFSjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FAA9101AA45;
        Sun, 10 Jul 2022 16:05:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 471BB40D296C;
        Sun, 10 Jul 2022 16:05:43 +0000 (UTC)
Message-ID: <14748580cc4b03f84b6fcdce14d33776fc8c75ae.camel@redhat.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Sun, 10 Jul 2022 19:05:42 +0300
In-Reply-To: <CALMp9eRCV187TsdnOr9PWo+MMNT71+2uU8YNvc89EBgYYvxRQQ@mail.gmail.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-12-mlevitsk@redhat.com>
         <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
         <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
         <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
         <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
         <CALMp9eS2gxzWU1+OpfBTqCZsmyq8qoCW_Qs84xv=rGo1ranG1Q@mail.gmail.com>
         <5ff3c2b4712f6446d2c1361315b972ddad48836f.camel@redhat.com>
         <CALMp9eRCV187TsdnOr9PWo+MMNT71+2uU8YNvc89EBgYYvxRQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 13:38 -0700, Jim Mattson wrote:
> On Wed, Jul 6, 2022 at 1:00 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Wed, 2022-07-06 at 11:13 -0700, Jim Mattson wrote:
> > > On Tue, Jul 5, 2022 at 6:38 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> ...
> > > > Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> > > > we as I found out flat out write over the fields that have other meaning in the X86 spec.
> > > 
> > > Shouldn't we fix that?
> > I am afraid we can't because that will break (in theory) the backward compatibility
> > (e.g if someone migrates a VM while in SMM).
> 
> Every time someone says, "We can't fix this, because it breaks
> backward compatibility," I think, "Another potential use of
> KVM_CAP_DISABLE_QUIRKS2?"
> 
> ...
> > But then after looking at SDM I also found out that Intel and AMD have completely
> > different SMM layout for 64 bit. We follow the AMD's layout, but we don't
> > implement many fields, including some that are barely/not documented.
> > (e.g what is svm_guest_virtual_int?)
> > 
> > In theory we could use Intel's layout when we run with Intel's vendor ID,
> > and AMD's vise versa, but we probably won't bother + once again there
> > is an issue of backward compatibility.
> 
> This seems pretty egregious, since the SDM specifically states, "Some
> of the registers in the SMRAM state save area (marked YES in column 3)
> may be read and changed by the
> SMI handler, with the changed values restored to the processor
> registers by the RSM instruction." How can that possibly work with
> AMD's layout?
> (See my comment above regarding backwards compatibility.)
> 
> <soapbox>I wish KVM would stop offering virtual CPU features that are
> completely broken.</soapbox>
> 
> > > The vNMI feature isn't available in any shipping processor yet, is it?
> > Yes, but one of its purposes is to avoid single stepping the guest,
> > which is especially painful on AMD, because there is no MTF, so
> > you have to 'borrow' the TF flag in the EFLAGS, and that can leak into
> > the guest state (e.g pushed onto the stack).
> 
> So, what's the solution for all of today's SVM-capable processors? KVM
> will probably be supporting AMD CPUs without vNMI for the next decade
> or two.

I did some homework on this a few months ago so here it goes:

First of all lets assume that GIF is set, because when clear, we just
intercept STGI to deliver #NMI there. Same for #SMI.
GIF is easy in other words in regard to interrupt window.

So it works like that:

When we inject #NMI, we enable IRET intercept (in svm_inject_nmi)
As long as we didn't hit IRET, that is our NMI window, so
enable_nmi_window does nothing.

We also mark this situation with

vcpu->arch.hflags |= HF_NMI_MASK;

This means that we are in NMI, but haven't yet
seen IRET.

When we hit IRET interception which is fault like interception,
we are still in NMI, until IRET completes.

We mark this situaion with 

vcpu->arch.hflags |= HF_IRET_MASK;

Now both HF_NMI_MASK and HF_IRET_MASK are set.


If at that point someone enables NMI window,
the NMI window code (enable_nmi_window) detects the 
(HF_NMI_MASK | HF_IRET_MASK), enables single stepping,
and remembers current RIP.


Finally svm_complete_interrupts (which is called on each vm exit)
notices the HF_IRET_MASK flag, and if set, and RIP is not the same as
it was when we enabled single stepping, then it clears the HF_NMI_MASK
and raises KVM_REQ_EVENT to possibly inject now an another NMI.

Of course if for example the IRET gets an exception (or even interrupt
since EFLAGS.IF can be set), then TF flag we force enabled will be pushed
onto the exception stack and leaked to the guest which is not nice.


Note that the same problem doesn't happen with STGI interception,
because unlike IRET, we fully emulate STGI, so upon completion of emulation
of it, the NMI window is open.

IF we could fully emualate IRET, we could have done the same with it as well,
but it is hard, and of course in the case of skipping over the interrupt shadow,
we would have to emulate *any* instruction which happens to be there,
which is not feasable at all for the KVM's emulator.


That also doesn't work with SEV-ES, due to encrypted nature of the guest
(but then emulated SMM won't work either), I guess this is another reason
for vNMI feature.

TL;DR - on #NMI injection we intercept IRET, and rely on its interception
to signal the almost start of the NMI window, but this still leaves a short
window of executing the IRET itself during which NMIs are still blocked,
so we have to single step over it.

Note that there is no issue with interrupt shadow here because NMI doesn't
respect it.



> 
> 
> > (Actually looking at clause of default treatment of SMIs in Intel's PRM,
> > they do mention that they preserve the int shadow somewhere at least
> > on some Intel's CPUs).
> 
> Yes, this is a required part of VMX-critical state for processors that
> support SMI recognition while there is blocking by STI or by MOV SS.
> However, I don't believe that KVM actually saves VMX-critical state on
> delivery of a virtual SMI.

Yes, but that does suggest that older cpus which allowed SMI in interrupt
shadow did preserve it *somewhere* Its also not a spec violation to preserve it
in this way.

> 
> > BTW, according to my observations, it is really hard to hit this problem,
> > because it looks like when the CPU is in interrupt shadow, it doesn't process
> > _real_ interrupts as well (despite the fact that in VM, real interrupts
> > should never be blocked(*), but yet, that is what I observed on both AMD and Intel.
> > 
> > (*) You can allow the guest to control the real EFLAGS.IF on both VMX and SVM,
> > (in which case int shadow should indeed work as on bare metal)
> > but KVM of course doesn't do it.
> 
> It doesn't surprise me that hardware treats a virtual interrupt shadow
> as a physical interrupt shadow. IIRC, each vendor has a way of
> breaking an endless chain of interrupt shadows, so a malicious guest
> can't defer interrupts indefinitely.

Thankfully a malicious guest can't abuse the STI interrupt shadow this way I think
because STI interrupt shadow is only valid if the STI actually enables the EFLAGS.IF.
If it was already set, there is no shadow.

I don't know how they deal with repeated MOV SS instruction. Maybe this one
doesn't enable real interrupt shadow, or also doesn't enable shadow if
the shadow is already enabled, I don't know.

> 
> > I observed that when KVM sends #SMI from other vCPU, it sends a vCPU kick,
> > and the kick never arrives inside the interrupt shadow.
> > I have seen it on both VMX and SVM.
> > 
> > What still triggers this problem, is that the instruction which is in the interrupt
> > shadow can still get a VM exit, (e.g EPT/NPT violation) and then it can notice
> > the pending SMI.
> > 
> > I think it has to be EPT/NPT violation btw, because, IMHO most if not all other VM exits I
> > think are instruction intercepts, which will cause KVM to emulate the instruction
> > and clear the interrupt shadow, and only after that it will enter SMM.
> > 
> > Even MMIO/IOPORT access is emulated by the KVM.
> > 
> > Its not the case with EPT/NPT violation, because the KVM will in this case re-execute
> > the instruction after it 'fixes' the fault.
> 
> Probably #PF as well, then, if TDP is disabled.

Yep no doubt about it.

Also come to think about it, we also intercept #AC and just forward it to the guest,
and since we let the instruction to be re-executed that won't clear the interrupt
shadow either.
#UD is also intercepted, and if the emulator can't emulate it, it should also be forwarded
to the guest. That gives me an idea to improve my test by sticking an UD2 there.
I'll take a look.


Best regards,
	Maxim Levitsky

> 




