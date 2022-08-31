Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15A5A7F62
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiHaN5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiHaN5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:57:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9B5D5EAA
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661954258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+qKO8x9wJXIemADSTXaheYi94IJqj0ek71ZlDgYpGA=;
        b=CiE36y9XNPTC9bcOwdQdJ/DjoP2LM4LibRXhgcuD91A9pC701ZCqL5TDDyq9FCreew7sWE
        CX2IWhIqPE70WEaeH9KjREELEC/4xl3gfZ02j+1/KsP6H5ZZHA91WN22iJNEW8j37CGCur
        YeESHDzVzJEYHoJZtRFAB7W/+arbDEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-xujqo_CLMIa0sGDzSJxApw-1; Wed, 31 Aug 2022 09:57:33 -0400
X-MC-Unique: xujqo_CLMIa0sGDzSJxApw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8822980418F;
        Wed, 31 Aug 2022 13:57:32 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4BDB1415117;
        Wed, 31 Aug 2022 13:57:30 +0000 (UTC)
Message-ID: <ca3be5f88268f1547e6f02b01a472186566066c5.camel@redhat.com>
Subject: Re: [PATCH 17/19] KVM: SVM: Handle multiple logical targets in AVIC
 kick fastpath
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 16:57:29 +0300
In-Reply-To: <20220831003506.4117148-18-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-18-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> Iterate over all target logical IDs in the AVIC kick fastpath instead of
> bailing if there is more than one target and KVM's optimized APIC map is
> enabled for logical mode.  If the optimized map is enabled, all vCPUs are
> guaranteed to be mapped 1:1 to a logical ID or effectively have logical
> mode disabled, i.e. iterating over the bitmap is guaranteed to kick each
> target exactly once.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 126 +++++++++++++++++++++++++---------------
>  1 file changed, 79 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 2095ece70712..dad5affe44c1 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -339,6 +339,62 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
>  					icrl & APIC_VECTOR_MASK);
>  }
>  
> +static void avic_kick_vcpu_by_physical_id(struct kvm *kvm, u32 physical_id,
> +					  u32 icrl)
> +{
> +	/*
> +	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
> +	 * i.e. APIC ID == vCPU ID.
> +	 */
> +	struct kvm_vcpu *target_vcpu = kvm_get_vcpu_by_id(kvm, physical_id);
> +
> +	/* Once again, nothing to do if the target vCPU doesn't exist. */
> +	if (unlikely(!target_vcpu))
> +		return;
> +
> +	avic_kick_vcpu(target_vcpu, icrl);
> +}
> +
> +static void avic_kick_vcpu_by_logical_id(struct kvm *kvm, u32 *avic_logical_id_table,
> +					 u32 logid_index, u32 icrl)
> +{
> +	u32 physical_id;
> +
> +	if (!avic_logical_id_table) {
^ Typo, the '!' shoudn't be there.

> +		u32 logid_entry = avic_logical_id_table[logid_index];
> +
> +		/* Nothing to do if the logical destination is invalid. */
> +		if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
> +			return;
> +
> +		physical_id = logid_entry &
> +			      AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
> +	} else {
> +		/*
> +		 * For x2APIC, the logical APIC ID is a read-only value that is
> +		 * derived from the x2APIC ID, thus the x2APIC ID can be found
> +		 * by reversing the calculation (stored in logid_index).  Note,
> +		 * bits 31:20 of the x2APIC ID aren't propagated to the logical
> +		 * ID, but KVM limits the x2APIC ID limited to KVM_MAX_VCPU_IDS.
> +		 */
> +		physical_id = logid_index;
> +	}
> +
> +	avic_kick_vcpu_by_physical_id(kvm, physical_id, icrl);
> +}

These two functions are a very good cleanup IMHO.

> +
> +static bool is_optimized_logical_map_enabled(struct kvm *kvm)
> +{
> +	struct kvm_apic_map *map;
> +	bool enabled;
> +
> +	rcu_read_lock();
> +	map = rcu_dereference(kvm->arch.apic_map);
> +	enabled = map && map->logical_mode != KVM_APIC_MODE_MAP_DISABLED;
> +	rcu_read_unlock();
> +	return enabled;
> +}

This function doesn't belong to avic, it should be in common KVM code.


