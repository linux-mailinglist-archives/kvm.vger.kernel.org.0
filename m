Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1246F37B30C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 02:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhELAj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 20:39:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhELAj2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 20:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620779901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I5KCa3tAvRSf1VRNUE9AphYEGmmcC0JJgr+iFRPwz0=;
        b=GIxQGNmGkxlnjJI+cimXhjHablLTO4yucY7l7MIHfttyR5mcdRPOXpobCZ4blCIsiq8xjT
        NenibZ4OPSdhI+W/GjxLLixM7cCjb+M38mKLfIArcfqiGjjX3WiWZNQwTROb9YvfUUXBSD
        WC7iXjRdpWSD4uC5ATcCYiBDLRQNKgg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-7pF4bCRCPn2c8IHmSo6ERQ-1; Tue, 11 May 2021 20:38:19 -0400
X-MC-Unique: 7pF4bCRCPn2c8IHmSo6ERQ-1
Received: by mail-qt1-f197.google.com with SMTP id i12-20020ac860cc0000b02901cb6d022744so14208556qtm.20
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 17:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5I5KCa3tAvRSf1VRNUE9AphYEGmmcC0JJgr+iFRPwz0=;
        b=mui2NpR28OFEBff220TFh2Dq6auxlkOz2jPAZHLOi7+w3qcYNHyFEQ5nQnB3njKlM4
         TqkLuUajOfnK7TPfJThIpYQYiuWZEjTmZtIQuEcTidTMgoRSekwqn1GR1ME+R4jeB1E7
         nl4QsZyExnj58oyiGpdi14niN1KwZjWjNdGL/b0gUCVvDSvxgUS733v//qAAF4hDv2BF
         Vz33ckXtYsXEsmQaOztSiE14w897kB8FTzLGxJbj0YYFrodfUrT6xLseNZ4uolmFWNS1
         jMD33BNw+SEAX3JmvoTsRSxGhh4HsrmUTqFjpsvEOeS5rAX0ENVR7p4Eiyc9nXMVHpUk
         eesg==
X-Gm-Message-State: AOAM533iFt2hhR4U73yewxRCXhV1Ew/71ineZxwLMPIrzVOi5E2zw5m1
        nVHHAgZz0UuFL0dVK5eYo5SDfYMJFSY4z0/jOF2MC40gWRAdV4hk/AgtV2+FAKwPWU9DzuLRMxE
        XXMOOy81YtF4c
X-Received: by 2002:a05:620a:5a7:: with SMTP id q7mr30287148qkq.326.1620779898725;
        Tue, 11 May 2021 17:38:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNRzxIfWjLECkGH60yYTEo6ShWVhW68iDejN7rTc7F+WyCgss1enP7n0PKu3aLclhsGO+PCA==
X-Received: by 2002:a05:620a:5a7:: with SMTP id q7mr30287128qkq.326.1620779898352;
        Tue, 11 May 2021 17:38:18 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id r10sm15829917qke.9.2021.05.11.17.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 17:38:17 -0700 (PDT)
Date:   Tue, 11 May 2021 20:38:16 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJsjeEl80KzAXNFE@t490s>
References: <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
 <20210511235124.GA187296@fuller.cnet>
 <20210512000259.GA192145@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210512000259.GA192145@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 09:02:59PM -0300, Marcelo Tosatti wrote:
> On Tue, May 11, 2021 at 08:51:24PM -0300, Marcelo Tosatti wrote:
> > On Tue, May 11, 2021 at 05:35:41PM -0400, Peter Xu wrote:
> > > On Tue, May 11, 2021 at 02:18:10PM -0300, Marcelo Tosatti wrote:
> > > > On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> > > > > On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > > > > > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > > > > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > > > > > 
> > > > > > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > > > > > {
> > > > > > > >         int ret = -EINTR;
> > > > > > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > > > > 
> > > > > > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > > > > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > > > > > >                 goto out;
> > > > > > > >         }
> > > > > > > > 
> > > > > > > > Don't want to unhalt the vcpu.
> > > > > > > 
> > > > > > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > > > > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > > > > > shouldn't we stop halting?  Thanks!
> > > > > > 
> > > > > > pi_test_on() only returns true when an interrupt is signalled by the
> > > > > > device. But the sequence of events is:
> > > > > > 
> > > > > > 
> > > > > > 1. pCPU idles without notification vector configured to wakeup vector.
> > > > > > 
> > > > > > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > > > > > 
> > > > > > <arbitrary amount of time>
> > > > > > 
> > > > > > 3. device generates interrupt, sets ON bit to true in the posted
> > > > > > interrupt descriptor.
> > > > > > 
> > > > > > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > > > > > is not set).
> > > > > 
> > > > > Ah yes.. thanks.
> > > > > 
> > > > > Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> > > > > define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> > > > > 
> > > > > #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> > > > > 
> > > > > We can set it in vmx_pi_start_assignment(), then check+clear it in
> > > > > kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).
> > > > 
> > > > Can't check it in kvm_vcpu_has_events() because that will set
> > > > KVM_REQ_UNHALT (which we don't want).
> > > 
> > > I thought it was okay to break the guest HLT? 
> > 
> > Intel:
> > 
> > "HLT-HALT
> > 
> > Description
> > 
> > Stops instruction execution and places the processor in a HALT state. An enabled interrupt (including NMI and
> > SMI), a debug exception, the BINIT# signal, the INIT# signal, or the RESET# signal will resume execution. If an
> > interrupt (including NMI) is used to resume execution after a HLT instruction, the saved instruction pointer
> > (CS:EIP) points to the instruction following the HLT instruction."
> > 
> > AMD:
> > 
> > "6.5 Processor Halt
> > The processor halt instruction (HLT) halts instruction execution, leaving the processor in the halt state.
> > No registers or machine state are modified as a result of executing the HLT instruction. The processor
> > remains in the halt state until one of the following occurs:
> > • A non-maskable interrupt (NMI).
> > • An enabled, maskable interrupt (INTR).
> > • Processor reset (RESET).
> > • Processor initialization (INIT).
> > • System-management interrupt (SMI)."
> > 
> > The KVM_REQ_UNBLOCK patch will resume execution even any such event
> 
> 						  even without any such event
> 
> > occuring. So the behaviour would be different from baremetal.
> 

What if we move that kvm_check_request() into kvm_vcpu_check_block()?

---8<---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 739e1bd59e8a9..e6fee59b5dab6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11177,9 +11177,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
             static_call(kvm_x86_smi_allowed)(vcpu, false)))
                return true;
 
-       if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
-               return true;
-
        if (kvm_arch_interrupt_allowed(vcpu) &&
            (kvm_cpu_has_interrupt(vcpu) ||
            kvm_guest_apic_has_interrupt(vcpu)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f68035355c08a..fc5f6bffff7fc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2925,6 +2925,10 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
                kvm_make_request(KVM_REQ_UNHALT, vcpu);
                goto out;
        }
+#ifdef CONFIG_X86
+       if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
+               return true;
+#endif
        if (kvm_cpu_has_pending_timer(vcpu))
                goto out;
        if (signal_pending(current))
---8<---

(The CONFIG_X86 is ugly indeed.. but just to show what I meant, e.g. it can be
 a boolean too I think)

Would this work?

Thanks,

-- 
Peter Xu

