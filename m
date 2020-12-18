Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E082DE10C
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 11:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388944AbgLRKcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 05:32:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbgLRKcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 05:32:36 -0500
Date:   Fri, 18 Dec 2020 10:31:52 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: linux-next: manual merge of the kvm tree with the arm64-fixes
 tree
Message-ID: <20201218103151.GA5258@gaia>
References: <20201218134739.45973671@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218134739.45973671@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 18, 2020 at 01:47:39PM +1100, Stephen Rothwell wrote:
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>   arch/arm64/include/asm/kvm_asm.h
> 
> between commit:
> 
>   9fd339a45be5 ("arm64: Work around broken GCC 4.9 handling of "S" constraint")
> 
> from the arm64-fixes tree and commit:
> 
>   b881cdce77b4 ("KVM: arm64: Allocate hyp vectors statically")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc arch/arm64/include/asm/kvm_asm.h
> index 8e5fa28b78c2,7ccf770c53d9..000000000000
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@@ -198,14 -199,6 +199,12 @@@ extern void __vgic_v3_init_lrs(void)
>   
>   extern u32 __kvm_get_mdcr_el2(void);
>   
> - extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
> - 
>  +#if defined(GCC_VERSION) && GCC_VERSION < 50000
>  +#define SYM_CONSTRAINT	"i"
>  +#else
>  +#define SYM_CONSTRAINT	"S"
>  +#endif
>  +
>   /*
>    * Obtain the PC-relative address of a kernel symbol
>    * s: symbol

Thanks Stephen, it looks fine. I'll send a pull request later today with
this commit but it's simple enough for Linus to fix it.

-- 
Catalin
