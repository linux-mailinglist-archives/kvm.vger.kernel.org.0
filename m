Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D363B0560
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhFVNBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 09:01:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231531AbhFVNBs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 09:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624366772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=11IbQ6LtwZCZCGfVWaU4+0InIg5X713BIpB4uME6Q/U=;
        b=M5xY8Q5aIkEm0fN0mo+CNTXMnVTi595f8i7vhHUhd52nfk9HgjuovSuLXi591HRu9BJc78
        DGsoE/Q9oaygWW3ZVG9UPYVQR5PWT0bE728VwMS6CrAD7vAfyGgH5QZ4hpOwdPEdFLCypL
        INk1tU1kxHdKp2WB2M+3CQDTwe16vy4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-Dmf2g3JhNSWLu0hkcTYwYw-1; Tue, 22 Jun 2021 08:59:31 -0400
X-MC-Unique: Dmf2g3JhNSWLu0hkcTYwYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 522D5100CEC2;
        Tue, 22 Jun 2021 12:59:30 +0000 (UTC)
Received: from [10.36.112.216] (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0266460C13;
        Tue, 22 Jun 2021 12:59:26 +0000 (UTC)
Message-ID: <01f3b0a48ac46d148f0cb489cb58f4b551832815.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address
 space support user-configurable
From:   Mohammed Gamal <mgamal@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:59:23 +0200
In-Reply-To: <CALMp9eTU8C4gXWfsLF-_=ymRC7Vqb0St=0BKvuvcNjBkqQBayA@mail.gmail.com>
References: <20200903141122.72908-1-mgamal@redhat.com>
         <CALMp9eT7yDGncP-G9v3fC=9PP3FD=uE1SBy1EPBbqkbrWSAXSg@mail.gmail.com>
         <11bb013a6beb7ccb3a5f5d5112fbccbf3eb64705.camel@redhat.com>
         <CALMp9eTU8C4gXWfsLF-_=ymRC7Vqb0St=0BKvuvcNjBkqQBayA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-21 at 11:01 -0700, Jim Mattson wrote:
> On Mon, Jan 18, 2021 at 2:22 AM Mohammed Gamal <mgamal@redhat.com>
> wrote:
> > 
> > On Fri, 2021-01-15 at 16:08 -0800, Jim Mattson wrote:
> > > On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com>
> > > wrote:
> > > > 
> > > > This patch exposes allow_smaller_maxphyaddr to the user as a
> > > > module
> > > > parameter.
> > > > 
> > > > Since smaller physical address spaces are only supported on
> > > > VMX,
> > > > the parameter
> > > > is only exposed in the kvm_intel module.
> > > > Modifications to VMX page fault and EPT violation handling will
> > > > depend on whether
> > > > that parameter is enabled.
> > > > 
> > > > Also disable support by default, and let the user decide if
> > > > they
> > > > want to enable
> > > > it.
> > > > 
> > > > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
> > > >  arch/x86/kvm/vmx/vmx.h |  3 +++
> > > >  arch/x86/kvm/x86.c     |  2 +-
> > > >  3 files changed, 10 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index 819c185adf09..dc778c7b5a06 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -129,6 +129,9 @@ static bool __read_mostly
> > > > enable_preemption_timer = 1;
> > > >  module_param_named(preemption_timer, enable_preemption_timer,
> > > > bool, S_IRUGO);
> > > >  #endif
> > > > 
> > > > +extern bool __read_mostly allow_smaller_maxphyaddr;
> > > 
> > > Since this variable is in the kvm module rather than the
> > > kvm_intel
> > > module, its current setting is preserved across "rmmod kvm_intel;
> > > modprobe kvm_intel." That is, if set to true, it doesn't revert
> > > to
> > > false after "rmmod kvm_intel." Is that the intended behavior?
> > > 
> > 
> > IIRC, this is because this setting was indeed not intended to be
> > just
> > VMX-specific, but since AMD has an issue with PTE accessed-bits
> > being
> > set by hardware and thus we can't yet enable this feature on it, it
> > might make sense to move the variable to the kvm_intel module for
> > now.
> 
> Um...
> 
> We do allow it for SVM, if NPT is not enabled. In fact, we set it
> unconditionally in that case. See commit 3edd68399dc15 ("KVM: x86:
> Add
> a capability for GUEST_MAXPHYADDR < HOST_MAXPHYADDR support").
> 
> Perhaps it should be a module parameter for SVM as well?

Hmmm, I think given how AMD CPUs' behavior with NPT enabled, maybe it'd
actually be a better idea to move this entirely to VMX for the time
being. And then maybe make it available again on AMD only if the
behavior with NPT is changed.

> 
> And, in any case, it would be nice if the parameter reverted to false
> when the kvm_intel module is unloaded.
> 
> > Paolo, what do you think?
> > 
> > 
> 


