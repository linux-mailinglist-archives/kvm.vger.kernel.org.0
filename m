Return-Path: <kvm+bounces-36873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD51A222C7
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06A41188290A
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258B71E102D;
	Wed, 29 Jan 2025 17:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xl+Lohgl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F991E0DF6
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171414; cv=none; b=Dsk0B001xRlKQczcIwyiLZD5vZivTCpTG0FU8b9d7gMnxul2GWSx/FvJlVavXYj8iFxbH0wbTMLAS1/DJ8dEwtmAeT0vl6ku3o4/45h0b/Za/CzvQ47ZLaD+fKqDDss3BXU/LQFPBQM/O1gMyUsjK1KTVZfA0F5j0SgjGrEKpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171414; c=relaxed/simple;
	bh=8zavs3oL0kc706cWUTJcLuGkX0ynxfhDbzhSPwymOvc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dNZ5AvhJQFYomYi88EgxPrRRCe80RGe4KE8Xyg8fKyYTIoi81JVKgpty+hKgWFv0ZZahc4gTEkwG3lMIUj/cdYmdZKd1GAfgXYJzXP2lCmNIFNVtyY0lIkoyrXcnWZO+y1RZP0gFoqbXBrk6i7hK09MSlzjjL8cZHlISMq332YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xl+Lohgl; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43626224274so40612005e9.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171411; x=1738776211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1nv4yVODl7ioMW6jJkbW1mbC87Wz7QQ6PPy9XEa8BJQ=;
        b=Xl+LohglAcy4ih0Rz9bdPSd70hrRZcLThnp9VxxBNIqRjgrSv1DY9QndVzGanLNb2S
         TWrAzddQyrHC6z7CJVIGJVRYjS5IRpv/MTWWR8M2DksD+rJchfuCIQ/ICKYaSb+H6+aU
         YZWCCw2UNyTXwKYcZHkrLk3Acrz7iQlNklHs4qf5Mr/XtBa2ZgStWUf7p5Gq3n0XPVbl
         vpOr96n8gHZGQNrRdk82nURdY6z1c+L8PLk8aQ6QAJlISrGsVkmyYODoWXpot98+NJmj
         GgG38ed/25NCyfsQKBkU6t97sOCtpo68lGJGvSasT83lIj8vNfT1gTLToF7rJUzT+HtJ
         9rIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171411; x=1738776211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nv4yVODl7ioMW6jJkbW1mbC87Wz7QQ6PPy9XEa8BJQ=;
        b=YzHrQEQ7fQfnf7FXi56MwSnimDGH3a5vdpqEumPFMG408AyyhPB9it9EQiHnV48qpo
         20raiDSfCxLrn9sqQtDWAE3ADo4X1tr2cXk4Or7kzZQ+FLLNamkNDYUpPQFTVK1gjg4p
         krU6tx0wWtmFaqIN4ney8wxS7i9zqaTfRm8j8G5AfsEkc119ph7jmuFir5mYVJSwqcJX
         xXJ8YyxVsqPFPhsWpNrI5ESX2iIznkRJTeCPcpREhtRUJUtMAr5crfxCqPWYbr6NJ+hd
         Z7UaOG9/kVQ2IAkgJ8ajLqZrsE8qnmfq22CIX+MZXkT8X7jMbvAWhH90pkX5t09q2Jej
         W+OA==
X-Gm-Message-State: AOJu0YwzaRNW83AO08naKaTCsE/ZPz1XFRtQLBpJi1PRS0utgMR7+MXL
	RYwhSQQpezFM8UO8lWP2PLjk+2V3gjQpxBJ4W/lDIQeMC/ZX0Ck7HNE0sY0nA0ES6RUc0VNRGr6
	kFWfqya2sxlDVVcbIbgMz8DgetKC9XNDhSGxXn0Tzf6u0uS5WPS5J8s8t2sWW5Q6Dhk3GCAppB4
	ektoA81zZ/LU1lTtC3g4RRxTQ=
X-Google-Smtp-Source: AGHT+IFIuIn6HWlnbbn3OX1lNHWQpyl+hx+IsFXmYLoKnyKlPSNVYQFkHXDzngFkRTaSpQvhKnRXZbiDkQ==
X-Received: from wmbjm10.prod.google.com ([2002:a05:600c:6aca:b0:435:21e:7bec])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a04:b0:436:e3ea:4447
 with SMTP id 5b1f17b1804b1-438dc436a08mr37793435e9.30.1738171410842; Wed, 29
 Jan 2025 09:23:30 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:13 +0000
In-Reply-To: <20250129172320.950523-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250129172320.950523-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-5-tabba@google.com>
Subject: [RFC PATCH v2 04/11] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
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

Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
that the VM supports shared memory in guest_memfd, or that the
host can create VMs that support shared memory. Supporting shared
memory implies that memory can be mapped when shared with the
host.

For now, this checks only whether the VM type supports sharing
guest_memfd backed memory. In the future, it will be expanded to
check whether the specific memory address is shared with the
host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/guest_memfd.c   | 13 +++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 502ea63b5d2e..3ac805c5abf1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -933,6 +933,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_GMEM_SHARED_MEM 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 86441581c9ae..4e1144ed3446 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -308,6 +308,13 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
 }
 
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
+static bool kvm_gmem_is_shared(struct file *file, pgoff_t pgoff)
+{
+	struct kvm_gmem *gmem = file->private_data;
+
+	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
+}
+
 static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
@@ -327,6 +334,12 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 		goto out_folio;
 	}
 
+	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
+	if (!kvm_gmem_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+		ret = VM_FAULT_SIGBUS;
+		goto out_folio;
+	}
+
 	if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae231..40e4ed512923 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4792,6 +4792,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
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
2.48.1.262.g85cc9f2d1e-goog


