Return-Path: <kvm+bounces-47814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F44AC59CB
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 20:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0F4178EBD
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8009280304;
	Tue, 27 May 2025 18:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OmePf3YE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B386283FD6
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368988; cv=none; b=T3McJ10yIb52Vp1d5ZrH8HWQyuvHeNtYXjoJGL07sm4AuSlts+W8Lsj+HkN5jAzxBWlld0DX8RKzmwbuziwpAvmLiKia+ZMg0JRwoaxjCZ4DgHklxF5EGPBfbvHKCO0qiKxcQQSBusPqEHmip2j0MZAhyYQ18mXSR3E4Y3/er8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368988; c=relaxed/simple;
	bh=ToeqWmtFdT7WRUcr7H559dqp9JvTbbU7zFXWYMbde+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sEWRcxEd5uuQGK8mCFDntxAqJZ0AjAi8aantT09FLVl3HoxynHSmcQh1f551ykPJRMXj1xFsGqs5luTJx38G9PFa9b0kdi3+SO2IDKFF1X4SbmMgZA2UKPEI7os7otKji1D9Ff11BqqW3uJOrvg3cAJcFHz8XkLh9BattDs93XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OmePf3YE; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ea256f039so29029335e9.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748368985; x=1748973785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vX7z/HyuGmtzDlVVFq4xd5F5VW4gqdbtxi0TML5OdT8=;
        b=OmePf3YEKWaba2hBegrE4uXQXJHGEODThC29svQswBGFDZtLK+SZ7/keAf01fIiUcN
         0bc8zC4ulzWDjOVkJBE+GBEtw8u3Yc4RExjBYDGudlHX32g81bXNte2aHGAbmFfTYCav
         x4VEGYrkAx5H5/phsY0ysK3dDzlR7dYKQ0U4ByHhUYTbtp62bLqAygfqISAspwk4pcFu
         fHDjAbpFUi0Li6ConUnfxCWu5yCkJKxdcVlv5AQzV7WAGvUNdSessN/LE0QPXeBqhBU0
         AHubtqosPkJiIECJNT6YWXZL+XrqMwavw3yXvqFl6JFO90doqeJpqFypauCDBWT/G0zc
         Tp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748368985; x=1748973785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vX7z/HyuGmtzDlVVFq4xd5F5VW4gqdbtxi0TML5OdT8=;
        b=QctGc1694ashbtp5UTT9w+53vR3aP9QHqjyt55Ly+w2zPpO4wQzEGuSvge90wU3V8X
         JKLWpXBUu7wp5/HbT51vQbO79MDQ5NeVKe41tI88nRtWzh83wb5bBqx7U4JRCnM4vGRe
         bRQbAAa1D/w50C9bdxrGUI1OJGIWGcIaW0fcTbP0hU1R42ZCKHbj7dR4ncuHQQGVktSt
         h3X8QVubqxiUS229oEgrx+qW8oXHQde9hSFZYHIx4BdCg3YrvbvPxeg1YOkjm0ij/Tvy
         MIKz7v7O7tQeDm70IwSyPY7YWwcqmF2ZUhnUrR79iMf4HHh/LeRKw3evnbRf+y4fgfjf
         nwXA==
X-Gm-Message-State: AOJu0YxFEWjQhNwJkfnOtuXXGWy+F369mt+oBCrNWbDknuGEZsxnUWuq
	D/nSr1bE2WO6T5fCucyEzl0nNaGlx0N+8MI5ujceq0DXg7sM1jch4zn+hkEZOi37y+pw4LkNeo+
	2Vg4PIp9S+UKsZQiV1Z1ByKBUpJjaOf30bXu4yGrn4gMVRjbknTbceTejoXFzde3dMG6UaJpyq2
	EOymvLTv420XWgM1SJ/LbGAFLJ60M=
X-Google-Smtp-Source: AGHT+IHm2QpLuppopnrLbiEdYMpqiHL9Z+DX8uPYQe0kFHM4Ap6KdDfZYYe7oYWFnkWPUHOflJMK8/QPyw==
X-Received: from wmbbi21.prod.google.com ([2002:a05:600c:3d95:b0:43c:ebbe:4bce])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f43:b0:442:e0e0:250
 with SMTP id 5b1f17b1804b1-44c933ed7efmr124297415e9.29.1748368984939; Tue, 27
 May 2025 11:03:04 -0700 (PDT)
Date: Tue, 27 May 2025 19:02:38 +0100
In-Reply-To: <20250527180245.1413463-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1164.gab81da1b16-goog
Message-ID: <20250527180245.1413463-10-tabba@google.com>
Subject: [PATCH v10 09/16] KVM: guest_memfd: Track shared memory support in memslot
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

Track whether a guest_memfd-backed memslot supports shared memory within
the memslot itself, using the flags field. The top half of memslot flags
is reserved for internal use in KVM. Add a flag there to track shared
memory support.

This saves the caller from having to check the guest_memfd-backed file
for this support, a potentially more expensive operation due to the need
to get/put the file.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  8 ++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ba83547e62b0..edb3795a64b9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID		(1UL << 16)
+#define KVM_MEMSLOT_SUPPORTS_SHARED	(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2502,6 +2503,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_SUPPORTS_SHARED;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5d34712f64fc..9ded8d5139ee 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -555,6 +555,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	loff_t size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
 	struct kvm_gmem *gmem;
+	bool supports_shared;
 	struct inode *inode;
 	struct file *file;
 	int r = -EINVAL;
@@ -578,8 +579,9 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	    offset + size > i_size_read(inode))
 		goto err;
 
-	if (kvm_gmem_supports_shared(inode) &&
-	    !kvm_arch_supports_gmem_shared_mem(kvm))
+	supports_shared = kvm_gmem_supports_shared(inode);
+
+	if (supports_shared && !kvm_arch_supports_gmem_shared_mem(kvm))
 		goto err;
 
 	filemap_invalidate_lock(inode->i_mapping);
@@ -600,6 +602,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (supports_shared)
+		slot->flags |= KVM_MEMSLOT_SUPPORTS_SHARED;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.49.0.1164.gab81da1b16-goog


