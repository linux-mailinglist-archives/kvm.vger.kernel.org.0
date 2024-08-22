Return-Path: <kvm+bounces-24810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0E495AE3C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 527D81C225A5
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 06:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D21B13A885;
	Thu, 22 Aug 2024 06:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j1QKaXk7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EB113C3DD
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 06:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724309770; cv=none; b=OvgicJhCzHNTmY3gCmeQLuY+7YCVyAjgjgre20LcQF3tqh0ddeAVWetjOnQzmKhnPfgIUOodkZ04NCbhMS9i2b1SZarhvC8YYBTiAxadONalTVhW0ZJHlVY3bSmVLbPKCD/h0oEGEG/qdUq7i0NrjzPJEuKTj5i2yL3zxQO2OAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724309770; c=relaxed/simple;
	bh=zmY296PjwQeTukeX232uZ4N2lzN/Qy5XgkMD4XdJ/uQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hnpTizIHiEi0q07eJTAJnr2uETp/5/JEBC2J5sswkHGReQq0/KfsX1GXPXtrFWnAKA99ejZ14fXOosvjYpGQGsfpJhEv30EjPmViZUZfKNhW3C44hVOyCqODVNRHkPJvsIvLc+z2QcceCv3cc25T5Ot4V/6iVn20uIboWgjA1CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j1QKaXk7; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3db18102406so287156b6e.1
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 23:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1724309767; x=1724914567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GFDydfkG+agaOlsuZHWg20v17CYJb4VeMMP0Wqz7Dj4=;
        b=j1QKaXk73RK8u+hpUc8AqvDgGW8liQrcMOdufAnO1hV0Tdh/PmKAsLRlkL3WN3FgXy
         0bqxMF6v/VZvChFirImtfbboQXWysLL41qZPKCgVrC921Xn05sGD1o90pxh+04OoVfGu
         Djw3ksfXPPZoVbuG1Alj1lyVu6LZudzjsAY84GMFAS/27BK9HFTokPYvAShbI4yjhOkq
         UR9tZjAyR/v+7aXIiQ7UAFDXsk+jmyj2BFf5eGjkX6yOleaz+kcGfljhJFrjs+On6gyx
         t5rxesM+PBigYJBk0dQx/sbGXjAIj4BInUoxeetg/1oqwieEye86fs1XXUjEmNY6+25M
         2MDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724309767; x=1724914567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GFDydfkG+agaOlsuZHWg20v17CYJb4VeMMP0Wqz7Dj4=;
        b=LxDKOS88vcce6M0yrshCSMXkItp9jTMV6KsPMhH18veCXpL05Ymw2T8TvNKOHRL0JS
         trFaJOC/G/XkmlhNAO7kMGknj7taUSqMcb9k4bOZLax5ylNiMkz4SsWU6IClS/o5AOri
         afAbVwJLCzNcQOPxQ3aUZ2UtsKsn3Wi9no5nsDIek3sJyMsz5x6M9r2IHvdm9v/pAAa1
         SiWgeXNflO2md5Wxt0LdO/X/FIBUXHadLxGhdO8cjQ+q4EG5eTW7UzzkCvVztj1KV7qq
         rrB1jjf+G5RLQwtMsBiNuXBJj8HPlMVd+SQxvFDMmVL3uSgK0Hu0wPBn/7XFtpPf52Dn
         rCRw==
X-Gm-Message-State: AOJu0YzlCnLrFEXtCD+UIeyOxQ62F8R0HfxAlM8brW64PLBzoe3fX8HV
	Z9tZb5CKMIA0ygCUh7zTHh2RHpZsTYZElTPitUfNqzITo1//SYorfQqR6DjT8so=
X-Google-Smtp-Source: AGHT+IFd6nbupeMmch8HYUZLo+nAXaiqmJ1Be/VEMkfQZfY19PJSES7bmK/eG3ZZDnQLO9L42i7OCw==
X-Received: by 2002:a05:6808:3185:b0:3d9:3649:906f with SMTP id 5614622812f47-3de2332620bmr1021309b6e.37.1724309767610;
        Wed, 21 Aug 2024 23:56:07 -0700 (PDT)
Received: from GL4FX4PXWL.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7cd9acbfc09sm678733a12.37.2024.08.21.23.56.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Aug 2024 23:56:07 -0700 (PDT)
From: Peng Zhang <zhangpeng.00@bytedance.com>
To: pbonzini@redhat.com,
	chao.p.peng@linux.intel.com,
	seanjc@google.com,
	Liam.Howlett@oracle.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Peng Zhang <zhangpeng.00@bytedance.com>
