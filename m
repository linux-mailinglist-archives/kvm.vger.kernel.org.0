Return-Path: <kvm+bounces-38464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77635A3A439
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 18:26:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 265D318954ED
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72379270ED3;
	Tue, 18 Feb 2025 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hSHBp3GO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F23270EB2
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739899512; cv=none; b=tIfm+wnC+KfKJ9jMJCScxexug/zYYNyjn5NO99rNKcDs52YYn87g5ExvjfkMcB/p2Bjxfrkk7an5YCrERjioqqoX/NUOCEbaFclLIj4+iaU+a4f78DqBKxb8aCbZgW9HDrzAqfUz/pyL96hXgAyG+gVpd5P2E7icocOngVFzcgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739899512; c=relaxed/simple;
	bh=Rooflcwn4NQXPC31lj8XKxiQLIgB+Yi/Z7igLXusc1Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=co3pce2KqfcMIsN/HcIwVN3flXvpUUSKAg2g/fOcwME0sGqvDm1ZXwYDyV+lEHev1KN5VRXWaljrTV/SBepJOptZgYoKIdIlGpB7YEXoDwG1eK9SkzknmfXPhFo8Hsp/Cb0wUNz9FrzkFOK6sOVRmYNFhq6SYK7UxMXIuygpQHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hSHBp3GO; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43943bd1409so47848685e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739899509; x=1740504309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ja1dbSYeEbtOj/Lq4H8XOfvxJc8Pm73z8vQggxiiAfA=;
        b=hSHBp3GO/5o+oWZ3FOmjSysseV601biv1VILibsVqxiyWzlrDJVddHfCoDZL6ZO+Md
         MqEi0Cgs7wrPzwaQUo31a4L01ZuEHzy23NrFred8ViXD8Hsuuk/tCVZmNsR1t+mNYehv
         0z6BgzR5zAtVP4XsVGrItD6T1yoyobnnHVHWqTNiSQbOjqGtRt/o6GZD6Yu5mYTGsJef
         /aaOUbWWIB7IPG8DhiVC/efGnt9PT/HktO1tTDgVQ4AwSdHYoe9funjzP9lH9MgahgyC
         uZ9F3+6rxbYa/bMGf9/w0YUeEhQw03qnvd/OvvgljMELErXBN2dgrCTGFX8VQSwMcVYa
         GT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739899509; x=1740504309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ja1dbSYeEbtOj/Lq4H8XOfvxJc8Pm73z8vQggxiiAfA=;
        b=w/R7qgwBD8PxmGt6zqZ08Pnn5oqo8EVqHQBzVmUb0koZvr5/DYyh+hBQGTR0FSJo+w
         2LIIm2FISGX1szZtCWe6oY23o7Z6GwkdJkM4Cm9S+13lP+ylNBFa06P60/aEYZJ2Un4i
         60sxy+2dFBRVjSpX4W2siKvzgT9qMlS8q2QCQNi9vWG4wb3kEPWLreELj0e+YdLmVHb9
         LBTA+eKcvc6i2CBbkfYbV2l3j3ob/AQFw/sysydmuQhR87jB7udGv0qCwvatbQLLPP0V
         AIbjqpVupYMDW7IjQJ9HwpvE9h2Xb1AVtIW0W9DAlhGo84q+WEqCOl63Wh0nAnDBXz8r
         YL0A==
X-Gm-Message-State: AOJu0YxCAqKvztllY5kInD8AjtGaKQedIiQBd4k/N3gE6TrW0bSpic2Z
	NEcNLfj62tGV3n4vFV9vB1dvap2eCWcTK2WzAuDv3GhznClhJQ1DuQkAN7mRNwlYajwA8kIX42O
	3H8mENa8qD7GGEd96OndceDMmrP2Q7jg/rpmpL9rB0P3GwRG1qMWZfVEXHqvLCbNZpvl0NK/Lvi
	lVrbxwXj1O24s4TDEkgk9svn8=
X-Google-Smtp-Source: AGHT+IEk7whKV8qDP3YJYflDIlm8Cb6VQQ/o4v2sTpWwI0tdVBtFPk7h94MV+FENYUw5CL+bP9BAxRH9cQ==
X-Received: from wmqe5.prod.google.com ([2002:a05:600c:4e45:b0:439:8333:1efb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d1e:b0:439:6118:c188
 with SMTP id 5b1f17b1804b1-43999dd1dc6mr3930085e9.19.1739899508877; Tue, 18
 Feb 2025 09:25:08 -0800 (PST)
Date: Tue, 18 Feb 2025 17:24:53 +0000
In-Reply-To: <20250218172500.807733-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218172500.807733-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218172500.807733-4-tabba@google.com>
Subject: [PATCH v4 03/10] KVM: guest_memfd: Allow host to map guest_memfd() pages
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd backed memory
in the host for VMs that support in-place conversion between
shared and private. To that end, this patch adds the ability to
check whether the VM type supports in-place conversion, and only
allows mapping its memory if that's the case.

This behavior is also gated by the configuration option
KVM_GMEM_SHARED_MEM.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  11 +++++
 virt/kvm/guest_memfd.c   | 103 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3ad0719bfc4f..f9e8b10a4b09 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 }
 #endif
 
+/*
+ * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
+ * private memory is enabled and it supports in-place shared/private conversion.
+ */
+#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
+static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c6f6792bec2a..30b47ff0e6d2 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -317,9 +317,112 @@ void kvm_gmem_handle_folio_put(struct folio *folio)
 {
 	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
 }
+
+static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
+{
+	struct kvm_gmem *gmem = file->private_data;
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
+		switch (PTR_ERR(folio)) {
+		case -EAGAIN:
+			ret = VM_FAULT_RETRY;
+			break;
+		case -ENOMEM:
+			ret = VM_FAULT_OOM;
+			break;
+		default:
+			ret = VM_FAULT_SIGBUS;
+			break;
+		}
+		goto out_filemap;
+	}
+
+	if (folio_test_hwpoison(folio)) {
+		ret = VM_FAULT_HWPOISON;
+		goto out_folio;
+	}
+
+	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
+	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
+	/*
+	 * Only private folios are marked as "guestmem" so far, and we never
+	 * expect private folios at this point.
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
 #endif /* CONFIG_KVM_GMEM_SHARED_MEM */
 
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
-- 
2.48.1.601.g30ceb7b040-goog


