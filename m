Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458783B922D
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhGANUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236745AbhGANUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD17B61413;
        Thu,  1 Jul 2021 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625145459;
        bh=cI1lm4mozxs4nIm/KqNPIglmKNb4tX+KV0h6fmFP+R0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R5cjISF1eh/5/Hdbdvebd57RmqEqbIoCtFhWl86CkgdEzBKPr+OL0Fr8r4Ec61kDo
         FK7jDUp3Mjw5PslrKZVxhD8wFRQsQWe9lB/3F2oXnQELml/J7RlJauoXYH4zoScrRo
         acm2I1wkol2WzxF99j2mZ/vHSOJDSia0orfn1cshIADREzPPRfKI0Z3G9zaoecLU2h
         Fs58SRA/m3xEDJbVgxsYRAMs8MYS+RFNQILw+87y5S9p3NF8at+WPyNPaPjljFWlbb
         ocr5c8SkjGyVFnrX17tTY466zjDovMnMJq3O6DyVPqbxBLi8T9LKK+7b4ZRQxp/O8E
         JPDZDqgo1uU2Q==
Date:   Thu, 1 Jul 2021 14:17:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 05/13] KVM: arm64: Restore mdcr_el2 from vcpu
Message-ID: <20210701131733.GE9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-6-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-6-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:42PM +0100, Fuad Tabba wrote:
> On deactivating traps, restore the value of mdcr_el2 from the
> vcpu context, rather than directly reading the hardware register.
> Currently, the two values are the same, i.e., the hardware
> register and the vcpu one. A future patch will be changing the
> value of mdcr_el2 on activating traps, and this ensures that its
> value will be restored.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index f7af9688c1f7..430b5bae8761 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -73,7 +73,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
>  
>  	___deactivate_traps(vcpu);
>  
> -	mdcr_el2 = read_sysreg(mdcr_el2);
> +	mdcr_el2 = vcpu->arch.mdcr_el2;

Do you need to change the VHE code too?

Will
