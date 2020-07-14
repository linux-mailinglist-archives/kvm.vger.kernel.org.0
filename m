Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7356021E475
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 02:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGNAX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 20:23:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:36936 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgGNAX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 20:23:57 -0400
IronPort-SDR: aHr1/x954aK0zHg6iIA5KAFzBxJRqiPPPKZcIbPD5ebpBApc6B3y3hshxwWhxVAGemE3kBLUMI
 Rg734929rTiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136910636"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="136910636"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 17:23:56 -0700
IronPort-SDR: n6qLgXD5LktAyl5QyGumIzqJHegV0PyYaCd/qlpxT+PNMct2ntuFhaLejSgpIuKtxCLEmtfF8N
 dTflf6+SalpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="268505778"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2020 17:23:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests PATCH 2/2] nVMX: Use the standard non-canonical value in test_mtf3
Date:   Mon, 13 Jul 2020 17:23:55 -0700
Message-Id: <20200714002355.538-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200714002355.538-1-sean.j.christopherson@intel.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the standard non-canonical value of repeating 'a' instead of a
custom (1 << 63) value in test_mtf3.  When PCID is enabled, bit 63 is
a flag that controls TLB swithching on MOV CR3 and is not included in
the canonical check of CR3, i.e. if CR4.PCIDE=1 then the test will load
0 into CR3 and all manner of confusion things happen.

Fixes: 46cc038c6afb8 ("x86: VMX: Add tests for monitor trap flag")
Cc: Oliver Upton <oupton@google.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index cb42a2d..32e3d4f 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5107,7 +5107,7 @@ static void test_mtf_guest(void)
 	      * MOV RAX is done before the VMCALL such that MTF is only enabled
 	      * for the instruction under test.
 	      */
-	     "mov $0x8000000000000000, %rax;\n\t"
+	     "mov $0xaaaaaaaaaaaaaaaa, %rax;\n\t"
 	     "vmcall;\n\t"
 	     "mov %rax, %cr3;\n\t"
 	     "test_mtf3:\n\t"
-- 
2.26.0

