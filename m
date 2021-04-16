Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454AB362431
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbhDPPmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:63662 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243449AbhDPPmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:02 -0400
IronPort-SDR: MYQ5WHyWqi4eq+RLtc6h6T4PyD0VKMaSLilimbbgxNgZZutgsEAI09n4yxvFYXhWhMHHgxmLYj
 0LnP85YfLcrA==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="174550437"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="174550437"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:37 -0700
IronPort-SDR: pd4rjOuDB7GQ8SDPFXTAOT408W4GzC6bMM/6th6kYTROmgUGT42oXh6q1tqsLOgM51ZsWI2pcP
 85QBOIF9XVfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453378439"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2021 08:41:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id DF99D1D2; Fri, 16 Apr 2021 18:41:49 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 03/13] x86/kvm: Make DMA pages shared
Date:   Fri, 16 Apr 2021 18:40:56 +0300
Message-Id: <20210416154106.23721-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
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

