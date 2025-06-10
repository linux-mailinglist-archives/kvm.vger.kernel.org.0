Return-Path: <kvm+bounces-48868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9832AAD434D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:54:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52FBB189CB5B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B787265631;
	Tue, 10 Jun 2025 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HVZQwp1N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918C02652BA
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585264; cv=none; b=YO/pMhkFRPQsSF2W33NntkiYjkOzTcUgzTRbgB1ti/8gnQWO56PTzHlosjIZpuxC6l6mnbySyIun02xSZb/S6FTRZXj6D3aIXHLSp9ElShfsdXO+6rbQDKSz9qv0AymQy/el758Z6hNbOz7yHTHFVYNpBXTIqlSZmXwRID+L2sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585264; c=relaxed/simple;
	bh=oCD19FkFzvYAWpXq5PTOBo6/0kFmIu/AEqJMwYROlHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f9l5bvAR0WVHw36OzK3eVcZzIl6WytXnWf7kjlfv28O3BpgAYZH+f8MmH/DluzJnC1r2aeLvZ4LJb7xrx86UxCl0Re+lCmElRlyh5aQVgL4U6uVo/k7bpYni5Wwqnz2ykahLjFwk8Mf5cWVuP5C2dBwo5pGaaSvKgU5two2ejMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HVZQwp1N; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748475d2a79so2277614b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585262; x=1750190062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AN8Znt7XMw+Q6kMus1uq4YUtqJm/XChvUuxMh5rYuEw=;
        b=HVZQwp1N8097uzNMmTQzDspF7v9t1duy1qtdRDC848qNVtac5dolH3Rh9O41guV6kc
         a03SdnXTNWy6CwErBz8p0RQsH0wdMASfM/HTV++3HBzrISUsJBOu0EuNYWos087V1ehI
         hRPsoG6EBI8keUqx90T5wZvnkZ0MUrQEf6bA3MFgWw5DyDMLT8U1U00NHATr7qunHThI
         QdDQzaDsYo3eBjlBMyPrxTrf/W4t8LfUBPHFrFfoVpv5k/9ImLolUe6hwvsBqt9AfW8V
         u5PkgYe8DGbbi+B/fsiDB9ER0tCnUEqC+VM9VFCLpC4IKno58Gi87BlbeHq8PFfmd4lA
         SKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585262; x=1750190062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AN8Znt7XMw+Q6kMus1uq4YUtqJm/XChvUuxMh5rYuEw=;
        b=pj9l2BNun9jGOyYndcFrbazaPDHKOrZli9ZQ4qlZcX//juT7iJFOXy6igiwXzwBVYL
         eu9BS+88lOKDAQjbi1KaXrb+6oxNNPpbNGMPclFGK+MYoD4lJWkkr25aS8TelR+KQmLA
         JxvPjD7C9CTwyJBF2I9dw44UUBYALgKfG/Oc5R9jkAFUNHayVmgGuyjRN6kPf4DUAQKV
         a/elLxyMgelu8Tch0i7GmhNH6tK0F3f8rM3+/E89fOTMZUxWpI+MhAcbAWfxPdQoz45W
         IyHGl9bRvXLrkGS81PWz3iA2UerCPDjPFkswvXY7xtNDMZ7SI5BHvMCu85zm7QnvDCJN
         mQOw==
X-Gm-Message-State: AOJu0YxHS9GkvN4J5Z61pkl3LmOKLpyN/MoX6aDzYUrYb7Affl7AtiLi
	u11twfktMMhB24wSZCDqw73XYsVeZPLi+/qp92TfZCZukX3rINIR8D3BrJ2JumpRNk894W1IGDg
	jWA75Jw==
