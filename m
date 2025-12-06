Return-Path: <kvm+bounces-65429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00001CA9BEE
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E61F13178E01
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810BC304BBF;
	Sat,  6 Dec 2025 00:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LgH5hYRC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BD9303A18
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980323; cv=none; b=EXVtUhU4/wW+ptqWyPcYm1PjPJ67YdWSzkJaU81Dz8DtShJbKrwY3Yx7IqSNa4JEy9U7p8kNZrWIuVzFRhTB7WxNIF4k7JHmVy+s26KK2DiboPsO6dZc+1DtcQEurbf50LSe84PVvrEZj65LiPe2qNlTsXGSENvIt4DL48HSz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980323; c=relaxed/simple;
	bh=q1xuOjj1CS5QA7ELdLFyugLEU/XcJbqyV6rHreEB4aE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CFnpstiUysQDyYcvFAYYc06G/MeA2rAlwJ7G9etrYsXXlJQx2KstzjZ0rMVVNuUXfEYPC/kRyO6C7Z911OClcf7zf8Kdsf1lMxeZQCT+TrKtx97xowmYrWe2ZFy7mYmnQKx+mI4k01wrxrMQ3NaFpSHdVqnQy4jHI+uIvQ7Z5Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LgH5hYRC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4735204a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980320; x=1765585120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ku5/x+LjNQqCx84/WRP5NtSBvqHOmfXefyV2HWZpjLA=;
        b=LgH5hYRCojXZxMk+udhVBWaSHt5Cz2gJX4YN9xR+XclaD/8uM8OFKqai8vC/9d4HfA
         HF8Q08xgUuZYyH6FA5WH+q17QnBO1YYpEln23eoWQWsFqoXvpjMSojwP4/SYwunWM63J
         +QwMADc3awZqRxQlFnuAv67lNugaHhW2Yz9qmG1/ZoBNr2tHYbAigyPreD2ppcGWPNUj
         UclS2of4ZPabA3A7kj80JS2A4HkVRWROgmCxUmRmS/GPki0KY6iu3KDnRDw3is/ma183
         VRj5Au6qsb5FC4mfxoTaINqM8XV2K95pbRYJFtjqfzpjBji8FO4BgZ+0Pqj6+hv+JDqY
         DaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980320; x=1765585120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ku5/x+LjNQqCx84/WRP5NtSBvqHOmfXefyV2HWZpjLA=;
        b=YZ7VTQvo8aSNHB1SulY+ttlVW1nlNOazTjPDvEwdIHuHyJU4uF1hXfTR3aa8HHKOMa
         +cC6sWAA4l9hOjqmt6FZ7c+hcGI+tOL9w6LK5U+c1Zifl7OvuSCk9ieNcrkte43QZ4z3
         czf5TCtSXF9PRWKZBBBeWW4wpMnq5DhlNWWq8XTXm/2c2l3JP7pzqCqJ62taROlcOfwu
         JwAlRpmtD/Qf3KKWMRL1kfMO019Mz6/lTn0bn7QFclhHsRPhitO+SUgDdRv14/dpUzvT
         4YEqNSnhv+u+41fYUUkCdWjGdE7yvUwGx89CrCU/WeVvTXox7uI1iFNEko05L0LgXWGT
         RKRg==
X-Forwarded-Encrypted: i=1; AJvYcCV7sKwv3U88SFK2PCahdtl6Vgov99Qedw5eSEHu1YhMGHnixB+uevsrsE1c6XyD+Mh4lVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2WdKB5E7ckF20sTnIrj7Ems+3vvN/CqY6qus74fZy7uXoq3c7
	PoK3KcpHbLJiHhZLL06hL/YLa9VFDxT2wpvbr8wyW+Jppcu3rF9lPTCLd9wFDU1yiAPc9AtScAJ
	fFSDL4w==
