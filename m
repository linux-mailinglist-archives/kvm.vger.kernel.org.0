Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0415669AC21
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 14:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBQNHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 08:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBQNHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 08:07:30 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EEE5B753;
        Fri, 17 Feb 2023 05:07:28 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id r28so1107963ljk.1;
        Fri, 17 Feb 2023 05:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68byFiLYC5ad7+usz+evma5sc0WL32oksuylCDKLpLc=;
        b=XyMGeHRAyuFHK1kPIMzLND2m7ZnVct4n8GsfI9Y/fzwgcXgAxmYpLTt2UpRfsx536T
         MsseeR+KZ7loLisF3iRugdgV7NUNZR3wdn7LVks8E/MWnotGFZl9Fvw6tzI1c6Nm+r3l
         BuVnqWVNK9q6sri62cgJ6uq1+5iUyCE17oIAcUzejkv1Kw+gcuuKkVjrgTJ5pic1jwHO
         9TjSgjUWFvxPsk8AiHVVeWuh5G/woG+kij+oapQzkBORIM4+jQ8IPWo/e+E7pkIPM1pm
         Ukty81HBnJy5b01ZZrknuTwUcB2sGztwRHFZSxn6t/dMzJ/Og2AjzSg6FzQdgu0VEPN/
         fZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=68byFiLYC5ad7+usz+evma5sc0WL32oksuylCDKLpLc=;
        b=E81Kovm/afNwuAMr50nbJVzKwGxiNMGSfFKv9P5AIJ8btZDxgfcKDZ7fvE+gP/S7gs
         3nPt9Vs9DoH2Rdag4mnAkhldXzDotVG9/Dg6kX7DTM2HisbzASM+WmNaPwhGHMnGTtsu
         OU0lm7Qr9dVI8XJJJ4GXdWMJCGQn2bqJZ2q2U7yB7xh0fCJuPoPAb904JIXvWOVuLkml
         9r3SY5T7mHNvGXqtEQTycVw5Kv7dAdGzYkTtXmIl0maQm+m/5p4sQ/GZ0yuoSMY1yIUf
         +fvnIVbDUktwaCNV2AktQojh9SvIb+o2kxgTJAcF0dQW4ZyyHYRstazpX88M4TU9GjN8
         5n0g==
X-Gm-Message-State: AO0yUKXa9NEoGa3gnbNwpDPhjTt9KzoOrJawaMxKx7Z4XtfnA1MzJN8Y
        NmDOL2pXyLtcwc06OwUajpQc3Khkf6U=
X-Google-Smtp-Source: AK7set+49LpdVaEUMs/rDfcN7O2eaGqHA+2GvBp75noTcFvkxqQ8kejJFTXC8w2xDcbaqDrX9Vl3TQ==
X-Received: by 2002:a2e:9d51:0:b0:293:5054:9825 with SMTP id y17-20020a2e9d51000000b0029350549825mr441581ljj.1.1676639246544;
        Fri, 17 Feb 2023 05:07:26 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id k16-20020a2e9210000000b00293524fb6b1sm591389ljg.74.2023.02.17.05.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 05:07:26 -0800 (PST)
Date:   Fri, 17 Feb 2023 15:07:24 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 13/28] arm64: RME: Allow VMM to set RIPAS
Message-ID: <20230217150724.00006820@gmail.com>
In-Reply-To: <20230127112932.38045-14-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-14-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:17 +0000
Steven Price <steven.price@arm.com> wrote:

