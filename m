Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E7F1E26F8
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgEZQ3p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:29:45 -0400
Received: from foss.arm.com ([217.140.110.172]:53280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgEZQ3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:29:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C352B30E;
        Tue, 26 May 2020 09:29:44 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C53183F52E;
        Tue, 26 May 2020 09:29:42 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 19/26] KVM: arm64: Make struct kvm_regs userspace-only
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-20-maz@kernel.org>
Message-ID: <0a38305f-77f8-11b0-cb74-2bec07ce0a0a@arm.com>
Date:   Tue, 26 May 2020 17:29:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-20-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> struct kvm_regs is used by userspace to indicate which register gets
> accessed by the {GET,SET}_ONE_REG API. But as we're about to refactor
> the layout of the in-kernel register structures, we need the kernel to
> move away from it.
> 
> Let's make kvm_regs userspace only, and let the kernel map it to its own
> internal representation.

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 23ebe51410f06..9fec9231b63e2 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -102,6 +102,55 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>  	return size;
>  }
>  
> +static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	u64 off = core_reg_offset_from_id(reg->id);
> +
> +	switch (off) {

> +	default:
> +		return NULL;

Doesn't this switch statement catch an out of range offset, and a misaligned offset?

... We still test for those explicitly in the caller. Better safe than implicit?


> +	}
> +}

With the reset thing reported by Zenghui and Zengtao on the previous patch fixed:
Reviewed-by: James Morse <james.morse@arm.com>

(otherwise struct kvm_regs isn't userspace-only!)


Thanks,

James
