Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB032C57F1
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 16:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389952AbgKZPRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 10:17:32 -0500
Received: from foss.arm.com ([217.140.110.172]:36240 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389743AbgKZPRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 10:17:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E36CB31B;
        Thu, 26 Nov 2020 07:17:31 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36B103F71F;
        Thu, 26 Nov 2020 07:17:31 -0800 (PST)
Subject: Re: [PATCH 6/8] KVM: arm64: Remove dead PMU sysreg decoding code
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com
References: <20201113182602.471776-1-maz@kernel.org>
 <20201113182602.471776-7-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <1ed6dfd6-4ace-a562-bc2f-054a5c853fa6@arm.com>
Date:   Thu, 26 Nov 2020 15:18:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113182602.471776-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

I checked and indeed the remaining cases cover all registers that use this accessor.

However, I'm a bit torn here. The warning that I got when trying to run a guest
with the PMU feature flag set, but not initialized (reported at [1]) was also not
supposed to ever be reached:

static u32 kvm_pmu_event_mask(struct kvm *kvm)
{
    switch (kvm->arch.pmuver) {
    case 1:            /* ARMv8.0 */
        return GENMASK(9, 0);
    case 4:            /* ARMv8.1 */
    case 5:            /* ARMv8.4 */
    case 6:            /* ARMv8.5 */
        return GENMASK(15, 0);
    default:        /* Shouldn't be here, just for sanity */
        WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
        return 0;
    }
}

I realize it's not exactly the same thing and I'll leave it up to you if you want
to add a warning for the cases that should never happen. I'm fine either way:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

[1] https://www.spinics.net/lists/arm-kernel/msg857927.html

On 11/13/20 6:26 PM, Marc Zyngier wrote:
> The handling of traps in access_pmu_evcntr() has a couple of
> omminous "else return false;" statements that don't make any sense:
> the decoding tree coverse all the registers that trap to this handler,
> and returning false implies that we change PC, which we don't.
>
> Get rid of what is evidently dead code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3bd4cc40536b..f878d71484d8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -733,8 +733,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
>  				return false;
>  
>  			idx = ARMV8_PMU_CYCLE_IDX;
> -		} else {
> -			return false;
>  		}
>  	} else if (r->CRn == 0 && r->CRm == 9) {
>  		/* PMCCNTR */
> @@ -748,8 +746,6 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
>  			return false;
>  
>  		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> -	} else {
> -		return false;
>  	}
>  
>  	if (!pmu_counter_idx_valid(vcpu, idx))
