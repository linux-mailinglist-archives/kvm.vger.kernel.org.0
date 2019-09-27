Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92894C03E7
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 13:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfI0LPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 07:15:51 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39851 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfI0LPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 07:15:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so5742718wml.4;
        Fri, 27 Sep 2019 04:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t6GKWk10SkA1KjsImI2OSEARlm/dqk+IOcuAz8AZeOE=;
        b=tghHbK7ZlAi5aohh+D6j7HzrMUogf1wWotzAml6VuA4i9EAjAAQ55hHA7/Dl2FIgg0
         ZhON54m0TcXUq8SPEaqBvVKM+RQ2CbkqVWOfxrIkFwx/tJlOWlw9Jk5eccbwESbjo7We
         FoNYP5P+WPk0YD3XQEcnU1T5UHFuIzk2mAJAAJ0uXVEqwT4bExE9bcR8kyubuMIrbFNJ
         irWj6D3nOGdLb4sdownRAT9EQi0bdrFS1vtrF+dMTZRSYq+OJxhwKj1hg7bQ+Kz2wpuf
         7a4i7UdXFPJ/fBYlOicF0aoMUZ/zdp4+GQ95kxJQ78GoC7PLcko0z8OEGQPSwIq6pItt
         JHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=t6GKWk10SkA1KjsImI2OSEARlm/dqk+IOcuAz8AZeOE=;
        b=Ktc+jvKXzmf1kyZbWB+T29APMyTfV7O0Ud7NumcycCTZovOfE7FLLbByC4c/cB2FDE
         402hY8IWkxWB+quixXi5i0WkJxt5E+KeYAfYM8TutAu5AV84Y/pQkQAegLCOD76xy7wr
         17At8jQZwXr0YkK2uXRF6tLnqoOln7FrX6g6Dh0hcX8E36T/Rbk48wFxsRdApBKPbDBp
         ywWv4F8hYblhyaEI7Yyu/DtHICNqi8V0Q5yJDaamFnjfZGKYwP9hjoZx+EhahALeTJV3
         hgiT4Cf/ZDhS6LR9MzxZlEo/p3yT95mHYIL9+oTK64Go7BULZk+6vAC78aP5VLqVVRkn
         5WJQ==
X-Gm-Message-State: APjAAAWXZTPG4j0VFokgBw3ly0TlO2g1rVnwOouO5SaOpE/RnS0vp5+E
        cPC0Wm/3vCq4LZo7kqQpYfsesT5m
X-Google-Smtp-Source: APXvYqyOz9S1L/GzjXdgBlPZ9lojqo+smdIw+YQ1V+kd+iv9rYPfAso3DfSR9G73ARTCviuhr0BzIg==
X-Received: by 2002:a7b:c0d4:: with SMTP id s20mr7045183wmh.101.1569582947506;
        Fri, 27 Sep 2019 04:15:47 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r28sm2913848wrr.94.2019.09.27.04.15.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 04:15:46 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 1/3] KVM: x86: assign two bits to track SPTE kinds
Date:   Fri, 27 Sep 2019 13:15:41 +0200
Message-Id: <1569582943-13476-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
References: <1569582943-13476-1-git-send-email-pbonzini@redhat.com>
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

Reviewed-by: Junaid Shahid <junaids@google.com>
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


