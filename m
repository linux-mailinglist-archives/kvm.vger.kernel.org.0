Return-Path: <kvm+bounces-59751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 301F1BCB394
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E721519E237B
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E72B28AAF9;
	Thu,  9 Oct 2025 23:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HiYzbhue"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D56824DCFD
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760053597; cv=none; b=AHejmxu9l2y2snZ1qOBbQcXgCKTbw25UJk/2xr2hxBKPaZEozzjpPd8DypdUkT04oAhOKHA5yLBySJFlr64mfgcmgJTz5gvR4r7ltfo8GahneTXkvMMuKpFOvalrJaQ1p7kBtL+NQdvxJ+9oNWceqSE0Uidu5tBKTWnDlrQ1b7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760053597; c=relaxed/simple;
	bh=26IoyXAer2dHxzUzTVbU51K2F6sl48ENyhzJEUv0PJU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=phSXJmW2+hxWa9myTEHd9mAHX5SyFsgGByhMsGk9Mafjx+iw3eaM0MULj1aGnN7ncHwIKlp5p6uUxzPK6GJ2meQoii681JaIwbKhzdJPPalzTWT9I8bdBQ2O7aFe7a9kkB3jooPk1Us6bALh7A7Wi2mDHPB8fik1ZwOwyT1tbUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HiYzbhue; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-782063922ceso1920556b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 16:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760053595; x=1760658395; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yvjZ7uGmx6MwK/XmH3gV8y+JgMzQDUlkkpBBmzwAG+g=;
        b=HiYzbhueYYljxXZLHUOAaoPLoW7wDVV5mHydGGAwfk8Zctfg6tM+UXR8XuZnzAS+kl
         X8eDOSCOEpZHFYgoRrZE7KMM9GFBBqKwByOpImSJ/qu1eIva9E2OzMEyDHvEOxzXFaGx
         pgNp5xmob84gzxBUVeiAokV5TdZpW0uOqdYsWhUYdMcSJbWMnm3rykb11Fw0na5KCmav
         rvdHIRy5ZaJ2N/vkr6922trloJAk/1NjLaxFP/au6uFibf6kB1ubMCPqmdgOP7cCUnP2
         +ynFOTIdstYx7U5DiGQlkja+UvVAcS8jCYdD0SGpZqubxKsiwHPV9rbAOYuMR3xOicbl
         eUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760053595; x=1760658395;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yvjZ7uGmx6MwK/XmH3gV8y+JgMzQDUlkkpBBmzwAG+g=;
        b=J77E/pWYRyMlPsstz9Kgj0+33SzveA6l7VeU6A4EIMoA5ypPF/YhYT2S+/9KDG6zP2
         OyRFTg2ld19bK/HYClw0kiQ4MtSmC9HJ9v0NAUINJjc+MP8m+eLvrwwbvVqtcrer6giJ
         Lza/vlTaMveRCwm2ij7N1bMvzx7nAtiyDPUnwSmUitliIggR8DAFL6B4rb865UAmCtqi
         W0Yw/U0DZVh2gQj7XTOEOQvXYcmsquhioEKLhJqHDHep6nJLmxgwEqqd7AFceIHHx8D4
         nMMnAm25kHPySmA8cKsrVnLmocEcP7o7Yg47U9yfhcVZ00Y6Ijn7LKqWFpMQKiV/J2Ei
         AFrw==
X-Forwarded-Encrypted: i=1; AJvYcCVLCD381QB+QGbKgCmERsVYLm7qc8hBPbS78PUFK3OE4uMQmkVnO/8Oo6pIpoYTrA1Mxq4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyeqKp459pjiwaW4U+2YEN9kTRoYWwObO2qbcMBOPT4QU6T5XL
	cI5r1roPJtmPxpT3V7JFInPIJIWe7D7f+UGJE2cl/7S/VJavJHoHOIsjRXORLjZxLhSQyPUfBDK
	JCpdOXNoXv0xen7oKv/DaNdXdTQ==
X-Google-Smtp-Source: AGHT+IE2eqIFsInCSpdgZguo3jkVyMJCh5am8HhRQlz8jeVv7Cbcv88hlF8n2DFG0dxbbLyXQa2s777rYld/g6ua2w==
X-Received: from pfsy56.prod.google.com ([2002:a05:6a00:3b8:b0:772:630e:8fd4])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:180a:b0:774:1f59:89de with SMTP id d2e1a72fcca58-79385703333mr9921633b3a.11.1760053595262;
 Thu, 09 Oct 2025 16:46:35 -0700 (PDT)
Date: Thu, 09 Oct 2025 16:46:33 -0700
In-Reply-To: <20251007222733.349460-1-seanjc@google.com> (message from Sean
 Christopherson on Tue,  7 Oct 2025 15:27:33 -0700)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqza51zhc4m.fsf@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> Drop the local "int err" that's buried in the middle guest_memfd's user
> fault handler to avoid the potential for variable shadowing, e.g. if an
> "err" variable were also declared at function scope.
>

Is the takeaway here that the variable name "err", if used, should be
defined at function scope?

IOW, would this code have been okay if any other variable name were
used, like if err_folio were used instead of err?

> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

> ---
>  virt/kvm/guest_memfd.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 94bafd6c558c..abbec01d7a3a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -330,12 +330,10 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  
>  	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>  	if (IS_ERR(folio)) {
> -		int err = PTR_ERR(folio);
> -
> -		if (err == -EAGAIN)
> +		if (PTR_ERR(folio) == -EAGAIN)
>  			return VM_FAULT_RETRY;
>  
> -		return vmf_error(err);
> +		return vmf_error(PTR_ERR(folio));
>  	}
>  
>  	if (WARN_ON_ONCE(folio_test_large(folio))) {
>
> base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac

