Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892F73F92B8
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244149AbhH0DNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCE0C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:46 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id h5-20020a170902704500b00137e251c362so606905plt.10
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cuN0ollxjDV2DaaXoouEXtDeSL4O0HORunjVAJir1EM=;
        b=fPij6UYNMIqXWvZFmfEq5DLfP9i7hwzdhyrY1gE3x9U7gAlV7ObTDdSPres2nM/pUh
         cMtEwrZVK7zG4Lhk/Dr6aCjEXCLbSy4y5u5QV2ZfH8UZv65T9awCCOKZqgQodznszu07
         hEaspyGMb6sTa7QDK7trVC81oGiDvewgQJZR71Ux2eFVKwSAEmzzBLlmCsrrmWUGa1Yx
         w1nmENx0UEjyzWVyhfXpUodztKNUtl9kab1Bu7y4HaLWiibK/WKQxi2u5JG01oJ44rgr
         +CzqKv5MMLDKakgUtB6h0yZIhbi4Zblm0CPBBxyTrib6LllfJQpvHV+vp4fcp6ccL+BH
         sFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cuN0ollxjDV2DaaXoouEXtDeSL4O0HORunjVAJir1EM=;
        b=ITBQM955h9K6ZlPdI9o6Saw18mLeaDs2Lf0bZUwWbVW9CH1CyWaXaTqSyS52Ladyzb
         wCZncU4+Q5LClK3GSUbcRWPqeV8zEhczs1lqtLN1lpI0xyT3WgEc4Tv2+uDb1aw5Q1N8
         Uzdi9liHnYfmnHiQywoMCFiq9f9AXs8Eq6050XizJ02tVAG2o3nzrjT86Dy/wZ102sFh
         aulAxydNXMFESD1/cRh3OOeJuBgbjYLEw/S0H7G50wLIo1GjBtd6n36181/fngE4bMw5
         hiHpGGtbUyjzvFVzgsEv9yzjaUED4ihpH7MEMoCjr51aVyGlPg33R23zI/WPxYoEvwSv
         FTzg==
X-Gm-Message-State: AOAM530ZHsgI7CYx7R5N6t+AuVSlO1NELLEq1CyPmpOgnzf4I5AEi0Sl
        8MqkH34EjMN+3YYdbmScHZCRk63MZl3jNKm1YlB7hOpwQ3WTFxPaDiaj8Hnnx7tdsnGiaLAx/FN
        tm8jnQaCkPCn/wDJlbDBukXrFrUzJbht1xwX96urjAcuaGyYOK4St7YicjGQ2FHpQMJmp
X-Google-Smtp-Source: ABdhPJxc224gwn0ff3V2VKSMQCy0L3Z40ttBYtS4iOxip53RYOh6O/Jm/89BmIAZtZE+E4Kcc2p3HIlKT4vZ5D1L
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:38c9:0:b0:3f2:6ab2:1828 with SMTP
 id f192-20020a6238c9000000b003f26ab21828mr4784538pfa.37.1630033965667; Thu,
 26 Aug 2021 20:12:45 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:17 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-13-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 12/17] x86 AMD SEV: Page table with c-bit
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV introduces c-bit to page table entries. To work with AMD SEV:

   1. c-bit should be set for new page table entries
   2. address calculation should not use c-bit as part of address

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c  | 10 ++++++++++
 lib/x86/amd_sev.h  |  1 +
 lib/x86/asm/page.h | 27 ++++++++++++++++++++++++---
 lib/x86/vm.c       | 18 ++++++++++++++----
 4 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 5498ed6..f5e3585 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -75,3 +75,13 @@ unsigned long long get_amd_sev_c_bit_mask(void)
 		return 0;
 	}
 }
