Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE6774DD03
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbjGJSEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 14:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjGJSEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 14:04:12 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133BD137
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 11:04:11 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b895fa8929so60074325ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 11:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689012250; x=1691604250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYLqBZaOzItKfrZ7qkctl+bAW7Mt+I13t+2ynGF0UiY=;
        b=6Em8Ck8pY6H7hDftF5k/CCVkzxbaS7N4lV5OK+Ffe265Trlh+BahH5YWayzioUDpCx
         9iY1q8Vz2wSsf6tE3GQ8QEryG3FWftA5Yh/z8rQVFo7R0Hu6MZ1QyGlYjNC1bjU3v674
         0Ell1lskpcCObjlKpcc4ijxKU36LVV3ESUmVKHOT+GpahucrrNhiTISfmt88x9gL3J3c
         Ma3HWhwyvlyVKctsPIEq1iZ6KaX2qH6Dycz1M7G13T/R9XgSN8M+UKwaYsjSGa5GN7iA
         bhWJLa2DO3VY0TJCcvydGnhuj3NF5JTAkQjeQKaPtzzjT9hQ9CpwWRzsnyTtcZj5wO18
         GTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689012250; x=1691604250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FYLqBZaOzItKfrZ7qkctl+bAW7Mt+I13t+2ynGF0UiY=;
        b=bzF/iV1zpyeBnmOkKv10yfbxd3KsSGO6Up067Lyi4CTaHprwwtcTaSdABNtMgDgPN2
         r2Oex74Jue6fefmF8SgaWW+HaikEhfK3MpT+jCzzEsKMlTqrGdrup0k6qzQIk20naEfm
         iOlMoKEwcdlReldnbMd4v0jeqFOdN3T4ReMCq4fbXWa/fqmMy+7k+KfaGqg6Gwqj2/n+
         5kszXPrvFGJEV2TH3IM+nTO+kR6uWD5tLRvbpUPXO18cTkkj8ryuKqzvSgn3bbhxEfRC
         vwyCXDZamVY54xe103pDWet2VP6+CowHzfgwZix4eW0SSCfYCXRIVbzRZa85EJyzhRvl
         Rliw==
X-Gm-Message-State: ABy/qLbphzbg0VMQS6GnxGSe+8andBGyXXIZoBsnb4Lll18br/eQCEQn
        khOZssmeZg5hHKY+aPAHvRw2ggSEmP0=
X-Google-Smtp-Source: APBJJlFSH+yLARWOcKqEJKKiVaqNOQphp5bI5CS4BulNlpKXujS+z4/oFnINg8Jmh4rjEYd2oGsEDqv9UwM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1cc:b0:1b8:a54c:61ef with SMTP id
 e12-20020a17090301cc00b001b8a54c61efmr13097824plh.9.1689012250555; Mon, 10
 Jul 2023 11:04:10 -0700 (PDT)
Date:   Mon, 10 Jul 2023 11:04:08 -0700
In-Reply-To: <20230703163548.1498943-1-maz@kernel.org>
Mime-Version: 1.0
References: <20230703163548.1498943-1-maz@kernel.org>
Message-ID: <ZKxIGOAcQbknIcBL@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        pbonzini@redhat.com,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        stable@vger.kernek.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 03, 2023, Marc Zyngier wrote:
> Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> a guest is running results in a number of ugly splats as most
> of this code expects to run with preemption disabled, which isn't
> the case anymore.
> 
> While the context is preemptable, it isn't migratable, which should
> be enough. But we have plenty of preemptible() checks all over
> the place, and our per-CPU accessors also disable preemption.
> 
> Since this affects released versions, let's do the easy fix first,
> disabling preemption in kvm_arch_hardware_enable(). We can always
> revisit this with a more invasive fix in the future.
> 
> Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
> Cc: stable@vger.kernek.org # v6.3, v6.4
> ---
>  arch/arm64/kvm/arm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index aaeae1145359..a28c4ffe4932 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
>  
>  int kvm_arch_hardware_enable(void)
>  {
> -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> +	int was_enabled;
>  
> +	/*
> +	 * Most calls to this function are made with migration
> +	 * disabled, but not with preemption disabled. The former is
> +	 * enough to ensure correctness, but most of the helpers
> +	 * expect the later and will throw a tantrum otherwise.
> +	 */
> +	preempt_disable();
> +
> +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);

IMO, this_cpu_has_cap() is at fault.  E.g. why not do this?

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7d7128c65161..b862477de2ce 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3193,7 +3193,9 @@ static void __init setup_boot_cpu_capabilities(void)
 
 bool this_cpu_has_cap(unsigned int n)
 {
-       if (!WARN_ON(preemptible()) && n < ARM64_NCAPS) {
+       __this_cpu_preempt_check("has_cap");
+
+       if (n < ARM64_NCAPS) {
                const struct arm64_cpu_capabilities *cap = cpu_hwcaps_ptrs[n];
 
                if (cap)