X-Google-Smtp-Source: AGHT+IHAUHO0TL0R5hgth6Ai0b77bbuk0CwzStUYBSJeCMMqy5a2rzdkREs36KnXcF8MF+ylk/Kl7QRKfzg=
X-Received: from pffx7.prod.google.com ([2002:aa7:93a7:0:b0:73c:26eb:39b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4649:b0:740:b5f9:287b
 with SMTP id d2e1a72fcca58-7486cb7f8femr1041242b3a.1.1749585261902; Tue, 10
 Jun 2025 12:54:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:03 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 02/14] x86: Add X86_PROPERTY_* framework to
 retrieve CPUID values
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Introduce X86_PROPERTY_* to allow retrieving values/properties from CPUID
leafs, e.g. MAXPHYADDR from CPUID.0x80000008.  Use the same core code as
X86_FEATURE_*, the primary difference is that properties are multi-bit
values, whereas features enumerate a single bit.

Add this_cpu_has_p() to allow querying whether or not a property exists
based on the maximum leaf associated with the property, e.g. MAXPHYADDR
doesn't exist if the max leaf for 0x8000_xxxx is less than 0x8000_0008.

Use the new property infrastructure in cpuid_maxphyaddr() to prove that
the code works as intended.  Future patches will convert additional code.

Note, the code, nomenclature, changelog, etc. are all stolen from KVM
selftests.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 109 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 102 insertions(+), 7 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index d86fa0cf..e6bd964f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -218,13 +218,6 @@ static inline struct cpuid cpuid(u32 function)
 	return cpuid_indexed(function, 0);
 }
 
