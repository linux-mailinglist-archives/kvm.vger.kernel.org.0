Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1715352D66
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhDBP1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbhDBP1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:03 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6D3C0617A7
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:00 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id c6so4454116lji.8
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aho3YzbAYOK3xFgDwaA/KoZASR7zBJ1wJNmUpntSsWc=;
        b=2QzvDuEvCR3I2ZDGC2q/r4bNtqnH2e/nkaqSMvgaY8t1XXblCZNLVwizVwriqp4ctq
         CuEbDoBOax44+oLmnKITnvspc5PpazSknGo20E7xxQUgEL0BMY+U4SOPirIT02WkkJ/w
         wrAY+AmwUvUFXoqRvjBzonIuQt3gNbeytFCVwJuDxuQrO9BxYGmZTXg0Nt7gEsMJptNO
         Ivjl0iZK4X/qBiwWdxuaKlUU5GzHNIbUoaBRC7viRsnEds4bK5Selt6pbN7neSbHwSap
         g32WgF2ulA5zJiMifrWUkKbeNzEZUyS9ygY05adoG52zdthFiBJxjcrkFR5TiLVRXDKW
         6UpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aho3YzbAYOK3xFgDwaA/KoZASR7zBJ1wJNmUpntSsWc=;
        b=NMHHmKNoF48VCcwqaiFNhZ5/GtiG3wygHnza7AaMrtfl3NyjojIgj3++9sHQiU/FTx
         YhKsjNBnT1Guf9h1jmk1l60h7zFGlMXgm8/DebtKVS9cJ/h96ASS89hfSTwS8bINorfa
         L7HuY//rk/Lzu65V2Uf1oujtIZrgDciJo8rUzVt4gwcIJ3VIT47tUNCzKWtKBM9MneX5
         Es9EIgrxquEHdfHVJHOIlQ+KQFSeUGKezaTbC8VVHkhO4JvVRvFzJ/vZX6aYT9tILBMO
         XVAORmWfKDg+841L61fYTzlGB907oKxiXILAdvET98/YXl+mjbbXYdk0WB9LHwHFfOQA
         OrNw==
X-Gm-Message-State: AOAM533wPH/aEOLW7D2Ouj2TW+XLkG/OBbBxwvoyHaGPs75erumZoo+k
        elJUwbVMFANuz3ca1iTbVgfziw==
X-Google-Smtp-Source: ABdhPJxPXdliVU29L50xs/trh5bjPIkQyC1OfYRcYmB3fubXDmftI2jmDxrfsCutGi24mgL0K0++ww==
X-Received: by 2002:a2e:9157:: with SMTP id q23mr8978027ljg.298.1617377219398;
        Fri, 02 Apr 2021 08:26:59 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id v11sm947533ljp.63.2021.04.02.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 3598F102674; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 3/7] x86/kvm: Make DMA pages shared
Date:   Fri,  2 Apr 2021 18:26:41 +0300
Message-Id: <20210402152645.26680-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make force_dma_unencrypted() return true for KVM to get DMA pages mapped
as shared.

__set_memory_enc_dec() now informs the host via hypercall if the state
of the page has changed from shared to private or back.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 |  1 +
 arch/x86/mm/mem_encrypt_common.c |  5 +++--
 arch/x86/mm/pat/set_memory.c     | 10 ++++++++++
 include/uapi/linux/kvm_para.h    |  1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2b4ce1722dbd..d197b3beb904 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -811,6 +811,7 @@ config KVM_GUEST
 	select PARAVIRT_CLOCK
 	select ARCH_CPUIDLE_HALTPOLL
 	select X86_HV_CALLBACK_VECTOR
+	select X86_MEM_ENCRYPT_COMMON
 	default y
 	help
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index dd791352f73f..6bf0718bb72a 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -10,14 +10,15 @@
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
 #include <linux/dma-direct.h>
+#include <asm/kvm_para.h>
 
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {
 	/*
-	 * For SEV, all DMA must be to unencrypted/shared addresses.
+	 * For SEV and KVM, all DMA must be to unencrypted/shared addresses.
 	 */
-	if (sev_active())
+	if (sev_active() || kvm_mem_protected())
 		return true;
 
 	/*
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 16f878c26667..4b312d80033d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/libnvdimm.h>
+#include <linux/kvm_para.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -1977,6 +1978,15 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	struct cpa_data cpa;
 	int ret;
 
+	if (kvm_mem_protected()) {
+		/* TODO: Unsharing memory back */
+		if (WARN_ON_ONCE(enc))
+			return -ENOSYS;
+
+		return kvm_hypercall2(KVM_HC_MEM_SHARE,
+				      __pa(addr) >> PAGE_SHIFT, numpages);
+	}
+
 	/* Nothing to do if memory encryption is not active */
 	if (!mem_encrypt_active())
 		return 0;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 1a216f32e572..09d36683ee0a 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI			10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_ENABLE_MEM_PROTECTED	12
+#define KVM_HC_MEM_SHARE		13
 
 /*
  * hypercalls use architecture specific
-- 
2.26.3

