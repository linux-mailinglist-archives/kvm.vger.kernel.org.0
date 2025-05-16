Return-Path: <kvm+bounces-46859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 375D7ABA392
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1910F1C02CEB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E62280320;
	Fri, 16 May 2025 19:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d2u6BSPa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F1280018
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747423196; cv=none; b=TuuNjnfSIgCV797kqwIYOIYvBFhglZTeGlZThd7f2f3Ob+Sp7vcmMzWvvhCC7OTsdGMdm0+iAOPu5C3hZRpoNnRaJx0Goe9bS2PDZgzY6ZWdj0hLHH/t1FvvTTHvCjZv+2IIG8ySkgHqFvmMoNe3X7BzKtvwJBXG2iVV+6lprvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747423196; c=relaxed/simple;
	bh=MZaYn+nvo0B04wdZlv09EaHso5El8svtVs317b2BC04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gjtulPvM4l4N35Ss76IaPTKxLUBdzzWDdHlIjvTNRaPTlCKJYXP6/2blP3fKdh6R8nQN218CODhW0LROhVs1K/thyfbflWif/CJBd4Cts8fMKacVL0m15K2Abn+r8z7G40jBwxN6UiaKZwmDwXYnkCmB2xxNSU6i0RJLx1EIJQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d2u6BSPa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115383fcecso1447092a12.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747423194; x=1748027994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oMFJ363USnG+FNszh8DLSKhNL8qceUKY5adrEM17BYQ=;
        b=d2u6BSPafAD90iS+6Dr4reF1EuHgIY5rDW/ZDrjtzul/r93E1AUqsu095yU8U1Rt3R
         XWFe8QRBaAl9aAUe8ZHS3f2y9sMh7lYcGe4D6+zaGLr6mD9eCVfGmE6a+ITS807AmnN5
         0t1oxfPSC5nJ2DtmsfGAp6DdSOu4/0oZE/1waYPPSMZBohaoOva0aDJ41/1zITurrHH8
         M1BOOEwPC/7uCMHxOBwuuuUD6Q7GeLAEwWkY+i5aClIX26CQYgIMNKlxNjuB7wo2G9IG
         ob+s11HW3bx/KPuCQ6drCDAKkWvYKYGKCfCvyE8o4ioXuLqN/Mr4f9zvHCz0pi7HNW9W
         udbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747423194; x=1748027994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMFJ363USnG+FNszh8DLSKhNL8qceUKY5adrEM17BYQ=;
        b=j/B3QNvNzEfAfJHWKRAPOlpzO0nHDdmk/j0ieBDH0DAWRuRhPyfv6ESKkB7GTiD87v
         ziTrpvEIflNHgcqzh8ag+D3rhBtGe+djFCeY8DU8q8EjqhY4hHx55+UQbi1dvBnrj4gZ
         yFixcfO3Du1TZyU32cRxO/ev3dvMqjDcyEtbyJJ4qlAxA1CDTsNPSnMEGvfv6Cg2vaJH
         /PndquY9NrWEAkY/f78Y3D6aMP0rpbQY861dq9WRm6cBxG5FCs515EO4fJUGKfGzcRiV
         HxLxuAkWrcvFihrB2GZWb9ASy1gWcJEaFOBqoMxrd+ggyk+Sx3sOX1FWj+6+/CjjFpSt
         RDpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoidB6VGjkntrAOSA+LO2g6KSqX35Z2WQhMd0ozjjvXRKyE2BU9cszS/0EOtrPtqbX5mA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqvYueqeDA8EgfGcGS26KPamo10pQuhpQc7D5jyUObTmVwmIFN
	Q0TWicZDck+2wV/5v9iAdfvuHRKpX/XtaATCmtLnJK6FPzQ73ArA1yxYIcgqoU/D5S7kNYbJthK
	j7g7BXaM3Sw==
X-Google-Smtp-Source: AGHT+IGI9ILyUKepnXkdGGm63vJAAGDjSs8x0J8EEnoDiBvLz3VF49AsRx4LzlHZ8XR+aVVknzB+VH1DaL5H
X-Received: from pjbsv11.prod.google.com ([2002:a17:90b:538b:b0:2f9:dc36:b11])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56cc:b0:2fe:a8b1:7d8
 with SMTP id 98e67ed59e1d1-30e7d5acb07mr6669924a91.25.1747423194396; Fri, 16
 May 2025 12:19:54 -0700 (PDT)