+
+unsigned long long get_amd_sev_addr_upperbound(void)
+{
+	if (amd_sev_enabled()) {
+		return amd_sev_c_bit_pos - 1;
+	} else {
+		/* Default memory upper bound */
+		return PT_ADDR_UPPER_BOUND_DEFAULT;
+	}
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 516d500..2780560 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -39,6 +39,7 @@ bool amd_sev_enabled(void);
 efi_status_t setup_amd_sev(void);
 
 unsigned long long get_amd_sev_c_bit_mask(void);
+unsigned long long get_amd_sev_addr_upperbound(void);
 
 #endif /* TARGET_EFI */
 
diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index f6f740b..c25bc66 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -25,6 +25,12 @@ typedef unsigned long pgd_t;
 #define LARGE_PAGE_SIZE	(1024 * PAGE_SIZE)
 #endif
 
+#ifdef TARGET_EFI
+/* lib/x86/amd_sev.c */
+extern unsigned long long get_amd_sev_c_bit_mask(void);
+extern unsigned long long get_amd_sev_addr_upperbound(void);
+#endif /* TARGET_EFI */
+
 #define PT_PRESENT_MASK		(1ull << 0)
 #define PT_WRITABLE_MASK	(1ull << 1)
 #define PT_USER_MASK		(1ull << 2)
@@ -33,10 +39,25 @@ typedef unsigned long pgd_t;
 #define PT_PAGE_SIZE_MASK	(1ull << 7)
 #define PT_GLOBAL_MASK		(1ull << 8)
 #define PT64_NX_MASK		(1ull << 63)
-#define PT_ADDR_MASK		GENMASK_ULL(51, 12)
 
-#define PDPTE64_PAGE_SIZE_MASK	  (1ull << 7)
-#define PDPTE64_RSVD_MASK	  GENMASK_ULL(51, cpuid_maxphyaddr())
+/*
+ * Without AMD SEV, the default address upper bound is 51 (i.e., pte bit 51 and
+ * lower bits are addresses). But with AMD SEV enabled, the upper bound is one
+ * bit lower than the c-bit position.
+ */
+#define PT_ADDR_UPPER_BOUND_DEFAULT	(51)
+
+#ifdef TARGET_EFI
+#define PT_ADDR_UPPER_BOUND	(get_amd_sev_addr_upperbound())
+#else
+#define PT_ADDR_UPPER_BOUND	(PT_ADDR_UPPER_BOUND_DEFAULT)
+#endif /* TARGET_EFI */
+
+#define PT_ADDR_LOWER_BOUND	(PAGE_SHIFT)
+#define PT_ADDR_MASK		GENMASK_ULL(PT_ADDR_UPPER_BOUND, PT_ADDR_LOWER_BOUND)
+
+#define PDPTE64_PAGE_SIZE_MASK	(1ull << 7)
+#define PDPTE64_RSVD_MASK	GENMASK_ULL(PT_ADDR_UPPER_BOUND, cpuid_maxphyaddr())
 
 #define PT_AD_MASK              (PT_ACCESSED_MASK | PT_DIRTY_MASK)
 
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 5cd2ee4..0ebc860 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -26,6 +26,9 @@ pteval_t *install_pte(pgd_t *cr3,
                 pt_page = 0;
 	    memset(new_pt, 0, PAGE_SIZE);
 	    pt[offset] = virt_to_phys(new_pt) | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
+#ifdef TARGET_EFI
+	    pt[offset] |= get_amd_sev_c_bit_mask();
+#endif /* TARGET_EFI */
 	}
 	pt = phys_to_virt(pt[offset] & PT_ADDR_MASK);
     }
@@ -63,7 +66,7 @@ struct pte_search find_pte_level(pgd_t *cr3, void *virt,
 		if (r.level == lowest_level)
 			return r;
 
-		pt = phys_to_virt(pte & 0xffffffffff000ull);
+		pt = phys_to_virt(pte & PT_ADDR_MASK);
 	}
 }
 
@@ -94,13 +97,20 @@ pteval_t *get_pte_level(pgd_t *cr3, void *virt, int pte_level)
 
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
-    return install_pte(cr3, 2, virt,
-		       phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask | PT_PAGE_SIZE_MASK, 0);
+    phys_addr_t flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask | PT_PAGE_SIZE_MASK;
+#ifdef TARGET_EFI
+    flags |= get_amd_sev_c_bit_mask();
+#endif /* TARGET_EFI */
+    return install_pte(cr3, 2, virt, phys | flags, 0);
 }
 
 pteval_t *install_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
-    return install_pte(cr3, 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask, 0);
+    phys_addr_t flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
+#ifdef TARGET_EFI
+    flags |= get_amd_sev_c_bit_mask();
+#endif /* TARGET_EFI */
+    return install_pte(cr3, 1, virt, phys | flags, 0);
 }
 
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt)
-- 
2.33.0.259.gc128427fd7-goog

