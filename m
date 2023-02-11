Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D73692FE5
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 11:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBKKHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 05:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKKHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 05:07:50 -0500
Received: from out-90.mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B259301BC
        for <kvm@vger.kernel.org>; Sat, 11 Feb 2023 02:07:48 -0800 (PST)
Date:   Sat, 11 Feb 2023 10:07:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676110066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZRjvYb4Ksjm5xGoHPb/oX2KqaO6lf9hahhWphjlh6Sw=;
        b=tbDRjwwuSot4VnQgVbi1KYnT0Y5ZcH/okX00hHSfyQy/lgjjbP282uHPZ0R6C8/JJUoPh+
        RdCwIgZnDpZH84l7XygAiMCB9Tqym+FIGrtp3NZprj551+3ARQQSh9HPa9pilVkQJ1K3Pe
        drsbcbv0I7ARQI1tykk3ynZg00jM1n0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 12/18] KVM: arm64: nv: Handle PSCI call via smc from the
 guest
Message-ID: <Y+do7RAm5PC8LFw2@linux.dev>
References: <20230209175820.1939006-1-maz@kernel.org>
 <20230209175820.1939006-13-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209175820.1939006-13-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 09, 2023 at 05:58:14PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> VMs used to execute hvc #0 for the psci call if EL3 is not implemented.
> However, when we come to provide the virtual EL2 mode to the VM, the
> host OS inside the VM calls kvm_call_hyp() which is also hvc #0. So,
> it's hard to differentiate between them from the host hypervisor's point
> of view.
> 
> So, let the VM execute smc instruction for the psci call. On ARMv8.3,
> even if EL3 is not implemented, a smc instruction executed at non-secure
> EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than being treated as
> UNDEFINED. So, the host hypervisor can handle this psci call without any
> confusion.

I think this commit message is rather stale to the point of being rather
misleading. This lets the vEL2 get at the entire gamut of SMCCC calls we
have in KVM, not just PSCI.

Of course, no problem with that since it is a requirement, but for
posterity the commit message should reflect the current state of KVM.

If I may suggest:

  Non-nested guests have used the hvc instruction to initiate SMCCC
  calls into KVM. This is quite a poor fit for NV as hvc exceptions are
  always taken to EL2. In other words, KVM needs to unconditionally
  forward the hvc exception back into vEL2 to uphold the architecture.

  Instead, treat the smc instruction from vEL2 as we would a guest
  hypercall, thereby allowing the vEL2 to interact with KVM's hypercall
  surface. Note that on NV-capable hardware HCR_EL2.TSC causes smc
  instructions executed in non-secure EL1 to trap to EL2, even if EL3 is
  not implemented.

> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/handle_exit.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index e75101f2aa6c..b0c343c4e062 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -63,6 +63,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
>  
>  static int handle_smc(struct kvm_vcpu *vcpu)
>  {
> +	int ret;
> +
>  	/*
>  	 * "If an SMC instruction executed at Non-secure EL1 is
>  	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
> @@ -70,10 +72,28 @@ static int handle_smc(struct kvm_vcpu *vcpu)
>  	 *
>  	 * We need to advance the PC after the trap, as it would
>  	 * otherwise return to the same address...
> +	 *
> +	 * If imm is non-zero, it's not defined, so just skip it.
> +	 */
> +	if (kvm_vcpu_hvc_get_imm(vcpu)) {
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +		kvm_incr_pc(vcpu);
> +		return 1;
> +	}
> +
> +	/*
> +	 * If imm is zero, it's a psci call.
> +	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
> +	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
> +	 * being treated as UNDEFINED.
>  	 */
> -	vcpu_set_reg(vcpu, 0, ~0UL);
> +	ret = kvm_hvc_call_handler(vcpu);
> +	if (ret < 0)
> +		vcpu_set_reg(vcpu, 0, ~0UL);
> +

This also has the subtle effect of allowing smc instructions from a
non-nested guest to hit our hypercall surface too. I think we should
avoid this and only handle smcs that actually come from a vEL2. What do
you think about the following?

I can squash in all of the changes I've asked for here.

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b0c343c4e062..a798c0b4d717 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -73,16 +73,18 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	 * We need to advance the PC after the trap, as it would
 	 * otherwise return to the same address...
 	 *
-	 * If imm is non-zero, it's not defined, so just skip it.
+	 * Only handle SMCs from the virtual EL2 with an immediate of zero and
+	 * skip it otherwise.
 	 */
-	if (kvm_vcpu_hvc_get_imm(vcpu)) {
+	if (!vcpu_is_el2(vcpu) || kvm_vcpu_hvc_get_imm(vcpu)) {
 		vcpu_set_reg(vcpu, 0, ~0UL);
 		kvm_incr_pc(vcpu);
 		return 1;
 	}
 
 	/*
-	 * If imm is zero, it's a psci call.
+	 * If imm is zero then it is likely an SMCCC call.
+	 *
 	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
 	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
 	 * being treated as UNDEFINED.

-- 
Thanks,
Oliver
