Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DE91ACDAC
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 18:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgDPQ2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 12:28:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:13693 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbgDPQ2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 12:28:19 -0400
IronPort-SDR: RaiMmUB6D5BwhO9aXefhzyOYjhsV6zkZDQjG1Ewc/L7PjnuDOuuyO3ITfLCq+qjTiOqrsCqOk/
 JLKEvM3LIZuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 09:28:18 -0700
IronPort-SDR: FKixKdxKXu495bulbZxjUOLEUSkbNuXKvvVfa9hed7D0h2appRHAB8ZOMq32vF45sNwUXRMyFj
 tLLCUdRnuNUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="400727226"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 16 Apr 2020 09:28:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] nVMX: Add testcase to cover VMWRITE to nonexistent CR3-target values
Date:   Thu, 16 Apr 2020 09:28:14 -0700
Message-Id: <20200416162814.32065-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhance test_cr3_targets() to verify that attempting to write CR3-target
value fields beyond the reported number of supported targets fails.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1f97fe3..f5c72e6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3570,6 +3570,10 @@ static void test_cr3_targets(void)
 	for (i = 0; i <= supported_targets + 1; i++)
 		try_cr3_target_count(i, supported_targets);
 	vmcs_write(CR3_TARGET_COUNT, cr3_targets);
+
+	/* VMWRITE to nonexistent target fields should fail. */
+	for (i = supported_targets; i < 256; i++)
+		TEST_ASSERT(vmcs_write(CR3_TARGET_0 + i*2, 0));
 }
 
 /*
-- 
2.26.0

