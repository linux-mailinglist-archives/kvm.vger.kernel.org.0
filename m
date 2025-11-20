Return-Path: <kvm+bounces-63988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CB9C767FB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E0F7234FC27
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 22:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4387F302CBD;
	Thu, 20 Nov 2025 22:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g238RRGp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653428371
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 22:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763677754; cv=none; b=k9Q0VQNajTF1U1eTOsyOLm94f9Ua/LnL9wYb34DqYTy1mBAwKxCuZpC63yNxfFdd35aRkPOJYhYZvxXb+JwEiw/9DvLEW+9xTq/uPaJeKV5YKJQrdc3zQ/1F1+0uMdjuc5Wt1qO7nbLB/6r9qgEYFP+m9dyQEI3i9QudtXifAhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763677754; c=relaxed/simple;
	bh=u9djnIZP8rkJaMKS6N2nKQ6riCgkdBBe+AZcnUNvHKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SaCN2bX/RzFa0fvA5wJ4FNCbmvBFscyHpYdMts2lPY69CwObUvMy+3kPjtDTTI1b0J5+suP4L0RHmzb+LZQyVHeIgXvIB/pL7Joym93zgPMQMZeY84qmIot6MsEZID5ZpLphbpuPdzmuv0ObWSHomhcXZGI8dwafsPLkwNgL8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g238RRGp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5edecdf94eso2768482a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 14:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763677752; x=1764282552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U1nH3sEHynbJU8mF+4VQIdR6a9jUJRLv0PEESVETGbE=;
        b=g238RRGpglHmZNXjzgUIr12MGNGC4BhdUlfUzNF5ptgaSIwoEfGJIhcseQcbj0izAL
         C8ft+bYv2mRFzdUPTCkSQ1qGcvpdzf7HHnFFTVEhkcTFWPq6a7FzUB7yKK4lIrTcMHsn
         ieCGOrXMtSYnZVMOn1ZY/4KqT72ZjNI34jhKfLIY4rxy+AJbDybAGFsVgsspA6sLHL7P
         3JfC+d0NDrb02pl4rzoDpNVS4Tq7tFJPZx9KX3FWsLwHD03BsEi/cVYAska3aMYbdNLp
         xKSMGCpbtfa4Wh/UUWCTVPYWH2MdIzZaiQO67DwWcSVtYRohVO66Dvi/DdE/gMkdp6xJ
         K/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763677752; x=1764282552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U1nH3sEHynbJU8mF+4VQIdR6a9jUJRLv0PEESVETGbE=;
        b=UK0v7b9zIBxLhGfqIrAptmIW8+JFnZCESeo17TUj/IhXbE+/0Gsn0jmVSDXCqrZ2YY
         0pXPxeIEeUkklPunmLsQfSZS7fNQHzOKnIQj21nI5Dt/G3N9DMPpIjkWE+xh6vhd+Zmk
         xo5MCuufX4T47bgo2UH0ISqFr/woPob8+WszSeenP15axSTOy7bj9rW7qCdR+6iSTaQc
         orC5xGaGJcU9/dTZdQWd9lfLXR65prBMAOE6N8A798OWQdWy7R4cIxfuZYCLYx+0Pg1L
         LPI6wKAo9Ft96lwmj/eTNgfj+eeNUIw6AuCUc7rskpj83wX7eClmsl4Ryotdy3a1wP6J
         iyzA==
X-Forwarded-Encrypted: i=1; AJvYcCV5Es0HuKbfplFrEOJ2+MCanBWd53D6ElB+uNmDGokCuH/1MtFxDaR7TMciQ933a8BadY0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9WD54DTFaPoUPQEwhR+jP+STnvOr4fCMVTWSYKvjE9TJ8sedg
	4DsnEzx+HZX94QIsHNKlircdrGsvmGCjy65AkHVAGr2gszQII5aCegX3t5hBQVvGf7tJZ4YwWOt
	nJ3j57Q==
X-Google-Smtp-Source: AGHT+IHM7B7UQ/zDV3Mpvlvaoxs6EXCH8k0nw52IjX+0zmGH5Z7erln6xW7Q16O5gL1Xy7YiKMtRYIxGYoY=
X-Received: from pftb19.prod.google.com ([2002:a05:6a00:2d3:b0:7b0:bc2e:959b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c2:b0:341:5d9f:8007
 with SMTP id adf61e73a8af0-3614eea27aamr358504637.57.1763677752250; Thu, 20
 Nov 2025 14:29:12 -0800 (PST)
Date: Thu, 20 Nov 2025 14:29:10 -0800
In-Reply-To: <20250903064601.32131-6-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com> <20250903064601.32131-6-dapeng1.mi@linux.intel.com>
Message-ID: <aR-WNu8iFfP1AKBX@google.com>
Subject: Re: [kvm-unit-tests patch v3 5/8] x86/pmu: Relax precise count check
 for emulated instructions tests
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Zide Chen <zide.chen@intel.com>, Das Sandipan <Sandipan.Das@amd.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 03, 2025, Dapeng Mi wrote:
> Relax precise count check for emulated instructions tests on these
> platforms with HW overcount issues.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index c54c0988..6bf6eee3 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -790,7 +790,7 @@ static void check_emulated_instr(void)
>  
>  	// Check that the end count - start count is at least the expected
>  	// number of instructions and branches.
> -	if (this_cpu_has_perf_global_ctrl()) {
> +	if (this_cpu_has_perf_global_ctrl() && !intel_inst_overcount_flags) {

This skips precise checking if _either_ errata is present.  IIUC, we can still do
a precise check for branches retired on Clearwater Forest, but not for instructions
retired.

>  		report(instr_cnt.count - instr_start == KVM_FEP_INSNS,
>  		       "instruction count");
>  		report(brnch_cnt.count - brnch_start == KVM_FEP_BRANCHES,
> -- 
> 2.34.1
> 

