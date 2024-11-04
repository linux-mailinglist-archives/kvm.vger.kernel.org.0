Return-Path: <kvm+bounces-30458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5889BAE6D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:45:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF2011C218A7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B9A1AB517;
	Mon,  4 Nov 2024 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U3mXCPQN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB76C1422D4;
	Mon,  4 Nov 2024 08:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730709930; cv=none; b=Xo4JrVVyG6oUpQnRusOsc82WZzlgOh3TRnIxFCWcqgcDkQMuRNoAc/kuBKLvwQEKjYfi0/G8NP3U5YE2sLZ1xtZuL011hEFO4htQKzcVj311RmpTcDfI767chhkdztWXTDKVBS4s5CE0i1N9DG6BVxBI4eWZaF0WlDMkWC26lVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730709930; c=relaxed/simple;
	bh=2/5Ky+jC5gjVZXuR/smrXJRvzH5WRkbXn2obO6nTz5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjFK+5GYy9BMmsFKWKXjsI9RE5mUEz7kQVmy4zD6iBdadwdGkEUEEf6PeBYNeHca6gomragCywbcNaV2aGH/QkiiRacn8TPZsAfzdkKtuHj/yXbkRYgA/lrCBRq8oYdW8wql/+isL3D9bIU3Xpyvs+4ozkeRPoR9X5UO1wHPix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3mXCPQN; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730709929; x=1762245929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2/5Ky+jC5gjVZXuR/smrXJRvzH5WRkbXn2obO6nTz5w=;
  b=U3mXCPQNyScr4NgdPruGnBK7MiDMwzhcgMDkLjcAy23cTO+OHvb16Q49
   hIqRrfdQSd6Hg4XExhoObmTj0nlLxE4wg2d3l69DDi619bnmFTyFXMxDi
   iL5uMmAp4JxUZB0F84RDkVho4X+e0yrNd0pvXgf6z2bH6/aD1e2bcgBcw
   /xziyXCbiG5x1gN7u9CDfRQ6GX/+tT07nf878kZTajtZw+5rYjE8sP44g
   DJd5Bl8Pzrv1fd/gPAUJs3Qlt3x/TBUT6u1ZIKicDN23s/4bkKxbrMZRQ
   +3vtQjjzJeFUHRbqT/SnjHNlBMC4DeVMQyrdEpiYtYcA1lvNanzqE3vh4
   g==;
X-CSE-ConnectionGUID: csutf2fCQEqPxAm1m7ZISw==
X-CSE-MsgGUID: dBsrUo0PR0agPPOiijgY+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="29824335"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="29824335"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:45:28 -0800
X-CSE-ConnectionGUID: 5QDdrfw8QH+l0ctJyqaGrA==
X-CSE-MsgGUID: fq6N5rDITgCTh03ASNidTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83473311"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:45:26 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/2] KVM: guest_memfd: Remove RCU-protected attribute from slot->gmem.file
Date: Mon,  4 Nov 2024 16:43:03 +0800
Message-ID: <20241104084303.29909-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241104084137.29855-1-yan.y.zhao@intel.com>
References: <20241104084137.29855-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the RCU-protected attribute from slot->gmem.file. No need to use RCU
primitives rcu_assign_pointer()/synchronize_rcu() to update this pointer.

- slot->gmem.file is updated in 3 places:
  kvm_gmem_bind(), kvm_gmem_unbind(), kvm_gmem_release().
  All of them are protected by kvm->slots_lock.

- slot->gmem.file is read in 2 paths:
  (1) kvm_gmem_populate
        kvm_gmem_get_file
        __kvm_gmem_get_pfn

  (2) kvm_gmem_get_pfn
         kvm_gmem_get_file
         __kvm_gmem_get_pfn

  Path (1) kvm_gmem_populate() requires holding kvm->slots_lock, so
  slot->gmem.file is protected by the kvm->slots_lock in this path.

  Path (2) kvm_gmem_get_pfn() does not require holding kvm->slots_lock.
  However, it's also not guarded by rcu_read_lock() and rcu_read_unlock().
  So synchronize_rcu() in kvm_gmem_unbind()/kvm_gmem_release() actually
  will not wait for the readers in kvm_gmem_get_pfn() due to lack of RCU
  read-side critical section.

  The path (2) kvm_gmem_get_pfn() is safe without RCU protection because:
  a) kvm_gmem_bind() is called on a new memslot, before the memslot is
     visible to kvm_gmem_get_pfn().
  b) kvm->srcu ensures that kvm_gmem_unbind() and freeing of a memslot
     occur after the memslot is no longer visible to kvm_gmem_get_pfn().
  c) get_file_active() ensures that kvm_gmem_get_pfn() will not access the
     stale file if kvm_gmem_release() sets it to NULL.  This is because if
     kvm_gmem_release() occurs before kvm_gmem_get_pfn(), get_file_active()
     will return NULL; if get_file_active() does not return NULL,
     kvm_gmem_release() should not occur until after kvm_gmem_get_pfn()
     releases the file reference.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/guest_memfd.c   | 23 ++++++++++-------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c7e4f8be3e17..3c3088a9e336 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -600,7 +600,7 @@ struct kvm_memory_slot {
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	struct {
-		struct file __rcu *file;
+		struct file *file;
 		pgoff_t pgoff;
 	} gmem;
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 651c2f08df62..9d9bf3d033bd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -267,9 +267,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	filemap_invalidate_lock(inode->i_mapping);
 
 	xa_for_each(&gmem->bindings, index, slot)
-		rcu_assign_pointer(slot->gmem.file, NULL);
-
-	synchronize_rcu();
+		WRITE_ONCE(slot->gmem.file, NULL);
 
 	/*
 	 * All in-flight operations are gone and new bindings can be created.
@@ -298,8 +296,7 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	/*
 	 * Do not return slot->gmem.file if it has already been closed;
 	 * there might be some time between the last fput() and when
-	 * kvm_gmem_release() clears slot->gmem.file, and you do not
-	 * want to spin in the meanwhile.
+	 * kvm_gmem_release() clears slot->gmem.file.
 	 */
 	return get_file_active(&slot->gmem.file);
 }
@@ -510,11 +507,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	/*
-	 * No synchronize_rcu() needed, any in-flight readers are guaranteed to
-	 * be see either a NULL file or this new file, no need for them to go
-	 * away.
+	 * memslots of flag KVM_MEM_GUEST_MEMFD are immutable to change, so
+	 * kvm_gmem_bind() must occur on a new memslot.
+	 * Readers are guaranteed to see this new file.
 	 */
-	rcu_assign_pointer(slot->gmem.file, file);
+	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
 
 	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
@@ -550,8 +547,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 
 	filemap_invalidate_lock(file->f_mapping);
 	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
-	rcu_assign_pointer(slot->gmem.file, NULL);
-	synchronize_rcu();
+	WRITE_ONCE(slot->gmem.file, NULL);
 	filemap_invalidate_unlock(file->f_mapping);
 
 	fput(file);
@@ -563,11 +559,12 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					pgoff_t index, kvm_pfn_t *pfn,
 					bool *is_prepared, int *max_order)
 {
+	struct file *gmem_file = READ_ONCE(slot->gmem.file);
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 
-	if (file != slot->gmem.file) {
-		WARN_ON_ONCE(slot->gmem.file);
+	if (file != gmem_file) {
+		WARN_ON_ONCE(gmem_file);
 		return ERR_PTR(-EFAULT);
 	}
 
-- 
2.43.2


