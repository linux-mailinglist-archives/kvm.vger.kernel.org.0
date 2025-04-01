Return-Path: <kvm+bounces-42342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99025A77FEB
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1731890C99
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08855219A9D;
	Tue,  1 Apr 2025 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DEM2U3/U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B751A2C3A
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523899; cv=none; b=bb/Y6L3z09ryh3OxNLXn7OGiCBZFSqxiXryN+EWCCQ/gnZqr2u9JRIDHjhYWKBKu7BNcQIS4AU5robSu17CshXEpNZOalAIS8pNrrGjv1GcMCw+z1U6NlC209ep/chaqeIT7zKAtAy7a/Er+pnVHBcrtGIkSBdNIbAZaeoBZfZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523899; c=relaxed/simple;
	bh=pIyJCdOg5EfnYtvOavzOlQjVJCjnaMJWsL07IXTnXPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2BJ8ij4aM18ntr0x04FqertmSsX4Tqir/z6bOMTShzMKqvyqXl0Yb1jCpG8HZ7UwjWxQJF5EWvuPXuGgQ1npTdUb0giN4vjVmF++ZFD2w9gO0oJWSJ4bAAPCoaQD75j6b3bxGHJj4hQ6V9tLV7kcWu0txW5FAjXuPbl7MrQs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DEM2U3/U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P25Au7R1dwmJRVWNgpsYsEFXlIeAhOMlbUwIILW5U9Q=;
	b=DEM2U3/U3eeO8QNjncAjrysgyTNYgHeOrpTGxDqd6pK0BRwng0Rq3n2qsUdUVMtcZKDi0L
	dhf1iTzfdS9S2x7TlX/+E2CaItBXve0E8ncpQa8uCO33THRiIoRgWFOMElxd+jppAFJe+p
	paMtNMaeSKTsd+0CALb4j4cnqjK4xTs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-3YZRgz6qNX6hy0r2hEo34A-1; Tue, 01 Apr 2025 12:11:34 -0400
X-MC-Unique: 3YZRgz6qNX6hy0r2hEo34A-1
X-Mimecast-MFC-AGG-ID: 3YZRgz6qNX6hy0r2hEo34A_1743523893
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c184b20a2so1046255f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523893; x=1744128693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P25Au7R1dwmJRVWNgpsYsEFXlIeAhOMlbUwIILW5U9Q=;
        b=w2xhpC/QCLk1eflAZexnGDUeqh3aY3xO8xSkmjmzlHFoZL6KcxfmRBrOOOcw23pQOw
         n2+aPPWBZxHOvy15WR6oV5ygSQxX87xxVq9ddQk95qjdc29PSuNimYxZWfGmo9R18kF/
         tLRGoIjlxn3eOe9u4OKrUdwSLIx+Xg0Vq5Wqp9YvjljVnd5JMJ/gr18rjM8B7kriRQqL
         XaeZ/qJWej+s77zFFqnQ7B6X5UOMwtrad5LQv/xRYsHw0ESlWWcLaYCRhF4sI0AJyGJ+
         NOaK0vABiMFnnHW4Ba1XKBADBj4IRR+apTtgOaGYVhyzEN6SfWbyy4XAvBkPsk1twUxv
         bQ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/YJG57t/0Sd58LNskPzxsyEs9zYDby07Rt3r9545aLQUn9o8OCDmHws64haYvCY6j8L8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWFlNEsE8nbwcLkWYYutLGgN641NvfrX9vqt5nRCEuFPiymJ+w
	77/H67aZmD7WJGbCCyr4gtpthLBXJ+4RYSxJd08F9CKJfpJl3gRVBrsWOyo3gCw8K2F0wUBoa8P
	T6PnYzi0MiAgTPMPD/dBVdPgD/i+hRmOSME55cC3ACTGs7blpAg==
X-Gm-Gg: ASbGncuJQMj1YrEeApYRZcX5iHpV1jD8JIRjGTRKHhEHt9XPwoTqlMDk01NXU7sSK3V
	Lmo+iZAOCK1R4bs1681uVTQh0vX+F7c/WMvTvLbchi3iJIaWpB4+6ol1/LpOTJpQvFddPaIw+MO
	dGD04KiSnVy/ChkfDFxBJP37ZhYnKQb9/psEyg2xX7pD59O8cawxHLRF8+h+ootRn75f1AUrrVq
	80AkQ3X3ZV+zYGnJLr7W3KhkOQqHTPIVR2iAX0J3nncwi+Ry8AiJRmWH/i7pMrcy+Rip5rrkE9r
	miNdkraCQ3dP8/4MWwaWlA==