> +
>  /*
>   * A fast-path version of avic_kick_target_vcpus(), which attempts to match
>   * destination APIC ID to vCPU without looping through all vCPUs.
> @@ -346,11 +402,10 @@ static void avic_kick_vcpu(struct kvm_vcpu *vcpu, u32 icrl)
>  static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source,
>  				       u32 icrl, u32 icrh, u32 index)
>  {
> -	u32 l1_physical_id, dest;
> -	struct kvm_vcpu *target_vcpu;
>  	int dest_mode = icrl & APIC_DEST_MASK;
>  	int shorthand = icrl & APIC_SHORT_MASK;
>  	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +	u32 dest;
>  
>  	if (shorthand != APIC_DEST_NOSHORT)
>  		return -EINVAL;
> @@ -367,14 +422,14 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		if (!apic_x2apic_mode(source) && dest == APIC_BROADCAST)
>  			return -EINVAL;
>  
> -		l1_physical_id = dest;
> -
> -		if (WARN_ON_ONCE(l1_physical_id != index))
> +		if (WARN_ON_ONCE(dest != index))
>  			return -EINVAL;
>  
> +		avic_kick_vcpu_by_physical_id(kvm, dest, icrl);
>  	} else {
> -		u32 bitmap, cluster;
> -		int logid_index;
> +		u32 *avic_logical_id_table;
> +		unsigned long bitmap, i;
> +		u32 cluster;
>  
>  		if (apic_x2apic_mode(source)) {
>  			/* 16 bit dest mask, 16 bit cluster id */
> @@ -394,50 +449,27 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		if (unlikely(!bitmap))
>  			return 0;
>  
> -		if (!is_power_of_2(bitmap))
> -			/* multiple logical destinations, use slow path */
> +		/*
> +		 * Use the slow path if more than one bit is set in the bitmap
> +		 * and KVM's optimized logical map is disabled to avoid kicking
> +		 * a vCPU multiple times.  If the optimized map is disabled, a
> +		 * vCPU _may_ have multiple bits set in its logical ID, i.e.
> +		 * may have multiple entries in the logical table.
> +		 */
> +		if (!is_power_of_2(bitmap) &&
> +		    !is_optimized_logical_map_enabled(kvm))
>  			return -EINVAL;


I hate to say it but there is another issue here, which I know about for a while
but haven't gotten yet to fix.

The issue is that AVIC's logical to physical map can't cover all the corner cases
that you discovered - it only supports the sane subset: for each cluster, and for each bit
in the mask, it has a physical apic id - so things like logical ids with multiple bits,
having same logical id for multiple vcpus and so on can't work.

In this case we need to either inhibit AVIC (I support this 100%), or clear
its logical ID map, so all logicical IPIs VM exit, and then they can be emulated.

I haven't studied it formally but the code which rebuilds the AVIC's logical ID map
starts at 'avic_handle_ldr_update'.


Besides that this patch makes sense, and it explains why you removed the logic which
was incorrectly checking for having a single bit in the bitmap, but I still
prefer to revert the patch as I explained there.

Best regards,
	Maxim Levitsky

>  
> -		logid_index = cluster + __ffs(bitmap);
> -
> -		if (!apic_x2apic_mode(source)) {
> -			u32 *avic_logical_id_table =
> -				page_address(kvm_svm->avic_logical_id_table_page);
> -
> -			u32 logid_entry = avic_logical_id_table[logid_index];
> -
> -			if (WARN_ON_ONCE(index != logid_index))
> -				return -EINVAL;
> -
> -			/* Nothing to do if the logical destination is invalid. */
> -			if (unlikely(!(logid_entry & AVIC_LOGICAL_ID_ENTRY_VALID_MASK)))
> -				return 0;
> -
> -			l1_physical_id = logid_entry &
> -					 AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK;
> -		} else {
> -			/*
> -			 * For x2APIC, the logical APIC ID is a read-only value
> -			 * that is derived from the x2APIC ID, thus the x2APIC
> -			 * ID can be found by reversing the calculation (done
> -			 * above).  Note, bits 31:20 of the x2APIC ID are not
> -			 * propagated to the logical ID, but KVM limits the
> -			 * x2APIC ID limited to KVM_MAX_VCPU_IDS.
> -			 */
> -			l1_physical_id = logid_index;
> -		}
> +		if (apic_x2apic_mode(source))
> +			avic_logical_id_table = NULL;
> +		else
> +			avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
> +
> +		for_each_set_bit(i, &bitmap, 16)
> +			avic_kick_vcpu_by_logical_id(kvm, avic_logical_id_table,
> +						     cluster + i, icrl);
>  	}
>  
> -	/*
> -	 * KVM inhibits AVIC if any vCPU ID diverges from the vCPUs APIC ID,
> -	 * i.e. APIC ID == vCPU ID.  Once again, nothing to do if the target
> -	 * vCPU doesn't exist.
> -	 */
> -	target_vcpu = kvm_get_vcpu_by_id(kvm, l1_physical_id);
> -	if (unlikely(!target_vcpu))
> -		return 0;
> -
> -	avic_kick_vcpu(target_vcpu, icrl);
>  	return 0;
>  }
>  


