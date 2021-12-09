Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7210B46EB67
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbhLIPjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:39:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239890AbhLIPjT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 10:39:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639064145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L6uKABwvgC4vbXPr+ibEt5UbMPmfxm+fjwySu+VC6SI=;
        b=VDGEbQPWBvkmFe6goZmI3CwkM4hIy1vjHfwdqPY5+tF641uCJ4IgTaaBPyWFFxKr+vazrG
        mJ97Nyl15VD1nm59xpbPVelFfUKunkB9c4NS+ZJh8+yEFLkZv/xg2RdYY1QRyEvTzhYrDG
        k55ExEYY8GRMCVAbyD3a2hwW7rp+tdA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-7kpqlfpgN16f__ppYHk1Mw-1; Thu, 09 Dec 2021 10:35:42 -0500
X-MC-Unique: 7kpqlfpgN16f__ppYHk1Mw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE3DE10168C3;
        Thu,  9 Dec 2021 15:35:40 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDCAB60BF1;
        Thu,  9 Dec 2021 15:35:36 +0000 (UTC)
Message-ID: <12e0b8b85930f158b35134d54d321ea6fc403584.camel@redhat.com>
Subject: Re: [PATCH 3/6] KVM: SVM: fix AVIC race of host->guest IPI delivery
 vs AVIC inhibition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 09 Dec 2021 17:35:35 +0200
In-Reply-To: <14c4784b5e2bfbe813964485b46052315b533744.camel@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
         <20211209115440.394441-4-mlevitsk@redhat.com>
         <4d723b07-e626-190d-63f4-fd0b5497dd9b@redhat.com>
         <bcf9f9e5922cce979cc11ced8ccda992e22b290a.camel@redhat.com>
         <YbIgb4V7jcx2tZ0R@google.com>
         <14c4784b5e2bfbe813964485b46052315b533744.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 17:33 +0200, Maxim Levitsky wrote:
> On Thu, 2021-12-09 at 15:27 +0000, Sean Christopherson wrote:
> > On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> > > On Thu, 2021-12-09 at 15:11 +0100, Paolo Bonzini wrote:
> > > > On 12/9/21 12:54, Maxim Levitsky wrote:
> > > > > If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
> > > > > inhibited, it might read a stale value of vcpu->arch.apicv_active
> > > > > which can lead to the target vCPU not noticing the interrupt.
> > > > > 
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > >   arch/x86/kvm/svm/avic.c | 16 +++++++++++++---
> > > > >   1 file changed, 13 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > > > index 859ad2dc50f1..8c1b934bfa9b 100644
> > > > > --- a/arch/x86/kvm/svm/avic.c
> > > > > +++ b/arch/x86/kvm/svm/avic.c
> > > > > @@ -691,6 +691,15 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> > > > >   	 * automatically process AVIC interrupts at VMRUN.
> > > > >   	 */
> > > > >   	if (vcpu->mode == IN_GUEST_MODE) {
> > > > > +
> > > > > +		/*
> > > > > +		 * At this point we had read the vcpu->arch.apicv_active == true
> > > > > +		 * and the vcpu->mode == IN_GUEST_MODE.
> > > > > +		 * Since we have a memory barrier after setting IN_GUEST_MODE,
> > > > > +		 * it ensures that AVIC inhibition is complete and thus
> > > > > +		 * the target is really running with AVIC enabled.
> > > > > +		 */
> > > > > +
> > > > >   		int cpu = READ_ONCE(vcpu->cpu);
> > > > 
> > > > I don't think it's correct.  The vCPU has apicv_active written (in 
> > > > kvm_vcpu_update_apicv) before vcpu->mode.
> > > 
> > > I thought that we have a full memory barrier just prior to setting IN_GUEST_MODE
> > > thus if I see vcpu->mode == IN_GUEST_MODE then I'll see correct apicv_active value.
> > > But apparently the memory barrier is after setting vcpu->mode.
> > > 
> > > 
> > > > For the acquire/release pair to work properly you need to 1) read 
> > > > apicv_active *after* vcpu->mode here 2) use store_release and 
> > > > load_acquire for vcpu->mode, respectively in vcpu_enter_guest and here.
> > > 
> > > store_release for vcpu->mode in vcpu_enter_guest means a write barrier just before setting it,
> > > which I expected to be there.
> > > 
> > > And yes I see now, I need a read barrier here as well. I am still learning this.
> > 
> > Sans barriers and comments, can't this be written as returning an "error" if the
> > vCPU is not IN_GUEST_MODE?  Effectively the same thing, but a little more precise
> > and it avoids duplicating the lapic.c code.
> 
> Yes, beside the fact that we already set the vIRR bit so if I return -1 here, it will be set again..
> (and these are set using atomic ops)
> 
> I don't know how much that matters except the fact that while a vCPU runs a nested guest,
> callers wishing to send IPI to it, will go through this code path a lot 
> (even when I implement nested AVIC as it is a separate thing which is used by L2 only).

Ah, hit send too soon, makes sense now to me!
Best regards,
	Maxim Levitsky
> 
> Best regards,
> 	Maxim Levitsky
> 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 26ed5325c593..cddf7a8da3ea 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -671,7 +671,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> > 
> >  int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  {
> > -       if (!vcpu->arch.apicv_active)
> > +       if (vcpu->mode != IN_GUEST_MODE || !vcpu->arch.apicv_active)
> >                 return -1;
> > 
> >         kvm_lapic_set_irr(vec, vcpu->arch.apic);
> > @@ -706,8 +706,9 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >                 put_cpu();
> >         } else {
> >                 /*
> > -                * Wake the vCPU if it was blocking.  KVM will then detect the
> > -                * pending IRQ when checking if the vCPU has a wake event.
> > +                * Wake the vCPU if it is blocking.  If the vCPU exited the
> > +                * guest since the previous vcpu->mode check, it's guaranteed
> > +                * to see the event before re-enterring the guest.
> >                  */
> >                 kvm_vcpu_wake_up(vcpu);
> >         }
> > 


