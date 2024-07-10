Return-Path: <kvm+bounces-21376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C089892DCD5
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77455286516
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F0615B971;
	Wed, 10 Jul 2024 23:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dj74Obhg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1097E158D7B
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654963; cv=none; b=Ty5JX8V2kK9KXUrXQNIdRpbUsqOtNCYvZQZX7LB7XEzLqXCaMPINL8gxJOlXh4RB3g1kIdAiDz8mxszA+jjE80iPilNqGYmJM9akt/q7wu+N1oRwRA5ihB/yhc2bFEYRcm6xT+V/w8ZkpHQmWZiDk/kpgPAcl2hnTOG6OXUWnog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654963; c=relaxed/simple;
	bh=fMhhiLsPFRJdblFtX9Nm1DkhL+INhnd2gLXtlR8Pjcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IR+9dQ+v/bXgj49JQpEeSsBopSCjEjIdh1iviSYvTin9r53zKcz1DApFIZmd0ZskoYfV2GrbAJpLGUZmh32GYz0jKtAwWyApgcJcneHj7slyEG1xiABbCZ6ckkKmYLlzGZCih4C+iXMG2zp6S7SoDXMpEa3pWfKzuzmlZWg1j04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dj74Obhg; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-48ffc7dc42fso87211137.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654960; x=1721259760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HCYoX0wE5GpicSTYT42iy6iZfDY9W+9PX613SFW91R8=;
        b=dj74ObhgmWglBTjsfK24/p/zFxK/NLqxsuzJZxMGjIDuN6BRlDBVzp/PZ/qerDyaTl
         PJvz00daKKTwpNK1QWID9KeLWDLbSX0S4vU1hE/hL/7J4ZG9Sh5Kq1mTot6X4HYDPtjR
         BOMllJJ/zqUvKT0tKJe//KTi3LQTISG6UTnO4ypJrtu0vxYu3EwQOwmETlKyBC0xQHVV
         t4/134slOqYF/ZpW7yziaV9SWOjwOSsawiKns5xt0r+WvYicWd8QbRAoshffsgIs11gc
         QoejyqYazDYu4fblIv3FyLA+MOt8qTpQzR0TuE90AhR6WUi+NTzAfLHzrvmG0OwLwiiZ
         CTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654960; x=1721259760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCYoX0wE5GpicSTYT42iy6iZfDY9W+9PX613SFW91R8=;
        b=PMxXh4BkHCE971bnzZG2wf/yJ6DOSiVkoT4kakXJtCjo4SrUmqk3FDhZa23RCpSI9f
         TNihfNdXWvKPDvbtlIRYahg1R6Ap29kYZPUzXDLxgBO3ziKqkKJVJfoXGR/ZMzEq3vqo
         7ESfMMgLkASmOFWr87oxa+OHf8v1QPxmG5geM26BLKCoivD3bW56xv1u8JQIolWSsRbM
         m2ZDN3RJ7QSM6VknVhMDWqaP27Drys01ADIBHopH2Ok5OWv5sErycVtrefhxJUOo++vm
         hI338DJnehyVL4YaiCJ7xSixIu3Qui9KO7XMZpmw/UfGVJYaWyXDryEnpcSPD7qU84RS
         Madg==
X-Forwarded-Encrypted: i=1; AJvYcCU+58Sq8pEFtPFRSnA+wIAw5T+WWpOcclmHj7/yeIEvwnn8CgJfBiaH8mMX4kyZKiPlSFpur2NAqoK6Ev6NpVtO4PP6
X-Gm-Message-State: AOJu0YzAP+QdIFfB3+vWyzQTaD2hJEPMD1RvX0b82AZ1hUigDaLdmSLG
	5h5fky1a/u3nDbnrEOgr4j4kNlnFeyzwGEq+Cz8/HZCo0jSlfQVipyD3hzFS5eI6M2XgNTPXtaK
	mnOoK38/vF/DuicZIyQ==
X-Google-Smtp-Source: AGHT+IG6wA2gw3HKgkdoyUxrFHR7N0Dl00lUttDnuqK5Ufpq56dpOwAB+SOcWAyxOYR+FLktKLLLdIod/BQqZoEF
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:38cd:b0:48b:e1a1:e57 with SMTP
 id ada2fe7eead31-49031dbef0emr134053137.0.1720654959859; Wed, 10 Jul 2024
 16:42:39 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:06 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-3-jthoughton@google.com>
Subject: [RFC PATCH 02/18] KVM: Add KVM_CAP_USERFAULT and KVM_MEMORY_ATTRIBUTE_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add the ability to enable and disable KVM Userfault, and add
KVM_MEMORY_ATTRIBUTE_USERFAULT to control whether or not pages should
trigger userfaults.

The presence of a kvm_userfault_ctx in the struct kvm is what signifies
whether KVM Userfault is enabled or not. To make sure that this struct
is non-empty, include a struct eventfd_ctx pointer, although it is not
used in this patch.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/virt/kvm/api.rst | 23 ++++++++
 include/linux/kvm_host.h       | 14 +++++
 include/uapi/linux/kvm.h       |  5 ++
 virt/kvm/kvm_main.c            | 96 +++++++++++++++++++++++++++++++++-
 4 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..26a98fea718c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8070,6 +8070,29 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_USERFAULT
