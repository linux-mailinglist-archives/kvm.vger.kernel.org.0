Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C082A8A13
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgKEWu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 17:50:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgKEWu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 17:50:26 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCA5206CA;
        Thu,  5 Nov 2020 22:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604616626;
        bh=o7PrUBztNEfDJjUh55lvvosuP3j1T4tJ1RkSbtVr/fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Ebvug8OoOsCvSF4mWsVAwx1gVvC2DchFtyqQXV0yvyWmLXzN3mN7OHzas9Nk9GVe
         ltPMNCbR7Ehzw1IT5weWvnmtPO3dEG/LRvgPyoXM/UEKjznZ5JC1FQGwi9wNThFM7x
         JfFX9t6TBOXZwIIsqj+pjtQToFPIkW2d/O6jprg8=
Date:   Thu, 5 Nov 2020 22:50:21 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Peng Liang <liangpeng10@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/3] KVM: arm64: Rename access_amu() to undef_access()
Message-ID: <20201105225020.GE8842@willie-the-truck>
References: <20201103171445.271195-1-maz@kernel.org>
 <20201103171445.271195-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103171445.271195-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 05:14:44PM +0000, Marc Zyngier wrote:
> The only thing that access_amu() does is to inject an UNDEF exception,
> so let's rename it to the clearer undef_access(). We'll reuse that
> for some other system registers.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 61789027b92b..fafaa81bf1f6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1038,8 +1038,8 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> -static bool access_amu(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> -			     const struct sys_reg_desc *r)
> +static bool undef_access(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			 const struct sys_reg_desc *r)
>  {
>  	kvm_inject_undefined(vcpu);

This seems to be identical to trap_ptrauth(). Shall we give it the same
treatment?

Will