X-Received: by 2002:a05:6000:2913:b0:391:4ca:490 with SMTP id ffacd0b85a97d-39c120e35d1mr10486559f8f.29.1743523892966;
        Tue, 01 Apr 2025 09:11:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRUznHPy00F+DVXJZ81FziQ7RotBaykrjs+9d/ucxw73LPo+iiCJX9scu8bMnyNgr21RT/Iw==
X-Received: by 2002:a05:6000:2913:b0:391:4ca:490 with SMTP id ffacd0b85a97d-39c120e35d1mr10486516f8f.29.1743523892530;
        Tue, 01 Apr 2025 09:11:32 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82efeacasm203836695e9.23.2025.04.01.09.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:30 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 09/29] KVM: implement plane file descriptors ioctl and creation
Date: Tue,  1 Apr 2025 18:10:46 +0200
Message-ID: <20250401161106.790710-10-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the file_operations for planes, the means to create new file
descriptors for them, and the KVM_CHECK_EXTENSION implementation for
the two new capabilities.

KVM_SIGNAL_MSI and KVM_SET_MEMORY_ATTRIBUTES are now available
through both vm and plane file descriptors, forward them to the
same function that is used by the file_operations for planes.
KVM_CHECK_EXTENSION instead remains separate, because it only
advertises a very small subset of capabilities when applied to
plane file descriptors.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h |  19 +++++
 include/uapi/linux/kvm.h |   2 +
 virt/kvm/kvm_main.c      | 154 +++++++++++++++++++++++++++++++++------
 3 files changed, 154 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0a91b556767e..dbca418d64f5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -342,6 +342,8 @@ struct kvm_vcpu {
 	unsigned long guest_debug;
 
 	struct mutex mutex;
+
+	/* Shared for all planes */
 	struct kvm_run *run;
 
 #ifndef __KVM_HAVE_ARCH_WQP
@@ -922,6 +924,23 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 }
 
 
+#if KVM_MAX_VCPU_PLANES == 1
+static inline int kvm_arch_nr_vcpu_planes(struct kvm *kvm)
+{
+	return KVM_MAX_VCPU_PLANES;
+}
+
+static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->planes[0];
+}
+#else
+static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->planes[vcpu->plane_id];
+}
+#endif
+
 #define KVM_BUG(cond, kvm, fmt...)				\
 ({								\
 	bool __ret = !!(cond);					\
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index b0cca93ebcb3..96d25c7fa18f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1690,4 +1690,6 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+#define KVM_CREATE_PLANE	_IO(KVMIO, 0xd6)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cd4dfc399cad..b08fea91dc74 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4388,6 +4388,80 @@ static int kvm_wait_for_vcpu_online(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_plane_ioctl_check_extension(struct kvm_plane *plane, long arg)
+{
+	switch (arg) {
+#ifdef CONFIG_HAVE_KVM_MSI
+	case KVM_CAP_SIGNAL_MSI:
+#endif
+	case KVM_CAP_CHECK_EXTENSION_VM:
+		return 1;
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	case KVM_CAP_MEMORY_ATTRIBUTES:
+		return kvm_supported_mem_attributes(plane);
+#endif
+	default:
+		return 0;
+	}
+}
+
+static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl,
+			      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+
+	switch (ioctl) {
+#ifdef CONFIG_HAVE_KVM_MSI
+	case KVM_SIGNAL_MSI: {
+		struct kvm_msi msi;
+
+		if (copy_from_user(&msi, argp, sizeof(msi)))
+			return -EFAULT;
+		return kvm_send_userspace_msi(plane, &msi);
+	}
+#endif
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	case KVM_SET_MEMORY_ATTRIBUTES: {
+		struct kvm_memory_attributes attrs;
+
+		if (copy_from_user(&attrs, argp, sizeof(attrs)))
+			return -EFAULT;
+		return kvm_vm_ioctl_set_mem_attributes(plane, &attrs);
+	}
+#endif
+	case KVM_CHECK_EXTENSION:
+		return kvm_plane_ioctl_check_extension(plane, arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static long kvm_plane_ioctl(struct file *filp, unsigned int ioctl,
+			     unsigned long arg)
+{
+	struct kvm_plane *plane = filp->private_data;
+
+	if (plane->kvm->mm != current->mm || plane->kvm->vm_dead)
+		return -EIO;
+
+	return __kvm_plane_ioctl(plane, ioctl, arg);
+}
+
+static int kvm_plane_release(struct inode *inode, struct file *filp)
+{
+	struct kvm_plane *plane = filp->private_data;
+
+	kvm_put_kvm(plane->kvm);
+	return 0;
+}
+
+static struct file_operations kvm_plane_fops = {
+	.unlocked_ioctl = kvm_plane_ioctl,
+	.release = kvm_plane_release,
+	KVM_COMPAT(kvm_plane_ioctl),
+};
+
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4878,6 +4952,14 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		if (kvm)
 			return kvm_arch_nr_memslot_as_ids(kvm);
 		return KVM_MAX_NR_ADDRESS_SPACES;
+#endif
+#if KVM_MAX_VCPU_PLANES > 1
+	case KVM_CAP_PLANES:
+		if (kvm)
+			return kvm_arch_nr_vcpu_planes(kvm);
+		return KVM_MAX_PLANES;
+	case KVM_CAP_PLANES_FPU:
+		return kvm_arch_planes_share_fpu(kvm);
 #endif
 	case KVM_CAP_NR_MEMSLOTS:
 		return KVM_USER_MEM_SLOTS;
@@ -5112,6 +5194,48 @@ static int kvm_vm_ioctl_get_stats_fd(struct kvm *kvm)
 	return fd;
 }
 
+static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
+{
+	struct kvm_plane *plane;
+	struct file *file;
+	int r, fd;
+
+	if (id >= KVM_MAX_VCPU_PLANES)
+		return -EINVAL;
+
+	guard(mutex)(&kvm->lock);
+	if (kvm->planes[id])
+		return -EEXIST;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	plane = kvm_create_vm_plane(kvm, id);
+	if (IS_ERR(plane)) {
+		r = PTR_ERR(plane);
+		goto put_fd;
+	}
+
+	kvm_get_kvm(kvm);
+	file = anon_inode_getfile("kvm-plane", &kvm_plane_fops, plane, O_RDWR);
+	if (IS_ERR(file)) {
+		r = PTR_ERR(file);
+		goto put_kvm;
+	}
+
+	kvm->planes[id] = plane;
+	fd_install(fd, file);
+	return fd;
+
+put_kvm:
+	kvm_put_kvm(kvm);
+	kfree(plane);
+put_fd:
+	put_unused_fd(fd);
+	return r;
+}
+
 #define SANITY_CHECK_MEM_REGION_FIELD(field)					\
 do {										\
 	BUILD_BUG_ON(offsetof(struct kvm_userspace_memory_region, field) !=		\
@@ -5130,6 +5254,9 @@ static long kvm_vm_ioctl(struct file *filp,
 	if (kvm->mm != current->mm || kvm->vm_dead)
 		return -EIO;
 	switch (ioctl) {
+	case KVM_CREATE_PLANE:
+		r = kvm_vm_ioctl_create_plane(kvm, arg);
+		break;
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
 		break;
@@ -5236,16 +5363,12 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #ifdef CONFIG_HAVE_KVM_MSI
-	case KVM_SIGNAL_MSI: {
-		struct kvm_msi msi;
-
-		r = -EFAULT;
-		if (copy_from_user(&msi, argp, sizeof(msi)))
-			goto out;
-		r = kvm_send_userspace_msi(kvm->planes[0], &msi);
-		break;
-	}
+	case KVM_SIGNAL_MSI:
 #endif
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+	case KVM_SET_MEMORY_ATTRIBUTES:
+#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+		return __kvm_plane_ioctl(kvm->planes[0], ioctl, arg);
 #ifdef __KVM_HAVE_IRQ_LINE
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
@@ -5301,18 +5424,6 @@ static long kvm_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
-#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	case KVM_SET_MEMORY_ATTRIBUTES: {
-		struct kvm_memory_attributes attrs;
-
-		r = -EFAULT;
-		if (copy_from_user(&attrs, argp, sizeof(attrs)))
-			goto out;
-
-		r = kvm_vm_ioctl_set_mem_attributes(kvm->planes[0], &attrs);
-		break;
-	}
-#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 	case KVM_CREATE_DEVICE: {
 		struct kvm_create_device cd;
 
@@ -6467,6 +6578,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
+	kvm_plane_fops.owner = module;
 	kvm_device_fops.owner = module;
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
-- 
2.49.0


