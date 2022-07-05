Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A229D567038
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 16:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiGEOEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 10:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiGEOEW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 10:04:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD0C3329
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 06:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657029097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7grj8hnH4C0sUwXwqnyePg2Xo6Bva0CuD1fVB2K7TE=;
        b=NDakcGuZ9G8Ll129zb1BhljAVAg1LVLih4FDAnjpf09ESGDz9DZCRvQ8Jw/1S1lMoArTEm
        8OwDN9AfxwhU2wHnEzK1C2uKzuSstuS4zrlR+w9U0ch7OGuN6sQJohzaA5aeoDG9rZe4mb
        FT1QQeJ0ObXC0plXvVRHN7Ne4XaRC20=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586--uoCqThdP0mBIAo5Qp07_g-1; Tue, 05 Jul 2022 09:51:36 -0400
X-MC-Unique: -uoCqThdP0mBIAo5Qp07_g-1
Received: by mail-wm1-f71.google.com with SMTP id o28-20020a05600c511c00b003a04f97f27aso6783692wms.9
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 06:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=C7grj8hnH4C0sUwXwqnyePg2Xo6Bva0CuD1fVB2K7TE=;
        b=jiM7nk9kqglu58N8Gb69T5rpWHHjq5e46BSv2F3hd1TIKHRmh0wUyRFW5YNy72LHVc
         Rc1wF+xIkZT31CU7gRQ7KDZgCcFFtzLjVBA7C6kPcL+lfVZl5SfqWCgkwpA6NZ663ZV7
         CP4uHyYLMqNCghSF94dFXj4ucxHIB/0hLWymbDGXVT/JUmyUTAaSfkb1UR1wVGLdvKM1
         eaubVHbOAGVionktPvcn9bklCcgZye5iT9Zb1JaiXdJSFZKU2yGGePKFtAnNgPTLmwJE
         CS5BdERkcMEZ4s9CMBf1aJTb+kvhVXMPgw02KeCt145YEHM1AM0lj7dDrae/1LexdmQO
         m0Yg==
X-Gm-Message-State: AJIora8Q+JqMLAPpzzlFDJuRN5ZSU5KNy8M5nBUlvBvBYQfLU0qVJiEL
        J7j3I0vPKuaA+nVlI6PDRNHdSbvtdJ0ysalht9MJzu4KCBcW0G1tmalR8ARzC4mcBljJ+OImuJ9
        2TICHYUTDhLFx
X-Received: by 2002:a05:600c:b46:b0:3a0:4a51:bb1d with SMTP id k6-20020a05600c0b4600b003a04a51bb1dmr36611712wmr.168.1657029095501;
        Tue, 05 Jul 2022 06:51:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1susCwApoDKFaY/c4KCAXgaJ87QYoy5BbUireK2wPMeUaWbnuVtGAzyoVLGBy/fCDLbP4jmUQ==
X-Received: by 2002:a05:600c:b46:b0:3a0:4a51:bb1d with SMTP id k6-20020a05600c0b4600b003a04a51bb1dmr36611685wmr.168.1657029095229;
        Tue, 05 Jul 2022 06:51:35 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id c3-20020adfef43000000b0021bab0ba755sm34305443wrp.106.2022.07.05.06.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 06:51:34 -0700 (PDT)
Message-ID: <c225be91ef5f2de1e452b1612f3a0630304e00a6.camel@redhat.com>
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
Date:   Tue, 05 Jul 2022 16:51:32 +0300
In-Reply-To: <646d2f04bbc7530339ca02dcf5eeb3b5e298a1c2.camel@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-12-mlevitsk@redhat.com>
         <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
         <42da1631c8cdd282e5d9cfd0698b6df7deed2daf.camel@redhat.com>
         <CALMp9eRNZ8D5aRyUEkc7CORz-=bqzfVCSf6nOGZhqQfWfte0dw@mail.gmail.com>
         <289c2dd941ecbc3c32514fc0603148972524b22d.camel@redhat.com>
         <646d2f04bbc7530339ca02dcf5eeb3b5e298a1c2.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-05 at 16:40 +0300, Maxim Levitsky wrote:
