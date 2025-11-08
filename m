Return-Path: <kvm+bounces-62380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D756CC423E6
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 02:36:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 994BD3AD90C
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 01:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CE028980F;
	Sat,  8 Nov 2025 01:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sJPtxveR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FBBBA45
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 01:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565766; cv=none; b=H6WDnwxX+gxrH+lpA5TDob7xi1/d7ZXD7SEzBBvJgSvzrRPb+Oaz4ja0D9NmU+f/VGZMPGj31vm60CDUmV8TdFzadtc1r1LzRCEusZv6XEec4Ykue2ap6pY6F75fLBtGeq1sQR76OwFwFOkYS9eVft2D+j4/DQz1/tkcoCLQN2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565766; c=relaxed/simple;
	bh=fuyWxbBhFRzVlhEb1d7Ax5pvnMcMxgWPJBvojd6LEcA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sgyoV7pr2jlADGGSH05AiWwUV4YqfxFrDviZe5BJC+qyto9o71Dtfj5URZ4aSC1MPDj3Sea9Or8dFSwKSKzHDwblMmYu3TWlfJnH9zW8xcIl+O7LAAmDUMVvVueetcRb6du9MzNHjoAAW4vVZymcu5Q6XUZdHH8hdtaZ+PKj6Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sJPtxveR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297dfae179bso7975325ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Nov 2025 17:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762565764; x=1763170564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u0gSVyaHm/RFZz43PnqJfIa7tkp5FemZN1Pt+86XgAQ=;
        b=sJPtxveRIB/QtPb0+MW2+77KSTfQUZUg+Rz8TGpAsS3InNOb6UyckDYdkeAND5v9UE
         e4qh2z5RX+KJR79kRJI2Ta/kJHtbSIGvx8bNXo3DScXvsxUPTY76EB15vQKIGT/36wsj
         wtfxymlk5xogJiqEy6dfFrkgu2OwHFZJndy4BNSyTHoknitUGkzX2unH2PoiIfBAcTMX
         tNaqrzRhpEh3JkvpM1MJHWar5I6DPODxr+O64ZoibPcMVwtInUojr4HDJ2sGOvYd6tC7
         7ggdY1qi31hxqyLnKRmnVePF2VP152grAXA/JmhmA4eZIvqWXT7KQ3jt02nFiHq/BPZW
         a2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762565764; x=1763170564;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0gSVyaHm/RFZz43PnqJfIa7tkp5FemZN1Pt+86XgAQ=;
        b=jMJD6o4HiqbAl0UWOxj86C0rNUwtOBz2pO7TM2UpjGUPjwA+Y8q0wmTTdxYjk4L9LS
         frPgXR5gxpSFtdUfmgxBRXRH1bN+5f4Ny/fq/FT2PbA+XDHpWPOADZENRlyL4Q92V0oE
         EznG25TbB4VZkuocw+xpBNTs3ZeIGw/DOsFKfdi63rzK0rs290K+QFz7CSAqndkDsHSL
         2EqUz0C967a1EFhOIiZUMsj+xWlnL8RyZxqLN5zYUPi6w3SDXkwot+8Ox6KbaxC3GGo0
         swVnEovjsAsjh8LYSJE4IwKkwXJ/dJfNDwftn4ldfekUvPHqwu87kmDFHYFrZICv9ynx
         J+lw==
X-Gm-Message-State: AOJu0YzmXLfpIdLOf8Bxo1ZhE6P67Uc2Hcx+FNvQ/mt0jgcE7kvLfN0F
	HrlfPma3hWordoTRZxTtKoflGnd2qlbiyGCUXDkq3EhbBoedao87EfDb51Mm2ps5/rQ/ijpt1NT
	eY9JQQg==
X-Google-Smtp-Source: AGHT+IHpztq6CsL06buHflHDop5NaQ1I+bKM6en+6ybPVhUoSJG/Csnx0VRAnVSCj9mVmv1MaDNZn1NHdwg=
X-Received: from pgac20.prod.google.com ([2002:a05:6a02:2954:b0:bac:6acd:8180])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:b715:b0:295:8db9:305f
 with SMTP id d9443c01a7336-297e56be263mr8254205ad.34.1762565764001; Fri, 07
 Nov 2025 17:36:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Nov 2025 17:36:01 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251108013601.902918-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
 (un)loading time
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Move user_return_msrs allocation/free from vendor modules (kvm-intel.ko and
kvm-amd.ko) (un)loading time to kvm.ko's to make it less risky to access
user_return_msrs in kvm.ko. Tying the lifetime of user_return_msrs to
vendor modules makes every access to user_return_msrs prone to
use-after-free issues as vendor modules may be unloaded at any time.