Subject: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
Date: Thu, 22 Aug 2024 14:55:44 +0800
Message-Id: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, xarray is used to manage memory attributes. The memory
attributes management here is an interval problem. However, xarray is
not suitable for handling interval problems. It may cause memory waste
and is not efficient. Switching it to maple tree is more elegant. Using
maple tree here has the following three advantages:
1. Less memory overhead.
2. More efficient interval operations.
3. Simpler code.

This is the first user of the maple tree interface mas_find_range(),
and it does not have any test cases yet, so its stability is unclear.

Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
---
 include/linux/kvm_host.h |  5 +++--
 virt/kvm/kvm_main.c      | 47 ++++++++++++++--------------------------
 2 files changed, 19 insertions(+), 33 deletions(-)

I haven't tested this code yet, and I'm not very familiar with kvm, so I'd
be happy if someone could help test it. This is just an RFC now. Any comments
are welcome.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a6b1a63027..9b3351d88d64 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,7 @@
 #include <linux/interval_tree.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/maple_tree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -839,7 +840,7 @@ struct kvm {
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_locks (for writes) and RCU (for reads) */
-	struct xarray mem_attr_array;
+	struct maple_tree mem_attr_mtree;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
@@ -2410,7 +2411,7 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
-	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
+	return xa_to_value(mtree_load(&kvm->mem_attr_mtree, gfn));
 }
 
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..9a99c334f4af 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -10,6 +10,7 @@
  *   Yaniv Kamay  <yaniv@qumranet.com>
  */
 
+#include "linux/maple_tree.h"
 #include <kvm/iodev.h>
 
 #include <linux/kvm_host.h>
@@ -1159,7 +1160,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_init(&kvm->mem_attr_array);
+	mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&kvm->mem_attr_mtree, &kvm->slots_lock);
 #endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
@@ -1356,7 +1358,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	xa_destroy(&kvm->mem_attr_array);
+	mutex_lock(&kvm->slots_lock);
+	__mt_destroy(&kvm->mem_attr_mtree);
+	mutex_unlock(&kvm->slots_lock);
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
@@ -2413,30 +2417,20 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
 bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs)
 {
-	XA_STATE(xas, &kvm->mem_attr_array, start);
-	unsigned long index;
+	MA_STATE(mas, &kvm->mem_attr_mtree, start, start);
 	void *entry;
 
 	mask &= kvm_supported_mem_attributes(kvm);
 	if (attrs & ~mask)
 		return false;
 
-	if (end == start + 1)
-		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
-
 	guard(rcu)();
-	if (!attrs)
-		return !xas_find(&xas, end - 1);
-
-	for (index = start; index < end; index++) {
-		do {
-			entry = xas_next(&xas);
-		} while (xas_retry(&xas, entry));
 
-		if (xas.xa_index != index ||
-		    (xa_to_value(entry) & mask) != attrs)
+	do {
+		entry = mas_find_range(&mas, end - 1);
+		if ((xa_to_value(entry) & mask) != attrs)
 			return false;
-	}
+	} while (mas.last < end - 1);
 
 	return true;
 }
@@ -2524,9 +2518,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		.on_lock = kvm_mmu_invalidate_end,
 		.may_block = true,
 	};
-	unsigned long i;
 	void *entry;
 	int r = 0;
+	MA_STATE(mas, &kvm->mem_attr_mtree, start, end - 1);
 
 	entry = attributes ? xa_mk_value(attributes) : NULL;
 
@@ -2540,20 +2534,11 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	 * Reserve memory ahead of time to avoid having to deal with failures
 	 * partway through setting the new attributes.
 	 */
-	for (i = start; i < end; i++) {
-		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
-		if (r)
-			goto out_unlock;
-	}
-
+	r = mas_preallocate(&mas, entry, GFP_KERNEL_ACCOUNT);
+	if (r)
+		goto out_unlock;
 	kvm_handle_gfn_range(kvm, &pre_set_range);
-
-	for (i = start; i < end; i++) {
-		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
-				    GFP_KERNEL_ACCOUNT));
-		KVM_BUG_ON(r, kvm);
-	}
-
+	mas_store_prealloc(&mas, entry);
 	kvm_handle_gfn_range(kvm, &post_set_range);
 
 out_unlock:
-- 
2.20.1


