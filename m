Return-Path: <kvm+bounces-52762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A61C2B091C4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 18:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84DC14A010E
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 16:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140462FD88E;
	Thu, 17 Jul 2025 16:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fz4HhIFT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E052FE31B
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769665; cv=none; b=N8wDx+x4MhFOUiB4QiKM+6AgbluihM89t8Cvi9NnKymiYK4Oo3NlJB/ZtxLMEp7pNyoG8V1s6OiJN+byZH8fJvlAijIg5+CxbVd0Y66L9VipEQYI6UQXUH2t8aKOzoXcZQSR+DG5Il+YRIeE7WAteo07X9fOBmSl9uVLWRDtHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769665; c=relaxed/simple;
	bh=qBFA+hgIFDH5VA3np+QeIyTUTOzA0s51yfc1tS1nUdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CrtU4X7R1ujmKjOQTCAShZK0YHJSrWH+FCPXjsF5+rmpGj/jaBvXXGiHobHbWZDOLmj4xQGcrskanA5wJCCa9FXfOnhgZAQawXNwmHyjFGbkxIa/IOA7Z+tZ8fXqiPC5kWNJhdV0Lm0f3Yvxg9LksVQAesdt/sIlEPh+0roZkZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fz4HhIFT; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-455ea9cb0beso9476205e9.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769662; x=1753374462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cp3mHLDXilC5UUJ8h8CWl5q86Vpa9+rZIAydOb79tw=;
        b=fz4HhIFTUGRN5YqKDl0f88ZAt/5WYx008+2e8pcadWXfjhgrRbMXRive3miY3CS8LU
         rB9+DAGscOzcZ15TsosR0FqyTqH+12aRX2M/UMwSIUDz0rKN3vEPoOU91nqVIDkhWpzq
         CUQFm81k1yDPvwlFrx2RAI2JPaFXKZulZHkaWiYt8LiFquHn7BjT1SL62DeiM2FHvyVc
         tyt/zOPWMzm9XlW1z9sgp1L3yFXg+cuBlDjOiPHt7e27vNBsk8iv/9Nw5WsNGySRDcp+
         74oexCe6EypJLycHwS/GGlTp/PYz00i+Beasd8sHyR3gByhWCT9k1pG0xpyuQtT3S2mO
         zS3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769662; x=1753374462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cp3mHLDXilC5UUJ8h8CWl5q86Vpa9+rZIAydOb79tw=;
        b=UjtWm2qmtlVgEGAKP8MhIX6M0N+0OQXRyGsccuv44H5P9N17YJA3H1efazulaV9kic
         f5UMssvlw9adFS6tWbiLG6AZNDcGx7jijfnaNkel6je8NJ2IG7B2yv+Zy4861XW5JKrd
         nMIhA82xL62wCIEXW52wTZJdz7TxSptowCOxEbduxAKfU8/xmhTx3Z0zk8GcxSrTeX4l
         nDTNLiaSdFZXZPpxC/XaQZSDkShMO8IuI3VVqOufAExMw/9v88lpUdJRi2ELeOifDiBB
         /Df0zqHiLSwa7K39WZ6hmwmVghsPy3OG3IouBSVEiV4B+YOKvVFRMMFAINOTg24eOb8N
         fy4w==
X-Gm-Message-State: AOJu0YzdvzoFWBP3Wj/HFGynUcjdTCi1wbxYrUD7I4PJiAmo3I+D6pq4
	De3m46DB8haOPGK+Kit3NLtj/bj0AoVsnbUpemNW4hop7eimQa+hAotaJIoFqpjNR3+QKzXzNyY
	D1Roj4utMyzt7Ss0hZwE5IlwUCeqw2kPbbbVlT9UJBaODmT8X4v2Cx63FwLEqiujnv8Z8D3IqAj
	aUTOAt8NthWhI2qqcQ995K91ejWvw=
X-Google-Smtp-Source: AGHT+IE21fhaeICe83jRxJ9PmfXWuTRh00VmTrToJooYUCyNgKLMGI0nhgD6QdhoopuIJeihgPQK1UPb+Q==
X-Received: from wmbfp9.prod.google.com ([2002:a05:600c:6989:b0:456:3cf:1e95])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26cc:b0:3a4:d4cd:b06
 with SMTP id ffacd0b85a97d-3b60e50ff10mr6053820f8f.34.1752769661545; Thu, 17
 Jul 2025 09:27:41 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:19 +0100
In-Reply-To: <20250717162731.446579-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-10-tabba@google.com>
Subject: [PATCH v15 09/21] KVM: guest_memfd: Track guest_memfd mmap support in memslot
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

Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
memslot->flags (which makes it strictly for KVM's internal use). This
flag tracks when a guest_memfd-backed memory slot supports host
userspace mmap operations, which implies that all memory, not just
private memory for CoCo VMs, is consumed through guest_memfd: "gmem
only".

This optimization avoids repeatedly checking the underlying guest_memfd
file for mmap support, which would otherwise require taking and
releasing a reference on the file for each check. By caching this
information directly in the memslot, we reduce overhead and simplify the
logic involved in handling guest_memfd-backed pages for host mappings.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ac21985f3b5..d2218ec57ceb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2536,6 +2537,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 07a4b165471d..2b00f8796a15 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.0.727.gbf7dc18ff4-goog


