Return-Path: <kvm+bounces-11434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1015876E94
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:30:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4788C1F22A03
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACCB3BB4F;
	Sat,  9 Mar 2024 01:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QcAq61iA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C7338FA6
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947668; cv=none; b=bMa7r/tZUWz+Ki5af8MfLfqsP0+c6xAba8HnyFVzqi1yxq8Lp8HL90S6/YPXYrOVRDsC0FgpYUH9PPAGTNy512WKHdMg2QjNvfCTvElEvnEYwDX2qHiTgw1U6tq9Co/BOCJnW+wEs9eTKf0zYU7Ij/+HzdflBFzki1PVi6Q6n2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947668; c=relaxed/simple;
	bh=vq2K+5LHK83RpKnCGkTT6ZhKAFoSxkbWDGsV0tgPWLw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BSGqMrSBfYfEACv6LIBygDhJjTbwi4WE6mhRLYHa8VEAEfTZ76OwMrynIw+d9I3+2ZnwS+jSg0aqLnYH6f4bCSWgG5b42QAadA08NuIRs40OiUryxu7thIlv7JSak20an+1vLctjEu6/EEFdvEiLSiEcvkiNXrF0evWg/G4YMvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QcAq61iA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e672f1880fso915562b3a.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947666; x=1710552466; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yWRHC3fowN32chz4V0nbkaLENfnprXFQBmDkxVMLWD0=;
        b=QcAq61iAMFmUZPo2SP05UsgzMOsOSL+fOoY/MQPpU9GBNB/eEN0YmaA90GG4Xm44HK
         r75Ws8AiCyaMJqBxWFjh46tfR4cdAmSj66p3QMsl1WxI3eL1FtPjJFgqExlY/FrHxFFs
         6XKUgLlQBKzsfiMTuAFiC7GLpxarcdpMBu7lo5rYnFQQ66jCNwfU8WJzfUPSqv3n+K+q
         JaGocGEFKa30mAQhaP1OF9q7MZ4mfVYWwYl37fDLkboQRFsiA45iaBbD5V2ptNaEZ/ZG
         zfvinBA7ZwyiGCos0fpLyczajx3m07cxmpMpQewrmhn8cm/22JebFRSfirJBgy40FOkb
         sx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947666; x=1710552466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWRHC3fowN32chz4V0nbkaLENfnprXFQBmDkxVMLWD0=;
        b=EDTxw9lKjZtlDLazAe/ek6smjwUIxx49J8FzlYn7F14ElHjqN3EyVQeYTqLQywtliy
         uZ9XXb5s6psXzk2t5rXQdzCUZN/qP044D1CA38T1Hkd/lTv4Netx6bMp8ze4HvGwt3Cv
         +TnFiexmdL6f+nb33DHPZxxLkquwPV9NrM5pIda6luX1LR4ko9+xfYZDDLSBZ/YPqkpE
         TRyLleWRyqdDM96EMgW5ypwRDe9cJjyvgLe3OwBQNRfyIzQO9plDBuEhoFHNLrE3OJ6R
         aBzHjWl447eWDUAGgF/v8BrG36bndylqHWXBage98q//KRkpdWMsUzsZ7MCyodWmiKcT
         56ig==
X-Forwarded-Encrypted: i=1; AJvYcCWQJdb3dcLcns8g/m+GWvIwqOM95ytBT9bvDx+kSrSKWx+lr0XfjlwmrkbcxABxgzn34BnYT6G3lqADTNqrWQP6j3mc
X-Gm-Message-State: AOJu0YwkeMafMsQo6Z6PLvfjS29kxBPE+shgf/9uiUkBzNyTCrSf4V8e
	sPtw9a3PbJDkwbkHj4WLicP85x3IvoK4G61j17oHgH1/USTqa9YFSAK7HBhtmjmj5BR7CvO4281
	PeA==
X-Google-Smtp-Source: AGHT+IFQJluLhAiF5eQqXz2PPCgiEuZQssxJpXXlfeXxfqSOPWP/vG50rZro2Xy/23igZND4o1xXOR4e3G8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9289:b0:6e5:8053:af92 with SMTP id
 jw9-20020a056a00928900b006e58053af92mr63785pfb.4.1709947666389; Fri, 08 Mar
 2024 17:27:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:24 -0800
In-Reply-To: <20240309012725.1409949-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-9-seanjc@google.com>
Subject: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask in
 its accessor
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
that the function looks like all the helpers that grab values from
VMX_BASIC and VMX_MISC MSR values.

No functional change intended.

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h | 3 +--
 arch/x86/kvm/vmx/vmx.c     | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 6ff179b11235..90ed559076d7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -148,7 +148,6 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
 }
 
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
 #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
 #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
 #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
@@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
 
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
-	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+	return vmx_misc & GENMASK_ULL(4, 0);
 }
 
 static inline int vmx_misc_cr3_count(u64 vmx_misc)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e312c48f542f..4fcfa1a213fa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8613,7 +8613,7 @@ static __init int hardware_setup(void)
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
 		cpu_preemption_timer_multi =
-			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmx_misc_preemption_timer_rate(vmcs_config.misc);
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.44.0.278.ge034bb2e1d-goog


