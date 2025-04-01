Return-Path: <kvm+bounces-42347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBEBA77FF7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B964F1890B74
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD4921D3ED;
	Tue,  1 Apr 2025 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbDXab7h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DFD21CC7B
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523911; cv=none; b=LJfkBxTu2cHX30cTuKImZi3pMH8Ckmhrl5yj3bk4er4oP2R8NHGWIScCJ1F8pLjhvpJ6zQarH1sFJgkP6qEoApf3w1WJMDYp9l4IXSp6C2kc1F9nCEb2uv77B0/gI5ZLqYEeNzoX45fDh8jw+URds+/OqaWZtnVMj/v+7jv7UvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523911; c=relaxed/simple;
	bh=qcCJMIEB/YYA+Wr5VMPjm8ILdoDyBhZd0vKvkLuJklw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0WEijIw/QCNiRrlt1k8Rt7ckr0FSJ+Cdw6OaaUL6xxA3+uBiO9NwTuvn1JgLym30Rs3qysNBk2QLQY2v9+FeIXDG3rByheMhKsvEEIs6/ANDhEW2MmmpbvcBuCGprAvzQNLZ2iKyEoJviNhYRaRi9bX5/pdl46OzJgj8+m/xsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbDXab7h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V4ffDXlDC4IXD1cfMgUEPRkug63IDolKcU/ffLWZ1l4=;
	b=gbDXab7hacLGYq6YLHYNbY+e22eW8fIzyP0VtJ2JdjXtmrMyEwdCSH/6qbd/j0eM1/78kV
	YDkA2L6XJABwE0UKBmirKGBJUevILzQbG31/TCfvLusWNfI2YvVzkFLQrZ2oe+ntAcWYKF
	8YtrcJVRG4Gb91n40NK+7kdV8NzAUTY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-5hAsmAaKML6WRW0Fvh4PBw-1; Tue, 01 Apr 2025 12:11:47 -0400
X-MC-Unique: 5hAsmAaKML6WRW0Fvh4PBw-1
X-Mimecast-MFC-AGG-ID: 5hAsmAaKML6WRW0Fvh4PBw_1743523906
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d00017e9dso39784795e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523906; x=1744128706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4ffDXlDC4IXD1cfMgUEPRkug63IDolKcU/ffLWZ1l4=;
        b=HHVnqsJfGJFqfjt2y6vWmmHJAQ27DFkFy5NHLHLEldeWwrcHI2vyWP8p9wV3sw9Gt4
         zyz12H8Bz8MyXAONnhSVjupzCvvlp6+CzjBTEXIu83fMi40tj7YCVLIeCA4VFj4rKPzV
         w2PBDp1cRugcn5C3KprkNVI9p1TzOwm8mazvQHsvzWFkcpU6bi6ijtXa/Sur1F8r/ULE
         wcQTYddsUVpLakN10J/2BYKDMGlbfYjcsxWcN/R6vTRuB2pOeoPdtWtN1s4DDfHP+QZE
         S/CKCN4E4y+TRwf2G5m6mKr1XzrooDyBbvWcudZrzDUWpLbnnb0AQzrPcMdm3UhnpFjm
         dhIA==
X-Forwarded-Encrypted: i=1; AJvYcCUVT5RvL5QKpraWGwAkKVDB3VlkfSQK26ztRTwflO48pVl/McP0pdy82lrEf8nKpVtJZJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXCUfqVBak8JFVfDU0KMvrjEcOVbmjqNsUmt1BLNmKo7+N48Ye
	X/RkCP+16wHeJ7TT+b26Xsj/cAHpP1mIxoBYPlCKprsD7gMcxSQzROK6HLJFYSPn1xhlx7K/ogh
	DbWo2sEr1eh+aRTSY65O+vAbS6gaNududEnNa0GI9ivAfWy7LOQ==
X-Gm-Gg: ASbGncvUW7JYPld+/OYw7Gh4RCB7RIXGok4Yg0bKz6l63Tg0dZUt6hPP8IdJMZNLQM/
	ZQOvoxDDcQ/GP2Flc2WRtl0OJhyQQaqTD+tDfQYVWgUX2wjzwPMIAQEHwKdshlvOljwz8JM0lLY
	wzkcWf8GJ6ODRS96mFVzrYdvKBW8CzBCxUTQ0Vd75rcsKDzwj2A30Wj/RBXowQb9fKBmQwXUZKJ
	6s4N0y3w3+h9zMVawHweKjKHAzX6YwFqhgyrlyYV1h+6wVtz0e/dM89aJBvyfMrLuRkzhRPXp1M
	67JyhnmNQNlGPE7j1ArlXQ==