> Each page within the protected region of the realm guest can be marked
> as either RAM or EMPTY. Allow the VMM to control this before the guest
> has started and provide the equivalent functions to change this (with
> the guest's approval) at runtime.
> 

The above is just the purpose of this patch. It would be better to have one
more paragraph to describe what this patch does (building RTT and set IPA
state in the RTT) and explain something might confuse people, for example
the spare page.

The spare page is really confusing. When reading __alloc_delegated_page()
, it looks like a mechanism to cache a delegated page for the realm. But later
in the teardown path, it looks like a workaround. What if the allocation of 
the spare page failed in the RTT tear down path? 

I understand this must be a temporary solution. It would be really nice to
have a big picture or some basic introduction to the future plan. 

> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_rme.h |   4 +
>  arch/arm64/kvm/rme.c             | 288 +++++++++++++++++++++++++++++++
>  2 files changed, 292 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 4b219ebe1400..3e75cedaad18 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -47,6 +47,10 @@ void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level);
>  int kvm_create_rec(struct kvm_vcpu *vcpu);
>  void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long addr, unsigned long end,
> +			unsigned long ripas);
> +
>  #define RME_RTT_BLOCK_LEVEL	2
>  #define RME_RTT_MAX_LEVEL	3
>  
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index d79ed889ca4d..b3ea79189839 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -73,6 +73,58 @@ static int rmi_check_version(void)
>  	return 0;
>  }
>  
> +static phys_addr_t __alloc_delegated_page(struct realm *realm,
> +					  struct kvm_mmu_memory_cache *mc, gfp_t flags)
> +{
> +	phys_addr_t phys = PHYS_ADDR_MAX;
> +	void *virt;
> +
> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> +		swap(realm->spare_page, phys);
> +		goto out;
> +	}
> +
> +	if (mc)
> +		virt = kvm_mmu_memory_cache_alloc(mc);
> +	else
> +		virt = (void *)__get_free_page(flags);
> +
> +	if (!virt)
> +		goto out;
> +
> +	phys = virt_to_phys(virt);
> +
> +	if (rmi_granule_delegate(phys)) {
> +		free_page((unsigned long)virt);
> +
> +		phys = PHYS_ADDR_MAX;
> +	}
> +
> +out:
> +	return phys;
> +}
> +
> +static phys_addr_t alloc_delegated_page(struct realm *realm,
> +					struct kvm_mmu_memory_cache *mc)
> +{
> +	return __alloc_delegated_page(realm, mc, GFP_KERNEL);
> +}
> +
> +static void free_delegated_page(struct realm *realm, phys_addr_t phys)
> +{
> +	if (realm->spare_page == PHYS_ADDR_MAX) {
> +		realm->spare_page = phys;
> +		return;
> +	}
> +
> +	if (WARN_ON(rmi_granule_undelegate(phys))) {
> +		/* Undelegate failed: leak the page */
> +		return;
> +	}
> +
> +	free_page((unsigned long)phys_to_virt(phys));
> +}
> +
>  static void realm_destroy_undelegate_range(struct realm *realm,
>  					   unsigned long ipa,
>  					   unsigned long addr,
> @@ -220,6 +272,30 @@ static int realm_rtt_create(struct realm *realm,
>  	return rmi_rtt_create(phys, virt_to_phys(realm->rd), addr, level);
>  }
>  
> +static int realm_create_rtt_levels(struct realm *realm,
> +				   unsigned long ipa,
> +				   int level,
> +				   int max_level,
> +				   struct kvm_mmu_memory_cache *mc)
> +{
> +	if (WARN_ON(level == max_level))
> +		return 0;
> +
> +	while (level++ < max_level) {
> +		phys_addr_t rtt = alloc_delegated_page(realm, mc);
> +
> +		if (rtt == PHYS_ADDR_MAX)
> +			return -ENOMEM;
> +
> +		if (realm_rtt_create(realm, ipa, level, rtt)) {
> +			free_delegated_page(realm, rtt);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int realm_tear_down_rtt_range(struct realm *realm, int level,
>  				     unsigned long start, unsigned long end)
>  {
> @@ -309,6 +385,206 @@ void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32 start_level)
>  	realm_tear_down_rtt_range(realm, start_level, 0, (1UL << ia_bits));
>  }
>  
> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long ipa, u64 size)
> +{
> +	u32 ia_bits = kvm->arch.mmu.pgt->ia_bits;
> +	u32 start_level = kvm->arch.mmu.pgt->start_level;
> +	unsigned long end = ipa + size;
> +	struct realm *realm = &kvm->arch.realm;
> +	phys_addr_t tmp_rtt = PHYS_ADDR_MAX;
> +
> +	if (end > (1UL << ia_bits))
> +		end = 1UL << ia_bits;
> +	/*
> +	 * Make sure we have a spare delegated page for tearing down the
> +	 * block mappings. We must use Atomic allocations as we are called
> +	 * with kvm->mmu_lock held.
> +	 */
> +	if (realm->spare_page == PHYS_ADDR_MAX) {
> +		tmp_rtt = __alloc_delegated_page(realm, NULL, GFP_ATOMIC);
> +		/*
> +		 * We don't have to check the status here, as we may not
> +		 * have a block level mapping. Delay any error to the point
> +		 * where we need it.
> +		 */
> +		realm->spare_page = tmp_rtt;
> +	}
> +
> +	realm_tear_down_rtt_range(&kvm->arch.realm, start_level, ipa, end);
> +
> +	/* Free up the atomic page, if there were any */
> +	if (tmp_rtt != PHYS_ADDR_MAX) {
> +		free_delegated_page(realm, tmp_rtt);
> +		/*
> +		 * Update the spare_page after we have freed the
> +		 * above page to make sure it doesn't get cached
> +		 * in spare_page.
> +		 * We should re-write this part and always have
> +		 * a dedicated page for handling block mappings.
> +		 */
> +		realm->spare_page = PHYS_ADDR_MAX;
> +	}
> +}
> +
> +static int set_ipa_state(struct kvm_vcpu *vcpu,
> +			 unsigned long ipa,
> +			 unsigned long end,
> +			 int level,
> +			 unsigned long ripas)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct realm *realm = &kvm->arch.realm;
> +	struct rec *rec = &vcpu->arch.rec;
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
> +	unsigned long map_size = rme_rtt_level_mapsize(level);
> +	int ret;
> +
> +	while (ipa < end) {
> +		ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, level, ripas);
> +
> +		if (!ret) {
> +			if (!ripas)
> +				kvm_realm_unmap_range(kvm, ipa, map_size);
> +		} else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int walk_level = RMI_RETURN_INDEX(ret);
> +
> +			if (walk_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      walk_level,
> +							      level, NULL);
> +				if (ret)
> +					return ret;
> +				continue;
> +			}
> +
> +			if (WARN_ON(level >= RME_RTT_MAX_LEVEL))
> +				return -EINVAL;
> +
> +			/* Recurse one level lower */
> +			ret = set_ipa_state(vcpu, ipa, ipa + map_size,
> +					    level + 1, ripas);
> +			if (ret)
> +				return ret;
> +		} else {
> +			WARN(1, "Unexpected error in %s: %#x\n", __func__,
> +			     ret);
> +			return -EINVAL;
> +		}
> +		ipa += map_size;
> +	}
> +
> +	return 0;
> +}
> +
> +static int realm_init_ipa_state(struct realm *realm,
> +				unsigned long ipa,
> +				unsigned long end,
> +				int level)
> +{
> +	unsigned long map_size = rme_rtt_level_mapsize(level);
> +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> +	int ret;
> +
> +	while (ipa < end) {
> +		ret = rmi_rtt_init_ripas(rd_phys, ipa, level);
> +
> +		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
> +			int cur_level = RMI_RETURN_INDEX(ret);
> +
> +			if (cur_level < level) {
> +				ret = realm_create_rtt_levels(realm, ipa,
> +							      cur_level,
> +							      level, NULL);
> +				if (ret)
> +					return ret;
> +				/* Retry with the RTT levels in place */
> +				continue;
> +			}
> +
> +			/* There's an entry at a lower level, recurse */
> +			if (WARN_ON(level >= RME_RTT_MAX_LEVEL))
> +				return -EINVAL;
> +
> +			realm_init_ipa_state(realm, ipa, ipa + map_size,
> +					     level + 1);
> +		} else if (WARN_ON(ret)) {
> +			return -ENXIO;
> +		}
> +
> +		ipa += map_size;
> +	}
> +
> +	return 0;
> +}
> +
> +static int find_map_level(struct kvm *kvm, unsigned long start, unsigned long end)
> +{
> +	int level = RME_RTT_MAX_LEVEL;
> +
> +	while (level > get_start_level(kvm) + 1) {
> +		unsigned long map_size = rme_rtt_level_mapsize(level - 1);
> +
> +		if (!IS_ALIGNED(start, map_size) ||
> +		    (start + map_size) > end)
> +			break;
> +
> +		level--;
> +	}
> +
> +	return level;
> +}
> +
> +int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> +			unsigned long addr, unsigned long end,
> +			unsigned long ripas)
> +{
> +	int ret = 0;
> +
> +	while (addr < end) {
> +		int level = find_map_level(vcpu->kvm, addr, end);
> +		unsigned long map_size = rme_rtt_level_mapsize(level);
> +
> +		ret = set_ipa_state(vcpu, addr, addr + map_size, level, ripas);
> +		if (ret)
> +			break;
> +
> +		addr += map_size;
> +	}
> +
> +	return ret;
> +}
> +
> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
> +				    struct kvm_cap_arm_rme_init_ipa_args *args)
> +{
> +	int ret = 0;
> +	gpa_t addr, end;
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	addr = args->init_ipa_base;
> +	end = addr + args->init_ipa_size;
> +
> +	if (end < addr)
> +		return -EINVAL;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EBUSY;
> +
> +	while (addr < end) {
> +		int level = find_map_level(kvm, addr, end);
> +		unsigned long map_size = rme_rtt_level_mapsize(level);
> +
> +		ret = realm_init_ipa_state(realm, addr, addr + map_size, level);
> +		if (ret)
> +			break;
> +
> +		addr += map_size;
> +	}
> +
> +	return ret;
> +}
> +
>  /* Protects access to rme_vmid_bitmap */
>  static DEFINE_SPINLOCK(rme_vmid_lock);
>  static unsigned long *rme_vmid_bitmap;
> @@ -460,6 +736,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  
>  		r = kvm_create_realm(kvm);
>  		break;
> +	case KVM_CAP_ARM_RME_INIT_IPA_REALM: {
> +		struct kvm_cap_arm_rme_init_ipa_args args;
> +		void __user *argp = u64_to_user_ptr(cap->args[1]);
> +
> +		if (copy_from_user(&args, argp, sizeof(args))) {
> +			r = -EFAULT;
> +			break;
> +		}
> +
> +		r = kvm_init_ipa_range_realm(kvm, &args);
> +		break;
> +	}
>  	default:
>  		r = -EINVAL;
>  		break;

