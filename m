Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC94155D1A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgBGRnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:43:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:13003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgBGRmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="312095676"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2020 09:42:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 2/4] nVMX: Refactor the EPT/VPID MSR cap check to make it readable
Date:   Fri,  7 Feb 2020 09:42:42 -0800
Message-Id: <20200207174244.6590-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207174244.6590-1-sean.j.christopherson@intel.com>
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the EPT_CAP_* and VPID_CAP_* defines to declare which bits are
reserved in MSR_IA32_VMX_EPT_VPID_CAP.  Encoding the reserved bits in
a 64-bit literal is difficult to read, even more difficult to update,
and error prone, as evidenced by the check allowing bit 39 to be '1',
despite it being reserved to zero in Intel's SDM.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 21 ++++++++++++++++++++-
 x86/vmx.h |  3 ++-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 0f2521b..3a99d27 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1537,8 +1537,27 @@ static void test_vmx_caps(void)
 	       (val & 0xfffffffffffffc01Ull) == 0,
 	       "MSR_IA32_VMX_VMCS_ENUM");
 
+	fixed0 = -1ull;
+	fixed0 &= ~(EPT_CAP_WT |
+		    EPT_CAP_PWL4 |
+		    EPT_CAP_UC |
+		    EPT_CAP_WB |
+		    EPT_CAP_2M_PAGE |
+		    EPT_CAP_1G_PAGE |
+		    EPT_CAP_INVEPT |
+		    EPT_CAP_AD_FLAG |
+		    EPT_CAP_ADV_EPT_INFO |
+		    EPT_CAP_INVEPT_SINGLE |
+		    EPT_CAP_INVEPT_ALL |
+		    VPID_CAP_INVVPID |
+		    (1ull << 39) |
+		    VPID_CAP_INVVPID_ADDR |
+		    VPID_CAP_INVVPID_CXTGLB |
+		    VPID_CAP_INVVPID_ALL |
+		    VPID_CAP_INVVPID_CXTLOC);
+
 	val = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-	report((val & 0xfffff07ef98cbebeUll) == 0,
+	report((val & fixed0) == 0,
 	       "MSR_IA32_VMX_EPT_VPID_CAP");
 }
 
diff --git a/x86/vmx.h b/x86/vmx.h
index e8035fc..44f0fdd 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -587,9 +587,10 @@ enum vm_instruction_error_number {
 #define EPT_CAP_2M_PAGE		(1ull << 16)
 #define EPT_CAP_1G_PAGE		(1ull << 17)
 #define EPT_CAP_INVEPT		(1ull << 20)
+#define EPT_CAP_AD_FLAG		(1ull << 21)
+#define EPT_CAP_ADV_EPT_INFO	(1ull << 22)
 #define EPT_CAP_INVEPT_SINGLE	(1ull << 25)
 #define EPT_CAP_INVEPT_ALL	(1ull << 26)
-#define EPT_CAP_AD_FLAG		(1ull << 21)
 #define VPID_CAP_INVVPID	(1ull << 32)
 #define VPID_CAP_INVVPID_ADDR   (1ull << 40)
 #define VPID_CAP_INVVPID_CXTGLB (1ull << 41)
-- 
2.24.1

