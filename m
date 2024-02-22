Return-Path: <kvm+bounces-9404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CC085FDBB
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CB0EB239C2
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB72C153BE9;
	Thu, 22 Feb 2024 16:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tp7npkon"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3993E153BC8
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618273; cv=none; b=XTRr/ouNqoG4rIEFmUZsGO4ftgdi9kXFipTqcBVNKIqH+IMl0O5+mhI1qOGIlsX/WRQ5Nt/gvagMooRcZeip+Kt2IcqLibu1rWTQGBSsNDyMCECJ3AznabpwRUGdBa7neOBdlT0yLR03RkPcpdo6JtcMt6WCuqGQfmglQnbGuJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618273; c=relaxed/simple;
	bh=InUUDTACv6VX9/UAFGNNoTeO7aRvGZf8iSQOeGU6ZBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W7f/xOlkz4N9TatkcOxXWyElQHqS9oJmUpEmorH+MNcBS3PXvUtmiHEMXuv0ZNIvjOqpOq2IaB0lsJr/sH9heeqDpJd3zxz3wfsxx0YJFlqMCVVQFNmywtHe+MXAD4mPC0ii6wycyEnsT+0sVV1026Q98dkB6C1csP3YLsA5IA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tp7npkon; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6089b90acddso14488387b3.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618270; x=1709223070; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c52r9LFDD4vblm2kGafNlF4FoWtGpxH68baRwt3dKTw=;
        b=tp7npkon7oBKLXJIggvsKV2YanvvfIXEaab+gr1HB4NMqw236XL0HOTUxJkaICAxus
         EIYM1XVQGl2F6NjMLBU/cB0+xKaZtUErXYo7Ar7JmDBZ/fcNBf5k8hC+8DmN6S/M25W7
         n/M5EPxTQy8y3U8JKAgGte8BkgnaRHx5ANDg52NZun/GaWWynjII5c2EjmjVJl7dH8Yk
         bYBrAlinJUgZOx+Oyn8Ph0ZOc//HgUwZ4fOKR7aCwURZ+D+Eiz15tRYiPJ4VAIXErZLW
         XmWkCO+z0N49V8c2FHp5TQi9xwxGhY2orGa/75M1e9WxA85nLbVkxAsPco25mYwS3QEE
         roYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618270; x=1709223070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c52r9LFDD4vblm2kGafNlF4FoWtGpxH68baRwt3dKTw=;
        b=d98AQ3m8zb77ZnuZeeEsNadIdTj64uGji2bl2hlH4gvnQ1PlI7jzY+9oerMBeDm7LS
         EQrXVt3ImziddvaOjClen4/0SFHGXinwLkpmknrC4m3qSNKR7nujWQekxNiWid6BSlku
         CAaWnY4W2i4L4qIswVS06Dml0exOAzcg484yIC3hOcs8WvX5EYWiNjJSAc1Cjjum+etz
         Wb6oOwxOBKgovsIeP/jxCF/NIwjGJaonU+iUuei7hiofx5f3IFEA/ROkwZxPaO6Sd4ag
         E7hDRL1nOLNaGBMbx1szgdk+W44MUV5DpVlFSpXqGVtc6Q98VVjfYgpPJG8kZFvW7656
         cfIw==
X-Gm-Message-State: AOJu0Yw219Uivg3G6PBGlmP3pPyv90XSfuikj69aGlYN7NCQ4i/1GnDk
	IAzXggsEHPMDj+Qycu5IIpGeboVS6BgqjxrUCljUPjV3WxDgnfofTXWN8xH8iP01iPmz3aQGZXw
	2Gw8vCluJI17BK6JTUUVesVL/NTLBrruN71FG2RFyd0DnRSOxIGw0ah+X9EV3B8CknNasNu2gao
	+Q3zbp5ucG7CXCJm4F7oNvDiw=
X-Google-Smtp-Source: AGHT+IEqqbSvb3HGyfr2MPY1kOQvtF2/nFLxJvaMG/qkPuOVmHOmLXolwq3JOzoj5YKs3LXmEsrebIjr0A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:490d:0:b0:604:42a3:3adc with SMTP id
 w13-20020a81490d000000b0060442a33adcmr2006803ywa.10.1708618269856; Thu, 22
 Feb 2024 08:11:09 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:29 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-9-tabba@google.com>
Subject: [RFC PATCH v1 08/26] KVM: arm64: Implement MEM_RELINQUISH SMCCC hypercall
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Keir Fraser <keirf@google.com>

