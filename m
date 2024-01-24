Return-Path: <kvm+bounces-6843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB21A83AE6C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5453B2B83E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B327CF3C;
	Wed, 24 Jan 2024 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kyUHQEMO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C561869
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706113522; cv=none; b=gou/gXbc/zFho9TPTK8ojHqs5jLXVjSKbXqqHBOOFZYpf6sPc4VDaRjrmfhT37H4iCph0HvKaMeJAwhgTWjMdLoIpchQhquR4UEebi5r+O5zx90FF7I4mZ9ZENO90pS4pPHbff+ziJKhxlN908m9j+kynxGk3RPT54rYSuOOuL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706113522; c=relaxed/simple;
	bh=V8c2cPcx8qXCwYKsBCzYFb0VJkAo5lBKil3rUqnEWMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C8r9fIfKnemGun0rLnbf8gwqCjjcYYisxXsGh0/xX4oakOeYe8AXOAsopIddcAY0kugKjGe1gaTJRrKbd3AkqgGToN7JnR8c7PClfznmzzD2dmELALtmfMcJaeZvshnzb+krIszQto4qPPOi2w4ANyHFHSmMlyt7R/aa4PT5rlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kyUHQEMO; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc365b303abso3497507276.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 08:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706113519; x=1706718319; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0CB9g0UuS73iITu6tgKIcBT+b0p2dqCHOybX6/OUmJA=;
        b=kyUHQEMOV/wR1EpynmH7BVnL1Rw+Yzq9mQzH//pfaBbRpfe2hYYxppGHM/t6CqebA+
         I8YOVL+a4A1HIwiNu5u2MNGhtvxlbVhhavIuoY0UxZuFf7A9lYZ4i1jBFdYrGdtlRX0V
         tn94O8LuSOJF4POXyprE+fatIBQUoNVOTL4WIIfDDn1BbtjnF6i6NqX4FgczZC+47LQP
         H/rPQQg2kSh9dhlux7qR6/uUffv8TKeZ+4FZ1PWvZFh/3iwefLaxl9SQjWlBz5lvnJr4
         XbScWzxptsTKZOnyantKW+8LZc2neF2kNriab6AAL8xNVGshChqVNqRvIGrUz6vgDVG3
         Xx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706113519; x=1706718319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0CB9g0UuS73iITu6tgKIcBT+b0p2dqCHOybX6/OUmJA=;
        b=mDzJPPpT5U3Z/N1j0uju4+Rbvsd1QBhbtunK9lTZZPtj/B/gbH3XEPsKmwh4uryc8R
         FvjyKtHJedlpZDSvfVhPdx6vsheQnx8yc6/ZhfIzKHsIlAd81pSPqp5FaZ7zklUJZ2lZ
         Uk1x4JjsBlVJBHq6b5PGd1ydgF0Dv3bk+AEPkpU+BOtXsgFZ+MTpvwkGxzZlBZlSRyx2
         gwOS4exDpsC4mszFpyCAI9Y3ogX1Fvx513yIML6zcM2fB4osl6E9od5nPzDupyfgmRTv
         C5kOhtpetwfZK4nZJCzFf9VchYcPEO9P99WTt88ZPxDbHyOuioDgngyJ85qswT/o7uhf
         sszw==
X-Gm-Message-State: AOJu0YwgicFIBPILfFfznQJiPyphkQHg3ft0mZFTSgUMeORGewB8Jypg
	4Lk+LHeJATHcEwUxD1EOv1+jboawAU26D/qK/jUTimRPGhpozENAEFoKyRTiTE8WJvqchhfHigG
	MOw==
X-Google-Smtp-Source: AGHT+IGr252szjH4g93wKVz1RH9JVWutpvTNlX80OC1R2PWsKKKTzftdwudbTd4do344yYpgughZEK+Q9gk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab4e:0:b0:dc2:4921:cc0 with SMTP id
 u72-20020a25ab4e000000b00dc249210cc0mr48970ybi.5.1706113519660; Wed, 24 Jan
 2024 08:25:19 -0800 (PST)
Date: Wed, 24 Jan 2024 08:25:18 -0800
In-Reply-To: <20240123002814.1396804-23-keescook@chromium.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240122235208.work.748-kees@kernel.org> <20240123002814.1396804-23-keescook@chromium.org>
Message-ID: <ZbE57k4gCYZb9h0H@google.com>
Subject: Re: [PATCH 23/82] KVM: Refactor intentional wrap-around calculation
From: Sean Christopherson <seanjc@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	kvm@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 22, 2024, Kees Cook wrote:
> In an effort to separate intentional arithmetic wrap-around from
> unexpected wrap-around, we need to refactor places that depend on this
> kind of math. One of the most common code patterns of this is:
> 
> 	VAR + value < VAR
> 
> Notable, this is considered "undefined behavior" for signed and pointer
> types, which the kernel works around by using the -fno-strict-overflow
> option in the build[1] (which used to just be -fwrapv). Regardless, we
> want to get the kernel source to the position where we can meaningfully
> instrument arithmetic wrap-around conditions and catch them when they
> are unexpected, regardless of whether they are signed, unsigned, or
> pointer types.
> 
> Refactor open-coded unsigned wrap-around addition test to use
> check_add_overflow(), retaining the result for later usage (which removes
> the redundant open-coded addition). This paves the way to enabling the
> unsigned wrap-around sanitizer[2] in the future.
> 
> Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
> Link: https://github.com/KSPP/linux/issues/27 [2]
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  virt/kvm/coalesced_mmio.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 1b90acb6e3fe..0a3b706fbf4c 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -25,17 +25,19 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
>  static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
>  				   gpa_t addr, int len)
>  {
> +	gpa_t sum;

s/sum/end?

Also, given that your're fixing a gpa_t, which is a u64, presumably that means
that this code in __kvm_set_memory_region() also needs to be fixed:

	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
		return -EINVAL; 

and for that one I'd really like to avoid an ignored output parameter (KVM
converts the incoming mem->memory_size to pages, so the "sum" is never used
directly).

Would it make sense to add an API that feeds a dummy "sum" value?  I assume UBSAN
won't fire on the usage of the known good value, i.e. using the output parameter
isn't necessary for functional correctness.  Having an API that does just the
check would trim down the size of many of these patches and avoid having to come
up with names for the local variables.  And IMO, the existing code is a wee bit
more intuitive, it'd be nice to give developers the flexibility to choose which
flavor yields the "best" code on a case-by-case basis.

> +
>  	/* is it in a batchable area ?
>  	 * (addr,len) is fully included in
>  	 * (zone->addr, zone->size)
>  	 */
>  	if (len < 0)
>  		return 0;
> -	if (addr + len < addr)
> +	if (check_add_overflow(addr, len, &sum))
>  		return 0;
>  	if (addr < dev->zone.addr)
>  		return 0;
> -	if (addr + len > dev->zone.addr + dev->zone.size)
> +	if (sum > dev->zone.addr + dev->zone.size)
>  		return 0;
>  	return 1;
>  }
> -- 
> 2.34.1
> 

