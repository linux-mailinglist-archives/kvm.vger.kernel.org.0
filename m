Return-Path: <kvm+bounces-59203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 885D0BAE2F6
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 326A0162DAF
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13E730DD16;
	Tue, 30 Sep 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IldiY3R4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD0630DD1A
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253346; cv=none; b=aM95BR7ZeqqjYh3QhYBWhbt06inPWhLKHymdaiPcXt4CfQtve4hKXVW6PVIOKyRcUlQqzX6BpVU/ymTO8KTGhR0dE5f8Tu4LiFSy+S/72W/rxC0zaNBIGoesFpISuY1+HxOZXhGHxRmdB5Yb2kdzZBwP5kNFJ+RVNmTAnmzlyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253346; c=relaxed/simple;
	bh=YUoO0y6u2bkGmAmplMQfqH31mOKndg7Od8qgpjk4qP8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Nl31FHceWuvwBI1gPfC4f6UWKPnl5aRynyIOAGPRxTDEroj+2O2zw/lmszGOWUrlCoEaWQGumQ+Zq3U/M9YVZx14yHCgOTABujqimcbp+2SmU35AnI6cC+fmfPwsIrJxpfAaVMkT8WbXMJYAsqabjyKOFfv5K9p94ngpUujx4dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IldiY3R4; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-78427dae77eso2806223b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759253343; x=1759858143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5AG8EXy3TDZDmNNZu7WhNXxOIMuvjXbnyRS/oPPdpus=;
        b=IldiY3R4nZPQFMXuhdTR+Hf13vVWHyhjRiVEW6SA7kF4+FKxKugToJP6MhpaDuoxoc
         7thu362xUP70Ps54G+lUkbPaQV+Erd9nEdn356z6uXXcvanFFx1OIdR/5kXTG8vnYNQo
         RSZTC1wzpYZhM15Q6RmZHJwcRzF1Arc8gNBb0P2xNXBnKH5ldU8xJXFenPX6ZlpBMp2h
         +j1NRgBLkPBCx2jXqnxZIHxADGF1Z919FTHADVx8qyRxY45QVgfPk8xL7OOwhbDHjftc
         y8ei6NUkLJi/o0lDT80nlwSaGat53Gy1X8CjzVDkuiIsbx7ewmVUpof3MkWIXFzD4isw
         p/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759253343; x=1759858143;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5AG8EXy3TDZDmNNZu7WhNXxOIMuvjXbnyRS/oPPdpus=;
        b=XjPzdCe8bTPJUiTxyP3eGteUKmrPQJ0QF5l4rUa9RvojcDJ4qYAeda3vxpPpdIkA4R
         djdRbei5EHepV3zpYCC23Fg6v1pb+c478HmOYt3razOIap1QvAV3HJ0mK4xoK7mcpPJt
         otM0HSUW+QlkhMygXx+D47edOUnuTyhlHj8vZpmkbv/Zsl8iTE5GNiqtPv1XYjc3R012
         ZGOLjwYcoxL5NiCcEF6LB67u1UTvF0drA3NhC60jGClj3s/oyzhgAv8a7vVQWPWFqAZ0
         HyWJm1c7gCYmYvfyXN1fq6R8WTjaN1WEJtodQL1UfA3ejLixGBOHZo52HY1wHxRCQKNz
         bIYw==
X-Forwarded-Encrypted: i=1; AJvYcCUkU7muqCcFFHfZyMMNOKNTFdlyaDxG+tD82Vo94or+OsxID8eP7JEWupeAA4mg/N4yu0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5QKpP2knhXfcNF48awyfOXi0yOoV6iucjM43E1aOH8jv+bfw9
	SG2T+a3GD01f3EDXDdms5LCbyAnkYjPUh77h4L4nEggZstnvppMlSgfLQ5AnP718Z7fjTe8sYiX
	7K94plOlN9FVkzjz2L89rOg==
X-Google-Smtp-Source: AGHT+IEtPf0eTLS9B8WxOVqYad9jKHadZk21B1TQnhnBnoLzLcgzLQq/iOt/bFNahjpr1vKhZ1DdvaViACsqzLr7
X-Received: from pfbfb8.prod.google.com ([2002:a05:6a00:2d88:b0:780:fcea:e87f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1391:b0:781:2531:7002 with SMTP id d2e1a72fcca58-78af4226bd0mr226200b3a.27.1759253343366;
 Tue, 30 Sep 2025 10:29:03 -0700 (PDT)
Date: Tue, 30 Sep 2025 17:28:49 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20250930172850.598938-1-jthoughton@google.com>
Subject: [PATCH 1/2] KVM: For manual-protect GET_DIRTY_LOG, do not hold slots lock
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For users that have enabled manual-protect, holding the srcu lock
instead of the slots lock allows KVM to copy the dirty bitmap for
multiple memslots in parallel.

Userspace can take advantage of this by creating multiple memslots and
calling GET_DIRTY_LOG on all of them at the same time, reducing the
dirty log collection time.

For VM live migration, the final dirty memory state can only be
collected after the VM has been paused (blackout). We can resume the VM
on the target host without this bitmap, but doing so requires the
post-copy implementation to assume that nothing is clean; this is very
slow. By being able to receive the bitmap quicker, VM responsiveness
improves dramatically.

On 12TiB Cascade Lake hosts, we observe GET_DIRTY_LOG times of about
25-40ms for each memslot when splitting the memslots 8 ways. This patch
reduces the total wall time spent calling GET_DIRTY_LOG from ~300ms to
~40ms. This means that the dirty log can be transferred to the target
~250ms faster, which is a significant responsiveness improvement. It
takes about 800ms to send the bitmap to the target today, so the 250ms
improvement represents a ~20% reduction in total time spent without the
dirty bitmap.

The bits that must be safe are:
1. The copy_to_user() to store the bitmap
2. kvm_arch_sync_dirty_log()

(1) is trivially safe.

(2) kvm_arch_sync_dirty_log() is non-trivially implemented for x86 and
s390. s390 does not set KVM_GENERIC_DIRTYLOG_READ_PROTECT, so the
optimization here does not apply. On x86, parallelization is safe.
The extra vCPU kicks that come from having more memslots should not be
an issue for the final dirty logging pass (the one I care about most
here), as vCPUs will have been kicked out to userspace at that point.

$ ./dirty_log_perf_test -x 8 -b 512G -s anonymous_hugetlb_1gb # serial
Iteration 1 get dirty log time: 0.004699057s
Iteration 2 get dirty log time: 0.003918316s
Iteration 3 get dirty log time: 0.003903790s
Iteration 4 get dirty log time: 0.003944732s
Iteration 5 get dirty log time: 0.003885857s

$ ./dirty_log_perf_test -x 8 -b 512G -s anonymous_hugetlb_1gb # parallel
Iteration 1 get dirty log time: 0.002352174s
Iteration 2 get dirty log time: 0.001064265s
Iteration 3 get dirty log time: 0.001102144s
Iteration 4 get dirty log time: 0.000960649s
Iteration 5 get dirty log time: 0.000972533s

So with 8 memslots, we get about a 4x reduction on this platform
(Skylake).

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_dirty_ring.h |  4 +-
 virt/kvm/dirty_ring.c          | 11 +++++-
 virt/kvm/kvm_main.c            | 68 +++++++++++++++++++++++-----------
 3 files changed, 58 insertions(+), 25 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index eb10d87adf7d..b7d18abec4d0 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -37,7 +37,7 @@ static inline u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 	return 0;
 }
 
-static inline bool kvm_use_dirty_bitmap(struct kvm *kvm)
+static inline bool kvm_use_dirty_bitmap(struct kvm *kvm, bool shared)
 {
 	return true;
 }
@@ -73,7 +73,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 int kvm_cpu_dirty_log_size(struct kvm *kvm);
-bool kvm_use_dirty_bitmap(struct kvm *kvm);
+bool kvm_use_dirty_bitmap(struct kvm *kvm, bool shared);
 bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm);
 u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm);
 int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring,
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 02bc6b00d76c..6662c302a3fa 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -21,9 +21,16 @@ u32 kvm_dirty_ring_get_rsvd_entries(struct kvm *kvm)
 	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size(kvm);
 }
 
