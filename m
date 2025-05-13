Return-Path: <kvm+bounces-46359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30426AB5A07
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:36:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96B7F4A72FD
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BC72BFC70;
	Tue, 13 May 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QfSKIf2n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5862BF989
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154095; cv=none; b=RaJy70JtEOeRvlP6XTa71Oi7IWDigprbR+6sy3sq3b4MitP4neZPC6/gGL9hTW5XAKhuv/WGTuf2EKYXFfEJaezhH1ISQycTpN2VfU2AjUIvwFj4PrdU/VuOj4tWeRfo2nj6+uPwRhlaPSbKysfrX+o90jVEOLRPUeK3Uu3Ecs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154095; c=relaxed/simple;
	bh=Nk2SE8fgWTOA3SD55WZwuIinzW8vRw+YmFTubUttCP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RQkuU07EewFyyuHxyZRHSogkaucMXQVI30nsNeMC60GVGG1Bf+8X4IELE3ELl5/hH3CbAhtM6Xl259JZ5YALVz6EKLdRBTfZWL8COvQNS3xNzmpSoR0bOhsgVxGY4j3Bfd5TuXtPbojEMED2RXc3fJfaw/NFZOyuGDkgPQEydRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QfSKIf2n; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a0b7120290so2645895f8f.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154091; x=1747758891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4Y6TGsiTr3tqPWwwMchy8j/vXKPtI/QJFPjXad1Sp8=;
        b=QfSKIf2nGji/LwVWsGtmWN1aiprnwNheDqfhRGDbH5+YbMl+9HHw4ubRy2Ta3ct7xL
         Dh6QPBpjIhKioFymLBq+NH40B4HWc0p+t8FlbU0+rIAD4INGeQYvoVOgK4GsuW02HUF4
         hzFYpcrYBHfoqURRJ0CF93fdLXF87sUXoK/+ZRLQNtZaCqpQ1nxrbLiz01EyTePblirM
         b6mbIEUBLCRSG5m6tCSZOSJpoVz/Oi1d48e1twN2T7UUIcX6FKP97A6g/HfTdIn1DaPn
         yuz9GvA4WN5arP9OlF8it0Fme9rxSxaBCW9vM0TyoNbcof5ZfVWquCsjC6QDmY9bwlsC
         dJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154091; x=1747758891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4Y6TGsiTr3tqPWwwMchy8j/vXKPtI/QJFPjXad1Sp8=;
        b=ZUGg1oi9jYakxRLKUAiBdkGax+DMlWnVRjlUszTMaF8qt7y4VSBLLSsXAU09MrEpku
         XQA12bihizwM39TnjTLN/9leXDRnTTY6EEgb7Vy5rIxicV9eIChl7YIcMRxeTB7eR7cl
         gI7HgNuafXnixzyn9100cd0/uYVjW1/82evq4hD7OgU5AKKvzxXWAYjZEt89kRGul57C
         yT7his9UpeM6Lcee84Igj0haZ4aunrA27niS+yHcVSISGTFvr+dQnVI7+/y7EIQh7fEh
         WDOkRSGTB7b3OoFZxPhuIYH5ka/RZxXJ0Hv98Kvur655Cc3MGB7roNqtu1EmteTeOpsc
         G6pw==
X-Gm-Message-State: AOJu0YxglgCFjvDddaIMbMEBGUQ1kHu4ZSR0wgXiaR/5xMMhp6+rfQtz
	PjmlFpH9x3DmuSPv+H4Xbj38O7mAzmexWtAmqM++u5w4/vSXeYJvlIthQlJQ0xCWXs5XRJb2hTA
	1JyOujtacS1Jql4k9A6V+cvEnZYo2Kb+b4mTEzuksNVG9/9GZ6UXuUO08smE2Vd+8ImEJjGs90G
	abST0Two/rRca9fQFT2cmN3gU=
X-Google-Smtp-Source: AGHT+IHW3MOJ2rEkdcM1Edo/ds00OBnNEl97oBivjg68cagNTaciFlwYJOcR54vqibaM891n/OdLrMHUUg==
X-Received: from wmbfm20.prod.google.com ([2002:a05:600c:c14:b0:440:6128:9422])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:37cd:b0:43c:e6d1:efe7
 with SMTP id 5b1f17b1804b1-442d6dd21e9mr126539735e9.26.1747154091128; Tue, 13
 May 2025 09:34:51 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:26 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-6-tabba@google.com>
Subject: [PATCH v9 05/17] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

The function kvm_slot_can_be_private() is used to check whether a memory
slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
that clearer and to decouple memory being private from guest_memfd.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
2.49.0.1045.g170613ef41-goog


