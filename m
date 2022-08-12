Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DDB590A00
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 03:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbiHLBrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 21:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbiHLBrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 21:47:48 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A982A063C;
        Thu, 11 Aug 2022 18:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660268867; x=1691804867;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dmCQu5n9kOHYzH3uYzvtW2dglSnokVqA7rtZWKM7xZs=;
  b=HR2qpYtCzIPOMxunTUXJKBLVq9OdsykszCupVZ+rvQXwvR6xdMV7f+GX
   a8OGXMNZ6wlx+zHm4+mf18PXiucE9NbvRS+uXeawFY6yLfHw7czHg9jJw
   MjqMGKiRORSUX90ANF8gBsHFDBZPIHikEhJilNRaIJjU9jJoU23ZNKDpV
   pJn/dS3VThS4PjrgS7qDYSBsakNhVMksN2NVTy9S2HKY7R5Uq7fBKwp7J
   wZjCT+3118AHtV7DNhb02XfhhZZ7gEVmR5I2PO0bjVH+93krzC9FFVnMU
   Dq+oBFcOq6kasKxaCPsbMmMPZDPrC5VcLawn+axFw1qjrqRcG1PCTeKYX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271273574"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="271273574"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 18:47:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="933543044"
Received: from sqa-gate.sh.intel.com (HELO localhost.tsp.org) ([10.239.48.212])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 18:47:44 -0700
From:   Yuan Yao <yuan.yao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Jon Cargille <jcargill@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH 1/1] kvm: nVMX: Checks "VMCS shadowing" with VMCS link pointer for non-root mode VM{READ,WRITE}
Date:   Fri, 12 Aug 2022 09:47:06 +0800
Message-Id: <20220812014706.43409-1-yuan.yao@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add checking to VMCS12's "VMCS shadowing", make sure the checking of
VMCS12's vmcs_link_pointer for non-root mode VM{READ,WRITE} happens
only if VMCS12's "VMCS shadowing" is 1.

SDM says that for non-root mode the VMCS's "VMCS shadowing" must be 1
(and the corresponding bits in VMREAD/VMWRITE bitmap must be 0) when
condition checking of [B] is reached(please refer [A]), which means
checking to VMCS link pointer for non-root mode VM{READ,WRITE} should
happen only when "VMCS shadowing" = 1.

Description from SDM Vol3(April 2022) Chapter 30.3 VMREAD/VMWRITE:

IF (not in VMX operation)
   or (CR0.PE = 0)
   or (RFLAGS.VM = 1)
   or (IA32_EFER.LMA = 1 and CS.L = 0)
THEN #UD;
ELSIF in VMX non-root operation
      AND (“VMCS shadowing” is 0 OR
           source operand sets bits in range 63:15 OR
           VMREAD bit corresponding to bits 14:0 of source
           operand is 1)  <------[A]
THEN VMexit;
ELSIF CPL > 0
THEN #GP(0);
ELSIF (in VMX root operation AND current-VMCS pointer is not valid) OR
      (in VMX non-root operation AND VMCS link pointer is not valid)
THEN VMfailInvalid;  <------ [B]
...

Fixes: dd2d6042b7f4 ("kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field")
Signed-off-by: Yuan Yao <yuan.yao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..30685be54c5d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5123,6 +5123,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		 */
 		if (vmx->nested.current_vmptr == INVALID_GPA ||
 		    (is_guest_mode(vcpu) &&
+		     nested_cpu_has_shadow_vmcs(vcpu) &&
 		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 			return nested_vmx_failInvalid(vcpu);
 
@@ -5233,6 +5234,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	 */
 	if (vmx->nested.current_vmptr == INVALID_GPA ||
 	    (is_guest_mode(vcpu) &&
+	     nested_cpu_has_shadow_vmcs(vcpu) &&
 	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 		return nested_vmx_failInvalid(vcpu);
 
-- 
2.27.0

