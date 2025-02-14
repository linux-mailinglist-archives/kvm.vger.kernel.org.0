Return-Path: <kvm+bounces-38195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 637EEA36736
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7789A171DFD
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8EE1D95A3;
	Fri, 14 Feb 2025 21:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENF1ol3o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD317E
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 21:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567218; cv=none; b=XAUP02QtHOVZ2Avnmhrjyieqswf4gqYsrLMjeQBRu7CBF+lEHB1qSVxQlvqMTm14AB6WVnngFKGaEJILpwmNCkIJFApyWW03ETMzi+HbwTM8aFfMIPuApmsp4XzNQCc12xK+ACkjKhd4ZDlSZT6WJIqObEwbgNa2KXaBsqUdFR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567218; c=relaxed/simple;
	bh=eBLGG68Or9yjsiP4CLRRkY0iPolcI0GPak3U8DpQKvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XRNiDJyKhEhgO8UpvxyIp0z+iWoNzMjiGtqd88+8uk3pmtVsP+epMzqIL2pX+XZaEJRrFPnXMsXVmFNzGRHsh71G33Xj1+xqJ8Y2Dm1+wom6QYuac7x3euq0+70Q6M3/kdtWGg6HfSMI0LYMHEGBrkGE/fOHOmb7FggRoJqwVMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENF1ol3o; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220e62c4fc2so30136085ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739567216; x=1740172016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=492QiewuxoOpSiREuMz57X44BumOAwjBNWQNhBoGViE=;
        b=ENF1ol3oribNwBxJB4/X330Pe8byV4ulcijx0Zyvti6xddv6OdVDJpPmwUuew79ITz
         91DZJldWNvVBBCG+sMpWD8qc9DZJrgUmDEwWuwB1rYbmxsTRIJUTp+0IR1jhuql5RqrT
         74h55dxmheQmGZy02eqQcgCB0759xYYanJC7bPBa226SNVVmog4fNX9TE03gWf5yARDK
         XeV4FHcJ5nuhUut2z5x1lghMxmxGMnbpHueOBpzks1PUB9Gl0uTZai0rwJxnbtbH6OmX
         9TH3wCOfyv7Xz75PQ5TuLGNW3qsX4Xp8Z0bJDY8yxUP1/ysUeHIp+MiFHJ9oTR3qx4lY
         PUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739567216; x=1740172016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=492QiewuxoOpSiREuMz57X44BumOAwjBNWQNhBoGViE=;
        b=VoivRNgtFRB4u9/NHQGH3XFIU7qWT6PI5pDFQB0A8Ij/QvrAJtB0pNNow3F9q0mPOO
         Y28UUErWOJGeRCAeta3cy4R0Bz4c59yckyrmZMf/VOL4PLKkyIZc6Sk4Vd/oa2lUBh7N
         Npu6EIo0OhGc6oBUharHqvZf6Ha1FY8UllYWPSGYM+HPQ3BDaedIjaVOPc64Zl7BnKY5
         rNkpHTRIVL8ARVxI9hXNyZXFfAiADb6rdOMCiJdifoFzqoUc/LURNCDUuXgL/Rg4O1iR
         bWphFQ0eEuE3cSafdncstLR5624tp10IhvtmirsDli6IHSTG3zgVOek+RZiGzr+6eYpj
         FYtg==
X-Forwarded-Encrypted: i=1; AJvYcCVds61a1zcPW47D4JKisnUgmXXJSImNg9rFubEty1auyFvh1+Ppfsf7Td4eu/25WIkIAqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YweWwz4LbQ3mJvFe80KfaYrt7N1a+GDLr1tsza6Zjn2bd6O47QA
	aMZLfmMsc2hr8HNjXgzNDmee6tG4wxgSi8Ax5/2iA35iCgXL2fSQOb2WJZ5K0jlR9WkeRBTuPeh
	A4A==
X-Google-Smtp-Source: AGHT+IHTxKpz9YQBehDW94ffNCBW6dSQ66S1eZW769DC4cxPKMriG0SAxEjF//npoSq9l3P1wuWzfkFJfBM=
X-Received: from pjbnb2.prod.google.com ([2002:a17:90b:35c2:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2b07:b0:21c:1140:136c
 with SMTP id d9443c01a7336-22103ef2e81mr12121105ad.3.1739567216039; Fri, 14
 Feb 2025 13:06:56 -0800 (PST)
Date: Fri, 14 Feb 2025 13:06:54 -0800
In-Reply-To: <20240914101728.33148-6-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com> <20240914101728.33148-6-dapeng1.mi@linux.intel.com>
Message-ID: <Z6-wbu7KFqFDLTLH@google.com>
Subject: Re: [kvm-unit-tests patch v6 05/18] x86: pmu: Enlarge cnt[] length to
 48 in check_counters_many()
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 14, 2024, Dapeng Mi wrote:
> Considering there are already 8 GP counters and 4 fixed counters on
> latest Intel processors, like Sapphire Rapids. The original cnt[] array
> length 10 is definitely not enough to cover all supported PMU counters on
> these new processors even through currently KVM only supports 3 fixed
> counters at most. This would cause out of bound memory access and may trigger
> false alarm on PMU counter validation
> 
> It's probably more and more GP and fixed counters are introduced in the
> future and then directly extends the cnt[] array length to 48 once and
> for all. Base on the layout of IA32_PERF_GLOBAL_CTRL and
> IA32_PERF_GLOBAL_STATUS, 48 looks enough in near feature.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index a0268db8..b4de2680 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -255,7 +255,7 @@ static void check_fixed_counters(void)
>  
>  static void check_counters_many(void)
>  {
> -	pmu_counter_t cnt[10];
> +	pmu_counter_t cnt[48];

ARGH.  Since the *entire* purpose of increasing the size is to guard against
buffer overflow, add an assert that the loop doesn't overflow.

>  	int i, n;
>  
>  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -- 
> 2.40.1
> 

