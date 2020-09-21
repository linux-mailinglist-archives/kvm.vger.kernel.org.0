Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB41271F0E
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIUJkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:40:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55681 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgIUJkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 05:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600681211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hzal5HS5mBmQ65nzGT4AtLr7x+11VqTcaPyuQCAIt4g=;
        b=PwYXWwAQkD7qZ9nfS1xSPKAl2N3rMA1+Z4FxFSl/u9WySsO7EZG7YhNZm9qDzCgWQ1rwWs
        8b305apwqOUwyEJpgLmrf+L0UvQfvGOuDutwxoaWldB1iUJ5EwZ+3fvH6Y4oXp+UB1aFSN
        s5UzIXwlNtvgxAbVKhCBCEbKAWVT6kM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-xapV6KnjMf2PtreSsxQg_g-1; Mon, 21 Sep 2020 05:40:09 -0400
X-MC-Unique: xapV6KnjMf2PtreSsxQg_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D0216A2A0;
        Mon, 21 Sep 2020 09:40:07 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 091987882A;
        Mon, 21 Sep 2020 09:40:00 +0000 (UTC)
Message-ID: <fd81b1a3816354b7bff2b229a38ceb2851ea5706.camel@redhat.com>
Subject: Re: [PATCH 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 21 Sep 2020 12:39:59 +0300
In-Reply-To: <f936123d4146ae6e2c9ffc8b25e4382c1d98255c.camel@redhat.com>
References: <20200917110723.820666-1-mlevitsk@redhat.com>
         <20200917110723.820666-2-mlevitsk@redhat.com>
         <20200917161135.GC13522@sjchrist-ice>
         <f936123d4146ae6e2c9ffc8b25e4382c1d98255c.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-21 at 12:25 +0300, Maxim Levitsky wrote:
> On Thu, 2020-09-17 at 09:11 -0700, Sean Christopherson wrote:
> > On Thu, Sep 17, 2020 at 02:07:23PM +0300, Maxim Levitsky wrote:
> > > MSR reads/writes should always access the L1 state, since the (nested)
> > > hypervisor should intercept all the msrs it wants to adjust, and these
> > > that it doesn't should be read by the guest as if the host had read it.
> > > 
> > > However IA32_TSC is an exception.Even when not intercepted, guest still
> > 
> > Missing a space after the period.
> Fixed
> > > reads the value + TSC offset.
> > > The write however does not take any TSC offset in the account.
> > 
> > s/in the/into
> Fixed.
> > > This is documented in Intel's PRM and seems also to happen on AMD as well.
> > 
> > Ideally we'd get confirmation from AMD that this is the correct behavior.
> It would be great. This isn't a blocker for this patch however since I didn't
> change the current emulation behavier which already assumes this.
> Also we don't really trap TSC reads, so this code isn't really executed.

I did now find out an explict mention that AMD's TSC scaling affects the MSR reads,
and while this doesn't expictily mention the offset, this does give more ground
to the assumption that the offset is added as well.

"Writing to the TSC Ratio MSR allows the hypervisor to control the guest's view of the Time Stamp
Counter. The contents of TSC Ratio MSR sets the value of the TSCRatio. This constant scales the
timestamp value returned when the TSC is read by a guest via the RDTSC or RDTSCP instructions or
when the TSC, MPERF, or MPerfReadOnly MSRs are read via the RDMSR instruction by a guest
running under virtualization."

Best regards,
	Maxim Levitsky

> 
> (I haven't checked what corner cases when we do this. It can happen in theory,
> if MSR read is done from the emulator or something like that).
> 
> > > This creates a problem when userspace wants to read the IA32_TSC value and then
> > > write it. (e.g for migration)
> > > 
> > > In this case it reads L2 value but write is interpreted as an L1 value.
> > 
> > It _may_ read the L2 value, e.g. it's not going to read the L2 value if L1
> > is active.
> 
> I didn't thought about this this way. I guess I always thought that L2 is,
> L2 if L2 is running, otherwise L1, but now I understand what you mean,
> and I agree.
> 
> > > To fix this make the userspace initiated reads of IA32_TSC return L1 value
> > > as well.
> > > 
> > > Huge thanks to Dave Gilbert for helping me understand this very confusing
> > > semantic of MSR writes.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
> > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 17f4995e80a7e..d10d5c6add359 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -2025,6 +2025,11 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
> > >  
> > > +static u64 kvm_read_l2_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
> > 
> > This is definitely not L2 specific.  I would vote to just omit the helper so
> > that we don't need to come up with a name that is correct across the board,
> > e.g. "raw" is also not quite correct.
> Yes, now I see this.
> 
> > An alternative would be to do:
> > 
> > 	u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
> > 						    vcpu->arch.tsc_offset;
> > 
> > 	msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> > 
> > Which I kind of like because the behavioral difference is a bit more obvious.
> Yep did that. The onl minor downside is that I need a C scope in the switch block.
> I can add kvm_read_tsc but I think that this is not worth it.
> 
> > > +{
> > > +	return vcpu->arch.tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
> > > +}
> > > +
> > >  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
> > >  {
> > >  	vcpu->arch.l1_tsc_offset = offset;
> > > @@ -3220,7 +3225,19 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >  		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
> > >  		break;
> > >  	case MSR_IA32_TSC:
> > > -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
> > > +		/*
> > > +		 * Intel PRM states that MSR_IA32_TSC read adds the TSC offset
> > > +		 * even when not intercepted. AMD manual doesn't define this
> > > +		 * but appears to behave the same
> > > +		 *
> > > +		 * However when userspace wants to read this MSR, return its
> > > +		 * real L1 value so that its restore will be correct
> > > +		 *
> > 
> > Extra line is unnecessary.
> This is a bit of my OCD :-) I don't mind to remove it.
> > > +		 */
> > > +		if (msr_info->host_initiated)
> > > +			msr_info->data = kvm_read_l1_tsc(vcpu, rdtsc());
> > > +		else
> > > +			msr_info->data = kvm_read_l2_tsc(vcpu, rdtsc());
> > >  		break;
> > >  	case MSR_MTRRcap:
> > >  	case 0x200 ... 0x2ff:
> > > -- 
> > > 2.26.2
> > > 
> 
> Thanks for the review, the V2 is on the way.
> Best regards,
> 	Maxim Levitsky
> 


