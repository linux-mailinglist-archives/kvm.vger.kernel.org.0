Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD354443B8
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCOmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:42:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbhKCOmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:42:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635950369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qK4KVwMVgqDfUZk64r68FyMsre3d9651ebVsk5EEu34=;
        b=Rjvn9//p7ioq5K8abW+rH4EVpJxo7yrrm5w7r1vnUZ/aVMun+V3wxtd+Om+b1dfYd4AxWX
        87u0BfWenyG/mgzi6UN45+5cNy83UBoOq2GAqDJxILw/iGjst3hGJo8AQbzuiwyg+n51IK
        8+A4doBeydFx8pYbH/45Dah3Sb6WBH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-H1wo3EDlNPq08X_mK85RTg-1; Wed, 03 Nov 2021 10:39:26 -0400
X-MC-Unique: H1wo3EDlNPq08X_mK85RTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D05361006AA2;
        Wed,  3 Nov 2021 14:39:24 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD4B4196E5;
        Wed,  3 Nov 2021 14:39:20 +0000 (UTC)
Message-ID: <031ae5fc05851dba8acce3f5e4307860bedfd9ea.camel@redhat.com>
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
Date:   Wed, 03 Nov 2021 16:39:19 +0200
In-Reply-To: <87y265mj9k.fsf@vitty.brq.redhat.com>
References: <20211103094255.426573-1-mlevitsk@redhat.com>
         <871r3xnzaw.fsf@vitty.brq.redhat.com>
         <8b7949ae8094217c92b714cfd193fc571654cea7.camel@redhat.com>
         <87y265mj9k.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-03 at 15:00 +0100, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > On Wed, 2021-11-03 at 14:28 +0100, Vitaly Kuznetsov wrote:
> > > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > 
> > > > KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> > > > standard kvm's inject_pending_event, and not via APICv/AVIC.
> > > > 
> > > > Since this is a debug feature, just inhibit it while it
> > > > is in use.
> > > > 
> > > > Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h | 1 +
> > > >  arch/x86/kvm/svm/avic.c         | 3 ++-
> > > >  arch/x86/kvm/vmx/vmx.c          | 3 ++-
> > > >  arch/x86/kvm/x86.c              | 3 +++
> > > >  4 files changed, 8 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 88fce6ab4bbd7..8f6e15b95a4d8 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
> > > >  #define APICV_INHIBIT_REASON_IRQWIN     3
> > > >  #define APICV_INHIBIT_REASON_PIT_REINJ  4
> > > >  #define APICV_INHIBIT_REASON_X2APIC	5
> > > > +#define APICV_INHIBIT_REASON_BLOCKIRQ	6
> > > >  
> > > >  struct kvm_arch {
> > > >  	unsigned long n_used_mmu_pages;
> > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > index 8052d92069e01..affc0ea98d302 100644
> > > > --- a/arch/x86/kvm/svm/avic.c
> > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > @@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
> > > >  			  BIT(APICV_INHIBIT_REASON_NESTED) |
> > > >  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
> > > >  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
> > > > -			  BIT(APICV_INHIBIT_REASON_X2APIC);
> > > > +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
> > > > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> > > >  
> > > >  	return supported & BIT(bit);
> > > >  }
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index 71f54d85f104c..e4fc9ff7cd944 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
> > > >  static bool vmx_check_apicv_inhibit_reasons(ulong bit)
> > > >  {
> > > >  	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
> > > > -			  BIT(APICV_INHIBIT_REASON_HYPERV);
> > > > +			  BIT(APICV_INHIBIT_REASON_HYPERV) |
> > > > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
> > > >  
> > > >  	return supported & BIT(bit);
> > > >  }
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index ac83d873d65b0..dccf927baa4dd 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> > > >  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
> > > >  		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
> > > >  
> > > > +	kvm_request_apicv_update(vcpu->kvm,
> > > > +				 !(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
> > > > +				 APICV_INHIBIT_REASON_BLOCKIRQ);
> > > >  	/*
> > > >  	 * Trigger an rflags update that will inject or remove the trace
> > > >  	 * flags.
> > > 
> > > This fixes the problem for me!
> > > 
> > > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > 
> > Cool!
> > 
> > Now that I think about it, since guest debug flags are per-vcpu, this code won't
> > work if there are multiple vCPUs and you enable KVM_GUESTDBG_BLOCKIRQ on all of them
> > and then disable on this flag on just one of vCPUs, because this code will re-enable APICv/AVIC in this case.
> > A counter is needed, like you did in synic/autoeoi case.
> > 
> 
> Right, I completely forgot about this peculiarity!

I am sending v3 of this patch, I decided to avoid a counter and instead just use 
kvm_for_each_vcpu to see if other vCPUs have that bit set, on the ground of
this feature beeing only a debug feature.

Best regards,
	Maxim Levitsky

> 


