Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2819530D87B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhBCLXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:23:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:28338 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234195AbhBCLXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:06 -0500
IronPort-SDR: 8pkWx1L0peDIjhYhCHK5imLU/GxoR9voIzkaPBRFSamCJBwa0lWAXipF7N9vxkXoi5P8NQvzHs
 vGXS7cKe5YSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981271"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981271"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:14 -0800
IronPort-SDR: M4zHD+Q03G2Ok+udSDHIqeh6al9FYjqTgWd+hQV7kFlEtbY8Z4AYeu6gQ7NYoVd8Ywa0kfpZ8T
 QHcfXq0qwL0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311119"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:12 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception dispatch
Date:   Wed,  3 Feb 2021 19:34:11 +0800
Message-Id: <20210203113421.5759-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add handling for Control Protection (#CP) exceptions, vector 21, used
and introduced by Intel's Control-Flow Enforcement Technology (CET).
relevant CET violation case.  See Intel's SDM for details.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 1 +
 arch/x86/kvm/x86.h              | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 8e76d3701db3..507263d1d0b2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -32,6 +32,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define CP_VECTOR 21
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 99f787152d12..d9d3bae40a8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -436,6 +436,7 @@ static int exception_class(int vector)
 	case NP_VECTOR:
 	case SS_VECTOR:
 	case GP_VECTOR:
+	case CP_VECTOR:
 		return EXCPT_CONTRIBUTORY;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..bdbd0b023ecc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -116,7 +116,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
 {
 	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
 			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
-			BIT(PF_VECTOR) | BIT(AC_VECTOR);
+			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
 
 	return (1U << vector) & exception_has_error_code;
 }
-- 
2.26.2

