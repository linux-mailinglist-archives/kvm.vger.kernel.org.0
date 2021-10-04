Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758B4420B28
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 14:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhJDMtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 08:49:47 -0400
Received: from foss.arm.com ([217.140.110.172]:56046 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233151AbhJDMtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 08:49:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B64B81FB;
        Mon,  4 Oct 2021 05:47:57 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12DA63F70D;
        Mon,  4 Oct 2021 05:47:55 -0700 (PDT)
Message-ID: <7b629634-0d0d-5601-3a64-c418ef2fc1e6@arm.com>
Date:   Mon, 4 Oct 2021 13:49:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 3/5] KVM: arm64: vgic-v3: Don't advertise
 ICC_CTLR_EL1.SEIS
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kernel-team@android.com,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20210924082542.2766170-1-maz@kernel.org>
 <20210924082542.2766170-4-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
In-Reply-To: <20210924082542.2766170-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/24/21 09:25, Marc Zyngier wrote:
> Since we are trapping all sysreg accesses when ICH_VTR_EL2.SEIS
> is set, and that we never deliver an SError when emulating
> any of the GICv3 sysregs, don't advertise ICC_CTLR_EL1.SEIS.

Makes sense, we don't emulate it, so don't advertise it. Checked
__vgic_v3_write_ctlr(), and we only allow the guest to modify EOI mode and which
register is responsible for determining the binary point for the interrupt priority.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 39f8f7f9227c..b3b50de496a3 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -987,8 +987,6 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
>  	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>  	/* IDbits */
>  	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
> -	/* SEIS */
> -	val |= ((vtr >> 22) & 1) << ICC_CTLR_EL1_SEIS_SHIFT;
>  	/* A3V */
>  	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
>  	/* EOImode */
