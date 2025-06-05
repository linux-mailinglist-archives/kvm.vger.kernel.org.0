Return-Path: <kvm+bounces-48537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A68D2ACF333
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:38:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E57C3AC9A5
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C00B21FF39;
	Thu,  5 Jun 2025 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pd6N8n27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC2D215793
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137898; cv=none; b=nrV6JEdLrhtd509czPqZlJ0VS1SoVxgt11rhP3qCKqWXCbn3/wj+DRYYXxgjs9nwoRRy9VeRCl7f0qfY36ruCux4KFprxa9WsNCCvpFIbSnnn0b9wir1nbrZ8EM7ZtOuNPGHZg78jWUx2hDjLj1J6kFpc0Xv4YIjtRgXiyAVwaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137898; c=relaxed/simple;
	bh=ClqrgboMEAhwsqtCXqqp6SxhBiB6M6InDzTzjwdArXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxC756Ph1ykTDFQd07qqjiJuQS85P8c2L1KfFbz91plmSWFIBc9jVEEOqhFfR1tWsvPGy4qw5EQNYoFR6HOEWJS2At9yanCtlHV7Pt+66ZCHOAS3pTgYth9XbBJGsHs4Gk5PPNQwFag357yWpjua4vaZ8uz6MI3LXca0U7852r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pd6N8n27; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4f7f1b932so718935f8f.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 08:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749137893; x=1749742693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qe3sWK5q5nK1m5jGk9UWStlvXP6F2F3f83ETUbM9FxM=;
        b=pd6N8n27L77gA4fYrBMC5E54AobMXFK6ENdDB6PgifD3eGnBlcrt+FJZ/+zVCQuYSr
         yz+tW78/x/XK0Gh6RG4tuCaN5nfa5N3GYBSh0yMXoZbl53ZTnW0viBV+NUev+yJbDXUp
         3O73BgHxx6ze2BwKkdk6T1lj/+QyHO0sVdcB2MMIAc8by+4+cKOSYZm5ukHgJkSbgoNM
         RiBn3SHOfm3c8TEQmWGohL/IlA5lv5VpEp0UZZP6bZcunpGK18cSTxP1RiYLyKRCkttQ
         eIlFXColoIrOVXXQ7VZIQkHfIVlv+T9a/lakQ+53vFcy2LO60h9x8K9uMHwaHaDjGzMN
         Wv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749137893; x=1749742693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qe3sWK5q5nK1m5jGk9UWStlvXP6F2F3f83ETUbM9FxM=;
        b=QcKUkixJkXa4AOq9IRPVpAKl+1i3LhXMaKHWPZYbXoFBveTPbDsLg96TRz7Mk4Ofqi
         LN4ZtjGZuD7G3fw0lrM/ZUEkeHjfXM5gJqcq+X37KudBxNmIlcsbCUXhm5LSKB/R/IyB
         rtQTxAS2d8jgJXx2BhoRwaU9kOXM9FJPQjX4bFpeZHtXgnw59a1C5QHaPuS3hDxOB7DY
         rLVpG3dDXV60kyLh6tpCEojVPIfq224CDo25SwfH0OVp1DwqDSy2uGYB+V1Epr012FqQ
         nPq5uQFF6bysbXq6y18/WDoxyhApcXkJ3aTcDqOObBVk8in8f/DFG6gYULSEg1yKh5AV
         cWQw==
X-Gm-Message-State: AOJu0YytOXerWvHVWtzby9KyGLmysVTxeaPTK1yTM8DQzGQ0Eun7Zubu
	TxizRDqI4A6eNCUT1HtKkjelCvczeRapJVJ4VyAwoF+MIkg6zYS69CTxmibneOcU4gd1bDc9UxF
	+IqAjzKudh1zu1/jk9TLQjmaQR5+3+4S6ws9vIlOl+QsRjBUc2HtqmJkYJSgGT0bM+7LbPS4D3r
	Kl9Jgv2KhI1qhUkmEpwo9BdAM7z3c=
X-Google-Smtp-Source: AGHT+IFmcdwhn2LMYNxP+uGrHHW9kSBs4n3ZI9kvbXxMD+ySlDN/PQ/FygdrWVTr0+hjocoxBaJLadObcg==
X-Received: from wmsr2.prod.google.com ([2002:a05:600c:8b02:b0:450:d401:f555])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:588a:0:b0:3a4:d5e8:e352
 with SMTP id ffacd0b85a97d-3a51d924837mr6940909f8f.7.1749137892942; Thu, 05
 Jun 2025 08:38:12 -0700 (PDT)
Date: Thu,  5 Jun 2025 16:37:47 +0100
In-Reply-To: <20250605153800.557144-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250605153800.557144-6-tabba@google.com>
Subject: [PATCH v11 05/18] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

The function kvm_slot_can_be_private() is used to check whether a memory
slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
that clearer and to decouple memory being private from guest_memfd.

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
index 69bf2ef22ed0..2b6376986f96 100644
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
index a7a7dc507336..27759ca6d2f2 100644
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
@@ -4688,7 +4688,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
2.49.0.1266.g31b7d2e469-goog


