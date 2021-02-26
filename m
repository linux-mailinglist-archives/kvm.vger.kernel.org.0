Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27F732627F
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhBZMQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:16:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:44724 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhBZMPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:15:41 -0500
IronPort-SDR: Q5nr1w0wAN3LlmbONhQIWw08d3HKt1JOTIXveIkdYCtLUvhU/HTSCrr63rYCborxtmmwc/9oeS
 9eIPuTm9VUvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185979912"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="185979912"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:25 -0800
IronPort-SDR: MHUmkDgLZzn/+Nf8jTdUCcVpZ6FBIF+5jjxwg85yxt5Cg7ccxRuyc/XBfVWrsWMNQlDGNUsH2o
 GYuZhbuwzNDA==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420528"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:15:22 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 07/25] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Sat, 27 Feb 2021 01:15:06 +1300
Message-Id: <fe9713e99f4c664bedd660549dd3063896eb5c7b.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify sgx_init() to always try to initialize the virtual EPC driver,
even if the SGX driver is disabled.  The SGX driver might be disabled
if SGX Launch Control is in locked mode, or not supported in the
hardware at all.  This allows (non-Linux) guests that support non-LC
configurations to use SGX.

Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v5->v6:

 - No code change. Added Dave's Acked-by.

v4->v5:

 - No code change.

v3->v4:

 - Added comment to explain virtual EPC driver can be supported in both cases
   that SGX driver is not supported, or failed to initialize, per Dave and
   Jarkko.
 - Removed "virt.h" inclusion since it was removed in previous patch, per Dave.

v2->v3:

 - Changed from sgx_virt_epc_init() to sgx_vepc_init().

---
 arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 44fe91a5bfb3..8c922e68274d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -712,7 +712,15 @@ static int __init sgx_init(void)
 		goto err_page_cache;
 	}
 
-	ret = sgx_drv_init();
+	/*
+	 * Always try to initialize the native *and* KVM drivers.
+	 * The KVM driver is less picky than the native one and
+	 * can function if the native one is not supported on the
+	 * current system or fails to initialize.
+	 *
+	 * Error out only if both fail to initialize.
+	 */
+	ret = !!sgx_drv_init() & !!sgx_vepc_init();
 	if (ret)
 		goto err_kthread;
 
-- 
2.29.2

