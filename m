Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8E473837
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbhLMW7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244116AbhLMW7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:39 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA82C061756
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:39 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id a8-20020a63cd48000000b00330605939c0so9724322pgj.5
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G1lTebD+2U0O4p131ZNw2bZ43siPK30QECOBusO54QM=;
        b=r1IVQAoNwPe/u5vtL4RoKMuhMWHrGR3OYMY5tjiyd77lkplG8sPbDT7Ar9J4zeJBLJ
         +0fM970c3aPeKunDiTxo6eL2Fa4O8mM5i33jjOTmgmxvhXlyLgX9BbMOU5jG6KSzlfQo
         3r41zJFyiKZ5xo8vzOAVWMnaZJJEMIprubVlI/z17VNrx3bijvouALcEc6vWjvDspH4n
         MY1BGL6QS4vL9xf8RUzgkn2NfrFy4yTj2p/K3awA2oLT43fDOXzu9eehLWVU9XB+Zyid
         3cKo6X0gw+AipwwlHwf0mK8TLuLYEvap6nht+akt4qtOakE4wisWyNKBPTByFWvfaLnS
         Uruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G1lTebD+2U0O4p131ZNw2bZ43siPK30QECOBusO54QM=;
        b=aGsA4wWHrEJau+jY5ZVlHgrFzfHN+pZ1LZqQZmauvlfZt4v5AFWa0sRtyNX9Wuse+6
         AwHeROE0BF8OPEnxJELbrvmKXIvMIc8j0tMoGvwdthIvEx4rE2Th3bXXgmViKabCVAXW
         1Bx7QfXVJIXPp4GCewlzpC88amEWWFOuoT8jdSVm1gDQKUMStVqTdaUzAJCAvyxQ7ZG2
         +wKjJeD1No0c97ILGUnNItnGfHhiupQyku4FkjHH8hrXCgMtNDNF1O8kC9Oud6mk/Vrt
         YWucTH9RIw0NOW7iCcwpep9gSzzFhjDv4Khrm9OY0+r3BJEHc8KZ22kmwibTfdgbEg4m
         rsiA==
X-Gm-Message-State: AOAM533sWlgrwWG70nh1QGxj/dBP135F4fiuCEFVnAxRv4cMxwvvDvP1
        Qp3U0DpAu69FBj1Qno+ae/DdVDYyvCsUTA==
X-Google-Smtp-Source: ABdhPJxyFYy/gzEsRWxnsbvnhYk8O728htIICky2J8vlpbm6pk0/fLOYO6yzngEf5Q7uldshTAXkoCpYNwWiUg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:26e3:b0:49f:c0ca:850e with SMTP
 id p35-20020a056a0026e300b0049fc0ca850emr1068213pfw.4.1639436379236; Mon, 13
 Dec 2021 14:59:39 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:16 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 11/13] KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using initially-all-set, huge pages are not write-protected when
dirty logging is enabled on the memslot. Instead they are
write-protected once userspace invokes CLEAR_DIRTY_LOG for the first
time and only for the specific sub-region being cleared.

Enhance CLEAR_DIRTY_LOG to also try to split huge pages prior to
write-protecting to avoid causing write-protection faults on vCPU
threads. This also allows userspace to smear the cost of huge page
splitting across multiple ioctls rather than splitting the entire
memslot when not using initially-all-set.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              |  2 +-
 arch/x86/kvm/x86.h              |  2 ++
 4 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a507109e886..3e537e261562 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1576,6 +1576,10 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 				       const struct kvm_memory_slot *memslot,
 				       int target_level);
+void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
+				  const struct kvm_memory_slot *memslot,
+				  u64 start, u64 end,
+				  int target_level);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c9e5fe290714..55640d73df5a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1362,6 +1362,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
 		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
 
+		/*
+		 * Try to proactively split any huge pages down to 4KB so that
+		 * vCPUs don't have to take write-protection faults.
+		 *
+		 * Drop the MMU lock since huge page splitting uses its own
+		 * locking scheme and does not require the write lock in all
+		 * cases.
+		 */
+		if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging)) {
+			write_unlock(&kvm->mmu_lock);
+			kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
+			write_lock(&kvm->mmu_lock);
+		}
+
 		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
 
 		/* Cross two large pages? */
@@ -5811,13 +5825,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
-				       const struct kvm_memory_slot *memslot,
-				       int target_level)
+void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot,
+				   u64 start, u64 end,
+				   int target_level)
 {
-	u64 start = memslot->base_gfn;
-	u64 end = start + memslot->npages;
-
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
@@ -5825,6 +5837,18 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
+void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot,
+					int target_level)
+{
+	u64 start, end;
+
+	start = memslot->base_gfn;
+	end = start + memslot->npages;
+
+	kvm_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level);
+}
+
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 					 struct kvm_rmap_head *rmap_head,
 					 const struct kvm_memory_slot *slot)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb5592bf2eee..e27a3d6e3978 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -187,7 +187,7 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
-static bool __read_mostly eagerly_split_huge_pages_for_dirty_logging = true;
+bool __read_mostly eagerly_split_huge_pages_for_dirty_logging = true;
 module_param(eagerly_split_huge_pages_for_dirty_logging, bool, 0644);
 
 /*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..825e47451875 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -352,6 +352,8 @@ extern int pi_inject_timer;
 
 extern bool report_ignored_msrs;
 
+extern bool eagerly_split_huge_pages_for_dirty_logging;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
-- 
2.34.1.173.g76aa8bc2d0-goog

