Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2FD331C6A
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhCIBkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:40:15 -0500
Received: from mga18.intel.com ([134.134.136.126]:36397 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhCIBkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:40:00 -0500
IronPort-SDR: MF5yLKzrJlmHsWWQhgygd0mRjUsBTZdpJnFSPRjIo96oIa7bg74joWErSb8Vg4sWwlt8YfXfE0
 NyqohLUSBP+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175749393"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="175749393"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:59 -0800
IronPort-SDR: B2VibRGs4ynFOeusotQFWT2ts02B0iuv18yCO3gfRP3pJ1cQ0pLmgv5BiIyrvqwq0ap6ECKG3l
 D/QlB9dQz6Sw==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327288"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:55 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Tue,  9 Mar 2021 14:39:40 +1300
Message-Id: <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
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

