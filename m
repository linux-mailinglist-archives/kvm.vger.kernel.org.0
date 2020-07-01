Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCCD2105CA
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgGAIFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:05:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:2452 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbgGAIEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 04:04:35 -0400
IronPort-SDR: 0MGT5X/ti1ZumtLNeXNg1u+1aOCtRAxAML1JZ2zf3Jp3kpVEi6VVFdzTDWEBONeHtetCEaxUNv
 zkw7tsP+wx9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="145581967"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="145581967"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 01:04:34 -0700
IronPort-SDR: NzHo0OsUtr3zWdFDSv5PoarSpUL/OePkL+T+sYHxbw1DanwxECqECpEudzIZtggQGdOAZGj5mO
 egF4Bk6/Cy9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="455010360"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 01:04:32 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v13 10/11] KVM: x86: Add #CP support in guest exception dispatch
Date:   Wed,  1 Jul 2020 16:04:10 +0800
Message-Id: <20200701080411.5802-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200701080411.5802-1-weijiang.yang@intel.com>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
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
index 3f3f780c8c65..78e5c4266270 100644
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
index 9c16ce65fe74..94ca5b56d233 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -407,6 +407,7 @@ static int exception_class(int vector)
 	case NP_VECTOR:
 	case SS_VECTOR:
 	case GP_VECTOR:
+	case CP_VECTOR:
 		return EXCPT_CONTRIBUTORY;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b968acc0516f..7374e77c91d8 100644
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