-bool kvm_use_dirty_bitmap(struct kvm *kvm)
+bool kvm_use_dirty_bitmap(struct kvm *kvm, bool shared)
 {
-	lockdep_assert_held(&kvm->slots_lock);
+	if (shared)
+		/*
+		 * In the shared mode, racing with dirty log mode changes is
+		 * tolerated.
+		 */
+		lockdep_assert_held(&kvm->srcu);
+	else
+		lockdep_assert_held(&kvm->slots_lock);
 
 	return !kvm->dirty_ring_size || kvm->dirty_ring_with_bitmap;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 18f29ef93543..bb1ec5556d76 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1687,7 +1687,7 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 			new->dirty_bitmap = NULL;
 		else if (old && old->dirty_bitmap)
 			new->dirty_bitmap = old->dirty_bitmap;
-		else if (kvm_use_dirty_bitmap(kvm)) {
+		else if (kvm_use_dirty_bitmap(kvm, false)) {
 			r = kvm_alloc_dirty_bitmap(new);
 			if (r)
 				return r;
@@ -2162,7 +2162,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long any = 0;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (!kvm_use_dirty_bitmap(kvm))
+	if (!kvm_use_dirty_bitmap(kvm, false))
 		return -ENXIO;
 
 	*memslot = NULL;
@@ -2216,7 +2216,8 @@ EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
  * exiting to userspace will be logged for the next call.
  *
  */
-static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
+static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log,
+				     bool protect)
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
@@ -2224,10 +2225,9 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long n;
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
-	bool flush;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (!kvm_use_dirty_bitmap(kvm))
+	if (!kvm_use_dirty_bitmap(kvm, !protect))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;
@@ -2242,21 +2242,30 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	dirty_bitmap = memslot->dirty_bitmap;
 
+	if (protect)
+		lockdep_assert_held(&kvm->slots_lock);
+	else
+		lockdep_assert_held(&kvm->srcu);
+	/*
+	 * kvm_arch_sync_dirty_log() must be safe to call with either kvm->srcu
+	 * held OR the slots lock held.
+	 */
 	kvm_arch_sync_dirty_log(kvm, memslot);
 
 	n = kvm_dirty_bitmap_bytes(memslot);
-	flush = false;
-	if (kvm->manual_dirty_log_protect) {
+	if (!protect) {
 		/*
-		 * Unlike kvm_get_dirty_log, we always return false in *flush,
-		 * because no flush is needed until KVM_CLEAR_DIRTY_LOG.  There
-		 * is some code duplication between this function and
-		 * kvm_get_dirty_log, but hopefully all architecture
-		 * transition to kvm_get_dirty_log_protect and kvm_get_dirty_log
-		 * can be eliminated.
+		 * Unlike kvm_get_dirty_log, we never flush, because no flush is
+		 * needed until KVM_CLEAR_DIRTY_LOG.  There is some code
+		 * duplication between this function and kvm_get_dirty_log, but
+		 * hopefully all architecture transition to
+		 * kvm_get_dirty_log_protect and kvm_get_dirty_log can be
+		 * eliminated.
 		 */
 		dirty_bitmap_buffer = dirty_bitmap;
 	} else {
+		bool flush;
+
 		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
 		memset(dirty_bitmap_buffer, 0, n);
 
@@ -2277,10 +2286,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 								offset, mask);
 		}
 		KVM_MMU_UNLOCK(kvm);
-	}
 
-	if (flush)
-		kvm_flush_remote_tlbs_memslot(kvm, memslot);
+		if (flush)
+			kvm_flush_remote_tlbs_memslot(kvm, memslot);
+	}
 
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		return -EFAULT;
@@ -2310,13 +2319,30 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 static int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				      struct kvm_dirty_log *log)
 {
-	int r;
+	bool protect;
+	int r, idx;
 
-	mutex_lock(&kvm->slots_lock);
+	/*
+	 * Only protect if manual protection isn't enabled.
+	 */
+	protect = !kvm->manual_dirty_log_protect;
 
-	r = kvm_get_dirty_log_protect(kvm, log);
+	/*
+	 * If we are only collecting the dlrty log and not clearing it,
+	 * the srcu lock is sufficient.
+	 */
+	if (protect)
+		mutex_lock(&kvm->slots_lock);
+	else
+		idx = srcu_read_lock(&kvm->srcu);
+
+	r = kvm_get_dirty_log_protect(kvm, log, protect);
+
+	if (protect)
+		mutex_unlock(&kvm->slots_lock);
+	else
+		srcu_read_unlock(&kvm->srcu, idx);
 
-	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -2339,7 +2365,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	bool flush;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
-	if (!kvm_use_dirty_bitmap(kvm))
+	if (!kvm_use_dirty_bitmap(kvm, false))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;

base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.51.0.618.g983fd99d29-goog