X-Google-Smtp-Source: AGHT+IEdp4wM145Xt6RAcxFUTnovxS6MiWgfOzkzkurnCS7JdSyw5SBAEDCrfo8aXCdOIaWJdQdQ/+16vt8=
X-Received: from pjbft20.prod.google.com ([2002:a17:90b:f94:b0:347:40b0:958b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70d:b0:343:66e2:5f9b
 with SMTP id 98e67ed59e1d1-349a25bd10emr622201a91.24.1764980320255; Fri, 05
 Dec 2025 16:18:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:12 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-37-seanjc@google.com>
Subject: [PATCH v6 36/44] KVM: nVMX: Don't update msr_autostore count when
 saving TSC for vmcs12
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

Rework nVMX's use of the MSR auto-store list to snapshot TSC to sneak
MSR_IA32_TSC into the list _without_ updating KVM's software tracking,
and drop the generic functionality so that future usage of the store list
for nested specific logic needs to consider the implications of modifying
the list.  Updating the list only for vmcs02 and only on nested VM-Enter
is a disaster waiting to happen, as it means vmcs01 is stale relative to
the software tracking, and KVM could unintentionally leave an MSR in the
store list in perpetuity while running L1, e.g. if KVM addressed the first
issue and updated vmcs01 on nested VM-Exit without removing TSC from the
list.

Furthermore, mixing KVM's desire to save an MSR with L1's desire to save
an MSR result KVM clobbering/ignoring the needs of vmcs01 or vmcs02.
E.g. if KVM added MSR_IA32_TSC to the store list for its own purposes, and
then _removed_ MSR_IA32_TSC from the list after emulating nested VM-Enter,
then KVM would remove MSR_IA32_TSC from the list even though saving TSC on
VM-Exit from L2 is still desirable (to provide L1 with an accurate TSC).

Similarly, removing an MSR from the list based on vmcs12's settings could
drop an MSR that KVM wants to save for its own purposes.

In practice, the issues are currently benign, because KVM doesn't use the
store list for vmcs01.  But that will change with upcoming mediated PMU
support.

Alternatively, a "full" solution would be to track MSR list entries for
vmcs12 separately from KVM's standard lists, but MSR_IA32_TSC is likely
the only MSR that KVM would ever want to save on _every_ VM-Exit purely
based on vmcs12.  I.e. the added complexity isn't remotely justified at
this time.

Opportunistically escalate from a pr_warn_ratelimited() to a full WARN as
KVM reserves eight entries in each MSR list, and as above KVM uses at most
one entry.

Opportunistically make vmx_find_loadstore_msr_slot() local to vmx.c as
using it directly from nested code is unsafe due to the potential for
mixing vmcs01 and vmcs02 state (see above).

Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 71 ++++++++++++---------------------------
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 3 files changed, 24 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 486789dac515..614b789ecf16 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1075,16 +1075,12 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 	 * does not include the time taken for emulation of the L2->L1
 	 * VM-exit in L0, use the more accurate value.
 	 */
-	if (msr_index == MSR_IA32_TSC) {
-		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore,
-						    MSR_IA32_TSC);
+	if (msr_index == MSR_IA32_TSC && vmx->nested.tsc_autostore_slot >= 0) {
+		int slot = vmx->nested.tsc_autostore_slot;
+		u64 host_tsc = vmx->msr_autostore.val[slot].value;
 
-		if (i >= 0) {
-			u64 val = vmx->msr_autostore.val[i].value;
-
-			*data = kvm_read_l1_tsc(vcpu, val);
-			return true;
-		}
+		*data = kvm_read_l1_tsc(vcpu, host_tsc);
+		return true;
 	}
 
 	if (kvm_emulate_msr_read(vcpu, msr_index, data)) {
@@ -1163,42 +1159,6 @@ static bool nested_msr_store_list_has_msr(struct kvm_vcpu *vcpu, u32 msr_index)
 	return false;
 }
 
-static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
-					   u32 msr_index)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct vmx_msrs *autostore = &vmx->msr_autostore;
-	bool in_vmcs12_store_list;
-	int msr_autostore_slot;
-	bool in_autostore_list;
-	int last;
-
-	msr_autostore_slot = vmx_find_loadstore_msr_slot(autostore, msr_index);
-	in_autostore_list = msr_autostore_slot >= 0;
-	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
-
-	if (in_vmcs12_store_list && !in_autostore_list) {
-		if (autostore->nr == MAX_NR_LOADSTORE_MSRS) {
-			/*
-			 * Emulated VMEntry does not fail here.  Instead a less
-			 * accurate value will be returned by
-			 * nested_vmx_get_vmexit_msr_value() by reading KVM's
-			 * internal MSR state instead of reading the value from
-			 * the vmcs02 VMExit MSR-store area.
-			 */
-			pr_warn_ratelimited(
-				"Not enough msr entries in msr_autostore.  Can't add msr %x\n",
-				msr_index);
-			return;
-		}
-		last = autostore->nr++;
-		autostore->val[last].index = msr_index;
-	} else if (!in_vmcs12_store_list && in_autostore_list) {
-		last = --autostore->nr;
-		autostore->val[msr_autostore_slot] = autostore->val[last];
-	}
-}
-
 /*
  * Load guest's/host's cr3 at nested entry/exit.  @nested_ept is true if we are
  * emulating VM-Entry into a guest with EPT enabled.  On failure, the expected
@@ -2699,12 +2659,25 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	}
 
 	/*
-	 * Make sure the msr_autostore list is up to date before we set the
-	 * count in the vmcs02.
+	 * If vmcs12 is configured to save TSC on exit via the auto-store list,
+	 * append the MSR to vmcs02's auto-store list so that KVM effectively
+	 * reads TSC at the time of VM-Exit from L2.  The saved value will be
+	 * propagated to vmcs12's list on nested VM-Exit.
+	 *
+	 * Don't increment the number of MSRs in the vCPU structure, as saving
+	 * TSC is specific to this particular incarnation of vmcb02, i.e. must
+	 * not bleed into vmcs01.
 	 */
-	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
+	if (nested_msr_store_list_has_msr(&vmx->vcpu, MSR_IA32_TSC) &&
+	    !WARN_ON_ONCE(vmx->msr_autostore.nr >= ARRAY_SIZE(vmx->msr_autostore.val))) {
+		vmx->nested.tsc_autostore_slot = vmx->msr_autostore.nr;
+		vmx->msr_autostore.val[vmx->msr_autostore.nr].index = MSR_IA32_TSC;
 
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
+		vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr + 1);
+	} else {
+		vmx->nested.tsc_autostore_slot = -1;
+		vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
+	}
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23c92c41fd83..52bcb817cc15 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1029,7 +1029,7 @@ static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
+static int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4ce653d729ca..3175fedb5a4d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -191,6 +191,7 @@ struct nested_vmx {
 	u16 vpid02;
 	u16 last_vpid;
 
+	int tsc_autostore_slot;
 	struct nested_vmx_msrs msrs;
 
 	/* SMM related state */
@@ -383,7 +384,6 @@ void vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx, unsigned int flags);
 unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx);
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs,
 		    unsigned int flags);
-int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
 void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool set);
-- 
2.52.0.223.gf5cc29aaa4-goog


