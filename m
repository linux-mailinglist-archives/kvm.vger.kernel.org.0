Return-Path: <kvm+bounces-38576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1413A3C232
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 15:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC75A1899268
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 14:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7611F3B9C;
	Wed, 19 Feb 2025 14:30:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6191F2B88;
	Wed, 19 Feb 2025 14:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739975438; cv=none; b=Qz43uT3MCmVlk1adU+d09LAXk/bz6LLxDtP9ZX+t/I6EU3Bi6gTmWYCUAnDumnEHi2EswTuivNKDHw4qq4xTkw6Mz0wTjlENlVkUMyzQf63J6Exz1B2pOZif1C0g1Yz1eiGiFKY+p568xnbvBhrMbYmbhlbmtiSmK/LK5rJZ3Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739975438; c=relaxed/simple;
	bh=g1/2wPLaewjbx4uyxyoD+nP5/AK0RWw0EsXYYA2h/bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDzTvVj3pem0U7su1FCt8g/9WlFpJDzFYTLSVIIRNU10wpHhuUZ6tTHh7YnetaflljhKYAizpnoi/L6ghfiipHYWHmzbcBJcbyiHtZxe8HOkXigTolLAzJt91BGrznEznnvzQ6gjzENln3bmgTppUQxJCRFmy0IDvbT7Kt5LK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C040312FC;
	Wed, 19 Feb 2025 06:30:53 -0800 (PST)
Received: from [10.57.84.90] (unknown [10.57.84.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 523213F59E;
	Wed, 19 Feb 2025 06:30:31 -0800 (PST)
Message-ID: <5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com>
Date: Wed, 19 Feb 2025 14:30:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/11] arm64: Enable memory encrypt for Realms
To: "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Will Deacon <will@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-10-steven.price@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20241017131434.40935-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/10/2024 14:14, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Use the memory encryption APIs to trigger a RSI call to request a
> transition between protected memory and shared memory (or vice versa)
> and updating the kernel's linear map of modified pages to flip the top
> bit of the IPA. This requires that block mappings are not used in the
> direct map for realm guests.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
[...]
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 547a9e0b46c2..6ae6ae806454 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -5,10 +5,12 @@
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/module.h>
> +#include <linux/mem_encrypt.h>
>  #include <linux/sched.h>
>  #include <linux/vmalloc.h>
>  
>  #include <asm/cacheflush.h>
> +#include <asm/pgtable-prot.h>
>  #include <asm/set_memory.h>
>  #include <asm/tlbflush.h>
>  #include <asm/kfence.h>
> @@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
>  bool can_set_direct_map(void)
>  {
>  	/*
> -	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
> -	 * mapped at page granularity, so that it is possible to
> +	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
> +	 * map to be mapped at page granularity, so that it is possible to
>  	 * protect/unprotect single pages.
>  	 *
>  	 * KFENCE pool requires page-granular mapping if initialized late.
> +	 *
> +	 * Realms need to make pages shared/protected at page granularity.
>  	 */
>  	return rodata_full || debug_pagealloc_enabled() ||
> -	       arm64_kfence_can_set_direct_map();
> +		arm64_kfence_can_set_direct_map() || is_realm_world();
>  }

Aneesh pointed out that this call to is_realm_world() is now too early 
since the decision to delay the RSI detection. The upshot is that a 
realm guest which doesn't have page granularity forced for other reasons 
will fail to share pages with the host.

At the moment I can think of a couple of options:

(1) Make rodata_full a requirement for realm guests. 
    CONFIG_RODATA_FULL_DEFAULT_ENABLED is already "default y" so this 
    isn't a big ask.

(2) Revisit the idea of detecting when running as a realm guest early. 
    This has the advantage of also "fixing" earlycon (no need to 
    manually specify the shared-alias of an unprotected UART).

I'm currently leaning towards (1) because it's the default anyway. But 
if we're going to need to fix earlycon (or indeed find other similar 
issues) then (2) would obviously make sense.

Any thoughts on the best option here.

Untested patch for (1) below. Although updating the docs would be
probably be a good idea too ;)

Thanks,
Steve

----8<---
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index ce4778141ec7..48a6ef0f401c 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -126,6 +126,10 @@ void __init arm64_rsi_init(void)
 		return;
 	if (!rsi_version_matches())
 		return;
+	if (!can_set_direct_map()) {
+		pr_err("rodata_full disabled, unable to run as a realm guest. Please enable CONFIG_RODATA_FULL_DEFAULT_ENABLED\n");
+		return;
+	}
 	if (WARN_ON(rsi_get_realm_config(&config)))
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 39fd1f7ff02a..f8fd8a3816fb 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -25,16 +25,14 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
 bool can_set_direct_map(void)
 {
 	/*
-	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
-	 * map to be mapped at page granularity, so that it is possible to
+	 * rodata_full, DEBUG_PAGEALLOC require linear map to be
+	 * mapped at page granularity, so that it is possible to
 	 * protect/unprotect single pages.
 	 *
 	 * KFENCE pool requires page-granular mapping if initialized late.
-	 *
-	 * Realms need to make pages shared/protected at page granularity.
 	 */
 	return rodata_full || debug_pagealloc_enabled() ||
-		arm64_kfence_can_set_direct_map() || is_realm_world();
+		arm64_kfence_can_set_direct_map();
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)


