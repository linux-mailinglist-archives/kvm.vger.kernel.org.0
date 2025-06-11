Return-Path: <kvm+bounces-49056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B87AD5732
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B1DC3A3A46
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726342BD03E;
	Wed, 11 Jun 2025 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BOa+cbpX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26932BD028
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648834; cv=none; b=KMEnoncSRpYUeImy6ZVGR/3+KEE1m0kq4lCftmVwOamwNgdWd+ASlGMNAijM4/4ekbPw9cXiJFP7YIEcSkdc61+aaf8OZgxfMbUc2W59MSELq35wVEglnv2/4giflbIIhkL0uxlPb1K3GAF43JL5PuXPvcQ5KCdZ5w+AYdJrfyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648834; c=relaxed/simple;
	bh=aCenjq/osErk0/gBDBOPBX37s9T4n/NKqJy9NLYSATc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JBXRc8yUdB8XMYMVOwyBAgixECpudNQ8BnAzPDWq0e2a1g/hcOV7yYex3ktvNLlZpXXJ+a+ZCWLHVN4VbNx8C/rxOfoDOEz91icXYMZr89UnFo1SRYi8bChNY7FmhWN79xFfYoaRNWxgbggGGwDxutl0Q4YaDEtGjGmSyYl7ZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BOa+cbpX; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso22564755e9.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648831; x=1750253631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcUaSO3kSOt8yI5c1YYgZJy8/Nv04Up4U/cxCnhaQoo=;
        b=BOa+cbpXKDkng5IUQ/gqXQWj71mqRbUANGefKoRtTOVP/axwl4gSKrA6Eocv/Bxehs
         Ij+GK7Fgsso9EsFa1QQ7FXoM2ifxI7LnEqX2VzCEH4wGD0r2+18KrCofowbNzgqj/uVn
         UBTHm9Gwpf+363qOG4I6BfWIu1Y5mzobdKDOTV5om1DFxhCwmFuFZpN3KD42xg25jg67
         Jd9ETTLtaDIhx9Ap2vIlQFbsVFc9FZ/1Ka4+xRCvH6pYxsFuMb40B6cUko1Y3zALPfnZ
         aHnZlAtI9V67ioyzvtSrZmhKCvrW0gKDxdRwDGFFZEmilFAN0fcb1KeTzgOOLiT7ydED
         g9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648831; x=1750253631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcUaSO3kSOt8yI5c1YYgZJy8/Nv04Up4U/cxCnhaQoo=;
        b=CUJSANK3y2QcNPAcDVFzagTCWw74pX3SHsFDJye8CCBa2xUSZZKy0f1bQZc7UpfYZd
         wF5olOb6BIfVwaiQxBCgk1U0a7rL9VOzv6MHIEcs46vk28LOsgLWhiIYryj/XllcQsQu
         6f2eYLxVWGkFMG4a4+4ZJPsWIXw6nLuTw+Su3NMMncUGdiqZM3AFMjSBQ2F1225BA2XC
         oqYPjPsuS5dfhlACtBlXn6a9okCNs6sCXuLggGTYN0J5YzO6ZoyaGdXyOImN0s0eI5Te
         /zb44aEoeRbCNuRhS9do3rv3vysWgkNzBH4/lNFK3GECFaP8NjKXKSUA4bb12Ops7xn3
         PYLw==
X-Gm-Message-State: AOJu0Yz4GvZpC1Qwjz7270zPLfTlFUaohhpkeuZGuSkz9Ti8ROHlwLTf
	PrHm5IexrRo8YvbYmCKVkviW1C5sqdFEFGdmGvyM6cw74q+smGGxS2GNUP8lo7VhVlXfEviv7UJ
	6OzF6U72oJ48B8Wfk8le7jAsEh0TZYZzR/eOGHme3gU/rcT6kedrLEWid8DrpmHMVmtmpkptX6w
	9Pp0+qFBLCjH3NXR7ACzP+R9wizp0=
X-Google-Smtp-Source: AGHT+IEQJp1MO1Qe/j84OGHbzIcWoKPAALChchZ3KOUi17k1TGhTtWrYDnxKKdMZ3WUIwsAkbY5Mkj9wdw==
X-Received: from wmbjh9.prod.google.com ([2002:a05:600c:a089:b0:450:cb8f:62cc])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c7:b0:39c:30cd:352c
 with SMTP id ffacd0b85a97d-3a558a9ae6amr2386549f8f.8.1749648831011; Wed, 11
 Jun 2025 06:33:51 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:21 +0100
In-Reply-To: <20250611133330.1514028-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-10-tabba@google.com>
Subject: [PATCH v12 09/18] KVM: guest_memfd: Track shared memory support in memslot
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

Add a new internal flag in the top half of memslot->flags to track when
a guest_memfd-backed slot supports shared memory, which is reserved for
internal use in KVM.

This avoids repeatedly checking the underlying guest_memfd file for
shared memory support, which requires taking a reference on the file.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 11 ++++++++++-
 virt/kvm/guest_memfd.c   |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6b63556ca150..bba7d2c14177 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -54,7 +54,8 @@
  * used in kvm, other bits are visible for userspace which are defined in
  * include/uapi/linux/kvm.h.
  */
-#define KVM_MEMSLOT_INVALID	(1UL << 16)
+#define KVM_MEMSLOT_INVALID			(1UL << 16)
+#define KVM_MEMSLOT_SUPPORTS_GMEM_SHARED	(1UL << 17)
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -2525,6 +2526,14 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 		vcpu->run->memory_fault.flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
 }
 
+static inline bool kvm_gmem_memslot_supports_shared(const struct kvm_memory_slot *slot)
+{
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
+		return false;
+
+	return slot->flags & KVM_MEMSLOT_SUPPORTS_GMEM_SHARED;
+}
+
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 06616b6b493b..73b0aa2bc45f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -592,6 +592,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
+	if (kvm_gmem_supports_shared(inode))
+		slot->flags |= KVM_MEMSLOT_SUPPORTS_GMEM_SHARED;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
-- 
2.50.0.rc0.642.g800a2b2222-goog


