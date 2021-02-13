Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2091231ABBF
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBMNaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:30:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:59256 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBMNaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:30:11 -0500
IronPort-SDR: Iqdpjd7zJPg7gHIcLpD2j213SI5MTaSDlBWnYpT33GOmHH59k6vcHUnixBt4uQpuFMBQUm41uE
 7rwE8ZORDANw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="161667687"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="161667687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:30 -0800
IronPort-SDR: U577CKIIlJ5jR9egwKQqMIrLhzlnI4ODOYUbmlvXOsq8LQptWadQuc9rHFCI1hdK7cIsf5JLuJ
 4TIVT31/s/Fw==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366012"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:26 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 07/26] x86/sgx: Initialize virtual EPC driver even when SGX driver is disabled
Date:   Sun, 14 Feb 2021 02:29:09 +1300
Message-Id: <1ab775bbf5212cd0b85d7a41234cccf710cb1656.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
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

