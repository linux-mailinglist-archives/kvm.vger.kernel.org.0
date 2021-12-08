Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123C146BEBD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhLGPMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:12:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238544AbhLGPMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:12:52 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821039"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821039"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289781"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:18 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 04/19] kvm: x86: Check guest xstate permissions when KVM_SET_CPUID2
Date:   Tue,  7 Dec 2021 19:03:44 -0500
Message-Id: <20211208000359.2853257-5-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Guest xstate permissions should be set by userspace VMM before vcpu
creation. This patch extends KVM to check the guest permissions in
KVM_SET_CPUID2 ioctl to avoid permission failure at guest run-time
(e.g. when reallocation path is triggered).

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 148003e26cbb..f3c61205bbf4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
+#include <asm/fpu/api.h>
 #include <asm/sgx.h>
 #include "cpuid.h"
 #include "lapic.h"
@@ -97,6 +98,17 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
+	/*
+	 * Check guest permissions for XSTATE features which must
+	 * be enabled dynamically.
+	 */
+	best = cpuid_entry2_find(entries, nent, 7, 0);
+	if (best && cpuid_entry_has(best, X86_FEATURE_AMX_TILE)) {
+		if (!(xstate_get_guest_group_perm() &
+			XFEATURE_MASK_XTILE_DATA))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
