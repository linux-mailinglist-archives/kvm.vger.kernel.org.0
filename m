Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46B661632
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 16:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjAHPdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 10:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjAHPdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 10:33:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FFCF58A
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 07:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673191974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkLd/nHNe1oQsB4/AkbibJ6pzG7cY0vYfVKTJREI4y8=;
        b=X+J2S/1EyLDWE2Kq9GYEbixU7bhOysSqfiz2bU1WyOYqn8l2m/tXvyv+Imbggus721c40z
        WYqEOngQ6pU290w+W7L387MYieajpwGh1/9Cf7uDc6vEC4HtPfpEkc+NUrDbpNAVJXzhTm
        lW0I8kPE3InJViU6qfh4AoXymGQySig=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-119-V-UVPr_4N6C9NVItvMhwKQ-1; Sun, 08 Jan 2023 10:32:52 -0500
X-MC-Unique: V-UVPr_4N6C9NVItvMhwKQ-1
Received: by mail-ed1-f72.google.com with SMTP id b16-20020a056402279000b0046fb99731e6so3866232ede.1
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 07:32:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vkLd/nHNe1oQsB4/AkbibJ6pzG7cY0vYfVKTJREI4y8=;
        b=NnpzJ+2xybzyOOOZl2+QBVSepM3z2EWl3ARIW2++bQeYwyun+eMVkRaK/XAaqQa2Q9
         JFLAZYKkTIaxgPYWdLHd6rPnDX3U2JeyrQagqACV2QriPa9YU6h4DQxGoQe2kU2yiMLc
         G06NphZkhKonBaVllBrZik6eh11qgEQsA875QnxC0YM0OmwB9Lz7HMNRUOeo5f2hWF7Z
         bl/mA+/8sCFqOBY1gKfF6U1LqX7MSFIbJ5s4F7m3lwQ3RA9yDgoeTot42Kjf8/Bb49MQ
         7ujOAtwR4s57ZGPqw7HJRgLmYO7XYehNsSpMb3RRciWM2dmVJr5lS97Rat349NkRyoX/
         9NfQ==
X-Gm-Message-State: AFqh2kqPNnGo5ekkdp/kSVxVtEhkrqg2sKjxP9doo1YaOwcDKczohR0N
        8i+Yj2rpmhejXuIhSTU5lc7KPltBkH1xXrxNR3D3GbOTElHvzgtWMirmIXmrFP231Rw9nja/9As
        t577XmkGH9C6C
X-Received: by 2002:a17:907:3e96:b0:7c4:f501:e5b1 with SMTP id hs22-20020a1709073e9600b007c4f501e5b1mr71157328ejc.51.1673191971427;
        Sun, 08 Jan 2023 07:32:51 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs2+OE24Y1ENktJS2QZAYKf1yBWYsyQ04nF8EbsLDzDfJhOlSnwwi07p2Vo+AvgoeVl96r4PA==
X-Received: by 2002:a17:907:3e96:b0:7c4:f501:e5b1 with SMTP id hs22-20020a1709073e9600b007c4f501e5b1mr71157311ejc.51.1673191971173;
        Sun, 08 Jan 2023 07:32:51 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id y9-20020a1709064b0900b0084d34979423sm1693907eju.127.2023.01.08.07.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 07:32:50 -0800 (PST)
Message-ID: <e90e4c4bd558b9e41acea9f8ce84783e7341c9b4.camel@redhat.com>
Subject: Re: [PATCH v5 33/33] KVM: x86: Add helpers to recalc physical vs.
 logical optimized APIC maps
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
Date:   Sun, 08 Jan 2023 17:32:48 +0200
In-Reply-To: <20230106011306.85230-34-seanjc@google.com>
References: <20230106011306.85230-1-seanjc@google.com>
         <20230106011306.85230-34-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2023-01-06 at 01:13 +0000, Sean Christopherson wrote:
