Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C88341669
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhCSHXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:23:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:22827 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233942AbhCSHXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:23:20 -0400
IronPort-SDR: 5m9x6Lm4pqWU1BipH9d4+vuiG/TH7zbeIDrFdnzPdEXhru+JL1AF6KfpOmZHMTrkvTEfP+ssV4
 VnGNVpwobDaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274910844"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="274910844"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:20 -0700
IronPort-SDR: uNxw3ENurhFtG7WXy+Hsr3Q08j3e3i9A7F2MG3mwoieQ7okV4bAuKKaooW55bgUinJkuz1cpsd
 akh27vDbicTg==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409364"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:16 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Fri, 19 Mar 2021 20:23:02 +1300
Message-Id: <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 6a734f484aa7..b73114150ff8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -743,7 +743,15 @@ static int __init sgx_init(void)
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
2.30.2

