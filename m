Return-Path: <kvm+bounces-8239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D6284CE10
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:30:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8CD71F26C09
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E933C7FBC9;
	Wed,  7 Feb 2024 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ga3f9zBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD380041
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707319826; cv=none; b=Vtu17J9sewmrrAYnkyMKaQ+lPv2NlT/ifOO6W3msIxHnSSloWAwW0nOdZPdXiDMmmyz8qRuaLUjREGRt8b2YlkKkY4/xyiqqxptu5dvVggxtIjt1OGUn8ZiFjVWSyFwfy1y4p3b4P3hggzO662achKHwMBnQCN7a6uf0qTpfQMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707319826; c=relaxed/simple;
	bh=29vGtu7yU0AAORwx8Q0xZo25ggpOKaABrK7glygmnuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DO4cJKrGPH2v4hRTF/z2d7nK/A844ybONg6jgcG9NCsx7l+igmP3gTCBzQXIYCbxvU/vB5D+CnurCXlat1+m7d6cTGTpl47SoEksoTKmQFgsArdFqLqHcTUFygPnoB9xX3VzKllT+Hn8nlpVx4K5QI6kBVJSsqFWcrwSx7/Lnjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ga3f9zBW; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6cd10fd4aso1051463276.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707319823; x=1707924623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4HtoAHVB9z2HW85BOTsqebXKmcVqdZooPls6AoWI2E=;
        b=Ga3f9zBW2hPlnwZvgjsBkQzU4lyiKxCyhgTKq605Lgpng9FNijWXDvlLjcryw35ltW
         x5yGIriC2PneH5boIQUmMINSEvMVHDn/MKihCY1FeoOeEAT4wXLLDEjQPMb6GY6CyjAu
         dUCUTvLNqi3UfH58W2K7wJUAhQk1M74LxrXLVEN2L+McljLkqg5mapSh0XG5yi9bjI4S
         /hw8BFprxcI/LIfPCngWR56mqS6MzYSmDwYpVMkZzgW1p1kdeOgDdSw9wih2ZEPhX5Q2
         G9v03Az3e9CgKgSeuB0S9aV3H9/RT5mSCryEfoOKe5KfULfP4PAMvxJoMOr747Yyd7K+
         i2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707319823; x=1707924623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4HtoAHVB9z2HW85BOTsqebXKmcVqdZooPls6AoWI2E=;
        b=E7iHcEOQBxHrhghVNG0XgvJpuxEjUHxjKshSMBGPvscr25YEpYW2XGmCT8ui7z101L
         2e6uK9S2ChkoxDbBNnBIfK14V6nq7v4vxwcngEK/XssivCtEpQaxAcqs17PY0euXhmQJ
         FbAWz5mhUelsKvyzuStI4n0eAnyyk76f8dpmvkAD65yjoXNLebs1vouzYARpR4ZtGLuJ
         b5IuzrQblFGWRPoDso7stA99pB5lMuuWDexl913JXhIC5hQ6tyNiQdemaQkFQBlkESBa
         CPiAtSP84G25pu0V2Z25t0YGYwaMAcM3lIFHzbjOdpaG5ePOih0G3lCcwmaw5XHplKHx
         ZrYg==
X-Gm-Message-State: AOJu0YwiF5Hh5kmMKVprk99Nqk00Alu948e5dd+RIkcRJGqz7Y9uzYAT
	B2jamxmUOb9IM1D3T94Jw6y8JL2x2iAw68wjevmIjW30hVVtBJIJw9ohyZsPHzPMkRqaCGYdmtF
	YyQ==
X-Google-Smtp-Source: AGHT+IHm0UAeTY0jrRYDjxsi6/W2lf2idjMOZ/39omY/MC1KZboNEYOdi+7r5MhNrDC85iynVdmlrecExE4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2302:b0:dc6:ebd4:cca2 with SMTP id
 do2-20020a056902230200b00dc6ebd4cca2mr168524ybb.11.1707319823546; Wed, 07 Feb
 2024 07:30:23 -0800 (PST)
Date: Wed, 7 Feb 2024 07:30:22 -0800
In-Reply-To: <20231109210325.3806151-3-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-3-amoorthy@google.com>
Message-ID: <ZcOiDopfqnPc69rF@google.com>
Subject: Re: [PATCH v6 02/14] KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, oliver.upton@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

Same "Documentation" issue.  And the purpose of the change isn't to add docstrings,
the purpose is to clarify the goofy/strange parameters:

  KVM: Add comment to clarify param usage for __kvm{read,_write}_guest_page()

On Thu, Nov 09, 2023, Anish Moorthy wrote:
> The (gfn, data, offset, len) order of parameters is a little strange
> since "offset" applies to "gfn" rather than to "data". Add docstrings to

s/docstrings/function comments/.  This change has value and impact even if the
kernel suddenly stops generating documentation from code.

> make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 687374138cfd..f521b6fd808f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3328,6 +3328,7 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)
>  {
> @@ -3429,6 +3430,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
> +/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
>  static int __kvm_write_guest_page(struct kvm *kvm,
>  				  struct kvm_memory_slot *memslot, gfn_t gfn,
>  			          const void *data, int offset, int len)
> -- 
> 2.42.0.869.gea05f2083d-goog
> 