+------------------------------
+
+:Architectures: none
+:Parameters: args[0] - whether or not to enable KVM Userfault. To enable,
+                       pass KVM_USERFAULT_ENABLE, and to disable pass
+                       KVM_USERFAULT_DISABLE.
+             args[1] - the eventfd to be notified when asynchronous userfaults
+                       occur.
+
+:Returns: 0 on success, -EINVAL if args[0] is not KVM_USERFAULT_ENABLE
+          or KVM_USERFAULT_DISABLE, or if KVM Userfault is not supported.
+
+This capability, if enabled with KVM_ENABLE_CAP, allows userspace to mark
+regions of memory as KVM_MEMORY_ATTRIBUTE_USERFAULT, in which case, attempted
+accesses to these regions of memory by KVM_RUN will fail with
+KVM_EXIT_MEMORY_FAULT. Attempted accesses by other ioctls will fail with
+EFAULT.
+
+Enabling this capability will cause all future faults to create
+small-page-sized sptes. Collapsing these sptes back into their optimal size
+is done with KVM_COLLAPSE_PAGE_TABLES.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b57878c8c18..f0d4db2d64af 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -730,6 +730,10 @@ struct kvm_memslots {
 	int node_idx;
 };
 
+struct kvm_userfault_ctx {
+	struct eventfd_ctx *ev_fd;
+};
+
 struct kvm {
 #ifdef KVM_HAVE_MMU_RWLOCK
 	rwlock_t mmu_lock;
@@ -831,6 +835,7 @@ struct kvm {
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
+	struct kvm_userfault_ctx __rcu *userfault_ctx;
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -2477,4 +2482,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 #endif
 
+static inline bool kvm_userfault_enabled(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_USERFAULT
+	return !!rcu_access_pointer(kvm->userfault_ctx);
+#else
+	return false;
+#endif
+}
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d03842abae57..c84c24a9678e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_USERFAULT 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1539,6 +1540,7 @@ struct kvm_memory_attributes {
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+#define KVM_MEMORY_ATTRIBUTE_USERFAULT         (1ULL << 4)
 
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 
@@ -1548,4 +1550,7 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_USERFAULT_ENABLE		(1ULL << 0)
+#define KVM_USERFAULT_DISABLE		(1ULL << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8e422c2c9450..fb7972e61439 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2430,10 +2430,16 @@ bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 {
+	u64 attributes = 0;
 	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+		attributes |= KVM_MEMORY_ATTRIBUTE_PRIVATE;
 
-	return 0;
+#ifdef CONFIG_KVM_USERFAULT
+	if (!kvm || kvm_userfault_enabled(kvm))
+		attributes |= KVM_MEMORY_ATTRIBUTE_USERFAULT;
+#endif
+
+	return attributes;
 }
 
 static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
@@ -4946,6 +4952,84 @@ bool kvm_are_all_memslots_empty(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_are_all_memslots_empty);
 
+#ifdef CONFIG_KVM_USERFAULT
+static int kvm_disable_userfault(struct kvm *kvm)
+{
+	struct kvm_userfault_ctx *ctx;
+
+	mutex_lock(&kvm->slots_lock);
+
+	ctx = rcu_replace_pointer(kvm->userfault_ctx, NULL,
+				  mutex_is_locked(&kvm->slots_lock));
+
+	mutex_unlock(&kvm->slots_lock);
+
+	if (!ctx)
+		return 0;
+
+	/* Wait for everyone to stop using userfault. */
+	synchronize_srcu(&kvm->srcu);
+
+	eventfd_ctx_put(ctx->ev_fd);
+	kfree(ctx);
+	return 0;
+}
+
+static int kvm_enable_userfault(struct kvm *kvm, int event_fd)
+{
+	struct kvm_userfault_ctx *userfault_ctx;
+	struct eventfd_ctx *ev_fd;
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+
+	ret = -EEXIST;
+	if (kvm_userfault_enabled(kvm))
+		goto out;
+
+	ret = -ENOMEM;
+	userfault_ctx = kmalloc(sizeof(*userfault_ctx), GFP_KERNEL);
+	if (!userfault_ctx)
+		goto out;
+
+	ev_fd = eventfd_ctx_fdget(event_fd);
+	if (IS_ERR(ev_fd)) {
+		ret = PTR_ERR(ev_fd);
+		kfree(userfault_ctx);
+		goto out;
+	}
+
+	ret = 0;
+	userfault_ctx->ev_fd = ev_fd;
+
+	rcu_assign_pointer(kvm->userfault_ctx, userfault_ctx);
+out:
+	mutex_unlock(&kvm->slots_lock);
+	return ret;
+}
+
+static int kvm_vm_ioctl_enable_userfault(struct kvm *kvm, int options,
+					 int event_fd)
+{
+	u64 allowed_options = KVM_USERFAULT_ENABLE |
+			      KVM_USERFAULT_DISABLE;
+	bool enable;
+
+	if (options & ~allowed_options)
+		return -EINVAL;
+	/* Exactly one of ENABLE or DISABLE must be set. */
+	if (options == allowed_options || !options)
+		return -EINVAL;
+
+	enable = options & KVM_USERFAULT_ENABLE;
+
+	if (enable)
+		return kvm_enable_userfault(kvm, event_fd);
+	else
+		return kvm_disable_userfault(kvm);
+}
+#endif
+
 static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 					   struct kvm_enable_cap *cap)
 {
@@ -5009,6 +5093,14 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+#ifdef CONFIG_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		if (cap->flags)
+			return -EINVAL;
+
+		return kvm_vm_ioctl_enable_userfault(kvm, cap->args[0],
+						     cap->args[1]);
+#endif
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.45.2.993.g49e7a77208-goog


