Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A51836243B
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344048AbhDPPmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:4092 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343989AbhDPPmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:11 -0400
IronPort-SDR: E9YfRotjPqIUZrKWWV/D64DLh8dwSCmaGzDza6oSmpdTNUauWpp8/Exd1T9XjguHtJEZIEQkFc
 tPMJ9eFMHzwQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="195169145"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195169145"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:42 -0700
IronPort-SDR: X85JOUNwgOD0cizzR5uDukCMiBRDxeHXnklH8hj1bphP48a0OlK0J470EynoTDSDOOq7s8sGWp
 THnhFtf3GCoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="384352246"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 08:41:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 0A0DB279; Fri, 16 Apr 2021 18:41:50 +0300 (EEST)
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
Subject: [RFCv2 06/13] x86/realmode: Share trampoline area if KVM memory protection enabled
Date:   Fri, 16 Apr 2021 18:40:59 +0300
Message-Id: <20210416154106.23721-7-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If KVM memory protection is active, the trampoline area will need to be
in shared memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/realmode/init.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 22fda7d99159..f3b54b5da693 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -10,6 +10,7 @@
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
 #include <asm/sev-es.h>
+#include <asm/kvm_para.h>
 
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
@@ -75,11 +76,11 @@ static void __init setup_real_mode(void)
 	base = (unsigned char *)real_mode_header;
 
 	/*
-	 * If SME is active, the trampoline area will need to be in
-	 * decrypted memory in order to bring up other processors
+	 * If SME or KVM memory protection is active, the trampoline area will
+	 * need to be in decrypted memory in order to bring up other processors
 	 * successfully. This is not needed for SEV.
 	 */
-	if (sme_active())
+	if (sme_active() || kvm_mem_protected())
 		set_memory_decrypted((unsigned long)base, size >> PAGE_SHIFT);
 
 	memcpy(base, real_mode_blob, size);
-- 
2.26.3

