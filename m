Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE63831ABC1
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBMNac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:30:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:59260 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBMNaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:30:17 -0500
IronPort-SDR: Edc2zQ9MKM7CtmlpVMxrWePWHfFJ8OAvIJUefIGm8p+Rtpqw20AsNMGo+Xr/fYRQ37+iLyWfYh
 f5Yx1ZC0J3jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="161667692"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="161667692"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:36 -0800
IronPort-SDR: 9l07mJqGVjMIBb8sWgKWSp/O/bQYtYWV8uRnn9Na3KzEkZzlQj9Y0ypZ7WWlVduWrwwSPja8oU
 NBNkaKpi/73w==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366025"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:29:33 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 09/26] x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
Date:   Sun, 14 Feb 2021 02:29:11 +1300
Message-Id: <3e2d4ddabf5956998d2405e4158a8433c5fdf9e6.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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

