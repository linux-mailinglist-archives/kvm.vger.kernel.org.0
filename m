Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379845692F2
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiGFUAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiGFUAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 16:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 792E1E73
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 13:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657137618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NavUkjTqIPAIXQj2Xma2uXjQ+LwLq07RgdZpvR+aqyk=;
        b=ThHdNVv23gnnMi3Vgm/PruB2h2uLEB5TJ9PzgvAEjyr9Kgb+onAJoeDh7JBKgGZbK3rISG
        0ApipOR8k1kpxIIUTuy8gjQ8MoU+EVKqErYWYs+7ClmzFYFwrpCv4Xvwi0bjq610+YrXFb
        zKRKv+XuzyDOXjTGylQt71j70LS5Im0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-d-zrfhtfO3Wk0NvgyGMDzg-1; Wed, 06 Jul 2022 16:00:14 -0400
X-MC-Unique: d-zrfhtfO3Wk0NvgyGMDzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEDA68339C5;
        Wed,  6 Jul 2022 20:00:13 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8565C18ECB;
        Wed,  6 Jul 2022 20:00:09 +0000 (UTC)
Message-ID: <5ff3c2b4712f6446d2c1361315b972ddad48836f.camel@redhat.com>
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
Date:   Wed, 06 Jul 2022 23:00:08 +0300
In-Reply-To: <CALMp9eS2gxzWU1+OpfBTqCZsmyq8qoCW_Qs84xv=rGo1ranG1Q@mail.gmail.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-12-mlevitsk@redhat.com>
         <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
         <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
         <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
         <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
         <CALMp9eS2gxzWU1+OpfBTqCZsmyq8qoCW_Qs84xv=rGo1ranG1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 11:13 -0700, Jim Mattson wrote:
> On Tue, Jul 5, 2022 at 6:38 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > Most of the SMI save state area is reserved, and the handler has no way of knowing
> > what CPU stored there, it can only access the fields that are reserved in the spec.
> > 
> > Yes, if the SMI handler really insists it can see that the saved RIP points to an
> > instruction that follows the STI, but does that really matter? It is allowed by the
> > spec explicitly anyway.
> 
> I was just pointing out that the difference between blocking SMI and
> not blocking SMI is, in fact, observable.

Yes, and I agree, I should have said that while observable,
it should cause no problem.


> 
> > Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> > we as I found out flat out write over the fields that have other meaning in the X86 spec.
> 
> Shouldn't we fix that?
I am afraid we can't because that will break (in theory) the backward compatibility
(e.g if someone migrates a VM while in SMM).

Plus this is only for 32 bit layout which is only used when the guest has no long
mode in CPUID, which is only used these days by 32 bit qemu 

(I found it the hard way when I found that SMM with a nested guest doesn't work
for me on 32 bit, and it was because the KVM doesn't bother to save/restore the
running nested guest vmcb address, when we use 32 bit SMM layout, which makes
sense because truly 32 bit only AMD cpus likely didn't had SVM).

But then after looking at SDM I also found out that Intel and AMD have completely
different SMM layout for 64 bit. We follow the AMD's layout, but we don't
implement many fields, including some that are barely/not documented.
(e.g what is svm_guest_virtual_int?)

In theory we could use Intel's layout when we run with Intel's vendor ID,
and AMD's vise versa, but we probably won't bother + once again there
is an issue of backward compatibility.

Feel free to look at the patch series, I documented fully the SMRAM layout
that KVM uses, including all the places when it differs from the real
thing.


> 
> > Also I proposed to preserve the int shadow in internal kvm state and migrate
> > it in upper 4 bits of the 'shadow' field of struct kvm_vcpu_events.
> > Both Paolo and Sean proposed to store the int shadow in the SMRAM instead,
> > and you didn't object to this, and now after I refactored and implemented
> > the whole thing you suddently do.
> 
> I did not see the prior conversations. I rarely get an opportunity to
> read the list.
I understand.

> 
> > However AMD just recently posted a VNMI patch series to avoid
> > single stepping the CPU when NMI is blocked due to the same reason, because
> > it is fragile.
> 
> The vNMI feature isn't available in any shipping processor yet, is it?
Yes, but one of its purposes is to avoid single stepping the guest,
which is especially painful on AMD, because there is no MTF, so
you have to 'borrow' the TF flag in the EFLAGS, and that can leak into
the guest state (e.g pushed onto the stack).


> 
> > Do you really want KVM to single step the guest in this case, to deliver the #SMI?
> > I can do it, but it is bound to cause lot of trouble.
> 
> Perhaps you could document this as a KVM erratum...one of many
> involving virtual SMI delivery.

Absolutely, I can document that we choose to save/restore the int shadow in
SMRAM, something that CPUs usually don't really do, but happens to be the best way
to deal with this corner case.

(Actually looking at clause of default treatment of SMIs in Intel's PRM,
they do mention that they preserve the int shadow somewhere at least
on some Intel's CPUs).


BTW, according to my observations, it is really hard to hit this problem,
because it looks like when the CPU is in interrupt shadow, it doesn't process
_real_ interrupts as well (despite the fact that in VM, real interrupts
should never be blocked(*), but yet, that is what I observed on both AMD and Intel.

(*) You can allow the guest to control the real EFLAGS.IF on both VMX and SVM,
(in which case int shadow should indeed work as on bare metal)
but KVM of course doesn't do it.

I observed that when KVM sends #SMI from other vCPU, it sends a vCPU kick,
and the kick never arrives inside the interrupt shadow.
I have seen it on both VMX and SVM.

What still triggers this problem, is that the instruction which is in the interrupt
shadow can still get a VM exit, (e.g EPT/NPT violation) and then it can notice
the pending SMI.

I think it has to be EPT/NPT violation btw, because, IMHO most if not all other VM exits I 
think are instruction intercepts, which will cause KVM to emulate the instruction 
and clear the interrupt shadow, and only after that it will enter SMM.

Even MMIO/IOPORT access is emulated by the KVM.

Its not the case with EPT/NPT violation, because the KVM will in this case re-execute
the instruction after it 'fixes' the fault.

Best regards,
	Maxim Levitsky



> 


