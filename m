Return-Path: <kvm+bounces-32676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2819DB0F8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:41:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4C21B22A2E
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB951A9B41;
	Thu, 28 Nov 2024 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tipgPEUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2370319D88F
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757718; cv=none; b=U3saef2hSDtWPcPAJlA/4sYA1r/HYo2GaiD1Qm3D44KcmU0hqdgPtBBQSTt2+s767nC7xQR2IBgdtkZW28aLK+U1HOK9J/FmbohTzv41RX6W0zTjZn/c25d4rw4IuGFP1WxlvwtebwzQs7TX631gFNaDuidxcVWpcRf2+R5dSm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757718; c=relaxed/simple;
	bh=Wq5LM6NqLa3bJHEUV5BTVIFsmH63BQ1SZbZwRoHeBQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LHw2XfYiIBwKfWyoYrarfZYH2NnkQo9OKzkJOznAl+bXjoRhANTHM201VUP3aY+vBua6f4Y95fpKOm1u8xuvQgBdyTu2zNPQOxJ0rO9lL35JCbzUlruTGkp5qJ0iclP7wO0b0S9EAZug8h9uxxKH2zAHTkbMSaSVQ+/wqCR6/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tipgPEUP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea33ae82efso362258a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757715; x=1733362515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4bBB0NQOkuxY/fMRl1/Z0GmdB3PHk1lvBMv7RHKM/5o=;
        b=tipgPEUPv4NrBSsd4AiteBFW7P/aWwAQiT29+mxuNuPntDECpNmfPud5HhL7Wrq02U
         IOsvzbNVO/S17IpniAieMucecdTM3o+mLIL50KxTXwFG+LdyqEkq2PqJTNFwk2bl6O/U
         92fAm8ZLyoYWvI7AbHrhqaY1MZYCnsoqIwMeYiL0dorp86UJ8m+Q9ngTpsH/ugQH8arr
         b1g9GwUP/g3kvxB+9SihjBsPbcSQL7Q6uGLOhXzyfpg2UKdNLAyj6bVQ41epuW/Sp9Tr
         QFv24mVo+J1N8zk9IkP9kSFg3nRix6N4vARTZRYhb7kSvV0IcwSsttCx12TMii46goeD
         473w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757715; x=1733362515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4bBB0NQOkuxY/fMRl1/Z0GmdB3PHk1lvBMv7RHKM/5o=;
        b=qPyPGOOFSXPt2lJwmg2ULmGgnrhw/tYLzUwICL43cZWHbXatnIeWB9CEmIZbf7WKdu
         FogIgaBu3748A8/dtUV/RSxlAkHsj8ofKLr7q3SRJV87OSpMtRI1pcKVk4PETseFeYkC
         S5RtM+O1o5nNVikLDpzZJt6ZjMyX7gV0HsfSOVk3gVzDpXczWA84ljjE8TCCyeqpZIQP
         wqK/7ONPXVUcR1JbDuXTm4h3eTV6jnCH4MdYqGWoE2ujD4aHu+9Labxl8qWqteowHGzd
         UwJq753yCWfTKJ3Nb21FxccvnrqkS1X117O0iTOdyABz9fQJqSw0Y13vt/euTSvTQZxI
         6ysA==
X-Gm-Message-State: AOJu0Yx4z4icUXjr9aeZtBou6iTK4bUWDd0gXJX674OVC6nmzxuQgWod
	0377q6Fx/9hY0hg315YG8swJ5SgN9KZg3qyf3vQr/BhKlT3RZCR7i2Mh3ZVcs83/2n0bqXmISrM
	GdQ==
X-Google-Smtp-Source: AGHT+IGwrEfLn6hBewUj/il+Vfs6v5UsNGJgiFF2RXZQmzZ8b1U9q7mlrLEDaSRSfx3tH3diTdGghP34XRs=
X-Received: from pjbqn7.prod.google.com ([2002:a17:90b:3d47:b0:2e0:a50e:a55e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c46:b0:2ea:aa69:1067
 with SMTP id 98e67ed59e1d1-2ee08e5e389mr6492735a91.3.1732757715563; Wed, 27
 Nov 2024 17:35:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:52 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-26-seanjc@google.com>
Subject: [PATCH v3 25/57] KVM: x86: Add a macro to precisely handle aliased
 0x1.EDX CPUID features
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

Add a macro to precisely handle CPUID features that AMD duplicated from
CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
assert that all features passed to kvm_cpu_cap_init() match the word being
processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.

Because the kernel simply reuses the X86_FEATURE_* definitions from
CPUID.0x1.EDX, KVM's use of the aliased features would result in false
positives from such an assert.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9219e164c810..ddff0c7c78b9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -648,6 +648,16 @@ static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
+/*
+ * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
+ * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
+ */
+#define ALIASED_1_EDX_F(name)							\
+({										\
+	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
+	feature_bit(name);							\
+})
+
 void kvm_set_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
@@ -892,30 +902,30 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
-		F(FPU) |
-		F(VME) |
-		F(DE) |
-		F(PSE) |
-		F(TSC) |
-		F(MSR) |
-		F(PAE) |
-		F(MCE) |
-		F(CX8) |
-		F(APIC) |
+		ALIASED_1_EDX_F(FPU) |
+		ALIASED_1_EDX_F(VME) |
+		ALIASED_1_EDX_F(DE) |
+		ALIASED_1_EDX_F(PSE) |
+		ALIASED_1_EDX_F(TSC) |
+		ALIASED_1_EDX_F(MSR) |
+		ALIASED_1_EDX_F(PAE) |
+		ALIASED_1_EDX_F(MCE) |
+		ALIASED_1_EDX_F(CX8) |
+		ALIASED_1_EDX_F(APIC) |
 		0 /* Reserved */ |
 		F(SYSCALL) |
-		F(MTRR) |
-		F(PGE) |
-		F(MCA) |
-		F(CMOV) |
-		F(PAT) |
-		F(PSE36) |
+		ALIASED_1_EDX_F(MTRR) |
+		ALIASED_1_EDX_F(PGE) |
+		ALIASED_1_EDX_F(MCA) |
+		ALIASED_1_EDX_F(CMOV) |
+		ALIASED_1_EDX_F(PAT) |
+		ALIASED_1_EDX_F(PSE36) |
 		0 /* Reserved */ |
 		F(NX) |
 		0 /* Reserved */ |
 		F(MMXEXT) |
-		F(MMX) |
-		F(FXSR) |
+		ALIASED_1_EDX_F(MMX) |
+		ALIASED_1_EDX_F(FXSR) |
 		F(FXSR_OPT) |
 		X86_64_F(GBPAGES) |
 		F(RDTSCP) |
@@ -1055,6 +1065,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef F
 #undef SF
 #undef X86_64_F
+#undef ALIASED_1_EDX_F
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
-- 
2.47.0.338.g60cca15819-goog


