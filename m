Return-Path: <kvm+bounces-46176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C4AAB3A2C
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6264862A06
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2911E47CA;
	Mon, 12 May 2025 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0cIyOtr9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F11E32DB
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747059193; cv=none; b=UBYX7/V0lyEVYJ4vg+Y5y+4F5GlURYMiUl8Ak9mj5dUmXc+G/odAfq+sFUpBHfKduAj7wtph88jKdOxiAj+kZ/xiAcBcx2ETosKKNyFeYkdXciP1JDr8Ti9PiBHU1K3Zowz6GtGJbTvKF4UL8KYHot+6d405NoJ9TVgKUR2PyPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747059193; c=relaxed/simple;
	bh=SKnN1ncZSJj/MEbr0gfzXGZNfOFzaykDF0R1s1+8CYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GmJFAk8hjH/Slt1eG7b682VjqX1q8rHblma7/1rJuqjB89B+V0CzYN3QnkqyZQaHnUw6O2lcGvyKh8DOZ5C6+CrVqAGRPjBWSheXYEZGTl95cMCaFR2ACBb4zy7BFtri83mi25/elsirGZhthm60wbHNZYvUPCrYQu6OSH/lXco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0cIyOtr9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a80fe759bso6103698a91.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 07:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747059191; x=1747663991; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E+Bh7c4UsvgqnjXtLXLGDW84tHDJYaJRZGq7z5u1X5E=;
        b=0cIyOtr98HT2Cj8JWQt81Sc9cdhJ9UkWO/ZiuJ/t8K3Gy3jCVJv5zQSI4oeujDYUp1
         97XgxPKzLFR6GD9pJzo7msdo5YdDF5fuglOkKf6fHeObk14AgpyYtXbzBOHxn8jdG64x
         11GXIig6NgYuitexBSsZQvG0W+goRzI0XMy0K6MjzyN2G7gJKpV27T3PST97pcX7Tu0a
         AJKZA2x0bu/RmMzvLWJcdCWALIUtywSCQc76eVeVW/mSz/gPI4fdPuaFvNYC4lTE5RhI
         BNPB73eNGkxff/1jN88Q+lshlCnzPoyBLBMuFzPf8ukIxkv+5w2R+jVI7+ZstDLJKGbt
         LyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747059191; x=1747663991;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+Bh7c4UsvgqnjXtLXLGDW84tHDJYaJRZGq7z5u1X5E=;
        b=jB1/w3aKJC3UwSoF1ZogPj0k7TRr5P7mXyNe8Rea+lVcqJcEf/0on9xwns/lbYDln+
         bpGZZlphApWw0cnZ9D4wsRMsjKjit1XRG8ZWV7xcMBuFPdIciAfWZeir8cFTc18GqsrB
         1BI94CKdLTIQ/LMrLDn7Hrkl7rXZoG3WG+R1gypRLeFi33ZlndYFA+C/RhXV88mwbNnE
         vmFQ2O90rDLf9cZmgekS1YZIIta1RWTBtX+dou+yGyIP96n6YdmdXNdPiFp8t85drnDI
         /d3HnOTSttXgQz3jHKxKk75MZwkXFUJAwFyIGc1iN3O4j+f4FZFrFt8nvdy6rhWsDoCw
         jqGw==
X-Forwarded-Encrypted: i=1; AJvYcCXJcEwreOi8qjZBCGNPJTpE4mic03tnOaJrlkDQmv75Ahd4XHn9MEf60d4OMH27QUlhAXM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6q6LfuJZsgqgJmOWpU9EYYaykTjz0FmMdZQr+lkkcf+RLDasQ
	zctmCf/Ltzrwoc97LgNtrNLlOUlYq6a0Xn489RfJ/fREbDy5tdq+0dIhFpxZggsekavXE/+wF6O
	GQw==
X-Google-Smtp-Source: AGHT+IFQm5taTcpUiAapk9Ux8rFT+sINfQek692ts0xWXhUSaKE8lGTK0QG66OYMwFe+55PbQ2ArW2nFZqY=
X-Received: from pjj12.prod.google.com ([2002:a17:90b:554c:b0:30a:2020:e2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52cf:b0:2ff:52e1:c49f
 with SMTP id 98e67ed59e1d1-30c3d62e58dmr16671203a91.26.1747059191196; Mon, 12
 May 2025 07:13:11 -0700 (PDT)
Date: Mon, 12 May 2025 07:13:08 -0700
In-Reply-To: <20250512085735.564475-4-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250512085735.564475-1-chao.gao@intel.com> <20250512085735.564475-4-chao.gao@intel.com>
Message-ID: <aCIB3nZSUTBXr80O@google.com>
Subject: Re: [PATCH v7 3/6] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, dave.hansen@intel.com, pbonzini@redhat.com, 
	peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com, xin3.li@intel.com, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@google.com>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, May 12, 2025, Chao Gao wrote:
> @@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
>  
>  static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
>  {
> -	/* Initialize sizes and feature masks */
> -	fpstate->size		= fpu_kernel_cfg.default_size;
> +	/*
> +	 * Initialize sizes and feature masks. Supervisor features and
> +	 * sizes may diverge between guest FPUs and host FPUs, whereas
> +	 * user features and sizes are always identical the same.

Pick of of "identical" or "the same" :-)

And maybe explain why supervisor features can diverge, while the kernel ensures
user features are identical?  Ditto for the XFD divergence.  E.g. I think this
would be accurate (though I may be reading too much into user features):

	/*
	 * Supervisor features (and thus sizes) may diverge between guest FPUs
	 * and host FPUs, as some supervisor features are supported for guests
	 * despite not being utilized by the host.  User features and sizes are
	 * always identical, which allows for common guest and userspace ABI.
	 *
	 * For the host, set XFD to the kernel's desired initialization value.
	 * For guests, set XFD to its architectural RESET value.
	 */

> +	 */
> +	if (fpstate->is_guest) {
> +		fpstate->size		= guest_default_cfg.size;
> +		fpstate->xfeatures	= guest_default_cfg.features;
> +	} else {
> +		fpstate->size		= fpu_kernel_cfg.default_size;
> +		fpstate->xfeatures	= fpu_kernel_cfg.default_features;
> +	}
> +
>  	fpstate->user_size	= fpu_user_cfg.default_size;
> -	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
>  	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
>  	fpstate->xfd		= xfd;
>  }
> -- 
> 2.47.1
> 

