Return-Path: <kvm+bounces-66875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70ADFCEAD08
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DBE6530081A7
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100D719E819;
	Tue, 30 Dec 2025 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C66zMUm+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289D3221FCF
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135722; cv=none; b=GdNyzhujvAVhaPAJPtIiD7+LXVEJbzc5F77apdgfMlJDYOd0EyzrcqQaL/KKxnUnKRe/6nSiVF9U2t148G5fIDdhqXemEM8ma59vUBPXZ4iSgCT+x2pcqHFUbaaer35q+vzyRuk8M/H9GuX8rGBZwYHGY0+hsKYsoAsvVtAg3qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135722; c=relaxed/simple;
	bh=gzGPTMBPkQtGA7aekWTJchDP0r6Rf1tv37EAxV+/uf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FNLT/JaXrdsie13ekpbY0CJa1r4SEIkDc5HXOSG8/NsEY/OElmrXOQVXHwjwYtEVlf5e2PuxTc/AVcg/AX3boJ4NTgqDCmf+IaKIo2sNsp1TqQ0DWE7Bqp8MMFZRkTZAEen2VGxPK91UkujQnBbeG97G4yQWsBsAoYC3HUbSkSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C66zMUm+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so23431307a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135719; x=1767740519; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kFEesFGPsutGHqF0001WthlsbSNNmBrKZgvGONrq/UE=;
        b=C66zMUm+m45C1Yfnisi0/OlzQr1RuAzz45D6IWDHIZJLUM6ZDjvvONA4fZjTm+pfB9
         hL5L7QuJxbLejhQGr5oMAlVcMPwSDC/pQ2K+QOSBmVkk3geKsU6F2qUAgZluLSIKsa0A
         E0a0X+JN5Y2IP0geYYv2/g1nGoDsa2G8jV9vRbvwwW+fz7lKxUbu1p8UkNEqy3WlwTeP
         tfgv4QSEeuLd4KGUfNucjvilN1NDehbp1g3Y5A7gq1R/Fkda0wdYvwMjsxDZI2yuQs2u
         MUfrgHO96PvVBYQNeWvgeDqj8NK+QtsgLuilh8y/Z2gK9Uw3fSzUo+Xf+a+coGr0OrRt
         1+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135719; x=1767740519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kFEesFGPsutGHqF0001WthlsbSNNmBrKZgvGONrq/UE=;
        b=RT09pCC0b1U2n0Xxo71MUWt8TNyVqx3pNIhKM/o+pObJLWXVhqvzhWRT6E6tM24bB5
         //KnMzePkWfZecQnnAhcEZ2dnBOQ+Nz0g5WAEW6cSyAwxLKK6ZswZg0YJy2MXTjPiTwT
         93WLrG8Slmxn0GzxZcoliIcC84x5wBSOe3YVnTlSvwCT+iDnyvVZRZz3YtPnPLI0rr6q
         /h42MVtx9hV6kwy6FmG9TrBof0PHHPkIR1bdNpr1RkTv2HI+ScGud0fWhI3N+P58SEK+
         05MoZ3ki5MAR3/0/MrDEVzlF/TD7SUhmyk+OgGaPoV9r7OcR1tp0fjRf+pun01s+SdV2
         WnKA==
X-Gm-Message-State: AOJu0Yza2r5ccf7QjnN5SbzX/mCUjd826h3EN6v0K08XE8VVxLWsYcmf
	jQEA29kS4bQOU+kzkm9+pC4M0gRooTxvE2Z/squMErttB1nyltS1iHT6zjtvAivgmTtaQBZaO86
	VVdRBSQ==
X-Google-Smtp-Source: AGHT+IFMvmVZegtbcaH8ygYeOdZA18LUtrqVKCjaPL92fD8viNNyqFkg9jykfPAXGidnl1kcsTEoQKpdcsc=
X-Received: from pjbqe11.prod.google.com ([2002:a17:90b:4f8b:b0:34a:9e02:ffa0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a52:b0:340:99fd:9676
 with SMTP id 98e67ed59e1d1-34e9212aaa9mr28973871a91.10.1767135719406; Tue, 30
 Dec 2025 15:01:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:33 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-5-seanjc@google.com>
Subject: [PATCH v4 04/21] KVM: selftests: Kill eptPageTablePointer
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Replace the struct overlay with explicit bitmasks, which is clearer and
less error-prone. See commit f18b4aebe107 ("kvm: selftests: do not use
bitfields larger than 32-bits for PTEs") for an example of why bitfields
are not preferable.

Remove the unused PAGE_SHIFT_4K definition while at it.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 35 +++++++++++------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 1954ccdfc353..85043bb1ec4d 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -10,10 +10,16 @@
 #include "processor.h"
 #include "vmx.h"
 
-#define PAGE_SHIFT_4K  12
-
 #define KVM_EPT_PAGE_TABLE_MIN_PADDR 0x1c0000
 
+#define EPTP_MT_SHIFT		0 /* EPTP memtype bits 2:0 */
+#define EPTP_PWL_SHIFT		3 /* EPTP page walk length bits 5:3 */
+#define EPTP_AD_ENABLED_SHIFT	6 /* EPTP AD enabled bit 6 */
+
+#define EPTP_WB			(X86_MEMTYPE_WB << EPTP_MT_SHIFT)
+#define EPTP_PWL_4		(3ULL << EPTP_PWL_SHIFT) /* PWL is (levels - 1) */
+#define EPTP_AD_ENABLED		(1ULL << EPTP_AD_ENABLED_SHIFT)
+
 bool enable_evmcs;
 
 struct hv_enlightened_vmcs *current_evmcs;
@@ -34,14 +40,6 @@ struct eptPageTableEntry {
 	uint64_t suppress_ve:1;
 };
 
-struct eptPageTablePointer {
-	uint64_t memory_type:3;
-	uint64_t page_walk_length:3;
-	uint64_t ad_enabled:1;
-	uint64_t reserved_11_07:5;
-	uint64_t address:40;
-	uint64_t reserved_63_52:12;
-};
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
 	uint16_t evmcs_ver;
@@ -196,16 +194,15 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
 	vmwrite(PIN_BASED_VM_EXEC_CONTROL, rdmsr(MSR_IA32_VMX_TRUE_PINBASED_CTLS));
 
 	if (vmx->eptp_gpa) {
-		uint64_t ept_paddr;
-		struct eptPageTablePointer eptp = {
-			.memory_type = X86_MEMTYPE_WB,
-			.page_walk_length = 3, /* + 1 */
-			.ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
-			.address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
-		};
+		uint64_t eptp = vmx->eptp_gpa | EPTP_WB | EPTP_PWL_4;
 
-		memcpy(&ept_paddr, &eptp, sizeof(ept_paddr));
-		vmwrite(EPT_POINTER, ept_paddr);
+		TEST_ASSERT((vmx->eptp_gpa & ~PHYSICAL_PAGE_MASK) == 0,
+			    "Illegal bits set in vmx->eptp_gpa");
+
+		if (ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS))
+			eptp |= EPTP_AD_ENABLED;
+
+		vmwrite(EPT_POINTER, eptp);
 		sec_exec_ctl |= SECONDARY_EXEC_ENABLE_EPT;
 	}
 
-- 
2.52.0.351.gbe84eed79e-goog


