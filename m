Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2700F37B2E7
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 02:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhELAEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 20:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhELAEU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 20:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620777793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o28x/OKYm7tBWvEEr/pyKjQeOAbwiNgjI/cKoifdFc4=;
        b=cXWtvoFUNJ5HqrOe0UvHReFrDCy4AICzTtfS0AKwf3FcxSObfSmGuFVM+XOiYelmlRHBbX
        VVOlmVLfws93F18vqJTg4CEWPM0g4rbVTkHbhxvd2aWHXKYISRXzwJVXIQU4QgdaJzqcum
        DLsTeXh44gUAzQ03yx78NkIdAOS7KjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-mHbqyFlhO-2ks3hn5ZRxyg-1; Tue, 11 May 2021 20:03:11 -0400
X-MC-Unique: mHbqyFlhO-2ks3hn5ZRxyg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A1AD801106;
        Wed, 12 May 2021 00:03:10 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0020B5D9C0;
        Wed, 12 May 2021 00:03:02 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id AE0A6406ED74; Tue, 11 May 2021 21:02:59 -0300 (-03)
Date:   Tue, 11 May 2021 21:02:59 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210512000259.GA192145@fuller.cnet>
References: <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
 <20210511235124.GA187296@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210511235124.GA187296@fuller.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 08:51:24PM -0300, Marcelo Tosatti wrote:
> On Tue, May 11, 2021 at 05:35:41PM -0400, Peter Xu wrote:
> > On Tue, May 11, 2021 at 02:18:10PM -0300, Marcelo Tosatti wrote:
> > > On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> > > > On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > > > > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > > > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > > > > 
> > > > > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > > > > {
> > > > > > >         int ret = -EINTR;
> > > > > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > > > > 
> > > > > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > > > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > > > > >                 goto out;
> > > > > > >         }
> > > > > > > 
> > > > > > > Don't want to unhalt the vcpu.
> > > > > > 
> > > > > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > > > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > > > > shouldn't we stop halting?  Thanks!
> > > > > 
> > > > > pi_test_on() only returns true when an interrupt is signalled by the
> > > > > device. But the sequence of events is:
> > > > > 
> > > > > 
> > > > > 1. pCPU idles without notification vector configured to wakeup vector.
> > > > > 
> > > > > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > > > > 
> > > > > <arbitrary amount of time>
> > > > > 
> > > > > 3. device generates interrupt, sets ON bit to true in the posted
> > > > > interrupt descriptor.
> > > > > 
> > > > > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > > > > is not set).
> > > > 
> > > > Ah yes.. thanks.
> > > > 
> > > > Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> > > > define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> > > > 
> > > > #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> > > > 
> > > > We can set it in vmx_pi_start_assignment(), then check+clear it in
> > > > kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).
> > > 
> > > Can't check it in kvm_vcpu_has_events() because that will set
> > > KVM_REQ_UNHALT (which we don't want).
> > 
> > I thought it was okay to break the guest HLT? 
> 
> Intel:
> 
> "HLT-HALT
> 
> Description
> 
> Stops instruction execution and places the processor in a HALT state. An enabled interrupt (including NMI and
> SMI), a debug exception, the BINIT# signal, the INIT# signal, or the RESET# signal will resume execution. If an
> interrupt (including NMI) is used to resume execution after a HLT instruction, the saved instruction pointer
> (CS:EIP) points to the instruction following the HLT instruction."
> 
> AMD:
> 
> "6.5 Processor Halt
> The processor halt instruction (HLT) halts instruction execution, leaving the processor in the halt state.
> No registers or machine state are modified as a result of executing the HLT instruction. The processor
> remains in the halt state until one of the following occurs:
> • A non-maskable interrupt (NMI).
> • An enabled, maskable interrupt (INTR).
> • Processor reset (RESET).
> • Processor initialization (INIT).
> • System-management interrupt (SMI)."
> 
> The KVM_REQ_UNBLOCK patch will resume execution even any such event

						  even without any such event

> occuring. So the behaviour would be different from baremetal.

