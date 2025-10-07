Return-Path: <kvm+bounces-59601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEB9BC2D5B
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 00:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52BDD3B2452
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 22:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B398269CE1;
	Tue,  7 Oct 2025 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JihKOyBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7864264A7F
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 22:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875288; cv=none; b=IVUxGb0pogRnkVWtEALlYM1nTBLP3uQLk6BvTD2W1TsGQJ41h3WCxDtpqq1Z0TtNbok06QEFla7KCP7/uyqWVYI5s3rgvftenwX/vTGcGKDQ/zlFG7/YVyJ3nrIvRURUmcFyjHnFCUucVuLHKZvwqR6afETBwDvR50LteZmmfRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875288; c=relaxed/simple;
	bh=vJiVcm/hHEBDVcPDPylwZWAoBHhJCbfQE2uP4IJza8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BM3O0N8yM9Rh+UXNCu3kH+qGIz3S1+OtATjDBHkC7C3EFoNhv5aFiKSFP+C3hiiPeVb4GdswzcXalX2M4q+c1CueVrnUviKnLhZv2r9onIpL5/ANOj/VAoH9zxKU8MWskWnCW7XmVgdBxZ8G/6TU6EeVEfwlb1U4x6P7IEeJSM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JihKOyBM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7810289cd5eso10842971b3a.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 15:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875286; x=1760480086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gNU+HQsGvlmXwK42mozGB/w8m3B2kCFg6kDxESGSNsw=;
        b=JihKOyBMq9MxSARhV6e27Rutc+dMr8Bou+rrm1b4wWYdwvo3m+pmEQcN1PqwW/iPWA
         2aHSdsgS+UaXsQT/7b59Hx1f0ABRDeRnrzICPqgevQAljmKEBZNYyj3vVsf4PdrtuZKg
         6YYCKGIe4d97Kyx20zeu30O9Ts7+Kj+xCtzKlgrhM+ISXECTjalgE/hOhawtKSbsHvk8
         kqH4Z/qY+TC781ZZN+I0DB9M4ovb5MNLE1cj5iWilr3yseqeBaNZwUa28rSRhERQblFX
         O5CzmMogZGeqSP2nnaVzTTRJYXX/sNkxZnVR7IUzJF+ldGpREA1y3R8hAXJgV4s36I3h
         sAPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875286; x=1760480086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNU+HQsGvlmXwK42mozGB/w8m3B2kCFg6kDxESGSNsw=;
        b=cxXfy60v8aWxErNCWdRW05rUaY8LxPXCj40UC4v1dYPw07CaihINF/oGcT0lHr9b+0
         LZvJV+qqt+AQIJdnIGeV2X+pPVCTo6jJAeP+jE7MR6Qwwmh019kUEgJc59Pop5X7s55a
         ZBYRtCIiqkM1qgr9+z9vTO7CYafZEgryA/O2gdWqy2wsUyOlfKYGazy04BxTipFqknDi
         rnr9Uk9QNXx545s4BRZv8Fz5OUDpE2wF11dtDCQT5W7PM7Bii1GX5uIjePltvSI439Y/
         ND1UVXvgiMhgUgPlMaUnR3NYFcXHnoVdZNZ0+VK1Rw/C2B3R2MPTZVmSWp2OZxq4GHNJ
         rR2A==
X-Forwarded-Encrypted: i=1; AJvYcCWJ9NITrsVV1RKVhhJsmj8sUOie3XAxipdiyNinVMVYtN7c4mwkGBWJCn40rYJa2wJWSBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwE4g35+L89wSEoOFvp1Z+LIXmmZcYKkK8Zu1DFQAQo6gL9VOrF
	KTLgbPG1QQ8809WORYYf1bGi1uWIXPhYtxXlPUePMcO8lDepBHRBZcQTT0o+0h2HsOE8SWy93/d
	JpKN3DA==
X-Google-Smtp-Source: AGHT+IGsPoJFOynSay0ELmZDfFhnfNRyjkBL7llPocXzISl5rOG0O7IaOg1XPUo94bJb1i3k0OW8/UjXMo0=
X-Received: from pgam19.prod.google.com ([2002:a05:6a02:2b53:b0:b63:2a6b:80b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7187:b0:2fb:add5:5574
 with SMTP id adf61e73a8af0-32da845e5d8mr1080588637.47.1759875286183; Tue, 07
 Oct 2025 15:14:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:13 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-6-seanjc@google.com>
Subject: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

From: Shivank Garg <shivankg@amd.com>

Previously, guest-memfd allocations followed local NUMA node id in absence
of process mempolicy, resulting in arbitrary memory allocation.
Moreover, mbind() couldn't be used  by the VMM as guest memory wasn't
mapped into userspace when allocation occurred.

Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
operation. This allows the VMM to map the memory and use mbind() to set the
desired NUMA policy. The policy is stored in the inode structure via
kvm_gmem_inode_info, as memory policy is a property of the memory (struct
inode) itself. The policy is then retrieved via mpol_shared_policy_lookup()
and passed to filemap_grab_folio_mpol() to ensure that allocations follow
the specified memory policy.

This enables the VMM to control guest memory NUMA placement by calling
mbind() on the mapped memory regions, providing fine-grained control over
guest memory allocation across NUMA nodes.

The policy change only affect future allocations and does not migrate
existing memory. This matches mbind(2)'s default behavior which affects
only new allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL
flags, which are not supported for guest_memfd as it is unmovable.

Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
[sean: document the ABI impact of the ->get_policy() hook]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 69 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index cc3b25155726..95267c92983b 100644
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
 
@@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
+static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
+						   pgoff_t index)
+{
+#ifdef CONFIG_NUMA
+	struct mempolicy *mpol;
+
+	mpol = mpol_shared_policy_lookup(&gi->policy, index);
+	return mpol ? mpol : get_task_policy(current);
+#else
+	return NULL;
+#endif
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -124,7 +139,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
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
+	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
+	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
+					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
+					 mapping_gfp_mask(inode->i_mapping), policy);
+	mpol_cond_put(policy);
+
+	return folio;
 }
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
@@ -413,8 +446,38 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
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
+	 * Note!  Directly return whatever the lookup returns, do NOT return
+	 * the current task's policy as is done when looking up the policy for
+	 * a specific folio.  Kernel ABI for get_mempolicy() is to return
+	 * MPOL_DEFAULT when there is no defined policy, not whatever the
+	 * default policy resolves to.
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
@@ -867,11 +930,13 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
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
2.51.0.710.ga91ca5db03-goog


