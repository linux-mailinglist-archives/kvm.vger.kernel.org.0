Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE564CA432
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiCBLv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiCBLv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:51:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C53F4BA754
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 03:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646221844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oikgHICTQUHtxHmAuwSw7IZLbRWCqG95tBMzGyTod6s=;
        b=YNwf2+YmOnay7rEVnLYdGze12g8QTzUEIX0rX9rpjxlTJ5csXG3hLjx0TQaiZaEscproN6
        uYCAmfJ1YoVRyD+Ya34KmbZYBC2VHf+F2MxBr0koRpv0dgEhK+qu9c17P7L8WD+V9EJRdK
        ET1fkYtslE9lSOJKtNXeRNZnd7XEZww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-UvQNvHkBP-ONidlTJkH16g-1; Wed, 02 Mar 2022 06:50:41 -0500
X-MC-Unique: UvQNvHkBP-ONidlTJkH16g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A02B51006AA5;
        Wed,  2 Mar 2022 11:50:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F34EC76C33;
        Wed,  2 Mar 2022 11:50:30 +0000 (UTC)
Message-ID: <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default
 apic id when not using x2apic api
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Wed, 02 Mar 2022 13:50:29 +0200
In-Reply-To: <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-5-mlevitsk@redhat.com> <Yh5QJ4dJm63fC42n@google.com>
         <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
         <Yh5b3eBYK/rGzFfj@google.com>
         <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-01 at 19:56 +0200, Maxim Levitsky wrote:
> On Tue, 2022-03-01 at 17:46 +0000, Sean Christopherson wrote:
> > On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > index 80a2020c4db40..8d35f56c64020 100644
> > > > > --- a/arch/x86/kvm/lapic.c
> > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > @@ -2618,15 +2618,14 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> > > > >  		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
> > > > >  		u64 icr;
> > > > >  
> > > > > -		if (vcpu->kvm->arch.x2apic_format) {
> > > > > -			if (*id != vcpu->vcpu_id)
> > > > > -				return -EINVAL;
> > > > > -		} else {
> > > > > -			if (set)
> > > > > -				*id >>= 24;
> > > > > -			else
> > > > > -				*id <<= 24;
> > > > > -		}
> > > > > +		if (!vcpu->kvm->arch.x2apic_format && set)
> > > > > +			*id >>= 24;
> > > > > +
> > > > > +		if (*id != vcpu->vcpu_id)
> > > > > +			return -EINVAL;
> > > > 
> > > > This breaks backwards compability, userspace will start failing where it previously
> > > > succeeded.  It doesn't even require a malicious userspace, e.g. if userspace creates
> > > > a vCPU with a vcpu_id > 255 vCPUs, the shift will truncate and cause failure.  It'll
> > > > obviously do weird things, but this code is 5.5 years old, I don't think it's worth
> > > > trying to close a loophole that doesn't harm KVM.
> > > > 
> > > > If we provide a way for userspace to opt into disallowiong APICID != vcpu_id, we
> > > > can address this further upstream, e.g. reject vcpu_id > 255 without x2apic_format.
> > > 
> > > This check is only when CPU is in x2apic mode. In this mode the X86 specs demands that
> > > apic_id == vcpu_id.
> > 
> > AMD's APM explicitly allows changing the x2APIC ID by writing the xAPIC ID and then
> > switching to x2APIC mode.
> This patch was supposed to go together with patch that fully forbids changing apic id.
> 
> > > When old API is used, APIC IDs are encoded in xapic format, even when vCPU is in x2apic
> > > mode, meaning that apic id can't be more  that 255 even in x2apic mode.
> > 
> > Even on Intel CPUs, if userspace creates a vCPU with vcpu_id = 256, then the xAPIC ID
> > will be (256 << 24) == 0.  If userspace does get+set, then KVM will see 0 != 256 and
> > reject the set with return -EINVAL.
> 
> First of all, I am saying again - with old API (!x2apic_format) - the APIC ID was limited
> to 8 bits - literaly only bits 24-31 of the value was used.
> 
> With old API - literaly, the APIC_ID register was supposed to have x2apic format
> regardless of if vCPU is in x2apic mode or not, and the above code cares to translate
> it to the real apic id register from and to.
> 
> Thus there is really no point of letting old API change apic id for x2apic mode,
> it is literaly a loophole that should be plugged.

Since I probably didn't explain myself correctly let me try to explain myself again:
 
 
First of all let me explain the x86 spec:
 
APIC id is number, usually relatively small number - its initial value is taken from
vcpu_id, when vCPU is created.
Initial APIC id is exposed in CPUID, as well.
 
When APIC is in xapic mode, then mmio apic_base + 0x20, contains apic id in bits 24-31.
plus apic id 0xff is reserved for broadcast, thus max of 255 cpus.
 
When APIC is in x2apic mode, mmio access is disabled, and instead MSR 0x802 contains
the local apic id, and it is the whole 32 bit number.
 
 
We have 2 ioctls, KVM_GET_LAPIC/KVM_SET_LAPIC which set/get local apic state.
They use array of apic registers which is basically snapshot of xapic mmio, 
and it is not defined fully if these are x2apic or xapic registers.
 
Because of this, initially the APIC_ID register in this snapshot would
contain apic id in bits 24-31.
 
To make it possible to support apic id > 256, new KVM cap was added KVM_CAP_X2APIC_API
It has nothing to do with x2apic strictly speaking and can be used regardless of
x2apic mode.
 
All it does was to make the value at 0x20 offset in that mmio state dump be full 32 bit
value of the apic id.
 
 
When APIC state is loading while APIC is in *x2apic* mode it does enforce that
value in this 0x20 offset is initial apic id if KVM_CAP_X2APIC_API.
 
I think that it is fair to also enforce this when KVM_CAP_X2APIC_API is not used,
especially if we make apic id read-only.
 
I hope that this explains my point better, sorry if I was not able
to explain it well before.
 
Best regards,
	Maxim Levitsky


> 
> Best regards,
> 	Maxim Levitsky
> 
> > And as above, userspace that hasn't opted into the x2apic_format could also legitimately
> > change the x2APIC ID.
> > 
> > I 100% agree this is a mess and probably can't work without major shenanigans, but on
> > the other hand this isn't harming anything, so why risk breaking userspace, even if the
> > risk is infinitesimally small?
> > 
> > I'm all for locking down the APIC ID with a userspace opt-in control, I just don't
> > think it's worth trying to retroactively plug the various holes in KVM.
> > 


