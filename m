Return-Path: <kvm+bounces-28397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79ECB99815E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A82F1C26205
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1C01C57BA;
	Thu, 10 Oct 2024 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fx6lOYcY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8D31C3F32
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 08:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550786; cv=none; b=Ov3MSgmFvYnGcC9NLnsJGo/iwCq0KxTJ9e7T18bi0WfVRQUpGj0dGdOdjztVcHweY3DwdJ43/Y061CBfMmkr6NZjQ7+eJLmI9+l7McuZhc+sD6lm6IlQb7mePyfu2JX3rvFrpM1g+CkSnL6AMLUESVjaB49UReEQtCeJMgZtxSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550786; c=relaxed/simple;
	bh=pRdqtCot2Cke/Hf83HQPerqg05/NdJlp6U+Chdcdoyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AVkbLHzXR2/QWAmk8ad1WBdHmNqKoNJPPR3WclDt/JWz3aKumRe9U23lde+CzSVDl6DaMiTmiurWUvRkBuqJcKE0fhR1ckGWYllO3eUdLIRuAYUQsaQ9+DTUKfbkt3YVbYBi4j7JzTfG3NRz/rG7+qIyzAZYSDu2ZVmDbKeMLdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fx6lOYcY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e25cd76fb92so1049631276.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 01:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728550784; x=1729155584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RaMAnTMU97KOopoBfYjbwx+ePz+tIxWqRe78kfl7LPI=;
        b=fx6lOYcYaM05BlrzMOxhszsKFn433GqXtNkrpQW3lA1LFR7zECwsgn1GEAfT0xGsWE
         GcGClg50cJq3buObsP71tEXFIXW72lqxghMZERc4MiPV8aWbUqNHqSKQfgpiM1bmeegw
         305npPtioKUkUygOTWqA6BT+PQx6YfoE0vrOtUDhaNti2nIpyrqEa+vHLI3qgjwjWc3B
         h41FuGFQCDktN/gigoyRvmpuy05Jsolrv6tkAvlBbx0o0YHhObcZMM1xHR8ijl4MeqgO
         xVCv+tkdOyxLaHvy4q/l3G1My2vItnoyi0oAnZONJLKwoWGLTUCLu8dM9JjOIit0lfg4
         HScw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728550784; x=1729155584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RaMAnTMU97KOopoBfYjbwx+ePz+tIxWqRe78kfl7LPI=;
        b=VYiG21KIUet/teNxxgYkp57r2WMXUef8O2uW8EZFHqAOZV32URZCL3DdG3UCGd2LDs
         gfUvd6zk8KXduXsWAMk/DZLEiU0w2tgwRNO0LsDYEk45X4fdEU+opt93nI4AOVdwUdCR
         PaRP8s9O4It9xA0tPNV9pj6/a9u5h1A+8XnVfgHKXwU+4q9B9i0DiDP/qdbIDDvx64DP
         39G61FwvcSw+j1esHSjvrkdLILLsMnaQibfEosj7VmWvgYJLLPgrIs3L+8ksNwPOZvsD
         AXmRRbqUdXPCVxpHuVYqEKmIJGQX5r3aAJwsTM570XRenU76XcaAX2ULsGb10+Qj0JU/
         4kcA==
X-Gm-Message-State: AOJu0YxL7iSFDEerduf1Xt/jjfGgol2d2RKaEel/w0QhvvJVHBBGBppe
	nHEFrPHy0RhX+DT1sH4s5HfLQoetoCjXRix8SbTv8phF8JxAr/GBEGkGxAZIDLxAXeYGpR+mPvv
	MOnYgL9xHHKJt/xu38t58GZz9agGeS84VLZSfKQ1FjqS7qmfQoQkYRaZmefyxKK2fRw2vYm+6U5
	eUatkttyT3gN9pVgKgZPb6KJ0=
X-Google-Smtp-Source: AGHT+IFXrnj8DsQckmU8dck3/aR7Cyrtk6dA8VC+TkvI6bTNlQ8hcSmPDes1mOxFCnXb7jNq/oQlri1uFw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5b:308:0:b0:e25:d46a:a6b6 with SMTP id
 3f1490d57ef6-e28fe41d292mr38495276.8.1728550783417; Thu, 10 Oct 2024 01:59:43
 -0700 (PDT)
Date: Thu, 10 Oct 2024 09:59:23 +0100
In-Reply-To: <20241010085930.1546800-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241010085930.1546800-5-tabba@google.com>
Subject: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap guest_memfd()
 pages when shared
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

Note that the functions kvm_gmem_is_mapped(),
kvm_gmem_set_mappable(), and int kvm_gmem_clear_mappable() are
not used in this patch series. They are intended to be used in
future patches [*], which check and toggle mapability when the
guest shares/unshares pages with the host.

