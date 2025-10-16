Return-Path: <kvm+bounces-60187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A48E8BE4DA9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 00FD04FC255
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1FE32B984;
	Thu, 16 Oct 2025 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CJFEjWk3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06610328B7D
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635819; cv=none; b=QIIys+B59Zbei6EL1RAfRbvu7UYqY56vEjdH3ggpKrye5+dIY/ZYILUWRU+7laTQDELV/E0SEChju/36fP0lXp1wO3RYA07KzrB8pV5evzgL9P0IDx0bMbNrSeKxoWxY1hpXdaC1EJHg4T4Tz3rkNr+L8Y47efCiBW6xPtn90Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635819; c=relaxed/simple;
	bh=oHD/pKXISr1Mkv48AhXYU4x8PV/y8rOdGSwdWWYiawI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lM01rfPVP8nkiJO3t8Skb/krYaGWQUQ4zaqAsaV7gi79eccHsJazGOvxlc+Zwa+IyTMYbWifdmQxkqyn/RW6a0cmGKgf+crG5IxJRUHvu5XkrCBOpE7e8YUMVvOuUEzgCQUqhDGzPpOWbTtS8yyWBQTxjwcHVwMXm+u7SWXPGR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CJFEjWk3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so326923a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635817; x=1761240617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=60UJyOOlPd6wRLEbpnoi5TtuF+cO4J6qbu8FcQfj4DA=;
        b=CJFEjWk3MvXiIXWbF1Bubaa1Il1vGpcmWIP1OuHpdNWASm9syR6Tbqwvz8vb0/uLyG
         gS5gO6JO5j0BZ9ZeE2Uw2ZEztEMkraGB204JxiDnlYPXyxek16wyZq+VVrXI9WqRwCuN
         MgJMycp1qheAmidSgONUMwm4S5Kzr68caEd9I9rUmxZrcA6cXgXM9QLkCVRrEPIimZpj
         jNx0Wks+0R4/awEdrpHzUKlG7elkUTDod6gJh10aOADbZ+yHH/snhA1DXUxJ57WRDuxM
         k6RDSGJA/1W3Y2ZwAo2t4I9vI9VxB8Glh4TtsABLpqs5HtjiRmEmfBmHxwlQ+zlunqID
         GGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635817; x=1761240617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60UJyOOlPd6wRLEbpnoi5TtuF+cO4J6qbu8FcQfj4DA=;
        b=tVOHkNeeNtuPVPgdxAW67w9bopjRcyHrkrzHxZl/aqdJ9ZqtDo8d+zW2jSNAhqmPOe
         tI271z4s6vlGNwuHVZSezzMiXk2VVI+mD9YMrUBKZ28ZwjctVMwt91tKnTkEpf1aT/ty
         UJ7V0y/lGUuSNNqF+Q0YrfcdwQjothq+7pzPRRxLe52e4S8SVw+4/m2ORlFA6+1DKTmp
         UrgUwxXpiBYQ6lRPBze1yaHmlVhmPPuB5Jix+f0DtHHgXCoTXVtaIxHI812kGCR7dWB9
         iY6+4kMQdYLiHxs88kXtKi428OKxzZQSwxTg1DgaywQOfn9qSEmy2Ggl3X6HFR4jKNy9
         2MmA==
X-Forwarded-Encrypted: i=1; AJvYcCU5EvasZiGHYqwDaMk6uv2NW9lDHMFyy0+U5LpR4hJW8ijYsKZmOmhVBy4sYWiq2KVuA8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDwWgpXH9xYOeA+OLgX0DjXmXMu0mpHS8S0DLLG0NKTrPat6TQ
	DEzElZvprOFlsssxX1l6de32d+I7tmwm3rZsoGEDNvcIXZlPeIawrt9IXOhAYZLIRckI8p4motG
	u0UDVUA==
