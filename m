Return-Path: <kvm+bounces-33747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E19B9F12D4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEA5B281810
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543771F2C5E;
	Fri, 13 Dec 2024 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCLhHEp5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC801F2391
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108511; cv=none; b=N8k4TlUaihOEZxW9Yxzf7dR7SLuvOfp0kNmJSn13X7mBN9qMu62cU4WGfRZcOzRLwKnWWY/2lZzsrT896h2XCscei7YoCJiPtS1l/owZHI67F6UYYam4rUvhiDZKwbx2EtBDwvGOKqdRrRxN/3mpTzX9pgbsgk+zA519u/3hvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108511; c=relaxed/simple;
	bh=HJ9evCiKrTr6pVEFTt9Uc9jd6JCIdDtaZlf4NLwhmDs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gQvpsakd+BHmMQgA2kpaAYAtNd8nAHhcYj/W2kQQh/y6p8aOE+yztLpjwUK2lp8hLYYD0AWmVRqCvjQvPB0IRjo0HvI4II9cL/BaM+WwqAk+cWrE3kTP+j9iGysPVaf1jorT7ckHkhFkHjZ48VUlFob9kWKtWt9NEG5LwwGbIZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KCLhHEp5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-436289a570eso12992045e9.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108508; x=1734713308; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vYAjt6KjlCWR3/9CjS9sdQrEPORDtZUsmbS3MjiJTDQ=;
        b=KCLhHEp5BCv5f/bO46MLYhE/ig8TCdFEl7gvN3Y7Ig34LuG3lhY/9q+S8wmY2N1miG
         hKPo2OWDsvnNGASu/8ihXN4Eb18LLW/e6Zs9c62tx4tYo/pUJqFZF3KGlaRV0jfDepqc
         UbbKplH9T2LYkmNY3Lo+8/HAm99s8ofkkZp9mfwtx3nhvZfW6ipUDAnBGoZx2SVp23Lg
         vZlmX4QjYjzOZ8Z20WfWYv4UnN1YMf7MtHLGueYHhehbUwe2r0LDdMkJQ+whG2uwaZJ1
         NFLK2Z5vDXMwDHBGwVQpeb92iyFyZBkGUxcZFp/X7hQA5GOZs++LXGItcDpDZBr9+ToE
         zyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108508; x=1734713308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYAjt6KjlCWR3/9CjS9sdQrEPORDtZUsmbS3MjiJTDQ=;
        b=wbXGVp1Bb5FPKcCnuMG+2Rft0gABg6EPzVSU+XCV29R2OMb/9QPMVz2rfucpZ1iZbB
         tD1EYyREv+7Smv3qQzSZ7c/brKYO8JDKyIjsN3b0NfygxrMD3P2QRhjWngiDh9MDXRbD
         J88XLzRwqBMearDZVeJUE72eEuv+FHqkHE7M/2Xw7GrZ/+TB+g1zHsNaTtkoy6yb2uB+
         PFC+s+KyX06POawC1ANGSoTQl/PnYiFLVEziwdxOQG038P4wncpASheKMZqcr536RIhf
         3L6Xto9jxmZBlYcQCZIsHvepgi+6FyriDWscMveIn93IRp89Dg7zciEOV93pIfqmc+4X
         Q8SQ==
X-Gm-Message-State: AOJu0YzN3XYVSCmWRQcBElOIzBVbc8W1WooT2t195AL6MIUs/0W3iHCf
	93FlhFv/hclWqW3PH57jMieusljQBcbC8Yjl7XpDCea39IHHPQkNBEoqqow+PfLXCBHlzIQzx/b
	UQN6mQ9zFAlrRcDwJvctr7E9s82anGBw3b41AZu2kRBsAHtg74oRRyqBNJUrrzvojDRZZNIsyIx
	qB1dxUL2WYas8KuI6xkKnFs+A=
X-Google-Smtp-Source: AGHT+IEuIo0g8Wj72K05W3M76Lwgy9hl7xYqHm8Z8UjN79dj1bkbMiQK/ObAF1ojkOHGGxPeIlJxjhjp+Q==
X-Received: from wmdv21.prod.google.com ([2002:a05:600c:12d5:b0:434:f1d0:7dc9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:524c:b0:436:2238:97f6
 with SMTP id 5b1f17b1804b1-4362aa1af5emr29426785e9.1.1734108507984; Fri, 13
 Dec 2024 08:48:27 -0800 (PST)
Date: Fri, 13 Dec 2024 16:48:03 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-8-tabba@google.com>
Subject: [RFC PATCH v4 07/14] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
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

Add support for mmap() and fault() for guest_memfd in the host.
The ability to fault in a guest page is contingent on that page
being shared with the host.

The guest_memfd PRIVATE memory attribute is not used for two
reasons. First because it reflects the userspace expectation for
that memory location, and therefore can be toggled by userspace.
The second is, although each guest_memfd file has a 1:1 binding
with a KVM instance, the plan is to allow multiple files per
inode, e.g. to allow intra-host migration to a new KVM instance,
without destroying guest_memfd.

The mapping is restricted to only memory explicitly shared with
the host. KVM checks that the host doesn't have any mappings for
private memory via the folio's refcount. To avoid races between
paths that check mappability and paths that check whether the
host has any mappings (via the refcount), the folio lock is held
in while either check is being performed.

This new feature is gated with a new configuration option,
CONFIG_KVM_GMEM_MAPPABLE.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Fuad Tabba <tabba@google.com>

---
The functions kvm_gmem_is_mapped(), kvm_gmem_set_mappable(), and
int kvm_gmem_clear_mappable() are not used in this patch series.
They are intended to be used in future patches [*], which check
and toggle mapability when the guest shares/unshares pages with
the host.

[*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v4-pkvm

---
 virt/kvm/Kconfig       |  4 ++
 virt/kvm/guest_memfd.c | 87 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

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
index 5ecaa5dfcd00..3d3645924db9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -671,9 +671,88 @@ bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
 
 	return gmem_is_guest_mappable(inode, pgoff);
 }
+
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
+	if (!gmem_is_mappable(inode, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
+		ret = VM_FAULT_SIGBUS;
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
+static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+#define kvm_gmem_mmap NULL
 #endif /* CONFIG_KVM_GMEM_MAPPABLE */
 
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -860,6 +939,14 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_gmem;
 	}
 
+	if (IS_ENABLED(CONFIG_KVM_GMEM_MAPPABLE)) {
+		err = gmem_set_mappable(file_inode(file), 0, size >> PAGE_SHIFT);
+		if (err) {
+			fput(file);
+			goto err_gmem;
+		}
+	}
+
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
-- 
2.47.1.613.gc27f4b7a9f-goog


