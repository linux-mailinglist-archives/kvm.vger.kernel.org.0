Return-Path: <kvm+bounces-35598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CCE2A12B68
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 20:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C35457A0FF0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70101D6DC5;
	Wed, 15 Jan 2025 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuI1v/SE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F51D61BB;
	Wed, 15 Jan 2025 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736967810; cv=none; b=Mvovzvkx131DhfoHRUSccnhmrL6+WvpIoN3grictQnKK+y530QQRUHomiR3ITg/0X4D/T9n0qwMMgitLPPVBh+nMJmOnPixp6gHX9YTx99tgwHlyMs/H+gSTCukRN+yH1AwRToRF0BrhGy+8nANCHMC16CA3kEYs9rL9Qo0zbEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736967810; c=relaxed/simple;
	bh=VAPXz2lk/aPqnrUp7qNA4j2tfR1dOW+mD7o3FbZjQtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tol1926J3pNNVKiYcJ9qSUjQJRB8ntjRXwJ4fFpuGj0JauQGtaLvA2uwl9VwXHDBPP9wooecZZhWFh/l3rXliQuhkLqeYxZXsjadcWpAowtFx0EMfj/ry37jB4rwQWeO2G5fIcPxDkOZgPnV74YtnDAAjTjjcrltFni+n+LDfN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuI1v/SE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D06C4CEE1;
	Wed, 15 Jan 2025 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736967810;
	bh=VAPXz2lk/aPqnrUp7qNA4j2tfR1dOW+mD7o3FbZjQtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TuI1v/SEQhVchExis5wBanGXJUS+fP2DCaKBzuqFoXz2IlqIkyqZ8lcbzG9ABDyxJ
	 cGTxwgADj/67SmbAu1pnkiigQaMEVJbRdoeDXFnzCa6MRbg1fLasscMrJOKPRvd7Dh
	 yoU7Z57ZIbPyEHzzr/hw/QqRmZlb6PsuGF7FIUB/zHsJLB/gzVQuMMy3wsYVj7hlrP
	 bko2k2jnf3Nc8RVVgqvvLyr7cPsd7RrxF5vlBaU4LAmMOi0Fge+VB3IiR4xV35Zt8I
	 G+iLQ9KrvDpATFlZ58pBRxP6o+cxfAeSViwl7LK9EEM4/ppgvvC1GwiulYDOlMdvbD
	 8Icsxpp0C66HQ==
Date: Wed, 15 Jan 2025 12:03:27 -0700
From: Keith Busch <kbusch@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, michael.christie@oracle.com,
	Tejun Heo <tj@kernel.org>, Luca Boccassi <bluca@debian.org>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Message-ID: <Z4gGf5SAJwnGEFK0@kbusch-mbp>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
 <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp>
 <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com>
 <Z4fnkL5-clssIKc-@kbusch-mbp>
 <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>

On Wed, Jan 15, 2025 at 06:10:05PM +0100, Paolo Bonzini wrote:
> You can implement something like pthread_once():

...

> Where to put it I don't know.  It doesn't belong in
> include/linux/once.h.  I'm okay with arch/x86/kvm/call_once.h and just
> pull it with #include "call_once.h".

Thanks for the suggestion, I can work with that. As to where to put it,
I think the new 'struct once' needs to be a member of struct kvm_arch,
so I've put it in arch/x86/include/asm/.

Here's the result with that folded in. If this is okay, I'll send a v2,
and can split out the call_once as a prep patch with your attribution if
you like.

---
diff --git a/arch/x86/include/asm/kvm_call_once.h b/arch/x86/include/asm/kvm_call_once.h
new file mode 100644
index 0000000000000..451cc87084aa7
--- /dev/null
+++ b/arch/x86/include/asm/kvm_call_once.h
@@ -0,0 +1,44 @@
+#ifndef _LINUX_CALL_ONCE_H
+#define _LINUX_CALL_ONCE_H
+
+#include <linux/types.h>
+
+#define ONCE_NOT_STARTED 0
+#define ONCE_RUNNING     1
+#define ONCE_COMPLETED   2
+
+struct once {
+        atomic_t state;
+        struct mutex lock;
+};
+
+static inline void __once_init(struct once *once, const char *name,
+			       struct lock_class_key *key)
+{
+        atomic_set(&once->state, ONCE_NOT_STARTED);
+        __mutex_init(&once->lock, name, key);
+}
+
+#define once_init(once)							\
+do {									\
+	static struct lock_class_key __key;				\
+	__once_init((once), #once, &__key);				\
+} while (0)
+
+static inline void call_once(struct once *once, void (*cb)(struct once *))
+{
+        /* Pairs with atomic_set_release() below.  */
+        if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
+                return;
+
+        guard(mutex)(&once->lock);
+        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
+        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
+                return;
+
+        atomic_set(&once->state, ONCE_RUNNING);
+        cb(once);
+        atomic_set_release(&once->state, ONCE_COMPLETED);
+}
+
+#endif /* _LINUX_CALL_ONCE_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b6..56c79958dc9cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,6 +37,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/kvm_call_once.h>
 #include <asm/reboot.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
@@ -1445,6 +1446,7 @@ struct kvm_arch {
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct vhost_task *nx_huge_page_recovery_thread;
 	u64 nx_huge_page_last;
+	struct once nx_once;
 
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2401606db2604..3c0c1f3647ceb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7411,20 +7411,28 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
 	return true;
 }
 
-int kvm_mmu_post_init_vm(struct kvm *kvm)
+static void kvm_mmu_start_lpage_recovery(struct once *once)
 {
-	if (nx_hugepage_mitigation_hard_disabled)
-		return 0;
+	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
 	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
 		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
 		kvm, "kvm-nx-lpage-recovery");
 
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+}
+
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
+	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 	if (!kvm->arch.nx_huge_page_recovery_thread)
 		return -ENOMEM;
-
-	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57ba42..23bf088fc4ae1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	int r;
 
+	r = kvm_mmu_post_init_vm(vcpu->kvm);
+	if (r)
+		return r;
+
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
@@ -12742,7 +12746,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
 {
-	return kvm_mmu_post_init_vm(kvm);
+	once_init(&kvm->arch.nx_once);
+	return 0;
 }
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
--

