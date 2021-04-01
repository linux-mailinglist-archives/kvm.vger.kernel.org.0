Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744D335195F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhDARxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234531AbhDARoE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98iVITrp+QoQaOvmHFzYOL2p801lu1RcC2838VOSYvw=;
        b=CZM+eGV8HtYLzfjwqLdPS+WQw0YMjjUPBst8p1g5NKB4EL+qXKip7oCBPegrsltqd6ph++
        FL+jZj+cAW0GTp6Bus0oS9H55N2/3zSNAoHScGJKP3I3wjYsdfV2PKwQBPK3nXFDjSA7VP
        6vbbnVyRZmgBBAXeSBbQbN27ga7xAbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-Y_Ye3OZyN3qad7yzaRZVwg-1; Thu, 01 Apr 2021 13:13:05 -0400
X-MC-Unique: Y_Ye3OZyN3qad7yzaRZVwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BEDC8189C8;
        Thu,  1 Apr 2021 17:13:03 +0000 (UTC)
Received: from starship (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC7015D6D1;
        Thu,  1 Apr 2021 17:12:59 +0000 (UTC)
Message-ID: <889f4565fb9b86e77ed22da6cbbe649311744f16.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: pending exceptions must not be blocked by
 an injected event
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 01 Apr 2021 20:12:58 +0300
In-Reply-To: <4f6a321a-bc44-fe2f-37f5-6b22bc7fae1c@redhat.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
         <20210401143817.1030695-2-mlevitsk@redhat.com>
         <4f6a321a-bc44-fe2f-37f5-6b22bc7fae1c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-01 at 19:05 +0200, Paolo Bonzini wrote:
> On 01/04/21 16:38, Maxim Levitsky wrote:
> > Injected interrupts/nmi should not block a pending exception,
> > but rather be either lost if nested hypervisor doesn't
> > intercept the pending exception (as in stock x86), or be delivered
> > in exitintinfo/IDT_VECTORING_INFO field, as a part of a VMexit
> > that corresponds to the pending exception.
> > 
> > The only reason for an exception to be blocked is when nested run
> > is pending (and that can't really happen currently
> > but still worth checking for).
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> This patch would be an almost separate bugfix, right?  I am going to 
> queue this, but a confirmation would be helpful.

Yes, this patch doesn't depend on anything else.
Thanks!
Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> > ---
> >   arch/x86/kvm/svm/nested.c |  8 +++++++-
> >   arch/x86/kvm/vmx/nested.c | 10 ++++++++--
> >   2 files changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 8523f60adb92..34a37b2bd486 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1062,7 +1062,13 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> >   	}
> >   
> >   	if (vcpu->arch.exception.pending) {
> > -		if (block_nested_events)
> > +		/*
> > +		 * Only a pending nested run can block a pending exception.
> > +		 * Otherwise an injected NMI/interrupt should either be
> > +		 * lost or delivered to the nested hypervisor in the EXITINTINFO
> > +		 * vmcb field, while delivering the pending exception.
> > +		 */
> > +		if (svm->nested.nested_run_pending)
> >                           return -EBUSY;
> >   		if (!nested_exit_on_exception(svm))
> >   			return 0;
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index fd334e4aa6db..c3ba842fc07f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3806,9 +3806,15 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >   
> >   	/*
> >   	 * Process any exceptions that are not debug traps before MTF.
> > +	 *
> > +	 * Note that only a pending nested run can block a pending exception.
> > +	 * Otherwise an injected NMI/interrupt should either be
> > +	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
> > +	 * while delivering the pending exception.
> >   	 */
> > +
> >   	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
> > -		if (block_nested_events)
> > +		if (vmx->nested.nested_run_pending)
> >   			return -EBUSY;
> >   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
> >   			goto no_vmexit;
> > @@ -3825,7 +3831,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >   	}
> >   
> >   	if (vcpu->arch.exception.pending) {
> > -		if (block_nested_events)
> > +		if (vmx->nested.nested_run_pending)
> >   			return -EBUSY;
> >   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
> >   			goto no_vmexit;
> > 


