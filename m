Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D772C7576CE
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 10:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjGRIkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 04:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjGRIkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 04:40:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B71E52
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 01:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689669568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48OfsAs+5NoliWawjnL6mrqynpB+mYbsWNJ2N0teO4w=;
        b=ZcNcd7BUBnlW5ef07InP4qh+CXmP3//x42h+6KkHe8zJOK0n9oT9g0y6W/ehB+qHMatmcw
        Kf0/QgsUyWPFa8xrIeo741jLcPHKMcKOuRT/pD7KMZ08fjj2lXPIs25ToXrdu6zX7iyncC
        ZauNHXYSMNIJlWS18hN+GSvlY76wO7Q=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-NvxGpOSfMDW8fZ3dkBo7Yg-1; Tue, 18 Jul 2023 04:39:27 -0400
X-MC-Unique: NvxGpOSfMDW8fZ3dkBo7Yg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-553c68126f8so746540a12.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 01:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689669566; x=1692261566;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=48OfsAs+5NoliWawjnL6mrqynpB+mYbsWNJ2N0teO4w=;
        b=RSzmlZ+6oTyQO+89vozYO52gJtCSaMAXln3q3h42Gqqhq8PEjXiBiblRnDLeFCOTYt
         sNqF3S0pqL8E+FXITYNg/zxQVcAsNKOxBJKFXA+ivAODYbNzYwX7+hO0eVkJrNl5O+k5
         zKBRpsmZT0jLgFyX/7+VKSQD03u2xZ/tS82BKwgAjM/cuyXtVPQswcaGQh+6oJsBZSfx
         b/k1vuvOVQmP+TiZVg+p3OgN9g5fhWDzXZkhBHq6Zt0IoBJl8WqGxIU3YPQesby2ezno
         5SBx8nUUJW8+m04wmMqFqSkjp3cqSJcdKiFMHM4/xU8+h0ngXWKojd+AGMH9HfiHhajj
         +bWg==
X-Gm-Message-State: ABy/qLZAMJlrdSNwjks81/fqaQbAqnuXJf4fNkklgblp+KLxwfOhmqmo
        fO0aFg4177ILwOx0yoQYzLDvff/yn8WZdwRdmf9eDbbGes2Bms0WjLcUUQ1zl39zdDUabA8998n
        1h+9h4xe2QzzF
X-Received: by 2002:a05:6a21:338e:b0:123:149b:a34f with SMTP id yy14-20020a056a21338e00b00123149ba34fmr11522164pzb.1.1689669565975;
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFn6VTd9NoeqQyeoZ4mz9lw2meP9X5GlAOs2CSTs0WWxzf4uI+E1rzir2tOn6PnHRRKr5e2eQ==
X-Received: by 2002:a05:6a21:338e:b0:123:149b:a34f with SMTP id yy14-20020a056a21338e00b00123149ba34fmr11522141pzb.1.1689669565640;
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p9-20020a639509000000b0055bbc746272sm1140176pgd.17.2023.07.18.01.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
Message-ID: <148fecc6-7ad5-1039-4466-7c1e5a9df911@redhat.com>
Date:   Tue, 18 Jul 2023 16:39:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
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
 <20230715005405.3689586-8-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-8-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> Implement the helper kvm_tlb_flush_vmid_range() that acts
> as a wrapper for range-based TLB invalidations. For the
> given VMID, use the range-based TLBI instructions to do
> the job or fallback to invalidating all the TLB entries.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>   2 files changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8294a9a7e566..5e8b1ff07854 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>    *	   kvm_pgtable_prot format.
>    */
>   enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> +
> +/**
> + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
> + *
> + * @mmu:	Stage-2 KVM MMU struct
> + * @addr:	The base Intermediate physical address from which to invalidate
> + * @size:	Size of the range from the base to invalidate
> + */
> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t addr, size_t size);
>   #endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index aa740a974e02..5d14d5d5819a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
>   	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
>   }
>   
> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t addr, size_t size)
> +{
> +	unsigned long pages, inval_pages;
> +
> +	if (!system_supports_tlb_range()) {
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		return;
> +	}
> +
> +	pages = size >> PAGE_SHIFT;
> +	while (pages > 0) {
> +		inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
> +
> +		addr += inval_pages << PAGE_SHIFT;
> +		pages -= inval_pages;
> +	}
> +}
> +
>   #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
>   
>   static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,

-- 
Shaoqin

