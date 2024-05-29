Return-Path: <kvm+bounces-18298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF418D366C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1A1EB24944
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8853E181312;
	Wed, 29 May 2024 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IIW5e/z+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFC0363
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716985822; cv=none; b=Z7fJ4I3AmyglQzGsSj8xsGedZCnH7ebdydj/KlS/gHF8yWk/jurw5BvQaPAonGC6q/xNE189GwgrMHwKvAQVA+PTHK0atLEg15QRTVovb+AomDV9IDDw2nQM6mrbdw/qLc1pWvhr91PJx2gM+DEgxh7vYXRIsSS3gYR02OvAZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716985822; c=relaxed/simple;
	bh=gcXS9jLJSZWjAWlbQbdUOaZ2nz7/IfF2IriZ5nAD9xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCzImSqltb1RnSH7Rwl7iqbc37hhivXkLQvqX5cTHbp3rMcCobP1lx1IQe0ItoW8S8kM2mnw0exL7CnerwjsdA3s5uV9SVOgSCMC6u8u11aJ86/6OQezuykEsWkRE8oH63tIZ/MVGMQNcspj6GuAsv3+ZzllOYHQ3jKZehmtU1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IIW5e/z+; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a634e03339dso238396466b.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716985819; x=1717590619; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2LXZ9wqthbTQhc7QRlnA0utzKwKCI8VLIKqeGLoEf8o=;
        b=IIW5e/z+1iTjp3pOJf1IqiVWIvC2Zyd+guqNuZNs8IdPxliWmgzAc63iwqO6uugMfi
         F3bOdLUgenoax1NRVU3It5zwaIj4EBocnqQuoyUOqsm7VDl9j5isaWC6oYIxp0+E18Sq
         FRU8F3ZztdQzAgCfduis+jwyWbKeryCaKShMKm2i3gAZf01RDcv3RIrT7osxT3j4/miH
         McgL8Fj72A8VpQ0+zuFlF5AZXhFc4hb0EkIrow3YLCIYeW+sWSKD6M2WBkfbvzaE0iPW
         NkHJMxNISuSviXNU9qn2DR2jx03QHIwWhlZc/wGobvW6xYZSR/4jK5nNKhDJDXTppLpE
         mlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716985819; x=1717590619;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LXZ9wqthbTQhc7QRlnA0utzKwKCI8VLIKqeGLoEf8o=;
        b=cszpwbAMZRHUkwEMGiMvqfe64fgWPk+gEyfyJncmEq6xjVBolHVZXbL5t65wYKC88u
         8kuX5LeoDjiAmWqPsXU3ivDeqxsFrLLouBkP9F74YrEQ6ZplhOkxfPOi2nZ4JnOEqZi5
         QWr3nT74q6mj564WwhsdrGlfwCIhbAAOJkTKQUNYvidnIuzu99ARwR96yW2uP0xPI6hS
         H0003S0LLLJGp7bgEsl1AbURXyX8dEbVwT0H4/10ScWumsZvFjE0NevSZG7vJg4A/a79
         1V7zl5h+h7wopOloQ0WOjbH+2sHWsvi7bc+gjy3q6KRb5blDxYnWjXat4OeMQlvt1ycE
         yIkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbeQsFuE/0eJZN1HyKnlq2Gdsxlb0J/45R9mfMWWKc5CiTamcM7a0ON2sffKYW2iubF6vM6rOqyvKeiKVwqvj/7KJT
X-Gm-Message-State: AOJu0YzZiTlhYABVTro6bY5/niNGSvHgfZlehwempw5SsX7sYgfWwIH7
	+iaCQIVCTCCyzv/lt9hGiO2uYWnI5a5KeK2FmA1TvbQUaS0KzEbj98MqxNC0AQ==
X-Google-Smtp-Source: AGHT+IFROfs0Pam4Y1EffkR7Vgq8UzsI4afoBVYuqf4XpoEh6dk7KzH/TKYs/1/Lt8AHYYLxKWPW/g==
X-Received: by 2002:a17:906:a391:b0:a65:ab74:1e8d with SMTP id a640c23a62f3a-a65ab743299mr47596066b.59.1716985819350;
        Wed, 29 May 2024 05:30:19 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626cc4fedesm703808866b.118.2024.05.29.05.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 05:30:18 -0700 (PDT)
Date: Wed, 29 May 2024 13:30:15 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <vk4jfrmlxyoav365rti4rent5ptmxis5d6vjlynr6xs3s4k7h7@2j2dyv6lhcbr>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-11-ptosi@google.com>
 <20240513173005.GB29051@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240513173005.GB29051@willie-the-truck>

Hi Will,

On Mon, May 13, 2024 at 06:30:05PM +0100, Will Deacon wrote:
> On Fri, May 10, 2024 at 12:26:39PM +0100, Pierre-Clément Tosi wrote:
> > [...]
> > 
> > Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
> > call it directly and must use a PA function pointer from C (because it
> > is part of the idmap page), which would trigger a kCFI failure if the
> > type ID wasn't present.
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/include/asm/esr.h       |  6 ++++++
> >  arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
> >  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
> >  4 files changed, 25 insertions(+), 4 deletions(-)
> > 
> >  [...]
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 5a15737b4233..33fb5732ab83 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -5,6 +5,7 @@
> >   */
> >  
> >  #include <linux/arm-smccc.h>
> > +#include <linux/cfi_types.h>
> >  #include <linux/linkage.h>
> >  
> >  #include <asm/alternative.h>
> > @@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> >  /*
> >   * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
> >   *                             void (*finalize_fn)(void));
> > + *
> > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > + * using a physical pointer without triggering a kCFI failure.
> >   */
> > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> >  	/* Load the inputs from the VA pointer before turning the MMU off */
> >  	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
> >  	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> 
> Unrelated hunk?

No, this is needed to prevent a kCFI failure at EL2.

Please let me know if the comment and commit message aren't clear enough.

> 
> Will

