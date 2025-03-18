Return-Path: <kvm+bounces-41400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B7BA6790E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 188161892F38
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA332116E4;
	Tue, 18 Mar 2025 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LY0l5zIS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE737211283
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314715; cv=none; b=GU4JO8WtlNnCnqqeJOo9VTVzMc/u8oUXoJ0HHesa7HmL5R0hW/xinfR3QbkSocMWdudoVyc6sUuHtxSFNP19THH1AWRaCDqfuaGEU+gqX/5ixDglEMF29fBqgoXea2V1d3fY7npDPjCUke4kmZZZ25uhHy/gb/tZq5Q/n1sR/j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314715; c=relaxed/simple;
	bh=AcygDQB0GAz4peXGybSUW+mlvSVjIu/PQZ6/lazCl/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S5kTM/wePro+EsphtXvRAo1xrTke/zHgs/TmmnWM5b/buNk5mO3WMpLqP4VTAXElzWszMO+XvRoaD6QIFaUobVLCzkX0E7uADwwJnb46kBYIALWDnY+eE+DWNfS+c3R3aiOdQbWSO5zShDTsL8AwILNkwkmtr5Wssq42gRYmzv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LY0l5zIS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d08915f61so19426205e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314711; x=1742919511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYOa1UU9h8jSjVAqsxgFkmmHWtUaYIzvfBIu4SI+BUA=;
        b=LY0l5zISqROAtRjirX4IateHARk13jzR697G98iNYTbrIa+ycM43zSBJ3PY+MQ7Q4q
         q68TaolRFovBl2o2g7ziWmLM5KkLIBBUqa4tezSiHBfxBbfgfruhYSDuEcRpqqd5LGo3
         comtMASQgA0Ly2iZsEADK9PdIzHA+Nr0uJKeW8QM70NpGRF7AFK8cvvq/OMldtnOTOsZ
         Y3wvQzpoXYg25ReosWPKsw58PhHErUdwR/r/xv7qkO0QQbJroBTBDL8QjwcmzdK1nt7H
         CzbXZ3wj4b6rWEYLoCpcY+Yjf7C4gk/Vmf6p+3tu52wjlPCS2BZcV86K88P4o9D2oMRY
         7ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314711; x=1742919511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYOa1UU9h8jSjVAqsxgFkmmHWtUaYIzvfBIu4SI+BUA=;
        b=OOM0vAtvfjLpVm+dYsAybay2MHmNMURVTH+e+p9FczjOGIPKs/XCSQkCjIBczU+POq
         ld727E95tu/BAydavwiz8Bx+xsKfSiGijqdxYJc7hI5+4SdpX3WFzzMb0Wp22DNuyy2E
         B+cTVSLl7Upa69qvp1FNln4ud2mcPT9ILsDmPsvZIKFGMVsHxHmyHuw4aDIWlln5OzRy
         kXTuGghPj0wJYyrghcCe5SQ3rGZTZXrSaNTj6NuVWmKZlAjlod+i5fgTm1xJPXpT11Uu
         qCu3hsk2DNfb9hmEY+RHs9KkSRviR7fzRNYGHJ9lv0DhjLDvggtoZ34Gw4pNECWsiXrZ
         BkTA==
X-Gm-Message-State: AOJu0YzdYoI/CbEHhp/d1ZmoT2IFRliunl4sn/ErtO0kks2lWSQ+MkwV
	QDb35F5/tl0UIQksu7skcybhyGDTcHn4OI7k2w9Pc/spEPqsED2OuflhIvBEN1TD0Cs7HJQpPRD
	eIJP3GWZuwWarJoOA6NH1zdLqYoDoSu/zgUAzkeGhNpIF9ukkVPLZCTasuZQoW1gSaqllbu9ckE
	Cfrrc6PonGkizyCOdH6ofjiDY=
X-Google-Smtp-Source: AGHT+IFh22cazuiaWoz765xAULeQoPlqrTQHDrVGOZCNL+4GObvqtUFGjre6fKpJHGgToLQW9OVbs++0/Q==
X-Received: from wmbz3.prod.google.com ([2002:a05:600c:c083:b0:43d:2038:224c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:21d1:b0:43d:8ea:8d7a
 with SMTP id 5b1f17b1804b1-43d3e14ff6fmr19346915e9.28.1742314711005; Tue, 18
 Mar 2025 09:18:31 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:18:17 +0000
In-Reply-To: <20250318161823.4005529-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318161823.4005529-4-tabba@google.com>
Subject: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
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
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd backed memory
in the host for VMs that support in-place conversion between
shared and private. To that end, this patch adds the ability to
check whether the VM type supports in-place conversion, and only
allows mapping its memory if that's the case.

Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
indicates that the VM supports shared memory in guest_memfd, or
that the host can create VMs that support shared memory.
Supporting shared memory implies that memory can be mapped when
shared with the host.

This is controlled by the KVM_GMEM_SHARED_MEM configuration
option.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  11 +++++
 include/uapi/linux/kvm.h |   1 +
 virt/kvm/guest_memfd.c   | 101 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |   4 ++
 4 files changed, 117 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3ad0719bfc4f..601bbcaa5e41 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
+ * private memory is enabled and it supports in-place shared/private conversion.
+ */
+#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 45e6d8fca9b9..117937a895da 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -929,6 +929,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_GMEM_SHARED_MEM 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5fc414becae5..fbf89e643add 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -320,7 +320,108 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 	return gfn - slot->base_gfn + slot->gmem.pgoff;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
+{
+	struct kvm_gmem *gmem = file->private_data;
+
+
+	/* For now, VMs that support shared memory share all their memory. */
+	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
+}
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
+		int err = PTR_ERR(folio);
+
+		if (err == -EAGAIN)
+			ret = VM_FAULT_RETRY;
+		else
+			ret = vmf_error(err);
+
+		goto out_filemap;
+	}
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out_folio;
+	}
+
+	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/*
+	 * Shared folios would not be marked as "guestmem" so far, and we only
+	 * expect shared folios at this point.
+	 */
+	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/* No support for huge pages. */
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
+	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
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
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ba0327e2d0d3..38f0f402ea46 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4830,6 +4830,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+	case KVM_CAP_GMEM_SHARED_MEM:
+		return !kvm || kvm_arch_gmem_supports_shared_mem(kvm);
 #endif
 	default:
 		break;
-- 
2.49.0.rc1.451.g8f38331e32-goog


