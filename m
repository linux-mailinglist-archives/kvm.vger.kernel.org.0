Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA89647867
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiLHV7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLHV66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:58:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480F7E62
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJ0em+eljjUI8oUv+HNXrXjRViEN7vmZYx2pW3NMCY4=;
        b=jGgKWj7SxUYzyz5NNb0Fx8x6NuGi6ZOeMG3J3VKW1yGPgyYnfZashARf9kQrrAdZXfMV1g
        UkrgjWBJHBXvk0rcXFwETiGJmffQoSQEumJqEutLQ3qHhmc6+JXsE6Rjcz2kz2rfSHuCWq
        2nGG3674wM7hyjPMjdGgEySpt3CKoRw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-yzRp5xPNNhSCsRnKM7mjDQ-1; Thu, 08 Dec 2022 16:57:54 -0500
X-MC-Unique: yzRp5xPNNhSCsRnKM7mjDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F98529AA387;
        Thu,  8 Dec 2022 21:57:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 186951121331;
        Thu,  8 Dec 2022 21:57:52 +0000 (UTC)
Message-ID: <95dfb8f37cd218ea706ed8ee7c105656c282fcba.camel@redhat.com>
Subject: Re: [PATCH v4 20/32] KVM: x86: Skip redundant x2APIC logical mode
 optimized cluster setup
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:57:52 +0200
In-Reply-To: <20221001005915.2041642-21-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-21-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> Skip the optimized cluster[] setup for x2APIC logical mode, as KVM reuses
> the optimized map's phys_map[] and doesn't actually need to insert the
> target apic into the cluster[].  The LDR is derived from the x2APIC ID,
> and both are read-only in KVM, thus the vCPU's cluster[ldr] is guaranteed
> to be the same entry as the vCPU's phys_map[x2apic_id] entry.
> 
> Skipping the unnecessary setup will allow a future fix for aliased xAPIC
> logical IDs to simply require that cluster[ldr] is non-NULL, i.e. won't
> have to special case x2APIC.

> Alternatively, the future check could allow "cluster[ldr] == apic", but
> that ends up being terribly confusing because cluster[ldr] is only set
> at the very end, i.e. it's only possible due to x2APIC's shenanigans.
> 
> Another alternative would be to send x2APIC down a separate path _after_
> the calculation and then assert that all of the above, but the resulting
> code is rather messy, and it's arguably unnecessary since asserting that
> the actual LDR matches the expected LDR means that simply testing that
> interrupts are delivered correctly provides the same guarantees.


Yes, I think it makes sense to not touch the cluser map in x2apic mode.
The map even explicitly named as for xapic (xapic_flat_map, xapic_cluster_map)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


> 
> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9989893fef69..fca8bbb44375 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -166,6 +166,11 @@ static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
>  	return kvm_can_post_timer_interrupt(vcpu) && vcpu->mode == IN_GUEST_MODE;
>  }
>  
> +static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
> +{
> +	return ((id >> 4) << 16) | (1 << (id & 0xf));
> +}
> +
>  static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
>  		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
>  	switch (map->logical_mode) {
> @@ -315,6 +320,18 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		}
>  		new->logical_mode = logical_mode;
>  
> +		/*
> +		 * In x2APIC mode, the LDR is read-only and derived directly
> +		 * from the x2APIC ID, thus is guaranteed to be addressable.
> +		 * KVM reuses kvm_apic_map.phys_map to optimize logical mode
> +		 * x2APIC interrupts by reversing the LDR calculation to get
> +		 * cluster of APICs, i.e. no additional work is required.
> +		 */
> +		if (apic_x2apic_mode(apic)) {
> +			WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
> +			continue;
> +		}
> +
>  		if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
>  								&cluster, &mask))) {
>  			new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> @@ -381,11 +398,6 @@ static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
>  	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>  }
>  
> -static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
> -{
> -	return ((id >> 4) << 16) | (1 << (id & 0xf));
> -}
> -
>  static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  {
>  	u32 ldr = kvm_apic_calc_x2apic_ldr(id);


