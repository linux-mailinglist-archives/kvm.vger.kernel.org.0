Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89F3B2A1E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 10:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhFXIPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 04:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231804AbhFXIPo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 04:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624522405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93B83MuKOnXGcqD1yFOtENeDWjr0pRle6LMuQcAX/kM=;
        b=VkymZTh1tKzXqrudqv1fH5n9AFS6+vGQOTJthOvgRgqu4U0GETHE7szEDojmEchQsvMCSr
        FcYkM2169he6SMssKra2mF+6RoswaGa0lX1/Tj2Oe34kdEknEz8Duc0Z6Rg+kQocruLxJE
        dkwZgJl7RiR5blNAOmRBDvWH+y54EJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-J-l8AB2jOXa24-G9obNLqA-1; Thu, 24 Jun 2021 04:13:24 -0400
X-MC-Unique: J-l8AB2jOXa24-G9obNLqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80E485074B;
        Thu, 24 Jun 2021 08:13:22 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC8DE5D9F0;
        Thu, 24 Jun 2021 08:13:18 +0000 (UTC)
Message-ID: <153cf16c78578079d168c754ef451b1f3ecd5220.camel@redhat.com>
Subject: Re: [PATCH 04/10] KVM: SVM: add warning for mistmatch between AVIC
 state and AVIC access page state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 24 Jun 2021 11:13:17 +0300
In-Reply-To: <6617e1f2-23dd-9132-d866-7780663533c3@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
         <20210623113002.111448-5-mlevitsk@redhat.com>
         <6617e1f2-23dd-9132-d866-7780663533c3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-06-23 at 23:53 +0200, Paolo Bonzini wrote:
> On 23/06/21 13:29, Maxim Levitsky wrote:
> > It is never a good idea to enter a guest when the AVIC state doesn't match
> > the state of the AVIC MMIO memory slot.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 12c06ea28f5c..50405c561394 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3780,6 +3780,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
> >   
> >   	pre_svm_run(vcpu);
> >   
> > +	WARN_ON_ONCE(vcpu->kvm->arch.apic_access_memslot_enabled !=
> > +		     kvm_vcpu_apicv_active(vcpu));
> > +
> >   	sync_lapic_to_cr8(vcpu);
> >   
> >   	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> > 
> 
> For patches 4-6, can the warnings actually fire without the fix in patch 2?
> 
> Paolo
> 

Hi!

The warning in patch 4 does fire, not often but it does. Patch 2 fixes it.
The guest usually boots though few lost APIC writes don't always cause it to hang.

Plus the warning is also triggered when the AVIC state is mismatched the other way
around, that is when AVIC is enabled but memslot is disabled, which probably
doesn't cause issues.

Warning in patch 5 is mostly theoretical, until patch 8 is applied.
They can happen if AVIC is toggled on one vCPU for some reason, while another vCPU
asks for an interrupt window.

Patch 6 doesn't fix a warning, but rather a case which most likely can't happen
till patch 8 is applied, but still is correct.

Best regards,
	Maxim Levitsky

