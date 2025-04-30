Return-Path: <kvm+bounces-44946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC96BAA5246
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B0B31C06774
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE0D26658B;
	Wed, 30 Apr 2025 16:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JD0s96+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D779264633
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032230; cv=none; b=sG8DaEDYBuHo32UcgLoqSX+zQbSleWvq1WXjhDIDvfImwId9Tb81ldn++XpfiRa1xyYw2MxvY1YrU2ejyvI4Eft1rnBVuoaQ+6AHOba8TlNR0kOTeS45cGtJuTpf0ovCDrf/nrk42sAd8cjcgsQfb8lfK0r0A8PcfvgW2sPp6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032230; c=relaxed/simple;
	bh=MVnAfN9V1U/fa9CprEKqa6aQx2j2+jxiiYDWMGy5vUA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j8z001eg4YBbYH/5d9XUT8KPdjDbuuj3HxdeCNqW+onqcEh4B+leF7VHNRKKRhJj2B4L5wreQ/Z39D+jMkYqINcpKfg7rRlKblsbRGkb2ynEReH1wgsQSeNv2dBmwSa8rgp8xRRg+2U6W/kbT/MpH2foID4xD6DgsCTrIKNXFMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JD0s96+2; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-39979ad285bso3494621f8f.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032227; x=1746637027; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3CtfAFFPAmimQWAxnHhowOi1TY4SeMONfCUu3d2ZV+g=;
        b=JD0s96+29dewEMrceqOrpOoSNT8VJ9YenR/+EbTpj6rHbZOncqVCWA2I5BUPGNgHxK
         09Xya0YAL5kxe5KYzJfiejD7T4Puh6bQjRZ6JwL+4c5w1ZWASjeRhyK3RKCE+AX9sAuh
         RpmLBgwSUlj340CHN8nrcdHj3H3dHblJbiCiPtCA9f0AzTCGWGGdtX/DGe8WDokFu0wX
         KR7/tG9frS7rELgXbMnlD1R47KuypEUjCC3euyBc+N8vljLFqGCJetLuAMpDCrghD2+X
         RB711DdHLWnXi+AAlV3Ah+0XcI7kz0QZnmb+sNDvjm7PqO2t8vM0S9lNVI5fWw6bSrYw
         8YuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032227; x=1746637027;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3CtfAFFPAmimQWAxnHhowOi1TY4SeMONfCUu3d2ZV+g=;
        b=fmbe4rRlhwyJAEVjAo1Vra86/AnmrrUI6uOXjiVlLXgJMT1inARGupyESoIZoWd9Ke
         0IA1MOJrO66d+ZMpjLNxoeGQHzOVVRXDTglFkTpmkpIvbvUOabw4tVVHRsLJwDXhck49
         LpOTkSdKmRMaNiVcVXCsfj1vfvd1kJz8SgXzmQJjiUhihHRB43QpgClwtqsz1oCdIgoy
         ArOo0wYNJTBu1yhPCTV80sQBSIsdent+fbuH6nSoBWxam1RaiD+s7N6I9U39r27zE1Of
         QA+EsPUP8lv9MSN0TNHo7j/dJzE2Ds1Pl4gjwv72vkxC2i5nt2thlAVMDglHiZ1q3cWZ
         0n3w==
X-Gm-Message-State: AOJu0YxehJj8lcQ8TTuXSuPo5NvasOz2ClU8dnL7xJ72wJHtq1jJqpA0
	+aWWKe/o6aULULZRJDoN0VoCm2sJZvcyou2NjHWnGXysYl9fLF4s6OZTUIgGOe+iv6N8ygAg9w7
	ZWjj2Jw0RthErhdPXYQs+sxNdCXukdoRDgUxIPvQV9Hyi4pjHRAsjGrQwqqqoX3KtreWCSVX1NV
	XliKMLVdtkBwNDMN+ThIlyI+E=
X-Google-Smtp-Source: AGHT+IG7z8QVHL81WQHnmCOzSujF1J6sOiLfM/15DH9y4sE0yZpL+jCikhfVxgZ427ckeUYKfQPTUnZiOQ==
X-Received: from wrbby19.prod.google.com ([2002:a05:6000:993:b0:391:41b6:d274])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:55cf:0:b0:3a0:90c6:46df
 with SMTP id ffacd0b85a97d-3a090c646f8mr1848861f8f.48.1746032227177; Wed, 30
 Apr 2025 09:57:07 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:47 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-6-tabba@google.com>
Subject: [PATCH v8 05/13] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The function kvm_slot_can_be_private() is used to check whether a memory
slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
that clearer and to decouple memory being private from guest_memfd.

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
index 734d71ec97ef..6d5dd869c890 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3283,7 +3283,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
+	bool is_private = kvm_slot_has_gmem(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
 	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
@@ -4496,7 +4496,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 {
 	int max_order, r;
 
-	if (!kvm_slot_can_be_private(fault->slot)) {
+	if (!kvm_slot_has_gmem(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..fbf55821d62e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2378,7 +2378,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4682,7 +4682,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6ca7279520cf..d9616ee6acc7 100644
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
2.49.0.901.g37484f566f-goog


