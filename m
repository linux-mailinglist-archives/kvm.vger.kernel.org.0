Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F06E70AFB1
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 21:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjEUTAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 15:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEUTAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 15:00:45 -0400
Received: from out-17.mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B939AB6
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 12:00:43 -0700 (PDT)
Date:   Sun, 21 May 2023 19:00:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684695641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Jxp6PYllL7DwCmDFtzb6hRQVpoYB2WZw0OlgDJXFEo=;
        b=C7mpz4vce+vo7x33wWenlXz2eY1+Zb9F7AGX0H5+UfLh20RjSce238S3FVsQV2841LFpS5
        gigAw7/fRa1xp9/9wfuEFpluOQKLm5ouSE7bwKQNQ7mwtkWmqvuiTA/uoEMnnVljrKlb7v
        4+qV3F6hQe6XnhsHLsRlZrFE9PV3cGU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is
 available
Message-ID: <ZGpqVSu8kJF37rU6@linux.dev>
References: <20230515170016.965378-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515170016.965378-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Mon, May 15, 2023 at 06:00:16PM +0100, Marc Zyngier wrote:
> CTR_EL0 can often be used in userspace, and it would be nice if
> KVM didn't have to emulate it unnecessarily.
> 
> While it isn't possible to trap the cache configuration registers
> indemendently from CTR_EL0 in the base ARMv8.0 architecture, FEAT_EVT
> allows these cache configuration registers (CCSIDR_EL1, CCSIDR2_EL1,
> CLIDR_EL1 and CSSELR_EL1) to be trapped indepdently by setting
> HCR_EL2.TID4.
> 
> Switch to using TID4 instead of TID2 in the cases where FEAT_EVT
> is available *and* that KVM doesn't need to sanitise CTR_EL0 to
> paper over mismatched cache configurations.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Just squashed the following nitpicks into your patch (trailing
whitespace, feature name).

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a08291051ac9..35bffdec0214 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -100,7 +100,7 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TID4;
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
-	
+
 	if (vcpu_el1_is_32bit(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c51870d4d492..4a2ab3f366de 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2642,7 +2642,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, DIT, IMP)
 	},
 	{
-		.desc = "Extended Virtualization Traps",
+		.desc = "Enhanced Virtualization Traps",
 		.capability = ARM64_HAS_EVT,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.sys_reg = SYS_ID_AA64MMFR2_EL1,

-- 
Thanks,
Oliver
