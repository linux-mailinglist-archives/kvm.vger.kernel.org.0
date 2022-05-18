Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ABA52B799
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 12:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiERJut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 05:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbiERJuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 05:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C46426AE8
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 02:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652867441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFPqNngbhurlXb9z2VG6oI79AAlWQ0hNU+ijxe8hQD8=;
        b=YyU0rgKZEHTW+FPdGZ2vZL4aBWraO/ldFHKWme+7YyS2+mL1wH9iGQMY7UYULbJyZ7bs1J
        WVptQyVmqL/L8gFZ/xEuxqI+rakWwBXWP06gc//s24enHTdVMi2bbiHIeKY0ROjUxuWuGO
        YymwWKjsthivwkC2rcSzLd6u72qTLdE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-iUSXRWdkNa2yhFYazfRDPw-1; Wed, 18 May 2022 05:50:35 -0400
X-MC-Unique: iUSXRWdkNa2yhFYazfRDPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAD65811E76;
        Wed, 18 May 2022 09:50:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D031410F36;
        Wed, 18 May 2022 09:50:27 +0000 (UTC)
Message-ID: <8c78939bf01a98554696add10e17b07631d97a28.camel@redhat.com>
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the
 guest and/or host changes apic id/base from the defaults.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Date:   Wed, 18 May 2022 12:50:27 +0300
In-Reply-To: <20220518082811.GA8765@gao-cwp>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
         <20220427200314.276673-3-mlevitsk@redhat.com>
         <20220518082811.GA8765@gao-cwp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 16:28 +0800, Chao Gao wrote:
> On Wed, Apr 27, 2022 at 11:02:57PM +0300, Maxim Levitsky wrote:
> > Neither of these settings should be changed by the guest and it is
> > a burden to support it in the acceleration code, so just inhibit
> > it instead.
> > 
> > Also add a boolean 'apic_id_changed' to indicate if apic id ever changed.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > arch/x86/include/asm/kvm_host.h |  3 +++
> > arch/x86/kvm/lapic.c            | 25 ++++++++++++++++++++++---
> > arch/x86/kvm/lapic.h            |  8 ++++++++
> > 3 files changed, 33 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 63eae00625bda..636df87542555 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1070,6 +1070,8 @@ enum kvm_apicv_inhibit {
> > 	APICV_INHIBIT_REASON_ABSENT,
> > 	/* AVIC is disabled because SEV doesn't support it */
> > 	APICV_INHIBIT_REASON_SEV,
> > +	/* APIC ID and/or APIC base was changed by the guest */
> > +	APICV_INHIBIT_REASON_RO_SETTINGS,
> 
> You need to add it to check_apicv_inhibit_reasons as well.
True, forgot about it.

> 
> > };
> > 
> > struct kvm_arch {
> > @@ -1258,6 +1260,7 @@ struct kvm_arch {
> > 	hpa_t	hv_root_tdp;
> > 	spinlock_t hv_root_tdp_lock;
> > #endif
> > +	bool apic_id_changed;
> 
> What's the value of this boolean? No one reads it.

I use it in later patches to kill the guest during nested VM entry 
if it attempts to use nested AVIC after any vCPU changed APIC ID.

I mentioned this boolean in the commit description.

This boolean avoids the need to go over all vCPUs and checking
if they still have the initial apic id.

In the future maybe we can introduce a more generic 'taint'
bitmap with various flags like that, indicating that the guest
did something unexpected.

BTW, the other option in regard to the nested AVIC is just to ignore this issue completely.
The code itself always uses vcpu_id's, thus regardless of when/how often the guest changes
its apic ids, my code would just use the initial APIC ID values consistently.

In this case I won't need this boolean.

> 
> > };
> > 
> > struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 66b0eb0bda94e..8996675b3ef4c 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2038,6 +2038,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
> > 	}
> > }
> > 
> > +static void kvm_lapic_check_initial_apic_id(struct kvm_lapic *apic)
> > +{
> > +	if (kvm_apic_has_initial_apic_id(apic))
> > +		return;
> > +
> > +	pr_warn_once("APIC ID change is unsupported by KVM");
> 
> It is misleading because changing xAPIC ID is supported by KVM; it just
> isn't compatible with APICv. Probably this pr_warn_once() should be
> removed.

Honestly since nobody uses this feature, I am not sure if to call this supported,
I am sure that KVM has more bugs in regard of using non standard APIC ID.
This warning might hopefuly make someone complain about it if this
feature is actually used somewhere.

> 
> > +
> > +	kvm_set_apicv_inhibit(apic->vcpu->kvm,
> > +			APICV_INHIBIT_REASON_RO_SETTINGS);
> 
> The indentation here looks incorrect to me.
> 	kvm_set_apicv_inhibit(apic->vcpu->kvm,
> 			      APICV_INHIBIT_REASON_RO_SETTINGS);

True, will fix.

> 
> > +
> > +	apic->vcpu->kvm->arch.apic_id_changed = true;
> > +}
> > +
> > static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> > {
> > 	int ret = 0;
> > @@ -2046,9 +2059,11 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> > 
> > 	switch (reg) {
> > 	case APIC_ID:		/* Local APIC ID */
> > -		if (!apic_x2apic_mode(apic))
> > +		if (!apic_x2apic_mode(apic)) {
> > +
> > 			kvm_apic_set_xapic_id(apic, val >> 24);
> > -		else
> > +			kvm_lapic_check_initial_apic_id(apic);
> > +		} else
> > 			ret = 1;
> > 		break;
> > 
> > @@ -2335,8 +2350,11 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> > 			     MSR_IA32_APICBASE_BASE;
> > 
> > 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
> > -	     apic->base_address != APIC_DEFAULT_PHYS_BASE)
> > +	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
> > +		kvm_set_apicv_inhibit(apic->vcpu->kvm,
> > +				APICV_INHIBIT_REASON_RO_SETTINGS);
> > 		pr_warn_once("APIC base relocation is unsupported by KVM");
> > +	}
> > }
> > 
> > void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> > @@ -2649,6 +2667,7 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
> > 		}
> > 	}
> > 
> > +	kvm_lapic_check_initial_apic_id(vcpu->arch.apic);
> > 	return 0;
> > }
> > 
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 4e4f8a22754f9..b9c406d383080 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -252,4 +252,12 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
> > 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
> > }
> > 
> > +static inline bool kvm_apic_has_initial_apic_id(struct kvm_lapic *apic)
> > +{
> > +	if (apic_x2apic_mode(apic))
> > +		return true;
> 
> I suggest warning of x2apic mode:
> 	if (WARN_ON_ONCE(apic_x2apic_mode(apic)))
> 
> Because it is weird that callers care about initial apic id when apic is
> in x2apic mode.

Yes but due to something I don't agree with, but also something that I gave up
on arguing upon, KVM userspace API kind of supports setting APIC ID != initial apic id,
even in x2apic mode, and disallowing it, is considered API breakage,
therefore this case is possible.

This case should still trigger a warning in kvm_lapic_check_initial_apic_id.

Best regards,
	Maxim Levitsky


> 


