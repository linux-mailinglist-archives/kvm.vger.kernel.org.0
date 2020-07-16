Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB67221AB0
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgGPDRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:17:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:8160 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgGPDRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:17:17 -0400
IronPort-SDR: 6tJ9OI36CziBtFvFD2RY87QznhbHv+NDFhc9NN2TMgjNQx4rqfQvclBkBjY9FeNDI1Snf8XpRA
 1H/IXE/Q8aPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210844866"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210844866"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:17:16 -0700
IronPort-SDR: DoNhtr9jlm5GbwGimNXBb0DZIFTwoHK/vmP6i5asBBydbTu3ZCFuXKRcHh/1DaXL18WPdz8h72
 54ZjVgTMengg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="360910490"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Jul 2020 20:17:14 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND v13 10/11] KVM: x86: Add #CP support in guest exception dispatch
Date:   Thu, 16 Jul 2020 11:16:26 +0800
Message-Id: <20200716031627.11492-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200716031627.11492-1-weijiang.yang@intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPU defined #CP(21) to handle CET induced exception, it's accompanied
with several error codes corresponding to different CET violation cases,
see SDM for detailed description. The exception is classified as a
contibutory exception w.r.t #DF.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 1 +
 arch/x86/kvm/x86.h              | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0780f97c1850..fb33cacc8935 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -31,6 +31,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c71a9ceac05e..76892fb0b0a0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -405,6 +405,7 @@ static int exception_class(int vector)
 	case NP_VECTOR:
 	case SS_VECTOR:
 	case GP_VECTOR:
+	case CP_VECTOR:
 		return EXCPT_CONTRIBUTORY;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6eb62e97e59f..53a92fc5f065 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -115,7 +115,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
 {
 	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
 			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
-			BIT(PF_VECTOR) | BIT(AC_VECTOR);
+			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
 
 	return (1U << vector) & exception_has_error_code;
 }
-- 
2.17.2

