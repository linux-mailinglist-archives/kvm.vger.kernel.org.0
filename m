Return-Path: <kvm+bounces-49052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 043A9AD5729
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DECE164AE2
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72972295515;
	Wed, 11 Jun 2025 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ceHIAoLG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54892951CA
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648825; cv=none; b=NhwduGUgoex5B6CGa9fhB7p6CPjgfKq1j5IX6HyTJCb/5cVC3ivuY+0++88BnUBRQrtRgTp8mNy2Y5DJXrhlP/lj39qktPN9ffv3Z3pWjxh3m3Tag9BUhWxoy4hrByBPyTf83AxrzBg30fAO40ipGKm8BEjIOYDKCuEPAyXYFmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648825; c=relaxed/simple;
	bh=7vn2LKz0DiGnSIDDs2V2kh5rysZiTSTz3Ly2sXV4SD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZkKqD6u1gXiCr2NF2qeNDkVGV/N6VN5ui6DXI4C1Pj+h+HqotTbIEFqEmWuwIg8ojCgxHqoxWL1X3sqYJDgiey52LWx7WxjnxLfOYGWzriAQUhT7F07VdiZNyEijQGV9wgMc+SlObVJsMXdpMFufl342M4efc6xKBmip+HUKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ceHIAoLG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-450d50eacafso37664485e9.3
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648822; x=1750253622; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fHa8ecXiFjILMVX7ljzeBm36pfeRCdeP+Tg7zuffq3M=;
        b=ceHIAoLG6d47D1S+FGj5Ylhi4h5wrpTFj7Kr9QUVt+wPPeKhSYXC4jXeirsmd0hMz7
         Qir+lF8rpMdQgkyeBhH4qqk8wdKBe8ELJC0vcE9CthM2YZDk9HXtL7Myb0MhQl2WTPOB
         yWCF5OHU+2D5RHtShWlc8X0DSCZX0VZYh4us2SGI245lJ2ws2cYawN3SoV/iGQeLbNSX
         bxdiVz1PcbxbZjjOJ2AmFpuPtEoIvSFoEOhtbB4FT3vdiA/BX7ywSWDHur3JJ5jTbyRP
         qkacBfdLKTYBXVoiwpXFv/CSRSHTvomXWSQyirerUTXDI39ikzzN+eXUo24W0AuQm0fk
         XB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648822; x=1750253622;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHa8ecXiFjILMVX7ljzeBm36pfeRCdeP+Tg7zuffq3M=;
        b=Ba5heNMDk/77+G9LD955UcPQxGVTLT9W5Ze80+CAj1Gm12lRXP9DC91vKBUcsloHEh
         ZIoNZSVT2Yq9iJOGcZirTcM6EKegKDFRca7FUvGgcpYQWZL0Y4nayUTdexVJXUh08aFG
         iW5cVsf/vYDpAfOVx53UgFYt2IY7415bJg5B1gCOdbgTKxED/yS1SXuY/IPNPEmoNylj
         04Kwm/5pbvRn6lUnOXClF3dmFZ7kDHQCXikgGS/llSh+QdQMiHAmD6EuZR9BWjg3xmjI
         D9GyEI8gD9UfEsgIK/+mCiauPLamlH0fGPwGQi7nn4gf/GzAKpDWRwD6Na6zDHos6NMc
         CLGQ==
X-Gm-Message-State: AOJu0YwxPu+w4z0OpcyXZvMof9F+HRc/OU+RphLt5LfBBtHHOA3PNnaH
	jiu6mzvY80iczbNW/OzQg1xafk9SKo8VVpRFlW9r19tdSAvbc3LbTxFg/a5vtogYgM6ot3XvQXq
	KIXgtmmjsNM2aWXCKjib1F6yyL1zRy9flixe9zUJeh9yBtEIablkoV3mYszG3OQgmgVLRj76T3z
	q48EGKlxpWiWPyQ4XBwMd1InL6V/E=
X-Google-Smtp-Source: AGHT+IFWFQPWCUEP2H/3glpy9tz6msJlvW+obnyNE3/UG7wTeYJGX28sYe2VOsbPe4n9KYugqPuHFDfSAA==
X-Received: from wmqe17.prod.google.com ([2002:a05:600c:4e51:b0:450:d104:29f8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c08e:b0:453:a95:f07d
 with SMTP id 5b1f17b1804b1-4532487b287mr27952385e9.10.1749648822211; Wed, 11
 Jun 2025 06:33:42 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:17 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-6-tabba@google.com>
Subject: [PATCH v12 05/18] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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
index c4e10797610c..75b7b02cfcb7 100644
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
index 5a69b657dae9..ed85634eb2bd 100644
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
@@ -4644,7 +4644,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	}
 
 	slot = gfn_to_memslot(kvm, gfn);
-	if (!kvm_slot_can_be_private(slot)) {
+	if (!kvm_slot_has_gmem(slot)) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
 				    gpa);
 		return;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a0e661aa3f8a..76b85099da99 100644
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
2.50.0.rc0.642.g800a2b2222-goog


