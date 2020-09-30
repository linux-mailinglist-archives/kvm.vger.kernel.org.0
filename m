Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EA227EB14
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 16:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgI3Ohu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 10:37:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20772 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgI3Ohu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 10:37:50 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601476669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvcoPWLZ/UXHXFLFR/AWxZXN9OnxSpqvTsQKFwNAyGQ=;
        b=gCXDLw4wrnBuetTaGRNZKVPOhk9n9WRkJRntFgh4F5UPhfUlP2rChN+Chh067mKzMCLZf8
        tT2BBwqc81dXRo09H7hFrsGdt6JiWMAM/y/ZATNrJ7rX0wyXrfP5PpSc1a1PnYHtuFa/GF
        u5do6POxQkR9QTf29b+V5osR9QEiwtY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-CBQgIOVjPnW1gt4xLqZ1UQ-1; Wed, 30 Sep 2020 10:37:47 -0400
X-MC-Unique: CBQgIOVjPnW1gt4xLqZ1UQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3AD785C732;
        Wed, 30 Sep 2020 14:37:45 +0000 (UTC)
Received: from starship (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 202E05579D;
        Wed, 30 Sep 2020 14:37:41 +0000 (UTC)
Message-ID: <58b7aa949cbdfefbb6149608ac0f45c8b25d5640.camel@redhat.com>
Subject: Re: [PATCH v2 1/1] KVM: x86: fix MSR_IA32_TSC read for nested
 migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Wed, 30 Sep 2020 17:37:41 +0300
In-Reply-To: <a35f7d67-d01b-0b2a-2993-7d6e0ba4add6@redhat.com>
References: <20200921103805.9102-1-mlevitsk@redhat.com>
         <20200921103805.9102-2-mlevitsk@redhat.com>
         <a35f7d67-d01b-0b2a-2993-7d6e0ba4add6@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-24 at 19:33 +0200, Paolo Bonzini wrote:
> On 21/09/20 12:38, Maxim Levitsky wrote:
> > MSR reads/writes should always access the L1 state, since the (nested)
> > hypervisor should intercept all the msrs it wants to adjust, and these
> > that it doesn't should be read by the guest as if the host had read it.
> > 
> > However IA32_TSC is an exception. Even when not intercepted, guest still
> > reads the value + TSC offset.
> > The write however does not take any TSC offset into account.
> > 
> > This is documented in Intel's SDM and seems also to happen on AMD as well.
> > 
> > This creates a problem when userspace wants to read the IA32_TSC value and then
> > write it. (e.g for migration)
> > 
> > In this case it reads L2 value but write is interpreted as an L1 value.
> > To fix this make the userspace initiated reads of IA32_TSC return L1 value
> > as well.
> > 
> > Huge thanks to Dave Gilbert for helping me understand this very confusing
> > semantic of MSR writes.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 17f4995e80a7e..ed4314641360e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3219,9 +3219,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	case MSR_IA32_POWER_CTL:
> >  		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
> >  		break;
> > -	case MSR_IA32_TSC:
> > -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
> > +	case MSR_IA32_TSC: {
> > +		/*
> > +		 * Intel SDM states that MSR_IA32_TSC read adds the TSC offset
> > +		 * even when not intercepted. AMD manual doesn't explicitly
> > +		 * state this but appears to behave the same.
> > +		 *
> > +		 * However when userspace wants to read this MSR, we should
> > +		 * return it's real L1 value so that its restore will be correct.
> > +		 */
> > +		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
> > +							    vcpu->arch.tsc_offset;
> > +
> > +		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> >  		break;
> > +	}
> >  	case MSR_MTRRcap:
> >  	case 0x200 ... 0x2ff:
> >  		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
> > 
> 
> Applied the patch as it is doing the sanest possible thing for the
> current semantics of host-initiated accesses.
> 
> Paolo
> 
Thanks!

Best regards,
	Maxim Levitsky

