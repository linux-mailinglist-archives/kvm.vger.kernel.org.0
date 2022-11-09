Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5826225AD
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiKIInH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiKIInE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:43:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD3186D3;
        Wed,  9 Nov 2022 00:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667983383; x=1699519383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S7xex32Cpwhkia59yekaOvOun7fKL5h5EceHgPZVwgg=;
  b=cg1FXu7rKeZ1dSxShFqZS3SdYhWyjxW48c4+47eMTfGJsHm2SER9IRh5
   lmm4mB5FhL7L5ikQxEV1i+4ipiCPkSS88fVFnkOLkdiU7idlO4DnBphjA
   E1atKqJiA+gFxEllX7SVPvEHrJi/4zbZX5PGc6p8ELhfRDikMP1nXsERe
   3nU8lMqtMKavKe0qStdVQZokuhCVQfowufrQ+t3Rv8s40DXClbHuz+vzJ
   lSDb6RcrxHpYtGub6hB3pYHnK1N9Z43JL08UVdZzxVYXSTpJMbCCpArYG
   OK0qFZl1u0eyusg8B9MHtdtQVLPVxnZ4x3w6E+Jr9B9mtALvlOsb+0iRD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="308544201"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="308544201"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 00:43:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="631182832"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="631182832"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by orsmga007.jf.intel.com with ESMTP; 09 Nov 2022 00:43:01 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: nVMX: Simplify the setting of SECONDARY_EXEC_ENABLE_VMFUNC for nested.
Date:   Wed,  9 Nov 2022 15:54:13 +0800
Message-Id: <20221109075413.1405803-3-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
References: <20221109075413.1405803-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Values of base settings for nested proc-based VM-Execution control MSR come
from the ones for non-nested. And for SECONDARY_EXEC_ENABLE_VMFUNC flag,
KVM currently a) first mask off it from vmcs_conf->cpu_based_2nd_exec_ctrl;
b) then check it against the same source; c) and reset it again if host has
it.

So just simplify this, by not masking off SECONDARY_EXEC_ENABLE_VMFUNC in
the first place.

No functional change.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1acb81c2be11..2bad79985c10 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6806,6 +6806,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
+		SECONDARY_EXEC_ENABLE_VMFUNC |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
 		SECONDARY_EXEC_TSC_SCALING;
@@ -6837,18 +6838,13 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 				SECONDARY_EXEC_ENABLE_PML;
 			msrs->ept_caps |= VMX_EPT_AD_BIT;
 		}
-	}
 
-	if (cpu_has_vmx_vmfunc()) {
-		msrs->secondary_ctls_high |=
-			SECONDARY_EXEC_ENABLE_VMFUNC;
 		/*
-		 * Advertise EPTP switching unconditionally
-		 * since we emulate it
+		 * Advertise EPTP switching irrespective of hardware support,
+		 * KVM emulates it in software so long as VMFUNC is supported.
 		 */
-		if (enable_ept)
-			msrs->vmfunc_controls =
-				VMX_VMFUNC_EPTP_SWITCHING;
+		if (cpu_has_vmx_vmfunc())
+			msrs->vmfunc_controls = VMX_VMFUNC_EPTP_SWITCHING;
 	}
 
 	/*
-- 
2.17.1

