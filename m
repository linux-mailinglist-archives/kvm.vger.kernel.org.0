Return-Path: <kvm+bounces-51982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDE0AFEED2
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 18:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFA675A7C5D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE3D212B3D;
	Wed,  9 Jul 2025 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X90rVWuh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A61DFE1
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752078338; cv=none; b=KsfSv07EKxwGu6XtoByEzFjcj+w0OCXvacTsYL3YvK/yP4SFDpDxzpu9suzKdzaOEJyCPXy4XYNL+3gz6/1qVspIIPYW6WJsivy4F/n+fUT2Y77EqT5Wx50AtDhZlu/6yoO5ltewh1/z6HJsmzXRSO2x/8AFD7RDB3vIKA5zGWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752078338; c=relaxed/simple;
	bh=BOrv+U+xtMQ/yrFmwpbqzeQEfpXdcCgV4Vn5vhcpghQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=nQrHeTwtgfvyyIbvLE1U7snFO6GSj/SNMfvydgFd4GkBM8xu+fLw77wCefcF4LWVrp0s0n3FRqYfHgsy2ylDp051AUwl3yEc10W3Gp+FwcfnIzysdgr0265ge9pLxJ/n3i/PmJj80jSBtKatxyv84Hf6rBzkds1SiCvRcRgS4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X90rVWuh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-236725af87fso668355ad.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 09:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752078337; x=1752683137; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ceX1V+pEYtx5k0rbcDGOFPKwI1VckK/A3ZcmuXkjgsE=;
        b=X90rVWuh8t2tQRWhPsxlFuCcppmdY7EDGwfPhJpKL42ILq/LrJoKEP7PpiXhMiTx27
         pBz+qq9tyG0EvDuHw/0b2qxZfYxF9jdoTpH7qJjbVB9GZoi2qXbwoO2nF3UvlkaOJ5qH
         wPvXrLPibQcOr7u25Q5PNZ2bVJoZ/Aa7A4ZBzYZakz8c5/pBEAQ2E8G9NaWNOHrGizSp
         E85xXmDzU488sJ6lqwmWCgvjAqel0HFpZ4s3nj5kNz2Gbm+LK95tIRNqTFTiM25Iqflz
         h+9G92simgH53ji/pO6K8+FH62IvvcNVcVYxDIvCMO5gJvFfdiG1DOmP+eL0qK63bfpk
         VQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752078337; x=1752683137;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ceX1V+pEYtx5k0rbcDGOFPKwI1VckK/A3ZcmuXkjgsE=;
        b=cP+7URX53qtOSGzb4bJw+QnLNtdUplcZPpoMa41CH3xtfKXsAbv3F//vZrE7GAkWR5
         Cq/7ono9v6Spfd0sskN/sYENqblvtsstv4cqwcJWfIeHLYfImYwEf98uw1HJ4ikob7kR
         JWp5zK/GGWktIpOft7GvRL3lp5ZZGLZViqMEe9jcNij1eWRJjiW3WlMIqzATyt0djz5W
         6Ac4GQ8JEFs6+g/Ims9+bc4iSiSEYFrmMtqH48+zFtjdBMRDwloafYaBgufPuzytkjgl
         6SQijtAHoN6R98FCX3goF2FfAgkVG5k+LgkrHx+mpu80wpTfkbqYhPtQh5JgRV4SwvzF
         vRyg==
X-Forwarded-Encrypted: i=1; AJvYcCXZiJHsxIgfvxvQ6iGgm6K6NnbZldUJLYSqb+fZ2H4A4VRMBfMHrlt4ZuR51/xOy3EWi+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8AkNFfUfNBb+9e71HgcjeTIlr/gf9EvxaubKC+F72gH35n6YM
	OAIGNipEpPQpdqaeOEDHVsEDs3PP3Swd7GeSQivAe9+YSrzR4Gcs0PKOLGj0DRJUehJvwjaprdh
	7IoDpdg==
X-Google-Smtp-Source: AGHT+IH+kN8wldNATK8t+RrFuOEfWrywXkePo1LcH5lJU83pzCFc9eEYj+xjtCKl7JjT7Dl07ty9+fMYhsA=
X-Received: from pjyr7.prod.google.com ([2002:a17:90a:e187:b0:314:2a3f:89c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:190d:b0:234:8a16:d62b
 with SMTP id d9443c01a7336-23ddb1a4d34mr50987395ad.12.1752078336689; Wed, 09
 Jul 2025 09:25:36 -0700 (PDT)
Date: Wed, 9 Jul 2025 09:25:35 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
Message-ID: <aG6X__K8MvVYORkr@google.com>
Subject: Re: [PATCH v3 0/8] x86, KVM: Optimize SEV cache flushing
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Kevin Loughlin <kevinloughlin@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Kai Huang <kai.huang@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	Zheyun Shen <szy0127@sjtu.edu.cn>, Mingwei Zhang <mizhang@google.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 22, 2025, Sean Christopherson wrote:
> This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
> flushing series[2].  The combined goal is to use WBNOINVD instead of WBINVD
> when doing cached maintenance to prevent data corruption due to C-bit aliasing,
> and to reduce the number of cache invalidations by only performing flushes on
> CPUs that have entered the relevant VM since the last cache flush.
> 
> All of the non-KVM patches are frontloaded and based on v6.15-rc7, so that
> they can go through the tip tree (in a stable branch, please :-) ).

Tip tree folks, any feedback/thoughts on this series (patches 1-4 in particular)?
It'd be nice to get this into 6.17, and I'd really like land it by 6.18 at the
latest.

> Kevin Loughlin (2):
>   x86, lib: Add WBNOINVD helper functions
>   KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency
> 
> Sean Christopherson (3):
>   drm/gpu: Remove dead checks on wbinvd_on_all_cpus()'s return value
>   x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
>   KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent
> 
> Zheyun Shen (3):
>   x86, lib: Add wbinvd and wbnoinvd helpers to target multiple CPUs
>   KVM: SVM: Remove wbinvd in sev_vm_destroy()
>   KVM: SVM: Flush cache only on CPUs running SEV guest
> 
>  arch/x86/include/asm/smp.h           | 23 +++++++-
>  arch/x86/include/asm/special_insns.h | 32 ++++++++++-
>  arch/x86/kvm/svm/sev.c               | 85 +++++++++++++++++++---------
>  arch/x86/kvm/svm/svm.h               |  1 +
>  arch/x86/kvm/x86.c                   | 11 +---
>  arch/x86/lib/cache-smp.c             | 26 ++++++++-
>  drivers/gpu/drm/drm_cache.c          |  9 +--
>  7 files changed, 140 insertions(+), 47 deletions(-)
> 
> 
> base-commit: a5806cd506af5a7c19bcd596e4708b5c464bfd21
> -- 
> 2.49.0.1151.ga128411c76-goog
> 

