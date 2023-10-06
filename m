Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A887BB46C
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjJFJlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 05:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjJFJln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 05:41:43 -0400
Received: from out-198.mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5E19F
        for <kvm@vger.kernel.org>; Fri,  6 Oct 2023 02:41:39 -0700 (PDT)
Date:   Fri, 6 Oct 2023 09:41:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1696585297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dmT/ZnCt0gWb0fl3TeqqXjxc6m6Vc6HmmLBlt4vvIbE=;
        b=iX+VyBhv3KtGoceLedWKPsvSZMLH2vfYSHoVVYxCkvTmGRb4lAmrEveLnjzJtWI5txw2rh
        cPbuA0drLlTzACHSs988kg8VRxcU1bm2YU30hIJWFJ7PWPESxgZgxKKjoqyJTlEoakrMWB
        8NOm83ECTrJ2GJ0WqIsFEIivE6D3Cxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Don't zero VTTBR in
 __tlb_switch_to_host()
Message-ID: <ZR_WTS-bqrd3L5j2@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
 <20231006093600.1250986-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006093600.1250986-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 06, 2023 at 09:35:58AM +0000, Oliver Upton wrote:
> HCR_EL2.TGE=0 is sufficient to disable stage-2 translation, so there's

TGE=1, obviously :)

> no need to explicitly zero VTTBR_EL2. Note that this is exactly what we
> do on the guest exit path in __kvm_vcpu_run_vhe() already.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/vhe/tlb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index 46bd43f61d76..f3f2e142e4f4 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -66,7 +66,6 @@ static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
>  	 * We're done with the TLB operation, let's restore the host's
>  	 * view of HCR_EL2.
>  	 */
> -	write_sysreg(0, vttbr_el2);
>  	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
>  	isb();
>  
> -- 
> 2.42.0.609.gbb76f46606-goog
> 

-- 
Thanks,
Oliver
