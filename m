Return-Path: <kvm+bounces-65428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 74492CA9B5B
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 54BEC302FFE7
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1853019CC;
	Sat,  6 Dec 2025 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YXuOOAK+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83A30171F
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980319; cv=none; b=BANADIJXQJP1zNdG/uDsDA7WJI4ZsjP94T1c7xbR9h/M5uj6iCfV2nmp6W/IZ4nIr96tVYOkR9NiYTz2hxyxIxJikIRQ72sl5WpbZcHCARSTZaeY0IEnoylqR/3/Vc5M5y809KKlHUlzvyXxNH4nJ7O8bkmoGPRVh0rjma2USK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980319; c=relaxed/simple;
	bh=idLMRNHkxj+prEIBFHlo9xwnmQGyalobOpJXM4sezD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFMLJbJj8x/aNgQliccU3x3mCUHl8z6zpWhS9YZoPfhlN5zssK0CzO3HR3D5zxjSIebDDVL4UdKU+cjzTjjbiFYB7vrDE3MUjc5g5z+xv4uf9HY/Ll1GnjgwivUZY+0LJ0+qwf4o/FsAJLujlprU4VEEFKDwuFjHtAYJaPT/JqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YXuOOAK+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34378c914b4so4920842a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980317; x=1765585117; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M6M+TUCunGgZRp0HQ274P454YeO/pMlL0Ud7LaETHp4=;
        b=YXuOOAK+IfYfCD1nGxvanCt5ZYGG9d5xqAYHnE+CUv0jkhfkMrKfPGFZoQnqGEHM2M
         l8jAkI/sJQ+LVd1/VmkGhzCCLPtB8IS3ofZBAZTLCzD328p8sur3wNpMybbXIaP7+gjt
         Dkt1TACMkPP6QNi5rxBUOELLFpoonof20I4dyyXyX6WL0tp/iGQRZBvrcY168s84Hf35
         dt4R/6UZXH1aFsMLj1QUlA0pi/bu9e+G1cKX2ZZWgfbUIbKbcbH603+yKx5pk7c0aHWe
         EO68Nlz++GJRueNWyjdoNrZQNW9ajsXSY1bJwgpgIKL88pD8gPU5qFAhjVsnV3zOtZ8s
         Mgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980317; x=1765585117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6M+TUCunGgZRp0HQ274P454YeO/pMlL0Ud7LaETHp4=;
        b=H3buRroF5QUbVZ7/6xxTuIJTQ45WYH8/zver+noeC/F2eqA8+qKOHVzyTow4vr8XFk
         SUBrWs1zAz97Oq3mO3dLD6URijHl7TkFbF8FH0DzNpcpnfwp5dssHXGaZPh98AbP3/UH
         WOfpHuD/aDhWBOh/2lujqydJb5d4fGbfyW0dlO2WSxd89LASZ4OwyEyHLlKLbnovfU+C
         Lfck60Qa20bn98HtE7L5cxybVNeFmCpPK83+YOfIXJiFahcsEaiMktO3B2RckEsq/UPt
         t3oXcUBcezdhB76FJYYoJ5TCLUVwuLfouYOcaDhZPMr8D8wDVX3QSuU3V4+/nhkhz2zw
         aMgw==
X-Forwarded-Encrypted: i=1; AJvYcCUDBevuLh0PIBRI2HVMJge3ZN1mbqpIsdzXCeVhvIvjkpu4aei08CfN+ciUf86yKTEYRW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1L4OX6Ahs+7jumbxBH0eYSXdRvW58ZjyemBGSw6fCGmXv/RmU
	OJFYDwdYFpVCx2TkpDkcY5o0uzuF+DUXdSdzeiN4KvVyXAp5LO5wYQaIRBGCdorneFiI/iizA7d
	UJkjOXQ==
X-Google-Smtp-Source: AGHT+IH4rM0hrWDLcj1m7KmQfI0LQhMNTOrUf9WMiZFUwgaE9DsfO2YaBs29AIBYl4bKM4D6uGtnUb5M7G0=
X-Received: from pjbsb13.prod.google.com ([2002:a17:90b:50cd:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c89:b0:343:6611:f21
 with SMTP id 98e67ed59e1d1-349a24e3b08mr610435a91.1.1764980317071; Fri, 05
 Dec 2025 16:18:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:11 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-36-seanjc@google.com>
Subject: [PATCH v6 35/44] KVM: VMX: Drop intermediate "guest" field from msr_autostore
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the intermediate "guest" field from vcpu_vmx.msr_autostore as the
value saved on VM-Exit isn't guaranteed to be the guest's value, it's
purely whatever is in hardware at the time of VM-Exit.  E.g. KVM's only
use of the store list at the momemnt is to snapshot TSC at VM-Exit, and
the value saved is always the raw TSC even if TSC-offseting and/or
TSC-scaling is enabled for the guest.

And unlike msr_autoload, there is no need differentiate between "on-entry"
and "on-exit".

No functional change intended.

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 10 +++++-----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/vmx/vmx.h    |  4 +---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 729cc1f05ac8..486789dac515 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1076,11 +1076,11 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 	 * VM-exit in L0, use the more accurate value.
 	 */
 	if (msr_index == MSR_IA32_TSC) {
-		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
+		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore,
 						    MSR_IA32_TSC);
 
 		if (i >= 0) {
-			u64 val = vmx->msr_autostore.guest.val[i].value;
+			u64 val = vmx->msr_autostore.val[i].value;
 
 			*data = kvm_read_l1_tsc(vcpu, val);
 			return true;
@@ -1167,7 +1167,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
 					   u32 msr_index)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
+	struct vmx_msrs *autostore = &vmx->msr_autostore;
 	bool in_vmcs12_store_list;
 	int msr_autostore_slot;
 	bool in_autostore_list;
@@ -2366,7 +2366,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	 * addresses are constant (for vmcs02), the counts can change based
 	 * on L2's behavior, e.g. switching to/from long mode.
 	 */
-	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.val));
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
 
@@ -2704,7 +2704,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 */
 	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
 
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 62ba2a2b9e98..23c92c41fd83 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6567,7 +6567,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
-		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
+		vmx_dump_msrs("autostore", &vmx->msr_autostore);
 
 	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
 		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d7a96c84371f..4ce653d729ca 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -245,9 +245,7 @@ struct vcpu_vmx {
 		struct vmx_msrs host;
 	} msr_autoload;
 
-	struct msr_autostore {
-		struct vmx_msrs guest;
-	} msr_autostore;
+	struct vmx_msrs msr_autostore;
 
 	struct {
 		int vm86_active;
-- 
2.52.0.223.gf5cc29aaa4-goog


