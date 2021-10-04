Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB654218AE
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbhJDUvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236849AbhJDUvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD715C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:53 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u7so15511326pfg.13
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GbzETZ+Y0mictTqX5N0ZcqEh/OP0EgELTPz8FGTRb6g=;
        b=RIpQbAHA6M3Zl81BJghI3YQ/CnKFthWkbF0cA7nRtDY9ta321OeVoRS6T1w8Xo+lTG
         r6bq+dmwE0WTrgZiEC93KqWyPIcfYClIKc/OmV2DwFCZJlk4rKxcLyrJMZFKRneMKMRH
         ljJX2RkkVBBd/hLBf3lDyv2uUKm5+6XGSet7/eavBXuug0q41Je0V/4Z7uhOpQxPw4UH
         3BSjJM4wX/OL0lbz4BsLADb+7Anpw1R14AYj9k+HjV4O+2aVfVInVhlFPOmNvQb0XI0l
         p/XNk7Cbg54D6xPSd28StkMh8Sjbf4vs1uR621NWC7AnAmZ8EBcYu3eurdQETf8u5IiK
         GibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GbzETZ+Y0mictTqX5N0ZcqEh/OP0EgELTPz8FGTRb6g=;
        b=pRVXYUdKTOtX8x01VjH8559PI/faa69qiPqkIKHROs7yZrSlKdQEnGRLIUYO897KY8
         sn/Rn4cX4K4VLxBVEQAR2ac9wuqU8+Aua438Aqj2oACgNNOxlP6N8ExoWyI6VguhI6a/
         gMQB6TQClNz1TVMwATnJmtYduiFhOWnFoRJRx3/don3xe9MSnhU9nCSt/XZV/PUrGMrp
         ey6/ck3obb7lLMHiKHo3xKOoKbe1hRI/7R6yiC2AMvc7w4O5BKUxcc4Eo2NfdqWDlRtl
         2vv2a26PWMCR47tP5I3+nLgGRwZnAzSS6ZiqtQwpuG7u7ESccxqOhRqC318fHBqTIRoa
         NuXg==
X-Gm-Message-State: AOAM530kAZkTWGlwNm8IyYQ/eiNJRieCk6hnhZFWijcLKzSYXmwjqqqM
        r+BHUrf8hl6Orveheq9loJAU6lcslMZ1Cw==
X-Google-Smtp-Source: ABdhPJx0zLu5PsqFt0DX2QTLmUeZTNY3+ZTHohI9ziuTyWZ5+eQWZOAIiR8/cdL4Ooe02rmSXElFfQ==
X-Received: by 2002:a63:79c7:: with SMTP id u190mr12622090pgc.378.1633380593012;
        Mon, 04 Oct 2021 13:49:53 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:52 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 13/17] x86 AMD SEV: Page table with c-bit
Date:   Mon,  4 Oct 2021 13:49:27 -0700
Message-Id: <20211004204931.1537823-14-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

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
index 13e6455..b555355 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -73,3 +73,13 @@ unsigned long long get_amd_sev_c_bit_mask(void)
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
index 68483c9..7de12f0 100644
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
2.33.0

