Return-Path: <kvm+bounces-9397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECF785FDB3
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1A8E1F273B5
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF549151CC5;
	Thu, 22 Feb 2024 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3jsVxVa6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3EC14F9FD
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618256; cv=none; b=SOHlF2EyDmRTTma0le/OTGwGHPBX3w4gWYzGhMYAFtoluII4kQ9X04es04YAhd2s/qc/Q+R7NwIIj03akDmqjzkhXgBY7PH4z9EyxIiTALnfwGkwCnWIK7PW6obRv0/xHEdlrJ1CPNOxWo7/+fa/xStcITmD3kfBws0/7kFQLVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618256; c=relaxed/simple;
	bh=EzVThhpsjIFmZ6APONr+3YQMg6Kc3S6m7HggcVHh5j0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=puRHtkDynX4e90U2mNgZvVPYuw2AxoT/XtIRwtnvWf9zHZXGS4IbawSo6zSIkvDdKjlQbzvmgYqoACCZvZr03qD4RUppHaeO4/L+xmCwH0PmtqJHeArkW5A79RXMLfjFoTs/VQApUHrXl0uNPcaAh1DlL7/hZIYbRiTpgLwQdwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3jsVxVa6; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dce775fa8adso3966079276.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618253; x=1709223053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p2sRNr14w+/34TVEz20+9bKFlKpUm8pWMLvdxv53Wkw=;
        b=3jsVxVa6/k1QsRE/B8qD5CYphIDJuXLxlDuM7GhEw9XUCwUonJy7GLg0o1Oe2ReZLR
         6pQ2wS45jkS7M4GuYoLDKM6ZPNTaRwAhIEaqYBxUlIc0vn3y06qviW0Vyer8RgjXWBka
         30VVufAU9dpp63W98Izq7NnFcu13OOdWBfNZ6ac8slsVzHpJ2KippQHVCQYjRsRJKcgj
         XIdExzqXPsl7r0/PM03suiDSRoKh878+4M6ndcVDdmaKwD2+BIRm0dtv5AIwDEcnX/YH
         7ZPCmJ2i6aBrcSx9ErbJiVwRBJ29d0/0tvc3FqEcxlyJArl+3HgiK8wbdVh2+sKH9UC/
         Im1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618253; x=1709223053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2sRNr14w+/34TVEz20+9bKFlKpUm8pWMLvdxv53Wkw=;
        b=g7NNHJm1Of106nmQtqMOqJ/dH+zsPOoFRNZIPuSOR+M2W4l4DP/bfXIYRUQzSyZkqd
         P7rZn6LmBxAvtHgRW5s6x5q96HG+Z2QXQpjVXabIwL8sajPfbYV20nfxykROHRJLlCE5
         xhfHeon9ermecYu0HI2qZQm3cSOZNVA5f4MmV3hYOgIOhRcbGzmzgkB/QgT6fy5+Kds0
         4VPk9GtSxZdqBMKg6lXr4fcIxWrtCz2TyfNXtGHLD7d6zIoKmvLSLrfQetzCLy1C8w1I
         5f8sUYjWpepu0JcoMO9SIFNT4R52rWQ2E3tnjbgmOc6bxfd7MAnylCrI3nW6Ia7Ufczi
         XueQ==
X-Gm-Message-State: AOJu0YwsG23PU2aRq9xMbXATjUs/5MzxjzNCS9zu5LvEutTBLSNNCpjR
	JUwjEgzX0f7pS4/4pHa87IGZe7bU0+UrOZAL2C16VsSO8yCL2dxAWBnsg6pYWN8dneEMHNXFCQZ
	/Yu6+UWyChy98B1SB/7kPPHPWXhc5sBpDVF0WGz26M5OtuO+hQE//OlOFwnPfIlvoDhofpoFEsM
	Pt3MvKUdRFVLvOpo0UynW66fM=
