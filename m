Return-Path: <kvm+bounces-53210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A96C1B0F049
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 12:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82C6756708C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12832E2664;
	Wed, 23 Jul 2025 10:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WjQFoHRg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB262E06D2
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267650; cv=none; b=H/2EenJWjwAdZFb0bWICJ2Sn8WvaR1haal8NXIHXlA8aJoCzffPuhGJaHVLJHopx0wA+K4QxGAokIwFYqVUz2s02ZlvDArzZQU/O3wNADwRaVLsUvSTOu/V3nCjUH+JvliKxSJ/ZK49iGzQGEiZ0IVrVDmyrpzQcrr/ofUWqUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267650; c=relaxed/simple;
	bh=L5CyHeZZ4MlbfulEBtmqhpa4/L75Uon1TBy3oHxttEE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/SHJqWIX25MhgOEZlS4XKp6WvKRT6wRGN8ui0df3s6m8oH0vTamYM6sY7wJRvtYuiHG/4KciJO64SlE+8oy2qlkUrGGw65dCUPTTDiDNo+wV6Y4Uy3hVUKo+SKedznivJ+3R5Y4oWtU+m+m2tyVZOv3CBBi+AW1m9Msr+JVoak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WjQFoHRg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45611579300so47527665e9.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 03:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267647; x=1753872447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=WjQFoHRgYcayRZEbNOZlPybdlKhIr5U0kXrNz29GL8eS9eEwIzwdYFTz1IxRF5kukw
         gIFaFz00Z2gxVZmQLmKDmyzOZ5MtpJEZth3U64IuMiIOUc21quEKFadXKA7kKP6bvmnC
         aZ40YUVeyD8Od6BhHHd5JDFT4Lcf81rxpvs3FZHtWpyiP0pBLuWSS4AV6oYzz8I61ZYI
         SVamgOnuZP/wirRGPSaL08eDyrLdvp9g2yQjpOuU8CutV2FbXNeNCAWTlDBOzpjukLOH
         MADSd9KUPrUsalcRrSOGbd4vDjezxRnzk52TL8U6qpPzD5Bbw1L5Y9cuBiAwobvpWhgU
         OBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267647; x=1753872447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=klSLvPZdGJf21T5CxWAvpof28nK2FqTvAw9KK02b9rM=;
        b=Mnuq8nAVJBxE8pSHOP5sIXMy7tWTmJI5XZGWly3nfbEH7bSio4mld8NItBwmEycrt8
         UBn6FYX5+ZV3/XaT8HtZIXWFJUkxe4tNzq3caV2roa+zDeODNthabvXVRVfdWFqlcEqS
         gH3N+zfz6OFrDuawSiSc+dWastFd0AL/KLlrTsuEX0zAAYqVsk46NHHvEhoi402qYL4b
         B6/a9yU/aMLM2WUYjIyhpyhu8RNHkw7S5zp6hzsXmOZhxiF5RWpJISDZSSrqpASTHiaM
         Llcz7l+8koPLcaVV0vxSHlEdQxZwST38HolPcZqf3xnDnU6iphijC8BJncHUinY87494
         cEiA==
X-Gm-Message-State: AOJu0Yw+tDkpvaQeZMyCMUHFPvqkz/cHbdSk4TE5hSmnGtmsWUx9vRQo
	OYqb6zgsEqhrvHG0ZQeQShzp2KzoVSRRWa2zSLfKlzctzKueh5A6tnDXmJ0ek+tp6+a5N9yFYTv
	wpZUVoMad8h9P+pCJXOcpsPL2OSei9gmtMrl6lmockWXDeMT5pIoo6RLNcB61gK5JJTFZmglGi1
	x0wDP0peQzAfB+4Tfde1Qyaw0CuxA=
X-Google-Smtp-Source: AGHT+IF9GujN7e5PEevnbfhJVmv/zauyrMQPlcffBVgGfUsoXqo1KZ7TOBa+t16TTquYqLmxApIIyf6F5Q==
X-Received: from wmqe11.prod.google.com ([2002:a05:600c:4e4b:b0:453:86cc:7393])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f12:b0:456:f1e:205c
 with SMTP id 5b1f17b1804b1-45868c74efcmr21231745e9.4.1753267646461; Wed, 23
 Jul 2025 03:47:26 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:03 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-12-tabba@google.com>
Subject: [PATCH v16 11/22] KVM: guest_memfd: Track guest_memfd mmap support in memslot
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26bad600f9fa..8b47891adca1 100644
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
@@ -2490,6 +2491,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 67e7cd7210ef..d5b445548af4 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -578,6 +578,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_mmap(inode))
+		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.1.470.g6ba607880d-goog


