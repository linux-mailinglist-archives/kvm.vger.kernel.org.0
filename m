Return-Path: <kvm+bounces-16376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D9E8B90C2
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD1828361A
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127D31649CD;
	Wed,  1 May 2024 20:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zNsxmEtY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB608147C80
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 20:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714596232; cv=none; b=aa84fm8pERc5SzzOFBhlU5FgWE7A8oQW/0aRXCCgzxh2yLo8ktNenPMApZI5v2NVDz5zCzaGoYBrBW01f/8LZCIF6T/jQ0ZoTW4qiEy0Lkkwu/U3fWCHNL7w7+7J8bNNN852x2E9HI5ffbt0HH2f9kzkB0x+YM0RUDHuHjo6MQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714596232; c=relaxed/simple;
	bh=EWkPfvYUijAMAeefowRafTalqnHwX1yDrtcNupf7HM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tqzAm5IGi+IppbvuNZoo37KlfQ8e2d5NmUlO7LE5GRbZuCf+ucplbB/eIyMw4Mrs183LmndIPzupNAGfG2oq+Jm+Jkm8NHNXPko7Sikl7+UdujB/XNwAGJ/RR9+IFr3PStWOr2/o4KKAPMjDbwIJvSTo6gtOXhNGZe5gspprqVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zNsxmEtY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so14137495276.2
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 13:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714596230; x=1715201030; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wRtOM25SVNugBVgm3ldBixvc/1V5aLfWAERA/zS9+NI=;
        b=zNsxmEtYOFCgTGBa1z15p1uAwePRROXYIvhW3J7TFg041TqymR2mDu5+xxoV1BpciF
         eEzKF8zZr/LiKmJUW7wgqTbn/gZkBXAzjoHn4ZhDhGJxnKsh2iI1MIwwT4p9ZwBdirO0
         Cl6wwiiXyXCMOY5o7aB+6ycFPyF2KztbPTZC6qkIY6mVcj+HKRviSVo4lJwj02y5IrMS
         6zAtqWYziM9yS8Ms24hXB9KDS05QoADjBBrGN8Sbwq6i9LHLIOmS5AklGcG+hhXHIHlN
         Qc71Re76JWbfMtdPtPUjsn2JXejjs2bMgohN1n5nAHT7ZSaBXZ6IMKaXKQcYin897Qg+
         ZZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714596230; x=1715201030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wRtOM25SVNugBVgm3ldBixvc/1V5aLfWAERA/zS9+NI=;
        b=JLtRj1Jsi0JKwOlktpi3NoVtXnkR/WCEehEFWnbupB4PrOCETPLsuHJl7epZBhCtFI
         blRVI+MucjQ0p4KRowN3lDy9Zf54kkCDFb0ms0tk2fFWbgUFHqNXAja+1x6bi4FaDTue
         SiWRg2LZX+UUbXQ+713TMyraBGCk3ebEWbgS4qLYLXpYZbv8yGCoq3mOjIQcYHnO77pI
         WMuuKwEoYTGzW4fDd1oZSjwCEnQXGWEZ1+kyiMjrfUOKHbVDOatUx4eX5CuHRA8sCfx+
         /7eoo+aPXBJVifdYAw68kKkObXr7lvJeI8k7RY7jx+vj8QMet0XF8klmWy/8Nb4pNndK
         IUNg==
X-Forwarded-Encrypted: i=1; AJvYcCXblvstaZHfV4xHcfMefRc404N6qTD+eUVsTl1/nJ1SoSvW3psjStYkjXwBNVIiMVlUncOL83wqE3GJmVTef9pXmqRz
X-Gm-Message-State: AOJu0YxlgLSURWeu9IP3pSvoVFna0WmTfa1a3aj5gxPoY7qi223XfjY/
	Y7k4/B1MnmERGgFcBotL0KFx/nVEu6fslG/+cMS8CYf68F+LoV8GdmI+NSbtG5vBMuduw/OrPnc
	76g==
X-Google-Smtp-Source: AGHT+IHkvvRyR4ZOFfRZbvHxisjAesK2LtdhCRlJFAR3MmJzlIQfXGNakxdxfoHY0k35gPGuOg9STWf3aHI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f0b:b0:de5:2325:72dc with SMTP id
 et11-20020a0569020f0b00b00de5232572dcmr988315ybb.5.1714596230054; Wed, 01 May
 2024 13:43:50 -0700 (PDT)
Date: Wed, 1 May 2024 13:43:48 -0700
In-Reply-To: <20240219074733.122080-14-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-14-weijiang.yang@intel.com>
Message-ID: <ZjKphDaJ5Bq-jTVx@google.com>
Subject: Re: [PATCH v10 13/27] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, dave.hansen@intel.com, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Feb 18, 2024, Yang Weijiang wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9eb5c8dbd4fb..b502d68a2576 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3926,16 +3926,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		}
>  		break;
>  	case MSR_IA32_XSS:
> -		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
> +		/*
> +		 * If KVM reported support of XSS MSR, even guest CPUID doesn't
> +		 * support XSAVES, still allow userspace to set default value(0)
> +		 * to this MSR.
> +		 */
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
> +		    !(msr_info->host_initiated && data == 0))

With my proposed MSR access cleanup[*], I think (hope?) this simply becomes:

		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
			return KVM_MSR_RET_UNSUPPORTED;

with no comment needed as the "host && !data" case is handled in common code.

[*] https://lore.kernel.org/all/20240425181422.3250947-1-seanjc@google.com

