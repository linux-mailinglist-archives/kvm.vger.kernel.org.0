Return-Path: <kvm+bounces-8630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CBE8536E9
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 18:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 747171F26B36
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 17:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0655FDB7;
	Tue, 13 Feb 2024 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dl55hXqo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EADC5FBB1
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707844389; cv=none; b=TX8ejkab4u+Qp7SHQxdDkbznF+zU7mV5lraR1yjSuJikb03ep+5qcS4OPia4inaxW5pEdHJBsorQijLjoop6l39TCHprdxeHEfVlzT3iiuf2U6O1Ew6RG+CBEXGbcTyRiKcGgY+pitGHY05AaN752pt/bDestkMB6c2HLb2yLOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707844389; c=relaxed/simple;
	bh=h4cB5JHd8AcNVaeM9c7rZQN4CcuQCnphSNrUX1ZKPI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lT7INdKYIWwBaztqkZyKk8XoYEeKdTM7ZJvpQgIlIOwxWp+2oRRupAuOHagDVtp6O3DILXhfTnQ1CLwtSUOSMacXeTWjcPn4k8OkrY2BLrQT+8orfSClDPSlIZcaWHU7n9YV9XUrHhnzrsKqAgOc6EGh0WRfh/5DU3yr/9h9mUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dl55hXqo; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-607838c0800so10337517b3.1
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707844386; x=1708449186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NseTxscz5dqu1awIczEokA/c80peECIvMUkxkuD+nY=;
        b=dl55hXqo6n9BeI5DdLkGoh0o2zzUJ+AOixuQUCAO5H0VzjKgZhBKLxqOB033/uQTwM
         bR0hO7LLY/A/8x7o02JqRDEa22Q0rgowyAO38uUY5VG7/bPYqrGT9koJ9TXzTbWAEBnW
         XHbHMyNdD5kn3K5QK2IakqU8k/Mzjs7K2LOPVqbH048Cf//yun56jycHKW9DI1almal8
         VYddFfQNcMNpD6qA3NOQz2KfMb8QdItTzeWTpqWLnES15dUwYG35MFx5zzD2NlpfVrvi
         9Pxs/hBTa3uJiYp38GzJrOqzR+RTLCXAbZeJJZq3Ov/NuIaF8/daJ1BJ0wD/GvlBXzia
         7Amw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707844386; x=1708449186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7NseTxscz5dqu1awIczEokA/c80peECIvMUkxkuD+nY=;
        b=MHoUWKCkGB77GT/y18ui5PtaJStMzDhOsSZ4uEecIflkttm8I1t+vtGY00qZLShSZi
         sFQzn04+UXrKu1oo1Aop3OVXvIoUjDuhKmKgjM1c7YqVM/QNtetJk6ZLYGP1wx0wV7vE
         8vqyIhhtZHhtRkxJMxdFe2B/TkWKytqa0dmsCIj8kyojx/4C23ZalurUMiC9D/IReC2b
         10Gn46h1nlzYcWhsvVdPNoICbyUHC+HLJaunNsqmFlkuR5AcvwxjM6ytPKtPYIYrPWc+
         UfqOG2P49VI6DuONZzwe8DGxG5UMOEw91IPJjLJhDpxEGJVahfuMWPhEXZx+YMs1d7Ba
         EZwg==
X-Forwarded-Encrypted: i=1; AJvYcCXQBZ7rhkYca3NjeiWPg5DMY7UJKXiYtElXHASa8yjM8DAGHXgo130rj50cc8ktmfmuyxrMImafV4lp0ONsEaMObwAu
X-Gm-Message-State: AOJu0YyGkgH+C1naK4UOT2Gh7iQZcnM/Z3mey9BIHXcs74ty3aGt7FT2
	/+tfxMEYv+9IGhNRkYKnt5Pc2xvAMzYpLOO2Mfn1jbvfDwvfTsbIZxA1j1LFkejZlpdk+/w07Tb
	h7w==
X-Google-Smtp-Source: AGHT+IEzqCxCDV0Gnim6GYjTtjI6HlJB9NqWAO8JCJPAdg+oIo+EDb6zqG81+Q85uJSViEJWOABcGUBtiCk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1890:b0:dbd:ee44:8908 with SMTP id
 cj16-20020a056902189000b00dbdee448908mr20517ybb.0.1707844386397; Tue, 13 Feb
 2024 09:13:06 -0800 (PST)