> On Tue, 2022-07-05 at 16:38 +0300, Maxim Levitsky wrote:
> > On Thu, 2022-06-30 at 09:00 -0700, Jim Mattson wrote:
> > > On Wed, Jun 29, 2022 at 11:00 PM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > 
> > > > On Wed, 2022-06-29 at 09:31 -0700, Jim Mattson wrote:
> > > > > On Tue, Jun 21, 2022 at 8:09 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > > > When #SMI is asserted, the CPU can be in interrupt shadow
> > > > > > due to sti or mov ss.
> > > > > > 
> > > > > > It is not mandatory in  Intel/AMD prm to have the #SMI
> > > > > > blocked during the shadow, and on top of
> > > > > > that, since neither SVM nor VMX has true support for SMI
> > > > > > window, waiting for one instruction would mean single stepping
> > > > > > the guest.
> > > > > > 
> > > > > > Instead, allow #SMI in this case, but both reset the interrupt
> > > > > > window and stash its value in SMRAM to restore it on exit
> > > > > > from SMM.
> > > > > > 
> > > > > > This fixes rare failures seen mostly on windows guests on VMX,
> > > > > > when #SMI falls on the sti instruction which mainfest in
> > > > > > VM entry failure due to EFLAGS.IF not being set, but STI interrupt
> > > > > > window still being set in the VMCS.
> > > > > 
> > > > > I think you're just making stuff up! See Note #5 at
> > > > > https://sandpile.org/x86/inter.htm.
> > > > > 
> > > > > Can you reference the vendors' documentation that supports this change?
> > > > > 
> > > > 
> > > > First of all, just to note that the actual issue here was that
> > > > we don't clear the shadow bits in the guest interruptability field
> > > > in the vmcb on SMM entry, that triggered a consistency check because
> > > > we do clear EFLAGS.IF.
> > > > Preserving the interrupt shadow is just nice to have.
> > > > 
> > > > 
> > > > That what Intel's spec says for the 'STI':
> > > > 
> > > > "The IF flag and the STI and CLI instructions do not prohibit the generation of exceptions and nonmaskable inter-
> > > > rupts (NMIs). However, NMIs (and system-management interrupts) may be inhibited on the instruction boundary
> > > > following an execution of STI that begins with IF = 0."
> > > > 
> > > > Thus it is likely that #SMI are just blocked when in shadow, but it is easier to implement
> > > > it this way (avoids single stepping the guest) and without any user visable difference,
> > > > which I noted in the patch description, I noted that there are two ways to solve this,
> > > > and preserving the int shadow in SMRAM is just more simple way.
> > > 
> > > It's not true that there is no user-visible difference. In your
> > > implementation, the SMI handler can see that the interrupt was
> > > delivered in the interrupt shadow.
> > 
> > Most of the SMI save state area is reserved, and the handler has no way of knowing
> > what CPU stored there, it can only access the fields that are reserved in the spec.
> I mean fields that are not reserved in the spec.
> 
> Best regards,
>         Maxim Levitsky
> > 
> > Yes, if the SMI handler really insists it can see that the saved RIP points to an
> > instruction that follows the STI, but does that really matter? It is allowed by the
> > spec explicitly anyway.
> > 
> > Plus our SMI layout (at least for 32 bit) doesn't confirm to the X86 spec anyway,
> > we as I found out flat out write over the fields that have other meaning in the X86 spec.
> > 
> > Also I proposed to preserve the int shadow in internal kvm state and migrate
> > it in upper 4 bits of the 'shadow' field of struct kvm_vcpu_events.
> > Both Paolo and Sean proposed to store the int shadow in the SMRAM instead,
> > and you didn't object to this, and now after I refactored and implemented
> > the whole thing you suddently do.
> > 
> > BTW, just FYI, I found out that qemu doesn't migrate the 'shadow' field,
> > this needs to be fixed (not related to the issue, just FYI).
> > 
> > > 
> > > The right fix for this problem is to block SMI in an interrupt shadow,
> > > as is likely the case for all modern CPUs.
> > 
> > Yes, I agree that this is the most correct fix. 
> > 
> > However AMD just recently posted a VNMI patch series to avoid
> > single stepping the CPU when NMI is blocked due to the same reason, because
> > it is fragile.
> > 
> > Do you really want KVM to single step the guest in this case, to deliver the #SMI?
> > I can do it, but it is bound to cause lot of trouble.
> > 
> > Note that I will have to do it on both Intel and AMD, as neither has support for SMI
> > window, unless I were to use MTF, which is broken on nested virt as you know,
> > so a nested hypervisor running a guest with SMI will now have to cope with broken MTF.
> > 
> > Note that I can't use the VIRQ hack we use for interrupt window, because there
> > is no guarantee that the guest's EFLAGS.IF is on.
> > 
> > Best regards,   
> >         Maxim Levitsky
> > 
> > > 
> > > > 
> > > > As for CPUS that neither block SMI nor preserve the int shadaw, in theory they can, but that would
> > > > break things, as noted in this mail
> > > > 
> > > > https://lore.kernel.org/lkml/1284913699-14986-1-git-send-email-avi@redhat.com/
> > > > 
> > > > It is possible though that real cpu supports HLT restart flag, which makes this a non issue,
> > > > still. I can't rule out that a real cpu doesn't preserve the interrupt shadow on SMI, but
> > > > I don't see why we can't do this to make things more robust.
> > > 
> > > Because, as I said, I think you're just making stuff up...unless, of
> > > course, you have documentation to back this up.

Again, I clearly explained that I choose to implement it this way because it
is more robust, _and_ it was approved by both Sean and Paolo. 

It is not called making stuff up - I never claimed that a real
CPU does it this way.

Best regards,
	Maxim Levitsky

> > > 
> > 
> 
> 


