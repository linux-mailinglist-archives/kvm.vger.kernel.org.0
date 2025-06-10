Return-Path: <kvm+bounces-48873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B4BAD4352
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E4093A4AF6
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5B8264F99;
	Tue, 10 Jun 2025 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YqpbO4+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AEC265CDD
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585272; cv=none; b=ak92d6B+xj9o53l1jxG1MjwShkqmH/nDPlzhxOr6TusiDBoSoUlPq5ZpjLnVCR/aqI3z3FVDBAMSRxmZYnCfi0GhvoV3hVheE9v+Bc2j/GmDlZTs5MfniJYwZbCMPsJYA/3RvYkKhMFLgOD4sdhA/l1lG7n1kzL5uiiVVuvrrq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585272; c=relaxed/simple;
	bh=uI8d7x1fFYhlPW5x75AVyP2Zrt8TE6FVZbQT3U3teAc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cW0jjfRIvJSdPtqxmjxpG455I0r+2nvWUNtu5n8fkvoDAaVL/GVx7g4494L33WzVoYayD1Ox+0Q0MAtTQ7sjhgSpaO0FKrPcf5SbcKA/NIsj23lHongiscMJE0oLEUAorFPAGhJSSFz+wk7r5KvrD5R1sx+r8Vc9AcTcl2hLKvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YqpbO4+p; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b090c7c2c6aso3345128a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585270; x=1750190070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=21sAxQls0dCADfTCLkbPivTreC2NYJtRPY+zh9VwZOE=;
        b=YqpbO4+p42e/0QnKpWdquJh2Lr1onFG/CmX3hje4NgXgCn2YdAhSKa+NGTg4BcTYiZ
         lAuphsVJG16cUt45xdMcyuFZcqvFqNtbG297Unx7bKA+ztY53VjwZ+cQWbfTT0AVN4uE
         RqNc7onAY+1OgzDrcIqWfJFS+2VlfaxoKkW0Wf9Ua416k0/4gFagjf64YDZAUy44iCN9
         5iq0eTQqWd8bpTIQAcra9UZNuHPGt3cHoKpZlx9B/lLMzcxJfuUHBEExXm5ovYh8mGJe
         HsRnkm+EFnIe62Qs+LqrZhylFCYAfWhwAV6ukS0GkWgon6yzUgNPcJKNCziumRZBaXBR
         DeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585270; x=1750190070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21sAxQls0dCADfTCLkbPivTreC2NYJtRPY+zh9VwZOE=;
        b=rpEI8xOm7XxYtCvjYkPIplf1EdzeNFj4IBcAVEsyUkjIAAQNaxwPiAYEsYtyGqm1RR
         vTRyUxrpWiP3m4vaRo5fandRKdlVGI36WpcQaaWlqNRj59U3sz9V8zqsTNn6TvGKEjmp
         /zo66HkBfLjaNB/MkjWuVIFW7cgCZkwu4yVJNxQnoZx+Zbf12ji7koH5lMK/izV+9+Gq
         oKAFML7rMXHfOZDXzjgy7JI92p6kjvSoJjJlGKWotyziY5pmxTrt1rP/2k9h9ZdKSGL0
         8i9BypFZSiqqXIlTEasRcHNhJHtfvxn0DAlWcDlTHvjUFm1g10tN01SXoCc7qz79iVvl
         iOtA==
X-Gm-Message-State: AOJu0YwX2k4ESIH4kI8sZyPrsOM0sJABiNYspyu7i99XvjLlJEpj/SMe
	7BqvP99g/wpOp0+U8Kcu4NGXikdY6FbtOKb8yx2k30hWJM50dNepD5Nm7QEn53RE+abUYjVzDlz
	/X2SjKA==
X-Google-Smtp-Source: AGHT+IHYp/LmBlzrglZqkFtprQSJLhbqAN2sBdKe26L7JWrRzD2Di7xsieJRa6Z3KicXuH5QqGqymMaNPNE=
X-Received: from pjbsc9.prod.google.com ([2002:a17:90b:5109:b0:311:b3fb:9f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d646:b0:311:abba:53c9
 with SMTP id 98e67ed59e1d1-313b1ea4349mr20106a91.7.1749585270548; Tue, 10 Jun
 2025 12:54:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:08 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 07/14] x86/pmu: Mark Intel architectural
 event available iff X <= CPUID.0xA.EAX[31:24]
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Mask the set of available architectural events based on the bit vector
length to avoid marking reserved/undefined events as available.  Per the
SDM:

  EAX Bits 31-24: Length of EBX bit vector to enumerate architectural
                  performance monitoring events. Architectural event x is
                  supported if EBX[x]=0 && EAX[31:24]>x.

Suggested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 3 ++-
 x86/pmu.c     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index d37c874c..92707698 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -21,7 +21,8 @@ void pmu_init(void)
 		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
 
 		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
-		pmu.arch_event_available = ~cpuid_10.b;
+		pmu.arch_event_available = ~cpuid_10.b &
+					   (BIT(pmu.arch_event_mask_length) - 1);
 
 		if (this_cpu_has(X86_FEATURE_PDCM))
 			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
diff --git a/x86/pmu.c b/x86/pmu.c
index e79122ed..3987311c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -993,6 +993,7 @@ int main(int ac, char **av)
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu.gp_counter_width);
 	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
+	printf("Arch Events (mask):  0x%x\n", pmu.arch_event_available);
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