Date: Tue, 13 Feb 2024 09:13:04 -0800
In-Reply-To: <20240206153405.489531-1-avagin@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206153405.489531-1-avagin@google.com>
Message-ID: <ZcujIJemLxhjnjfN@google.com>
Subject: Re: [PATCH v2] kvm/x86: allocate the write-tracking metadata on-demand
From: Sean Christopherson <seanjc@google.com>
To: Andrei Vagin <avagin@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Andrei Vagin wrote:
> The write-track is used externally only by the gpu/drm/i915 driver.
> Currently, it is always enabled, if a kernel has been compiled with this
> driver.
> 
> Enabling the write-track mechanism adds a two-byte overhead per page across
> all memory slots. It isn't significant for regular VMs. However in gVisor,
> where the entire process virtual address space is mapped into the VM, even
> with a 39-bit address space, the overhead amounts to 256MB.
> 
> This change rework the write-tracking mechanism to enable it on-demand
> in kvm_page_track_register_notifier.

Don't use "this change", "this patch", or any other variant of "this blah" that
you come up with.  :-)  Simply phrase the changelog as a command.

> Here is Sean's comment about the locking scheme:
> 
> The only potential hiccup would be if taking slots_arch_lock would
> deadlock, but it should be impossible for slots_arch_lock to be taken in
> any other path that involves VFIO and/or KVMGT *and* can be coincident.
> Except for kvm_arch_destroy_vm() (which deletes KVM's internal
> memslots), slots_arch_lock is taken only through KVM ioctls(), and the
> caller of kvm_page_track_register_notifier() *must* hold a reference to
> the VM.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
> v1: https://lore.kernel.org/lkml/ZcErs9rPqT09nNge@google.com/T/
> v2: allocate the write-tracking metadata on-demand
> 
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/mmu/mmu.c          | 24 +++++------
>  arch/x86/kvm/mmu/page_track.c   | 74 ++++++++++++++++++++++++++++-----
>  arch/x86/kvm/mmu/page_track.h   |  3 +-
>  4 files changed, 78 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d271ba20a0b2..c35641add93c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1503,6 +1503,8 @@ struct kvm_arch {
>  	 */
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>  	struct kvm_mmu_memory_cache split_desc_cache;
> +
> +	bool page_write_tracking_enabled;

Rather than a generic page_write_tracking_enabled, I think it makes sense to
explicitly track if there are *external* write tracking users.  One could argue
it makes the total tracking *too* fine grained, but I think it would be helpful
for readers to when KVM itself is using write tracking (shadow paging) versus
when KVM has write tracking enabled, but has not allocated rmaps (external write
tracking user).

That way, kernels with CONFIG_KVM_EXTERNAL_WRITE_TRACKING=n don't need to check
the bool (though they'll still check kvm_shadow_root_allocated()).  And as a
bonus, the diff is quite a bit smaller.

> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index c87da11f3a04..a4790b0a6f50 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -20,10 +20,14 @@
>  #include "mmu_internal.h"
>  #include "page_track.h"
>  
> -bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
> +static bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
>  {
> -	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
> -	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
> +	/*
> +	 * Read page_write_tracking_enabled before related pointers. Pairs with
> +	 * smp_store_release in kvm_page_track_write_tracking_enable.
> +	 */
> +	return smp_load_acquire(&kvm->arch.page_write_tracking_enabled) |

Needs to be a logical ||, not a bitwise |.

> @@ -161,12 +204,21 @@ int kvm_page_track_register_notifier(struct kvm *kvm,
>  				     struct kvm_page_track_notifier_node *n)
>  {
>  	struct kvm_page_track_notifier_head *head;
> +	int r;
>  
>  	if (!kvm || kvm->mm != current->mm)
>  		return -ESRCH;
>  
>  	kvm_get_kvm(kvm);
>  
> +	mutex_lock(&kvm->slots_arch_lock);

This can and should check if write tracking is enabled without taking the mutex.
I *highly* doubt it will matter in practice, especially since KVM-GT is the only
user of the external tracking, and attaching a vGPU is a one-time thing.  But
it's a cheap an easy optimization that also makes the code look more like the
shadow_root_allocated, i.e. makes it easier to grok that the two flows are doing
very similar things.

> +	r = kvm_page_track_write_tracking_enable(kvm);

I'd prefer to call this helper kvm_enable_external_write_tracking().  As is, I
had hard time seein which flows were calling enable() versus enabled().

> +	mutex_unlock(&kvm->slots_arch_lock);
> +	if (r) {
> +		kvm_put_kvm(kvm);

Allocate write tracking before kvm_get_kvm(), then there's no need to have an
error handling path.

All in all, this?  Compile tested only.

---
 arch/x86/include/asm/kvm_host.h |  9 +++++
 arch/x86/kvm/mmu/page_track.c   | 68 ++++++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad5319a503f0..af857a899f85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1467,6 +1467,15 @@ struct kvm_arch {
 	 */
 	bool shadow_root_allocated;
 
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+	/*
+	 * If set, the VM has (or had) an external write tracking user, and
+	 * thus all write tracking metadata has been allocated, even if KVM
+	 * itself isn't using write tracking.
+	 */
+	bool external_write_tracking_enabled;
+#endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11f3a04..6fb61b33675f 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -20,10 +20,23 @@
 #include "mmu_internal.h"
 #include "page_track.h"
 
+static bool kvm_external_write_tracking_enabled(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_EXTERNAL_WRITE_TRACKING
+	/*
+	 * Read external_write_tracking_enabled before related pointers.  Pairs
+	 * with the smp_store_release in kvm_page_track_write_tracking_enable().
+	 */
+	return smp_load_acquire(&kvm->arch.external_write_tracking_enabled);
+#else
+	return false;
+#endif
+}
+
 bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 {
-	return IS_ENABLED(CONFIG_KVM_EXTERNAL_WRITE_TRACKING) ||
-	       !tdp_enabled || kvm_shadow_root_allocated(kvm);
+	return kvm_external_write_tracking_enabled(kvm) ||
+	       kvm_shadow_root_allocated(kvm) || !tdp_enabled;
 }
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
@@ -153,6 +166,50 @@ int kvm_page_track_init(struct kvm *kvm)
 	return init_srcu_struct(&head->track_srcu);
 }
 
+static int kvm_enable_external_write_tracking(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0, i, bkt;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Check for *any* write tracking user (not just external users) under
+	 * lock.  This avoids unnecessary work, e.g. if KVM itself is using
+	 * write tracking, or if two external users raced when registering.
+	 */
+	if (kvm_page_track_write_tracking_enabled(kvm))
+		goto out_success;
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, bkt, slots) {
+			/*
+			 * Intentionally do NOT free allocations on failure to
+			 * avoid having to track which allocations were made
+			 * now versus when the memslot was created.  The
+			 * metadata is guaranteed to be freed when the slot is
+			 * freed, and will be kept/used if userspace retries
+			 * the failed ioctl() instead of killing the VM.
+			 */
+			r = kvm_page_track_write_tracking_alloc(slot);
+			if (r)
+				goto out_unlock;
+		}
+	}
+
+	/*
+	 * Ensure that external_write_tracking_enabled becomes true strictly
+	 * after all the related pointers are set.
+	 */
+out_success:
+	smp_store_release(&kvm->arch.external_write_tracking_enabled, true);
+out_unlock:
+	mutex_unlock(&kvm->slots_arch_lock);
+	return r;
+}
+
 /*
  * register the notifier so that event interception for the tracked guest
  * pages can be received.
@@ -161,10 +218,17 @@ int kvm_page_track_register_notifier(struct kvm *kvm,
 				     struct kvm_page_track_notifier_node *n)
 {
 	struct kvm_page_track_notifier_head *head;
+	int r;
 
 	if (!kvm || kvm->mm != current->mm)
 		return -ESRCH;
 
+	if (!kvm_external_write_tracking_enabled(kvm)) {
+		r = kvm_enable_external_write_tracking(kvm);
+		if (r)
+			return r;
+	}
+
 	kvm_get_kvm(kvm);
 
 	head = &kvm->arch.track_notifier_head;

base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
-- 


