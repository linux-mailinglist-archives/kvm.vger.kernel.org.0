Return-Path: <kvm+bounces-36666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 411C4A1DACC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 17:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F842188974C
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 16:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBA4E15CD78;
	Mon, 27 Jan 2025 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="poMWBr3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50602433CB
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737996487; cv=none; b=NRgGyJ5pcuCTMEW6l9VHpq2d006tO4gTCPjiYKLapJKV1bvsdASl/2aLPOT7aKsm1sAXCIVmaF2HLn6m9s1X+/jq8sq6f0QRhhi2Fp45worQkQCAb+n9cPizTFRocz5vk0vXBKGCFdGXj32t3x1tEy7vdS4Z2A5QYVtojQSdSaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737996487; c=relaxed/simple;
	bh=rC8/+q5ECehEzDr0Eeul/D3qDLk1q1nGnFaKw1Tfmqk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hWByhdnh9xl7DMiRo+c7Ltz4IX5Ont2I189qW2A5VAHI0yO46LLitDZ3O3VUjXaijdCsBEAGLi9gnPBU+ZkODYh4n+cWHzBx4EH0FJxgnQKNZJCyV0H0nYEV2NKcSicb7JcRlR2nml3Voc8i7T4nghGz95B19gR94MsSnGA8yU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=poMWBr3z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2161d5b3eb5so87683615ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 08:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737996484; x=1738601284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZHiYiF3H2A4Qb5HmP4i+PZ2NyxuxfcL4OLEcU7/iwk=;
        b=poMWBr3zZx6oMdVn9qsHzJurm7H5tvuby8uPOgyRtrBXgugcjIUdytDxY8GQFkSR1x
         Mr/eiadioJFNHQc9NMxV9CvYaH4+sE4X6ggsqQ6uNIFNLg7gimfCTok6fTH7Tpx8vVTS
         eoNQilz/ygrZN+6U1vadu/OmaqPY0GtaMLBCqrR5Wof1q6ukXX2y0XQaPCm7o0XVrwB9
         3yfR5ScDcQe/MTx9y/Txuqmo4cXbbr2nWyrRHddapGMa3D6rFJXJGJToiVcUgEhKQAXK
         FV0kfYLyuQJZ83YUB8edSuSrxJp5EooNOb+xRfNdZHxwLPWSxYhsDgDuoMoPVDuw+4Mf
         jj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737996484; x=1738601284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZHiYiF3H2A4Qb5HmP4i+PZ2NyxuxfcL4OLEcU7/iwk=;
        b=ua9Y5KBHXASPls3+l2BWaBOPyoUzwUN6m32W1nihjvDqcaj7jhPSvR4Rvqflfcsyt6
         6S7ItJ3ME/ZxcPnS8lD3slOAL0EuA09GncxRvMslXVMjcwrnSUu/SLxRAby+zNYR0Z+A
         AivDMMZWsouhYzQV48j03NS9eA+BcLNelsq8XTcLQOStU8fxTFZ+YCnSbsAv+0G6Xdvz
         DLuy7lBpxgCNES2GzkRmLCEB1e1rmFatDSl9mB8o+8QGpN4pxPMNZ+w+ZvAi2e5YEzRG
         7wtTPojg3Fm0+WO3at9yNpqT93xrDeSGWV9TKLBqgxH10mtAQsQXlFRJ72LrS8lQ8Jqv
         /60g==
X-Forwarded-Encrypted: i=1; AJvYcCUy7IO9gluZJsdh7Aaycrs6S0QTEWZUq7s+xz3+47ViaivRWASlQ8AlMZyY1YXV0UogMvc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjj5r8CUhMDBzo8MqE2CI6F1+RgLTVmpHwTz/9JChACmXP3Avk
	71GiFFB32Qo3gMr1ySwRRqSDj+g5xkrrhwsREHPla9lyCbEkQ0JhHkA74fEjQr1ofdq8U2bGx7W
	7jA==
X-Google-Smtp-Source: AGHT+IEX1SAwxB2HSms/4bC+n9DkJN4TQKCDCbPD3ddL8tIvlGeTbPBNQ8imKUpjgqmMdv2awNRJnbmIqqs=
X-Received: from pgbdw9.prod.google.com ([2002:a05:6a02:4489:b0:a9d:dca9:236])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9105:b0:1eb:22e5:bb76
 with SMTP id adf61e73a8af0-1eb22e5bedemr52658271637.42.1737996484555; Mon, 27
 Jan 2025 08:48:04 -0800 (PST)
Date: Mon, 27 Jan 2025 08:48:03 -0800
In-Reply-To: <Z5RkcB_wf5Y74BUM@kbusch-mbp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124234623.3609069-1-seanjc@google.com> <Z5RkcB_wf5Y74BUM@kbusch-mbp>
Message-ID: <Z5e4w7IlEEk2cpH-@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
From: Sean Christopherson <seanjc@google.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Keith Busch wrote:
> On Fri, Jan 24, 2025 at 03:46:23PM -0800, Sean Christopherson wrote:
> > +static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
> > +{
> > +	/*
> > +	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
> > +	 * may not be valid even though the VM is globally visible.  Do nothing,
> > +	 * as such a VM can't have any possible NX huge pages.
> > +	 */
> > +	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
> > +
> > +	if (nx_thread)
> > +		vhost_task_wake(nx_thread);
> > +}