X-Google-Smtp-Source: AGHT+IFYCuijTJVxj0GlLBJa9Pm0/DDmJE1649EzPWKeem3CrEc4NAZWsIRZhFfSZlUHJsQteNJxT4RkUg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:abd0:0:b0:dc6:5396:c0d4 with SMTP id
 v74-20020a25abd0000000b00dc65396c0d4mr723248ybi.1.1708618252702; Thu, 22 Feb
 2024 08:10:52 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:22 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-2-tabba@google.com>
Subject: [RFC PATCH v1 01/26] KVM: Split KVM memory attributes into user and
 kernel attributes
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
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
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Currently userspace can set all KVM memory attributes. Future
patches will add new attributes that should only be set by the
kernel.  Split the attribute space into two parts, one that
userspace can set, and one that can only be set by the kernel.

This patch introduces two new functions,
kvm_vm_set_mem_attributes_kernel() and
kvm_vm_set_mem_attributes_user(), whereby each sets the
attributes associated with the kernel or with userspace, without
clobbering the other's attributes.

Since these attributes are stored in an xarray, do the split at
bit 16, so that this would still work on 32-bit architectures if
needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  3 +++
 include/uapi/linux/kvm.h |  3 +++
 virt/kvm/kvm_main.c      | 36 +++++++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7df0779ceaba..4cacf2a9a5d5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1438,6 +1438,9 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf);
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext);
 
+int kvm_vm_set_mem_attributes_kernel(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long attributes);
+
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
 					gfn_t gfn_offset,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 59e7f5fd74e1..0862d6cc3e66 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2225,6 +2225,9 @@ struct kvm_memory_attributes {
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
+#define KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT     (16)
+#define KVM_MEMORY_ATTRIBUTES_KERNEL_MASK      GENMASK(63, KVM_MEMORY_ATTRIBUTES_KERNEL_SHIFT)
+
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
 struct kvm_create_guest_memfd {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f0dec2fa0f1..fba4dc6e4107 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2536,8 +2536,8 @@ static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
 }
 
 /* Set @attributes for the gfn range [@start, @end). */
-static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
-				     unsigned long attributes)
+static int __kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
+				      unsigned long attributes, bool userspace)
 {
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
@@ -2559,8 +2559,6 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	void *entry;
 	int r = 0;
 
-	entry = attributes ? xa_mk_value(attributes) : NULL;
-
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
@@ -2580,6 +2578,17 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	kvm_handle_gfn_range(kvm, &pre_set_range);
 
 	for (i = start; i < end; i++) {
+		/* Maintain kernel/userspace attributes separately. */
+		unsigned long attr = xa_to_value(xa_load(&kvm->mem_attr_array, i));
+
+		if (userspace)
+			attr &= KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+		else
+			attr &= ~KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+		attributes |= attr;
+		entry = attributes ? xa_mk_value(attributes) : NULL;
+
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
 				    GFP_KERNEL_ACCOUNT));
 		KVM_BUG_ON(r, kvm);
@@ -2592,6 +2601,23 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	return r;
 }
+
+int kvm_vm_set_mem_attributes_kernel(struct kvm *kvm, gfn_t start, gfn_t end,
+				     unsigned long attributes)
+{
+	attributes &= KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+	return __kvm_vm_set_mem_attributes(kvm, start, end, attributes, false);
+}
+
+static int kvm_vm_set_mem_attributes_userspace(struct kvm *kvm, gfn_t start, gfn_t end,
+					       unsigned long attributes)
+{
+	attributes &= ~KVM_MEMORY_ATTRIBUTES_KERNEL_MASK;
+
+	return __kvm_vm_set_mem_attributes(kvm, start, end, attributes, true);
+}
+
 static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 					   struct kvm_memory_attributes *attrs)
 {
@@ -2617,7 +2643,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 	 */
 	BUILD_BUG_ON(sizeof(attrs->attributes) != sizeof(unsigned long));
 
-	return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
+	return kvm_vm_set_mem_attributes_userspace(kvm, start, end, attrs->attributes);
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
-- 
2.44.0.rc1.240.g4c46232300-goog


