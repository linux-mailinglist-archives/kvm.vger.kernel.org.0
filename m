Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6315EE37F
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbiI1Rvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbiI1Rvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:51:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E4F6F65
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664387503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqjowHi26bsESSLy5gRLnwl2mccAdSnDp5ecLzbfdZE=;
        b=HYXSCBNtjDQtnxG/APcaoYC29aP7k8I/ui2I2NShFhnaWm/s/4rQBYhQ9iX+6ZQ58q/zRR
        9zhxmKjx6yffOiuFhUclafIoTcaxLLjhYoW6AhLv5dThilfBVuH3I3u94ioDDsHsp791Db
        KITvMkVZfovyO5yoqyNU1Mx9rlWhxgg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-jeKFmtqoNG-roxKtWUPHKw-1; Wed, 28 Sep 2022 13:51:39 -0400
X-MC-Unique: jeKFmtqoNG-roxKtWUPHKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C83B185A79C;
        Wed, 28 Sep 2022 17:51:39 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BDC6C15BA8;
        Wed, 28 Sep 2022 17:51:37 +0000 (UTC)
Message-ID: <1aea43e831cd7ed90c325b2c90bc6f3f9a1805b5.camel@redhat.com>
Subject: Re: [PATCH v3 05/28] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID
 mismatch is due to 32-bit ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 28 Sep 2022 20:51:36 +0300
In-Reply-To: <YzR7ezt67i1lH1/b@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
         <20220920233134.940511-6-seanjc@google.com>
         <d02d0b30-f29b-0ff6-98c7-89ddcd091c60@oracle.com>
         <e5d54876b233dc71a69249c3d02d649da5040a14.camel@redhat.com>
         <YzR7ezt67i1lH1/b@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-09-28 at 16:51 +0000, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-09-27 at 23:15 -0400, Alejandro Jimenez wrote:
> > > On 9/20/2022 7:31 PM, Sean Christopherson wrote:
> > > > Truncate the vcpu_id, a.k.a. x2APIC ID, to an 8-bit value when comparing
> > > > it against the xAPIC ID to avoid false positives (sort of) on systems
> > > > with >255 CPUs, i.e. with IDs that don't fit into a u8.  The intent of
> > > > APIC_ID_MODIFIED is to inhibit APICv/AVIC when the xAPIC is changed from
> > > > it's original value,
> > > > 
> > > > The mismatch isn't technically a false positive, as architecturally the
> > > > xAPIC IDs do end up being aliased in this scenario, and neither APICv
> > > > nor AVIC correctly handles IPI virtualization when there is aliasing.
> > > > However, KVM already deliberately does not honor the aliasing behavior
> > > > that results when an x2APIC ID gets truncated to an xAPIC ID.  I.e. the
> > > > resulting APICv/AVIC behavior is aligned with KVM's existing behavior
> > > > when KVM's x2APIC hotplug hack is effectively enabled.
> > > > 
> > > > If/when KVM provides a way to disable the hotplug hack, APICv/AVIC can
> > > > piggyback whatever logic disables the optimized APIC map (which is what
> > > > provides the hotplug hack), i.e. so that KVM's optimized map and APIC
> > > > virtualization yield the same behavior.
> > > > 
> > > > For now, fix the immediate problem of APIC virtualization being disabled
> > > > for large VMs, which is a much more pressing issue than ensuring KVM
> > > > honors architectural behavior for APIC ID aliasing.
> > > 
> > > I built a host kernel with this entire series on top of mainline 
> > > v6.0-rc6, and booting a guest with AVIC enabled works as expected on the 
> > > initial boot. The issue is that during the first reboot AVIC is 
> > > inhibited due to APICV_INHIBIT_REASON_APIC_ID_MODIFIED, and I see 
> > > constant inhibition events due to APICV_INHIBIT_REASON_IRQWIN as seen in 
> > 
> > APICV_INHIBIT_REASON_IRQWIN is OK, because that happens about every time
> > the good old PIT timer fires which happens on reboot.
> > 
> > APICV_INHIBIT_REASON_APIC_ID_MODIFIED should not happen as you noted,
> > this needs investigation.
> 
> Ya, I'll take a look.
> 
> > > It happens regardless of vCPU count (tested with 2, 32, 255, 380, and 
> > > 512 vCPUs). This state persists for all subsequent reboots, until the VM 
> > > is terminated. For vCPU counts < 256, when x2apic is disabled the 
> > > problem does not occur, and AVIC continues to work properly after reboots.
> 
> Bit of a shot in the dark, but does the below fix the issue?  There are two
> issues with calling kvm_lapic_xapic_id_updated() from kvm_apic_state_fixup():
> 
>   1. The xAPIC ID should only be refreshed on "set".
True - I didn't bother to fix it yet because it shouldn't cause harm, but
sure this needs to be fixed.

> 
>   2. The refresh needs to be noted after memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
Are you sure? The check is first because if it fails, then error is returned to userspace
and the KVM's state left unchanged.

I assume you are talking about 

        ....
	r = kvm_apic_state_fixup(vcpu, s, true);
	if (r) {
		kvm_recalculate_apic_map(vcpu->kvm);
		return r;
	}
	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
        ....


> 
> and a third bug in the helper itself, as changes to the ID should be ignored if
> the APIC is hardward disabled since the ID is reset to the vcpu_id when the APIC
> is hardware enabled (architecturally behavior).

That is true, and something I haven't thought about.

Best regards,
	Maxim Levitsky



> 
> ---
>  arch/x86/kvm/lapic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 804d529d9bfb..b8b2faf5abc7 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2159,6 +2159,9 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  {
>  	struct kvm *kvm = apic->vcpu->kvm;
>  
> +	if (!kvm_apic_hw_enabled(apic))
> +		return;
> +
>  	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>  		return;
>  
> @@ -2875,8 +2878,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
>  			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
>  			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
>  		}
> -	} else {
> -		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
>  	}
>  
>  	return 0;
> @@ -2912,6 +2913,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	}
>  	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>  
> +	if (!apic_x2apic_mode(vcpu->arch.apic))
> +		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
> +
>  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>  	kvm_recalculate_apic_map(vcpu->kvm);
>  	kvm_apic_set_version(vcpu);
> 
> base-commit: 0b502152c0b8523f399bdb53096e2d620c5795b5