> Move the guts of kvm_recalculate_apic_map()'s main loop to two separate
> helpers to handle recalculating the physical and logical pieces of the
> optimized map.  Having 100+ lines of code in the for-loop makes it hard
> to understand what is being calculated where.
> 
> No functional change intended.
> 
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 250 +++++++++++++++++++++++--------------------
>  1 file changed, 133 insertions(+), 117 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 856e81a2dc64..669ea125b7e2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -218,6 +218,134 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>  	kvfree(map);
>  }
>  
> +static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
> +				    struct kvm_vcpu *vcpu,
> +				    bool *xapic_id_mismatch)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	u32 x2apic_id = kvm_x2apic_id(apic);
> +	u32 xapic_id = kvm_xapic_id(apic);
> +	u32 physical_id;
> +
> +	/*
> +	 * Deliberately truncate the vCPU ID when detecting a mismatched APIC
> +	 * ID to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a
> +	 * 32-bit value.  Any unwanted aliasing due to truncation results will
> +	 * be detected below.
> +	 */
> +	if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
> +		*xapic_id_mismatch = true;
> +
> +	/*
> +	 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC IDs.
> +	 * Allow sending events to vCPUs by their x2APIC ID even if the target
> +	 * vCPU is in legacy xAPIC mode, and silently ignore aliased xAPIC IDs
> +	 * (the x2APIC ID is truncated to 8 bits, causing IDs > 0xff to wrap
> +	 * and collide).
> +	 *
> +	 * Honor the architectural (and KVM's non-optimized) behavior if
> +	 * userspace has not enabled 32-bit x2APIC IDs.  Each APIC is supposed
> +	 * to process messages independently.  If multiple vCPUs have the same
> +	 * effective APIC ID, e.g. due to the x2APIC wrap or because the guest
> +	 * manually modified its xAPIC IDs, events targeting that ID are
> +	 * supposed to be recognized by all vCPUs with said ID.
> +	 */
> +	if (vcpu->kvm->arch.x2apic_format) {
> +		/* See also kvm_apic_match_physical_addr(). */
> +		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> +			x2apic_id <= new->max_apic_id)
> +			new->phys_map[x2apic_id] = apic;
> +
> +		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> +			new->phys_map[xapic_id] = apic;
> +	} else {
> +		/*
> +		 * Disable the optimized map if the physical APIC ID is already
> +		 * mapped, i.e. is aliased to multiple vCPUs.  The optimized
> +		 * map requires a strict 1:1 mapping between IDs and vCPUs.
> +		 */
> +		if (apic_x2apic_mode(apic))
> +			physical_id = x2apic_id;
> +		else
> +			physical_id = xapic_id;
> +
> +		if (new->phys_map[physical_id])
> +			return -EINVAL;
Very small nitpick: -EINVAL feels like redundant here,
I'll say just return -1 or returning boolean would be a tiny bit better.
But this really doesn't matter much.

> +
> +		new->phys_map[physical_id] = apic;
> +	}
> +
> +	return 0;
> +}
> +
> +static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
> +					struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	enum kvm_apic_logical_mode logical_mode;
> +	struct kvm_lapic **cluster;
> +	u16 mask;
> +	u32 ldr;
> +
> +	if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
> +		return;
> +
> +	if (!kvm_apic_sw_enabled(apic))
> +		return;
> +
> +	ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> +	if (!ldr)
> +		return;
> +
> +	if (apic_x2apic_mode(apic)) {
> +		logical_mode = KVM_APIC_MODE_X2APIC;
> +	} else {
> +		ldr = GET_APIC_LOGICAL_ID(ldr);
> +		if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
> +			logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
> +		else
> +			logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
> +	}
> +
> +	/*
> +	 * To optimize logical mode delivery, all software-enabled APICs must
> +	 * be configured for the same mode.
> +	 */
> +	if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
> +		new->logical_mode = logical_mode;
> +	} else if (new->logical_mode != logical_mode) {
> +		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> +		return;
> +	}
> +
> +	/*
> +	 * In x2APIC mode, the LDR is read-only and derived directly from the
> +	 * x2APIC ID, thus is guaranteed to be addressable.  KVM reuses
> +	 * kvm_apic_map.phys_map to optimize logical mode x2APIC interrupts by
> +	 * reversing the LDR calculation to get cluster of APICs, i.e. no
> +	 * additional work is required.
> +	 */
> +	if (apic_x2apic_mode(apic)) {
> +		WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(kvm_x2apic_id(apic)));
> +		return;
> +	}
> +
> +	if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
> +							&cluster, &mask))) {
> +		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> +		return;
> +	}
> +
> +	if (!mask)
> +		return;
> +
> +	ldr = ffs(mask) - 1;
> +	if (!is_power_of_2(mask) || cluster[ldr])
> +		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> +	else
> +		cluster[ldr] = apic;
> +}
> +
>  /*
>   * CLEAN -> DIRTY and UPDATE_IN_PROGRESS -> DIRTY changes happen without a lock.
>   *
> @@ -272,128 +400,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  	new->logical_mode = KVM_APIC_MODE_SW_DISABLED;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		struct kvm_lapic *apic = vcpu->arch.apic;
> -		struct kvm_lapic **cluster;
> -		enum kvm_apic_logical_mode logical_mode;
> -		u32 x2apic_id, physical_id;
> -		u16 mask;
> -		u32 ldr;
> -		u8 xapic_id;
> -
>  		if (!kvm_apic_present(vcpu))
>  			continue;
>  
> -		xapic_id = kvm_xapic_id(apic);
> -		x2apic_id = kvm_x2apic_id(apic);
> -
> -		/*
> -		 * Deliberately truncate the vCPU ID when detecting a mismatched
> -		 * APIC ID to avoid false positives if the vCPU ID, i.e. x2APIC
> -		 * ID, is a 32-bit value.  Any unwanted aliasing due to
> -		 * truncation results will be detected below.
> -		 */
> -		if (!apic_x2apic_mode(apic) && xapic_id != (u8)vcpu->vcpu_id)
> -			xapic_id_mismatch = true;
> -
> -		/*
> -		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
> -		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
> -		 * if the target vCPU is in legacy xAPIC mode, and silently
> -		 * ignore aliased xAPIC IDs (the x2APIC ID is truncated to 8
> -		 * bits, causing IDs > 0xff to wrap and collide).
> -		 *
> -		 * Honor the architectural (and KVM's non-optimized) behavior
> -		 * if userspace has not enabled 32-bit x2APIC IDs.  Each APIC
> -		 * is supposed to process messages independently.  If multiple
> -		 * vCPUs have the same effective APIC ID, e.g. due to the
> -		 * x2APIC wrap or because the guest manually modified its xAPIC
> -		 * IDs, events targeting that ID are supposed to be recognized
> -		 * by all vCPUs with said ID.
> -		 */
> -		if (kvm->arch.x2apic_format) {
> -			/* See also kvm_apic_match_physical_addr(). */
> -			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> -			    x2apic_id <= new->max_apic_id)
> -				new->phys_map[x2apic_id] = apic;
> -
> -			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> -				new->phys_map[xapic_id] = apic;
> -		} else {
> -			/*
> -			 * Disable the optimized map if the physical APIC ID is
> -			 * already mapped, i.e. is aliased to multiple vCPUs.
> -			 * The optimized map requires a strict 1:1 mapping
> -			 * between IDs and vCPUs.
> -			 */
> -			if (apic_x2apic_mode(apic))
> -				physical_id = x2apic_id;
> -			else
> -				physical_id = xapic_id;
> -
> -			if (new->phys_map[physical_id]) {
> -				kvfree(new);
> -				new = NULL;
> -				goto out;
> -			}
> -			new->phys_map[physical_id] = apic;
> -		}
> -
> -		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
> -		    !kvm_apic_sw_enabled(apic))
> -			continue;
> -
> -		ldr = kvm_lapic_get_reg(apic, APIC_LDR);
> -		if (!ldr)
> -			continue;
> -
> -		if (apic_x2apic_mode(apic)) {
> -			logical_mode = KVM_APIC_MODE_X2APIC;
> -		} else {
> -			ldr = GET_APIC_LOGICAL_ID(ldr);
> -			if (kvm_lapic_get_reg(apic, APIC_DFR) == APIC_DFR_FLAT)
> -				logical_mode = KVM_APIC_MODE_XAPIC_FLAT;
> -			else
> -				logical_mode = KVM_APIC_MODE_XAPIC_CLUSTER;
> +		if (kvm_recalculate_phys_map(new, vcpu, &xapic_id_mismatch)) {
> +			kvfree(new);
> +			new = NULL;
> +			goto out;
>  		}
>  
> -		/*
> -		 * To optimize logical mode delivery, all software-enabled APICs must
> -		 * be configured for the same mode.
> -		 */
> -		if (new->logical_mode == KVM_APIC_MODE_SW_DISABLED) {
> -			new->logical_mode = logical_mode;
> -		} else if (new->logical_mode != logical_mode) {
> -			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> -			continue;
> -		}
> -
> -		/*
> -		 * In x2APIC mode, the LDR is read-only and derived directly
> -		 * from the x2APIC ID, thus is guaranteed to be addressable.
> -		 * KVM reuses kvm_apic_map.phys_map to optimize logical mode
> -		 * x2APIC interrupts by reversing the LDR calculation to get
> -		 * cluster of APICs, i.e. no additional work is required.
> -		 */
> -		if (apic_x2apic_mode(apic)) {
> -			WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
> -			continue;
> -		}
> -
> -		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
> -								&cluster, &mask))) {
> -			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> -			continue;
> -		}
> -
> -		if (!mask)
> -			continue;
> -
> -		ldr = ffs(mask) - 1;
> -		if (!is_power_of_2(mask) || cluster[ldr]) {
> -			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> -			continue;
> -		}
> -		cluster[ldr] = apic;
> +		kvm_recalculate_logical_map(new, vcpu);
>  	}
>  out:
>  	/*

Looks good, much cleaner now.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


