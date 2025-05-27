Return-Path: <kvm+bounces-47809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF3DAC59C0
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A85998A7291
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B120E28136B;
	Tue, 27 May 2025 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mZlVUh5Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F561E25E3
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368979; cv=none; b=CvNxVHH5kLY8WSbvsXh39qdGeqjog7E5qOR8UqYOmLlSUN2ZbP9wJWScwp67cYDvEy3kFYhUR96DWZC/Ha1iKEt9m06GdEPOTebzY0Kbksw4XBVyc/jmQbE0mL5f9MgZR36yxvFpZq/zbXZ1fr0+mm6QABIOjXJmKSvLV9H6Vg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368979; c=relaxed/simple;
	bh=3HEY+bDaTKhxdd8Inej7qYB7y7DFBDmld0ZLU9lS/Yc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nz8jjBxrwXhKb0j4JblWf78zSUI7r+2T1c4kRDzzCzfWIAZwqcnYLRQRUAiMB4ptCKz/uLAoIlLLjWuMIGlYNkKqO77oZeeYvUh7Cn8W0F6ieTsj7ZvFoDFImHGdEmAUP49J6Ya/lsPGr5tsgaQUc7ScuZln5QvHnaJlWbXyTlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mZlVUh5Q; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442f4a3851fso26966265e9.1
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368976; x=1748973776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lLl1bAhu1edqB0aL6MbIfxoXUqqHcE7E+0hknC1ZGy0=;
        b=mZlVUh5QCFFirVT4w2iE+PeDIKs/dO+jyd2keINte6MgTpaugkxJSM1ZBdngX+wvfg
         IvSsMqBaVYs/GQlpfidGM8/UGwJhYFMxFtfwTFMXSkWBrbcAFkyy/ZxOijn8546OJ11X
         yv+MzCf+NwvGgZsSLnouw60tt1aLnKCvP3GrSFwLYnhmu70//HbpHwyTk8YfoywHeJNt
         B1F3bkW0bq7pzyaaiGyGD/gjaU91tJNceHLun4cljvvaBkW/BBfBeOui7/cckV2zdYJG
         mecb5OLuWcBOW315J8sRciQ5qFnnVFGqYTK7hYVdOAd8rwd13VYi4g3IusjvmVcUqijN
         1rfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368976; x=1748973776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lLl1bAhu1edqB0aL6MbIfxoXUqqHcE7E+0hknC1ZGy0=;
        b=dyj2z5a9d48WIreZ7yNv7usXavof7DaAIIB4hFSug7xzwJixI8ZNbVC25WCI7LBRB6
         v5iuhQPDNrY4pOxxBNJflQ3NEM8sPRQxKyvifg8Ky4Wze3AyHNhEqYzhMsLsKEsEO7AO
         ODTtF+F4H3A8qauZxfRRgIhWoECMxXezvAOonOrlzVPGhdIf8IlcBjEGtn2PdmszwJOZ
         Qz+gr3TQSS3wRcFK7L9AxmQjBa+x3LSxqyxE1l4TvrshFzfWPIACsEJJ0gjTWcAbaRhH
         NvKqdMBXFt1PAUyYKU0JN0udToopSDUWRmwJBJP2MMVwyQANepvj/wXLLxvLBbuzvG02
         evCQ==
X-Gm-Message-State: AOJu0Yw3PwC6ZRB+v8er3e4MVpOlh0xOHNNRseeW1Py1W/xjyBeWO7rY
	6RUifZWaXeB6Iv06PQHyYdWq8aQqDQMyOxgjIxp5Kd2mQrBZRZYtDVBtom2hz7UmVdJH4QQalhH
	GZk8TeyqbgChJ2QFZ27APL11LP1BppeFfmdPiVekcQCQEal2G6JruRlH/rrCixrEmnNwSfG0zyv
	oN8fv86C9YOY/zSTlDouq/YPtUmQs=
X-Google-Smtp-Source: AGHT+IF2T9kruthHanldNzTC5lsPTPvkZrQxx1LfteCYkDfwCMzrLxFPW7sjZDnseKL7faWqPowpJMeTcg==
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:442:fa58:cd7d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3f09:b0:442:cd03:3e2
 with SMTP id 5b1f17b1804b1-44c93da7f1amr146003305e9.2.1748368976248; Tue, 27
 May 2025 11:02:56 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:34 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-6-tabba@google.com>
Subject: [PATCH v10 05/16] KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
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

Reviewed-by: Gavin Shan <gshan@redhat.com>
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
2.49.0.1164.gab81da1b16-goog


