Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDE44A7263
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 14:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbiBBNzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 08:55:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232546AbiBBNzM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 08:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643810112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HLhl4bBPmyrydvFytaTsMCBmf2VczsHEP3qhhK1U8wk=;
        b=bRqbqVcWtsqviYJqJyoDrpoO4ZlO4Nl906BBxm3w7UEJcWpyv9RKVrmI889IcdFhzJlw6T
        uQnOzlMuI5lzp9MQB0ziAbscE2NNVJWRC7Lg0ae5UVqfTMYIXil9Ju/D2z/VXi7qR+cdYJ
        Ix8EcqoMman9shraFFWAONW2H4aeM+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-HjeJSL3aPYOu5sR-upDznA-1; Wed, 02 Feb 2022 08:55:11 -0500
X-MC-Unique: HjeJSL3aPYOu5sR-upDznA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4240484DA40
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 13:55:10 +0000 (UTC)
Received: from virtlab612.virt.lab.eng.bos.redhat.com (virtlab612.virt.lab.eng.bos.redhat.com [10.19.152.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3E1C798D5;
        Wed,  2 Feb 2022 13:55:09 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org
Subject: [kvm-unit-tests v2 PATCH] vmx: Fix EPT accessed and dirty flag test
Date:   Wed,  2 Feb 2022 08:55:09 -0500
Message-Id: <20220202135509.3286-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If ept_ad is not supported by the processor or has been
turned off via kvm module param, test_ept_eptp() will
incorrectly leave EPTP_AD_FLAG set in variable eptp
causing the following failures of subsequent
test_vmx_valid_controls calls:

FAIL: Enable-EPT enabled; reserved bits [11:7] 0: vmlaunch succeeds
FAIL: Enable-EPT enabled; reserved bits [63:N] 0: vmlaunch succeeds

Signed-off-by: Cathy Avery <cavery@redhat.com>
---

* Changes in v2:

- Initialize vmcs EPTP to good values for page walk len
  and ept memory type.
- Restore eptp to known good values from eptp_saved
- Cleanup test_vmx_vmlaunch to generate clearer and
  more consolidated test reports.
  New format suggested by seanjc@google.com
---
 x86/vmx_tests.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3d57ed6..1269829 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3392,14 +3392,21 @@ static void test_vmx_vmlaunch(u32 xerror)
 	bool success = vmlaunch_succeeds();
 	u32 vmx_inst_err;
 
-	report(success == !xerror, "vmlaunch %s",
-	       !xerror ? "succeeds" : "fails");
-	if (!success && xerror) {
-		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+	if (!success)
+	vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+
+	if (success && !xerror)
+		report_pass("VMLAUNCH succeeded as expected");
+	else if (success && xerror)
+		report_fail("VMLAUNCH succeeded unexpectedly, wanted VM-Fail with error code = %d",
+			    xerror);
+	else if (!success && !xerror)
+		report_fail("VMLAUNCH hit unexpected VM-Fail with error code = %d",
+			    vmx_inst_err);
+	else
 		report(vmx_inst_err == xerror,
-		       "VMX inst error is %d (actual %d)", xerror,
-		       vmx_inst_err);
-	}
+		       "VMLAUNCH hit VM-Fail as expected, wanted error code %d, got %d",
+		       xerror, vmx_inst_err);
 }
 
 /*
@@ -4707,12 +4714,11 @@ static void test_ept_eptp(void)
 {
 	u32 primary_saved = vmcs_read(CPU_EXEC_CTRL0);
 	u32 secondary_saved = vmcs_read(CPU_EXEC_CTRL1);
-	u64 eptp_saved = vmcs_read(EPTP);
 	u32 primary = primary_saved;
 	u32 secondary = secondary_saved;
-	u64 eptp = eptp_saved;
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
+	u64 eptp_saved, eptp;
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
 	    (ctrl_cpu_rev[1].clr & CPU_EPT))) {
@@ -4720,6 +4726,9 @@ static void test_ept_eptp(void)
 		return;
 	}
 
+	setup_dummy_ept();
+	eptp = eptp_saved = vmcs_read(EPTP);
+
 	/* Support for 4-level EPT is mandatory. */
 	report(is_4_level_ept_supported(), "4-level EPT support check");
 
@@ -4742,8 +4751,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPT_MEM_TYPE_MASK) | 6ul;
+	eptp = eptp_saved;
 
 	/*
 	 * Page walk length (bits 5:3).  Note, the value in VMCS.EPTP "is 1
@@ -4762,9 +4770,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
-	    3ul << EPTP_PG_WALK_LEN_SHIFT;
+	eptp = eptp_saved;
 
 	/*
 	 * Accessed and dirty flag (bit 6)
@@ -4784,6 +4790,7 @@ static void test_ept_eptp(void)
 		eptp |= EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, false);
 	}
+	eptp = eptp_saved;
 
 	/*
 	 * Reserved bits [11:7] and [63:N]
@@ -4802,8 +4809,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
-
-	eptp = (eptp & ~(EPTP_RESERV_BITS_MASK << EPTP_RESERV_BITS_SHIFT));
+	eptp = eptp_saved;
 
 	maxphysaddr = cpuid_maxphyaddr();
 	for (i = 0; i < (63 - maxphysaddr + 1); i++) {
@@ -4822,6 +4828,7 @@ static void test_ept_eptp(void)
 			test_vmx_invalid_controls();
 		report_prefix_pop();
 	}
+	eptp = eptp_saved;
 
 	secondary &= ~(CPU_EPT | CPU_URG);
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
-- 
2.31.1

