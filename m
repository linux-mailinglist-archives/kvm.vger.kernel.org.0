Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12C4647864
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiLHV7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLHV6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC06721A8
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ASIj2kEQ6oY1hd8auPy7e53VDe/NPdiMHyAQK+FFLxI=;
        b=GUxkxRmgXdlgbffy2qGtf1VVShgE2QIfQkAscBNBPg1mZ+Yvzk8vwUEBKRUmzY2dAjHmZ9
        21Fz3Hr0SZVvQ7IEnwUTN8B41Kvi98Kf70m+PIolFLqUXArlfBaKadN/WRAsx87PLAIkW9
        5MXEkytQKNUfp+eEbOy0vX/PthzWXBk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-MhO298SpOWi7X7VbPRRFlQ-1; Thu, 08 Dec 2022 16:57:39 -0500
X-MC-Unique: MhO298SpOWi7X7VbPRRFlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CF7D29AA3AF;
        Thu,  8 Dec 2022 21:57:39 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BFA22024CC0;
        Thu,  8 Dec 2022 21:57:37 +0000 (UTC)
Message-ID: <96c369fb2042e8722256d36c9b2ccf4a930752d1.camel@redhat.com>
Subject: Re: [PATCH v4 19/32] KVM: x86: Explicitly track all possibilities
 for APIC map's logical modes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:57:36 +0200
In-Reply-To: <20221001005915.2041642-20-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-20-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
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
>  arch/x86/include/asm/kvm_host.h | 21 +++++++++++---------
>  arch/x86/kvm/lapic.c            | 35 +++++++++++++++++++++++++--------
>  2 files changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 062758135c86..ac28bbfbf0e3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -962,19 +962,22 @@ struct kvm_arch_memory_slot {
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

It would be nice to have short comment about each of the modes, like

/* All local APICs are disabled */
> +	KVM_APIC_MODE_SW_DISABLED,
/* All enabled local APICs are in XAPIC mode using cluster logical addresssing */
> +	KVM_APIC_MODE_XAPIC_CLUSTER,
/* All enabled local APICs are in XAPIC mode using flat logical addresssing */
> +	KVM_APIC_MODE_XAPIC_FLAT,
/* All enabled local APICs are in X2APIC mode */
> +	KVM_APIC_MODE_X2APIC,
/* 
   Due to differencies in mode between enabled local APICs and/or other corner cases, 
   the optimized logical map disabled 
*/
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
> index cef8b202490b..9989893fef69 100644
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
>  		u16 mask;
>  		u32 ldr;
>  		u8 xapic_id;
> @@ -282,7 +291,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
>  			new->phys_map[xapic_id] = apic;
>  
> -		if (!kvm_apic_sw_enabled(apic))
> +		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
> +		    !kvm_apic_sw_enabled(apic))
>  			continue;
Very minor nitpick: it feels to me that code that updates the logical mode of the
map, might be better to be in a function, or in 'if', like

		if (new->logical_mode != KVM_APIC_MODE_MAP_DISABLED) {

			/* Disabled local APICs don't affect the logical map */
			if (!kvm_apic_sw_enabled(apic))
				continue;
			....
		}
>  
>  		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> @@ -290,17 +300,26 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
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

How about:

		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED)
			new->logical_mode = logical_mode;

		if (new->logical_mode != logical_mode) {
			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
			continue;
		}
		
>  
> -		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
> +		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
> +								&cluster, &mask))) {
> +			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
>  			continue;
> +		}
>  
>  		if (mask)
>  			cluster[ffs(mask) - 1] = apic;
> @@ -953,7 +972,7 @@ static bool kvm_apic_is_broadcast_dest(struct kvm *kvm, struct kvm_lapic **src,
>  {
>  	if (kvm->arch.x2apic_broadcast_quirk_disabled) {
>  		if ((irq->dest_id == APIC_BROADCAST &&
> -				map->mode != KVM_APIC_MODE_X2APIC))
> +		     map->logical_mode != KVM_APIC_MODE_X2APIC))
>  			return true;
>  		if (irq->dest_id == X2APIC_BROADCAST)
>  			return true;


Functionality wise the code looks OK to me.

Best regards,
	Maxim Levitsky

