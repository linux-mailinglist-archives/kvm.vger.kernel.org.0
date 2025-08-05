Return-Path: <kvm+bounces-54055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AFAFB1BB59
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 833AB169291
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7316B293C4F;
	Tue,  5 Aug 2025 20:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="29FNzCVo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B1B239072
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425352; cv=none; b=E0VAZtQxNC41WjKh5Z33eEuIHks+bFGr2UghF7pWfomGTbb9CJVggMd31hqN5JG9HoIfaGuuewJjPTSCQfxpIKhEfZEUXk6mInZyul+n7His6dWtUJvWQiNMercmkYi0HScgJst4kekP34/D/OFRg96wKEHlGrNjQD4NhOM3f8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425352; c=relaxed/simple;
	bh=m4cvXDVqGW0AbHw4k3Vzfovsu939uVbAU2XVf0YMJis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dm9yepTz+Vsus4G7nAIW/uFUYdVQG/QzqZ+LAqCx2rTjLTh9xnU1PK68/PrAXYSuDi38JF+bCOcnSWXUdm+yirjp8JkDcA5a60QNJ/iOMWPbNwIJV4fHouv47T8BSlqCHsX6cOCOykDuE6VuTXLHHL/ikEC948U+ljZoHMN1Wik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=29FNzCVo; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bc9259f63so5121225b3a.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 13:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754425350; x=1755030150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wjR/uxIdvcDRTpBouU2Bht36ZMEEqH5DZxI9XQvsEgw=;
        b=29FNzCVoA3UTpIt0UXOjFra+kcVX/goUGRP7qMVOeFpJjJR+Rn+N1IR8WC44Td+HoA
         PMI+YxTW0wfOv6vYKx9Iyx1l9fg24x4xk2+zsc44Qa+OkCtAk7z9a04QWZGDVqpkvDg9
         s/5yrkFH2kZtXGWRXaS/Z6qJjV6lnE7n7VgzsbC/1/l+wA+9YS7RIT0//9xF580ST9n1
         84JkqDQSLpbvuWIsV4QB9GYlmZAoCvXem+oGlvUwL6yamuuN8fbwxjWSkb1d1NOSU1Ie
         0IlqGPP4DpE13L+g7JQjoK5tN2WBkkwMuoZQx0lRB82bqVJbqRrUMPTqZgR2VFFJukaO
         qVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754425350; x=1755030150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wjR/uxIdvcDRTpBouU2Bht36ZMEEqH5DZxI9XQvsEgw=;
        b=rrMDtWSTUtSXyJTc0ufdnks0mAaWJJ39zEI1LbcJrxLGqAO8h0rry/CnfEp6Z1TOI/
         fr0tTuoapdC43knHRqQgtdft36OPIS0WJfuwdQrjqncnHRGQ12BOOqN0gDup7MnfDQqh
         XjAk93aFlo4HCojtKj4kYdyR8DEs+fFMIYWYNjFEWwlYzyNauRqtJ6GBcV39s3d6V3e/
         SyEy+zyZi15aWXOh2JSFDa17Z3Y3T1r/KDbGwGFXJxQOvAbGhrBdvSaJ+uIosoGzNBLe
         /H2MEDfHWlkpipkL5+P9qTnGZMzhuTKJ2IaEoTYETHM8gAxTnUkGuAfMRugCZPqOCX+7
         s3vA==
X-Gm-Message-State: AOJu0YyuSVCcLfUU9pnpMxrwIAUYn6O7GxUSmwW+I2oOYSAKBlXRkdsq
	LLNottw8hz4+KhEjmBLVU/+ZJ8e9R0X8J2ALRB2spwwjInnsX8tOvSY1gyt8kLIqWE22Mbnli/2
	qq2t2hw==
X-Google-Smtp-Source: AGHT+IFCEgZsJmKgL2NHifE5gOQctZUA/8fGKPI5Bt4+O9PcW1nCN4b728D10NGn7NJpY+CAkpFhrL7KBbw=
X-Received: from pfnp22.prod.google.com ([2002:aa7:8616:0:b0:76b:269d:d476])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2590:b0:240:265f:4eb0
 with SMTP id adf61e73a8af0-24031412f65mr574781637.4.1754425350570; Tue, 05
 Aug 2025 13:22:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 13:22:19 -0700
In-Reply-To: <20250805202224.1475590-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805202224.1475590-2-seanjc@google.com>
Subject: [PATCH v3 1/6] x86/cpufeatures: Add a CPU feature bit for MSR
 immediate form instructions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin@zytor.com>

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

Use a scattered CPU feature bit for MSR immediate form instructions.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..75b43bbe2a6d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -491,6 +491,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_MSR_IMM		(21*32+14) /* MSR immediate form instructions */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..5fe19bbe538e 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -27,6 +27,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,		CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,			CPUID_ECX,  3, 0x00000006, 0 },
 	{ X86_FEATURE_INTEL_PPIN,		CPUID_EBX,  0, 0x00000007, 1 },
+	{ X86_FEATURE_MSR_IMM,			CPUID_ECX,  5, 0x00000007, 1 },
 	{ X86_FEATURE_APX,			CPUID_EDX, 21, 0x00000007, 1 },
 	{ X86_FEATURE_RRSBA_CTRL,		CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_BHI_CTRL,			CPUID_EDX,  4, 0x00000007, 2 },
-- 
2.50.1.565.gc32cd1483b-goog


