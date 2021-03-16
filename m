Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0D333D1E9
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhCPKkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:40:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhCPKjo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615891184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dU9IneHGaHNFOjov7DnhzTntJcnj94OUhCbXAz8zI4=;
        b=C2yzw8mJywQy0mJ2ycnRKWRri4v7sXRv/QB7qcL3/Y/DTEXv7Jb+gQ1mGUJMiaPWxevPos
        CQ5xzUctHYEc8pFM7u+6bExxs0BdYpGFG1tjtqSoABkJ60sae8s9e9g/4XVJjXNSxXQ6Zt
        uIZDuKk7iVfLLIvfGPwRDsHzBl+NCDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-vXftc9TbM5CF3E0ZmL606w-1; Tue, 16 Mar 2021 06:39:39 -0400
X-MC-Unique: vXftc9TbM5CF3E0ZmL606w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B49E310866A4;
        Tue, 16 Mar 2021 10:39:37 +0000 (UTC)
Received: from starship (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E64661001281;
        Tue, 16 Mar 2021 10:39:31 +0000 (UTC)
Message-ID: <33a306b07a102ae8ad61efb18118a475ff89eba2.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
Date:   Tue, 16 Mar 2021 12:39:30 +0200
In-Reply-To: <f1ee6230-760e-b614-5290-663b44fe1436@redhat.com>
References: <20210315174316.477511-1-mlevitsk@redhat.com>
         <20210315174316.477511-3-mlevitsk@redhat.com>
         <0dbcff57-8197-8fbb-809d-b47a4f5e9e77@redhat.com>
         <1a4f35e356c50e38916acef6c86175b24efca0a3.camel@redhat.com>
         <f1ee6230-760e-b614-5290-663b44fe1436@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-16 at 09:16 +0100, Paolo Bonzini wrote:
> On 15/03/21 19:19, Maxim Levitsky wrote:
> > On Mon, 2021-03-15 at 18:56 +0100, Paolo Bonzini wrote:
> > > On 15/03/21 18:43, Maxim Levitsky wrote:
> > > > +	if (!guest_cpuid_is_intel(vcpu)) {
> > > > +		/*
> > > > +		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
> > > > +		 * in VMCB and clear intercepts to avoid #VMEXIT.
> > > > +		 */
> > > > +		if (vls) {
> > > > +			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> > > > +			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> > > > +			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> > > > +		}
> > > > +		/* No need to intercept these msrs either */
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> > > > +	}
> > > 
> > > An "else" is needed here to do the opposite setup (removing the "if
> > > (vls)" from init_vmcb).
> > 
> > init_vmcb currently set the INTERCEPT_VMLOAD and INTERCEPT_VMSAVE and it doesn't enable vls
> 
> There's also this towards the end of the function:
> 
>          /*
>           * If hardware supports Virtual VMLOAD VMSAVE then enable it
>           * in VMCB and clear intercepts to avoid #VMEXIT.
>           */
>          if (vls) {
>                  svm_clr_intercept(svm, INTERCEPT_VMLOAD);
>                  svm_clr_intercept(svm, INTERCEPT_VMSAVE);
>                  svm->vmcb->control.virt_ext |= 
> VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>          }
> 
> > thus there is nothing to do if I don't want to enable vls.
> > It seems reasonable to me.
> > 
> > Both msrs I marked as '.always = false' in the
> > 'direct_access_msrs', which makes them be intercepted by the default.
> > If I were to use '.always = true' it would feel a bit wrong as the intercept is not always
> > enabled.
> 
> I agree that .always = false is correct.
> 
> > What do you think?
> 
> You can set the CPUID multiple times, so you could go from AMD to Intel 
> and back.

I understand now, I will send V2 with that. Thanks for the review!

Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
> Paolo
> 


