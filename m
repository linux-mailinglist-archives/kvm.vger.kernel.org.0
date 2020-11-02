Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D28C2A2B7C
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgKBN3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 08:29:09 -0500
Received: from foss.arm.com ([217.140.110.172]:59478 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgKBN3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 08:29:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66E8030E;
        Mon,  2 Nov 2020 05:29:08 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C3973F66E;
        Mon,  2 Nov 2020 05:29:07 -0800 (PST)
Subject: Re: [PATCH 2/8] KVM: arm64: Remove leftover kern_hyp_va() in nVHE TLB
 invalidation
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-3-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4ba97fdf-3b62-a414-2f34-ee7c3fe22808@arm.com>
Date:   Mon, 2 Nov 2020 13:30:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> The new calling convention says that pointers coming from the SMCCC
> interface are turned into their HYP version in the host HVC handler.
> However, there is still a stray kern_hyp_va() in the TLB invalidation
> code, which could result in a corrupted pointer.
>
> Drop the spurious conversion.
>
> Fixes: a071261d9318 ("KVM: arm64: nVHE: Fix pointers during SMCCC convertion")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index 39ca71ab8866..fbde89a2c6e8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -128,7 +128,6 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
>  	struct tlb_inv_context cxt;
>  
>  	/* Switch to requested VMID */
> -	mmu = kern_hyp_va(mmu);
>  	__tlb_switch_to_guest(mmu, &cxt);
>  
>  	__tlbi(vmalle1);

Looks fine to me, the function handle_host_hcall() already does the required
transformation when handling the __kvm_tlb_flush_local_vmid function id:

case KVM_HOST_SMCCC_FUNC(__kvm_tlb_flush_local_vmid): { unsigned long r1 =
host_ctxt->regs.regs[1]; struct kvm_s2_mmu *mmu = (struct kvm_s2_mmu *)r1;
__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu)); break; }

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

