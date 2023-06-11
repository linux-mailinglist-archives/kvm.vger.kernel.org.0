Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B356572AFE8
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 03:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbjFKBLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Jun 2023 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjFKBLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Jun 2023 21:11:10 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [IPv6:2001:41d0:203:375::38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6920E35A2
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 18:11:08 -0700 (PDT)
Date:   Sat, 10 Jun 2023 18:10:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686445865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lTqrTqu4lbc5Kdk1rdto/JErn7scjGVqX4V894iYVF4=;
        b=wLty8sZQIFI7Fh0ktYA4LViooorlIfhUyNVRHpukRyrAd54x+CjY4c5BVnSQmAm8XwmK+Y
        05FMzyQWquMTQTlgCbqV3lHNlKI5Mvakk7cGSEJhhguwg3qeXRd1LRm+benVGDdXl+Hcks
        ZNPtYdc4dN0LizW21ISwpHPR1r9PsMk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: PMU: Introduce pmu_v3_is_supported()
 helper
Message-ID: <ZIUfGJwVCO0y0lgQ@linux.dev>
References: <20230610061520.3026530-1-reijiw@google.com>
 <20230610061520.3026530-2-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610061520.3026530-2-reijiw@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 11:15:19PM -0700, Reiji Watanabe wrote:
> Introduce pmu_v3_is_supported() helper to check if the given
> PMUVer supports PMUv3, and use it instead of open coding it.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +--
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  include/kvm/arm_pmu.h     | 8 ++++++++
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 491ca7eb2a4c..5d2903f52a5f 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -672,8 +672,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
>  {
>  	struct arm_pmu_entry *entry;
>  
> -	if (pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_NI ||
> -	    pmu->pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +	if (!pmu_v3_is_supported(pmu->pmuver))
>  		return;

Why not use pmuv3_implemented()?

--
Thanks,
Oliver