This allows a VM running on PKVM to notify the hypervisor (and host)
that it is returning pages to host ownership.

Signed-off-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h             |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 30 +++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 83 +++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/switch.c              |  1 +
 arch/arm64/kvm/hypercalls.c                   | 19 ++++-
 arch/arm64/kvm/pkvm.c                         | 35 ++++++++
 include/linux/arm-smccc.h                     |  7 ++
 10 files changed, 173 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 60b2d4965e4a..ea9d9529e412 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -22,6 +22,7 @@ int pkvm_init_host_vm(struct kvm *kvm, unsigned long type);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 bool pkvm_is_hyp_created(struct kvm *kvm);
+void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa);
 
 /*
  * Definitions for features to be allowed or restricted for guest virtual
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 973983d78f31..a20e5b9426ce 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -75,6 +75,8 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *hyp_vcpu, u64 ipa);
+int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
+				    u64 ipa, u64 *ppa);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 7940a042289a..094599692187 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -113,6 +113,7 @@ int kvm_check_pvm_sysreg_table(void);
 void pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
 
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_hyp_handle_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 
 struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, u64 mpidr);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1fd419cef3db..1c93c225915b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -85,6 +85,8 @@ static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
 		fallthrough;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		fallthrough;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
 		vcpu_set_reg(&hyp_vcpu->vcpu, 0, SMCCC_RET_SUCCESS);
 		break;
 	default:
@@ -253,6 +255,8 @@ static void handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
 		fallthrough;
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
+		fallthrough;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
 		n = 4;
 		break;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 899164515e0c..1dd8eee1ab28 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -321,6 +321,36 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	}
 }
 
+int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
+				    u64 ipa, u64 *ppa)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb     = reclaim_walker,
+		.arg    = ppa,
+		.flags  = KVM_PGTABLE_WALK_LEAF
+	};
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	/* Set default pa value to "not found". */
+	*ppa = 0;
+
+	/* If ipa is mapped: sets page flags, and gets the pa. */
+	ret = kvm_pgtable_walk(&vm->pgt, ipa, PAGE_SIZE, &walker);
+
+	/* Zap the guest stage2 pte. */
+	if (!ret)
+		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_prot_finalize(void)
 {
 	struct kvm_s2_mmu *mmu = &host_mmu.arch.mmu;
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 199ad51f1169..4209c75e7fba 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -1258,6 +1258,54 @@ static bool pkvm_memunshare_call(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return true;
 }
 
+static bool pkvm_meminfo_call(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u64 arg1 = smccc_get_arg1(vcpu);
+	u64 arg2 = smccc_get_arg2(vcpu);
+	u64 arg3 = smccc_get_arg3(vcpu);
+
+	if (arg1 || arg2 || arg3)
+		goto out_guest_err;
+
+	smccc_set_retval(vcpu, PAGE_SIZE, 0, 0, 0);
+	return true;
+
+out_guest_err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return true;
+}
+
+static bool pkvm_memrelinquish_call(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u64 ipa = smccc_get_arg1(vcpu);
+	u64 arg2 = smccc_get_arg2(vcpu);
+	u64 arg3 = smccc_get_arg3(vcpu);
+	u64 pa = 0;
+	int ret;
+
+	if (arg2 || arg3)
+		goto out_guest_err;
+
+	ret = __pkvm_guest_relinquish_to_host(hyp_vcpu, ipa, &pa);
+	if (ret)
+		goto out_guest_err;
+
+	if (pa != 0) {
+		/* Now pass to host. */
+		return false;
+	}
+
+	/* This was a NOP as no page was actually mapped at the IPA. */
+	smccc_set_retval(vcpu, 0, 0, 0, 0);
+	return true;
+
+out_guest_err:
+	smccc_set_retval(vcpu, SMCCC_RET_INVALID_PARAMETER, 0, 0, 0);
+	return true;
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -1288,20 +1336,16 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_UNSHARE);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_RELINQUISH);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
-		if (smccc_get_arg1(vcpu) ||
-		    smccc_get_arg2(vcpu) ||
-		    smccc_get_arg3(vcpu)) {
-			val[0] = SMCCC_RET_INVALID_PARAMETER;
-		} else {
-			val[0] = PAGE_SIZE;
-		}
-		break;
+		return pkvm_meminfo_call(hyp_vcpu);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
 		return pkvm_memshare_call(hyp_vcpu, exit_code);
 	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID:
 		return pkvm_memunshare_call(hyp_vcpu);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
