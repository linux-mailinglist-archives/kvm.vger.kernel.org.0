Return-Path: <kvm+bounces-52758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D65B091BD
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149B73BECB3
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BA72FD89D;
	Thu, 17 Jul 2025 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dr0RalLq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5242FCE0F
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769661; cv=none; b=u+/baDJXgCJxLbcE1wN67io5NMLMFe48FUsItmEbTC4NTvd73P8wQGvZScSWEJ+Eux8FlFmLjmnwc+gWDKVoCwx3Bxfh1t/6pAWW6WAMo/Tn9rH2O1Axau0cYpdpq9mshXCHCdYzTv8BERD+0euegYh2yPP2KdlG5N1hpIJKgDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769661; c=relaxed/simple;
	bh=y+3abzMGV4Okr3EUDSwzzvtzSNYTEEWlj4FSPy863KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B8061fCT5DuYyisoHP25YEZPhIA2Apy1nrHNWNp/HQ9rGwxtFLVN78e3w0rb/6VARMM/eF5FqWXlkcTzuqV9+l16F+WIxOrkZOnyGm94KCSRt5FtaFD5s0AmgJn0xSnf/6k/rTSRTD7Uvc3cXtvealitdt6K5T3BO+UtUobQGmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dr0RalLq; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a4e9252ba0so690206f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769658; x=1753374458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C4FWofDuxo3LiAutlhmOSHe+Y0D/llAlEXKakE+6Iv4=;
        b=dr0RalLqH76kZG6KkLSLLHkIzEQyVxx4E/58u2+zqEg9bP8tlkvPtb5or7XOEusXAR
         j2nVv2KMB7DxK/ohLqELMqF1F8T0We5iXcVhOvxrLMx0JRKcQSlteBExqxeykUAjIyHt
         U8ohQvn4n0GrTYUBOb1HyBCawpAPe9WD017xrXFKNDrN0bgCKiScwnai0ek7TgBJwpFI
         9oteBdYwjvcpA8CYvofbspGev3fRqsa3bJrcL3YZELoN/rnMdom7Ot5KxkBUrDMsP1qT
         i0ELdhcIQCjwrWGKsSNXv3vYracTFJDwCRLSpDTs6kBHYnNlEBQ6Sg9fNRf4b0hMxVrY
         43nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769658; x=1753374458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4FWofDuxo3LiAutlhmOSHe+Y0D/llAlEXKakE+6Iv4=;
        b=WZCtQgJk9Gjnu0j0mPngzB3wLitPt6p2R4NeXm+NWrYUPYRFnl2k8YqVv1qwdwvUSV
         NfUzqDyVHRkQq4oHd5WgfaO7v+rHamJDHHYee9jyB+CBr50hvhGlOjrdMz0c6aTImeiI
         RBJSTzqHZdmeHLCUGxntkXBgk8x4l0xM3BdK+L3XBj37WSSz6HUcQsT2yeQAEvlJZyj8
         MKzVV00iOfyASXmEFzWmHzb4CfXNhwcUcgHg1Dw+tc9NZGdvDHiwjvmGvr35pXenTEn0
         g7xBJtwwzbDGY+XAjmrFSx78p9XbNlJeefysyLpv0FMfM42yf0/QwUIONptXmPHVqiq8
         kT5w==
X-Gm-Message-State: AOJu0Yyh6DSNC3TqOMDMoYpBWWzLuX9GI3EUYdkVh5NVjnwRbmBm1LFE
	wtd6RjZignNY6GgQ8xpaqIAYNo8wLxvcocTa/pg2Mheva/YgflPpLlsqQwPbuBbHTw7ydoVEesj
	aUmO1GCzfGK6fXy5jv05WqD0WHwB627EMs9US/YGThKlQRvHfx632VdFCS4KENr355jKbM+AWFC
	0aWuncmu41AdO+dqSCFVwYsIDGuZ0=
X-Google-Smtp-Source: AGHT+IHaz+yroPg0NKMwZMkX/KC2XWpH90jKrNk29OTREzYSqrwLXlyKc1zvsU986x2v63y7WEDy/ENfdA==
X-Received: from wrmr13.prod.google.com ([2002:adf:e68d:0:b0:3a4:e608:d34b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2903:b0:3a4:e75f:53f5
 with SMTP id ffacd0b85a97d-3b60e50fe57mr5344519f8f.35.1752769657583; Thu, 17
 Jul 2025 09:27:37 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:15 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-6-tabba@google.com>
Subject: [PATCH v15 05/21] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
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
index b201f77fcd49..687392c5bf5d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2323,7 +2323,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	mutex_lock(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_can_be_private(memslot)) {
+	if (!kvm_slot_has_gmem(memslot)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4678,7 +4678,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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


