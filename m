Return-Path: <kvm+bounces-18651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D54248D8389
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 15:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EBF41F21FA8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC5F12C7FB;
	Mon,  3 Jun 2024 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtpDO4fx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE4612D744;
	Mon,  3 Jun 2024 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717420176; cv=none; b=Sr+4uE6BIygPlfK20hwR2HU8Y7hHGxjEAQxGhDLo3MjcwnZEKfM0eI6c2lWSJ5jGAX2AN0fq/yD0mK25JvoA5J8xcnxLP2f+OlZzBw5gK8NtBx41MXvrzcgbzh+ZWScvHFKIiTX53qxDj+uUJglHZ0r4QsJRvmpaVDshWslwvoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717420176; c=relaxed/simple;
	bh=M6NNbvARU58EuIkUnk8E/IjEk94rEU/YtoMJAvIC6HU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4gy4iAwbBb0eG5+DygYt4Hzx8qMtMqB/iGCRFfTlbVSeB1TF35y59p/DHaOt/pPuE8NyTy9eeoDBwL0G5JrAmL1hstXAdA/9tUjS2wArJPB+PlLVWFDt6nLdxRXlLHIWHjPqH/F3L/19ES6icDPE/1/sP7mFRAmVEp4As1WPxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtpDO4fx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F22DC4AF08;
	Mon,  3 Jun 2024 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717420176;
	bh=M6NNbvARU58EuIkUnk8E/IjEk94rEU/YtoMJAvIC6HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtpDO4fx8Anann6Kih5ARIt9RM+wreHgndBkOE+u4rFnUKgi7GwAXETV9RZhCiieR
	 RVUxi4ICcoTzRWP1oz0KVVYm4euYtw2IPYTJ0Skbhuucm51V3PyvqAV3eZ6+9J4nHs
	 uF1kvsdnZ0lTI2FpfGH+OiYU0ubjZmZnGroR/7/ayidDJMHg81idzdSKKDz+7zstvg
	 FQhk1o1V3uqFWvxAwgoebnjhBxxhbQ2OY8wvQJmF96OxZ9yJ/VajnerWjHACCJG1dn
	 mX1OGFT30ozSdazn6YVtC9m+KGiFiOS3/dHGQoME9vlw6hd6mxe8bB0+MsDE3wNFRk
	 Lx48RKrJGzy2w==
Date: Mon, 3 Jun 2024 14:09:31 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <20240603130930.GA18991@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-11-ptosi@google.com>
 <20240513173005.GB29051@willie-the-truck>
 <vk4jfrmlxyoav365rti4rent5ptmxis5d6vjlynr6xs3s4k7h7@2j2dyv6lhcbr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <vk4jfrmlxyoav365rti4rent5ptmxis5d6vjlynr6xs3s4k7h7@2j2dyv6lhcbr>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:30:15PM +0100, Pierre-Clément Tosi wrote:
> On Mon, May 13, 2024 at 06:30:05PM +0100, Will Deacon wrote:
> > On Fri, May 10, 2024 at 12:26:39PM +0100, Pierre-Clément Tosi wrote:
> > > [...]
> > > 
> > > Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
> > > call it directly and must use a PA function pointer from C (because it
> > > is part of the idmap page), which would trigger a kCFI failure if the
> > > type ID wasn't present.
> > > 
> > > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > > ---
> > >  arch/arm64/include/asm/esr.h       |  6 ++++++
> > >  arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
> > >  4 files changed, 25 insertions(+), 4 deletions(-)
> > > 
> > >  [...]
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > index 5a15737b4233..33fb5732ab83 100644
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
> > > @@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> > >  /*
> > >   * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
> > >   *                             void (*finalize_fn)(void));
> > > + *
> > > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > > + * using a physical pointer without triggering a kCFI failure.
> > >   */
> > > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> > >  	/* Load the inputs from the VA pointer before turning the MMU off */
> > >  	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
> > >  	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> > 
> > Unrelated hunk?
> 
> No, this is needed to prevent a kCFI failure at EL2.
> 
> Please let me know if the comment and commit message aren't clear enough.

I'm not disputing that this hunk is needed, but I think it should be
in place before the patch enabling CFI. For example, by merging it in
with patch 2?

Will

