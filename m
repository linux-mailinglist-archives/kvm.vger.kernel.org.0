Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3919EBFBE0
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbfIZXTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:33 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:56643 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbfIZXTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:32 -0400
Received: by mail-qt1-f201.google.com with SMTP id m6so3975547qtk.23
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LsnPdTp5GaF/lyahKH1vXf0L/46JuHXj66N8OEChvcw=;
        b=UHT5p+/fYiB2mVGalDD3QamKeFpexD5xPdbGirmdxGCOFk1bHht+I2nMePtIJT4ACs
         UMfr9YhOfJ7YAPrSnxfyoksMvT6Yf9Etr9DixePSzgZ0zjHle7T3xyz8iK4tI/ksG+aT
         lfxpZMzNhwQOy9H4kxJAgybMqxirsaQb6N+ocPVv4QThIHl7bRUo+YY31RyCplQp9jCW
         LynlaxfM2B+buYzKFnQovEcu6kgxw5SJN+cAp0/LSZaDD4aCqfh1/+ft3tSAy+SD18MQ
         AGP9ZWKzRRGw1p5JCfQ+BGhZ81YZwVPfJKxGPQhEMTlpewBAjLgNi5HNL3ClEwk/eb9h
         eQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LsnPdTp5GaF/lyahKH1vXf0L/46JuHXj66N8OEChvcw=;
        b=CUyQHlITUuqnXCeTj9PbnzB0Pw+WUKreZMFR5HSfuhYbiY6bTjr06xk3vhlZj5c0HY
         s9Nf3ibPj4v/ju/yDGIZIeMnJWAi53SjdISv2jWMNeOgvN4taIWbYf6SkW5dDaMW0XxH
         dERZu/K0DrSzb1r72d88I1C8c6EL4I1rDcMwSsu/BnW7+qFqNAZUehtYJBfVzNevv/nT
         GMCl3hVxOxg1ptoNp6kcl2UDNP/ypcB7mxp0rNuJbXWRCLgSuzBbSXAZJd33UfpcrBAk
         VzoKvRsq07aHhuiK52BeLudYfSBgrMD30Gyj+z07U7jTgTOM7peqqwKREBKtOwEoD/nr
         xKzw==
X-Gm-Message-State: APjAAAU8A3jfP9nERsO74tUzDWy4oldOcxbwQF1hnSnNivUQftqi2E7B
        1Lfoq4nb0WxQQ+HBHITxxeFfcyNRYJ+zR70c7EU1QrsANXDS4oc10qpbqqlv9P/cmVb7E7Vi/c5
        6m6b1PIc1j76g2fHU2X9BfsUESzVX1h5eev0Wy8b9TWwMWlKv69HSEMIwKVXb
X-Google-Smtp-Source: APXvYqwg4RzLJ/Y1SXOhSKcCwkH8r+t5GE/AuTwr5grm7ZIMxbjSFivGDBODkaxkwod3AB/GQYOtNclFsa2G
X-Received: by 2002:ad4:42d2:: with SMTP id f18mr5314963qvr.52.1569539969639;
 Thu, 26 Sep 2019 16:19:29 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:23 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-28-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 27/28] kvm: mmu: Lazily allocate rmap when direct MMU is enabled
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the MMU is in pure direct mode, it uses a paging structure walk
iterator and does not require the rmap. The rmap requires 8 bytes for
every PTE that could be used to map guest memory. It is an expensive data
strucutre at ~0.2% of the size of guest memory. Delay allocating the rmap
until the MMU is no longer in pure direct mode. This could be caused,
for example, by the guest launching a nested, L2 VM.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 15 ++++++++++
 arch/x86/kvm/x86.c | 72 ++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h |  2 ++
 3 files changed, 83 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e0f35da0d1027..72c2289132c43 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5228,8 +5228,23 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	u64 pdptr, pm_mask;
 	gfn_t root_gfn, root_cr3;
 	int i;
+	int r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
+	if (vcpu->kvm->arch.pure_direct_mmu) {
+		write_unlock(&vcpu->kvm->mmu_lock);
+		/*
+		 * If this is the first time a VCPU has allocated shadow roots
+		 * and the direct MMU is enabled on this VM, it will need to
+		 * allocate rmaps for all its memslots. If the rmaps are already
+		 * allocated, this call will have no effect.
+		 */
+		r = kvm_allocate_rmaps(vcpu->kvm);
+		if (r < 0)
+			return r;
+		write_lock(&vcpu->kvm->mmu_lock);
+	}
+
 	vcpu->kvm->arch.pure_direct_mmu = false;
 	write_unlock(&vcpu->kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index edd7d7bece2fe..566521f956425 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9615,14 +9615,21 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	kvm_page_track_free_memslot(free, dont);
 }
 
-int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
-			    unsigned long npages)
+static int allocate_memslot_rmap(struct kvm *kvm,
+				   struct kvm_memory_slot *slot,
+				   unsigned long npages)
 {
 	int i;
 
+	/*
+	 * rmaps are allocated all-or-nothing under the slots
+	 * lock, so we only need to check that the first rmap
+	 * has been allocated.
+	 */
+	if (slot->arch.rmap[0])
+		return 0;
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		struct kvm_lpage_info *linfo;
-		unsigned long ugfn;
 		int lpages;
 		int level = i + 1;
 
@@ -9634,8 +9641,61 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 				 GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i])
 			goto out_free;
-		if (i == 0)
-			continue;
+	}
+	return 0;
+
+out_free:
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		kvfree(slot->arch.rmap[i]);
+		slot->arch.rmap[i] = NULL;
+	}
+	return -ENOMEM;
+}
+
+int kvm_allocate_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0;
+	int i;
+
+	mutex_lock(&kvm->slots_lock);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			r = allocate_memslot_rmap(kvm, slot, slot->npages);
+			if (r < 0)
+				break;
+		}
+	}
+	mutex_unlock(&kvm->slots_lock);
+	return r;
+}
+
+int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    unsigned long npages)
+{
+	int i;
+	int r;
+
+	/* Set the rmap pointer for each level to NULL */
+	memset(slot->arch.rmap, 0,
+	       ARRAY_SIZE(slot->arch.rmap) * sizeof(*slot->arch.rmap));
+
+	if (!kvm->arch.pure_direct_mmu) {
+		r = allocate_memslot_rmap(kvm, slot, npages);
+		if (r < 0)
+			return r;
+	}
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
+		struct kvm_lpage_info *linfo;
+		unsigned long ugfn;
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + npages - 1,
+				      slot->base_gfn, level) + 1;
 
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b6..91bfbfd2c58d4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -369,4 +369,6 @@ static inline bool kvm_pat_valid(u64 data)
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 
+int kvm_allocate_rmaps(struct kvm *kvm);
+
 #endif
-- 
2.23.0.444.g18eeb5a265-goog

