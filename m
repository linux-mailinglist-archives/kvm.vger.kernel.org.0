Return-Path: <kvm+bounces-60267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCE6BE5F87
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B04EE4F8327
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226952C21DC;
	Fri, 17 Oct 2025 00:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBGRhlRn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA61C2DAFCA
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661215; cv=none; b=rqwYkd7oHdfGhxQ+OrEg/68Yn9KXfE5uEtYcTLteP2SlWEwmOmGUGa/pQTwwr591iS4/cFkAfyKEX4hICQdo6NV3ZDrTjeDIzohcD3XGtu+f1U8xhaL1shOknmCj9/zIKyrZ7SJEjm9VOaLNecIwesznvNJ16hiJqdkht6cRtZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661215; c=relaxed/simple;
	bh=Bv2JFpVKbSOr8w26IO6QkCIXhdunh/T2ahf6bwE6NCw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J671Ee7uo2+OwoXpnm6G1zQ/4uGRhRNDEsaqfyFHUuaQTNgdKTanS2m3d+PDDx00qynekjmwG8mF/fJzpML2CWC7uvgetdlfW/9gbWEOegG+yIxjl1ynPRNY/PAamvNsZaEpJbPasqKXYsM3FmZ9xMfD9D1oaKfTgdZEZnT0PQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBGRhlRn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so1211321a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661212; x=1761266012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/pSW/fUm0O3ay1Oo9bje5jBv9ucpW+KObLJe4y1pVWI=;
        b=iBGRhlRntFycHJp61W6uPCtjw066185c9WUSwfyFKn2wvPaHzqCEy4q/VnoYFxzYC8
         Wmz89f+f8Hx4wed0e178GuuUeCzocnNDdfylbXLmyxiHCf+i9IhjJHhParlKtiTgshoS
         ZUMCcoSEnfPspN3yfvacgNZjNjMqPlf4sU2HQYbED/VNMbUg8CQd6f+OcpRLJgzqTxnF
         gBUCTlchG17NGEOCmbUzEv38ommjKE0CgN2480Y/mzOjsWqituxXbyvkEPziX0LXO8Sg
         l41nqw6hHff/Ot9lguc+/JfVZ5DLQ9EmFxaiWgC0joB3wGrQRJ/ScilAEl16FEGoiUBY
         GEbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661212; x=1761266012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/pSW/fUm0O3ay1Oo9bje5jBv9ucpW+KObLJe4y1pVWI=;
        b=ls2y19gOCV1VjSs4gS22XCcTlV2syCz48cMOtEvlTkDHJ8+cn4xpcs3slbdb6s4Riz
         znSmI0cW4mvKYB4ac0zljkOCQLKLL7NgPRitS+VoKNyD9fYN3XEgpKggALsevHRuvQMX
         os9yLgu9eb4G6WQbd9LOgLSWBaKBDMNSvBQ1Qkg2GEEe9fNKGQK6PhiIoHWNNRfC2Imc
         IJqeZCe8YkArLVzXyE6FxSgTPLTYJBeQgmC77HvIFrang3m/izZu0BgDo44S4hiTAmzG
         Avvds4V4+dN+bOSnbB/d0QzXzWPgnEb7oq0Sg4YP+kxhk830gqZQjvmZ/ohERKSf0nHH
         EwxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLe7UohEIoD58jxfe5F/FafQ0MXtA9FJHDCHNh4rAXIgiSxp4W0znZmZoybEzOZ/0XBtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbGb18XXJCnZCse9HVe0tnvBnA6MR+0oIr8QI2wWhKpx6qhv+j
	u1ueniLdYQpDPbKFoi5sZ8AxrcCzCacrruL99OvR5QgGIBvDXNydX1xhs6Moz6cfynMhWqSV7UP
	PJYIIhA==
