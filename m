Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C100830D88D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhBCLYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:24:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:28325 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhBCLXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:46 -0500
IronPort-SDR: rsSUxF52B9HMG+JOyjOQ3K4dadTJO37uyAnZ3rGuKS2RENEVy+JUDEe9JrZ0TWt967yWynRB7I
 2ZrMDj2FVe8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981301"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981301"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:23 -0800
IronPort-SDR: dSvR5vZAT9li05iwPSRw5mO523CIBKg59w0CFqjZqIiGlDfIkEZXgXZQ/cAkf2KNE915pDAQ0G
 HA9iiqumxcdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311179"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:21 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 09/14] KVM: x86: Report CET MSRs as to-be-saved if CET is supported
Date:   Wed,  3 Feb 2021 19:34:16 +0800
Message-Id: <20210203113421.5759-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report all CET MSRs, including the synthetic GUEST_SSP MSR, as
to-be-saved, e.g. for migration, if CET is supported by KVM.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6af240d87a33..059e101daf94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1266,6 +1266,8 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_S_CET, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -5828,6 +5830,14 @@ static void kvm_init_msr_list(void)
 			if (!supported_xss)
 				continue;
 			break;
+		case MSR_KVM_GUEST_SSP:
+		case MSR_IA32_U_CET:
+		case MSR_IA32_S_CET:
+		case MSR_IA32_INT_SSP_TAB:
+		case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+			if (!kvm_cet_supported())
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
2.26.2

