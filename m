Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3220BBF774
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 19:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfIZRSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 13:18:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36926 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfIZRSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 13:18:33 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so3676057wro.4;
        Thu, 26 Sep 2019 10:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GkS5kuygwejg7PDcUIWyOZOfFuOcNn5PfD7h7RT01L8=;
        b=hc4dBRiR+3MmRXD2YSP7YYzYvRBEAnPNowN/puMUP1el9LVeDWcq967Jr0fVUCVshq
         93IAV5lc2ccJzqvpWXtUn5sheJLkI/RnfIbevezrSMAq/XNR37NJ6aaBhJ+t8SWc0sAI
         +9qVLstrNGSRxd8EXlK8qXcOWpbc/xrJe65m/fgY5eHBNjLqFciqSaYK+aixBOKKS3Wv
         1W00G87OZ3xCgzezwbzDkiZfyXCNrtTnVdk+NhDSDT6Pq1SmtFmbIlSyz9iFQsjymMLR
         FEoDkZkWJ2BtJ/mzXBKw25oYu4aHDgkAn6Sq8EBDD25wMsl4/LuYuz87uZegs2DrhCrG
         XFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=GkS5kuygwejg7PDcUIWyOZOfFuOcNn5PfD7h7RT01L8=;
        b=Hivn8XF2eijKGk25llm28AeXObGFByHl3izo2EpaffhIrwMNXY4JxUiqfhEofbywnI
         oASgGc3t/Y2ybhDlI1Zj++v7LAMCXiEF8nB5ez82nJVhBG5bmkPV4uatIXb3EK+Zrsnx
         r7oIiW0vmKAO8tpjn+HD0E3t/l493Ips75/BSgNhejH0iXCF1yetBksL+eAnsICjEXV7
         OnZVUlcUHcbgm/gY/NYvj2kDEd+YCupYpkMQ7TVIaep8FZEuc/0OldXOebVBtDK+gdY8
         h4JWn9MUQxlLnHJ4D/bNIGiYry1ibglgreA6ViHqjl+1BIxlR3iDV3vxwPyrp7xx9zjQ
         T1nw==
X-Gm-Message-State: APjAAAX/P+rs8B/pv34AwDdOW9pjZhYtKu9ZE4b4n/BTStpCarMjMoTL
        8RovfqMfsJpi9IM+wmeikxflE7Bt
X-Google-Smtp-Source: APXvYqyalDAeXllKtzEFt9yvgqyJ7wKa7qILmmc3n0LyiYfUMGmBIHAkg/Gcn9RFmXVLspBWL7Opog==
X-Received: by 2002:a5d:42cb:: with SMTP id t11mr3658891wrr.99.1569518309883;
        Thu, 26 Sep 2019 10:18:29 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v4sm4792782wrg.56.2019.09.26.10.18.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 10:18:29 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH 1/3] KVM: x86: assign two bits to track SPTE kinds
Date:   Thu, 26 Sep 2019 19:18:24 +0200
Message-Id: <1569518306-46567-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
References: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we are overloading SPTE_SPECIAL_MASK to mean both
"A/D bits unavailable" and MMIO, where the difference between the
two is determined by mio_mask and mmio_value.

However, the next patch will need two bits to distinguish
availability of A/D bits from write protection.  So, while at
it give MMIO its own bit pattern, and move the two bits from
bit 62 to bits 52..53 since Intel is allocating EPT page table
bits from the top.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 -------
 arch/x86/kvm/mmu.c              | 28 ++++++++++++++++++----------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 23edf56cf577..50eb430b0ad8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -219,13 +219,6 @@ enum {
 				 PFERR_WRITE_MASK |		\
 				 PFERR_PRESENT_MASK)
 
-/*
- * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
- * Access Tracking SPTEs. We use bit 62 instead of bit 63 to avoid conflicting
- * with the SVE bit in EPT PTEs.
- */
-#define SPTE_SPECIAL_MASK (1ULL << 62)
-
 /* apic attention bits */
 #define KVM_APIC_CHECK_VAPIC	0
 /*
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5269aa057dfa..bac8d228d82b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -83,7 +83,16 @@ enum {
 #define PTE_PREFETCH_NUM		8
 
 #define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 52
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+
+/*
+ * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
+ * Access Tracking SPTEs.
+ */
+#define SPTE_SPECIAL_MASK (3ULL << 52)
+#define SPTE_AD_ENABLED_MASK (0ULL << 52)
+#define SPTE_AD_DISABLED_MASK (1ULL << 52)
+#define SPTE_MMIO_MASK (3ULL << 52)
 
 #define PT64_LEVEL_BITS 9
 
@@ -219,12 +228,11 @@ struct kvm_shadow_walk_iterator {
 static u64 __read_mostly shadow_me_mask;
 
 /*
- * SPTEs used by MMUs without A/D bits are marked with shadow_acc_track_value.
- * Non-present SPTEs with shadow_acc_track_value set are in place for access
- * tracking.
+ * SPTEs used by MMUs without A/D bits are marked with SPTE_AD_DISABLED_MASK;
+ * shadow_acc_track_mask is the set of bits to be cleared in non-accessed
+ * pages.
  */
 static u64 __read_mostly shadow_acc_track_mask;
-static const u64 shadow_acc_track_value = SPTE_SPECIAL_MASK;
 
 /*
  * The mask/shift to use for saving the original R/X bits when marking the PTE
@@ -304,7 +312,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	BUG_ON((mmio_mask & mmio_value) != mmio_value);
-	shadow_mmio_value = mmio_value | SPTE_SPECIAL_MASK;
+	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
 	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
 	shadow_mmio_access_mask = access_mask;
 }
@@ -323,7 +331,7 @@ static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 static inline bool spte_ad_enabled(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
-	return !(spte & shadow_acc_track_value);
+	return (spte & SPTE_SPECIAL_MASK) == SPTE_AD_ENABLED_MASK;
 }
 
 static inline u64 spte_shadow_accessed_mask(u64 spte)
@@ -461,7 +469,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 {
 	BUG_ON(!dirty_mask != !accessed_mask);
 	BUG_ON(!accessed_mask && !acc_track_mask);
-	BUG_ON(acc_track_mask & shadow_acc_track_value);
+	BUG_ON(acc_track_mask & SPTE_SPECIAL_MASK);
 
 	shadow_user_mask = user_mask;
 	shadow_accessed_mask = accessed_mask;
@@ -2622,7 +2630,7 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
 
 	if (sp_ad_disabled(sp))
-		spte |= shadow_acc_track_value;
+		spte |= SPTE_AD_DISABLED_MASK;
 	else
 		spte |= shadow_accessed_mask;
 
@@ -2968,7 +2976,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	sp = page_header(__pa(sptep));
 	if (sp_ad_disabled(sp))
-		spte |= shadow_acc_track_value;
+		spte |= SPTE_AD_DISABLED_MASK;
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
-- 
1.8.3.1


