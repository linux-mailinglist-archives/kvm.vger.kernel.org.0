Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6B46E9EE
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 15:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238597AbhLIOaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 09:30:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232122AbhLIOaa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 09:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639060016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98vHVkgD1zcUMYnaT7kiJnczoMqUf5nBps9d8EoldNI=;
        b=ExzE2FS60h6iFIAljK0BTVoyIFccWSsnruPdoSz+aEzKaROoSdDF6IejgQLsu43bQPq1Zr
        SJ07LFfWZl/bP0oSBU499eiqcjfTOD70Ejd1inOM0d0g3+fzHriCdyAzM5DblNLyTUp3Ag
        bYOIMQq4fI+Bj/0eouv91vqteExADQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-0RVno8FaMbODHui7sPdM_w-1; Thu, 09 Dec 2021 09:26:53 -0500
X-MC-Unique: 0RVno8FaMbODHui7sPdM_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0505B1023F4D;
        Thu,  9 Dec 2021 14:26:51 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E7DE5BE0E;
        Thu,  9 Dec 2021 14:26:31 +0000 (UTC)
Message-ID: <bcf9f9e5922cce979cc11ced8ccda992e22b290a.camel@redhat.com>
Subject: Re: [PATCH 3/6] KVM: SVM: fix AVIC race of host->guest IPI delivery
 vs AVIC inhibition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 09 Dec 2021 16:26:30 +0200
In-Reply-To: <4d723b07-e626-190d-63f4-fd0b5497dd9b@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
         <20211209115440.394441-4-mlevitsk@redhat.com>
         <4d723b07-e626-190d-63f4-fd0b5497dd9b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-09 at 15:11 +0100, Paolo Bonzini wrote:
> On 12/9/21 12:54, Maxim Levitsky wrote:
> > If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
> > inhibited, it might read a stale value of vcpu->arch.apicv_active
> > which can lead to the target vCPU not noticing the interrupt.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/avic.c | 16 +++++++++++++---
> >   1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 859ad2dc50f1..8c1b934bfa9b 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -691,6 +691,15 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >   	 * automatically process AVIC interrupts at VMRUN.
> >   	 */
> >   	if (vcpu->mode == IN_GUEST_MODE) {
> > +
> > +		/*
> > +		 * At this point we had read the vcpu->arch.apicv_active == true
> > +		 * and the vcpu->mode == IN_GUEST_MODE.
> > +		 * Since we have a memory barrier after setting IN_GUEST_MODE,
> > +		 * it ensures that AVIC inhibition is complete and thus
> > +		 * the target is really running with AVIC enabled.
> > +		 */
> > +
> >   		int cpu = READ_ONCE(vcpu->cpu);
> 
> I don't think it's correct.  The vCPU has apicv_active written (in 
> kvm_vcpu_update_apicv) before vcpu->mode.

I thought that we have a full memory barrier just prior to setting IN_GUEST_MODE
thus if I see vcpu->mode == IN_GUEST_MODE then I'll see correct apicv_active value.
But apparently the memory barrier is after setting vcpu->mode.


> 
> For the acquire/release pair to work properly you need to 1) read 
> apicv_active *after* vcpu->mode here 2) use store_release and 
> load_acquire for vcpu->mode, respectively in vcpu_enter_guest and here.

store_release for vcpu->mode in vcpu_enter_guest means a write barrier just before setting it,
which I expected to be there.

And yes I see now, I need a read barrier here as well. I am still learning this.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 
> >   		/*
> > @@ -706,10 +715,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >   		put_cpu();
> >   	} else {
> >   		/*
> > -		 * Wake the vCPU if it was blocking.  KVM will then detect the
> > -		 * pending IRQ when checking if the vCPU has a wake event.
> > +		 * Kick the target vCPU otherwise, to make sure
> > +		 * it processes the interrupt even if its AVIC is inhibited.
> >   		 */
> > -		kvm_vcpu_wake_up(vcpu);
> > +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> > +		kvm_vcpu_kick(vcpu);
> >   	}
> >   
> >   	return 0;
> > 