[*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.12-v3-pkvm

---
 include/linux/kvm_host.h |  52 +++++++++++
 virt/kvm/Kconfig         |   4 +
 virt/kvm/guest_memfd.c   | 185 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 138 +++++++++++++++++++++++++++++
 4 files changed, 379 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index acf85995b582..bda7fda9945e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2527,4 +2527,56 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
+bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start,
+			       gfn_t end);
+int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
+				 gfn_t end);
+bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
+#else
+static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start,
+					  gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot,
+					     gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot,
+					       gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot,
+					     gfn_t gfn)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+#endif /* CONFIG_KVM_GMEM_MAPPABLE */
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index fd6a3010afa8..2cfcb0848e37 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -120,3 +120,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config KVM_GMEM_MAPPABLE
+       select KVM_PRIVATE_MEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f414646c475b..df3a6f05a16e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -370,7 +370,184 @@ static void kvm_gmem_init_mount(void)
 	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
 }
 
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+static struct folio *
+__kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
+		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
+		   int *max_order);
+
+static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
+	void *xval = xa_mk_value(true);
+	pgoff_t i;
+	bool r;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	for (i = start; i < end; i++) {
+		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
+		if (r)
+			break;
+	}
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
+	pgoff_t i;
+	int r = 0;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	for (i = start; i < end; i++) {
+		struct folio *folio;
+
+		/*
+		 * Holds the folio lock until after checking its refcount,
+		 * to avoid races with paths that fault in the folio.
+		 */
+		folio = kvm_gmem_get_folio(inode, i);
+		if (WARN_ON_ONCE(IS_ERR(folio)))
+			continue;
+
+		/*
+		 * Check that the host doesn't have any mappings on clearing
+		 * the mappable flag, because clearing the flag implies that the
+		 * memory will be unshared from the host. Therefore, to maintain
+		 * the invariant that the host cannot access private memory, we
+		 * need to check that it doesn't have any mappings to that
+		 * memory before making it private.
+		 *
+		 * Two references are expected because of kvm_gmem_get_folio().
+		 */
+		if (folio_ref_count(folio) > 2)
+			r = -EPERM;
+		else
+			xa_erase(mappable_offsets, i);
+
+		folio_put(folio);
+		folio_unlock(folio);
+
+		if (r)
+			break;
+	}
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
+{
+	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
+	bool r;
+
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	r = xa_find(mappable_offsets, &pgoff, pgoff, XA_PRESENT);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
+
+	return r;
+}
+
+int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	struct inode *inode = file_inode(slot->gmem.file);
+	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
+	pgoff_t end_off = start_off + end - start;
+
+	return gmem_set_mappable(inode, start_off, end_off);
+}
+
+int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	struct inode *inode = file_inode(slot->gmem.file);
+	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
+	pgoff_t end_off = start_off + end - start;
+
+	return gmem_clear_mappable(inode, start_off, end_off);
+}
+
+bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct inode *inode = file_inode(slot->gmem.file);
+	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
+
+	return gmem_is_mappable(inode, pgoff);
+}
+
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct folio *folio;
+	vm_fault_t ret = VM_FAULT_LOCKED;
+
+	/*
+	 * Holds the folio lock until after checking whether it can be faulted
+	 * in, to avoid races with paths that change a folio's mappability.
+	 */
+	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
+	if (!folio)
+		return VM_FAULT_SIGBUS;
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out;
+	}
+
+	if (!gmem_is_mappable(inode, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out;
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
+out:
+	if (ret != VM_FAULT_LOCKED) {
+		folio_put(folio);
+		folio_unlock(folio);
+	}
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
+#endif /* CONFIG_KVM_GMEM_MAPPABLE */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -557,6 +734,14 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..aed9cf2f1685 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3263,6 +3263,144 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end, i;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(gfn_start >= gfn_end))
+			continue;
+
+		for (i = gfn_start; i < gfn_end; i++) {
+			if (!kvm_slot_gmem_is_mappable(memslot, i))
+				return false;
+		}
+	}
+
+	return true;
+}
+
+bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	bool r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __kvm_gmem_is_mappable(kvm, start, end);
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static bool kvm_gmem_is_pfn_mapped(struct kvm *kvm, struct kvm_memory_slot *memslot, gfn_t gfn_idx)
+{
+	struct page *page;
+	bool is_mapped;
+	kvm_pfn_t pfn;
+
+	/*
+	 * Holds the folio lock until after checking its refcount,
+	 * to avoid races with paths that fault in the folio.
+	 */
+	if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, memslot, gfn_idx, &pfn, NULL)))
+		return false;
+
+	page = pfn_to_page(pfn);
+
+	/* Two references are expected because of kvm_gmem_get_pfn_locked(). */
+	is_mapped = page_ref_count(page) > 2;
+
+	put_page(page);
+	unlock_page(page);
+
+	return is_mapped;
+}
+
+static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end, i;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(gfn_start >= gfn_end))
+			continue;
+
+		for (i = gfn_start; i < gfn_end; i++) {
+			if (kvm_gmem_is_pfn_mapped(kvm, memslot, i))
+				return true;
+		}
+	}
+
+	return false;
+}
+
+bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	bool r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __kvm_gmem_is_mapped(kvm, start, end);
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_t end,
+				    bool is_mappable)
+{
+	struct kvm_memslot_iter iter;
+	int r = 0;
+
+	mutex_lock(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		if (is_mappable)
+			r = kvm_slot_gmem_set_mappable(memslot, gfn_start, gfn_end);
+		else
+			r = kvm_slot_gmem_clear_mappable(memslot, gfn_start, gfn_end);
+
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return kvm_gmem_toggle_mappable(kvm, start, end, true);
+}
+
+int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return kvm_gmem_toggle_mappable(kvm, start, end, false);
+}
+
+#endif /* CONFIG_KVM_GMEM_MAPPABLE */
+
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
-- 
2.47.0.rc0.187.ge670bccf7e-goog


