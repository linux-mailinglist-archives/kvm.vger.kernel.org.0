Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9840F32531A
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 17:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhBYQIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 11:08:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233545AbhBYQIh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 11:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614269218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPlqJMoU9ErSEMEtT1KkqA811b4H3V90AXjiHwKSLXI=;
        b=haN79t07AbdZVTC5ZQKQ11XOD/MFzaOziCmqlchwiUrD0TiurkbXhXmEta7zZn9vtH7nSl
        V2S9CJuNu3AaWMvdlc2YBHL7lGAts7SKrnVzPVhrpK6skxa81t0DbVTt36lzsfijy/x2k/
        t0izHlZ/uYbid6wz4dj8KstRWmTqBPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-jYMGSjROMGe1Fug5WoRlvA-1; Thu, 25 Feb 2021 11:06:56 -0500
X-MC-Unique: jYMGSjROMGe1Fug5WoRlvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3E9D10066F2;
        Thu, 25 Feb 2021 16:06:54 +0000 (UTC)
Received: from starship (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B7755D9C2;
        Thu, 25 Feb 2021 16:06:50 +0000 (UTC)
Message-ID: <ac4e47fbfb7f884b87fd084fe4bc3c7e3db79666.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: pending exception must be be injected
 even with an injected event
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Thu, 25 Feb 2021 18:06:49 +0200
In-Reply-To: <358e284b-957a-388b-9729-9ee82b4fd8e3@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
         <20210225154135.405125-4-mlevitsk@redhat.com>
         <358e284b-957a-388b-9729-9ee82b4fd8e3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-25 at 17:05 +0100, Paolo Bonzini wrote:
> On 25/02/21 16:41, Maxim Levitsky wrote:
> > Injected events should not block a pending exception, but rather,
> > should either be lost or be delivered to the nested hypervisor as part of
> > exitintinfo/IDT_VECTORING_INFO
> > (if nested hypervisor intercepts the pending exception)
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Does this already fix some of your new test cases?

Yes, this fixes the 'interrupted' interrupt delivery test,
while patch fixes th 'interrupted' exception delivery.
Both interrupted by an exception.

Best regards
	Maxim Levitsky
> 
> Paolo
> 
> > ---
> >   arch/x86/kvm/svm/nested.c | 7 ++++++-
> >   arch/x86/kvm/vmx/nested.c | 9 +++++++--
> >   2 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 881e3954d753b..4c82abce0ea0c 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1024,7 +1024,12 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> >   	}
> >   
> >   	if (vcpu->arch.exception.pending) {
> > -		if (block_nested_events)
> > +		/*
> > +		 * Only pending nested run can block an pending exception
> > +		 * Otherwise an injected NMI/interrupt should either be
> > +		 * lost or delivered to the nested hypervisor in EXITINTINFO
> > +		 * */
> > +		if (svm->nested.nested_run_pending)
> >                           return -EBUSY;
> >   		if (!nested_exit_on_exception(svm))
> >   			return 0;
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index b34e284bfa62a..20ed1a351b2d9 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3810,9 +3810,14 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >   
> >   	/*
> >   	 * Process any exceptions that are not debug traps before MTF.
> > +	 *
> > +	 * Note that only pending nested run can block an pending exception
> > +	 * Otherwise an injected NMI/interrupt should either be
> > +	 * lost or delivered to the nested hypervisor in EXITINTINFO
> >   	 */
> > +
> >   	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
> > -		if (block_nested_events)
> > +		if (vmx->nested.nested_run_pending)
> >   			return -EBUSY;
> >   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
> >   			goto no_vmexit;
> > @@ -3829,7 +3834,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
> >   	}
> >   
> >   	if (vcpu->arch.exception.pending) {
> > -		if (block_nested_events)
> > +		if (vmx->nested.nested_run_pending)
> >   			return -EBUSY;
> >   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
> >   			goto no_vmexit;
> > 