X-Received: by 2002:a05:600c:4e87:b0:43c:f8fc:f686 with SMTP id 5b1f17b1804b1-43db61d6c2fmr101787135e9.3.1743523905650;
        Tue, 01 Apr 2025 09:11:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSQ1wvUh2eHOLlh8NcVQtz5xS01dfxv4KX3HPNNarZ4kwVszorKHWEoxoNvdgXqk1Sv1qazA==
X-Received: by 2002:a05:600c:4e87:b0:43c:f8fc:f686 with SMTP id 5b1f17b1804b1-43db61d6c2fmr101786685e9.3.1743523905112;
        Tue, 01 Apr 2025 09:11:45 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82e83482sm207502195e9.14.2025.04.01.09.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:43 -0700 (PDT)
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
Subject: [PATCH 13/29] KVM: implement vCPU creation for extra planes
Date: Tue,  1 Apr 2025 18:10:50 +0200
Message-ID: <20250401161106.790710-14-pbonzini@redhat.com>
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

For userspace to have fun with planes it is probably useful to let them
create vCPUs on the non-zero planes as well.  Since such vCPUs are backed
by the same struct kvm_vcpu, these are regular vCPU file descriptors except
that they only allow a small subset of ioctls (mostly get/set) and they
share some of the backing resources, notably vcpu->run.

TODO: prefault might be useful on non-default planes as well?

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst |   3 +
 include/linux/kvm_host.h           |   4 +-
 include/uapi/linux/kvm.h           |   1 +
 virt/kvm/kvm_main.c                | 167 +++++++++++++++++++++++------
 4 files changed, 142 insertions(+), 33 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index ae8bce7fecbe..ad22344deb28 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -26,6 +26,9 @@ The acquisition orders for mutexes are as follows:
   are taken on the waiting side when modifying memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
+- when VMs have multiple planes, vcpu->mutex for plane 0 can taken
+  outside vcpu->mutex for the same id and another plane
+
 cpus_read_lock() vs kvm_lock:
 
 - Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b511aed2de8e..99fd90c5d71b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -343,6 +343,9 @@ struct kvm_vcpu {
 
 	struct mutex mutex;
 
+	/* Only valid on plane 0 */
+	bool wants_to_run;
+
 	/* Shared for all planes */
 	struct kvm_run *run;
 
@@ -388,7 +391,6 @@ struct kvm_vcpu {
 		bool dy_eligible;
 	} spin_loop;
 #endif
-	bool wants_to_run;
 	bool preempted;
 	bool ready;
 	bool scheduled_out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 96d25c7fa18f..24fa002cd7c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1691,5 +1691,6 @@ struct kvm_pre_fault_memory {
 };
 
 #define KVM_CREATE_PLANE	_IO(KVMIO, 0xd6)
+#define KVM_CREATE_VCPU_PLANE	_IO(KVMIO, 0xd7)
 
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 863fd80ddfbe..06fa2a6ad96f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -438,11 +438,11 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 }
 #endif
 
-static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
+static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_plane *plane, unsigned id)
 {
 	mutex_init(&vcpu->mutex);
 	vcpu->cpu = -1;
-	vcpu->kvm = kvm;
+	vcpu->kvm = plane->kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
 	rwlock_init(&vcpu->pid_lock);
@@ -459,8 +459,13 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->last_used_slot = NULL;
 
 	/* Fill the stats id string for the vcpu */
-	snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
-		 task_pid_nr(current), id);
+	if (plane->plane) {
+		snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d:%d",
+			 task_pid_nr(current), id, plane->plane);
+	} else {
+		snprintf(vcpu->stats_id, sizeof(vcpu->stats_id), "kvm-%d/vcpu-%d",
+			 task_pid_nr(current), id);
+	}
 }
 
 static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -475,7 +480,9 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 */
 	put_pid(vcpu->pid);
 
-	free_page((unsigned long)vcpu->run);
+	if (!vcpu->plane)
+		free_page((unsigned long)vcpu->run);
+
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
@@ -4026,6 +4033,9 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
 	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
 	struct page *page;
 
+	if (vcpu->plane)
+		return VM_FAULT_SIGBUS;
+
 	if (vmf->pgoff == 0)
 		page = virt_to_page(vcpu->run);
 #ifdef CONFIG_X86
@@ -4113,7 +4123,10 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	if (!debugfs_initialized())
 		return;
 
