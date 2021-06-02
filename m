Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FADF39965C
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFBX3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:29:44 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46952 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFBX3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 19:29:43 -0400
Received: by mail-pg1-f179.google.com with SMTP id n12so3579678pgs.13
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qVLg4Q35iCp+LlhdPI9P9bXpg6OFtieobQceA0Gb/Xk=;
        b=htyn0vTZfw8IfuHoWZd5HiZ+suevAlDWCSkhs+BOEVeTFRufexfOiwfuxvpNaCtwuZ
         byqWD32hXz49RAK9QxzCF8WjQevSGmkmcx8I10QW2eyIk96oJsKZ5D7z76hRfo3wz7HI
         1Yo8K0oN+IJPB28T8p7kpxiDEcdwfLlP/N5xC+zMro9P9pJRH4AyRfuveOjPvdH33XGG
         Z3FZB8AkluzJC0xivxo5TRqN9GTxqlSH6FuHnkNLIc2xFhTenZo4+dimh+OJsvJ0dm1h
         z9XTytYXbExNzWv0Gb56M4irnma4K6JjGsy9CCnYV8FMpiEPcYfR2kMB2ObPujM1hiJc
         D9Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qVLg4Q35iCp+LlhdPI9P9bXpg6OFtieobQceA0Gb/Xk=;
        b=p0rjNW803KMtvmjdmC2R/ZFohg+jKaK70zhOjUGKxbjluZrg0o5LQfJTNUiUM7YoAS
         69QvQdiNZGJDWYQbVvT86pZ71Gr6GrglNc3GsPgsYVnrYhVyWRZI5UY4nFXx0N74xD4p
         sTZTfHGjeCaUFJgZbZC6dPsaasB5Zexu2infPOdJ+whBu3bwv8rPt5ftk57o9xsG+xnh
         JiQlzBIlT4QPBPm+7kjJR8OqIrjBuj0/2Ln2QmWWKaPSffKk39neDITpRkdiL3nOStsh
         awn5fmSnvfXJvNYeAbJbxd4qUnvTZRyROWGNwyXDEgVKeN/TzbTXXbi4/cQIlx6JvN6k
         zPbg==
X-Gm-Message-State: AOAM532R7SnUXZAIoQWOmhlerpaeopqZ+DjSbB1Z+8cqUsDS2ts6dTbd
        cHP3j/+Gw6JpHDF7GySt4StG0g==
X-Google-Smtp-Source: ABdhPJyFKVnJ0duxYPD4Y/Doon1B87bwqj4O5vlJHiiZBYmVCJxx+kLmIYEwIt97YKOsGmDPZN6lMA==
X-Received: by 2002:a63:f815:: with SMTP id n21mr37018823pgh.2.1622676415852;
        Wed, 02 Jun 2021 16:26:55 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id o10sm536969pfh.67.2021.06.02.16.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 16:26:55 -0700 (PDT)
Date:   Wed, 2 Jun 2021 16:26:51 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: get-reg-list: Split base
 and pmu registers
Message-ID: <YLgTu4EEnwfrtHSo@google.com>
References: <20210531103344.29325-1-drjones@redhat.com>
 <20210531103344.29325-6-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-6-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 12:33:44PM +0200, Andrew Jones wrote:
> Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> userspace when not available") the get-reg-list* tests have been
> failing with
> 
>   ...
>   ... There are 74 missing registers.
>   The following lines are missing registers:
>   ...
> 
> where the 74 missing registers are all PMU registers. This isn't a
> bug in KVM that the selftest found, even though it's true that a
> KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> flag, but still expecting the PMU registers to be in the reg-list,
> would suddenly no longer have their expectations met. In that case,
> the expectations were wrong, though, so that KVM userspace needs to
> be fixed, and so does this selftest. The fix for this selftest is to
> pull the PMU registers out of the base register sublist into their
> own sublist and then create new, pmu-enabled vcpu configs which can
> be tested.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ricardo Koller <ricarkol@google.com>

> ---
>  .../selftests/kvm/aarch64/get-reg-list.c      | 39 +++++++++++++++----
>  1 file changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index b46b8a1fdc0c..a16c8f05366c 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -637,7 +637,7 @@ int main(int ac, char **av)
>   * The current blessed list was primed with the output of kernel version
>   * v4.15 with --core-reg-fixup and then later updated with new registers.
>   *
> - * The blessed list is up to date with kernel version v5.10-rc5
> + * The blessed list is up to date with kernel version v5.13-rc3
>   */
>  static __u64 base_regs[] = {
>  	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
> @@ -829,8 +829,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
>  	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
>  	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
> -	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
>  	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
> @@ -839,6 +837,16 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
>  	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
>  	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
> +	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
> +	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
> +	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
> +	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
> +	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
> +};
> +
> +static __u64 pmu_regs[] = {
> +	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
> +	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 0),	/* PMCR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
> @@ -848,8 +856,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
>  	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
> -	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
>  	ARM64_SYS_REG(3, 3, 14, 8, 0),
>  	ARM64_SYS_REG(3, 3, 14, 8, 1),
>  	ARM64_SYS_REG(3, 3, 14, 8, 2),
> @@ -913,9 +919,6 @@ static __u64 base_regs[] = {
>  	ARM64_SYS_REG(3, 3, 14, 15, 5),
>  	ARM64_SYS_REG(3, 3, 14, 15, 6),
>  	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
> -	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
> -	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
>  };
>  
>  static __u64 vregs[] = {
> @@ -1015,6 +1018,8 @@ static __u64 sve_rejects_set[] = {
>  	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
>  #define VREGS_SUBLIST \
>  	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
> +#define PMU_SUBLIST \
> +	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
>  #define SVE_SUBLIST \
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
> @@ -1027,6 +1032,14 @@ static struct vcpu_config vregs_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config vregs_pmu_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	VREGS_SUBLIST,
> +	PMU_SUBLIST,
> +	{0},
> +	},
> +};
>  static struct vcpu_config sve_config = {
>  	.sublists = {
>  	BASE_SUBLIST,
> @@ -1034,9 +1047,19 @@ static struct vcpu_config sve_config = {
>  	{0},
>  	},
>  };
> +static struct vcpu_config sve_pmu_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	SVE_SUBLIST,
> +	PMU_SUBLIST,
> +	{0},
> +	},
> +};
>  
>  static struct vcpu_config *vcpu_configs[] = {
>  	&vregs_config,
> +	&vregs_pmu_config,
>  	&sve_config,
> +	&sve_pmu_config,
>  };
>  static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.31.1
> 
