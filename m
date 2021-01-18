Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE12F9D28
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbhARKs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:48:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390096AbhARKXt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 05:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610965342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RpFlhXoCi3L1BBKHKCd/6ZVAAft9GBSKHZM8kwXaep8=;
        b=bLkAEnp+o4AwvZdotWh4qsbHdu2m426EDxVfUoa9pyZx55+gRnzCCXBS2+Y8hZuG1eX+gS
        oahTGS0h4d1Z/qpbf1t3cAwOEKOg/4VxF1qGh+ScpZubpgoc1wjK92cXgGc59M7rA5s+AO
        4o2EmLbHE6fh/cruuWKWmveZIFiwGAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-Me9VOK4bNmKeCSDyuYamrQ-1; Mon, 18 Jan 2021 05:22:20 -0500
X-MC-Unique: Me9VOK4bNmKeCSDyuYamrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02687107ACE4;
        Mon, 18 Jan 2021 10:22:19 +0000 (UTC)
Received: from [10.40.208.57] (unknown [10.40.208.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 053F060BFA;
        Mon, 18 Jan 2021 10:22:11 +0000 (UTC)
Message-ID: <11bb013a6beb7ccb3a5f5d5112fbccbf3eb64705.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address
 space support user-configurable
From:   Mohammed Gamal <mgamal@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Mon, 18 Jan 2021 12:18:05 +0200
In-Reply-To: <CALMp9eT7yDGncP-G9v3fC=9PP3FD=uE1SBy1EPBbqkbrWSAXSg@mail.gmail.com>
References: <20200903141122.72908-1-mgamal@redhat.com>
         <CALMp9eT7yDGncP-G9v3fC=9PP3FD=uE1SBy1EPBbqkbrWSAXSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-01-15 at 16:08 -0800, Jim Mattson wrote:
> On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com>
> wrote:
> > 
> > This patch exposes allow_smaller_maxphyaddr to the user as a module
> > parameter.
> > 
> > Since smaller physical address spaces are only supported on VMX,
> > the parameter
> > is only exposed in the kvm_intel module.
> > Modifications to VMX page fault and EPT violation handling will
> > depend on whether
> > that parameter is enabled.
> > 
> > Also disable support by default, and let the user decide if they
> > want to enable
> > it.
> > 
> > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
> >  arch/x86/kvm/vmx/vmx.h |  3 +++
> >  arch/x86/kvm/x86.c     |  2 +-
> >  3 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 819c185adf09..dc778c7b5a06 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -129,6 +129,9 @@ static bool __read_mostly
> > enable_preemption_timer = 1;
> >  module_param_named(preemption_timer, enable_preemption_timer,
> > bool, S_IRUGO);
> >  #endif
> > 
> > +extern bool __read_mostly allow_smaller_maxphyaddr;
> 
> Since this variable is in the kvm module rather than the kvm_intel
> module, its current setting is preserved across "rmmod kvm_intel;
> modprobe kvm_intel." That is, if set to true, it doesn't revert to
> false after "rmmod kvm_intel." Is that the intended behavior?
> 

IIRC, this is because this setting was indeed not intended to be just
VMX-specific, but since AMD has an issue with PTE accessed-bits being
set by hardware and thus we can't yet enable this feature on it, it
might make sense to move the variable to the kvm_intel module for now.

Paolo, what do you think?