...

> > +	nx_thread = vhost_task_create(kvm_nx_huge_page_recovery_worker,
> > +				      kvm_nx_huge_page_recovery_worker_kill,
> > +				      kvm, "kvm-nx-lpage-recovery");
> >  
> > -	if (kvm->arch.nx_huge_page_recovery_thread)
> > -		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
> > +	if (!nx_thread)
> > +		return;
> > +
> > +	vhost_task_start(nx_thread);
> > +
> > +	/* Make the task visible only once it is fully started. */
> > +	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
> 
> I believe the WRITE_ONCE needs to happen before the vhost_task_start to
> ensure the parameter update callback can see it before it's started.

It's not clear to me that calling vhost_task_wake() before vhost_task_start() is
allowed, which is why I deliberately waited until the task was started to make it
visible.  Though FWIW, doing "vhost_task_wake(nx_thread)" before vhost_task_start()
doesn't explode.

Ha!  There is another bug here, but we can smack 'em both with a bit of trickery
and do an optimized serialization in the process.

If vhost_task_create() fails, then the call_once() will "succeed" and mark the
structure as ONCE_COMPLETED.  The first KVM_RUN will fail with -ENOMEM, but any
subsequent calls will succeed, including in-flight KVM_RUNs on other threads.
Odds are good userspace will terminate the VM on -ENOMEM, but that't not guaranteed,
e.g. if userspace has logic to retry a few times before giving up.

If call_once() and its callback are modified to return errors, then we can abuse
call_once() to serialize against kvm_mmu_start_lpage_recovery() when waking the
recovery thread.  If the recovery thread is fully created, call_once() is a lockless
happy path, otherwise the wakup path will serialize against the creation path
via the once's mutex.

Over two patches...

---
 arch/x86/kvm/mmu/mmu.c    | 46 ++++++++++++++++++++++++++++-----------
 include/linux/call_once.h | 16 ++++++++++----
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a45ae60e84ab..f3ad33cd68b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7120,6 +7120,26 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static int kvm_nx_recovery_thread_not_ready(struct once *once)
+{
+	return -ENOENT;
+}
+
+static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
+{
+	/*
+	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
+	 * may not be started even though the VM is globally visible.  Abuse
+	 * call_once() to serialize against starting the recovery thread; if
+	 * this task's callback is invoked, then the thread hasn't been created
+	 * and the thread is guaranteed to see up-to-date parameters.
+	 */
+	if (call_once(&kvm->arch.nx_once, kvm_nx_recovery_thread_not_ready))
+		return;
+
+	vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+}
+
 static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
@@ -7180,7 +7200,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7315,7 +7335,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
+			kvm_wake_nx_recovery_thread(kvm);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7447,7 +7467,7 @@ static bool kvm_nx_huge_page_recovery_worker(void *data)
 	return true;
 }
 
-static void kvm_mmu_start_lpage_recovery(struct once *once)
+static int kvm_mmu_start_lpage_recovery(struct once *once)
 {
 	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
@@ -7457,21 +7477,21 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
 		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
 		kvm, "kvm-nx-lpage-recovery");
 
-	if (kvm->arch.nx_huge_page_recovery_thread)
-		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
-}
-
-int kvm_mmu_post_init_vm(struct kvm *kvm)
-{
-	if (nx_hugepage_mitigation_hard_disabled)
-		return 0;
-
-	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 	if (!kvm->arch.nx_huge_page_recovery_thread)
 		return -ENOMEM;
+
+	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
 	return 0;
 }
 
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
+	return call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
+}
+
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
 	if (kvm->arch.nx_huge_page_recovery_thread)
diff --git a/include/linux/call_once.h b/include/linux/call_once.h
index 6261aa0b3fb0..9d47ed50139b 100644
--- a/include/linux/call_once.h
+++ b/include/linux/call_once.h
@@ -26,20 +26,28 @@ do {									\
 	__once_init((once), #once, &__key);				\
 } while (0)
 
-static inline void call_once(struct once *once, void (*cb)(struct once *))
+static inline int call_once(struct once *once, int (*cb)(struct once *))
 {
+        int r;
+
         /* Pairs with atomic_set_release() below.  */
         if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
-                return;
+                return 0;
 
         guard(mutex)(&once->lock);
         WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
         if (atomic_read(&once->state) != ONCE_NOT_STARTED)
-                return;
+                return -EINVAL;
 
         atomic_set(&once->state, ONCE_RUNNING);
-        cb(once);
+        r = cb(once);
+        if (r) {
+                atomic_set(&once->state, ONCE_NOT_STARTED);
+                return r;
+        }
+
         atomic_set_release(&once->state, ONCE_COMPLETED);
+        return 0;
 }
 
 #endif /* _LINUX_CALL_ONCE_H */

base-commit: f7bafceba76e9ab475b413578c1757ee18c3e44b
-- 

