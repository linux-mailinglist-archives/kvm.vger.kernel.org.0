Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F2D30390E
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 10:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389763AbhAZJdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 04:33:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:12748 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391185AbhAZJbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:31:47 -0500
IronPort-SDR: mXX9DhvXVC9dWvDjUFDE1OuMHxs2odvitvnTyW2ObbEGCpFlYWlmtk3GrFFREwkFW7gGzq61P9
 WgKz3pwu479Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179954881"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179954881"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:21 -0800
IronPort-SDR: fh8WUTMAPe4Qujz+F3pL/se8p50TznUJyf4MZbDe8h7GQvMZTO79e3t0r9w1xBun3+LMNofGiZ
 3WQxdUrfsLig==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747650"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Tue, 26 Jan 2021 22:31:00 +1300
Message-Id: <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify sgx_init() to always try to initialize the virtual EPC driver,
even if the bare-metal SGX driver is disabled.  The bare-metal driver
might be disabled if SGX Launch Control is in locked mode, or not
supported in the hardware at all.  This allows (non-Linux) guests that
support non-LC configurations to use SGX.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v2->v3:

 - Changed from sgx_virt_epc_init() to sgx_vepc_init().

---
 arch/x86/kernel/cpu/sgx/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 21c2ffa13870..93d249f7bff3 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -12,6 +12,7 @@
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
+#include "virt.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 static int sgx_nr_epc_sections;
@@ -712,7 +713,8 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
-	ret = sgx_drv_init();
+	/* Success if the native *or* virtual EPC driver initialized cleanly. */
+	ret = !!sgx_drv_init() & !!sgx_vepc_init();
 	if (ret)
 		goto err_kthread;
 
-- 
2.29.2

