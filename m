Return-Path: <kvm+bounces-52473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20EFFB0567E
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 730D21C237FF
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1048E2D877B;
	Tue, 15 Jul 2025 09:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0YlwALiI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCFC2D876C
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572046; cv=none; b=ntswHgzMCM2/t/hSqFCSUrmvwAx7GJL8NOrBWrhyfdOlsMAfzIi3oE/ftuKdJ/MLgvxoy2mJyInnNazxkK/p9rc+kzXA32EzF84iEAeTmkdmJrWWMBYCxGaHPpSSOOGut/yo92eQJaz3/ddzWHLqw+6GXi2JLy3XW2WznBFg0MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572046; c=relaxed/simple;
	bh=8drK7wXvtedh2HpFNUcdbXZgnZHxeXsUaLbHtq7/9GA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5NNJrsawl4j3BR+Aq4+8JvfQpXZfJGlK7WCXK4SnHRnmh7z0FrKnzdjSVUts/Qo6oihFsMy2Y0LuY8zZKlEJvCAAkjyo2de6k6J/PNqgU8tVUmmUOu+Oz8gqPsTq9z0lRxHYEKPpvQD2Zw/dCnajPI6d/HtSFgdmcger9J7k+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0YlwALiI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a6d90929d6so2356045f8f.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572043; x=1753176843; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8pudhEgqt6j9GkneYmmruy0SFjYwu+6usi2MMhMEwBI=;
        b=0YlwALiIO4p6kPYhGxkN4rQC3vBY2PnAMzDgUIxHcFLIpmIYc+aFfK3HX+3HcPlkoC
         zD0UVkNgn8k+ZxlFuZLlfjCnFoqoVA7cm3C2/eCuV3ZDqdOw3pvjwbeRUp58FFqE918H
         VP6Or7HiXcEWAZUUlDXjeYDmmCE9XW+0Db7WjZERk3V+J82h9dYQu2McqXM08D6RTt0q
         PDK1NTPOcIH4tKUO9dulqPMhMiLbm0nrxDkNwhJ81QaLkJjOgoeFS5STOGK9y7TbLElG
         XYDl2OfavroNgIJD3cqOwx8mSPws51Bfz8Z8A5PU8PW9vqQJN7r+LswQlOGCWoHSuBLz
         DMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572043; x=1753176843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pudhEgqt6j9GkneYmmruy0SFjYwu+6usi2MMhMEwBI=;
        b=LR+6K+CacJ9Tn/i9ISVObePI+J9nbt+zHS4XgZpM/9E1ljPMPwePHk2SOB/RP2c7Kj
         vG7JEmYtWrybvlofMZ6eyTRnDN8qYgMcavqgDRebpQY4TPLy2blHi8qMvdDzrNzdCps6
         fbAiJDqUSCvunZMc11ffUR4Sikpkr0/4ZkhjIRY1QQ/FrzrurQIA2lSBkYdyGxsyEx6O
         ntx2xVDJg0BTZVq2Cebs9V8aKT0pUv/dfKtJDvEyhaqPPizgBA6iKW2E885Tz8uOXE/p
         7u53/z1yy3eQJQ8KMvKqTQ8RWFzy2XRZFmY5MjhpP6UyXu9qg69nImEh0C/EQ8F52jSf
         f2yQ==
X-Gm-Message-State: AOJu0Yyo0PFEtw8GuEhTqb1Jzsqwxkd9aIDtv9MCowi1HwZeWXco3J3G
	O94itWhiumMeirK3Bq6uhN8scSHe0enUFBFFDI5Hd+NIKZ8LvIjrn/hcn+hQEWKy/m/rn13Rglh
	CyfYX1esWbP3n6WICFrAIlzwu885rndZ4Yy8hr8VPPjByh09zjGyH4b5Y7KvU0YbjXidwRReoNv
	0wpsRwA3HynP45dcC26sPE7MELpik=
X-Google-Smtp-Source: AGHT+IFctu0fAkeb8CPBUq72/4rilEf/lWwdMxSroppHEiafl4lyrm/kvgmt1YhMWTR9YyccADVY1z8Y6Q==
X-Received: from wmrm6.prod.google.com ([2002:a05:600c:37c6:b0:456:13a2:2e7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2207:b0:3a5:8a68:b81b
 with SMTP id ffacd0b85a97d-3b5f2e26cc0mr11225293f8f.44.1752572042216; Tue, 15
 Jul 2025 02:34:02 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:34 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-6-tabba@google.com>
Subject: [PATCH v14 05/21] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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