-	snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
+	if (vcpu->plane)
+		snprintf(dir_name, sizeof(dir_name), "vcpu%d:%d", vcpu->vcpu_id, vcpu->plane);
+	else
+		snprintf(dir_name, sizeof(dir_name), "vcpu%d", vcpu->vcpu_id);
 	debugfs_dentry = debugfs_create_dir(dir_name,
 					    vcpu->kvm->debugfs_dentry);
 	debugfs_create_file("pid", 0444, debugfs_dentry, vcpu,
@@ -4126,9 +4139,10 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
+static int kvm_vm_ioctl_create_vcpu(struct kvm_plane *plane, struct kvm_vcpu *plane0_vcpu, unsigned long id)
 {
 	int r;
+	struct kvm *kvm = plane->kvm;
 	struct kvm_vcpu *vcpu;
 	struct page *page;
 
@@ -4165,24 +4179,33 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 		goto vcpu_decrement;
 	}
 
-	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!page) {
-		r = -ENOMEM;
-		goto vcpu_free;
-	}
-	vcpu->run = page_address(page);
+	if (plane->plane) {
+		page = NULL;
+		vcpu->run = plane0_vcpu->run;
+	} else {
+		WARN_ON(plane0_vcpu != NULL);
+		plane0_vcpu = vcpu;
 
-	if (kvm->dirty_ring_size) {
-		r = kvm_dirty_ring_alloc(kvm, &vcpu->__dirty_ring,
-					 id, kvm->dirty_ring_size);
-		if (r)
-			goto vcpu_free_run_page;
+		BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!page) {
+			r = -ENOMEM;
+			goto vcpu_free;
+		}
+		vcpu->run = page_address(page);
+
+		if (kvm->dirty_ring_size) {
+			r = kvm_dirty_ring_alloc(kvm, &vcpu->__dirty_ring,
+						 id, kvm->dirty_ring_size);
+			if (r)
+				goto vcpu_free_run_page;
+		}
 	}
 
-	vcpu->plane0 = vcpu;
-	vcpu->stat = &vcpu->__stat;
-	kvm_vcpu_init(vcpu, kvm, id);
+	vcpu->plane0 = plane0_vcpu;
+	vcpu->stat = &plane0_vcpu->__stat;
+	vcpu->dirty_ring = &plane0_vcpu->__dirty_ring;
+	kvm_vcpu_init(vcpu, plane, id);
 
 	r = kvm_arch_vcpu_create(vcpu);
 	if (r)
@@ -4190,7 +4213,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 
 	mutex_lock(&kvm->lock);
 
-	if (kvm_get_vcpu_by_id(kvm, id)) {
+	if (kvm_get_plane_vcpu_by_id(plane, id)) {
 		r = -EEXIST;
 		goto unlock_vcpu_destroy;
 	}
@@ -4200,8 +4223,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	 * release semantics, which ensures the write is visible to kvm_get_vcpu().
 	 */
 	vcpu->plane = -1;
-	vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
-	r = xa_insert(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx, vcpu, GFP_KERNEL_ACCOUNT);
+	if (plane->plane)
+		vcpu->vcpu_idx = atomic_read(&kvm->online_vcpus);
+	else
+		vcpu->vcpu_idx = plane0_vcpu->vcpu_idx;
+
+	r = xa_insert(&plane->vcpu_array, vcpu->vcpu_idx,
+		      vcpu, GFP_KERNEL_ACCOUNT);
 	WARN_ON_ONCE(r == -EBUSY);
 	if (r)
 		goto unlock_vcpu_destroy;
@@ -4220,13 +4248,14 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	if (r < 0)
 		goto kvm_put_xa_erase;
 
-	atomic_inc(&kvm->online_vcpus);
+	if (!plane0_vcpu)
+		atomic_inc(&kvm->online_vcpus);
 
 	/*
 	 * Pairs with xa_load() in kvm_get_vcpu, ensuring that online_vcpus
 	 * is updated before vcpu->plane.
 	 */
-	smp_store_release(&vcpu->plane, 0);
+	smp_store_release(&vcpu->plane, plane->plane);
 	mutex_unlock(&vcpu->mutex);
 
 	mutex_unlock(&kvm->lock);
@@ -4237,14 +4266,15 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 kvm_put_xa_erase:
 	mutex_unlock(&vcpu->mutex);
 	kvm_put_kvm_no_destroy(kvm);
-	xa_erase(&kvm->planes[0]->vcpu_array, vcpu->vcpu_idx);
+	xa_erase(&plane->vcpu_array, vcpu->vcpu_idx);
 unlock_vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_dirty_ring:
 	kvm_dirty_ring_free(&vcpu->__dirty_ring);
 vcpu_free_run_page:
-	free_page((unsigned long)vcpu->run);
+	if (page)
+		__free_page(page);
 vcpu_free:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
@@ -4406,6 +4436,35 @@ static int kvm_plane_ioctl_check_extension(struct kvm_plane *plane, long arg)
 	}
 }
 
