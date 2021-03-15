Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0358033C567
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhCOSTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhCOSTU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 14:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615832359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4lwr2MQuhGgaP+aDNtyMeR5Cd4Z5d5TENFki18L169Q=;
        b=cEw83EPVuRnv77nxM55lOcZ7BpvrVB/itvB1MuVkXHr2vQGyQPMhzbwjbpoLuHslO6gcjw
        4jSZk5R4u+jos+PBJ6Zr/RJcOc7/Tu7QQ1qv8GL75XCZXnVneyhKseZwBx/c4LVib2Spfj
        tmo6qLrEolKtiP6c4hux1M7yZsPfgPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-J_4xzsA3NT2pN2kj3r1TPg-1; Mon, 15 Mar 2021 14:19:16 -0400
X-MC-Unique: J_4xzsA3NT2pN2kj3r1TPg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4939481433D;
        Mon, 15 Mar 2021 18:19:14 +0000 (UTC)
Received: from starship (unknown [10.35.207.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF05B5C5E0;
        Mon, 15 Mar 2021 18:19:10 +0000 (UTC)
Message-ID: <1a4f35e356c50e38916acef6c86175b24efca0a3.camel@redhat.com>
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
Date:   Mon, 15 Mar 2021 20:19:09 +0200
In-Reply-To: <0dbcff57-8197-8fbb-809d-b47a4f5e9e77@redhat.com>
References: <20210315174316.477511-1-mlevitsk@redhat.com>
         <20210315174316.477511-3-mlevitsk@redhat.com>
         <0dbcff57-8197-8fbb-809d-b47a4f5e9e77@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-15 at 18:56 +0100, Paolo Bonzini wrote:
> On 15/03/21 18:43, Maxim Levitsky wrote:
> > +	if (!guest_cpuid_is_intel(vcpu)) {
> > +		/*
> > +		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
> > +		 * in VMCB and clear intercepts to avoid #VMEXIT.
> > +		 */
> > +		if (vls) {
> > +			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> > +			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> > +			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> > +		}
> > +		/* No need to intercept these msrs either */
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
> > +	}
> 
> An "else" is needed here to do the opposite setup (removing the "if 
> (vls)" from init_vmcb).

init_vmcb currently set the INTERCEPT_VMLOAD and INTERCEPT_VMSAVE and it doesn't enable vls
thus there is nothing to do if I don't want to enable vls.
It seems reasonable to me.

Both msrs I marked as '.always = false' in the 
'direct_access_msrs', which makes them be intercepted by the default.
If I were to use '.always = true' it would feel a bit wrong as the intercept is not always
enabled.

What do you think?

> 
> This also makes the code more readable since you can write
> 
> 	if (guest_cpuid_is_intel(vcpu)) {
> 		/*
> 		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
> 		 * accesses because the processor only stores 32 bits.
> 		 * For the same reason we cannot use virtual
> 		 * VMLOAD/VMSAVE.
> 		 */
> 		...
> 	} else {
> 		/* Do the opposite.  */
> 		...
> 	}

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


