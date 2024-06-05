Return-Path: <kvm+bounces-18968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86DD48FDA55
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEA241C22CBD
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C77517E8E2;
	Wed,  5 Jun 2024 23:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U54ffGPR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7117CA1A
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629580; cv=none; b=LAeX+IhivWME8HgnkpeWfbKaOP9tkvYPM/lxQBcCgjvK+seOL+JjeeaVURPdA/IUBs0uaEalTTPIJ24+fcYvl8Lcdqr5wpeg3/UbsrF1vvuozomLYUMAfMho8j3Rqdjqf53nNKfmFwbB1bW3RO+55wLRj4RovNg1TdwgQqjZedo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629580; c=relaxed/simple;
	bh=qT1Q/A+sxSRLAa1UnNv1bglzkpgKWm1lRFUyoxPlGMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dhB6HI9i7rB35567J6znSW6NNe35ur/W4vR3b12MiPUQ9/PhWfQB9AfUq/sgZXUJC/QBCtY9Al3yTAIxQUTXmlYTvPkZVTacDvIiCoonp9q/8qDdgXCGX/7s8iIYTQJ+218NNo//CQvB/NaBnGsBT6Ig1+bqzciaur7oOuiFZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U54ffGPR; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso204407a12.0
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629579; x=1718234379; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=b5iJECmbxc8XjWct41Unl4ZkHLR82FVwTmxy1PWdoMc=;
        b=U54ffGPRtNhKFuAIeShBUkYV2Qx89/WK6bD8QY1aK2+k2aU4q/Cvgi6Oew1f0seU9j
         /UB316vsgVBH04glf6HT4CEZSxX+1Xyt6cwNUKKfe1cp7uedlYYjjtu4ssQompALnwy0
         Clc7R41IipHdGHVllp2UNPaHYsdi/goIXVdjirUgVFvxp+Y/iLr2fLNPsQ5/+w4/X2od
         0tlkI8ys+kP/Bh7F7QqSzs4L5+ukSje54nR7TnkTzCHb1Q9d4gtlrNfGFTjHEtpz5M0X
         /YHHKiRpKVJ9HOEDLWKSHA456rgYIzBOt31z6P/ZBpuNrnVhhIkxepbqdF24WHfENoTN
         r95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629579; x=1718234379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b5iJECmbxc8XjWct41Unl4ZkHLR82FVwTmxy1PWdoMc=;
        b=QeK2evkk7Dh3jMXQ5kHeeKLbkcVVcaUt0+sorjGsr6c8OCQw1OI/Jinqd/+XY8jZS5
         OlvrAm9g2IBjJiAnQV9kOmpWeO2+EDd4ncwoz5MZm0aDpUzuZq1UXzSlhGbYvA4XU7/Z
         4rtzpSm8vpDXU79ZLv5FKGE+5hNQMM6ikFotO7LJKQ/y7HpCeuSp8smhYvBjcr+tJyV5
         ti6JfCgLMhPP1v2kJgPuGlUW2loFlU1MlQltvkjfK+9jGTFnsxxAblLrL9uKKc2oG3lG
         6F1P7x/fj+6ucBKmShFpscaG0aj00krE9E11qj4ad/IOLVaenyOEdIGQxhPYQEdVJuO3
         1bbw==
X-Forwarded-Encrypted: i=1; AJvYcCXkqBYg4V4j/6sF3cx2ehPdwZhWai5e36tiBAp7YTPj9wDxnk9ujyUTZnz5hgi0yf89t304Tl1d/S+SWW5zD0OVHdfJ
X-Gm-Message-State: AOJu0YyUR3c1lBRGlt9vta91NGrq08il08H6wqhjIl7+OgvV0qjEaC5t
	QlpIpOrwEJX/ReR1YgrbxqtA/6jmdK7ssIVOjC/pXNBe1xd2JYf93K/0p6MEF9PGm8wy1cHc6DB
	sSg==
X-Google-Smtp-Source: AGHT+IHzGCqGspsUE3KdeJLxZDTEgUfeVZbxWBer++QVBA+iCIe2uO3AyPkz7j5TguAF+TXpdDlYwNQkPxA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:6a0:b0:6be:f8bf:6a64 with SMTP id
 41be03b00d2f7-6dd1d952bcbmr3813a12.1.1717629578555; Wed, 05 Jun 2024 16:19:38
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  5 Jun 2024 16:19:17 -0700
In-Reply-To: <20240605231918.2915961-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240605231918.2915961-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240605231918.2915961-10-seanjc@google.com>
Subject: [PATCH v8 09/10] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jim Mattson <jmattson@google.com>, Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
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
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h | 3 +--
 arch/x86/kvm/vmx/vmx.c     | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 400819ccb42c..f7fd4369b821 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -153,7 +153,6 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
 	return revision | ((u64)size << 32) | ((u64)memtype << 50);
 }
 
-#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
 #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
 #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
 #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
@@ -167,7 +166,7 @@ static inline u64 vmx_basic_encode_vmcs_info(u32 revision, u16 size, u8 memtype)
 
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
-	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+	return vmx_misc & GENMASK_ULL(4, 0);
 }
 
 static inline int vmx_misc_cr3_count(u64 vmx_misc)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3141ef8679e2..69865e7a3506 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8536,7 +8536,7 @@ __init int vmx_hardware_setup(void)
 		u64 use_timer_freq = 5000ULL * 1000 * 1000;
 
 		cpu_preemption_timer_multi =
-			vmcs_config.misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
+			vmx_misc_preemption_timer_rate(vmcs_config.misc);
 
 		if (tsc_khz)
 			use_timer_freq = (u64)tsc_khz * 1000;
-- 
2.45.1.467.gbab1589fc0-goog


