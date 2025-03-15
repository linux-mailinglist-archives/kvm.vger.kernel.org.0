Return-Path: <kvm+bounces-41145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23552A62522
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 04:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67AD2169A74
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7F519D06A;
	Sat, 15 Mar 2025 03:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1dv00/Uc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB07199EA2
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 03:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742008004; cv=none; b=enXHBlOHYp/e34mxq2NK1b9tgUXJvKdO0QL5qbYmxn5CFMyEW2fWxO0alVTtBeGBS3A2s2ROwhLHxagOoLd3pQmQqLh7c12TqXTbHn4Qhbuvga4k7buRERKxA9fkX8vzVvOvcMylb3OPyEyGh6FzYQd34JZx3hrtWlmaxNpRxtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742008004; c=relaxed/simple;
	bh=DIDA37JL8eeKhWGYjcN5PxZYRrpmJV0kRjJacIWUfhQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ri8tFKuWTKx7vP9js73kOTfmsX4XC93OrmqLMu4cs7+9ut5kPPbXxBjHScOXk9wHG7ynQdNt/3JCiSbi1M+pAalHkva+h7VhHwU9QHlsls5pzLcc7dyV2UtdtY5o6GprPI3v+Amfc2Kv3T3scmsI6OLxzz3FM1GQsNIQLdXjZkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1dv00/Uc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7f9a0b9bso439482a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 20:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742008002; x=1742612802; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hv39/O/PnMVFihpfgZT9SpR99lFAgaV130aLFM9qjm4=;
        b=1dv00/UcK4oER/YLiOMaxFVrKEWirmRovwQWwX6yItUbKsCfoh7wT1wHH0k4wITgBC
         Q6Ad4AnqU8nJ1xIQevzuGzQPCrCNeX2URXUpPBUAhxbcMWgpvmhMGNWL+g0rVIrXDA/Y
         Qc7/pDe+k2f4vAd485redXeir59iSCOD32B/ZIgtrIhn12koiU2VyMqZFD1YD+SUjLy0
         dB6Ua0QKW1juHyHTktBsqcg/ChpXS6LYe0CmX5YG5z1oK66ZE1CIVetlExdo47Y2gU5q
         U7sc03bYLwFU6qjIDpp5Ga4Tu1xJBgoemKAdxVfWx3kG8zjK8892umX+6JJZ/M0yMZUi
         ACqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742008002; x=1742612802;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hv39/O/PnMVFihpfgZT9SpR99lFAgaV130aLFM9qjm4=;
        b=r77OAOVBzZm2EVD8OSoCalepO3z9tZB08oXU9MvpGo8hntjJn7MzQdDD6id1faTcrN
         Hz2R6xbQiQoo9Uhm89XB1ENLxoGi/5U7eJ9uyhFd4jjECaxd8MKrcpR6J9b+MJh8UP8r
         lL6UjRkXshG2/xTAspqOIVEsTlfh6g0/B9goTyTvjFUzO6sUcSbmqG5ivhth5/m4R47j
         TiGUV9foEyKYf67jr3hRMFP/L28kAnLloiKJzW0yU3BfTmpnnhJkadaUHPxk0W0Ybe0z
         Gz2voocvScd1XWeGaFBhIwb+jY/R8Ambkq8hyQWSJ9tb9Pxx8Jow0MAhbnFODwlMY/vM
         dWAg==
X-Forwarded-Encrypted: i=1; AJvYcCW0jZ+V4Yb+Ih5qHFr7cCquzQMqWV+gBcls88o1jN4vH94MnHz40txU/e+apJurzdS3vHY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/ONfO1Q+wVptqd13zYcTrYHRd7hK1Z0+Jyoq2+XGZgFCKZO5w
	cHezxr+7ftmc4wEF9bmOy/kVtJ/WnCM1P/Cli5JM5Cavm9+OvfE/aAqkFMFG6oqB+/4vW7KxGLJ
	O2A==
X-Google-Smtp-Source: AGHT+IHWjt/BJeVYOLv32GnaoqzmTC0s6P3U8PoNtZJT15p0guIAJtE+fq85gGZBlDG7yQuICOSFHSPkotI=
X-Received: from pjbph6.prod.google.com ([2002:a17:90b:3bc6:b0:2fc:11a0:c549])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514e:b0:2fa:157e:c78e
 with SMTP id 98e67ed59e1d1-30151cab344mr6435643a91.7.1742008002348; Fri, 14
 Mar 2025 20:06:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 20:06:27 -0700
In-Reply-To: <20250315030630.2371712-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250315030630.2371712-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315030630.2371712-7-seanjc@google.com>
Subject: [PATCH 6/8] KVM: VMX: Isolate pure loads from atomic XCHG when
 processing PIR
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework KVM's processing of the PIR to use the same algorithm as posted
MSIs, i.e. to do READ(x4) => XCHG(x4) instead of (READ+XCHG)(x4).  Given
KVM's long-standing, sub-optimal use of 32-bit accesses to the PIR, it's
safe to say far more thought and investigation was put into handling the
PIR for posted MSIs, i.e. there's no reason to assume KVM's existing
logic is meaningful, let alone superior.

Matching the processing done by posted MSIs will also allow deduplicating
the code between KVM and posted MSIs.

See the comment for handle_pending_pir() added by commit 1b03d82ba15e
("x86/irq: Install posted MSI notification handler") for details on
why isolating loads from XCHG is desirable.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e4f182ee9340..d7e36faffc72 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -659,6 +659,7 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 {
 	unsigned long pir_vals[NR_PIR_WORDS];
 	u32 *__pir = (void *)pir_vals;
+	bool found_irq = false;
 	u32 i, vec;
 	u32 irr_val, prev_irr_val;
 	int max_updated_irr;
@@ -668,6 +669,14 @@ bool __kvm_apic_update_irr(unsigned long *pir, void *regs, int *max_irr)
 
 	for (i = 0; i < NR_PIR_WORDS; i++) {
 		pir_vals[i] = READ_ONCE(pir[i]);
+		if (pir_vals[i])
+			found_irq = true;
+	}
+
+	if (!found_irq)
+		return false;
+
+	for (i = 0; i < NR_PIR_WORDS; i++) {
 		if (!pir_vals[i])
 			continue;
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


