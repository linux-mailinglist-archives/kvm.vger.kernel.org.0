Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0CD2EB7E3
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAFB45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:56:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:27768 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbhAFB45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:56:57 -0500
IronPort-SDR: ngVpgL/c/O4713pFas9H+lEKGPuVmij7W2s6vkMNT4+DCciz4xmaU9HBMGgN6WOjf06c/4h6/r
 bOplIDRO4OqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="241292464"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="241292464"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:16 -0800
IronPort-SDR: yWsnp4qWu2wjPeWWK+OqvXgcXdpOMS6cKMqiupwMbWFCVtGZHOSlLoBm1zf6PKv23ke58oTtu7
 BWGzWnJl16kQ==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993277"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:56:13 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 07/23] x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
Date:   Wed,  6 Jan 2021 14:56:01 +1300
Message-Id: <07980b834b8e10475fa4074a6edf072b724c0450.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the ENCLS leaf definitions to sgx_arch.h so that they can be used
by KVM.  And because they're architectural.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 56b0f8ae3f92..38ef7ce3d3c7 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -22,6 +22,21 @@
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
+enum sgx_encls_function {
+	ECREATE	= 0x00,
+	EADD	= 0x01,
+	EINIT	= 0x02,
+	EREMOVE	= 0x03,
+	EDGBRD	= 0x04,
+	EDGBWR	= 0x05,
+	EEXTEND	= 0x06,
+	ELDU	= 0x08,
+	EBLOCK	= 0x09,
+	EPA	= 0x0A,
+	EWB	= 0x0B,
+	ETRACK	= 0x0C,
+};
+
 /**
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 443188fe7e70..be5c49689980 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -11,21 +11,6 @@
 #include <asm/traps.h>
 #include "sgx.h"
 
-enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-};
-
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
  *
-- 
2.29.2

