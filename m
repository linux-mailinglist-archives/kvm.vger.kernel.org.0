Return-Path: <kvm+bounces-53690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E98B1558B
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 00:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF2A3A8BBC
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 22:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3A12BEC57;
	Tue, 29 Jul 2025 22:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qw/IIqlV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916202BE7A0
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 22:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753829749; cv=none; b=lONtmjycxkRG6dSlchS/ibVOl14p9auKvxNjQFH0gjU+YAEy/qUmUbyhwknm54If9Qd7ZV9e8Pgiv4NTeFI0BEcGnb1xx7RJmkFPfKr+QMWbuqgb7dEjh3ZLL8xLQOK6u6TKQLNmN/Py4YL4nOTg/hCNb9UvEnEUmTd4UOoa9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753829749; c=relaxed/simple;
	bh=Xbe974jAg04TIW9HfK3Y4I+nikYFzuKAbkXN+KFWFPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n78wbaglQbmX3LLCNnSGUXEWZmW0CzoHHRMrBFGhfZfba9Wy4jT6V00L/WoQxAXO1Mo7xcaTWJ8MZDa+LQAY7yB+BBldfAAkzM/sDwFbpbbExMAjonNH+VbX6LhXua4JuBBLRljHXWkUkVLVKGkLea8HhBPWSkLf2LgSGVzk7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qw/IIqlV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2400cbd4241so32354755ad.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 15:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753829747; x=1754434547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tn1mSBLO+YLVwstEyyon9JR/mQU0lWjJcGUdOXFvVvs=;
        b=qw/IIqlVlsHtwrrpV317Ga6/K1j02MpDgvhCP9CenNVJ1OH6SwpLhbJgPl+LbtafLE
         OKuQUOFqPc9wzLjIbBKEvcBX4bT8M3e+KMw+LYWyyAFJj3fwyh9LlVQgLq0NOBBMppIA
         lOCHUobchVa38CMjb/lKZQ7eUmbBEzU+JS29rlTeA+udEdvyZhqXDei8W0LtBH/Bv8KR
         B90ZqKtMhuapcKZ+eYwCiEhg7vzeFaPV3rNcS+7iuD+AT/8/ZWY6ZAMu+OqYQ1aFSEhU
         /Vwm3Cjuj4DgTpF5FvsjAmxLGRUMo5Xp8Uc6rQtzxGQoEZ5n02DrxVLaDslXJw1iEtGV
         qg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753829747; x=1754434547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tn1mSBLO+YLVwstEyyon9JR/mQU0lWjJcGUdOXFvVvs=;
        b=iuBalHXttoDysPd9hfNmRMpg6lHAbG/GQICqajghukO0LkVVWGy5MZcCDWGgsBA13z
         rX0LU8ClbPkbCP5racP+biojjU7E48/ttQlNnFmKuUJBojXHFtj23vGh/FJq0qjszDaX
         /N0ltRm5ZSVYz5O7qJ2EFg1B2w1y6Ehw3l9IfME9Ix9VOGKkml37lJG6qPwqJxnyuB1Y
         Go0eITLPHHvUBD+EKs5LOTHOkZcmuMPmYNSphO2pZftzIvRIlU23qxRQyoSJ/KCchloH
         sIY8NrUcbRYWmkTuqhg2FAuzKjZiixaC22wUYxAHoqo7Iayi4rIiGnHP20dMUyvIoX7M
         98zg==
X-Gm-Message-State: AOJu0YyNkvgEqC4PNNZVBXbbCqLNOpPmK/OxFIbj0dm9RAAvvuk8JH09
	oswCc5/ec0GfJl+iMcTHFytnSQ9e7nsMWOtNK19IgD+fn8p6UwhWKQ2CAIClZOXOAh4lcGfz8IM
	Z1CsZkQ==
X-Google-Smtp-Source: AGHT+IHAFJZIedsHoBlxMRk1Os6nimsUyZRbs4o25k9lGhNMmtWWfdhx2zaS8kMkKKU+mHoV57Vx/+pszAo=
X-Received: from pjk4.prod.google.com ([2002:a17:90b:5584:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d505:b0:240:6740:6b11
 with SMTP id d9443c01a7336-24096b0faa3mr13034795ad.40.1753829746789; Tue, 29
 Jul 2025 15:55:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 15:54:41 -0700
In-Reply-To: <20250729225455.670324-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729225455.670324-11-seanjc@google.com>
Subject: [PATCH v17 10/24] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

Introduce the core infrastructure to enable host userspace to mmap()
guest_memfd-backed memory. This is needed for several evolving KVM use
cases:

* Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
  entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
  provides a unified memory management model and simplifies guest memory
  handling.

* Direct map removal for enhanced security: This is an important step
  for direct map removal of guest memory [2]. By allowing host userspace
  to fault in guest_memfd pages directly, we can avoid maintaining host
  kernel direct maps of guest memory. This provides additional hardening
  against Spectre-like transient execution attacks by removing a
  potential attack surface within the kernel.

* Future guest_memfd features: This also lays the groundwork for future
  enhancements to guest_memfd, such as supporting huge pages and
  enabling in-place sharing of guest memory with the host for CoCo
  platforms that permit it [3].

Enable the basic mmap and fault handling logic within guest_memfd, but
hold off on allow userspace to actually do mmap() until the architecture
support is also in place.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
[3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       | 11 +++++++
 include/linux/kvm_host.h |  4 +++
 virt/kvm/guest_memfd.c   | 70 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..e5cd54ba1eaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+/*
+ * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
+ * (the private vs. shared tracking needs to be moved into guest_memfd).
+ */
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return !kvm_arch_has_private_mem(kvm);
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
@@ -13531,6 +13541,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	kvm_x86_call(gmem_invalidate)(start, end);
 }
 #endif
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4d1c44622056..26bad600f9fa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -726,6 +726,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a99e11b8b77f..67e7cd7210ef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,72 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_mmap(struct inode *inode)
+{
+	return false;
+}
+
+static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+		return VM_FAULT_SIGBUS;
+
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (IS_ERR(folio)) {
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			return VM_FAULT_RETRY;
+
+		return vmf_error(err);
+	}
+
+	if (WARN_ON_ONCE(folio_test_large(folio))) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		kvm_gmem_mark_prepared(folio);
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
+	return ret;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault_user_mapping,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!kvm_gmem_supports_mmap(file_inode(file)))
+		return -ENODEV;
+
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -391,6 +456,11 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
+bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return true;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-- 
2.50.1.552.g942d659e1b-goog


