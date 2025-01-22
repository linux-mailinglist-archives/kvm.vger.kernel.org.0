Return-Path: <kvm+bounces-36257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B078A19527
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:28:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 884B8188B8DA
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE422147FB;
	Wed, 22 Jan 2025 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kl3Hdewa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D34E2144B6
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559665; cv=none; b=CPxbHTsnB5W/hGBOeVD2hhxLVlZu+duYZwXUmUrckyF2WznW84kDXNOF4miF3J644GsE/tinTDp4dhM7EF5gXzB6S41LZIJcJ1oDIG0IBITboCeR3ukNTrVFwP8HA6BFY8LqWxBfRcLuX+3Q1oWUJm9F9ZQsY7iHN8hWvSsSc8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559665; c=relaxed/simple;
	bh=YoLt3jg672qLkVcu7VIEZbT4qXMy3Xl6u3hot8yMq0w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ny47p5X1yPLV0FPejbx1PQTlczcRz9+F298p2X6gaQGZ8GnDWjPEy47dN/Szhq22kCfJavVOHIJB10wGSMfzyy5s7GrNUXkVUDXtXmgotO0r7jKsnuCWoyJcGgTGakdtSd1F8FZRlpETvdAzz0OzI2y0FJ8JsvEhUYYgIvpeOjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kl3Hdewa; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so38933585e9.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737559663; x=1738164463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDcetJFcXF4ZQue9UQkLlQm0kzILtlW6lFAnbaIvucU=;
        b=Kl3HdewakC6e3TUCJGah+GdKZ7PuGcSKku8Des/NjtxtKm+R84v1xav9Xz8F8UFOfk
         HsykueYFQIaThtc4BarPS3kEjMNb0xqMMa2UFlgq76hagJ4RMIswVfqcTx0AiNGTd/gr
         l8FGHFMIBPCsrFEnjNnQOH9Zm3nePmjxze/8KRljlzeN/eIAQ62796g9SOVk5cGrstZY
         CLb6P21TOAfybhDYG4P6eiCCdRc3alyEc3Np1QBBHBeKETSEAvU9Q2BD0WO7I5aBlHZY
         zgu1s+pbvb/3pP8t8dkMw1SQsDjuZW+m3nNE+DMn5t4UeJBe/49F7HHFFL78OpQxm7VL
         4i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737559663; x=1738164463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDcetJFcXF4ZQue9UQkLlQm0kzILtlW6lFAnbaIvucU=;
        b=O1pmq9atT8JdNsCkWlELxP4tFpLLfzYtDQ2lnrytlwPJZ6t9ko022LiiODLz+dABNW
         B3Jt0zYpMX8whMb4m3e+3VFxFUeVTpWBE/Dptdot78QtTRkpKdWwtUkpMSqQnVV8Xdsa
         bUulnNPwr1LDojlS9rbtRHkVQFPo4l30/a+Llb47qN3OfYZvv85Foca7+5mHBm4KV8Ti
         nkVDFCxQz+Nr/PRLwKROq9YIN7XzLx76Uy5ZFrVSo2u7FCXilQaJH6g7znWRQhcqB1kS
         nwdyiUiIpYC053o1wGa/zANgrK13z718CsttBzqfZHJHvXp6WTK5VZacO/sdLa9vxcMB
         KuTw==
X-Gm-Message-State: AOJu0Yxq/LPg0cEE/KcPz95SeZLkK18y/6GogUXq+8hDdGwwQbT/SKU+
	9LoKKjc0AQzgv+6NpeWfVkjxRa/m6o6nvdceWr1Xseue0PL1nf4TfIeSoK1Phs1E4oNeLjfK81T
	gZY6xeNmV26V4dp9tBetsJ7FoXd3fDzFKb1sRuvxBMvjJHH7dbJZnsEB9NETIuDwFz5wBOYRIhN
	SPFNr65dpr5r74uszM7mg8ewY=
X-Google-Smtp-Source: AGHT+IF8KsDXB6MILYgdI4bjHbLtTHjfa5HGKAzChHRDB4DnJXkZq0oaXJyTUpB5YHGdtSJAjVRTemZsTA==
X-Received: from wmow21.prod.google.com ([2002:a05:600c:4755:b0:436:e755:a053])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5101:b0:434:f925:f5c9
 with SMTP id 5b1f17b1804b1-438913c85e0mr201044935e9.6.1737559662645; Wed, 22
 Jan 2025 07:27:42 -0800 (PST)
Date: Wed, 22 Jan 2025 15:27:30 +0000
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250122152738.1173160-1-tabba@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250122152738.1173160-2-tabba@google.com>
Subject: [RFC PATCH v1 1/9] KVM: guest_memfd: Allow host to mmap guest_memfd() pages
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd in the host
for VMs that support in place conversion between shared and
private. To that end, this patch adds the ability to check
whether the architecture has that support, and only allows mmap()
if that's the case.

Additionally, this is gated with a new configuration option,
CONFIG_KVM_GMEM_MAPPABLE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 include/linux/kvm_host.h        | 11 +++++
 virt/kvm/Kconfig                |  4 ++
 virt/kvm/guest_memfd.c          | 71 +++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..c0e149bc1d79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2206,6 +2206,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 #define kvm_arch_has_private_mem(kvm) false
 #endif
 
+#define kvm_arch_private_mem_inplace(kvm) false
+
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
 
 static inline u16 kvm_read_ldt(void)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3..ebca0ab4c5e2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -717,6 +717,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_private_mem_inplace if support for private
+ * memory is enabled it supports in-place conversion between shared and private.
+ */
+#if !defined(kvm_arch_private_mem_inplace) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+static inline bool kvm_arch_private_mem_inplace(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..59400fd8f539 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_GMEM_MAPPABLE
+       select KVM_PRIVATE_MEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 47a9f68f7b24..9ee162bf6bde 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -307,7 +307,78 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_filemap;
+	}
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		unsigned long nr_pages = folio_nr_pages(folio);
+		unsigned long i;
+
+		for (i = 0; i < nr_pages; i++)
+			clear_highpage(folio_page(folio, i));
+
+		folio_mark_uptodate(folio);
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+
+out_folio:
+	if (ret != VM_FAULT_LOCKED) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+out_filemap:
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	return ret;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct kvm_gmem *gmem = file->private_data;
+
+	if (!kvm_arch_private_mem_inplace(gmem->kvm))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	file_accessed(file);
+	vm_flags_set(vma, VM_DONTDUMP);
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+#else
+#define kvm_gmem_mmap NULL
+#endif /* CONFIG_KVM_GMEM_MAPPABLE */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
-- 
2.48.0.rc2.279.g1de40edade-goog


