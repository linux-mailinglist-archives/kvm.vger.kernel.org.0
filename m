Return-Path: <kvm+bounces-56377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3336FB3C55D
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D8611735D8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6F72DEA80;
	Fri, 29 Aug 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sxHn+asV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7B32DD61E
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756507618; cv=none; b=bx1Yf0zUUS4nyj4AizX43Vh/GUJBBoN9qyaEsyH05A2FyOY0h5s1t63G18ZVIuPolMyuNEMeTTyoRKzSwbqJyyWlEjgdG7FBcy2DFW9u8nF/rao/xjxrRgXrJIKvnzn2/RMLO8kpVJvRjtfH1k+EKyGDBf0F7ZPry3n+awf8KHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756507618; c=relaxed/simple;
	bh=7iKeOMQFOEEVd5ETUGweiy0cPrlfaMl1uc16FWLXC+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uj1CHCBMlU0oAtR6GSNi797rFg0G/rQkucS6jCf91V5ObaMLLkDUNM/td8XoEznZpjD2h1gpxV+5qQMsfOYeWvcI9u9MwR0LleM0qWnHp7+btNZxCfmDuUWQJZgbKsA7znJG67dwTcNLLyBA4U8lRNtsJRoXKNJBRKcmiYZo9bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sxHn+asV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471a0e5a33so3553171a12.3
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 15:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756507615; x=1757112415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=osO9EdDK8ULTUCgyPclw9xxVN7HnxTjhwUYL0zf8SiE=;
        b=sxHn+asVQ4idbSkIMokYYwHvX5BKlIjEvztTGbGtxWdMJq8Dpm+UN+LyhbvYzDiN3V
         ztqGH568RSndTnBePn/2H89LBuxwGBBLYVm20Bx0OUJ9Gx5ClnA3J0KHD4p9HOjXWPoR
         05bO05UHpZ9lPQnHYlUvc2/nC1BcyqSFeYXmC8rCVRLM3fnrA2QUsTOGR8NOg36MZijs
         U4iGMhwUpBt0h62fy5Dey8vrUM3nicKF2PZ14bzUNliT2i0wY55ri5zYBjUt/ojmDHyH
         PZbN0MCJqVLVD6lKWSD4xvO/EGZ3nB5VaMbMFEO0cKYZZlpZWO44Vtpqn2stNE+34Xbq
         tnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756507615; x=1757112415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=osO9EdDK8ULTUCgyPclw9xxVN7HnxTjhwUYL0zf8SiE=;
        b=weTARsXw16m71J/MW9QSIDDyeVU0wEpjw4wVfPJWS4Euv7D9aWdhLrEIwzNswJP5Y/
         Ie87LziO3uFKX9z5TFdB0B7174rYP9DHVj9syFxRE7K0TzsYuRPAhIEbfFIpEmD1QJ9R
         69gBUucEsJ2iAmD/xXQA0sUo/h6Vm6hpA9lNSgJ53XAqklJvvX5DFchV0b6LmJvdLNeT
         QX+Ju3UpDQZZO9UD+RujMIDQ5fXf0SG91925ja/xpp8vArtnzy23XjLTvzjJVTm7ML8C
         QpAU42x0JzVDEtqBwYZltYBk/5mCQnCweHoBamhdac57iBfL7tdC/xbE7jbd+yI3vUPA
         axog==
X-Forwarded-Encrypted: i=1; AJvYcCXwo/ZN8FJqhsj2C/dbB5YerhbXE0YPWCeKrbLkzGeW3tFHvR47aZ8CYTJhG85qovRgw4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9sF6uzAINQZEQpAMeOkH0vciOc1lY/Ts89OiTwx1khDBSSN4O
	aV6CQ/ailE5xIr0rXlXq8whC/mAHWgMMZ356Rdr/o58gqj0zmhA1PjRNY8C7tLHbtSktm8G4Opu
	sC/FXeQ==
X-Google-Smtp-Source: AGHT+IGkt/EAn947SVVMGSrEgo9yvNr3e4MeFQSbN7ad+YrLR9BbTewsN8HKmFTWK3fVBIpRGYfyACOyUfY=
X-Received: from plbkq13.prod.google.com ([2002:a17:903:284d:b0:246:a8c3:9a07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1448:b0:248:c5d7:1b94
 with SMTP id d9443c01a7336-24944b695e6mr2556105ad.53.1756507615340; Fri, 29
 Aug 2025 15:46:55 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:46:53 -0700
In-Reply-To: <20250829142556.72577-3-aqibaf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829142556.72577-1-aqibaf@amazon.com> <20250829142556.72577-3-aqibaf@amazon.com>
Message-ID: <aLIt3bm0uxSh8I1j@google.com>
Subject: Re: [PATCH 2/9] KVM: selftests: Add __packed attribute fallback
From: Sean Christopherson <seanjc@google.com>
To: Aqib Faruqui <aqibaf@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Aqib Faruqui wrote:
> Kernel UAPI headers use __packed but don't provide the definition in
> userspace builds.
> 
> Add a fallback definition matching the kernel's implementation. This
> follows the same pattern used by BPF and SGX selftests.

Ugh.  No, this needs to be fixed in a central location, not splattered all over
random subsystem selftests.  My first choice would be to copy (and keep synchronize)
all of the include/linux/compiler*.h headers to tools/include/linux/.

If for some reason that's not a viable option, we should yank the __packed and
similar #defines out of tools/include/linux/compiler-gcc.h and place them in
tools/include/linux/compiler.h.  AFAICT, none of them are actually GCC-only.

> Signed-off-by: Aqib Faruqui <aqibaf@amazon.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 23a506d7e..7fae7f5e7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -5,6 +5,10 @@
>  #ifndef SELFTEST_KVM_UTIL_H
>  #define SELFTEST_KVM_UTIL_H
>  
> +#ifndef __packed
> +#define __packed __attribute__((__packed__))
> +#endif
> +
>  #include "test_util.h"
>  
>  #include <linux/compiler.h>
> -- 
> 2.47.3
> 

