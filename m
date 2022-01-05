Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C083C485182
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 11:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiAEK5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 05:57:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232847AbiAEK5H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 05:57:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641380226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBy6hI7L7HTM1Yr+Z3hpduy38cqpSc0OdU4IcEZRTBk=;
        b=ScX9kcisSAeDdfIn+TmCmUi/RR+Ci4IMczmsqSaK9CCqWAIyT76BGJQK81IY/AZklJOGdT
        wJXvYbwWlANYTZYukUidlE+5GpEr5fwjd/fZlQRpyPiLRhRdiqTWj4lVJvTRLD2KZ/jpYc
        zlJYBsH6ISkA4XgVk2AAmdu1vvUlNWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-5BwaaFdlPVqrFH4JAfhbJg-1; Wed, 05 Jan 2022 05:57:03 -0500
X-MC-Unique: 5BwaaFdlPVqrFH4JAfhbJg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96071760C1;
        Wed,  5 Jan 2022 10:57:01 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D44121F420;
        Wed,  5 Jan 2022 10:56:53 +0000 (UTC)
Message-ID: <69ebeb828f92cc01ac74836bd298216b25f68eda.camel@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: don't touch irr_pending in
 kvm_apic_update_apicv when inhibiting it
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Wed, 05 Jan 2022 12:56:52 +0200
In-Reply-To: <YdTQ3ewNzNOKoXCN@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-5-mlevitsk@redhat.com> <YdTQ3ewNzNOKoXCN@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-01-04 at 22:57 +0000, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Maxim Levitsky wrote:
> > kvm_apic_update_apicv is called when AVIC is still active, thus IRR bits
> > can be set by the CPU after it was called, and won't cause the irr_pending
> > to be set to true.
> > 
> > Also the logic in avic_kick_target_vcpu doesn't expect a race with this
> > function.
> > 
> > To make it simple, just keep irr_pending set to true and
> > let the next interrupt injection to the guest clear it.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index baca9fa37a91c..6e1fbbf4c508b 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2312,7 +2312,10 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> >  		apic->irr_pending = true;
> >  		apic->isr_count = 1;
> >  	} else {
> > -		apic->irr_pending = (apic_search_irr(apic) != -1);
> > +		/*
> > +		 * Don't touch irr_pending, let it be cleared when
> > +		 * we process the interrupt
> 
> Please don't use pronouns in comments, e.g. who is "we" in this context?  Please
> also say _why_.  IIUC, this could more precisely be:

Yes, good point. I will fix this.

Best regards,
	Maxim Levitsky

> 
> 		/*
> 		 * Don't clear irr_pending, searching the IRR can race with
> 		 * updates from the CPU as APICv is still active from hardware's
> 		 * perspective.  The flag will be cleared as appropriate when
> 		 * KVM injects the interrupt.
> 		 */
> 
> > +		 */
> >  		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
> >  	}
> >  }
> > -- 
> > 2.26.3
> > 


