Return-Path: <kvm+bounces-54749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D4D8B27462
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD55B3BF84E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D0385260;
	Fri, 15 Aug 2025 00:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vqPGhqsz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76A8145B3F
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219456; cv=none; b=eQvw2vgZy0obQLdr/2/IT6mLk6jmicErqADZKDRjpQI6hP0IhWzGOfVw6qh2pePc4Cvyb/XEJw8iOHHgYwaKIECPiVTIFjssZfBXnxhGtC0Ckuz9mRDRHPaRre6SDIEknWFaHTvTpNnIjaGCewCbGaUrbTdc/Tq35ulPvWATD0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219456; c=relaxed/simple;
	bh=TXJ2X85YFocPqa+0zEr21K2R3q6PmeINWu5+zoL0tCI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TuR7+5xfpGneF4Ll721Sa0iTWdu4Ztzo3UIjyPQzlTJwoSbnKkIAf3xD5iRPO3npsxQ7FmS5gShx9dmQuCru9aZKV1dPxcK1/wzo15+GVQi2E6scmXHmmE9/bccgFCgmn8qztZ6tFMkHhJeufBEBljRej95+OrHQRMT0IP2EARc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vqPGhqsz; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e614c60so1317730b3a.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755219454; x=1755824254; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IsZpbkhX5MqnYq0KyZ5GB4Mk6gnPhn07/9u1mPEC7EI=;
        b=vqPGhqszToW6NtcggnZokyjuSJQca/JdYn4DMsyRQvwZDJbZ4KUgOa4uNHh9/FAEyE
         WZFTkSUxT8s8nv17L54bHm2bIiv1BZvLKNTvPYHu20LudehH1iGFjXXc/s0SO3j6x1nn
         C/fWTy6sLkDK5VYWHTA8ybkgSczES8EitdLx5tS6jklDDVQOCPg8xq5goKVbIkLfoGuI
         HHZ4/Wz2dNjM3nsu02+jj+Hckuyxyutet5GxwN77YKsBNDaI0wltNqKwBUiUJxn1mqB5
         8+4sqCV3azDNllRHgdNXAix8gY9ZOLeP60tKZiiIkPZ/Uk8/Tn9Hg874TdLxl0zcogwF
         9nNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755219454; x=1755824254;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IsZpbkhX5MqnYq0KyZ5GB4Mk6gnPhn07/9u1mPEC7EI=;
        b=aY2pDjZdFQBUH2EsnsaIGIdqGLU6uPaQtcbs4ZAO62D7wV2YXr3vsy304rIEOHdtri
         EMNQiaZ7yJmyJAagXOtUY27dnxWtEGiJ25+FwyBqZkmXgs0FWB5L7LwScz3pyRWqHgRS
         zCzMEEC29bG7gSy7V4GTsU8iiUvQ374hNnuuZwPrrsnQAy5qdQKM/S2MAFDj9XqvxWkh
         WnB/KiB/qOUP9JqGe/b8Wtj4W5sh9CThcSA3qf1IiuZT+Gm5ay02c0EfINvDA4gv/xqm
         1nQ00IHoelfE6UlkE+zfjUcxYI0W08Yz1OlF0WIpDOc8hYtZiS76Kt/5YeWWlllXrHiQ
         Y6DA==
X-Gm-Message-State: AOJu0YxqE7ONWpDrVVlzvR2t9qOG8ez1UlFK5M6LE9aKpdSbMqHypb2e
	eHFo0ses+EOYVfgP/DHaqUwBZ2LK7KWY7RhzS7IaEYanHOmRRxE9fL6aRrG4SU3AdhivB+5EwNG
	gqOvg8Q==
X-Google-Smtp-Source: AGHT+IH+or5YDIHHNrmIsvXJ1577coTnf6xAqbqWIbdl/OyYWkW8UyDl0dwXFEHdZ0O1Uralx54l0daxwQY=
X-Received: from pgbee14.prod.google.com ([2002:a05:6a02:458e:b0:b42:c74:a4c8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:42a3:b0:206:a9bd:a3a3
 with SMTP id adf61e73a8af0-240d2fbf950mr418739637.24.1755219454202; Thu, 14
 Aug 2025 17:57:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:57:21 -0700
In-Reply-To: <20250815005725.2386187-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815005725.2386187-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815005725.2386187-4-seanjc@google.com>
Subject: [PATCH 6.12.y 3/7] KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if
 RTM is supported
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 17ec2f965344ee3fd6620bef7ef68792f4ac3af0 ]

Let the guest set DEBUGCTL.RTM_DEBUG if RTM is supported according to the
guest CPUID model, as debug support is supposed to be available if RTM is
supported, and there are no known downsides to letting the guest debug RTM
aborts.

Note, there are no known bug reports related to RTM_DEBUG, the primary
motivation is to reduce the probability of breaking existing guests when a
future change adds a missing consistency check on vmcs12.GUEST_DEBUGCTL
(KVM currently lets L2 run with whatever hardware supports; whoops).

Note #2, KVM already emulates DR6.RTM, and doesn't restrict access to
DR7.RTM.

Fixes: 83c529151ab0 ("KVM: x86: expose Intel cpu new features (HLE, RTM) to guest")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-5-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kvm/vmx/vmx.c           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7ebe76f69417..2b6e3127ef4e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -417,6 +417,7 @@
 #define DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI	(1UL << 12)
 #define DEBUGCTLMSR_FREEZE_IN_SMM_BIT	14
 #define DEBUGCTLMSR_FREEZE_IN_SMM	(1UL << DEBUGCTLMSR_FREEZE_IN_SMM_BIT)
+#define DEBUGCTLMSR_RTM_DEBUG		BIT(15)
 
 #define MSR_PEBS_FRONTEND		0x000003f7
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b9c7940feac6..529a10bba056 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2185,6 +2185,10 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
+	if (boot_cpu_has(X86_FEATURE_RTM) &&
+	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_RTM)))
+		debugctl |= DEBUGCTLMSR_RTM_DEBUG;
+
 	return debugctl;
 }
 
-- 
2.51.0.rc1.163.g2494970778-goog


