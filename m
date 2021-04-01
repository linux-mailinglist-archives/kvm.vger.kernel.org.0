Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9735176A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhDARmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234365AbhDARhB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymqWAzLAr6YjRLZWB43VnMgVtF641FdmA2DlyPy0Tsc=;
        b=bzD0rAsv58wJqaiQMMgu5g2BkjKSOK3Zb+w6Va/HNp7a5kH81Ih5KZwjVJQFMKVYaVSfZF
        /2X2FD4/SAVhtnMG/uNVpKDKjj2T5tXizEgpFIPK+KevzI2vttuTU3A94fHI5H8dJwNPnh
        JHAsPRr2cRICBMIES4uH9ljur36uNHM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-eCMNvA66Px6meC_TdNIwIQ-1; Thu, 01 Apr 2021 13:06:04 -0400
X-MC-Unique: eCMNvA66Px6meC_TdNIwIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0ED618C8C00;
        Thu,  1 Apr 2021 17:06:02 +0000 (UTC)
Received: from starship (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81F3076BF6;
        Thu,  1 Apr 2021 17:05:52 +0000 (UTC)
Message-ID: <0db95e08290267a6cc808f4ed795551c0ca6d946.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Date:   Thu, 01 Apr 2021 20:05:51 +0300
In-Reply-To: <87h7kqrwb2.fsf@vitty.brq.redhat.com>
References: <20210401111928.996871-1-mlevitsk@redhat.com>
         <20210401111928.996871-3-mlevitsk@redhat.com>
         <87h7kqrwb2.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-04-01 at 15:03 +0200, Vitaly Kuznetsov wrote:
> Maxim Levitsky <mlevitsk@redhat.com> writes:
> 
> > Currently to support Intel->AMD migration, if CPU vendor is GenuineIntel,
> > we emulate the full 64 value for MSR_IA32_SYSENTER_{EIP|ESP}
> > msrs, and we also emulate the sysenter/sysexit instruction in long mode.
> > 
> > (Emulator does still refuse to emulate sysenter in 64 bit mode, on the
> > ground that the code for that wasn't tested and likely has no users)
> > 
> > However when virtual vmload/vmsave is enabled, the vmload instruction will
> > update these 32 bit msrs without triggering their msr intercept,
> > which will lead to having stale values in kvm's shadow copy of these msrs,
> > which relies on the intercept to be up to date.
> > 
> > Fix/optimize this by doing the following:
> > 
> > 1. Enable the MSR intercepts for SYSENTER MSRs iff vendor=GenuineIntel
> >    (This is both a tiny optimization and also ensures that in case
> >    the guest cpu vendor is AMD, the msrs will be 32 bit wide as
> >    AMD defined).
> > 
> > 2. Store only high 32 bit part of these msrs on interception and combine
> >    it with hardware msr value on intercepted read/writes
> >    iff vendor=GenuineIntel.
> > 
> > 3. Disable vmload/vmsave virtualization if vendor=GenuineIntel.
> >    (It is somewhat insane to set vendor=GenuineIntel and still enable
> >    SVM for the guest but well whatever).
> >    Then zero the high 32 bit parts when kvm intercepts and emulates vmload.
> > 
> > Thanks a lot to Paulo Bonzini for helping me with fixing this in the most
> 
> s/Paulo/Paolo/ :-)
Sorry about that!

> 
> > correct way.
> > 
> > This patch fixes nested migration of 32 bit nested guests, that was
> > broken because incorrect cached values of SYSENTER msrs were stored in
> > the migration stream if L1 changed these msrs with
> > vmload prior to L2 entry.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 99 +++++++++++++++++++++++++++---------------
> >  arch/x86/kvm/svm/svm.h |  6 +--
> >  2 files changed, 68 insertions(+), 37 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 271196400495..6c39b0cd6ec6 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -95,6 +95,8 @@ static const struct svm_direct_access_msrs {
> >  } direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
> >  	{ .index = MSR_STAR,				.always = true  },
> >  	{ .index = MSR_IA32_SYSENTER_CS,		.always = true  },
> > +	{ .index = MSR_IA32_SYSENTER_EIP,		.always = false },
> > +	{ .index = MSR_IA32_SYSENTER_ESP,		.always = false },
> >  #ifdef CONFIG_X86_64
> >  	{ .index = MSR_GS_BASE,				.always = true  },
> >  	{ .index = MSR_FS_BASE,				.always = true  },
> > @@ -1258,16 +1260,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> >  	if (kvm_vcpu_apicv_active(vcpu))
> >  		avic_init_vmcb(svm);
> >  
> > -	/*
> > -	 * If hardware supports Virtual VMLOAD VMSAVE then enable it
> > -	 * in VMCB and clear intercepts to avoid #VMEXIT.
> > -	 */
> > -	if (vls) {
> > -		svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> > -		svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> > -		svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> > -	}
> > -
> >  	if (vgif) {
> >  		svm_clr_intercept(svm, INTERCEPT_STGI);
> >  		svm_clr_intercept(svm, INTERCEPT_CLGI);
> > @@ -2133,9 +2125,11 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
> >  
> >  	ret = kvm_skip_emulated_instruction(vcpu);
> >  
> > -	if (vmload)
> > +	if (vmload) {
> >  		nested_svm_vmloadsave(vmcb12, svm->vmcb);
> > -	else
> > +		svm->sysenter_eip_hi = 0;
> > +		svm->sysenter_esp_hi = 0;
> > +	} else
> >  		nested_svm_vmloadsave(svm->vmcb, vmcb12);
> 
> Nitpicking: {} are now needed for both branches here.
I didn't knew about this rule, and I'll take this into
account next time. Thanks!


Best regards,
	Maxim Levitsky


