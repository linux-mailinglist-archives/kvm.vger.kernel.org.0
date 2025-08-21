Return-Path: <kvm+bounces-55239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B68B2ECD2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64DB5A2317E
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86FF2D3A94;
	Thu, 21 Aug 2025 04:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eqN1UGq7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508412E093A
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750570; cv=none; b=bV4Nm2S76vpJux4Hr2tcruBghXmzbyHMH6QWtoJB4mx9KZJoi6o2A7cWxv4hFBFozXMi7vxyui/BOh84hjL7L1fwPP84orajKY8/M7PphqTaf/7zGpJUY9HtgPjQEq5CL0Xoy8h3wzPVuSV9Xy55lya7DB7zbXC5JriBHnofoIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750570; c=relaxed/simple;
	bh=oza6hx2ntzUZXObmix0KiLo9V3JboBdBQCO1cnzK8hQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rB92kELbJEcDqsLi/7dLnlmXdtbXC38gHZXhlmWDphfyiKp73apqeacI/0cVq1e+TM2evXJ65Wx0mju7Mo97yXx0JCnWq6LUrbzeC0fmwB4AbZH557IwB6dibns8r7T1riJ8rrw0LDIVnSTV5kAXwdvFqohyOnOB5yK3jO+HNAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eqN1UGq7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323266c83f6so644358a91.0
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750568; x=1756355368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRFEjTGnGKNT/7J5APntzZoA6CylwPAhIKfI752BiBs=;
        b=eqN1UGq77WT4zjkWFh+zFFBywaJjTNbP3Z8lGFQ3U5hJA7VM4Dhzn5uWV/C1mY6tp+
         URcn/hAFcDkasv5MtTym9v4nZSRRZgl2t0UTpjRh+6KjFHcIE+Z/0bKlBPbhoWEPNPMj
         VYReKi8ToNBOiGDYMykMNCX7/ak+rFRlEuFRCEFQeLMroBxNnCV6FW3b/alCQQ2q70m9
         4Dinxy/r6kEOJKWIHVTNYYgO4In1lNZ8PD1yOllUIl0nX4mM+oksFgW/HgqwHqPV0UQA
         P/X1N3G/XFbShmk2pPDjwxzdUBvOdHU6P6fvEKtUrGP6OihhzbIbtCWPtMffPeeWFwlk
         H9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750568; x=1756355368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRFEjTGnGKNT/7J5APntzZoA6CylwPAhIKfI752BiBs=;
        b=CYGGTlb2wBiQe4/EjEI6zRtMyBWZVUTERWt4HUBJ8iItWPCPfzIl141UKFf/l2wUqt
         5yhrf44DGR3DiculhEvqTfz4mw5Vjirjddh9jAEkwk55wzKdEA/D1h1scxKztSFdHwUh
         xy+50QMQG6+i6losB4/46JRX+SytL0nSM60NkvSkIwoPihCaXKKRuCPN5YGLnLMYBm7f
         /n4cLzRr3OTYFnyOckppGFkobPMaqRMYeMHSIp6HYx6XnHY21O92x0x3pO+d2xfiOfWt
         4nA7JKE1Y/a0LAS03qJdgICbQ+0yHSmEAxOYR1pYDiQt/PHx8rc1iht1W5dpTMIjf+3f
         X+6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWY9vWx71A9zduAuvEvuQZaNNRiEsFcNKVa4funjbR+RIR/oDCFQ296rGY5JEY/4swinlI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXvniw97Xx659khjNWAy5oaOA8RQZ7x0/GjurmmQZ8ZVFNl96p
	63N8uWY36ajI6jORCr+XnaXToe6V+uF7YYnjVH/Dh8OcQPebqrqUE8BPdKgHBIFIZLrbj6gTiog
	mgA==
X-Google-Smtp-Source: AGHT+IGgXv0HXZJEaeYeMRs0Tu4Cdx9jcHbVap6aLHFdU7b6D7sdqdWyIH1R2tQe7TkoFGhR8InX65S0gA==
X-Received: from pjbsl4.prod.google.com ([2002:a17:90b:2e04:b0:312:ea08:fa64])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c90:b0:30a:3e8e:ea30
 with SMTP id 98e67ed59e1d1-324eedf50bfmr1190919a91.11.1755750568559; Wed, 20
 Aug 2025 21:29:28 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:28:56 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-4-sagis@google.com>
Subject: [PATCH v9 03/19] KVM: selftests: Expose functions to get default
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
 .../selftests/kvm/include/x86/processor.h     |  6 +++
 .../testing/selftests/kvm/lib/x86/processor.c | 41 +++++++++++++++----
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2efb05c2f2fb..5c16507f9b2d 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1026,6 +1026,12 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
 
+uint16_t kvm_get_default_idt_limit(void);
+uint16_t kvm_get_default_gdt_limit(void);
+uint64_t kvm_get_default_cr0(void);
+uint64_t kvm_get_default_cr4(void);
+uint64_t kvm_get_default_efer(void);
+
 static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
 {
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d4c19ac885a9..b2a4b11ac8c0 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -488,6 +488,35 @@ static void kvm_seg_set_tss_64bit(vm_vaddr_t base, struct kvm_segment *segp)
 	segp->present = 1;
 }
 
+uint16_t kvm_get_default_idt_limit(void)
+{
+	return NUM_INTERRUPTS * sizeof(struct idt_entry) - 1;
+}
+
+uint16_t kvm_get_default_gdt_limit(void)
+{
+	return getpagesize() - 1;
+}
+
+uint64_t kvm_get_default_cr0(void)
+{
+	return X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
+}
+
+uint64_t kvm_get_default_cr4(void)
+{
+	uint64_t cr4 = X86_CR4_PAE | X86_CR4_OSFXSR;
+
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
+		cr4 |= X86_CR4_OSXSAVE;
+	return cr4;
+}
+
+uint64_t kvm_get_default_efer(void)
+{
+	return EFER_LME | EFER_LMA | EFER_NX;
+}
+
 static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	struct kvm_sregs sregs;
@@ -498,15 +527,13 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
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
2.51.0.rc1.193.gad69d77794-goog