Opportunistically turn the per-CPU variable into full structs, as there's
no practical difference between statically allocating the memory and
allocating it unconditionally during module_init().

Zero out kvm_nr_uret_msrs on vendor module exit to further minimize the
chances of consuming stale data, and WARN on vendor module load if KVM
thinks there are existing user-return MSRs.

Note!  The user-return MSRs also need to be "destroyed" if
ops->hardware_setup() fails, as both SVM and VMX expect common KVM to
clean up (because common code, not vendor code, is responsible for
kvm_nr_uret_msrs).

Signed-off-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c2e28028c2b..24dba35f3217 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -212,7 +212,7 @@ struct kvm_user_return_msrs {
 u32 __read_mostly kvm_nr_uret_msrs;
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_nr_uret_msrs);
 static u32 __read_mostly kvm_uret_msrs_list[KVM_MAX_NR_USER_RETURN_MSRS];
-static struct kvm_user_return_msrs __percpu *user_return_msrs;
+static DEFINE_PER_CPU(struct kvm_user_return_msrs, user_return_msrs);
 
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
@@ -575,25 +575,14 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.apf.gfns[i] = ~0;
 }
 
-static int kvm_init_user_return_msrs(void)
+static void kvm_destroy_user_return_msrs(void)
 {
-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
-	if (!user_return_msrs) {
-		pr_err("failed to allocate percpu user_return_msrs\n");
-		return -ENOMEM;
-	}
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		WARN_ON_ONCE(per_cpu(user_return_msrs, cpu).registered);
+
 	kvm_nr_uret_msrs = 0;
-	return 0;
-}
-
-static void kvm_free_user_return_msrs(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
-
-	free_percpu(user_return_msrs);
 }
 
 static void kvm_on_user_return(struct user_return_notifier *urn)
@@ -656,7 +645,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_find_user_return_msr);
 
 static void kvm_user_return_msr_cpu_online(void)
 {
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(&user_return_msrs);
 	u64 value;
 	int i;
 
@@ -678,7 +667,7 @@ static void kvm_user_return_register_notifier(struct kvm_user_return_msrs *msrs)
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(&user_return_msrs);
 	int err;
 
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
@@ -696,13 +685,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
 
 u64 kvm_get_user_return_msr(unsigned int slot)
 {
-	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
+	return this_cpu_ptr(&user_return_msrs)->values[slot].curr;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(&user_return_msrs);
 
 	if (msrs->registered)
 		kvm_on_user_return(&msrs->urn);
@@ -10077,13 +10066,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -ENOMEM;
 	}
 
-	r = kvm_init_user_return_msrs();
-	if (r)
-		goto out_free_x86_emulator_cache;
-
 	r = kvm_mmu_vendor_module_init();
 	if (r)
-		goto out_free_percpu;
+		goto out_free_x86_emulator_cache;
 
 	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
 	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
@@ -10108,6 +10093,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrq(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
 
+	WARN_ON_ONCE(kvm_nr_uret_msrs);
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
@@ -10180,9 +10167,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kvm_x86_ops.enable_virtualization_cpu = NULL;
 	kvm_x86_call(hardware_unsetup)();
 out_mmu_exit:
+	kvm_destroy_user_return_msrs();
 	kvm_mmu_vendor_module_exit();
-out_free_percpu:
-	kvm_free_user_return_msrs();
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
 	return r;
@@ -10210,8 +10196,8 @@ void kvm_x86_vendor_exit(void)
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_call(hardware_unsetup)();
+	kvm_destroy_user_return_msrs();
 	kvm_mmu_vendor_module_exit();
-	kvm_free_user_return_msrs();
 	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
 	static_key_deferred_flush(&kvm_xen_enabled);

base-commit: 9052f4f6c539ea1fb7b282a34e6bb33154ce0b63
-- 
2.51.2.1041.gc1ab5b90ca-goog


