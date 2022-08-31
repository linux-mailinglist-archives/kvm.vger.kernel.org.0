Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5A05A859E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbiHaSaY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 14:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiHaSaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 14:30:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C121B78A
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 11:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661970305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Si1iwu1R0to21pjaPNDmF4Mnk8lbHWDBxAleduKvEiQ=;
        b=d31FeiHmKCRnbiuGzl0LWG5jX0T+7xEYjmgaXQeP+CU8x7HBFs+wxnyLgP7Az/8oy6XcKD
        fKL6ga6EQXJ6v9pvgCmxgNh6WVfyD9/GEe6b8I5Kut8qRRZt/8iT+LZz68bGhwiHHniW5f
        hlTEYEhYD+YRruXta+esjRWe2ERJOMI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-OndAVcPJPzGN_yIJL-9Dkg-1; Wed, 31 Aug 2022 14:25:03 -0400
X-MC-Unique: OndAVcPJPzGN_yIJL-9Dkg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 089598037AA;
        Wed, 31 Aug 2022 18:25:03 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 673DE40CF8EE;
        Wed, 31 Aug 2022 18:25:01 +0000 (UTC)
Message-ID: <d15e7d7e922b615fbc701ce766caa3e8c703bc6f.camel@redhat.com>
Subject: Re: [PATCH 17/19] KVM: SVM: Handle multiple logical targets in AVIC
 kick fastpath
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 21:25:00 +0300
In-Reply-To: <Yw+mFbuih3rBjMV8@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-18-seanjc@google.com>
         <ca3be5f88268f1547e6f02b01a472186566066c5.camel@redhat.com>
         <Yw+mFbuih3rBjMV8@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 18:19 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> > > +static void avic_kick_vcpu_by_logical_id(struct kvm *kvm, u32 *avic_logical_id_table,
> > > +					 u32 logid_index, u32 icrl)
> > > +{
> > > +	u32 physical_id;
> > > +
> > > +	if (!avic_logical_id_table) {
> > ^ Typo, the '!' shoudn't be there.
> 
> Ouch.  I suspect the tests pass because this just ends up routing events through
> the slow path.  I try to concoct a testcase to expose this bug.
> 
> > > +static bool is_optimized_logical_map_enabled(struct kvm *kvm)
> > > +{
> > > +	struct kvm_apic_map *map;
> > > +	bool enabled;
> > > +
> > > +	rcu_read_lock();
> > > +	map = rcu_dereference(kvm->arch.apic_map);
> > > +	enabled = map && map->logical_mode != KVM_APIC_MODE_MAP_DISABLED;
> > > +	rcu_read_unlock();
> > > +	return enabled;
> > > +}
> > 
> > This function doesn't belong to avic, it should be in common KVM code.
> 
> I'll move it.  I'm not expecting any additional users, but I agree it belongs
> elsewhere.  Actually, might be a moot point (see below).
> 
> > > @@ -394,50 +449,27 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
> > >  		if (unlikely(!bitmap))
> > >  			return 0;
> > >  
> > > -		if (!is_power_of_2(bitmap))
> > > -			/* multiple logical destinations, use slow path */
> > > +		/*
> > > +		 * Use the slow path if more than one bit is set in the bitmap
> > > +		 * and KVM's optimized logical map is disabled to avoid kicking
> > > +		 * a vCPU multiple times.  If the optimized map is disabled, a
> > > +		 * vCPU _may_ have multiple bits set in its logical ID, i.e.
> > > +		 * may have multiple entries in the logical table.
> > > +		 */
> > > +		if (!is_power_of_2(bitmap) &&
> > > +		    !is_optimized_logical_map_enabled(kvm))
> > >  			return -EINVAL;
> > 
> > I hate to say it but there is another issue here, which I know about for a while
> > but haven't gotten yet to fix.
> > 
> > The issue is that AVIC's logical to physical map can't cover all the corner cases
> > that you discovered - it only supports the sane subset: for each cluster, and for each bit
> > in the mask, it has a physical apic id - so things like logical ids with multiple bits,
> > having same logical id for multiple vcpus and so on can't work.
> > 
> > In this case we need to either inhibit AVIC (I support this 100%),
> 
> I like the idea of inhibiting.
> 
> >  or clear its logical ID map, so all logicical IPIs VM exit, and then they
> >  can be emulated.
> > 
> > I haven't studied it formally but the code which rebuilds the AVIC's logical ID map
> > starts at 'avic_handle_ldr_update'.
> 
> I suspected there are issues here, but the new tests passed (somewhat surprisingly)
> so I stopped trying to decipher the AVIC LDR handling.
> 
> Eww.  And the VM-Exit trap logic is broken too.  If the guest updates and disables
> its LDR, SVM returns immediately and doesn't call into common APIC code, i.e. doesn't
> recalc the optimized map.  E.g. if the guest clears its LDR, the optimized map will
> be left as is and the vCPU will receive interrupts using its old LDR.
> 
> 	case APIC_LDR:
> 		if (avic_handle_ldr_update(vcpu))
> 			return 0;
> 		break;
> 
> Rather than handling this purely in AVIC code, what if we a key off of
> the optimized map being enabled?  E.g. drop the return from avic_handle_ldr_update()
> and in the kvm_recalculate_apic_map() do:
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3b6ef36b3963..6e188010b614 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -364,6 +364,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>                 cluster[ldr] = apic;
>         }
>  out:
> +       if (!new || new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
> +               kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_MAP_DISABLED);
> +       else
> +               kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_MAP_DISABLED);
> +

This looks very good, it will even work on APICv, because the 'check_apicv_inhibit_reasons'
will not return true for this new reason (APICv IPIv I think doesn't deal with logical destination at all);

Best regards,
	Maxim Levitsky

>         old = rcu_dereference_protected(kvm->arch.apic_map,
>                         lockdep_is_held(&kvm->arch.apic_map_lock));
>         rcu_assign_pointer(kvm->arch.apic_map, new);
> 


