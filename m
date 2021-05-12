Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F87B37BC28
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhELMA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 08:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230178AbhELMA1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 08:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620820759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPzYqFqAJkTs7cOFqUIQhzc+Cz5mbywAGDvmfIHlGHI=;
        b=JFhhXAmUuk++zK/VKuw4clOwRr61sUNje6G5NWxJWmMhBqSEzbWviQWe7oSbPTdgeUyiaO
        Br1t5ujrTQ6gyz8oRqIXMyC1kiSvCJJGL1/S+roWhyKuVDNXz1UDC5Ypltu/DOgcSooKVs
        RWzuQQzpsf8s06qHfxHKNPlbuQ8zcI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-ymXRmXDlOzGk9qoWUzgPwQ-1; Wed, 12 May 2021 07:59:17 -0400
X-MC-Unique: ymXRmXDlOzGk9qoWUzgPwQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2774107ACCA;
        Wed, 12 May 2021 11:59:16 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-5.gru2.redhat.com [10.97.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1DE42C240;
        Wed, 12 May 2021 11:59:09 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id BDD5740B1FA0; Wed, 12 May 2021 08:10:10 -0300 (-03)
Date:   Wed, 12 May 2021 08:10:10 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210512111010.GA232673@fuller.cnet>
References: <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
 <20210511235124.GA187296@fuller.cnet>
 <20210512000259.GA192145@fuller.cnet>
 <YJsjeEl80KzAXNFE@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YJsjeEl80KzAXNFE@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 08:38:16PM -0400, Peter Xu wrote:
> On Tue, May 11, 2021 at 09:02:59PM -0300, Marcelo Tosatti wrote:
> > On Tue, May 11, 2021 at 08:51:24PM -0300, Marcelo Tosatti wrote:
> > > On Tue, May 11, 2021 at 05:35:41PM -0400, Peter Xu wrote:
> > > > On Tue, May 11, 2021 at 02:18:10PM -0300, Marcelo Tosatti wrote:
> > > > > On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> > > > > > On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > > > > > > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > > > > > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > > > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > > > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > > > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > > > > > > 
> > > > > > > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > > > > > > {
> > > > > > > > >         int ret = -EINTR;
> > > > > > > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > > > > > 
> > > > > > > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > > > > > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > > > > > > >                 goto out;
> > > > > > > > >         }
> > > > > > > > > 
> > > > > > > > > Don't want to unhalt the vcpu.
> > > > > > > > 
> > > > > > > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > > > > > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > > > > > > shouldn't we stop halting?  Thanks!
> > > > > > > 
> > > > > > > pi_test_on() only returns true when an interrupt is signalled by the
> > > > > > > device. But the sequence of events is:
> > > > > > > 
> > > > > > > 
> > > > > > > 1. pCPU idles without notification vector configured to wakeup vector.
> > > > > > > 
> > > > > > > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > > > > > > 
> > > > > > > <arbitrary amount of time>
> > > > > > > 
> > > > > > > 3. device generates interrupt, sets ON bit to true in the posted
> > > > > > > interrupt descriptor.
> > > > > > > 
> > > > > > > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > > > > > > is not set).
> > > > > > 
> > > > > > Ah yes.. thanks.
> > > > > > 
> > > > > > Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> > > > > > define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> > > > > > 
> > > > > > #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> > > > > > 
> > > > > > We can set it in vmx_pi_start_assignment(), then check+clear it in
> > > > > > kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).
> > > > > 
> > > > > Can't check it in kvm_vcpu_has_events() because that will set
> > > > > KVM_REQ_UNHALT (which we don't want).
> > > > 
> > > > I thought it was okay to break the guest HLT? 
> > > 
> > > Intel:
> > > 
> > > "HLT-HALT
> > > 
> > > Description
> > > 
> > > Stops instruction execution and places the processor in a HALT state. An enabled interrupt (including NMI and
> > > SMI), a debug exception, the BINIT# signal, the INIT# signal, or the RESET# signal will resume execution. If an
> > > interrupt (including NMI) is used to resume execution after a HLT instruction, the saved instruction pointer
> > > (CS:EIP) points to the instruction following the HLT instruction."
> > > 
> > > AMD:
> > > 
> > > "6.5 Processor Halt
> > > The processor halt instruction (HLT) halts instruction execution, leaving the processor in the halt state.
> > > No registers or machine state are modified as a result of executing the HLT instruction. The processor
> > > remains in the halt state until one of the following occurs:
> > > • A non-maskable interrupt (NMI).
> > > • An enabled, maskable interrupt (INTR).
> > > • Processor reset (RESET).
> > > • Processor initialization (INIT).
> > > • System-management interrupt (SMI)."
> > > 
> > > The KVM_REQ_UNBLOCK patch will resume execution even any such event
> > 
> > 						  even without any such event
> > 
> > > occuring. So the behaviour would be different from baremetal.
> > 
> 
> What if we move that kvm_check_request() into kvm_vcpu_check_block()?
> 
> ---8<---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 739e1bd59e8a9..e6fee59b5dab6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11177,9 +11177,6 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>              static_call(kvm_x86_smi_allowed)(vcpu, false)))
>                 return true;
>  
> -       if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> -               return true;
> -
>         if (kvm_arch_interrupt_allowed(vcpu) &&
>             (kvm_cpu_has_interrupt(vcpu) ||
>             kvm_guest_apic_has_interrupt(vcpu)))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f68035355c08a..fc5f6bffff7fc 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2925,6 +2925,10 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>                 kvm_make_request(KVM_REQ_UNHALT, vcpu);
>                 goto out;
>         }
> +#ifdef CONFIG_X86
> +       if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
> +               return true;
> +#endif
>         if (kvm_cpu_has_pending_timer(vcpu))
>                 goto out;
>         if (signal_pending(current))
> ---8<---
> 
> (The CONFIG_X86 is ugly indeed.. but just to show what I meant, e.g. it can be
>  a boolean too I think)
> 
> Would this work?

That would work: but vcpu->requests are nicely checked (and processed) 
at vcpu_enter_guest, before guest entry. The proposed request does not 
follow that pattern.

