Return-Path: <kvm+bounces-51912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F631AFE6BE
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 13:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EA284E412F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513BB28FAB3;
	Wed,  9 Jul 2025 11:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lUAK0yVk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA3E28DF08
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058803; cv=none; b=QYItX/cIYO286hdHBwt/0+4KTGSXu04fV9VASTx5rnArgkxScGnU1zHknNO4jEPpLGjtUgrTCQy+KSau+ySg7YjhRiskCpuzprlqIxCFe5qkgeWIwSxHLC410x5wDHspmrAS6roSfXoP2+xcL7FX+QzWnuO6Zy2wFnphTlzhnVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058803; c=relaxed/simple;
	bh=0OuzOJYPGireTSNTxyWHKEmPI2NB+k8Qn2NIiXdBEP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nhhVHYzD1QqQsSWKBUZgBNRBm7Kqmb2xQ9iEJJz5iC3lg5gRNiGmIQfuBa+CiLJiZnR7yeKjqp+AUa+vx9NhVAVXYAtifEZFh0vd5H8nfB51QXDZyRHlLuLth4lQegXHK736ZbqMLOSvL3/+cqkwQXTrhVLvEol3wbKNSgx7L+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lUAK0yVk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4536962204aso23265065e9.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 04:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058800; x=1752663600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9AmJt3JSIC2bm90ziNqKjnyGIAyeHrkJLic7hf5RL/M=;
        b=lUAK0yVkae1rNtOrloU3JjIKDafmueQZk0/fkNMUoVMkuZLv0ptDaO0V8hPzSE54Hr
         PnPwZV6ezKxEkeOthDrjKa9VbX49FE/CfYUbjfePlEuTyVKa4N5P0RdZx/wGN7d/wfSa
         pI8+n19dRQlSa3Sq9mQPXuEGVDoPzZX4h8NHMw/LW/qjTND6oJp5s0LViuXk6GKsAzWK
         53uI+ad9zzHppmNI9Cb0y+HyPJu0auqdsgDMKbqKB4bnN6yWdda8TuBCkgE5lD+3HmxW
         2A8nISgDCaDBZP9FAG8YvwwOmHwSIRWJlBAFtcsk8G2AB60RMV+PEaI+QK/iBi9X36Fi
         7oZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058800; x=1752663600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9AmJt3JSIC2bm90ziNqKjnyGIAyeHrkJLic7hf5RL/M=;
        b=RXlA+SrwfUMOMMnVDr9TC75blw2v8PGlY95qQmV4vdtSFfOdorstpn9hdMlisjgN2m
         3zNtjhShkj8upwlAtqAZU2F47NCLRerBBSjAlFEBcQIPMFjoTzgjjl6/WNt72d0qbt91
         BscmmO58nPkh1q618MIv3pz1iVuAVkISJyOm32hzOLihU42qk37ygC/eoAqlPa3KGjLr
         wpJTIM9h9mSRYc/S5+6ZToaO+/Buf4O1d9ldGp86NAcQWnCx/0x4R5aY0X02mpN/B0hQ
         +VW0wbePrBnMAlCQWRwgnTv2UhAkb5rF6EnpHfo4xB1iCbyFbvVkfmPttC5gQTccn1WJ
         h+9g==
X-Gm-Message-State: AOJu0YzIweurTajtYqepMqfAZpUrboVbfIxOWjJ1N1KlzXuHffYJXbUH
	CZb5m2LtAxhdawF5UqRbNfII3xxwSt8Bjlqnjqe1vVfzkBr2boPz20FZh/qjW6KhISMzbRmO82D
	Jv0HztMz2PDmZ3t/teyRJ4c7r4IuQ4aFyJ1Z3hotaxEBK/8IHuVtNHFEsGcBn7UftGaqfN3HIWa
	Zg3E8QiXhtNxfyddqqL9geqM/4nT4=
X-Google-Smtp-Source: AGHT+IE+2TZW+dbYocsnC6GGlK4Vi+081qpuZi8IBcmNih0IEcKRjGe3Hl0WX1Ir2nLOlb1Mn2L1NomloA==
X-Received: from wmbjh9.prod.google.com ([2002:a05:600c:a089:b0:442:f9fc:2a02])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19d1:b0:440:68db:9fef
 with SMTP id 5b1f17b1804b1-454d53eef2dmr17048565e9.20.1752058799393; Wed, 09
 Jul 2025 03:59:59 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:31 +0100
In-Reply-To: <20250709105946.4009897-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-6-tabba@google.com>
Subject: [PATCH v13 05/20] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
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

Rename kvm_slot_can_be_private() to kvm_slot_has_gmem() to improve
clarity and accurately reflect its purpose.

The function kvm_slot_can_be_private() was previously used to check if a
given kvm_memory_slot is backed by guest_memfd. However, its name
implied that the memory in such a slot was exclusively "private".

As guest_memfd support expands to include non-private memory (e.g.,
shared host mappings), it's important to remove this association. The
new name, kvm_slot_has_gmem(), states that the slot is backed by
guest_memfd without making assumptions about the memory's privacy
attributes.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 4 ++--
 arch/x86/kvm/svm/sev.c   | 4 ++--
 include/linux/kvm_host.h | 2 +-
 virt/kvm/guest_memfd.c   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..213904daf1e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3285,7 +3285,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4498,7 +4498,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 459c3b791fd4..ade7a5b36c68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2319,7 +2319,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4670,7 +4670,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab1bde048034..ed00c2b40e4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -614,7 +614,7 @@ struct kvm_memory_slot {
 #endif
 };
 
-static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
+static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
 {
 	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
 }
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index befea51bbc75..6db515833f61 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -654,7 +654,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		return -EINVAL;
 
 	slot = gfn_to_memslot(kvm, start_gfn);
-	if (!kvm_slot_can_be_private(slot))
+	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
 
 	file = kvm_gmem_get_file(slot);
-- 
2.50.0.727.gbf7dc18ff4-goog


