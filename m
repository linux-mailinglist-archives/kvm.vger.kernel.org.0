Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF2351E596
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 10:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383748AbiEGIcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 04:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383686AbiEGIcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 04:32:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E262CC86;
        Sat,  7 May 2022 01:28:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n18so9522608plg.5;
        Sat, 07 May 2022 01:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=51U05xLln8jvwaVJ/GYDAlmADJa8Oq6KTjcweXEcEBo=;
        b=GIlwH1ChEbKDsON6fEw5IVOwvQd/3nzoIK2CtkBY0x9YbjIp2cZBYow+6FrCdsqUiK
         7DjS0eVf9lKselmLUFfsYW95b52EK/1SNXwsTqB3oIIsIF2b5YUj2eeBF/oPuifmEBxP
         PUgMdp8yngcglmME3sSSqd6LWmPMv6AYhjFWZh6LDwgM6+9clTKTD8VkzNNIfE/Q47xc
         dg/wUbwXVr9kyDvK6ic+iz17M7RtDHvXwp4eQvsEzP+gmMq5AT/kh+6+JPeagYfuKsJm
         JtIh2jyE2H/4XWYTz/S654wMM5RNSP4y2oFYK5dVsj6Gj36fXQsTV5XBf8j8gh7aP1Yk
         mmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=51U05xLln8jvwaVJ/GYDAlmADJa8Oq6KTjcweXEcEBo=;
        b=JrLakbrwiqS+/kg7P2TETBMIzqdV5wtZ+t/7B0Hv5KHZrrbegrUtiqCybeylwH5b0C
         pNe+/UR7atbyC3f4kfhBl8WR72KadsMCIiyIPQrynK+XiSvP/tfXYLxAnDDmgddfxkvE
         UX5hlvSLp8GS4GfmNcRkvpcEtoNV0AAZVYo60t33/AIDCFs6k5b87doAvd4TjygTKRC6
         8aXTF3l2awebvqAUDWf+haublwGEVheGNdQiReX7/GOO/CCWA7IOifmoYOx1h7M3SKNj
         yZ6wcyisOkzUHtQJdMyH+i+tr5jPG3rwXDEzl0WvJeJQgFl6E20/Jkf1ItnzPwcLN2pj
         I/Dg==
X-Gm-Message-State: AOAM532mu28iLHNSmSXo68SQq6ULdbrWIsfP48zRljzkqHgyxlBjO63/
        e66Es/1obSxgCkrkf5R2ij8=
X-Google-Smtp-Source: ABdhPJx2/OhxgtiOkQ2IirqlGpQJjQhIEeY+OQTjTbzoh41w/HqiZMgrT5Bro1mPW9UgNqdTp1g8Bg==
X-Received: by 2002:a17:903:32c6:b0:15e:c1cc:2405 with SMTP id i6-20020a17090332c600b0015ec1cc2405mr7763243plr.117.1651912104711;
        Sat, 07 May 2022 01:28:24 -0700 (PDT)
Received: from [30.22.112.212] ([205.204.117.91])
        by smtp.gmail.com with ESMTPSA id kx7-20020a17090b228700b001dce819d6f6sm1600678pjb.13.2022.05.07.01.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 01:28:24 -0700 (PDT)
Message-ID: <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
Date:   Sat, 7 May 2022 16:28:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
In-Reply-To: <20220422210546.458943-4-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/4/23 05:05, David Matlack wrote:
> Instead of computing the shadow page role from scratch for every new
> page, derive most of the information from the parent shadow page.  This
> avoids redundant calculations and reduces the number of parameters to
> kvm_mmu_get_page().
> 
> Preemptively split out the role calculation to a separate function for
> use in a following commit.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 96 +++++++++++++++++++++++-----------
>   arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
>   2 files changed, 71 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dc20eccd6a77..4249a771818b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2021,31 +2021,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
>   	__clear_sp_write_flooding_count(sptep_to_sp(spte));
>   }
>   
> -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> -					     gfn_t gfn,
> -					     gva_t gaddr,
> -					     unsigned level,
> -					     bool direct,
> -					     unsigned int access)
> +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> +					     union kvm_mmu_page_role role)
>   {
> -	union kvm_mmu_page_role role;
>   	struct hlist_head *sp_list;
> -	unsigned quadrant;
>   	struct kvm_mmu_page *sp;
>   	int ret;
>   	int collisions = 0;
>   	LIST_HEAD(invalid_list);
>   
> -	role = vcpu->arch.mmu->root_role;
> -	role.level = level;
> -	role.direct = direct;
> -	role.access = access;
> -	if (role.has_4_byte_gpte) {
> -		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
> -		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> -		role.quadrant = quadrant;
> -	}


I don't think replacing it with kvm_mmu_child_role() can reduce any calculations.

role.level, role.direct, role.access and role.quadrant still need to be
calculated.  And the old code is still in mmu_alloc_root().

I think kvm_mmu_get_shadow_page() can keep the those parameters and
kvm_mmu_child_role() is only introduced for nested_mmu_get_sp_for_split().

Both kvm_mmu_get_shadow_page() and nested_mmu_get_sp_for_split() call
__kvm_mmu_get_shadow_page() which uses role as a parameter.



> -
>   	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>   	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>   		if (sp->gfn != gfn) {
> @@ -2063,7 +2047,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			 * Unsync pages must not be left as is, because the new
>   			 * upper-level page will be write-protected.
>   			 */
> -			if (level > PG_LEVEL_4K && sp->unsync)
> +			if (role.level > PG_LEVEL_4K && sp->unsync)
>   				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
>   							 &invalid_list);
>   			continue;
> @@ -2104,14 +2088,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   
>   	++vcpu->kvm->stat.mmu_cache_miss;
>   
> -	sp = kvm_mmu_alloc_page(vcpu, direct);
> +	sp = kvm_mmu_alloc_page(vcpu, role.direct);
>   
>   	sp->gfn = gfn;
>   	sp->role = role;
>   	hlist_add_head(&sp->hash_link, sp_list);
> -	if (!direct) {
> +	if (!role.direct) {
>   		account_shadowed(vcpu->kvm, sp);
> -		if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> +		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
>   			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
>   	}
>   	trace_kvm_mmu_get_page(sp, true);
> @@ -2123,6 +2107,51 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   	return sp;
>   }
>   
> +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> +{
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> +	union kvm_mmu_page_role role;
> +
> +	role = parent_sp->role;
> +	role.level--;
> +	role.access = access;
> +	role.direct = direct;
> +
> +	/*
> +	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
> +	 * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> +	 * directories, each mapping 1/4 of the guest's linear address space
> +	 * (1GiB). The shadow pages for those 4 page directories are
> +	 * pre-allocated and assigned a separate quadrant in their role.


It is not going to be true in patchset:
[PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots

https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/

The shadow pages for those 4 page directories are also allocated on demand.
