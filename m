Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671E1C6B6A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgEFITv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:35429 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbgEFITv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:51 -0400
IronPort-SDR: v7JvIQHH5Y6uE5PDex6CsD3moZdxVgYsELgtwFr9AEoQqwi7ussCRuUqVVldJ5FIwGa8B6YufS
 UTMWqq3tU9eQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:50 -0700
IronPort-SDR: DuAY0jRRlZ3zyVcuJ4CK8aFLVrysBKHAsOmhKD0sLBa8na84w+uk7KsObMEsuv8Qqh+kVEK1MF
 2jXSpJ4q6/aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030127"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:48 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 09/10] KVM: x86: Add #CP support in guest exception dispatch
Date:   Wed,  6 May 2020 16:21:08 +0800
Message-Id: <20200506082110.25441-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
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
index 1ba91101e6e6..5f7ee1129711 100644
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

