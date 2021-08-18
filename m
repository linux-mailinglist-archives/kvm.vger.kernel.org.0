Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECE73EF68F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbhHRAKL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237077AbhHRAKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A71DC061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e75-20020a25374e000000b00597165a06d2so976346yba.6
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zMFVut4qB9Rms4PSa4L5t5RsPAg+k2A0uTP0Q6VXM2Y=;
        b=W6A0VCKfZh1Oimmzxe1JBJgTmRWNnHDvmAnVeX44at9mcFGcDG8haAWQBoC2VR2Ple
         uCr54Al1MDZ3o39/dAluI1iklB5bgKocjxXhqt/v2MX7ufSLe3YsAfiWhx6tHbnog7Bz
         q5R0LP+qzsHjWUzHdrbxlyrV+nli+q+njpSldSzEGafU3lIvD2qOHcCeNddr/iaxqCM+
         yoEbaqO8zdt3tLlzOL/Ml3rwI/F9UbvG3RvvcaXQkDPpv9Gs8l7Ph0oCjI4mXWNnskIO
         xo40Q5gNdDv1ewrol+ff1oQ00NvLTnmlSAE0PnoSRxFGVyjz/ZNuX3LS7+/kNLzBDE5A
         KPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zMFVut4qB9Rms4PSa4L5t5RsPAg+k2A0uTP0Q6VXM2Y=;
        b=YUt7yCQ45pWNU+O9ItwCdFxXgmDCiVFac3chR0pw5JnJYybXtYtmh6eScBP/YzFoQr
         bY1sjHN7j9oOdnBVVoRqdJIYsW2r4YBINoBtWXFPY2148wVsAYKNUQaXNkGGWAVqbsey
         orxctE1woHJecYQsWeX3zJ9tCuEtegfQCbYTLP5MSO+F6ZBGL6GOkivvrhytADIN9IOc
         BfbVYPqo5C4RJpe1Mep1UGV3/roAHVUC5TrpsvfKOdQ25EPrzqnMFMnsHUe+Nxo0BtpL
         CirzklhZ1TsvS9gbGGTIf2Rszqp35GUCO4XgkQYpRvPyn4ruQssRBG4i5b0OFvhLgQ2f
         mDIg==
X-Gm-Message-State: AOAM531WNz12giJFiEmwUVadmcdQlPFhBmmRjQ86CnZ+HIA0FfMaHF2d
        B3P0mmmxj7Lq3fM4fl1cdZ68YYCnSlfOkdHPEQciXPT+FYLHD1Awjs70n9sEeH6UI0eTpMz2O3r
        myx9MAcdZi3F4sCz2wV6pW+w3gLMKVhDUUsDG2iFTF8Ci7YzWHDx3aaATv/qvG/VYkghJ
X-Google-Smtp-Source: ABdhPJx/T6uilcVvSM13RwseOLh6Mjv6gDoFpd/t+F1M3uC46J4wm42oKvHfAnxGwXv3kL42TOSRr+NbteOm9vK5
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:becd:: with SMTP id
 k13mr7855960ybm.198.1629245373839; Tue, 17 Aug 2021 17:09:33 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:00 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-12-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 11/16] x86 AMD SEV: Page table with c-bit
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV introduces c-bit to page table entries. To work with AMD SEV:

   1. c-bit should be set for new page table entries
   2. address calculation should not use c-bit as part of address

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c  |  5 +++++
 lib/x86/amd_sev.h  |  1 +
 lib/x86/asm/page.h | 13 +++++++++++--
 lib/x86/vm.c       | 18 ++++++++++++++----
 4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index bd8d536..535f0e8 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -48,3 +48,8 @@ unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	return 1ull << amd_sev_c_bit_pos;
 }
+
+unsigned long long get_amd_sev_c_bit_pos(void)
+{
+	return amd_sev_c_bit_pos;
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index c1b08e8..e1ef777 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -37,5 +37,6 @@
 
 EFI_STATUS setup_amd_sev(void);
 unsigned long long get_amd_sev_c_bit_mask(void);
+unsigned long long get_amd_sev_c_bit_pos(void);
 
 #endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index f6f740b..c49b259 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -33,10 +33,19 @@ typedef unsigned long pgd_t;
 #define PT_PAGE_SIZE_MASK	(1ull << 7)
 #define PT_GLOBAL_MASK		(1ull << 8)
 #define PT64_NX_MASK		(1ull << 63)
-#define PT_ADDR_MASK		GENMASK_ULL(51, 12)
+#ifndef CONFIG_AMD_SEV
+#define PT_ADDR_UPPER_BOUND	(51)
+#else
+/* lib/x86/amd_sev.c */
+extern unsigned long long get_amd_sev_c_bit_mask(void);
+extern unsigned long long get_amd_sev_c_bit_pos(void);
+#define PT_ADDR_UPPER_BOUND	(get_amd_sev_c_bit_pos()-1)
+#endif /* CONFIG_AMD_SEV */
+#define PT_ADDR_LOWER_BOUND	(PAGE_SHIFT)
+#define PT_ADDR_MASK		GENMASK_ULL(PT_ADDR_UPPER_BOUND, PT_ADDR_LOWER_BOUND)
 
 #define PDPTE64_PAGE_SIZE_MASK	  (1ull << 7)
-#define PDPTE64_RSVD_MASK	  GENMASK_ULL(51, cpuid_maxphyaddr())
+#define PDPTE64_RSVD_MASK	  GENMASK_ULL(PT_ADDR_UPPER_BOUND, cpuid_maxphyaddr())
 
 #define PT_AD_MASK              (PT_ACCESSED_MASK | PT_DIRTY_MASK)
 
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 5cd2ee4..b482b87 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -26,6 +26,9 @@ pteval_t *install_pte(pgd_t *cr3,
                 pt_page = 0;
 	    memset(new_pt, 0, PAGE_SIZE);
 	    pt[offset] = virt_to_phys(new_pt) | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
+#ifdef CONFIG_AMD_SEV
+	    pt[offset] |= get_amd_sev_c_bit_mask();
+#endif /* CONFIG_AMD_SEV */
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
+#ifdef CONFIG_AMD_SEV
+    flags |= get_amd_sev_c_bit_mask();
+#endif /* CONFIG_AMD_SEV */
+    return install_pte(cr3, 2, virt, phys | flags, 0);
 }
 
 pteval_t *install_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
-    return install_pte(cr3, 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask, 0);
+    phys_addr_t flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
+#ifdef CONFIG_AMD_SEV
+    flags |= get_amd_sev_c_bit_mask();
+#endif /* CONFIG_AMD_SEV */
+    return install_pte(cr3, 1, virt, phys | flags, 0);
 }
 
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt)
-- 
2.33.0.rc1.237.g0d66db33f3-goog

