Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBA037AD1F
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhEKRaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:30:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhEKRaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 13:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620754158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R8Jfx2u6beGznuNa8djJTksGxj/j6Y+RV0TOPVHrWLI=;
        b=LJlkkZ6qRqPKYpvVsd6u58xo8BGvKRZfl6Z3nnBPBNpythSaMstwi4TUX8tY745XBa2s42
        cYwtFifwpLrzj9xzmWyt/CI2GGvLUHQsS8XOEGO/kgSA7n9sUxup7Wy+d67kFPg1TBT7y5
        Ic0qbxwDB0quvx+rm4ZqVvwWDnjvXwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-1ctvELjLMVqVEruB-jeKpg-1; Tue, 11 May 2021 13:29:15 -0400
X-MC-Unique: 1ctvELjLMVqVEruB-jeKpg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE82107ACC7;
        Tue, 11 May 2021 17:29:14 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-7.gru2.redhat.com [10.97.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FCDC39A73;
        Tue, 11 May 2021 17:29:06 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 2EA18418AE2E; Tue, 11 May 2021 14:18:10 -0300 (-03)
Date:   Tue, 11 May 2021 14:18:10 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210511171810.GA162107@fuller.cnet>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJqurM+LiyAY+MPO@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 12:19:56PM -0400, Peter Xu wrote:
> On Tue, May 11, 2021 at 11:51:57AM -0300, Marcelo Tosatti wrote:
> > On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> > > On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > > > 
> > > > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > > > {
> > > >         int ret = -EINTR;
> > > >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > > > 
> > > >         if (kvm_arch_vcpu_runnable(vcpu)) {
> > > >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> > > >                 goto out;
> > > >         }
> > > > 
> > > > Don't want to unhalt the vcpu.
> > > 
> > > Could you elaborate?  It's not obvious to me why we can't do that if
> > > pi_test_on() returns true..  we have pending post interrupts anyways, so
> > > shouldn't we stop halting?  Thanks!
> > 
> > pi_test_on() only returns true when an interrupt is signalled by the
> > device. But the sequence of events is:
> > 
> > 
> > 1. pCPU idles without notification vector configured to wakeup vector.
> > 
> > 2. PCI device is hotplugged, assigned device count increases from 0 to 1.
> > 
> > <arbitrary amount of time>
> > 
> > 3. device generates interrupt, sets ON bit to true in the posted
> > interrupt descriptor.
> > 
> > We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
> > is not set).
> 
> Ah yes.. thanks.
> 
> Besides the current approach, I'm thinking maybe it'll be cleaner/less LOC to
> define a KVM_REQ_UNBLOCK to replace the pre_block hook (in x86's kvm_host.h):
> 
> #define KVM_REQ_UNBLOCK			KVM_ARCH_REQ(31)
> 
> We can set it in vmx_pi_start_assignment(), then check+clear it in
> kvm_vcpu_has_events() (or make it a bool in kvm_vcpu struct?).

Can't check it in kvm_vcpu_has_events() because that will set
KVM_REQ_UNHALT (which we don't want).

I think KVM_REQ_UNBLOCK will add more lines of code.

> The thing is current vmx_vcpu_check_block() is mostly a sanity check and
> copy-paste of the pi checks on a few items, so maybe cleaner to use
> KVM_REQ_UNBLOCK, as it might be reused in the future for re-evaluating of
> pre-block for similar purpose?
> 
> No strong opinion, though.

Hum... IMHO v3 is quite clean already (although i don't object to your
suggestion).

Paolo, what do you think?



