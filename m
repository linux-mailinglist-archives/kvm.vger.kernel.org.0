Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E569A40A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfHVXqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:46:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:7827 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbfHVXqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:46:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 16:46:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="169947512"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 16:46:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Don't test 64-bit-only MSRs in 32-bit build
Date:   Thu, 22 Aug 2019 16:46:49 -0700
Message-Id: <20190822234649.3258-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the 64-bit-only MSRs on 32-bit to avoid triple faults due to #GPs
on the MSR access.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/msr.c b/x86/msr.c
index ffc24b1..beb321f 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -48,7 +48,6 @@ struct msr_info msr_info[] =
     { .index = 0xc0000080, .name = "MSR_EFER",
       .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
     },
-#endif
     { .index = 0xc0000082, .name = "MSR_LSTAR",
       .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
     },
@@ -58,6 +57,7 @@ struct msr_info msr_info[] =
     { .index = 0xc0000084, .name = "MSR_SYSCALL_MASK",
       .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
     },
+#endif
 
 //    MSR_IA32_DEBUGCTLMSR needs svm feature LBRV
 //    MSR_VM_HSAVE_PA only AMD host
-- 
2.22.0

