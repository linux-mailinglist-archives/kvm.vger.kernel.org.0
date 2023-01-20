Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F80675227
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 11:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjATKOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 05:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjATKOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 05:14:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2605BB9
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 02:14:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46BC261F06
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E184EC433D2;
        Fri, 20 Jan 2023 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674209661;
        bh=8coKsEGNOLVnML+qzF/cIjseg/P2bFDNfepu0vc5CHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtc/Lu/Am8c4uVLCAKluT/KlboKnPU98ZUzaj4diA4eURXvZlRnakfAQjwEhUyv9N
         xxxUi/2bQzrIn9y37fhMtOvNTo4g2QiQy+Bq7Kc4k5OY+C+isMgYIJFOfH5DnfdSBz
         pFlGxHbfvpTPeTbYI2LQHNybWeIQhN1v0mUNYdIrZYQyxzYu7ZR4tGP1PFuM3U2/St
         4BQd1WnxJIsTZldWfhkY7NQ3bgyAHOwdBYNZYgANuMNYtzcWPX8toc0xOUs5l+pfet
         KQdG+TS49OeCDrmep/qNFw9ojv4C9jmRd4edEP8KYRN9wNiRJtSNA+yQFvA7H4+2MH
         bth0iY00R8QIg==
Date:   Fri, 20 Jan 2023 10:14:16 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disable KVM on systems with a VPIPT
 i-cache
Message-ID: <20230120101415.GA21784@willie-the-truck>
References: <20230113172523.2063867-1-maz@kernel.org>
 <20230113172523.2063867-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113172523.2063867-2-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 05:25:22PM +0000, Marc Zyngier wrote:
> Systems with a VMID-tagged PIPT i-cache have been supported for
> a while by Linux and KVM. However, these systems never appeared
> on our side of the multiverse.
> 
> Refuse to initialise KVM on such a machine, should then ever appear.
> Following changes will drop the support from the hypervisor.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..508deed213a2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2195,6 +2195,11 @@ int kvm_arch_init(void *opaque)
>  	int err;
>  	bool in_hyp_mode;
>  
> +	if (icache_is_vpipt()) {
> +		kvm_info("Incompatible VPIPT I-Cache policy\n");
> +		return -ENODEV;
> +	}

Hmm, does this work properly with late CPU onlining? For example, if my set
of boot CPUs are all friendly PIPT and KVM initialises happily, but then I
late online a CPU with a horrible VPIPT policy, I worry that we'll quietly
do the wrong thing wrt maintenance.

If that's the case, then arguably we already have a bug in the cases where
we trap and emulate accesses to CTR_EL0 from userspace because I _think_
we'll change the L1Ip field at runtime after userspace could've already read
it.

Is there something that stops us from ended up in this situation?

Will
