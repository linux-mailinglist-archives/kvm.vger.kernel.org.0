Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A642A8BE2
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbgKFBGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:06:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733138AbgKFBGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:33 -0500
IronPort-SDR: DHhCoO8Oboy8EctR1TdeVd0njltL41IpMaXgRzxd33zhymWJvv/3vCtfsb9+tPFNAsq4PxPBru
 xBm5LXObslWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264709"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:32 -0800
IronPort-SDR: zNjkvGqVCsAUQu7ianTu/Nn/4Ia3SDi+35/hz0sKkbdmGsSFoqaHvO/K8PLEIM0jG9fw24TNzt
 6AGpUEUP/nWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874528"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:30 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 09/13] KVM: x86: Report CET MSRs as to-be-saved if CET is supported
Date:   Fri,  6 Nov 2020 09:16:33 +0800
Message-Id: <20201106011637.14289-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report all CET MSRs, including the synthetic GUEST_SSP MSR, as
to-be-saved, e.g. for migration, if CET is supported by KVM.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 751b62e871e5..d573cadf5baf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1248,6 +1248,8 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 
 	MSR_IA32_XSS,
+	MSR_IA32_U_CET, MSR_IA32_S_CET, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
+	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -5761,6 +5763,13 @@ static void kvm_init_msr_list(void)
 			if (!supported_xss)
 				continue;
 			break;
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
2.17.2

