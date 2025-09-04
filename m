Return-Path: <kvm+bounces-56747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C87C5B432F4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C8895E73DA
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9D5287241;
	Thu,  4 Sep 2025 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hqg7p1rh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2CE285CA2
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968908; cv=none; b=n4MxaNGLJnwBs5irOrze+2K0IaMxVtgECrMYzGx6Bg8YnwHB47K2OWHCe6vVB8K7Euu/9zh19IxBMIKrMX6jVuX2+i289i+cFDFeQQWQT67VcVQmTob8hd4gRRTc8XJmAY8iYGwwfhnTq7PbAqHqIQS/rEH2yE6/a+99JkCDuP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968908; c=relaxed/simple;
	bh=348b4OgRxCPZDt5zbD2zMnPjRA6DnidXFpSwvU+Q7T0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WIq+E7Sebc94j2Y+IUJYW7whLBlDkkLDt75GQ9nPWgl7m5R4oJ7keKrMoToMrDlnm4TdlnqMAc+rmZddE/tJhCAmbaNyH4t+ZOJ2nQnvLRiYPLLwvHVcYmeVceWtr7OMbDo7WkyFo82kolDkqnCY4mHLUYHaL8gqymYKPd1/O4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hqg7p1rh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-325b2959306so1286782a91.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968906; x=1757573706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vezJfUKCtxNWPm/VdLSVnM4sP+de00c6p544QQMtBnU=;
        b=Hqg7p1rhO/pp9pFDQrs/XZlVGnczm3Bvq91al0XdGMVsuWn1wlRKFU6Apq5XKMntCU
         gmqQkx4mNNFk3C4SkijiksIiu/Q86YE/YrrlGDz86HVA92Z9A3qKcVjDTG5YouOJq9gC
         2tMbvYIGyT88UTP00E/1V0TPxR4LCEczs/hUobMKWG3SU73Vr1v0z7FlFnGhKaR2aMDq
         rZ6f3E980KfCv3rsbiDNJUmA9w4PYlP7nt2lVsBiiwm7YKI74XdQff6DXK3uUq4zsY4S
         oCJCQrp9m/slnx0w3aAs+Z/+ItaX6dbQ3dfyJsQIU4E8W+X5Fgp8chhGPEjLM+z1jABX
         Gprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968906; x=1757573706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vezJfUKCtxNWPm/VdLSVnM4sP+de00c6p544QQMtBnU=;
        b=Ons3O6F7q580Qblb7XqCnLDOw9lFZA2vJxpc93gddy3kO6pnuKTJjI8VffHVNYmX5c
         XdPi3Hoit9ND0pRagGV1UPA6gN8ALtaHtYHPA6rU+r4GGKDD+yktxFE2xMu9JegtS2HP
         5F+lkP9sHW5G2PCHyqlQJBMnpbmTVnZP7ZS2UKaUcr/gGYHVyk95XreufG/qC32SoxmN
         0WL5qrmP5ClGTXhx2J10DbkdiEiFk7HTvEU1sI7w+G2mv5YKginfFRK6zH5Qk6uoZapR
         K0GDGyIcZ5wwdZU0sSOcFn+bSaVuM1GRfIyP69/cjhSQ6gvOvMmqBB+EmIPTI1vLCTqy
         IJJw==
X-Forwarded-Encrypted: i=1; AJvYcCUchs6auKtNoB3SpMSEdeA0ykxcl9YoD0yby46PxN76fmMWKEPX2wbl1GfwrjyiNKU7Aos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxtY06Uaw2YxxMd2kPipOqarVZ4pzdOxu1pf3ilySyhPeOVG7p
	F0iO0VnuFmS39l/UhcpGM2VRxI8IkqDQj5qV30OhwJRMgSlr20ZUfpGFyuCJADnV7vEY9Nj1X2Z
	k1g==
X-Google-Smtp-Source: AGHT+IHKFulWacx9Uc/kpwTFlpBhGdWU15nk+AKPjD6xyzys8McNW5qoCvcoYO9CJe7Y4Ge8I7kXM/rjWQ==
X-Received: from pjboh15.prod.google.com ([2002:a17:90b:3a4f:b0:32b:827b:f76e])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4aca:b0:329:cb75:fed7
 with SMTP id 98e67ed59e1d1-329cb760ed6mr17044247a91.19.1756968906032; Wed, 03
 Sep 2025 23:55:06 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:32 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-3-sagis@google.com>
Subject: [PATCH v10 02/21] KVM: selftests: Expose functions to get default
 sregs values
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

TDX can't set sregs values directly using KVM_SET_SREGS. Expose the
default values of certain sregs used by TDX VMs so they can be set
manually.

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/processor.h     | 33 +++++++++++++++++++
 .../testing/selftests/kvm/lib/x86/processor.c | 12 +++----
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2efb05c2f2fb..f610c09cadf4 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -27,6 +27,10 @@ extern uint64_t guest_tsc_khz;
 #define MAX_NR_CPUID_ENTRIES 100
 #endif
 
+#ifndef NUM_INTERRUPTS
+#define NUM_INTERRUPTS 256
+#endif
+
 #define NONCANONICAL 0xaaaaaaaaaaaaaaaaull
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
@@ -1456,4 +1460,33 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 bool sys_clocksource_is_based_on_tsc(void);
 
+static inline uint16_t kvm_get_default_idt_limit(void)
+{
+	return NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+}
+
+static inline uint16_t kvm_get_default_gdt_limit(void)
+{
+	return getpagesize() - 1;
+}
+
+static inline uint64_t kvm_get_default_cr0(void)
+{
+	return X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
+}
+
+static inline uint64_t kvm_get_default_cr4(void)
+{
+	uint64_t cr4 = X86_CR4_PAE | X86_CR4_OSFXSR;
+
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
+		cr4 |= X86_CR4_OSXSAVE;
+	return cr4;
+}
+
+static inline uint64_t kvm_get_default_efer(void)
+{
+	return EFER_LME | EFER_LMA | EFER_NX;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c19ac885a9..83efcf48faad 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -498,15 +498,13 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_get(vcpu, &sregs);
 
 	sregs.idt.base = vm->arch.idt;
-	sregs.idt.limit = NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+	sregs.idt.limit = kvm_get_default_idt_limit();
 	sregs.gdt.base = vm->arch.gdt;
-	sregs.gdt.limit = getpagesize() - 1;
+	sregs.gdt.limit = kvm_get_default_gdt_limit();
 
-	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
-	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
-	if (kvm_cpu_has(X86_FEATURE_XSAVE))
-		sregs.cr4 |= X86_CR4_OSXSAVE;
-	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
+	sregs.cr0 = kvm_get_default_cr0();
+	sregs.cr4 |= kvm_get_default_cr4();
+	sregs.efer |= kvm_get_default_efer();
 
 	kvm_seg_set_unusable(&sregs.ldt);
 	kvm_seg_set_kernel_code_64bit(&sregs.cs);
-- 
2.51.0.338.gd7d06c2dae-goog


