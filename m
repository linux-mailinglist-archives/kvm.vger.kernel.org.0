Return-Path: <kvm+bounces-18938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B908FD288
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26D9E1C23FC6
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CC115351A;
	Wed,  5 Jun 2024 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9cXwPAA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8762575A;
	Wed,  5 Jun 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603902; cv=none; b=OIRogY1obECqaWx7sOPf6l/ZLujfSaLI+/Xh8Z6/7xnmp3XcSf4o9gop9XBEHcAjwPzHJnOhR4Db347wU0s5kAEWGakrC9K+sIMwCidMMnQ9LX50zHi99S04n/iq1uLh8i5WrWjQeT/XVVP4rJiFRXI3WkwhBfyEBRpBmE42ZJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603902; c=relaxed/simple;
	bh=simTZ+nEbAiDmV4Z9GCTmA+TawwRkQwEDt4QYzfCKwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jcZeDpabOwSeIGv4P0txRNfnzaI/a16UQtiirLks778h3DVlWyoA0vXpNw4fP9Z1/gOjKJfbmY6Hnp+X8jayjfqkGo3Ui4RtI/rCKyT7igsaMeiVDoLVULmhtkrdEW3F0YClv5zRiE6QOiNaXi7LMvyvCVA1T/ej9ErRt71oZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9cXwPAA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7550C2BD11;
	Wed,  5 Jun 2024 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717603902;
	bh=simTZ+nEbAiDmV4Z9GCTmA+TawwRkQwEDt4QYzfCKwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d9cXwPAAA5mgiKYXiSVaJKv8htQWMAmJEk1PP14iYT4l4cV6B9LVnghU1IIE9fUXt
	 hSBiqXOmy94oqiaQ+NRgQHtrPsnars5Jr0oTNA3Wh8BMok/38X01QFUVHh83hIhJS8
	 OKFZ59BM8q4j67oC8xGNZgTSrFP4wtkVnMkKv3+lAL2cS30e5FYSIXhhDqsZl2Ix7w
	 ZsymXVoinJcv0qADpNXqkIxGByKe22c6OUqzhUXwME5/5BzdGNXpenID0SBUOaVuid
	 9KlqlcbpAaiWfL4YCn87Vx8FEZ/LD2ceQ8K5F27sdkOXhPejw+uzGaQwDlsvPyJktE
	 70doRkqkl8Pnw==
Date: Wed, 5 Jun 2024 17:11:37 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <20240605161137.GC22199@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-11-ptosi@google.com>
 <20240603144530.GK19151@willie-the-truck>
 <ucvvmwiur2qhagm4tcsbffftzaktthqnryi74k5ajtolhx4qor@via5txfexwlc>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ucvvmwiur2qhagm4tcsbffftzaktthqnryi74k5ajtolhx4qor@via5txfexwlc>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 04, 2024 at 05:04:40PM +0100, Pierre-Clément Tosi wrote:
> On Mon, Jun 03, 2024 at 03:45:30PM +0100, Will Deacon wrote:
> > On Wed, May 29, 2024 at 01:12:16PM +0100, Pierre-Clément Tosi wrote:
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > index d859c4de06b6..b1c8977e2812 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > @@ -5,6 +5,7 @@
> > >   */
> > >  
> > >  #include <linux/arm-smccc.h>
> > > +#include <linux/cfi_types.h>
> > >  #include <linux/linkage.h>
> > >  
> > >  #include <asm/alternative.h>
> > > @@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> > >  
> > >  /*
> > >   * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
> > > + *
> > > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > > + * using a physical pointer without triggering a kCFI failure.
> > >   */
> > > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> > >  	/* Turn the MMU off */
> > >  	pre_disable_mmu_workaround
> > >  	mrs	x9, sctlr_el2
> > 
> > I still think this last hunk should be merged with the earlier patch
> > fixing up the prototype of __pkvm_init_switch_pgd().
> 
> Unfortunately, this is not possible because
> 
>   SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> 
> makes the assembler generate an unresolved symbol for the function type, which
> the compiler only generates (from the C declaration) if it compiles with kCFI so
> that moving this hunk to an earlier patch results in a linker error:
> 
>   ld.lld: error: undefined symbol: __kvm_nvhe___kcfi_typeid___pkvm_init_switch_pgd
> 
> OTOH, moving it to a later patch triggers a kCFI (runtime) panic.
> 
> As a result, this hunk *must* be part of this patch.

Argh, thanks for the explanation. I thought CONFIG_CFI_CLANG would save
us here, but that's already enabled for the rest of the kernel so now I
understand what you mean.

> > With that:
> > 
> > Acked-by: Will Deacon <will@kernel.org>
> 
> As I haven't followed your suggestion, I'll ignore this.

You can keep the Ack.

Cheers,

Will

