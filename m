Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE63647869
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiLHV7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLHV7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:59:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9BF82F92
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRn/oyaLj2Lenlib7ojSGd0wXp2ThD8FeODPfDFzqNU=;
        b=VoGo3Bo7QgWTipKNQMXayQg5PIFU2VsNT5S9LQD7jxCn5Indtd6mqEe5raJIKoFxUxoYrn
        wPKdajzFtGEXtoozBDIhY2PU7JpjIZOs+vQs3eUsAckoNwZG0aillLVaQt6EtPNuP+E9Nq
        a/iguZX4dJJc1G19776uT02fv6vA/t8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-lYNX6bY5NMepfsL-XZ04iA-1; Thu, 08 Dec 2022 16:58:05 -0500
X-MC-Unique: lYNX6bY5NMepfsL-XZ04iA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E92E3C0F245;
        Thu,  8 Dec 2022 21:58:05 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAC9D2024CC0;
        Thu,  8 Dec 2022 21:58:03 +0000 (UTC)
Message-ID: <b23995ebbd901a5a6ef322798d803854fc2d3832.camel@redhat.com>
Subject: Re: [PATCH v4 23/32] KVM: x86: Honor architectural behavior for
 aliased 8-bit APIC IDs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:58:03 +0200
In-Reply-To: <20221001005915.2041642-24-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-24-seanjc@google.com>
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
> Apply KVM's hotplug hack if and only if userspace has enabled 32-bit IDs
> for x2APIC.  If 32-bit IDs are not enabled, disable the optimized map to
> honor x86 architectural behavior if multiple vCPUs shared a physical APIC
> ID.  As called out in the changelog that added the hack, all CPUs whose
> (possibly truncated) APIC ID matches the target are supposed to receive
> the IPI.
> 
>   KVM intentionally differs from real hardware, because real hardware
>   (Knights Landing) does just "x2apic_id & 0xff" to decide whether to
>   accept the interrupt in xAPIC mode and it can deliver one interrupt to
>   more than one physical destination, e.g. 0x123 to 0x123 and 0x23.
> 
> Applying the hack even when x2APIC is not fully enabled means KVM doesn't
> correctly handle scenarios where the guest has aliased xAPIC IDs across
> multiple vCPUs, as only the vCPU with the lowest vCPU ID will receive any
> interrupts.  It's extremely unlikely any real world guest aliase APIC IDs,
> or even modifies APIC IDs, but KVM's behavior is arbitrary, e.g. the
> lowest vCPU ID "wins" regardless of which vCPU is "aliasing" and which
> vCPU is "normal".
> 
> Furthermore, the hack is _not_ guaranteed to work!  The hack works if and
> only if the optimized APIC map is successfully allocated.  If the map
> allocation fails (unlikely), KVM will fall back to its unoptimized
> behavior, which _does_ honor the architectural behavior.
> 
> Pivot on 32-bit x2APIC IDs being enabled as that is required to take
> advantage of the hotplug hack (see kvm_apic_state_fixup()), i.e. won't
> break existing setups unless they are way, way off in the weeds.
> 
> And an entry in KVM's errata to document the hack.  Alternatively, KVM
> could provide an actual x2APIC quirk and document the hack that way, but
> there's unlikely to ever be a use case for disabling the quirk.  Go the
> errata route to avoid having to validate a quirk no one cares about.
> 
> Fixes: 5bd5db385b3e ("KVM: x86: allow hotplug of VCPU with APIC ID over 0xff")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/x86/errata.rst | 11 ++++++
>  arch/x86/kvm/lapic.c                  | 50 ++++++++++++++++++++++-----
>  2 files changed, 52 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
> index 410e0aa63493..49a05f24747b 100644
> --- a/Documentation/virt/kvm/x86/errata.rst
> +++ b/Documentation/virt/kvm/x86/errata.rst
> @@ -37,3 +37,14 @@ Nested virtualization features
>  ------------------------------
>  
>  TBD
> +
> +x2APIC
> +------
> +When KVM_X2APIC_API_USE_32BIT_IDS is enabled, KVM activates a hack/quirk that
> +allows sending events to a single vCPU using its x2APIC ID even if the target
> +vCPU has legacy xAPIC enabled, e.g. to bring up hotplugged vCPUs via INIT-SIPI
> +on VMs with > 255 vCPUs.  A side effect of the quirk is that, if multiple vCPUs
> +have the same physical APIC ID, KVM will deliver events targeting that APIC ID
> +only to the vCPU with the lowest vCPU ID.  If KVM_X2APIC_API_USE_32BIT_IDS is
> +not enabled, KVM follows x86 architecture when processing interrupts (all vCPUs
> +matching the target APIC ID receive the interrupt).

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 14f03e654de4..340c2d3e781b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -274,10 +274,10 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		struct kvm_lapic *apic = vcpu->arch.apic;
>  		struct kvm_lapic **cluster;
>  		enum kvm_apic_logical_mode logical_mode;
> +		u32 x2apic_id, physical_id;
>  		u16 mask;
>  		u32 ldr;
>  		u8 xapic_id;
> -		u32 x2apic_id;
>  
>  		if (!kvm_apic_present(vcpu))
>  			continue;
> @@ -285,16 +285,48 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		xapic_id = kvm_xapic_id(apic);
>  		x2apic_id = kvm_x2apic_id(apic);
>  
> -		/* Hotplug hack: see kvm_apic_match_physical_addr(), ... */
> -		if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> -				x2apic_id <= new->max_apic_id)
> -			new->phys_map[x2apic_id] = apic;
>  		/*
> -		 * ... xAPIC ID of VCPUs with APIC ID > 0xff will wrap-around,
> -		 * prevent them from masking VCPUs with APIC ID <= 0xff.
> +		 * Apply KVM's hotplug hack if userspace has enable 32-bit APIC
> +		 * IDs.  Allow sending events to vCPUs by their x2APIC ID even
> +		 * if the target vCPU is in legacy xAPIC mode, and silently
> +		 * ignore aliased xAPIC IDs (the x2APIC ID is truncated to 8
> +		 * bits, causing IDs > 0xff to wrap and collide).
> +		 *
> +		 * Honor the architectural (and KVM's non-optimized) behavior
> +		 * if userspace has not enabled 32-bit x2APIC IDs.  Each APIC
> +		 * is supposed to process messages independently.  If multiple
> +		 * vCPUs have the same effective APIC ID, e.g. due to the
> +		 * x2APIC wrap or because the guest manually modified its xAPIC
> +		 * IDs, events targeting that ID are supposed to be recognized
> +		 * by all vCPUs with said ID.
>  		 */
> -		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> -			new->phys_map[xapic_id] = apic;
> +		if (kvm->arch.x2apic_format) {
> +			/* See also kvm_apic_match_physical_addr(). */
> +			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> +			    x2apic_id <= new->max_apic_id)
> +				new->phys_map[x2apic_id] = apic;
> +
> +			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> +				new->phys_map[xapic_id] = apic;
> +		} else {
> +			/*
> +			 * Disable the optimized map if the physical APIC ID is
> +			 * already mapped, i.e. is aliased to multiple vCPUs.
> +			 * The optimized map requires a strict 1:1 mapping
> +			 * between IDs and vCPUs.
> +			 */
> +			if (apic_x2apic_mode(apic))
> +				physical_id = x2apic_id;
> +			else
> +				physical_id = xapic_id;
> +
> +			if (new->phys_map[physical_id]) {
> +				kvfree(new);
> +				new = NULL;
> +				goto out;
> +			}
> +			new->phys_map[physical_id] = apic;
> +		}
>  
>  		if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED ||
>  		    !kvm_apic_sw_enabled(apic))


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

