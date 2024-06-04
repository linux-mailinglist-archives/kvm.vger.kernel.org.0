Return-Path: <kvm+bounces-18798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F158FB8C1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 18:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46443B3221B
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 16:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DED514600B;
	Tue,  4 Jun 2024 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZZ8VS9n9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E283413D619
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717517088; cv=none; b=L3SJ6L24PPixjk5CbDyEOZzrr6diMnFQcww+nLRLGe0FwntbXiXJJUithP2MbkEnSTUZEBP3de3+cPC9t28Wn8yyPT2DsqopBn0yME6Q7xezvhk2m6D3//wAY7Cyrhrh/UvTU5BWQ6ecV1PsGO0FcJc0D/0rdtHlqBcQ0wKrzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717517088; c=relaxed/simple;
	bh=TuVYZmXd02wbEklbfC5WAvOqMWKiRbjiXfc+JoeuUhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4JEhLZ7L5tyn8J3NgO1IKg2pQBFSx8ymbFXKKkTM8vNgV0siOhWN7X2RSz/XDQshqxcD+ZBL3JnxO9qzOZr9UEWmQhFd1T2iqiTe8/yUTD+SeKJuJDxH3rBoO+WReyl7SXkuAj5KtYaKD6pOkrEnheTBjdH7yXwv+5Ymnutwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZZ8VS9n9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a63359aaaa6so747228366b.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717517085; x=1718121885; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Cruorfn7NoREOjiMGGn/cp+VaqblM1rLgighQuS1JLA=;
        b=ZZ8VS9n9v4cVVW55QkbmTOJUAPwGng48FGLZ9H8wqNM5FzYY7fDZNfaD4CHDYbjjDy
         CGx8peOVZSydNtD/XEzA/uuHMLyB6hfZtF4wM0QMBbr8OJg8+datX8Bpod5dl+AQKSsF
         zsgcSeOWN6WtRx7lK8X7Mn9DgifoWmIccZiJHu5qBJxAnwf+MECt25jBBQIYyrUjvkq1
         XzwMGoxeZE+acARx151IzmXrdMaQYTPMa8YS7oxp2kNcMnNZO2B3SXwodoksBvxXYLR3
         Nje0F6+bAhIF/NpceCHEcqjj/9hwW7qfnsPZbHf0iV1TlHQ21P9FTIyxZPLgafpJRzcI
         ZFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717517085; x=1718121885;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cruorfn7NoREOjiMGGn/cp+VaqblM1rLgighQuS1JLA=;
        b=pYmnaQo3ypttVXXbu+gyWcllL2X13dZg+6D098PZzslfeSJI+yFsJTcm2hgik4UDp/
         VskkmX2qzcL8ZGUqa6N36MImSddmFCrAUZejjubg7h5bOvoxowGHEjQou90KwV6zdQxd
         vQF4Ty9rQqB/otUVeUkMUM1mQJ8vqT4IdhgQugmLQEi8TT6sV3bzT99C6wE66Ra/A4J1
         Lc6AzdEHzqLnJqtHV2jeWsEFfvVGYoQzc7atHmI9N8YU5UX5Ryt8Iw+zonSZGSjLwOj8
         0CllVIl/DN1LV3grv2Usb14fZccIuf9xSs6buz2L04KRAgSAyNq+s4b53psNpWy2IpEX
         y0jw==
X-Forwarded-Encrypted: i=1; AJvYcCWyOeSkRXb8OpcJNr/TrZsyVBuBpAso4x/i6Zi5Xt+nUd61kPIQUs94JV97e0jV5AlbAx4+c4jixIvXVLyThOyQp61y
X-Gm-Message-State: AOJu0YzhL26w1eo6QnSaSGk201ciRZsIHsOz5rdhWWms8zFeXUVhm8/+
	8q5qresww4f4vLKzGHeQOz9VLlU2L8xMaVvvQniGqrn2swUQmReu8Rr0j+VmSg==
X-Google-Smtp-Source: AGHT+IGInW6fKvSmBsK5Zli+h9BQYP14HAX01lASA3eX37L7IrTgDRmIzyPqKYNdoRF2r9nIA1b23g==
X-Received: by 2002:a17:907:b010:b0:a59:c209:3e33 with SMTP id a640c23a62f3a-a681fe4bc4bmr607698766b.15.1717517084985;
        Tue, 04 Jun 2024 09:04:44 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68c5c523b4sm478543266b.11.2024.06.04.09.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 09:04:44 -0700 (PDT)
Date: Tue, 4 Jun 2024 17:04:40 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <ucvvmwiur2qhagm4tcsbffftzaktthqnryi74k5ajtolhx4qor@via5txfexwlc>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-11-ptosi@google.com>
 <20240603144530.GK19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603144530.GK19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:45:30PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:16PM +0100, Pierre-Clément Tosi wrote:
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index d859c4de06b6..b1c8977e2812 100644
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
> > @@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
> >  
> >  /*
> >   * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
> > + *
> > + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> > + * using a physical pointer without triggering a kCFI failure.
> >   */
> > -SYM_FUNC_START(__pkvm_init_switch_pgd)
> > +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
> >  	/* Turn the MMU off */
> >  	pre_disable_mmu_workaround
> >  	mrs	x9, sctlr_el2
> 
> I still think this last hunk should be merged with the earlier patch
> fixing up the prototype of __pkvm_init_switch_pgd().

Unfortunately, this is not possible because

  SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)

makes the assembler generate an unresolved symbol for the function type, which
the compiler only generates (from the C declaration) if it compiles with kCFI so
that moving this hunk to an earlier patch results in a linker error:

  ld.lld: error: undefined symbol: __kvm_nvhe___kcfi_typeid___pkvm_init_switch_pgd

OTOH, moving it to a later patch triggers a kCFI (runtime) panic.

As a result, this hunk *must* be part of this patch.

> 
> With that:
> 
> Acked-by: Will Deacon <will@kernel.org>

As I haven't followed your suggestion, I'll ignore this.