X-Google-Smtp-Source: AGHT+IFcs9B/qCYOsWmtZzq14oPESjBkFJ9nBCJwMUyetaJnGRYqGcMBfINCMOMd2YxxJXmxDfq4dgLvfo8=
X-Received: from pjha21.prod.google.com ([2002:a17:90a:4815:b0:330:9af8:3e1d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c10:b0:32e:a10b:ce33
 with SMTP id 98e67ed59e1d1-33bcf8facf2mr645651a91.21.1760635817441; Thu, 16
 Oct 2025 10:30:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:46 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-6-seanjc@google.com>
Subject: [PATCH v13 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Previously, guest-memfd allocations followed local NUMA node id in absence
of process mempolicy, resulting in arbitrary memory allocation.
Moreover, mbind() couldn't be used  by the VMM as guest memory wasn't
mapped into userspace when allocation occurred.

Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
operation.  This allows the VMM to use mmap()+mbind() to set the desired
NUMA policy for a range of memory, and provides fine-grained control over
guest memory allocation across NUMA nodes.

Note, using mmap()+mbind() works even for PRIVATE memory, as mbind()
doesn't require the memory to be faulted in.  However, get_mempolicy()
and other paths that require the userspace page tables to be populated
may return incorrect information for PRIVATE memory (though under the hood,
KVM+guest_memfd will still behave correctly).

Store the policy in the inode structure, gmem_inode, as a shared memory
policy, so that the policy is a property of the physical memory itself,
i.e. not bound to the VMA.  In guest_memfd, KVM is the primary MMU and any
VMAs are secondary, i.e. using mbind() on a VMA to set policy is a means
to an end, e.g. to avoid having to add a file-based equivalent to mbind().

Similarly, retrieve the policy via mpol_shared_policy_lookup(), not
get_vma_policy(), even when allocating to fault in memory for userspace
mappings, so that the policy stored in gmem_inode is always the source of
true.

Apply policy changes only to future allocations, i.e. do not migrate
existing memory in the guest_memfd instance.  This matches mbind(2)'s
default behavior, which affects only new allocations unless overridden
with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL flags (which are not supported by
guest_memfd as guest_memfd memory is unmovable).

Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/all/e9d43abc-bcdb-4f9f-9ad7-5644f714de19@amd.com
[sean: fold in fixup (see Link above), massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 58 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 88fd812f0f31..4463643bd0a2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 
@@ -27,6 +28,7 @@ struct gmem_file {
 };
 
 struct gmem_inode {
+	struct shared_policy policy;
 	struct inode vfs_inode;
 };
 
@@ -129,7 +131,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
 	/* TODO: Support huge pages. */
-	return filemap_grab_folio(inode->i_mapping, index);
+	struct mempolicy *policy;
+	struct folio *folio;
+
+	/*
+	 * Fast-path: See if folio is already present in mapping to avoid
+	 * policy_lookup.
+	 */
+	folio = __filemap_get_folio(inode->i_mapping, index,
+				    FGP_LOCK | FGP_ACCESSED, 0);
+	if (!IS_ERR(folio))
+		return folio;
+
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
+	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
+					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 mapping_gfp_mask(inode->i_mapping), policy);
+	mpol_cond_put(policy);
+
+	return folio;
 }
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
@@ -411,8 +431,40 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 	return ret;
 }
 
+#ifdef CONFIG_NUMA
+static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+
+	return mpol_set_shared_policy(&GMEM_I(inode)->policy, vma, mpol);
+}
+
+static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
+					     unsigned long addr, pgoff_t *pgoff)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+
+	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
+
+	/*
+	 * Return the memory policy for this index, or NULL if none is set.
+	 *
+	 * Returning NULL, e.g. instead of the current task's memory policy, is
+	 * important for the .get_policy kernel ABI: it indicates that no
+	 * explicit policy has been set via mbind() for this memory. The caller
+	 * can then replace NULL with the default memory policy instead of the
+	 * current task's memory policy.
+	 */
+	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, *pgoff);
+}
+#endif /* CONFIG_NUMA */
+
 static const struct vm_operations_struct kvm_gmem_vm_ops = {
-	.fault = kvm_gmem_fault_user_mapping,
+	.fault		= kvm_gmem_fault_user_mapping,
+#ifdef CONFIG_NUMA
+	.get_policy	= kvm_gmem_get_policy,
+	.set_policy	= kvm_gmem_set_policy,
+#endif
 };
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
@@ -864,11 +916,13 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
 	if (!gi)
 		return NULL;
 
+	mpol_shared_policy_init(&gi->policy, NULL);
 	return &gi->vfs_inode;
 }
 
 static void kvm_gmem_destroy_inode(struct inode *inode)
 {
+	mpol_free_shared_policy(&GMEM_I(inode)->policy);
 }
 
 static void kvm_gmem_free_inode(struct inode *inode)
-- 
2.51.0.858.gf9c4a03a3a-goog