Date: Fri, 16 May 2025 19:19:24 +0000
In-Reply-To: <cover.1747368092.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747368092.git.afranji@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <a6f82952d92c74b91f25390ed4d4ba760bf51263.1747368092.git.afranji@google.com>
Subject: [RFC PATCH v2 04/13] KVM: guest_mem: Add ioctl KVM_LINK_GUEST_MEMFD
From: Ryan Afranji <afranji@google.com>
To: afranji@google.com, ackerleytng@google.com, pbonzini@redhat.com, 
	seanjc@google.com, tglx@linutronix.de, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	tabba@google.com
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	shuah@kernel.org, andrew.jones@linux.dev, ricarkol@google.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, yu.c.zhang@linux.intel.com, 
	vannapurve@google.com, erdemaktas@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, sagis@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

KVM_LINK_GUEST_MEMFD will link a gmem fd's underlying inode to a new
file (and fd).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Ryan Afranji <afranji@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 include/uapi/linux/kvm.h |  8 ++++++
 virt/kvm/guest_memfd.c   | 57 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 10 +++++++
 virt/kvm/kvm_mm.h        |  7 +++++
 4 files changed, 82 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c6988e2c68d5..8f17f0b462aa 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1583,4 +1583,12 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+#define KVM_LINK_GUEST_MEMFD	_IOWR(KVMIO,  0xd6, struct kvm_link_guest_memfd)
+
+struct kvm_link_guest_memfd {
+	__u64 fd;
+	__u64 flags;
+	__u64 reserved[6];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a3918d1695b9..d76bd1119198 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -555,6 +555,63 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
+int kvm_gmem_link(struct kvm *kvm, struct kvm_link_guest_memfd *args)
+{
+	static const char *name = "[kvm-gmem]";
+	u64 flags = args->flags;
+	u64 valid_flags = 0;
+	struct file *dst_file, *src_file;
+	struct kvm_gmem *gmem;
+	struct timespec64 ts;
+	struct inode *inode;
+	struct fd f;
+	int ret, fd;
+
+	if (flags & ~valid_flags)
+		return -EINVAL;
+
+	f = fdget(args->fd);
+	src_file = fd_file(f);
+	if (!src_file)
+		return -EINVAL;
+
+	ret = -EINVAL;
+	if (src_file->f_op != &kvm_gmem_fops)
+		goto out;
+
+	/* Cannot link a gmem file with the same vm again */
+	gmem = src_file->private_data;
+	if (gmem->kvm == kvm)
+		goto out;
+
+	ret = fd = get_unused_fd_flags(0);
+	if (ret < 0)
+		goto out;
+
+	inode = file_inode(src_file);
+	dst_file = kvm_gmem_alloc_view(kvm, inode, name);
+	if (IS_ERR(dst_file)) {
+		ret = PTR_ERR(dst_file);
+		goto out_fd;
+	}
+
+	ts = inode_set_ctime_current(inode);
+	inode_set_atime_to_ts(inode, ts);
+
+	inc_nlink(inode);
+	ihold(inode);
+
+	fd_install(fd, dst_file);
+	fdput(f);
+	return fd;
+
+out_fd:
+	put_unused_fd(fd);
+out:
+	fdput(f);
+	return ret;
+}
+
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1e3fd81868bc..a9b01841a243 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5285,6 +5285,16 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_gmem_create(kvm, &guest_memfd);
 		break;
 	}
+	case KVM_LINK_GUEST_MEMFD: {
+		struct kvm_link_guest_memfd params;
+
+		r = -EFAULT;
+		if (copy_from_user(&params, argp, sizeof(params)))
+			goto out;
+
+		r = kvm_gmem_link(kvm, &params);
+		break;
+	}
 #endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index dcacb76b8f00..85baf8a7e0de 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -71,6 +71,7 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 int kvm_gmem_init(struct module *module);
 void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
+int kvm_gmem_link(struct kvm *kvm, struct kvm_link_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
@@ -82,6 +83,12 @@ static inline int kvm_gmem_init(struct module *module)
 
 static inline void kvm_gmem_exit(void) {};
 
+static inline int kvm_gmem_link(struct kvm *kvm,
+				struct kvm_link_guest_memfd *args)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)
-- 
2.49.0.1101.gccaa498523-goog


