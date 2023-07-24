Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C175EF02
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjGXJW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjGXJW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:22:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0981A5
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690190503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ijXK5mx/mHT57SLCIb40VpMSvRABTcruzVYNxBiTMvo=;
        b=PnCPT/QSuHfGQQiO8obUoFTHlK3/o3+eICUySW+UHFafFTx0hgOaO//VAUDeumtt19WNU3
        5r9GcaCMyF9IJPAZG4wAV2hX/kHmujyPxDBMRPMG3jq9Jre+wbLbnUTnHu5EjcKRjMXOrc
        lL0Tv9wYBEUUAGrYIG1kqRno7adBhzM=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-btyuDr20NbWMiNrslLJJRw-1; Mon, 24 Jul 2023 05:21:41 -0400
X-MC-Unique: btyuDr20NbWMiNrslLJJRw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2682c860d5bso587a91.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 02:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690190500; x=1690795300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ijXK5mx/mHT57SLCIb40VpMSvRABTcruzVYNxBiTMvo=;
        b=jfS1o9CjD9Ymhrr61vMHMGKj+AZruTVVuZkzcHzJWuE3JK7UshSq/pT8Tl9AsU50kP
         4tUDdsFFnR06rGOdttzoKjwDiyG+rTH3X4Jzx0k1UDzEkqZqeQ2ZLjHvGVINQbZqQYBF
         lE7xYO+1LAd0ELvqQ90FGf8gB+VGbvqciNjunWK0EjZD8OpxUOjJy9KhiORWxJFqbF7D
         poxH+0rAgiGStmfeRW/ab4Q9Ge33C/8aAVUh73Qz8pKwWU1Xe4GWs1mavlSAo9MaxdQH
         yvLWINXK2cFnEwTZebOHniS8DLH+5jz736U91c/Wm4RYQIbKUQYkFGFIvpiHh/5q+/TY
         BtQg==
X-Gm-Message-State: ABy/qLZjgusU30vLHCDTlq6SjXRUht2H1P5s+D912p5JLfvpyWJbN0rt
        1Qxor6jiByNtmLEHEezKnszwU+4ii/OYL+YOoUzGCCDXBon3kLePRQJLheUkVa7zbODSuo+I4rg
        rQwpRjD78iGeK
X-Received: by 2002:a17:903:24f:b0:1b8:ac61:ffcd with SMTP id j15-20020a170903024f00b001b8ac61ffcdmr12283767plh.3.1690190500639;
        Mon, 24 Jul 2023 02:21:40 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEZg+XWG7wausr9JUrEDKdubfGzKS3ftfwX+fiU3qfVPHFuyHIzNTMWW2KHzK0G7Dd2zhpA5A==
X-Received: by 2002:a17:903:24f:b0:1b8:ac61:ffcd with SMTP id j15-20020a170903024f00b001b8ac61ffcdmr12283739plh.3.1690190500295;
        Mon, 24 Jul 2023 02:21:40 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b001bb34ae3f47sm8365727plf.122.2023.07.24.02.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:21:39 -0700 (PDT)
Message-ID: <86b36980-0a3b-7f56-44b4-079e8058021e@redhat.com>
Date:   Mon, 24 Jul 2023 17:21:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 07/12] KVM: arm64: Implement
 __kvm_tlb_flush_vmid_range()
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-8-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230722022251.3446223-8-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
> Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
> to flush a range of stage-2 page-tables using IPA in one go.
> If the system supports FEAT_TLBIRANGE, the following patches
> would conviniently replace global TLBI such as vmalls12e1is
> in the map, unmap, and dirty-logging paths with ripas2e1is
> instead.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_asm.h   |  3 +++
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
>   arch/arm64/kvm/hyp/nvhe/tlb.c      | 30 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/vhe/tlb.c       | 27 +++++++++++++++++++++++++++
>   4 files changed, 71 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 7d170aaa2db4..2c27cb8cf442 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
>   	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
>   	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa_nsh,
>   	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
> +	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
>   	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
>   	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
>   	__KVM_HOST_SMCCC_FUNC___vgic_v3_read_vmcr,
> @@ -229,6 +230,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
>   extern void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
>   					 phys_addr_t ipa,
>   					 int level);
> +extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +					phys_addr_t start, unsigned long pages);
>   extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
>   
>   extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index a169c619db60..857d9bc04fd4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -135,6 +135,16 @@ static void handle___kvm_tlb_flush_vmid_ipa_nsh(struct kvm_cpu_context *host_ctx
>   	__kvm_tlb_flush_vmid_ipa_nsh(kern_hyp_va(mmu), ipa, level);
>   }
>   
> +static void
> +handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> +	DECLARE_REG(unsigned long, pages, host_ctxt, 3);
> +
> +	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, pages);
> +}
> +
>   static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>   {
>   	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -327,6 +337,7 @@ static const hcall_t host_hcall[] = {
>   	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
>   	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa_nsh),
>   	HANDLE_FUNC(__kvm_tlb_flush_vmid),
> +	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
>   	HANDLE_FUNC(__kvm_flush_cpu_context),
>   	HANDLE_FUNC(__kvm_timer_set_cntvoff),
>   	HANDLE_FUNC(__vgic_v3_read_vmcr),
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index b9991bbd8e3f..09347111c2cd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -182,6 +182,36 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
>   	__tlb_switch_to_host(&cxt);
>   }
>   
> +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t start, unsigned long pages)
> +{
> +	struct tlb_inv_context cxt;
> +	unsigned long stride;
> +
> +	/*
> +	 * Since the range of addresses may not be mapped at
> +	 * the same level, assume the worst case as PAGE_SIZE
> +	 */
> +	stride = PAGE_SIZE;
> +	start = round_down(start, stride);
> +
> +	/* Switch to requested VMID */
> +	__tlb_switch_to_guest(mmu, &cxt, false);
> +
> +	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
> +
> +	dsb(ish);
> +	__tlbi(vmalle1is);
> +	dsb(ish);
> +	isb();
> +
> +	/* See the comment in __kvm_tlb_flush_vmid_ipa() */
> +	if (icache_is_vpipt())
> +		icache_inval_all_pou();
> +
> +	__tlb_switch_to_host(&cxt);
> +}
> +
>   void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
>   {
>   	struct tlb_inv_context cxt;
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index e69da550cdc5..02f4ed2fd715 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -138,6 +138,33 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
>   	dsb(nsh);
>   	__tlbi(vmalle1);
>   	dsb(nsh);
> +
> +	__tlb_switch_to_host(&cxt);
> +}
> +
> +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t start, unsigned long pages)
> +{
> +	struct tlb_inv_context cxt;
> +	unsigned long stride;
> +
> +	/*
> +	 * Since the range of addresses may not be mapped at
> +	 * the same level, assume the worst case as PAGE_SIZE
> +	 */
> +	stride = PAGE_SIZE;
> +	start = round_down(start, stride);
> +
> +	dsb(ishst);
> +
> +	/* Switch to requested VMID */
> +	__tlb_switch_to_guest(mmu, &cxt);
> +
> +	__flush_tlb_range_op(ipas2e1is, start, pages, stride, 0, 0, false);
> +
> +	dsb(ish);
> +	__tlbi(vmalle1is);
> +	dsb(ish);
>   	isb();
>   
>   	__tlb_switch_to_host(&cxt);

-- 
Shaoqin

