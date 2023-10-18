Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0407CD4B9
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjJRHAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjJRHAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:00:54 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A526B0
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 00:00:51 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4S9MB64ryfz15NcQ;
        Wed, 18 Oct 2023 14:58:06 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 18 Oct 2023 15:00:48 +0800
Subject: Re: [PATCH v2 2/5] KVM: arm64: Restore the stage-2 context in VHE's
 __tlb_switch_to_host()
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
 <20231012205422.3924618-3-oliver.upton@linux.dev>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5563bffd-0b27-ac95-9e87-24f5b8c71fb7@huawei.com>
Date:   Wed, 18 Oct 2023 15:00:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20231012205422.3924618-3-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/13 4:54, Oliver Upton wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> An MMU notifier could cause us to clobber the stage-2 context loaded on
> a CPU when we switch to another VM's context to invalidate. This isn't
> an issue right now as the stage-2 context gets reloaded on every guest
> entry, but is disastrous when moving __load_stage2() into the
> vcpu_load() path.
> 
> Restore the previous stage-2 context on the way out of a TLB
> invalidation if we installed something else. Deliberately do this after
> TGE=1 is synchronized to keep things safe in light of the speculative AT
> errata.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/vhe/tlb.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index f3f2e142e4f4..ef21153ce5fa 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -11,18 +11,25 @@
>  #include <asm/tlbflush.h>
>  
>  struct tlb_inv_context {
> -	unsigned long	flags;
> -	u64		tcr;
> -	u64		sctlr;
> +	struct kvm_s2_mmu	*mmu;
> +	unsigned long		flags;
> +	u64			tcr;
> +	u64			sctlr;
>  };
>  
>  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
>  				  struct tlb_inv_context *cxt)
>  {
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  	u64 val;
>  
>  	local_irq_save(cxt->flags);
>  
> +	if (vcpu && mmu != vcpu->arch.hw_mmu)
> +		cxt->mmu = mmu;

Shouldn't this be

cxt->mm = vcpu->arch.hw_mmu (the "previous" S2 context)?

Thanks,
Zenghui
