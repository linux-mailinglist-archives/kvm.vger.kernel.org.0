Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D26A799EF8
	for <lists+kvm@lfdr.de>; Sun, 10 Sep 2023 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjIJQby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Sep 2023 12:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjIJQbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Sep 2023 12:31:53 -0400
X-Greylist: delayed 336 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Sep 2023 09:31:47 PDT
Received: from out-219.mta0.migadu.com (out-219.mta0.migadu.com [IPv6:2001:41d0:1004:224b::db])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCC81B5
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 09:31:47 -0700 (PDT)
Message-ID: <fd96f034-b7ca-c1bd-a94e-06f8e84e52a7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694363170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsJTV4TGEiHWsO+KfLl8BIfB/jdFBOkN4/lhq6SgVaw=;
        b=G2BwvTyKhntpdDrUFaeWo109jjjRls1LKieTt6X/EFdnX5xJd0l02jyMyu8sYL3AgBBg3n
        nvp/4UVxHkAJwymOdmOn78UbWqJHSNiVwXX4sfv/NUMIBU33RMI1MhHdNj17ZhpTyC/XRI
        TBc5PobGJfqX7mFoU0ZzfbCayRuwbmY=
Date:   Mon, 11 Sep 2023 00:25:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>
References: <20230907100931.1186690-1-maz@kernel.org>
 <20230907100931.1186690-5-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20230907100931.1186690-5-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2023/9/7 18:09, Marc Zyngier wrote:
> As we're about to change the way SGIs are sent, start by splitting
> out some of the basic functionnality: instead of intermingling

functionality

> the broadcast and non-broadcast cases with the actual SGI generation,
> perform the following cleanups:
> 
> - move the SGI queuing into its own helper
> - split the broadcast code from the affinity-driven code
> - replace the mask/shift combinations with FIELD_GET()
> 
> The result is much more readable, and paves the way for further
> optimisations.

Indeed!

> @@ -1070,19 +1102,30 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_vcpu *c_vcpu;
> -	u16 target_cpus;
> +	unsigned long target_cpus;
>  	u64 mpidr;
> -	int sgi;
> -	int vcpu_id = vcpu->vcpu_id;
> -	bool broadcast;
> -	unsigned long c, flags;
> -
> -	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
> -	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
> -	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
> +	u32 sgi;
> +	unsigned long c;
> +
> +	sgi = FIELD_GET(ICC_SGI1R_SGI_ID_MASK, reg);
> +
> +	/* Broadcast */
> +	if (unlikely(reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT))) {
> +		kvm_for_each_vcpu(c, c_vcpu, kvm) {
> +			/* Don't signal the calling VCPU */
> +			if (c_vcpu == vcpu)
> +				continue;
> +
> +			vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
> +		}
> +
> +		return;
> +	}
> +
>  	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
>  	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
> +	target_cpus = FIELD_GET(ICC_SGI1R_TARGET_LIST_MASK, reg);
>  
>  	/*
>  	 * We iterate over all VCPUs to find the MPIDRs matching the request.
> @@ -1091,54 +1134,19 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
>  	 * VCPUs when most of the times we just signal a single VCPU.
>  	 */
>  	kvm_for_each_vcpu(c, c_vcpu, kvm) {
> -		struct vgic_irq *irq;
> +		int level0;
>  
>  		/* Exit early if we have dealt with all requested CPUs */
> -		if (!broadcast && target_cpus == 0)
> +		if (target_cpus == 0)
>  			break;
> -
> -		/* Don't signal the calling VCPU */
> -		if (broadcast && c == vcpu_id)

Unrelated to this patch, but it looks that we were comparing the value
of *vcpu_idx* and vcpu_id to skip the calling VCPU. Is there a rule in
KVM that userspace should invoke KVM_CREATE_VCPU with sequential
"vcpu id"s, starting at 0, so that the user-provided vcpu_id always
equals to the KVM-internal vcpu_idx for a given VCPU?

I asked because it seems that in kvm/arm64 we always use
kvm_get_vcpu(kvm, i) to obtain the kvm_vcpu pointer, even if *i* is
sometimes essentially provided by userspace..

Besides, the refactor itself looks good to me.

Thanks,
Zenghui
