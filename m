Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545AF165F80
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 15:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBTOMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 09:12:49 -0500
Received: from foss.arm.com ([217.140.110.172]:43744 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgBTOMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 09:12:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F74E31B;
        Thu, 20 Feb 2020 06:12:48 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAF363F6CF;
        Thu, 20 Feb 2020 06:12:47 -0800 (PST)
Date:   Thu, 20 Feb 2020 14:12:44 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: arm64: Refactor filtering of ID registers
Message-ID: <20200220141244.353ec1d7@donnerap.cambridge.arm.com>
In-Reply-To: <20200216185324.32596-3-maz@kernel.org>
References: <20200216185324.32596-1-maz@kernel.org>
        <20200216185324.32596-3-maz@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 16 Feb 2020 18:53:21 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi,

> Our current ID register filtering is starting to be a mess of if()
> statements, and isn't going to get any saner.
> 
> Let's turn it into a switch(), which has a chance of being more
> readable.

Indeed, much better now.

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre

> ---
>  arch/arm64/kvm/sys_regs.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index da82c4b03aab..682fedd7700f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -9,6 +9,7 @@
>   *          Christoffer Dall <c.dall@virtualopensystems.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/bsearch.h>
>  #include <linux/kvm_host.h>
>  #include <linux/mm.h>
> @@ -1070,6 +1071,8 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -1078,13 +1081,18 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
>  	u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
>  
> -	if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
> -		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> -		val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -			 (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> +	switch (id) {
> +	case SYS_ID_AA64PFR0_EL1:
> +		if (!vcpu_has_sve(vcpu))
> +			val &= ~FEATURE(ID_AA64PFR0_SVE);
> +		break;
> +	case SYS_ID_AA64ISAR1_EL1:
> +		if (!vcpu_has_ptrauth(vcpu))
> +			val &= ~(FEATURE(ID_AA64ISAR1_APA) |
> +				 FEATURE(ID_AA64ISAR1_API) |
> +				 FEATURE(ID_AA64ISAR1_GPA) |
> +				 FEATURE(ID_AA64ISAR1_GPI));
> +		break;
>  	}
>  
>  	return val;

