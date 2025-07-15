Return-Path: <kvm+bounces-52476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 136B3B05683
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B567D3A470C
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1382D63F7;
	Tue, 15 Jul 2025 09:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zi++dST5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF9C2D9496
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 09:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572052; cv=none; b=njjgXKjB9xoKVcsq7aiJ7t/KggRxIz/Zn5b5/qBWj/SoM/hrkhUucQFOsbsbu6XewKAb0Myn97GvRLLu47pxAeNJB2xvrxJLbg52QGZP3GnbDdT6ySlRY5l+zBGw7epiaqVzD04FXNHcEAAByPKQf6YsTILomF9GheNwvc1mwyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572052; c=relaxed/simple;
	bh=f3u/Ge8FW+SN0Aue0ZwJsi77J3s3HWIHGe8Tcer+Qcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pBOg8aQ/jhJxfVbUuYonYTuuHo3mJ1lOIBIz1MMUHe1gSpKJOdgx0YHGrd9p7hSrYJVJRaMXiB30NyYOkIRcgkIp3ysDQyQRqTAEl5XWMYU0XRlQRG++gdF1PToMBdvCOXEpvWuxkziIjqyDpJCzZkRotLCBOswJZJuwpSHa8fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zi++dST5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso33660885e9.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 02:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572049; x=1753176849; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WSSwKIi+z+0CV3EnxLo9K1Ta6KVi8c942Os2pIujWoc=;
        b=Zi++dST5TDeuuVN8AM4j4NH+wnBAwz/aF99ijf2fFIJoSTMGXpX/CdPicRfP9h8lq2
         E++n3YtScRruSH7PjQgmqRy2RojTyHdt/X3hC/UsGeKK/frO18kPiLwGjmd827EpZjPt
         K0FAoqzgl8zv7HYqFqLR2sP0lqDMfU4J0PPeDG0FCGfnmaiJb0oOYz4S7ESULa0CzW8g
         9Ktin3/Hc/946BjCgQmV/pcJUsT5NEM2UrFIZeCHLtHrq/N0DxQxE7yqx+j7kTYtOcwk
         Nm6SANDWrpkqsebNeHg+X2c9NDNkILU93IgD4VOavKudJcozlvttNU78UY+aZ0pttxIF
         hesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572049; x=1753176849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSSwKIi+z+0CV3EnxLo9K1Ta6KVi8c942Os2pIujWoc=;
        b=jNq7TEuiiKx700EDM3rIKUnM6P2k5xHE/OlaqS1UasZTwAscdNUEbwk27T8CmWylkR
         aRnQNTSqe7Pa3K7BkT6lXSMqGVAgHjX0YLPIwuK1ZRQB2UvMypV0i1VwHpg3hSrLAyIE
         mJUDlsRtrEDMRN/gzvQas+dJaq3e9QeMXk2TGcfYSp+T8aVvaDd7uwDySzo3f7k3NUqW
         6LXvxQVzhUgmIIGMjdaSCF3CwQlEK8V9U8InDWRleuA5B+/99HVSGT2oIhatxIwxq03Z
         GDIDLvO+thyScb3ahdtCb0HykRKIZpCW3IupPQHJ/Wx9j3f1mywq5daIIN+wE6IR8tEy
         WLMw==
X-Gm-Message-State: AOJu0Ywojjm01o/6AmAAS5IEvXB6UbhpmDsxRDSJfO1s6QnNWqO1dVzn
	8rSq0ik20zmUKwoZF/q2aUgyPfTV5oAAyW0h+yYM5+28XkP7EVA7MOIDdKeIRn+jTJzH4KaqoNM
	NUlx0jn7926CML/p7BPt3WmaKYXu6wJqzKkmqJqFXfHzJWnIFNO5mSvReCNEz82PDWbIB2F3yCL
	tqQ7lkbUeViLP8KettpalmOgdQZuI=
X-Google-Smtp-Source: AGHT+IHgamLFcufzCJQVsHbvBUVlJeiytNHFVEbf8P/4J7LbjSqlHqRHXf8I6zFTOn/KcAg4RaZF5Qer8Q==
X-Received: from wmbea10.prod.google.com ([2002:a05:600c:674a:b0:455:fdc1:e6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e04:b0:456:c48:491f
 with SMTP id 5b1f17b1804b1-4560c484fbbmr122769635e9.10.1752572048741; Tue, 15
 Jul 2025 02:34:08 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:37 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-9-tabba@google.com>
Subject: [PATCH v14 08/21] KVM: guest_memfd: Allow host to map guest_memfd pages
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

Therefore, enable the basic mmap and fault handling logic within
guest_memfd. However, this functionality is not yet exposed to userspace
and remains inactive until two conditions are met in subsequent patches:

* Kconfig Gate (CONFIG_KVM_GMEM_SUPPORTS_MMAP): A new Kconfig option,
  KVM_GMEM_SUPPORTS_MMAP, is introduced later in this series. This
  option gates the compilation and availability of this mmap
  functionality at a system level. While the code changes in this patch
  might seem small, the Kconfig option is introduced to explicitly
  signal the intent to enable this new capability and to provide a clear
  compile-time switch for it. It also helps ensure that the necessary
  architecture-specific glue (like kvm_arch_supports_gmem_mmap) is
  properly defined.

* Per-instance opt-in (GUEST_MEMFD_FLAG_MMAP): On a per-instance basis,
  this functionality is enabled by the guest_memfd flag
  GUEST_MEMFD_FLAG_MMAP, which will be set in the KVM_CREATE_GUEST_MEMFD
  ioctl. This flag is crucial because when host userspace maps
  guest_memfd pages, KVM must *not* manage the these memory regions in
  the same way it does for traditional KVM memory slots. The presence of
  GUEST_MEMFD_FLAG_MMAP on a guest_memfd instance allows mmap() and
  faulting of guest_memfd memory to host userspace. Additionally, it
  informs KVM to always consume guest faults to this memory from
  guest_memfd, regardless of whether it is a shared or a private fault.
  This opt-in mechanism ensures compatibility and prevents conflicts
  with existing KVM memory management. This is a per-guest_memfd flag
  rather than a per-memslot or per-VM capability because the ability to
  mmap directly applies to the specific guest_memfd object, regardless
  of how it might be used within various memory slots or VMs.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
[3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 13 +++++++
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig         |  4 +++
 virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ec71648824c..9ac21985f3b5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -740,6 +740,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Returns true if this VM supports mmap() in guest_memfd.
+ *
+ * Arch code must define kvm_arch_supports_gmem_mmap if support for guest_memfd
+ * is enabled.
+ */
+#if !defined(kvm_arch_supports_gmem_mmap)
+static inline bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7a4c35ff03fe..3beafbf306af 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1596,6 +1596,7 @@ struct kvm_memory_attributes {
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+#define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 559c93ad90be..fa4acbedb953 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_GMEM
+
+config KVM_GMEM_SUPPORTS_MMAP
+       select KVM_GMEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6db515833f61..07a4b165471d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+static bool kvm_gmem_supports_mmap(struct inode *inode)
+{
+	const u64 flags = (u64)inode->i_private;
+
+	if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
+		return false;
+
+	return flags & GUEST_MEMFD_FLAG_MMAP;
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
@@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	u64 flags = args->flags;
 	u64 valid_flags = 0;
 
+	if (kvm_arch_supports_gmem_mmap(kvm))
+		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
+
 	if (flags & ~valid_flags)
 		return -EINVAL;
 
-- 
2.50.0.727.gbf7dc18ff4-goog


