Return-Path: <kvm+bounces-37406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8932BA29C6C
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACD3C7A2986
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 22:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22CE215F58;
	Wed,  5 Feb 2025 22:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KdC14nmM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88061FFC4B
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 22:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738793603; cv=none; b=fZGCoLBxFUyvle/8zdMKAgePXX7Cxi12Aa9vz1lTTcdgV3d0cD0DW5pPdF4FjIcS96jqGYSA5ZpCqfOUdP8LFliz3eVtQZIvpEBsvTg6/igPh15yPVTLqsKf5UJi4a0kdBIw3VB3kh5dtsNFkvotHXQM1VU+gebaUiKDmbHU+xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738793603; c=relaxed/simple;
	bh=q7L8AfCkoiRYk6XD0LRMspwgS/hS3OT1u+Pk97yLlzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YgEb+1IkUgZqqKIh8Xu+ViNSfrkxQ6w0i5j7V/t4wVwlAdHQrFmvlzfMN7acEu3LW/3vuj209L+Rqf7A2leztewH/3KQWrGSsAUpBChaiOlfo/NIzCReECkR6QG7MxUDK+6VFEcJrK1onDvzvBwtSYrHsG4/4B92d4Q2DUKRUH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KdC14nmM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f9cf77911eso453196a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 14:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738793601; x=1739398401; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dVdg6lU59UKb0/TD/si7cIrxJXLN5wRx2BqZWD8EZQ0=;
        b=KdC14nmMVwfSBjR+yaLuVK4//ybFGHhfowGnSubwhaRVq+Phf9iYCvXV3cEw8JOUu8
         q/TslWSyz30zYdNjIR/R2o7CxnYETMzWe+Qx0evCFggiHpaE/ToMUYcQaBrrsmownRNg
         UR5fYmHymAU4LRLQHfQoZVbuINc2yCCAb33VRTxy8QGXQV7ZkCdM1mIGGhgupQfHCtyT
         J94mhXtuQsccs/ei5wS71Hd2WjOIHOcYLfFAKKNgIdy53nPViXInD0M8rcy5j+8wesl2
         iDUZEJ6jCvf5zVMgKu5b7s+c1CtAko6l3WLR6io6qodmmQpBjqhjUofnHNIPq09Npm28
         +M7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738793601; x=1739398401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dVdg6lU59UKb0/TD/si7cIrxJXLN5wRx2BqZWD8EZQ0=;
        b=Hz+oOd6N0CRM1qpuK5e+LKH9lJmP1PWwU6YlR4cV2qEDAdUIj0PImaYPNgqjNvolhY
         pt8vlGLXANXpSrnGhfRtOjKD4IeIqKUe7cFahA0lxqNFs/W+VT/Q3oTwdNm0254S6NzY
         PKr7x6KFCqgTKVqGm97qjr950xljP08DJp2oXwMOvRj8HTbipT6RGXXKpno1RTYWyJ6R
         6LmLxp0Zet/mXz20qAs8KEp5dOgzn4afLlu4XmSaNLF5mANEgff2tGuMnEHwX6qZapR7
         Zm70XmclF1vBlAJTCFx9wVONlFGjCmQZNPKwU0NjzQ7iWOskcFwNqa3PjZDETkEeBUkH
         i0Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVcsGIko6o6sPwiVg7F1QOErhPnz0pdxIB7lnRY+2v14ZBxr9rX9UTPnzq3ezMyPHlRUCM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu/a/yg1nBTjTBljG7FyAfXGU5jilYAC3UVvaO/+zt4WKwVJQJ
	eJshbZfzm0OoSfLubBU+A8SL0w9TqdEI5C+iJbs/twChE6jrpm6gOpoiN/jimiZrl8Bz0Q8A/5i
	dPw==
X-Google-Smtp-Source: AGHT+IEzBJXIxqY+Exe441l1aJjABmGJq/OUJpRwmw6f4+fEJCNQJEg3bbzDZBjxuP/ajdzYJPIfpzBr2jA=
X-Received: from pjbsi5.prod.google.com ([2002:a17:90b:5285:b0:2ea:4a74:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e707:b0:2f9:9c3a:ed3
 with SMTP id 98e67ed59e1d1-2f9ffb7ba78mr1633015a91.16.1738793601045; Wed, 05
 Feb 2025 14:13:21 -0800 (PST)
Date: Wed, 5 Feb 2025 14:13:19 -0800
In-Reply-To: <20250201021718.699411-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com> <20250201021718.699411-2-seanjc@google.com>
Message-ID: <Z6Pif2CFE0o1eOnj@google.com>
Subject: Re: [PATCH 01/16] x86/tsc: Add a standalone helpers for getting TSC
 info from CPUID.0x15
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com, 
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 31, 2025, Sean Christopherson wrote:
> +static inline int cpuid_get_tsc_freq(unsigned int *tsc_khz,
> +				     unsigned int *crystal_khz)
> +{
> +	unsigned int denominator, numerator;
> +
> +	if (cpuid_get_tsc_info(tsc_khz, &denominator, &numerator))

As pointed out by Dan, this is broken.  It should be crystal_khz, not tsc_khz.
I fixed the bug in my test build but clobbered it before posting.

> +		return -ENOENT;
> +
> +	if (!*crystal_khz)
> +		return -ENOENT;
> +
> +	*tsc_khz = *crystal_khz * numerator / denominator;
> +	return 0;
> +}

