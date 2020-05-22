Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028931DE731
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgEVMw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgEVMwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADACC08C5C0
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id c11so10325968ljn.2
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QDGQlabqNdXWT8KYXiZwEeKnt25k8ILFDWxwAiuz/rs=;
        b=T5hCoobMWtJ7Xzo20ohRf6NdcQ3ttgHexOKNzdWduVQbkLxApAPl+W+t7qaQWvvPaL
         szS1ESDyCBl8nxotiDX/fMAWiyPnn53Y573QSOYSRIKxkWL0hFikT7PbX/xhc6GpbupH
         Jx3l5SbaTAsfUfZ10CSxgW0gxp6Cm2E9v82GsvCLwFYiFiZkeS2r0a/IwAaNcT0g776C
         7W0DJCCofxJ5gED2yaCZ/LqHet1TQUSlADKixI+VvxGE2mHgUd5Dkn1QmrHHAhn68P+f
         a2mkP4+qpHJmX+8ZpqpZJ8eyw6wwk1TMtgSBnlxvgDuZ5J/XSH61k5FXpKubBlHpB7A+
         tHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QDGQlabqNdXWT8KYXiZwEeKnt25k8ILFDWxwAiuz/rs=;
        b=U+RSgawl92f6V3PSQl4+D6EDVGknT265lPZW14XaI5q7cn/e3sv13qMtJMI1hzk5WO
         3cPgxZEK/cTqUmXrhd/Ubuj67u78namVO6OB6ivuTdPZkIoDNG+vk6ukaRDRESeSFu4U
         Td5ehqm0YWHBFNwI5F4Xk3n83z1iotahMuYyu6U3hOWIImGSn9g3YU9joftXJdSt/MOa
         H/63RNNy4QRu7y01MxPJErm+HADa99s2No/C3aC9pJMtPUfSTYLIwCtaUrZJamdJWG3Z
         9W+H4gUt/o8m7WhlQs+TK85Fink5GdAUt39q0tQI2U6rXmg001EYI8Oo+O6ern3Knofs
         YOjg==
X-Gm-Message-State: AOAM533WmYb03KK3lmd7N0s+iJXZdUNfNF3w83BCSz50nJ+4g86+3qB6
        rVyabXlEoGtqwCMg8zoEGdf0lw==
X-Google-Smtp-Source: ABdhPJzbEgynOtDCfmMokHSL9w+mx6+aIeiKdBvwClE9qAMTx107s9z4ayxTSo/aYXpRjHq4p8yErA==
X-Received: by 2002:a2e:9ada:: with SMTP id p26mr7407068ljj.14.1590151939171;
        Fri, 22 May 2020 05:52:19 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e18sm343134lja.55.2020.05.22.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:17 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id B92F7102051; Fri, 22 May 2020 15:52:19 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 04/16] x86/kvm: Use bounce buffers for KVM memory protection
Date:   Fri, 22 May 2020 15:52:02 +0300
Message-Id: <20200522125214.31348-5-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mirror SEV, use SWIOTLB always if KVM memory protection is enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/kernel/kvm.c            |  2 ++
 arch/x86/kernel/pci-swiotlb.c    |  3 ++-
 arch/x86/mm/mem_encrypt.c        | 20 --------------------
 arch/x86/mm/mem_encrypt_common.c | 23 +++++++++++++++++++++++
 5 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 86c012582f51..58dd44a1b92f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -800,6 +800,7 @@ config KVM_GUEST
 	select PARAVIRT_CLOCK
 	select ARCH_CPUIDLE_HALTPOLL
 	select X86_MEM_ENCRYPT_COMMON
+	select SWIOTLB
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index bda761ca0d26..f50d65df4412 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -24,6 +24,7 @@
 #include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/swiotlb.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -742,6 +743,7 @@ static void __init kvm_init_platform(void)
 		}
 
 		mem_protected = true;
+		swiotlb_force = SWIOTLB_FORCE;
 	}
 }
 
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index c2cfa5e7c152..814060a6ceb0 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,6 +13,7 @@
 #include <asm/dma.h>
 #include <asm/xen/swiotlb-xen.h>
 #include <asm/iommu_table.h>
+#include <asm/kvm_para.h>
 
 int swiotlb __read_mostly;
 
@@ -49,7 +50,7 @@ int __init pci_swiotlb_detect_4gb(void)
 	 * buffers are allocated and used for devices that do not support
 	 * the addressing range required for the encryption mask.
 	 */
-	if (sme_active())
+	if (sme_active() || kvm_mem_protected())
 		swiotlb = 1;
 
 	return swiotlb;
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 112304a706f3..35c748ee3fcb 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -370,23 +370,3 @@ void __init mem_encrypt_free_decrypted_mem(void)
 
 	free_init_pages("unused decrypted", vaddr, vaddr_end);
 }
-
-void __init mem_encrypt_init(void)
-{
-	if (!sme_me_mask)
-		return;
-
-	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
-	swiotlb_update_mem_attributes();
-
-	/*
-	 * With SEV, we need to unroll the rep string I/O instructions.
-	 */
-	if (sev_active())
-		static_branch_enable(&sev_enable_key);
-
-	pr_info("AMD %s active\n",
-		sev_active() ? "Secure Encrypted Virtualization (SEV)"
-			     : "Secure Memory Encryption (SME)");
-}
-
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index a878e7f246d5..7900f3788010 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -37,3 +37,26 @@ bool force_dma_unencrypted(struct device *dev)
 
 	return false;
 }
+
+void __init mem_encrypt_init(void)
+{
+	if (!sme_me_mask && !kvm_mem_protected())
+		return;
+
+	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
+	swiotlb_update_mem_attributes();
+
+	/*
+	 * With SEV, we need to unroll the rep string I/O instructions.
+	 */
+	if (sev_active())
+		static_branch_enable(&sev_enable_key);
+
+	if (sme_me_mask) {
+		pr_info("AMD %s active\n",
+			sev_active() ? "Secure Encrypted Virtualization (SEV)"
+			: "Secure Memory Encryption (SME)");
+	} else {
+		pr_info("KVM memory protection enabled\n");
+	}
+}
-- 
2.26.2

