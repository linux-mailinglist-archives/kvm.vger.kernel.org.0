Return-Path: <kvm+bounces-57245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED51FB520E3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E876E480D52
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AB42D7384;
	Wed, 10 Sep 2025 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qcRnjS9M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1BF2D46B5
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757532137; cv=none; b=Ghc7L3iUVy+Sw/XaikiUX9i6xfE17dFtjzu1vGdI9ZHN0p+bds3vAK4Ger7PUepsAAuBHqnvC8X3rLFOr79Fi/K0vewE9mcNsLqptP5o963JWYtpUl7rtXzM1BUimOfWVgvDFqEmCWhJ4yzOWH7JWHAL0LN3kbLA+PN3VQ0D3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757532137; c=relaxed/simple;
	bh=WwPKx+F4nZMQQvbxZ+yQ8ep3mrkTsl/KPllHb3TKExM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SZ/OMfb6COHdJkKHcF1h84Miq0eqG9jv3yGvH2Z2sHpmoEnOeDObkCDGrh6DifI8p0uUdqBfJvVd1Rz+RsJZsRZTQR6UOUilX0TgLV4+vlDstQQY86w6tyqarMBpFhnNmSzbkuVO/hV8ZHrdwWy5QIig+xFM0rf/gW8iRljUQ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qcRnjS9M; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-774659e841eso2015066b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 12:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757532134; x=1758136934; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F4vLrrazh5OqKjK4hFSlEDxoFcTPUg28TR1gqdyw1Q0=;
        b=qcRnjS9MJqZEViulTai0j6vXBzSS0GrLbHGqMizQNiHxQSwrind1D0bCdB39sOEpgq
         k70KqIOer3dUHPDM5gXP0XG90WyxaNMZ+yMMLw2C1D9kdCzEsvZ7YGQk7TMmS76t7K9h
         72MfqjO1K3Nf4FIFcQPuKn8xvj/mEtNTzzb9FYm1nw4anMUMa9ldctsi5Sbw0fTrvdap
         550h6kff1tTOeXBcrU3mg4xZq99rfjYe8U0ANHSBVjYU6mDdseVL+JEz+oY/FtuGCGXe
         WTzmrpHUjcxAWPhY2ZNbdNTLFDAlwI44PCUPqYRdCb2N1aKIEEOcwnPfe/j50myvDwsa
         cLWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757532134; x=1758136934;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F4vLrrazh5OqKjK4hFSlEDxoFcTPUg28TR1gqdyw1Q0=;
        b=SxQpR0NbTYsQYTEmmoG9X0JtlmihnAHXdL28qHeiTQVcD5aNKlCDUinzkiUQZirSak
         OVbh1yNJK9pxvKHpbhWRkGxUAkKAQwT7PUh4Y11C91NX36yAWCLT314eUj/Rnsu9M/Zx
         VGcWjAYDi8YU+5mVpFNCM5FufPyERfYVAVzA8lNTx35LRsaA2M8hVmdL7+z6qpEQZ3UC
         oNL/azGkJS5uNRWCMI/Yxh8Of/xceyf4TWM16bDxy1ts3VeXHjibSeP9r2/cBEZcX/US
         1I3yx8fVV3j3tUyJD9HrTwncewzyJD+qPDCURevP98VHqaMU9hVi1VdNbJTujbnk1t3Z
         pBkQ==
X-Gm-Message-State: AOJu0Yw6xA8W29sQpijqq7bZrCYqwjHj52p/NFmsxBwctEF3TTqxGa46
	d2KZFIdUxJ90Pz8Ffb0wYH+Lf2GyERMihU2Q/6YbD+WxRwwDskEU1EqergsPHg0rwBB4Ms6a14w
	x9b9Lag==
X-Google-Smtp-Source: AGHT+IGnPIfSXQ9s+kXYoHDkwl7tzKe5qzsmRWKh5g9jlXevcrlzn/w3fY5nOgrSlDdLhh33sh8KTyaeSf4=
X-Received: from pgcy10.prod.google.com ([2002:a63:7d0a:0:b0:b4c:7355:9e4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f8f:b0:247:f6ab:69cc
 with SMTP id adf61e73a8af0-2534054a415mr21214365637.26.1757532134403; Wed, 10
 Sep 2025 12:22:14 -0700 (PDT)
Date: Wed, 10 Sep 2025 12:22:12 -0700
In-Reply-To: <e9014e7dfd7f7c040c5d0eefb1f6c20a3c35d9e5.1755897933.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755897933.git.thomas.lendacky@amd.com> <e9014e7dfd7f7c040c5d0eefb1f6c20a3c35d9e5.1755897933.git.thomas.lendacky@amd.com>
Message-ID: <aMHP5EO-ucJGdHXz@google.com>
Subject: Re: [RFC PATCH 3/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 22, 2025, Tom Lendacky wrote:
> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
>  bool sev_is_snp_ciphertext_hiding_supported(void);
> +u64 sev_get_snp_policy_bits(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
>  
>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
>  
> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }

I don't think you need a stub (the ciphertext hiding one should have been omitted
too).  arch/x86/kvm/svm/sev.c depends on CONFIG_KVM_AMD_SEV=y, which in turn
depends on CRYPTO_DEV_SP_PSP=y, so nothing will ever actually need the stub.  I
bet the same holds true for the majority of these stubs.