+		return pkvm_memrelinquish_call(hyp_vcpu);
 	default:
 		return pkvm_handle_psci(hyp_vcpu);
 	}
@@ -1309,3 +1353,26 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return true;
 }
+
+/*
+ * Handler for non-protected VM HVC calls.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+bool kvm_hyp_handle_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u32 fn = smccc_get_function(vcpu);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
+
+	switch (fn) {
+	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
+		return pkvm_meminfo_call(hyp_vcpu);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
+		return pkvm_memrelinquish_call(hyp_vcpu);
+	}
+
+	return false;
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 31c46491e65a..12b7d56d3842 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -185,6 +185,7 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
+	[ESR_ELx_EC_HVC64]		= kvm_hyp_handle_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..89b5b61bc9f7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_pkvm.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
@@ -13,8 +14,15 @@
 	GENMASK(KVM_REG_ARM_STD_BMAP_BIT_COUNT - 1, 0)
 #define KVM_ARM_SMCCC_STD_HYP_FEATURES				\
 	GENMASK(KVM_REG_ARM_STD_HYP_BMAP_BIT_COUNT - 1, 0)
-#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES			\
-	GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT - 1, 0)
+#define KVM_ARM_SMCCC_VENDOR_HYP_FEATURES ({				\
+	unsigned long f;						\
+	f = GENMASK(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT - 1, 0);	\
+	if (is_protected_kvm_enabled()) {				\
+		f |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);		\
+		f |= BIT(ARM_SMCCC_KVM_FUNC_MEM_RELINQUISH);		\
+	}								\
+	f;								\
+})
 
 static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 {
@@ -116,6 +124,9 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vcpu, u32 func_id)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
+		return test_bit(ARM_SMCCC_KVM_FUNC_MEM_RELINQUISH,
+				&smccc_feat->vendor_hyp_bmap);
 	default:
 		return false;
 	}
@@ -364,6 +375,10 @@ int kvm_smccc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID:
+		pkvm_host_reclaim_page(vcpu->kvm, smccc_get_arg1(vcpu));
+		val[0] = SMCCC_RET_SUCCESS;
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 11355980e18d..713bbb023177 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -24,6 +24,14 @@ static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
 phys_addr_t hyp_mem_base;
 phys_addr_t hyp_mem_size;
 
+static int rb_ppage_cmp(const void *key, const struct rb_node *node)
+{
+       struct kvm_pinned_page *p = container_of(node, struct kvm_pinned_page, node);
+       phys_addr_t ipa = (phys_addr_t)key;
+
+       return (ipa < p->ipa) ? -1 : (ipa > p->ipa);
+}
+
 static int cmp_hyp_memblock(const void *p1, const void *p2)
 {
 	const struct memblock_region *r1 = p1;
@@ -330,3 +338,30 @@ static int __init finalize_pkvm(void)
 	return ret;
 }
 device_initcall_sync(finalize_pkvm);
+
+void pkvm_host_reclaim_page(struct kvm *host_kvm, phys_addr_t ipa)
+{
+	struct kvm_pinned_page *ppage;
+	struct mm_struct *mm = current->mm;
+	struct rb_node *node;
+
+	write_lock(&host_kvm->mmu_lock);
+	node = rb_find((void *)ipa, &host_kvm->arch.pkvm.pinned_pages,
+		       rb_ppage_cmp);
+	if (node)
+		rb_erase(node, &host_kvm->arch.pkvm.pinned_pages);
+	write_unlock(&host_kvm->mmu_lock);
+
+	WARN_ON(!node);
+	if (!node)
+		return;
+
+	ppage = container_of(node, struct kvm_pinned_page, node);
+
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
+				  page_to_pfn(ppage->page)));
+
+	account_locked_vm(mm, 1, false);
+	unpin_user_pages_dirty_lock(&ppage->page, 1, true);
+	kfree(ppage);
+}
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 9cb7c95920b0..ec85f1be2040 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -118,6 +118,7 @@
 #define ARM_SMCCC_KVM_FUNC_HYP_MEMINFO		2
 #define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
 #define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
+#define ARM_SMCCC_KVM_FUNC_MEM_RELINQUISH	9
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -158,6 +159,12 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
 
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_RELINQUISH_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_RELINQUISH)
+
 /* ptp_kvm counter type ID */
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
-- 
2.44.0.rc1.240.g4c46232300-goog


