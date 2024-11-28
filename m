Return-Path: <kvm+bounces-32662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A734C9DB0D9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB271164965
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DA71531E3;
	Thu, 28 Nov 2024 01:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MiKR/3qg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9A014AD3A
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757693; cv=none; b=ML/8+/KSY61YtnZ45IjGfq7gdBCidQJp+BPZO0gtsPWFMZaABqFNb6fUKixDwyAE/vBsZ+i+yRwGeQFSPrZcDwI7mtyzIhB2mRzNXtM01QKv00ZqoXktQdSJLSZBfXS5jaNZ8kdKFVldvuxEZB59ZAE1mYLMbNdgnYVhTPv9Tbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757693; c=relaxed/simple;
	bh=8M4UbYKmp2Gh3Zl4jYlDZTt0BoGbSmn6dRyyLDCWFzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rc1geP1l70Jw1/4C+SDCLXH0mo5Dwq7IddPUqYLlq7xcQKWGmO4I62wJSKD7IvvtP1/0gj7/PB17hWtzfJyuLazeJPdG/A7W7utyunnMoCv6rjESEMWqh3TGMPKa1iu6PiFypMniZ5UVCsJIar3VKj/z64Vi8rfZs/j/rzz9MjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MiKR/3qg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea28fcaad8so380501a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757691; x=1733362491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=En/ebXFE7IQduzFpZQdCqb30HJiQ4lZcee0ytf8Ga+A=;
        b=MiKR/3qgJH4REfUoGPzlFpALpdIbgwl/ret7NLzLlKib7Wljca/iiqV4pPUpSaKbIt
         8DmAkqMeZY1inyBOyyTz40jX/PsobyH/V+dvmNMubEsquz8dzxFd3kF4IBzxs0P/ID2s
         44Rx5abNB77VoZJWa+2AQnlaqYpc2AhAr84Xer5rkhK0zS13bzdEtyh0+KZPE4eTn6NX
         N8obH6AQmv5dWVU6hiP+3rtv78P+2d4oAi+9+6T6GQSUW82LJLAkSBEQiNmjSN9SBMd3
         TpPHbX00NZl9I/GSHKUSyKuBAnOqXo6ZZ8l8QPgYBzoPP0jyRNSABcgcoK6KhcZNWp72
         WWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757691; x=1733362491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=En/ebXFE7IQduzFpZQdCqb30HJiQ4lZcee0ytf8Ga+A=;
        b=kM8T1hDklhULbyJbg5aKfBqdsyXitldglyBnEX/nt3LxIrTLdRsCXshKCYDZ3jhr2i
         MFIqmY0XA+XjJ2SGtBDMzIkjB+iaZa2ZmmYDDy6natOyUynvGPhB9mFhfidrv8kKc+md
         WU8/2qxwLmKL1zxLNxJ1tvp1AVlhQYj1pOkn2DVqQyeax9xWpzJkByZTZsvFKNVfmcVb
         mhFp2LvIng8vZAhO6p3nCNZBp4FLiLMmwLp86cesqvp3tz/K2FU3yJigpY8kkZZ442UQ
         YZGRv1RTPDlx64J8DVsT1HcWmG6aU3KFY6t4u3z51i7gwJ/AhQolhbh/Rb/bf5ILgM6c
         Ji0w==
X-Gm-Message-State: AOJu0YwKsjJ0YgIl8OnaY/p09V7jG6s6t4YCRJbIWpzr08AV2C7Mv9Xt
	gW4Thsw7GlaKmY1BOgjNWjBIc5W+DjihtenXKKap361l1bFyEsrnsRiL6rJrMcXHUfbR2pet+FG
	S3Q==
X-Google-Smtp-Source: AGHT+IEjLtBeoOk0kP8rZqlEKEWA2SUCicvERQLF5yyR4OIJCyQDVxB251zmH/KpQQb4kFZaHqyk1H0JDY0=
X-Received: from pjbpl3.prod.google.com ([2002:a17:90b:2683:b0:2e9:5043:f55b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b87:b0:2ea:8e42:c39
 with SMTP id 98e67ed59e1d1-2ee08eb2a35mr6655972a91.11.1732757691529; Wed, 27
 Nov 2024 17:34:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:38 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-12-seanjc@google.com>
Subject: [PATCH v3 11/57] KVM: x86/pmu: Drop now-redundant refresh() during init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual kvm_pmu_refresh() from kvm_pmu_init() now that
kvm_arch_vcpu_create() performs the refresh via kvm_vcpu_after_set_cpuid().

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 47a46283c866..75e9cfc689f8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -797,7 +797,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	kvm_pmu_call(init)(vcpu);
-	kvm_pmu_refresh(vcpu);
 }
 
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
-- 
2.47.0.338.g60cca15819-goog


