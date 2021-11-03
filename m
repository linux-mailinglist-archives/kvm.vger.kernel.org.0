Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D313D4442A1
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKCNv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhKCNv6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 09:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635947361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvvBtFFD47+ufbEQ8dXpkpIFQ9Q2+BGMrva/35vcuLk=;
        b=MiY3yFr2zFSg8KffioN0fRFhJFrwRTcbdc6oBtim9UMkQnlJtdPZ0wABEDyZfKHJLwtr8Q
        ODTQHqoN33MvAI7jrGpz6NNROFk5dvkSOB7J+OnNKBxgY1QTpNzHW0mR7hvX5ybF/qalZp
        xj+QP2E+aFpIOVmmslRN+rpmgTytSBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-iB7flddOOA26E61IlkTuCA-1; Wed, 03 Nov 2021 09:49:20 -0400
X-MC-Unique: iB7flddOOA26E61IlkTuCA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C936F18125C5;
        Wed,  3 Nov 2021 13:49:17 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0EF668D7D;
        Wed,  3 Nov 2021 13:49:13 +0000 (UTC)
Message-ID: <8b7949ae8094217c92b714cfd193fc571654cea7.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 03 Nov 2021 15:49:12 +0200
In-Reply-To: <871r3xnzaw.fsf@vitty.brq.redhat.com>
References: <20211103094255.426573-1-mlevitsk@redhat.com>
         <871r3xnzaw.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-03 at 14:28 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> > standard kvm's inject_pending_event, and not via APICv/AVIC.
> > 
> > Since this is a debug feature, just inhibit it while it
> > is in use.
> > 
> > Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/svm/avic.c         | 3 ++-
> >  arch/x86/kvm/vmx/vmx.c          | 3 ++-
> >  arch/x86/kvm/x86.c              | 3 +++
> >  4 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 88fce6ab4bbd7..8f6e15b95a4d8 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
> >  #define APICV_INHIBIT_REASON_IRQWIN     3
> >  #define APICV_INHIBIT_REASON_PIT_REINJ  4
> >  #define APICV_INHIBIT_REASON_X2APIC	5
> > +#define APICV_INHIBIT_REASON_BLOCKIRQ	6
> >  
> >  struct kvm_arch {
> >  	unsigned long n_used_mmu_pages;
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 8052d92069e01..affc0ea98d302 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
> >  			  BIT(APICV_INHIBIT_REASON_NESTED) |
> >  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> >  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> > -			  BIT(APICV_INHIBIT_REASON_X2APIC);
> > +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
> > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> >  
> >  	return supported & BIT(bit);
> >  }
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 71f54d85f104c..e4fc9ff7cd944 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
> >  static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> >  {
> >  	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> > -			  BIT(APICV_INHIBIT_REASON_HYPERV);
> > +			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> >  
> >  	return supported & BIT(bit);
> >  }
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ac83d873d65b0..dccf927baa4dd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> >  		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
> >  
> > +	kvm_request_apicv_update(vcpu->kvm,
> > +				 !(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
> > +				 APICV_INHIBIT_REASON_BLOCKIRQ);
> >  	/*
> >  	 * Trigger an rflags update that will inject or remove the trace
> >  	 * flags.
> 
> This fixes the problem for me!
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Cool!
> 

Now that I think about it, since guest debug flags are per-vcpu, this code won't
work if there are multiple vCPUs and you enable KVM_GUESTDBG_BLOCKIRQ on all of them
and then disable on this flag on just one of vCPUs, because this code will re-enable APICv/AVIC in this case.
A counter is needed, like you did in synic/autoeoi case.

I'll send a V3 soon.


Best regards,
	Maxim Levitsky

