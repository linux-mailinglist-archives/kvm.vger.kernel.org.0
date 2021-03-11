Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF15337178
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 12:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhCKLgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 06:36:04 -0500
Received: from foss.arm.com ([217.140.110.172]:33456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhCKLff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 06:35:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32AC431B;
        Thu, 11 Mar 2021 03:35:35 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.54.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B82053F793;
        Thu, 11 Mar 2021 03:35:32 -0800 (PST)
Date:   Thu, 11 Mar 2021 11:35:29 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210311113529.GD37303@C02TD0UTHF1T.local>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
 <20210310154625.GA29738@willie-the-truck>
 <874khjxade.wl-maz@kernel.org>
 <20210310161546.GC29834@willie-the-truck>
 <87zgzagaqq.wl-maz@kernel.org>
 <20210310182022.GA29969@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310182022.GA29969@willie-the-truck>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 06:20:22PM +0000, Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:49:17PM +0000, Marc Zyngier wrote:
> > On Wed, 10 Mar 2021 16:15:47 +0000,
> > Will Deacon <will@kernel.org> wrote:
> > > On Wed, Mar 10, 2021 at 04:05:17PM +0000, Marc Zyngier wrote:
> > > > On Wed, 10 Mar 2021 15:46:26 +0000,
> > > > Will Deacon <will@kernel.org> wrote:
> > > > > On Wed, Mar 10, 2021 at 03:26:55PM +0000, Marc Zyngier wrote:
> > > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > index 4eb584ae13d9..7423f4d961a4 100644
> > > > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > @@ -122,7 +122,7 @@ alternative_else_nop_endif
> > > > > >  	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > > > > >  	 * is allowed to generate unaligned accesses.
> > > > > >  	 */
> > > > > > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > > > > > +	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_EL2_FLAGS & ~SCTLR_ELx_A))
> > > > > 
> > > > > Can we just drop SCTLR_ELx_A from SCTLR_EL2_FLAGS instead of clearing it
> > > > > here?
> > > > 
> > > > Absolutely. That'd actually be an improvement.
> > > 
> > > In fact, maybe just define INIT_SCTLR_EL2_MMU_ON to mirror what we do for
> > > EL1 (i.e. including the RES1 bits) and then use that here?
> > 
> > Like this?
> > 
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index dfd4edbfe360..593b9bf91bbd 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -579,9 +579,6 @@
> >  #define SCTLR_ELx_A	(BIT(1))
> >  #define SCTLR_ELx_M	(BIT(0))
> >  
> > -#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> > -			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
> > -
> >  /* SCTLR_EL2 specific flags. */
> >  #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> >  			 (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> > @@ -593,6 +590,10 @@
> >  #define ENDIAN_SET_EL2		0
> >  #endif
> >  
> > +#define INIT_SCTLR_EL2_MMU_ON						\
> > +	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
> > +	 SCTLR_ELx_IESB | ENDIAN_SET_EL2 | SCTLR_EL2_RES1)
> > +
> >  #define INIT_SCTLR_EL2_MMU_OFF \
> >  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 4eb584ae13d9..2e16b2098bbd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -117,13 +117,7 @@ alternative_else_nop_endif
> >  	tlbi	alle2
> >  	dsb	sy
> >  
> > -	/*
> > -	 * Preserve all the RES1 bits while setting the default flags,
> > -	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > -	 * is allowed to generate unaligned accesses.
> > -	 */
> > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > -CPU_BE(	orr	x0, x0, #SCTLR_ELx_EE)
> > +	mov_q	x0, INIT_SCTLR_EL2_MMU_ON
> >  alternative_if ARM64_HAS_ADDRESS_AUTH
> >  	mov_q	x1, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
> >  		     SCTLR_ELx_ENDA | SCTLR_ELx_ENDB)
> 
> Beautiful!
> 
> With that, you can have my ack on the whole series:
> 
> Acked-by: Will Deacon <will@kernel.org>

FWIW, likewise:

Acked-by: Mark Rutland <nark.rutland@arm.com>

This is really nice!

Thanks,
Mark.
