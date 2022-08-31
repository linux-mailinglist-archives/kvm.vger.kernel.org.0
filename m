Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0F95A7F1E
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiHaNnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiHaNnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:43:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F8CD2928
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661953407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8pS8kArZdqj3nVOpVcm6dWHWuc9UK8v0cVrJN8ErYI=;
        b=ImvZ/d484H72J9rx5g6ovS5mDuJFT3VEkX4rTYFx5ISq2FVmWVcxfBpP5Am3qbt2HDxS97
        skS8RXHCwDkX+rwj9vExAJO0oYP/eWOgg6ZgdSYahpadMCILDsOI/gNdOrBJZnuZUPiGqN
        ijwMluS2Tb3yYxaowTDDKRva8i+rrhE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-v44JciQiNu-uKn9Goq08Pw-1; Wed, 31 Aug 2022 09:43:22 -0400
X-MC-Unique: v44JciQiNu-uKn9Goq08Pw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25493800124;
        Wed, 31 Aug 2022 13:43:22 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83C671121314;
        Wed, 31 Aug 2022 13:43:20 +0000 (UTC)
Message-ID: <8d3569a8b2d1563eb3ff665118ffc5c8d7e1e2f2.camel@redhat.com>
Subject: Re: [PATCH 16/19] KVM: x86: Explicitly track all possibilities for
 APIC map's logical modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 16:43:19 +0300
In-Reply-To: <20220831003506.4117148-17-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-17-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> Track all possibilities for the optimized APIC map's logical modes
> instead of overloading the pseudo-bitmap and treating any "unknown" value
> as "invalid".
> 
> As documented by the now-stale comment above the mode values, the values
> did have meaning when the optimized map was originally added.  That
> dependent logical was removed by commit e45115b62f9a ("KVM: x86: use
> physical LAPIC array for logical x2APIC"), but the obfuscated behavior
> and its comment were left behind.
> 
> Opportunistically rename "mode" to "logical_mode", partly to make it
> clear that the "disabled" case applies only to the logical map, but also
> to prove that there is no lurking code that expects "mode" to be a bitmap.
> 
> Functionally, this is a glorified nop.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 21 ++++++++++--------
>  arch/x86/kvm/lapic.c            | 38 ++++++++++++++++++++++++---------
>  2 files changed, 40 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1f51411f3112..0184e64ab555 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -955,19 +955,22 @@ struct kvm_arch_memory_slot {
>  };
>  
>  /*
> - * We use as the mode the number of bits allocated in the LDR for the
> - * logical processor ID.  It happens that these are all powers of two.
> - * This makes it is very easy to detect cases where the APICs are
> - * configured for multiple modes; in that case, we cannot use the map and
> - * hence cannot use kvm_irq_delivery_to_apic_fast either.
> + * Track the mode of the optimized logical map, as the rules for decoding the
> + * destination vary per mode.  Enabling the optimized logical map requires all
> + * software-enabled local APIs to be in the same mode, each addressable APIC to
> + * be mapped to only one MDA, and each MDA to map to at most one APIC.
>   */
> -#define KVM_APIC_MODE_XAPIC_CLUSTER          4
> -#define KVM_APIC_MODE_XAPIC_FLAT             8
> -#define KVM_APIC_MODE_X2APIC                16
> +enum kvm_apic_logical_mode {
> +	KVM_APIC_MODE_SW_DISABLED,
> +	KVM_APIC_MODE_XAPIC_CLUSTER,
> +	KVM_APIC_MODE_XAPIC_FLAT,
> +	KVM_APIC_MODE_X2APIC,
> +	KVM_APIC_MODE_MAP_DISABLED,
> +};
>  
>  struct kvm_apic_map {
>  	struct rcu_head rcu;
> -	u8 mode;
> +	enum kvm_apic_logical_mode logical_mode;
>  	u32 max_apic_id;
>  	union {
>  		struct kvm_lapic *xapic_flat_map[8];
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8209caffe3ab..3b6ef36b3963 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -168,7 +168,12 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
>  		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
> -	switch (map->mode) {
> +	switch (map->logical_mode) {
> +	case KVM_APIC_MODE_SW_DISABLED:
> +		/* Arbitrarily use the flat map so that @cluster isn't NULL. */
> +		*cluster = map->xapic_flat_map;
> +		*mask = 0;
> +		return true;
Could you explain why this is needed? I probably missed something.

>  	case KVM_APIC_MODE_X2APIC: {
>  		u32 offset = (dest_id >> 16) * 16;
>  		u32 max_apic_id = map->max_apic_id;
> @@ -193,8 +198,10 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
>  		*cluster = map->xapic_cluster_map[(dest_id >> 4) & 0xf];
>  		*mask = dest_id & 0xf;
>  		return true;
> +	case KVM_APIC_MODE_MAP_DISABLED:
> +		return false;
>  	default:
> -		/* Not optimized. */
> +		WARN_ON_ONCE(1);
>  		return false;
>  	}
>  }
> @@ -256,10 +263,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		goto out;
>  
>  	new->max_apic_id = max_id;
> +	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		struct kvm_lapic *apic = vcpu->arch.apic;
>  		struct kvm_lapic **cluster;
> +		enum kvm_apic_logical_mode logical_mode;
>  		u32 x2apic_id, physical_id;
>  		u16 mask;
>  		u32 ldr;
> @@ -314,7 +323,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  			new->phys_map[physical_id] = apic;
>  		}
>  
> -		if (!kvm_apic_sw_enabled(apic))
> +		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
> +		    !kvm_apic_sw_enabled(apic))
>  			continue;
>  
>  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> @@ -322,25 +332,33 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  			continue;
>  
>  		if (apic_x2apic_mode(apic)) {
> -			new->mode |= KVM_APIC_MODE_X2APIC;
> +			logical_mode = KVM_APIC_MODE_X2APIC;
>  		} else {
>  			ldr = GET_APIC_LOGICAL_ID(ldr);
>  			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
> -				new->mode |= KVM_APIC_MODE_XAPIC_FLAT;
> +				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
>  			else
> -				new->mode |= KVM_APIC_MODE_XAPIC_CLUSTER;
> +				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
>  		}
> +		if (new->logical_mode != KVM_APIC_MODE_SW_DISABLED &&
> +		    new->logical_mode != logical_mode) {
> +			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> +			continue;
> +		}
> +		new->logical_mode = logical_mode;
>  
> -		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
> +		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
> +								&cluster, &mask))) {
> +			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
>  			continue;
> +		}
>  
>  		if (!mask)
>  			continue;
>  
>  		ldr = ffs(mask) - 1;
>  		if (!is_power_of_2(mask) || cluster[ldr]) {
> -			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
> -				    KVM_APIC_MODE_XAPIC_CLUSTER;
> +			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
>  			continue;
>  		}
>  		cluster[ldr] = apic;
> @@ -993,7 +1011,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
>  {
>  	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
>  		if ((irq->dest_id == APIC_BROADCAST &&
> -				map->mode != KVM_APIC_MODE_X2APIC))
> +		     map->logical_mode != KVM_APIC_MODE_X2APIC))
>  			return true;
>  		if (irq->dest_id == X2APIC_BROADCAST)
>  			return true;

To be honest I would put that patch first, and then do all the other patches, this
way you would avoid all of the hacks they do and removed here.


Other than that this looks like a very good cleanup.

Best regards,
	Maxim Levitsky



