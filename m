Return-Path: <kvm+bounces-47808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1FAAC59BE
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 094791BA4D51
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD3C27E7C8;
	Tue, 27 May 2025 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSlgZtw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD8B280A5A
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368977; cv=none; b=Ti5KFLVriO1XrlOb6WGIXfa1iVUGjJ60KQF5Bb8sFwTu24P31cze6hy2L8tbWiEvf7T/S+/dZIV3tYV9tbnqrNrSevRvexF1OdZUw/3ELrPlWbJ9jQYZjQky3v+tKlgfSeyvq/Bv8wqTGzRpig5bL96Q+JstVO2J8kym37ekSBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368977; c=relaxed/simple;
	bh=RaF8YEEhxc7z3y5xGKW8KDoDzyTLapjLfTFqRqKAAhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DpREGERJWSo38DoK5+Ml7iqvhx2H1bLq5m3HPbnGzDnDogQ7gN7y5nG5EFrY1U2pR0UCfUtFtziZcmvAhffsTycLHq1qsirhrj6opL6OrQ9LSRjdfDv/GazeQM4j6jxeuCeJHrxHWdG+BNAtTtnN9ecIuH25Puu3BrgfUdmhM30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VSlgZtw9; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a36bbfbd96so1331996f8f.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368973; x=1748973773; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N93IbLALKdYCf1GiKS11Qu3xpDb0jOxHx0uJTo/bq4Q=;
        b=VSlgZtw9P8s+/TAQO7zs3DSLt2hVI//eqgy0D0jR2Dblkr6zjuIhIHO3vonaHM2GHZ
         vLcr+MDAT2cMO9lE/xcswvtqlYKC/TLqWS4MInKjm/9mmFAaV3gsAnpX2YLa5QIPLF3Z
         gnA2i2oOWYGgl8b1/ZSDdJzLWJ/K1Tmt2cZWuwpChVMFmo3dvLGykoaNtORihUxten9k
         5USw8S7zJ3b8lzYT5/K0+dlNVSwKJV3hjtw+Hta8O2DA2N2+F77N83PzfSDJQd8ov2t4
         d19ZjHfKHmXVZuq4U93cC81dbtrA6YKWcHMFzQaQivYJAYev8S//Gp6hzdr5Qw6VuZuF
         6Nkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368973; x=1748973773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N93IbLALKdYCf1GiKS11Qu3xpDb0jOxHx0uJTo/bq4Q=;
        b=tXtks+v8Ddix+xh8uXVqr/dtjNR3lKgThOg8tlqZ7B9ZG16eVQcReRs++zXQZxDAar
         eXfYr9tH4/znEKpKhDtwSyGpgflnDlG3DTWls3LWVwHCKBEtiWRjPvNhAo2k2jfYvJue
         4lviNb33sjbGnWRyMCv5TLRTXrQ/Ub7YQ5eWjGIMTr5JJpip5mBgp7hpBtjE48a20Md0
         hKz5SkF/pDLm6RwNQX98QLmnVz5JUkGxpW0px8sGCX7qOxdjArQKdSWm8VJI4+fX02X4
         qoeDmvE8lXU1jqbabligRBXnpUiWB9cfdF9nEbll4Ly2y4mKyFvXKpe+6DWEAt9khu6B
         t3lA==
X-Gm-Message-State: AOJu0Yyea8UhrY5qtGNhKy7JZEK2SmCp8/fo8BYm1lIx/Mbl0kYTwbCo
	Xa3O2/oW7gZUXOjxM9aAp48XXOtpexOsgqTVVdr/IELRohAkeih8/Eh1IvYiYKZRWUA6PQomB6e
	vemGIP+lrJJkYAfdvpHcitoVHtQLxBXW7frj4MMiUlru72/z3KD0vEgu6CTYnrmFgR5GUtHZaV2
	0EnncBNioPO0QPIjaCzQ4cqaeF+r8=
X-Google-Smtp-Source: AGHT+IGz6MIl22so8xg2Skb3Oh+5iI9gcMMAR/8wKnp3bzW9/kLtp8Rg4Ad4rhI5QSegPiDbuPORXHvyyA==
X-Received: from wrbck12.prod.google.com ([2002:a5d:5e8c:0:b0:3a4:cf7c:16c3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5846:0:b0:3a4:dd63:4ae0
 with SMTP id ffacd0b85a97d-3a4dd634d88mr6208111f8f.35.1748368972426; Tue, 27
 May 2025 11:02:52 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:32 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-4-tabba@google.com>
Subject: [PATCH v10 03/16] KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function kvm_arch_has_private_mem() is used to indicate whether
guest_memfd is supported by the architecture, which until now implies
that its private. To decouple guest_memfd support from whether the
memory is private, rename this function to kvm_arch_supports_gmem().

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++----
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 include/linux/kvm_host.h        | 6 +++---
 virt/kvm/kvm_main.c             | 6 +++---
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52f6f6d08558..4a83fbae7056 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2254,9 +2254,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 
 
 #ifdef CONFIG_KVM_GMEM
-#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
+#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
 #else
-#define kvm_arch_has_private_mem(kvm) false
+#define kvm_arch_supports_gmem(kvm) false
 #endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
@@ -2309,8 +2309,8 @@ enum {
 #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
 
 # define KVM_MAX_NR_ADDRESS_SPACES	2
-/* SMM is currently unsupported for guests with private memory. */
-# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
+/* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
+# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
 # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 #else
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d1b632e33d2..b66f1bf24e06 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4917,7 +4917,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	if (kvm_arch_has_private_mem(vcpu->kvm) &&
+	if (kvm_arch_supports_gmem(vcpu->kvm) &&
 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
 		error_code |= PFERR_PRIVATE_ACCESS;
 
@@ -7705,7 +7705,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
 	 * a hugepage can be used for affected ranges.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
@@ -7784,7 +7784,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * a range that has PRIVATE GFNs, and conversely converting a range to
 	 * SHARED may now allow hugepages.
 	 */
-	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
+	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
 		return false;
 
 	/*
@@ -7840,7 +7840,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
 {
 	int level;
 
-	if (!kvm_arch_has_private_mem(kvm))
+	if (!kvm_arch_supports_gmem(kvm))
 		return;
 
 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ca23837fa52..6ca7279520cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -719,11 +719,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 #endif
 
 /*
- * Arch code must define kvm_arch_has_private_mem if support for private memory
+ * Arch code must define kvm_arch_supports_gmem if support for guest_memfd
  * is enabled.
  */
-#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
+static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 {
 	return false;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4996cac41a8f..2468d50a9ed4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,7 +1531,7 @@ static int check_memory_region_flags(struct kvm *kvm,
 {
 	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
 
-	if (kvm_arch_has_private_mem(kvm))
+	if (kvm_arch_supports_gmem(kvm))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
 	/* Dirty logging private memory is not currently supported. */
@@ -2362,7 +2362,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
-	if (!kvm || kvm_arch_has_private_mem(kvm))
+	if (!kvm || kvm_arch_supports_gmem(kvm))
 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
 	return 0;
@@ -4844,7 +4844,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #endif
 #ifdef CONFIG_KVM_GMEM
 	case KVM_CAP_GUEST_MEMFD:
-		return !kvm || kvm_arch_has_private_mem(kvm);
+		return !kvm || kvm_arch_supports_gmem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.1164.gab81da1b16-goog


