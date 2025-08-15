Return-Path: <kvm+bounces-54741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5550B273E3
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60A83B631EE
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772C7223301;
	Fri, 15 Aug 2025 00:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knv0Q+Ou"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C321D3CA
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217577; cv=none; b=TVdJ1qSgHVaF3fheKgdz4FBzNx7QCsu2Zqs0zP/GycCCqAAcd7h2pB06BMgBkVhtsJ70fZdiMqS4uG2NABSprESUhwozBNIejIQ02b3sfNMeFArBAUae9Lu79yMyXhLQZi74NHVMsnwcwv5irgOIGYkuMfbVbJZ2+khKAPdOkOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217577; c=relaxed/simple;
	bh=/IiKb2UN6NIrbOOa08VQXgMrzpDFlocGasn1XlZEIGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCpoVblpJ+q5d5N1U9v4ZbCcb1dk/uqAF9YbbqiGYB2ulDm32up5KWk3H+l1n54laC4L5YwBtQSadDSIddMXdmBZn2HFHaEO4sA//6AxQuI7um3APgl5zBr1mPG0rPgfdOOr0FeTwRXUVKI/1h5EvAGFbrqdR0m6JP53oqM6mKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knv0Q+Ou; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47175064beso1041201a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217574; x=1755822374; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zWqf+ODUewWqtQUwrkc1cIbhsaF3K9K+427e32UUWjo=;
        b=knv0Q+OurA2Cx/CDIokpEESNN+Nfg0FCsySgkNE6cNiPQeRcZihiRjL6nJ48MnI55p
         cekl/GciviF9+ld39okyOvl0YOosE2yPCKqhKG51khZbjrU0muc3P5PmIJzRIhpY7z3J
         YX3jJ9if+WnIu6Ubg2eQrP5KSXJ3CEFiCX8OAQiBTzJrbe0nUIpc1r/oW+GQCXwEdZ6w
         +AEnJfEHfAffdO/9vtfqgAbQJbB1+I8sAkSd7eetezWE/or2waWRmJZ3F52XtcgyVzG9
         0r29a3xPzAD7N4H0N3V5HkPlWGXkBTbnsLDtBrWx7FwrqVOgxNVuoalmp2WL52D3rQik
         5WIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217574; x=1755822374;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zWqf+ODUewWqtQUwrkc1cIbhsaF3K9K+427e32UUWjo=;
        b=fKQJlrUunNEUQO24AexfVFodAJCcONpCafOR13wGKXshiCU3aaz8B6JJBMX+wS4PjQ
         CuPkt64SYMnyvG4SgsWQoKEjisuKYNxBey/xoMRXaM6imk+5o2mETTLKCRSNiDn+dMVS
         Ff839oS3N/wrFYTJ+RoaDCVyToQ/UnlxGps90cWFgHQ/VNA9DKhWRFtVOt5DOC+Oz1m0
         gFIBKH6INk4PpRnAvHmUC8ULN5CDBX9/br4ZBgoiKyHHnitlwzTETRM5UBliFyL5FNV+
         fQDDp01On7hUvPRf5s7tWlmlk4Ik8rjraUKl1FCLRK1NQVYlPAS0Rm2Mm7RfSfrK7Iw5
         kHRw==
X-Gm-Message-State: AOJu0YyE/3w8szO5SwVZsaJTqzisyNgCKYrTQ8IlcC1v5e08TvZPYct1
	rNgH6TgSPxCIEhywIijhPwwwYUy16fQrAGn8VRaD13IXTUK/ZBArY8Zta0FHHPrVvUE19nPIUAn
	HMpMSjg==
X-Google-Smtp-Source: AGHT+IHabHEkDiu3aHpCxhpBkfZt77DDXCcXMkgWTbHMtwvNhlVRz3tRq+jdWNuZp9kMhjiWHZ4O6g7zjRQ=
X-Received: from pjbsm2.prod.google.com ([2002:a17:90b:2e42:b0:31e:c61e:663b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84b:b0:240:5523:6658
 with SMTP id d9443c01a7336-2446d89d22cmr2336095ad.29.1755217574277; Thu, 14
 Aug 2025 17:26:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:36 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-17-seanjc@google.com>
Subject: [PATCH 6.6.y 16/20] KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG
 if RTM is supported
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
index 033855457581..723e48b57bd0 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -380,6 +380,7 @@
 #define DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI	(1UL << 12)
 #define DEBUGCTLMSR_FREEZE_IN_SMM_BIT	14
 #define DEBUGCTLMSR_FREEZE_IN_SMM	(1UL << DEBUGCTLMSR_FREEZE_IN_SMM_BIT)
+#define DEBUGCTLMSR_RTM_DEBUG		BIT(15)
 
 #define MSR_PEBS_FRONTEND		0x000003f7
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08ca218ee858..359c3b7f52a1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2161,6 +2161,10 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
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


