Return-Path: <kvm+bounces-40034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6018DA4E10D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B1F31898FEF
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704E0209F30;
	Tue,  4 Mar 2025 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkrBuqT8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FCA207A1C
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741098574; cv=none; b=IG6fE44InFZmLfwaknAW+KEqV1yplz7KyGW6lbuTbnqUmQ6utvf5oEqW8FrRvlEbseiNFi6e3g31m0trPHlzzFv08ga3p8PvmgbiQJs1AHtAqWFH8KKenHRJaf/i6G8XiN49PVUrT53DP+vCJ05yVYizMofWc4xYH5KKt0sXphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741098574; c=relaxed/simple;
	bh=a/YFflfb2EK9kw3c7YnjtpLWS8pYQnzbqqHoyHCeB4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EyMMbh8lmdgEfOmquEAZcHvZHsgcuB/E8up3wnOSCqVXqCdxhEfBJcfJNNLhsCS+g/5vRrt39VCuLHyoBjhk/+JT8YnBpY7jEZXDna24pgwvuWPUlkntGO9iQTOwvqOGmS2fZiuHIWs0qPe4vWcT+NGKEkHfGoDC/qBVurbY1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mkrBuqT8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8c697ec3so11234986a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 06:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741098572; x=1741703372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2p2XL8JhJpNhWPdG9BUq0LcAt9yo+jCFLOZu7nZEpGw=;
        b=mkrBuqT8X+JE2e6QMGPrh1EWzauym93G3HrcXZPpn9C9qS3gZqxEGIAJtSzsRIT/fd
         QiU6SkhLIx7F9qrwqVdejwnsGUQ7OERsscyBzqN5S1h918jSLk+5OrSoljmtrooHUAFm
         FeX0KodSLCWxGrC0bibpZe4pYA0pFNah/MuWcTEJVZb342MLhQkXkkss9cbSXNnL1Gyx
         qjt4eNloOhFSPJxMPMKFu2Ms+aTZT+OpYeO34DEqKehHGYdV62f9uXD8PTbwB6fKp49w
         r6lTMvArXTCRoyHfijwnf8BmpFnJHloj8+ZZHlNXBV8om2vyh0ybV5Dw4k0JOfdE4/8w
         1tBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741098572; x=1741703372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2p2XL8JhJpNhWPdG9BUq0LcAt9yo+jCFLOZu7nZEpGw=;
        b=EShE1cv8/DeS41SB9SlRRFsOChfp1bw+6Cg82CdIqRJUiIvU+h2C45be51nTiUtNll
         WjVyY4OPahwqHTfMK9GFKkrUsLcb1NQvCoFjIpJ4IAZCpT35HYRBHn3S43P2Vh1MyLpd
         +mUmk9D2Z1oOFLK3Dkeil82oRyYLwC8wddiM02jgZSCaNJRvWIYRFb9RlShY/XDFHTla
         +HlBSQu+tp+zdtwqFubuj79S7EimSTFRbziIlMQBpZaCu6LyCasvNvgVOrn7pj+Yx1+b
         P9X0y9UQS2vilxNkesURAkWwm1TbO/g2FJtEQ7dOJva3SqYWYtSZJeMEjF8z+EAWPZ5/
         VvOg==
X-Forwarded-Encrypted: i=1; AJvYcCW+vkkiYNU0jYQ6XQ0u16/zkr9+7kxFUGVHa62B99Jb0z47EnCbDGP1a1uIDYv/M4lZJ+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsS/qLjNfV9GNLG4CKxU9YBWx5B5zDW9cpbRmM9lseaL7ehubZ
	cGG+89V1RLQNFetWSDgMTxS98vHz6YoFxQF2vIQnzjbNRS1JPhNqJ+Ii1XyjIZnlD16QqvhYap5
	rIA==
X-Google-Smtp-Source: AGHT+IEjI0ckrU1ub2lDtOJk5zmvFETMpwAw2L6eR8/wUHBbWfWiwRNMKq/fEHxIwjK/fKFweLvCYujAIu8=
X-Received: from pjbpm13.prod.google.com ([2002:a17:90b:3c4d:b0:2ef:9b30:69d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d47:b0:2fa:22a2:26a3
 with SMTP id 98e67ed59e1d1-2ff33b9d896mr5369979a91.6.1741098572362; Tue, 04
 Mar 2025 06:29:32 -0800 (PST)
Date: Tue, 4 Mar 2025 06:29:30 -0800
In-Reply-To: <20250304082314.472202-3-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304082314.472202-1-xiaoyao.li@intel.com> <20250304082314.472202-3-xiaoyao.li@intel.com>
Message-ID: <Z8cOSq1shwIRm3wG@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Explicitly set eax and ebx to 0 when
 X86_FEATURE_PERFMON_V2 cannot be exposed to guest
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Xiaoyao Li wrote:
> It wrongly exposes the host ebx value of leaf 0x80000022 to userspace
> when it's supposed to return 0.
> 
> Fixes: 94cdeebd8211 ("KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022")
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f9a9175e3fe8..5e4d4934c0d3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1767,7 +1767,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  
>  		entry->ecx = entry->edx = 0;
>  		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
> -			entry->eax = entry->ebx;

Ugh, that typo came from me:

https://lore.kernel.org/all/Y1sIHXX3HEJEXJm+@google.com

> +			entry->eax = entry->ebx = 0;
>  			break;
>  		}
>  
> -- 
> 2.34.1
> 

