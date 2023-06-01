Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60907193D9
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjFAHCf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 03:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjFAHCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 03:02:05 -0400
Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [IPv6:2001:41d0:203:375::3d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD95F2
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 00:01:56 -0700 (PDT)
Date:   Thu, 1 Jun 2023 07:01:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685602914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=plr4C16SSJbKZ59AieGvFJiPtYheTw7pGAQ68J2Djz8=;
        b=C7FXcOcqsYSeBr4NAXtbvcxKb0OL0ZNSvL9RHTKGcT4hdyOL9Y32dz6uHpohEy6iOhUg4N
        C72iagtr2eRQ54LHUg0d9WCFov4IiviKD1ws6ZtPU27I3oQo0gQY67+fbdo5IwHqZFVQcj
        RouUPWaFLIDHHGuuKBJm6IF/8r0WJZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 02/17] arm64: Add KVM_HVHE capability and has_hvhe()
 predicate
Message-ID: <ZHhCXm4k9zEOwPtV@linux.dev>
References: <20221020090727.3669908-1-maz@kernel.org>
 <20221020090727.3669908-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020090727.3669908-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022 at 10:07:12AM +0100, Marc Zyngier wrote:
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a3959e9f7d55..efac89c4c548 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1932,6 +1932,15 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
>  		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
>  }
>  
> +static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> +			  int __unused)
> +{
> +	u64 val;
> +
> +	val = arm64_sw_feature_override.val & arm64_sw_feature_override.mask;
> +	return cpuid_feature_extract_unsigned_field(val, ARM64_SW_FEATURE_OVERRIDE_HVHE);
> +}

Does this need to test ID_AA64MMFR1_EL1.VH as well? Otherwise I don't
see what would stop us from attempting hVHE on a system with asymmetric
support for VHE, as the software override was only evaluated on the boot
CPU.

> +
>  #ifdef CONFIG_ARM64_PAN
>  static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
>  {
> @@ -2642,6 +2651,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>  		.matches = has_cpuid_feature,
>  		.cpu_enable = cpu_trap_el0_impdef,
>  	},
> +	{
> +		.desc = "VHE for hypervisor only",
> +		.capability = ARM64_KVM_HVHE,
> +		.type = ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE,
> +		.matches = hvhe_possible,
> +	},
>  	{},
>  };
>  
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index f1c0347ec31a..cee2be85b89b 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -43,6 +43,7 @@ HAS_TLB_RANGE
>  HAS_VIRT_HOST_EXTN
>  HAS_WFXT
>  HW_DBM
> +KVM_HVHE
>  KVM_PROTECTED_MODE
>  MISMATCHED_CACHE_TYPE
>  MTE
> -- 
> 2.34.1
> 

-- 
Thanks,
Oliver
