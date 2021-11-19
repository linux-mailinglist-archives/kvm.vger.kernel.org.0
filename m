Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882B54579D5
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhKTACG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236249AbhKTABj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963B4C06175D
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:31 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n6-20020a17090a670600b001a9647fd1aaso7470968pjj.1
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pkWaF7bQP6gucghx+x3mEjN+bvfdj/rHkNl/xx3z+d8=;
        b=bAz8AOc/hZUuzNMBOzzmxr0xbPUPI6Q9V5CmnFRWmbdg/O4erZO/M/GRxEPp6v7/AY
         6mIvJNpFIqefvB8veWA9J1SYzi/tE94oR0k/wuzQSSXS1xeMnPYRaMoq5Q91VT4oVFBz
         O5+u+plrt8PBdCepbxKrLbBgGe2Vcgyq/hw40KWYKzH1EZD37fUxyE6VX32UAes5uTqY
         n9DKrwmXYdmAE6c4lK3qWkoWpHq/S6r3DGvA1DPw5J9D49VUtvnXldPx0G21TLHZtaBo
         QipCeUjSvs3/7t2JgEDK8HpQSjHI0cmL1Fmoxv9xcczRqlnjffJoPhaIlOvWu/lNAFfH
         IsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pkWaF7bQP6gucghx+x3mEjN+bvfdj/rHkNl/xx3z+d8=;
        b=B2GpX1eDqxvaOV737VYdAhHMdHIcASfqCxAX3ONyLFcweyB//oMUhhDHMqHIb+MVNv
         iYD6P8BimyY/s/jB36U/Mixlob/0Tam+XJju3fgNFv/7a+kVeF29gvZp8f/lxZkCHL5+
         QUbJiSDk/5cuGlSlfb/Sd5QfnFY7qFB/7qv6r6gLgacAXDrpVf4Z5BA/aRerAhwomnrp
         ZxdFceRPdtTFQuD2cxxi/5PN4dl7t0teTbgxL55fNtvtLiq3jxRGMXm/Vnv78TiqzAUB
         D/GFvQKfmVGNUP9Juuoxi0Qe1EyAvljrgB+gFg6t9YKWDVFxL0hnKE45x6nbpY583WD/
         Wy4A==
X-Gm-Message-State: AOAM533DWGxH0uncrWkFraVzXh8BofMJYccM3Cqx3whF9klZTX1p0/XZ
        c5KAdJC37OfUixmnu5KZKmszQSBCsUUezw==
X-Google-Smtp-Source: ABdhPJxez272G3wG/hupmmPHs5bDdzSEpf3O30ohlyIH3Jz4ZmCj+aZRQ/W++MAypps8SLIS1u8CxvFdl3mkeg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1b4a:: with SMTP id
 nv10mr4710359pjb.118.1637366311056; Fri, 19 Nov 2021 15:58:31 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:57 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using initially-all-set, large pages are not write-protected when
dirty logging is enabled on the memslot. Instead they are
write-protected once userspace invoked CLEAR_DIRTY_LOG for the first
time, and only for the specific sub-region of the memslot that userspace
whishes to clear.

Enhance CLEAR_DIRTY_LOG to also try to split large pages prior to
write-protecting to avoid causing write-protection faults on vCPU
threads. This also allows userspace to smear the cost of large page
splitting across multiple ioctls rather than splitting the entire
memslot when not using initially-all-set.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/mmu/mmu.c          | 30 ++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 432a4df817ec..6b5bf99f57af 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1591,6 +1591,10 @@ void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      const struct kvm_memory_slot *memslot,
 				      int start_level);
+void kvm_mmu_try_split_large_pages(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot,
+				   u64 start, u64 end,
+				   int target_level);
 void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
 					const struct kvm_memory_slot *memslot,
 					int target_level);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6768ef9c0891..4e78ef2dd352 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1448,6 +1448,12 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
 		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
 
+		/*
+		 * Try to proactively split any large pages down to 4KB so that
+		 * vCPUs don't have to take write-protection faults.
+		 */
+		kvm_mmu_try_split_large_pages(kvm, slot, start, end, PG_LEVEL_4K);
+
 		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
 
 		/* Cross two large pages? */
@@ -5880,21 +5886,17 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot,
-					int target_level)
+void kvm_mmu_try_split_large_pages(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot,
+				   u64 start, u64 end,
+				   int target_level)
 {
-	u64 start, end;
-
 	if (!is_tdp_mmu_enabled(kvm))
 		return;
 
 	if (mmu_topup_split_caches(kvm))
 		return;
 
-	start = memslot->base_gfn;
-	end = start + memslot->npages;
-
 	read_lock(&kvm->mmu_lock);
 	kvm_tdp_mmu_try_split_large_pages(kvm, memslot, start, end, target_level);
 	read_unlock(&kvm->mmu_lock);
@@ -5902,6 +5904,18 @@ void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
 	mmu_free_split_caches(kvm);
 }
 
+void kvm_mmu_slot_try_split_large_pages(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot,
+					int target_level)
+{
+	u64 start, end;
+
+	start = memslot->base_gfn;
+	end = start + memslot->npages;
+
+	kvm_mmu_try_split_large_pages(kvm, memslot, start, end, target_level);
+}
+
 static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 					 struct kvm_rmap_head *rmap_head,
 					 const struct kvm_memory_slot *slot)
-- 
2.34.0.rc2.393.gf8c9666880-goog