-static inline u8 cpuid_maxphyaddr(void)
-{
-	if (raw_cpuid(0x80000000, 0).a < 0x80000008)
-	return 36;
-	return raw_cpuid(0x80000008, 0).a & 0xff;
-}
-
 static inline bool is_intel(void)
 {
 	struct cpuid c = cpuid(0);
@@ -329,6 +322,74 @@ struct x86_cpu_feature {
 #define X86_FEATURE_VNMI		X86_CPU_FEATURE(0x8000000A, 0, EDX, 25)
 #define X86_FEATURE_AMD_PMU_V2		X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
 
+/*
+ * Same idea as X86_FEATURE_XXX, but X86_PROPERTY_XXX retrieves a multi-bit
+ * value/property as opposed to a single-bit feature.  Again, pack the info
+ * into a 64-bit value to pass by value with no overhead on 64-bit builds.
+ */
+struct x86_cpu_property {
+	u32	function;
+	u8	index;
+	u8	reg;
+	u8	lo_bit;
+	u8	hi_bit;
+};
+#define X86_CPU_PROPERTY(fn, idx, gpr, low_bit, high_bit)			\
+({										\
+	struct x86_cpu_property property = {					\
+		.function = fn,							\
+		.index = idx,							\
+		.reg = gpr,							\
+		.lo_bit = low_bit,						\
+		.hi_bit = high_bit,						\
+	};									\
+										\
+	static_assert(low_bit < high_bit);					\
+	static_assert((fn & 0xc0000000) == 0 ||					\
+		      (fn & 0xc0000000) == 0x40000000 ||			\
+		      (fn & 0xc0000000) == 0x80000000 ||			\
+		      (fn & 0xc0000000) == 0xc0000000);				\
+	static_assert(idx < BIT(sizeof(property.index) * BITS_PER_BYTE));	\
+	property;								\
+})
+
+#define X86_PROPERTY_MAX_BASIC_LEAF		X86_CPU_PROPERTY(0, 0, EAX, 0, 31)
+#define X86_PROPERTY_PMU_VERSION		X86_CPU_PROPERTY(0xa, 0, EAX, 0, 7)
+#define X86_PROPERTY_PMU_NR_GP_COUNTERS		X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
+#define X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH	X86_CPU_PROPERTY(0xa, 0, EAX, 16, 23)
+#define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
+#define X86_PROPERTY_PMU_EVENTS_MASK		X86_CPU_PROPERTY(0xa, 0, EBX, 0, 7)
+#define X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK	X86_CPU_PROPERTY(0xa, 0, ECX, 0, 31)
+#define X86_PROPERTY_PMU_NR_FIXED_COUNTERS	X86_CPU_PROPERTY(0xa, 0, EDX, 0, 4)
+#define X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH	X86_CPU_PROPERTY(0xa, 0, EDX, 5, 12)
+
+#define X86_PROPERTY_SUPPORTED_XCR0_LO		X86_CPU_PROPERTY(0xd,  0, EAX,  0, 31)
+#define X86_PROPERTY_XSTATE_MAX_SIZE_XCR0	X86_CPU_PROPERTY(0xd,  0, EBX,  0, 31)
+#define X86_PROPERTY_XSTATE_MAX_SIZE		X86_CPU_PROPERTY(0xd,  0, ECX,  0, 31)
+#define X86_PROPERTY_SUPPORTED_XCR0_HI		X86_CPU_PROPERTY(0xd,  0, EDX,  0, 31)
+
+#define X86_PROPERTY_XSTATE_TILE_SIZE		X86_CPU_PROPERTY(0xd, 18, EAX,  0, 31)
+#define X86_PROPERTY_XSTATE_TILE_OFFSET		X86_CPU_PROPERTY(0xd, 18, EBX,  0, 31)
+#define X86_PROPERTY_AMX_MAX_PALETTE_TABLES	X86_CPU_PROPERTY(0x1d, 0, EAX,  0, 31)
+#define X86_PROPERTY_AMX_TOTAL_TILE_BYTES	X86_CPU_PROPERTY(0x1d, 1, EAX,  0, 15)
+#define X86_PROPERTY_AMX_BYTES_PER_TILE		X86_CPU_PROPERTY(0x1d, 1, EAX, 16, 31)
+#define X86_PROPERTY_AMX_BYTES_PER_ROW		X86_CPU_PROPERTY(0x1d, 1, EBX, 0,  15)
+#define X86_PROPERTY_AMX_NR_TILE_REGS		X86_CPU_PROPERTY(0x1d, 1, EBX, 16, 31)
+#define X86_PROPERTY_AMX_MAX_ROWS		X86_CPU_PROPERTY(0x1d, 1, ECX, 0,  15)
+
+#define X86_PROPERTY_MAX_KVM_LEAF		X86_CPU_PROPERTY(0x40000000, 0, EAX, 0, 31)
+
+#define X86_PROPERTY_MAX_EXT_LEAF		X86_CPU_PROPERTY(0x80000000, 0, EAX, 0, 31)
+#define X86_PROPERTY_MAX_PHY_ADDR		X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
+#define X86_PROPERTY_MAX_VIRT_ADDR		X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
+#define X86_PROPERTY_GUEST_MAX_PHY_ADDR		X86_CPU_PROPERTY(0x80000008, 0, EAX, 16, 23)
+#define X86_PROPERTY_SEV_C_BIT			X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
+#define X86_PROPERTY_PHYS_ADDR_REDUCTION	X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
+#define X86_PROPERTY_NR_PERFCTR_CORE		X86_CPU_PROPERTY(0x80000022, 0, EBX, 0, 3)
+#define X86_PROPERTY_NR_PERFCTR_NB		X86_CPU_PROPERTY(0x80000022, 0, EBX, 10, 15)
+
+#define X86_PROPERTY_MAX_CENTAUR_LEAF		X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
+
 static inline u32 __this_cpu_has(u32 function, u32 index, u8 reg, u8 lo, u8 hi)
 {
 	union {
@@ -347,6 +408,40 @@ static inline bool this_cpu_has(struct x86_cpu_feature feature)
 			      feature.reg, feature.bit, feature.bit);
 }
 
+static inline uint32_t this_cpu_property(struct x86_cpu_property property)
+{
+	return __this_cpu_has(property.function, property.index,
+			      property.reg, property.lo_bit, property.hi_bit);
+}
+
+static __always_inline bool this_cpu_has_p(struct x86_cpu_property property)
+{
+	uint32_t max_leaf;
+
+	switch (property.function & 0xc0000000) {
+	case 0:
+		max_leaf = this_cpu_property(X86_PROPERTY_MAX_BASIC_LEAF);
+		break;
+	case 0x40000000:
+		max_leaf = this_cpu_property(X86_PROPERTY_MAX_KVM_LEAF);
+		break;
+	case 0x80000000:
+		max_leaf = this_cpu_property(X86_PROPERTY_MAX_EXT_LEAF);
+		break;
+	case 0xc0000000:
+		max_leaf = this_cpu_property(X86_PROPERTY_MAX_CENTAUR_LEAF);
+	}
+	return max_leaf >= property.function;
+}
+
+static inline u8 cpuid_maxphyaddr(void)
+{
+	if (!this_cpu_has_p(X86_PROPERTY_MAX_PHY_ADDR))
+		return 36;
+
+	return this_cpu_property(X86_PROPERTY_MAX_PHY_ADDR);
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
-- 
2.50.0.rc0.642.g800a2b2222-goog


