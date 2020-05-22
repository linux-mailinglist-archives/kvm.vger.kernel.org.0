Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E551DE747
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgEVMwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbgEVMwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:21 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E50DC05BD43
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:21 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id k5so12452105lji.11
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YzqQsjWsD3KM16gewdvtpsRwCFP82zpuuyGt2UtUvco=;
        b=j6Temqp5EdCwy2lHEeBRNU/roZu6P35IXqFKlgDFfcRBuTYSUzvoVVn3YuRD/rx9VD
         A/33zGrbtZ5asrkQE65MmYaLJtBAEY84pZxygcVD/NIjWPOHi2M0V+WECH/S/BiPQcjj
         ye0nW3hVLvZJ9O5MEjEmTV62uQQDzHRq2b2l05cYTQowGXzbX7D6xJuXQOctBQIUszcW
         svrImc0ptd9lZd1snb+8vxKeIxuW1Zu0t9X2Cwq5D2IKtwHlftfhGib5sGsFpuwYWQp7
         imBMkbE7Z20hpw2drt92fqwRw+0cXJIXL8sTiwxb11wDDXa/PIa0fbCDv1b2cCqwzOGa
         hvwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YzqQsjWsD3KM16gewdvtpsRwCFP82zpuuyGt2UtUvco=;
        b=cxgPn7dNA3p41Mhrom4cVCF2PYn7JF7Qwp2RocuVqUZxdXUhFAEBqwtAFnWMU+l1ot
         4mylzKlYLnAv/mEiZNJ6qfGNSPudeKltHatIJbDj7PZOGs3h3tApPDlEuCvxEI4hmc4D
         B6G9SG3SBWaYbG/KjZUrGZVyS7Iuduvro4cjDNvghwh9XJedqZiV7jevSgtfzY4N6wqm
         fJVtlrmPubmJnASI5z0zNZIZG5eIVRtC99lT5Q1wscBcfulc0g0DHCJoCZvw9FhcQZIj
         B4A9+qx4TVT9GH+iDkP0YQmciwapaojV2s01SA1t0k2muQAaDrhFG3/ScXGBDWL+3EPa
         WSMQ==
X-Gm-Message-State: AOAM533izF5FKckzpJEQvYUMvTvaIlD3EwTpPG0Mb/f6jdkhk+mb3uws
        U9H7vpKj4GG6hgi/aPEz5IgVnQ==
X-Google-Smtp-Source: ABdhPJysUi0S/B10wTzt4/F1rMdfE2sKWbCTwK5LOYcv3t2ygEQAFnn1cMIJjclfQZFWD15ToOwdhA==
X-Received: by 2002:a2e:9a41:: with SMTP id k1mr7755117ljj.143.1590151939515;
        Fri, 22 May 2020 05:52:19 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id y21sm428982ljg.48.2020.05.22.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:17 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id B146A10204F; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
Subject: [RFC 03/16] x86/kvm: Make DMA pages shared
Date:   Fri, 22 May 2020 15:52:01 +0300
Message-Id: <20200522125214.31348-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make force_dma_unencrypted() return true for KVM to get DMA pages mapped
as shared.

__set_memory_enc_dec() now informs the host via hypercall if the state
of the page has changed from shared to private or back.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 | 1 +
 arch/x86/mm/mem_encrypt_common.c | 5 +++--
 arch/x86/mm/pat/set_memory.c     | 7 +++++++
 include/uapi/linux/kvm_para.h    | 2 ++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc72bfd89bcf..86c012582f51 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -799,6 +799,7 @@ config KVM_GUEST
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
 	select ARCH_CPUIDLE_HALTPOLL
+	select X86_MEM_ENCRYPT_COMMON
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index 964e04152417..a878e7f246d5 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -10,14 +10,15 @@
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
 #include <linux/dma-mapping.h>
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
index b8c55a2e402d..6f075766bb94 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/libnvdimm.h>
+#include <linux/kvm_para.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -1972,6 +1973,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	struct cpa_data cpa;
 	int ret;
 
+	if (kvm_mem_protected()) {
+		unsigned long gfn = __pa(addr) >> PAGE_SHIFT;
+		int call = enc ? KVM_HC_MEM_UNSHARE : KVM_HC_MEM_SHARE;
+		return kvm_hypercall2(call, gfn, numpages);
+	}
+
 	/* Nothing to do if memory encryption is not active */
 	if (!mem_encrypt_active())
 		return 0;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 1a216f32e572..c6d8c988e330 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,8 @@
 #define KVM_HC_SEND_IPI			10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_ENABLE_MEM_PROTECTED	12
+#define KVM_HC_MEM_SHARE		13
+#define KVM_HC_MEM_UNSHARE		14
 
 /*
  * hypercalls use architecture specific
-- 
2.26.2

