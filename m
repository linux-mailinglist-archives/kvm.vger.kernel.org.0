Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD45456AC2
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 08:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhKSHSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 02:18:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:13427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhKSHSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 02:18:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="258161241"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="258161241"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 23:15:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="647080045"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 18 Nov 2021 23:15:23 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86/vmx: Deprecate VMX_VMCS_ENUM.MAX_INDEX check in vmread/vmwrite test
Date:   Fri, 19 Nov 2021 15:15:07 +0800
Message-Id: <1637306107-92967-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yu Zhang <yu.c.zhang@linux.intel.com>

The actual value of vmcs12.vmcs_enum is set by QEMU, with hard code,
while the expected value in this test is got from literally traversing
vmcs12 fields. They probably mismatch, depends on KVM version and QEMU
version used. It doesn't mean QEMU or KVM is buggy.

We deprecate this failure report, as we "don't see any point in fighting
too hard with QEMU."[1]
We keep its log here as hint.

[1] https://lore.kernel.org/kvm/YZWqJwUrF2Id9hM2@google.com/

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 x86/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 7a2f7a3..7e191dd 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -379,8 +379,7 @@ static void test_vmwrite_vmread(void)
 	vmcs_enum_max = (rdmsr(MSR_IA32_VMX_VMCS_ENUM) & VMCS_FIELD_INDEX_MASK)
 			>> VMCS_FIELD_INDEX_SHIFT;
 	max_index = find_vmcs_max_index();
-	report(vmcs_enum_max == max_index,
-	       "VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
+	printf("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x\n",
 	       max_index, vmcs_enum_max);
 
 	assert(!vmcs_clear(vmcs));
-- 
1.8.3.1

