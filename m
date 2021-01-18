Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1112F9838
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbhARD2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:28:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:30517 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731643AbhARD2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:32 -0500
IronPort-SDR: eTmZw6PkwbfBLnhkqUOmpV/wY9TC42OZAXhlDcNUq6QrVgJ/ody074/qdk2K7pxuPy2bKiVeI6
 ZARc60HHFvHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165843049"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="165843049"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:50 -0800
IronPort-SDR: FWVF7Od1x+XYTMVbnROpUWhBPiPGpotPeWgYvmbD/JLDmHozO6Q0WA/4xNb7cm/iUwyiGjkGfv
 tZMGuus+HCfw==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150905"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:46 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 07/26] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Mon, 18 Jan 2021 16:27:38 +1300
Message-Id: <a060e5f2ec611efdd83bbd40bbe0a3fcaf405b8b.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5e20b42f2639..bdda631c975b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -12,6 +12,7 @@
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
+#include "virt.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 static int sgx_nr_epc_sections;
@@ -710,7 +711,8 @@ static void __init sgx_init(void)
 	if (!sgx_page_reclaimer_init())
 		goto err_page_cache;
 
-	ret = sgx_drv_init();
+	/* Success if the native *or* virtual EPC driver initialized cleanly. */
+	ret = !!sgx_drv_init() & !!sgx_virt_epc_init();
 	if (ret)
 		goto err_kthread;
 
-- 
2.29.2