+static int kvm_plane_ioctl_create_vcpu(struct kvm_plane *plane, long arg)
+{
+	int r = -EINVAL;
+	struct file *file;
+	struct kvm_vcpu *vcpu;
+	int fd;
+
+	if (arg != (int)arg)
+		return -EBADF;
+
+	fd = arg;
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+
+	if (file->f_op != &kvm_vcpu_fops)
+		goto err;
+
+	vcpu = file->private_data;
+	if (vcpu->kvm != plane->kvm)
+		goto err;
+
+	r = kvm_vm_ioctl_create_vcpu(plane, vcpu, vcpu->vcpu_id);
+
+err:
+	fput(file);
+	return r;
+}
+
 static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl,
 			      unsigned long arg)
 {
@@ -4432,6 +4491,8 @@ static long __kvm_plane_ioctl(struct kvm_plane *plane, unsigned int ioctl,
 #endif
 	case KVM_CHECK_EXTENSION:
 		return kvm_plane_ioctl_check_extension(plane, arg);
+	case KVM_CREATE_VCPU_PLANE:
+		return kvm_plane_ioctl_create_vcpu(plane, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -4463,6 +4524,44 @@ static struct file_operations kvm_plane_fops = {
 };
 
 
+static inline bool kvm_arch_is_vcpu_plane_ioctl(unsigned ioctl)
+{
+	switch (ioctl) {
+	case KVM_GET_DEBUGREGS:
+	case KVM_SET_DEBUGREGS:
+	case KVM_GET_FPU:
+	case KVM_SET_FPU:
+	case KVM_GET_LAPIC:
+	case KVM_SET_LAPIC:
+	case KVM_GET_MSRS:
+	case KVM_SET_MSRS:
+	case KVM_GET_NESTED_STATE:
+	case KVM_SET_NESTED_STATE:
+	case KVM_GET_ONE_REG:
+	case KVM_SET_ONE_REG:
+	case KVM_GET_REGS:
+	case KVM_SET_REGS:
+	case KVM_GET_SREGS:
+	case KVM_SET_SREGS:
+	case KVM_GET_SREGS2:
+	case KVM_SET_SREGS2:
+	case KVM_GET_VCPU_EVENTS:
+	case KVM_SET_VCPU_EVENTS:
+	case KVM_GET_XCRS:
+	case KVM_SET_XCRS:
+	case KVM_GET_XSAVE:
+	case KVM_GET_XSAVE2:
+	case KVM_SET_XSAVE:
+
+	case KVM_GET_REG_LIST:
+	case KVM_TRANSLATE:
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 static long kvm_vcpu_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4475,6 +4574,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
 		return -EIO;
 
+	if (vcpu->plane && !kvm_arch_is_vcpu_plane_ioctl(ioctl))
+		return -EINVAL;
+
 	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
 		return -EINVAL;
 
@@ -4958,7 +5060,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_PLANES:
 		if (kvm)
 			return kvm_arch_nr_vcpu_planes(kvm);
-		return KVM_MAX_PLANES;
+		return KVM_MAX_VCPU_PLANES;
 	case KVM_CAP_PLANES_FPU:
 		return kvm_arch_planes_share_fpu(kvm);
 #endif
@@ -5201,7 +5303,8 @@ static int kvm_vm_ioctl_create_plane(struct kvm *kvm, unsigned id)
 	struct file *file;
 	int r, fd;
 
-	if (id >= KVM_MAX_VCPU_PLANES)
+	if (id >= kvm_arch_nr_vcpu_planes(kvm)
+	    || WARN_ON_ONCE(id >= KVM_MAX_VCPU_PLANES))
 		return -EINVAL;
 
 	guard(mutex)(&kvm->lock);
@@ -5259,7 +5362,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_create_plane(kvm, arg);
 		break;
 	case KVM_CREATE_VCPU:
-		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
+		r = kvm_vm_ioctl_create_vcpu(kvm->planes[0], NULL, arg);
 		break;
 	case KVM_ENABLE_CAP: {
 		struct kvm_enable_cap cap;
-- 
2.49.0