X-Google-Smtp-Source: AGHT+IGUYXYNMUKz1i83Pw6n8U7DCU7Wd9XYw4AfmAkZINqRiiLRcAvioXFznTZGlb6j2wOsKcjvQ1uSQcI=
X-Received: from pjsc19.prod.google.com ([2002:a17:90a:bf13:b0:33b:ab21:aff7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0f:b0:32e:8c14:5cd2
 with SMTP id 98e67ed59e1d1-33bcf8faac8mr1848079a91.28.1760661212029; Thu, 16
 Oct 2025 17:33:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:43 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-26-seanjc@google.com>
Subject: [PATCH v3 25/25] KVM: TDX: Fix list_add corruption during vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

During vCPU creation, a vCPU may be destroyed immediately after
kvm_arch_vcpu_create() (e.g., due to vCPU id confiliction). However, the
vcpu_load() inside kvm_arch_vcpu_create() may have associate the vCPU to
pCPU via "list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu))"
before invoking tdx_vcpu_free().

Though there's no need to invoke tdh_vp_flush() on the vCPU, failing to
dissociate the vCPU from pCPU (i.e., "list_del(&to_tdx(vcpu)->cpu_list)")
will cause list corruption of the per-pCPU list associated_tdvcpus.

Then, a later list_add() during vcpu_load() would detect list corruption
and print calltrace as shown below.

Dissociate a vCPU from its associated pCPU in tdx_vcpu_free() for the vCPUs
destroyed immediately after creation which must be in
VCPU_TD_STATE_UNINITIALIZED state.

kernel BUG at lib/list_debug.c:29!
Oops: invalid opcode: 0000 [#2] SMP NOPTI
RIP: 0010:__list_add_valid_or_report+0x82/0xd0

Call Trace:
 <TASK>
 tdx_vcpu_load+0xa8/0x120
 vt_vcpu_load+0x25/0x30
 kvm_arch_vcpu_load+0x81/0x300
 vcpu_load+0x55/0x90
 kvm_arch_vcpu_create+0x24f/0x330
 kvm_vm_ioctl_create_vcpu+0x1b1/0x53
 kvm_vm_ioctl+0xc2/0xa60
  __x64_sys_ioctl+0x9a/0xf0
 x64_sys_call+0x10ee/0x20d0
 do_syscall_64+0xc3/0x470
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d6541b08423f..daec88d4b88d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -833,19 +833,52 @@ void tdx_vcpu_put(struct kvm_vcpu *vcpu)
 	tdx_prepare_switch_to_host(vcpu);
 }
 
+/*
+ * Life cycles for a TD and a vCPU:
+ * 1. KVM_CREATE_VM ioctl.
+ *    TD state is TD_STATE_UNINITIALIZED.
+ *    hkid is not assigned at this stage.
+ * 2. KVM_TDX_INIT_VM ioctl.
+ *    TD transitions to TD_STATE_INITIALIZED.
+ *    hkid is assigned after this stage.
+ * 3. KVM_CREATE_VCPU ioctl. (only when TD is TD_STATE_INITIALIZED).
+ *    3.1 tdx_vcpu_create() transitions vCPU state to VCPU_TD_STATE_UNINITIALIZED.
+ *    3.2 vcpu_load() and vcpu_put() in kvm_arch_vcpu_create().
+ *    3.3 (conditional) if any error encountered after kvm_arch_vcpu_create()
+ *        kvm_arch_vcpu_destroy() --> tdx_vcpu_free().
+ * 4. KVM_TDX_INIT_VCPU ioctl.
+ *    tdx_vcpu_init() transitions vCPU state to VCPU_TD_STATE_INITIALIZED.
+ *    vCPU control structures are allocated at this stage.
+ * 5. kvm_destroy_vm().
+ *    5.1 tdx_mmu_release_hkid(): (1) tdh_vp_flush(), disassociates all vCPUs.
+ *                                (2) puts hkid to !assigned state.
+ *    5.2 kvm_destroy_vcpus() --> tdx_vcpu_free():
+ *        transitions vCPU to VCPU_TD_STATE_UNINITIALIZED state.
+ *    5.3 tdx_vm_destroy()
+ *        transitions TD to TD_STATE_UNINITIALIZED state.
+ *
+ * tdx_vcpu_free() can be invoked only at 3.3 or 5.2.
+ * - If at 3.3, hkid is still assigned, but the vCPU must be in
+ *   VCPU_TD_STATE_UNINITIALIZED state.
+ * - if at 5.2, hkid must be !assigned and all vCPUs must be in
+ *   VCPU_TD_STATE_INITIALIZED state and have been dissociated.
+ */
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int i;
 
+	if (vcpu->cpu != -1) {
+		KVM_BUG_ON(tdx->state == VCPU_TD_STATE_INITIALIZED, vcpu->kvm);
+		tdx_disassociate_vp(vcpu);
+		return;
+	}
+
 	/*
 	 * It is not possible to reclaim pages while hkid is assigned. It might
-	 * be assigned if:
-	 * 1. the TD VM is being destroyed but freeing hkid failed, in which
-	 * case the pages are leaked
-	 * 2. TD VCPU creation failed and this on the error path, in which case
-	 * there is nothing to do anyway
+	 * be assigned if the TD VM is being destroyed but freeing hkid failed,
+	 * in which case the pages are leaked.
 	 */
 	if (is_hkid_assigned(kvm_tdx))
 		return;
-- 
2.51.0.858.gf9c4a03a3a-goog


