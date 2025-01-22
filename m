Return-Path: <kvm+bounces-36263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EB4A1953B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F607188D840
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4679A2144DC;
	Wed, 22 Jan 2025 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GTvRmw+C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BDA2144D7
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559679; cv=none; b=ayo07b9vQfTzovI0oRFA32q70gVmC35l2I/U5xbjl6HjZbTybuKIRb6P9BwTnmXjJUXRuFnslvCwsOZJoK+15Rh+BDsf6zh5WiUTsniYQ2aXKgtKlUB7g6rQcsoo6LY5FXj6RuDrAbjjnITA8cv0KA3ycDlFKNQMrQazdGV0Vec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559679; c=relaxed/simple;
	bh=8w1WTqUiK31jfnTfzyxBwRvu7b+mgoYkGXHFHXBaL1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cixttKfTJHTZ0/xZGXqPJtKNnzwTDfyM0h2bOZRLXxCGFPEczVR9Dh2vLh7ouip6LI3mrUnVRhKogY1R5PcBxhbzvU7NgTBfpoS3+EGB2jtzRHNWyeg1eutfYSt1yZfMJI8vrmGSQOV3XS+BJELxf43GnE3ysCRp+qZzsgYEoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GTvRmw+C; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361b090d23so36980065e9.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559676; x=1738164476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5uY+HDVZ7Dp1D+/uAf3D/YK52BSVzxXpdvAU1b299wE=;
        b=GTvRmw+CLXwi8VUf7MZYCwMfeg7efMiqq6BZXTwFJ8YooPfwWLgDZaLKY82EiXcKad
         jEseKbLdHEThE9gktHp0naTHduTzzBSS30MB0uF/+Q6g++6GTGP56ZDbOhJit75BKMQI
         GIStQ2XAAJGC6akFl82WVDhFeP1d2+3FHS/B12Vnv9WtEsLf443wRalX2hBsIDkYdz3m
         pgWpElBLWdzJwpCTHZtl63Y+bEkLV+qpusQoa99rEQYvBsHCKfxOfJLXdon7tRs5t0H+
         mvWrtt/Bik9wCoCjJXQZ01HYKjDwcgn0VPy7XrECz28iMJQi/SYY/8xgLyL8WnqK3Z7f
         IPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559676; x=1738164476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5uY+HDVZ7Dp1D+/uAf3D/YK52BSVzxXpdvAU1b299wE=;
        b=hHsjeygDQG0Z4QF07YeThvLrAZ9CJi7jJl3wA7v+n6fA4tZqPm8bDMa4wkR8t738cL
         NKU7fXPlF+Pv3YxRF9KKXeyxxU4taGq4MdeuEu4zrVce6R7B2jHJi9ekuZkCTJxxg14V
         sBkj7DtFz8BmHxQEauvYYS0nn/6miY8e6Ex57LwO/XqbSn7Di2OjOah7GltJCh8JA1yU
         n+8pXikZKyelAUM18CViDi91TMIHUJttPA0+Vv9PQLaZbTM0tBILjIBkAa7pOwWwO3Xs
         2CoBpDWc17Pp1bhOZ6H/YGxFl/BYuCw9QjEZteLrXQs3V8z/vtiZAGeh+ChxfkPWQIBY
         Oksw==
X-Gm-Message-State: AOJu0YzIj6iRtKvCz1UgcTGkKMhXI0ZSD5G53dklUhHR47ysPysSh2ws
	jD8UmRs8U8wS3D8/eZgWUnqhyUnq7k6orNKSAfRKm/EsRsjJfc60fOxd1YMUs2Wt/3NBmW0cNlA
	4TlTL09koNnU1LcL/34XMOgwpCiKVPTzkwNtWylYpOVSkAsbBO8rjWajyDlqtzqyiDGDUWcZwG4
	gNuGKlinbz1wTThsqSEUHi4f4=
X-Google-Smtp-Source: AGHT+IF2hKFLXA7PBCoJ+LiMdi1Un48iNomJH581YLTvT7wM4Qq5KK+uhWlMUrwC1rIHE2BbM0N2m173nA==
X-Received: from wmom15.prod.google.com ([2002:a05:600c:460f:b0:436:1a60:654e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4894:b0:434:a7e7:a1ca
 with SMTP id 5b1f17b1804b1-43891427762mr182016925e9.20.1737559675909; Wed, 22
 Jan 2025 07:27:55 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:36 +0000
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-8-tabba@google.com>
Subject: [RFC PATCH v1 7/9] KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED
 machine type
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Introduce a new virtual machine type,
KVM_VM_TYPE_ARM_SW_PROTECTED, to serve as a development and
testing vehicle for Confidential (CoCo) VMs, similar to the x86
KVM_X86_SW_PROTECTED_VM type.

Initially, this is used to test guest_memfd without needing any
underlying protection.

Similar to the x86 type, this is currently only for development
and testing.  Do not use KVM_VM_TYPE_ARM_SW_PROTECTED for "real"
VMs, and especially not in production. The behavior and effective
ABI for software-protected VMs is unstable.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst    |  5 +++++
 arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/mmu.c              |  3 ---
 include/uapi/linux/kvm.h          |  6 ++++++
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f15b61317aad..7953b07c8c2b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -214,6 +214,11 @@ exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
 size of the address translated by the stage2 level (guest physical to
 host physical address translations).
 
+KVM_VM_TYPE_ARM_SW_PROTECTED is currently only for development and testing of
+confidential VMs without having underlying support. Do not use
+KVM_VM_TYPE_ARM_SW_PROTECTED for "real" VMs, and especially not in production.
+The behavior and effective ABI for software-protected VMs is unstable.
+
 
 4.3 KVM_GET_MSR_INDEX_LIST, KVM_GET_MSR_FEATURE_INDEX_LIST
 ----------------------------------------------------------
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..2fdc7e24ae8e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,6 +380,8 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	unsigned long vm_type;
 };
 
 struct kvm_vcpu_fault_info {
@@ -1529,4 +1531,12 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1poe(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
+#define kvm_arch_has_private_mem(kvm)			\
+	(IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&		\
+	 ((kvm)->arch.vm_type & KVM_VM_TYPE_ARM_SW_PROTECTED))
+
+#define kvm_arch_private_mem_inplace(kvm)		\
+	(IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE) &&	\
+	 ((kvm)->arch.vm_type & KVM_VM_TYPE_ARM_SW_PROTECTED))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..ecdb8db619d8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -171,6 +171,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret;
 
+	if (type & ~KVM_VM_TYPE_MASK)
+		return -EINVAL;
+
 	mutex_init(&kvm->arch.config_lock);
 
 #ifdef CONFIG_LOCKDEP
@@ -212,6 +215,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
 
+	kvm->arch.vm_type = type;
+
 	return 0;
 
 err_free_cpumask:
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index adf23618e2a0..b6cbe11dea48 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -869,9 +869,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	u64 mmfr0, mmfr1;
 	u32 phys_shift;
 
-	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
-		return -EINVAL;
-
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
 	if (is_protected_kvm_enabled()) {
 		phys_shift = kvm_ipa_limit;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 021f8ef9979b..5e10a5903a58 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -656,6 +656,12 @@ struct kvm_enable_cap {
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
+#define KVM_VM_TYPE_ARM_SW_PROTECTED	(1UL << 9)
+
+#define KVM_VM_TYPE_MASK	(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
+				 KVM_VM_TYPE_ARM_SW_PROTECTED)
+
 /*
  * ioctls for /dev/kvm fds:
  */
-- 
2.48.0.rc2.279.g1de40edade-goog


