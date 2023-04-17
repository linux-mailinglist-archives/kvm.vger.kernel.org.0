Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA676E40AB
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjDQHWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDQHVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:21:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566F544AC
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681716035;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=urktqoQPNL62ta63+uWPbsfKfnDqeorMUw+E44Iw5GM=;
        b=V8cdTanFkYz49A95Tqq7oN4Gh4JN6AAs28urlZb/9mVwy+pPpSE+3/vSRPjU7g0AixRoJQ
        425NCyGdh9ALj4FWZc++mA9bKfTu3W7VV7cI8Ak81YkshS9JHZ02w6xYFCDhbb6CT73BFw
        bG1y3wyXuTtpHxBCZe2zDEceOgzncEc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-Krc4P42bMGC_kMG9d_PLRA-1; Mon, 17 Apr 2023 03:20:32 -0400
X-MC-Unique: Krc4P42bMGC_kMG9d_PLRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2829F85A588;
        Mon, 17 Apr 2023 07:20:31 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91142C15BA0;
        Mon, 17 Apr 2023 07:20:20 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 12/12] KVM: arm64: Use local TLBI on permission
 relaxation
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-14-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <b163513f-b858-307f-e271-3d0cd17194f3@redhat.com>
Date:   Mon, 17 Apr 2023 15:20:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-14-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:30 PM, Ricardo Koller wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Broadcast TLB invalidations (TLBIs) targeting the Inner Shareable
> Domain are usually less performant than their non-shareable variant.
> In particular, we observed some implementations that take
> millliseconds to complete parallel broadcasted TLBIs.
> 
> It's safe to use non-shareable TLBIs when relaxing permissions on a
> PTE in the KVM case.  According to the ARM ARM (0487I.a) section
> D8.13.1 "Using break-before-make when updating translation table
> entries", permission relaxation does not need break-before-make.
> Specifically, R_WHZWS states that these are the only changes that
> require a break-before-make sequence: changes of memory type
> (Shareability or Cacheability), address changes, or changing the block
> size.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/include/asm/kvm_asm.h   |  4 +++
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 ++++++
>   arch/arm64/kvm/hyp/nvhe/tlb.c      | 54 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c       |  2 +-
>   arch/arm64/kvm/hyp/vhe/tlb.c       | 32 ++++++++++++++++++
>   5 files changed, 101 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 43c3bc0f9544d..bb17b2ead4c71 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
>   	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>   	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
>   	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
> +	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
>   	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
>   	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
>   	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
> @@ -225,6 +226,9 @@ extern void __kvm_flush_vm_context(void);
>   extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
>   extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
>   				     int level);
> +extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
> +					 phys_addr_t ipa,
> +					 int level);
>   extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
>   
>   extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 728e01d4536b0..c6bf1e49ca934 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -125,6 +125,15 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
>   	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
>   }
>   
> +static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +	DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
> +	DECLARE_REG(int, level, host_ctxt, 3);
> +
> +	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
> +}
> +
>   static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>   {
>   	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -315,6 +324,7 @@ static const hcall_t host_hcall[] = {
>   	HANDLE_FUNC(__kvm_vcpu_run),
>   	HANDLE_FUNC(__kvm_flush_vm_context),
>   	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> +	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
>   	HANDLE_FUNC(__kvm_tlb_flush_vmid),
>   	HANDLE_FUNC(__kvm_flush_cpu_context),
>   	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f5896..ef2b70587f933 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -109,6 +109,60 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>   	__tlb_switch_to_host(&cxt);
>   }
>   
> +void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
> +				  phys_addr_t ipa, int level)
> +{
> +	struct tlb_inv_context cxt;
> +
> +	dsb(nshst);
> +
> +	/* Switch to requested VMID */
> +	__tlb_switch_to_guest(mmu, &cxt);
> +
> +	/*
> +	 * We could do so much better if we had the VA as well.
> +	 * Instead, we invalidate Stage-2 for this IPA, and the
> +	 * whole of Stage-1. Weep...
> +	 */
> +	ipa >>= 12;
> +	__tlbi_level(ipas2e1, ipa, level);
> +
> +	/*
> +	 * We have to ensure completion of the invalidation at Stage-2,
> +	 * since a table walk on another CPU could refill a TLB with a
> +	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
> +	 * the Stage-1 invalidation happened first.
> +	 */
> +	dsb(nsh);
> +	__tlbi(vmalle1);
> +	dsb(nsh);
> +	isb();
> +
> +	/*
> +	 * If the host is running at EL1 and we have a VPIPT I-cache,
> +	 * then we must perform I-cache maintenance at EL2 in order for
> +	 * it to have an effect on the guest. Since the guest cannot hit
> +	 * I-cache lines allocated with a different VMID, we don't need
> +	 * to worry about junk out of guest reset (we nuke the I-cache on
> +	 * VMID rollover), but we do need to be careful when remapping
> +	 * executable pages for the same guest. This can happen when KSM
> +	 * takes a CoW fault on an executable page, copies the page into
> +	 * a page that was previously mapped in the guest and then needs
> +	 * to invalidate the guest view of the I-cache for that page
> +	 * from EL1. To solve this, we invalidate the entire I-cache when
> +	 * unmapping a page from a guest if we have a VPIPT I-cache but
> +	 * the host is running at EL1. As above, we could do better if
> +	 * we had the VA.
> +	 *
> +	 * The moral of this story is: if you have a VPIPT I-cache, then
> +	 * you should be running with VHE enabled.
> +	 */
> +	if (icache_is_vpipt())
> +		icache_inval_all_pou();
> +
> +	__tlb_switch_to_host(&cxt);
> +}
> +
>   void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
>   {
>   	struct tlb_inv_context cxt;
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 48c5a95c6e8cd..023269dd84f76 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1189,7 +1189,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>   				       KVM_PGTABLE_WALK_HANDLE_FAULT |
>   				       KVM_PGTABLE_WALK_SHARED);
>   	if (!ret)
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr, level);
>   	return ret;
>   }
>   
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index 24cef9b87f9e9..e69da550cdc5b 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -111,6 +111,38 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>   	__tlb_switch_to_host(&cxt);
>   }
>   
> +void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
> +				  phys_addr_t ipa, int level)
> +{
> +	struct tlb_inv_context cxt;
> +
> +	dsb(nshst);
> +
> +	/* Switch to requested VMID */
> +	__tlb_switch_to_guest(mmu, &cxt);
> +
> +	/*
> +	 * We could do so much better if we had the VA as well.
> +	 * Instead, we invalidate Stage-2 for this IPA, and the
> +	 * whole of Stage-1. Weep...
> +	 */
> +	ipa >>= 12;
> +	__tlbi_level(ipas2e1, ipa, level);
> +
> +	/*
> +	 * We have to ensure completion of the invalidation at Stage-2,
> +	 * since a table walk on another CPU could refill a TLB with a
> +	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
> +	 * the Stage-1 invalidation happened first.
> +	 */
> +	dsb(nsh);
> +	__tlbi(vmalle1);
> +	dsb(nsh);
> +	isb();
> +
> +	__tlb_switch_to_host(&cxt);
> +}
> +
>   void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
>   {
>   	struct tlb_inv_context cxt;
> 

