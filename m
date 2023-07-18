Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78FE7575B4
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 09:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjGRHv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 03:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjGRHv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 03:51:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BD510C2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 00:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689666639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IQV8O6VkoZMK+uzlvNWBITxOlq3iVkMNabGAT3CedZ4=;
        b=ZFB/RG7wKuZrZN6uOAHMQmRR/fcEI+YRXcQD4AN4u+IQvp9PBMrWUBNz9L7RQ7SZ7Pt2fV
        QNn2tabT1X9Xyy/HxtpQ15hVTorUg+qw6uCYk5L702xRtpKqsTa720QQMCPv/RXeu9l9Ey
        v4AcTOHI/49+b2eolWefsU6v0Z1Oxbg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-TIzkdzIQMK-zQ5b5LUnBUw-1; Tue, 18 Jul 2023 03:50:38 -0400
X-MC-Unique: TIzkdzIQMK-zQ5b5LUnBUw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-263f3c02e02so1247134a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 00:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689666637; x=1692258637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQV8O6VkoZMK+uzlvNWBITxOlq3iVkMNabGAT3CedZ4=;
        b=cSgM8nVzA3cljHCANBG2+3u2S3sjvv9shSjIR1XKhjW4EB1/UGkfBBCxv9mkDMVFrS
         9qxcmwZxhnQquBD5x+7GbzVJgpE2ToLFgkaHj72oZf87In7xubRHJF9eBHx4C4goOysM
         6IIqAAqDB/AWKEsGNFSxOVILCv8s1L3xVLWJHnR1Es8HgI/3MYEsmSDCdeLVx84I8iOn
         O68TIKbfLuhGRfZCW7vHYU1sTUQSu+g20wBLsg7/hcCsg6gmY5rronM4vhKCuwq9JUM8
         qCcP8XmyDK7FPc7zqv4XU76mmbf1YEu4pHg6Db6+kELrP3ABNrP36olX1/fPk0QXhp4x
         GtQw==
X-Gm-Message-State: ABy/qLarvUi28y4KK6EtmOjdEcC0bDppNxL4IkB5PnOj/FtfCrqMzIXE
        osHJnd1YhHfaYED6zs/BrcnKg+WFK5Sr3IN02mkUfSDhJDUcDUGNArAMi5xiJhriy4Fkxv+Io9Q
        o2XbVRiZekkL+
X-Received: by 2002:a05:6a20:a111:b0:133:6e3d:728a with SMTP id q17-20020a056a20a11100b001336e3d728amr11334192pzk.6.1689666637190;
        Tue, 18 Jul 2023 00:50:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFD2KNTmEnZo1x3FiDeADMJZauRC0v1yUa82OuIn2vMpvvXR2PsgNf3c6C22aGrV8c2mvw/Zg==
X-Received: by 2002:a05:6a20:a111:b0:133:6e3d:728a with SMTP id q17-20020a056a20a11100b001336e3d728amr11334171pzk.6.1689666636842;
        Tue, 18 Jul 2023 00:50:36 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x53-20020a056a000bf500b00684ca1b45b9sm973422pfu.149.2023.07.18.00.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 00:50:36 -0700 (PDT)
Message-ID: <0b2b367e-30c7-672e-f249-e4100c4dff5f@redhat.com>
Date:   Tue, 18 Jul 2023 15:50:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 06/11] KVM: arm64: Implement
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
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-7-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-7-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
> to flush a range of stage-2 page-tables using IPA in one go.
> If the system supports FEAT_TLBIRANGE, the following patches
> would conviniently replace global TLBI such as vmalls12e1is
> in the map, unmap, and dirty-logging paths with ripas2e1is
> instead.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_asm.h   |  3 +++
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
>   arch/arm64/kvm/hyp/nvhe/tlb.c      | 30 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/vhe/tlb.c       | 23 +++++++++++++++++++++++
>   4 files changed, 67 insertions(+)
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
> index e69da550cdc5..4ed8a1786812 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -138,6 +138,29 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
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

Is there lack of switch VMID to guest?
	__tlb_switch_to_guest(mmu, &cxt, false);

Thanks,
Shaoqin

> +	dsb(ishst);
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

