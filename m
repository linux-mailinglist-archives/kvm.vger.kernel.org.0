Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC630437C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbhAZQMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:12:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:12823 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391220AbhAZJcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:32:06 -0500
IronPort-SDR: 59Lu3EBEhi/mVeX4pIBzuCz6Ls04r8zUk0YagIQ8JLzrbNxj3129j7jukbjtgsmais6RoB/h6x
 qEfGgiOsoHhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179954902"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179954902"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:28 -0800
IronPort-SDR: VQah8dqav3BXJ7aCoJmbdegfoEHn9/h6udr6IZaqC941egdHOZpJhqkwWHCkCxHYBakHz30pvW
 O0pWR9mj4xwQ==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747690"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:31:24 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 10/27] x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
Date:   Tue, 26 Jan 2021 22:31:02 +1300
Message-Id: <5578e5c0af224d8bc4b3e65200ee725287280f9b.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
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
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index abf99bb71fdc..3dbe7aacf552 100644
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

