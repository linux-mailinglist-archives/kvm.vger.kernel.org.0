Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A143D4B00
	for <lists+kvm@lfdr.de>; Sun, 25 Jul 2021 04:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGYBnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jul 2021 21:43:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:14481 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhGYBns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jul 2021 21:43:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10055"; a="199262128"
X-IronPort-AV: E=Sophos;i="5.84,266,1620716400"; 
   d="scan'208";a="199262128"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2021 19:24:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,266,1620716400"; 
   d="scan'208";a="416721353"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 24 Jul 2021 19:24:18 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, bsd@redhat.com
Cc:     Robert Hoo <robert.hu@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86: vmx_tests: pml: Skip PML test if it's not enabled in underlying
Date:   Sun, 25 Jul 2021 10:24:14 +0800
Message-Id: <1627179854-1878-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PML in VM depends on "enable PML" in VM-execution control, check this
before vmwrite to PMLADDR, because this field doesn't exist if PML is
disabled in VM-execution control.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 x86/vmx_tests.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4f712eb..8663112 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1502,13 +1502,16 @@ static int pml_init(struct vmcs *vmcs)
 		return VMX_TEST_EXIT;
 	}
 
+	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) & CPU_PML;
+	if (!ctrl_cpu) {
+		printf("\tPML is not enabled\n");
+		return VMX_TEST_EXIT;
+	}
+
 	pml_log = alloc_page();
 	vmcs_write(PMLADDR, (u64)pml_log);
 	vmcs_write(GUEST_PML_INDEX, PML_INDEX - 1);
 
-	ctrl_cpu = vmcs_read(CPU_EXEC_CTRL1) | CPU_PML;
-	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu);
-
 	return VMX_TEST_START;
 }
 
-- 
1.8.3.1

