Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3523B7A914B
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 05:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjIUD3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 23:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjIUD3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 23:29:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A952F4
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 20:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695266896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0v2JG/s7PIc0vGKodtM+Q59Y9VnGkq0n4Wh8qBqHuOY=;
        b=Kc26MZ1wPbp8WDtR2ze0PWWJ/5KGrhGs/HkVO+VkgG0s5EyfTVlzG5QmUhkRRf+2LI9apy
        UuMA+hMA+W9t0XyZJDrRkCFtV/mY0eIHXZtjN+2FOrgirHzdbkUpmTRaBUYeTGc6DgWW8V
        7YNezBc0lvDXsdzApaXTZw4+HiLnYLk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-2h19XlCMOP2Scngs-VCc1w-1; Wed, 20 Sep 2023 23:28:13 -0400
X-MC-Unique: 2h19XlCMOP2Scngs-VCc1w-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-274bc2cb2dbso330026a91.0
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 20:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695266892; x=1695871692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v2JG/s7PIc0vGKodtM+Q59Y9VnGkq0n4Wh8qBqHuOY=;
        b=ORchFYs+Z3LwFgszeuhNihfCsixXkDUwp6vYk6VuPtjd3aEuNPSCw9kNeLAyVzHp8b
         sasueuqNN3AqUN8nT3vF8kaHSazpo9/xr1Wpg3iMSaX49bduQ6OJGHrDBEQNMswcab5D
         eEjOjJMij77ThOyxlUyt1v82UZ1CKgV4q14WqCsSTEeXdywvtXybOz2q+sd10qXDPVjf
         1qF7DpAfjhDtaggn8TdiGsN7//vDkG8/Lxu1gmk+2ZsDT9cOfCrS/pQCWHjmu2xaXowO
         CIv5lvQ2s5khyBqrSig6a0bGxQsz31O/ZVEHiqepXibsbcnnHH7zk+qO3ea5MJcOa9ND
         8y3w==
X-Gm-Message-State: AOJu0YxAtPVws8/rtkyW6IzVR7MhhrAsotHkqIaLxaJGBGIS64lJBJTk
        513SFh24CudHk8E3qQH/c+wgiggSwth00yJDJO0J6uJ/HupS/IHz3/eibyOPN0Jgpd3ZJikjmtr
        MuLwQbM7mZ+cU
X-Received: by 2002:a17:90b:60f:b0:271:9237:a07f with SMTP id gb15-20020a17090b060f00b002719237a07fmr4640841pjb.32.1695266892196;
        Wed, 20 Sep 2023 20:28:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdTGDV/U1WxJZGqkf4/kI8P6PMbKZALx0spzejxrzMvccw2t9wWS0So2gleLrmzMbpuDGdXw==
X-Received: by 2002:a17:90b:60f:b0:271:9237:a07f with SMTP id gb15-20020a17090b060f00b002719237a07fmr4640832pjb.32.1695266891888;
        Wed, 20 Sep 2023 20:28:11 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a31c800b0027360359b70sm287885pjf.48.2023.09.20.20.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 20:28:11 -0700 (PDT)
Message-ID: <b652ad1e-6d38-3591-7728-487afeb1c9a6@redhat.com>
Date:   Thu, 21 Sep 2023 13:28:06 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/2] KVM: arm64: Avoid soft lockups due to I-cache
 maintenance
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <20230920080133.944717-1-oliver.upton@linux.dev>
 <20230920080133.944717-3-oliver.upton@linux.dev>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230920080133.944717-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/23 18:01, Oliver Upton wrote:
> Gavin reports of soft lockups on his Ampere Altra Max machine when
> backing KVM guests with hugetlb pages. Upon further investigation, it
> was found that the system is unable to keep up with parallel I-cache
> invalidations done by KVM's stage-2 fault handler.
> 
> This is ultimately an implementation problem. I-cache maintenance
> instructions are available at EL0, so nothing stops a malicious
> userspace from hammering a system with CMOs and cause it to fall over.
> "Fixing" this problem in KVM is nothing more than slapping a bandage
> over a much deeper problem.
> 
> Anyway, the kernel already has a heuristic for limiting TLB
> invalidations to avoid soft lockups. Reuse that logic to limit I-cache
> CMOs done by KVM to map executable pages on systems without FEAT_DIC.
> While at it, restructure __invalidate_icache_guest_page() to improve
> readability and squeeze our new condition into the existing branching
> structure.
> 
> Link: https://lore.kernel.org/kvmarm/20230904072826.1468907-1-gshan@redhat.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 37 ++++++++++++++++++++++++++------
>   1 file changed, 31 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 96a80e8f6226..a425ecdd7be0 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -224,16 +224,41 @@ static inline void __clean_dcache_guest_page(void *va, size_t size)
>   	kvm_flush_dcache_to_poc(va, size);
>   }
>   
> +static inline size_t __invalidate_icache_max_range(void)
> +{
> +	u8 iminline;
> +	u64 ctr;
> +
> +	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
> +				    "movk %0, #0, lsl #16\n"
> +				    "movk %0, #0, lsl #32\n"
> +				    "movk %0, #0, lsl #48\n",
> +				    ARM64_ALWAYS_SYSTEM,
> +				    kvm_compute_final_ctr_el0)
> +		     : "=r" (ctr));
> +
> +	iminline = SYS_FIELD_GET(CTR_EL0, IminLine, ctr) + 2;
> +	return MAX_DVM_OPS << iminline;
> +}
> +
>   static inline void __invalidate_icache_guest_page(void *va, size_t size)
>   {
> -	if (icache_is_aliasing()) {
> -		/* any kind of VIPT cache */
> +	/*
> +	 * VPIPT I-cache maintenance must be done from EL2. See comment in the
> +	 * nVHE flavor of __kvm_tlb_flush_vmid_ipa().
> +	 */
> +	if (icache_is_vpipt() && read_sysreg(CurrentEL) != CurrentEL_EL2)
> +		return;
> +
> +	/*
> +	 * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
> +	 * invalidation range exceeds our arbitrary limit on invadations by
> +	 * cache line.
> +	 */
> +	if (icache_is_aliasing() || size > __invalidate_icache_max_range())
>   		icache_inval_all_pou();
> -	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
> -		   !icache_is_vpipt()) {
> -		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> +	else
>   		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
> -	}
>   }
>   
>   void kvm_set_way_flush(struct kvm_vcpu *vcpu);

