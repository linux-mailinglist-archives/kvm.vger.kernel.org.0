Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9901159C5
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfLFXtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:49:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLFXtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:49:45 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6Nnajv086259;
        Fri, 6 Dec 2019 23:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=M2ZmxtepfkEQAKsamj7tE+Rd2mHwl5/582CpOGHbwBA=;
 b=oQU8EMWFEKimzqsr+a3pu/rpQw8AlQgmIlYD95UQvd4HOk1QV50Ir/vrH6AL8GHahfWG
 ZWaiWyjzkCs1DlggepQlCnapU3TB3dr4QfxEQ2VS4m8nFPrRx9hsoTaffwfK0TZvIcoH
 +TEbK7lFclMn3jTtFwCY43+YpVUm14f9QfaoxIKkJx3T6zcSp3r669qYLVJ41aDHIffV
 G5hTDrFvrAG7C8W05cMZmCQXVTYPHxpOeyy8UmoK10Q36nxDQnxv22njEE1szu6M1J4P
 pzrX/q0EHx2rMPKsYDXGYV20ZY4EI9+LI2U4EfOqoGC8m2CXaltFnMmFDNvCZ97ujCNx TQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wkfuuy24h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6Nn7m8023633;
        Fri, 6 Dec 2019 23:49:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wqt45jt9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6NndrC025849;
        Fri, 6 Dec 2019 23:49:39 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 15:49:39 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 4/4] kvm-unit-test: nVMX: Test GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on vmentry of nested guests
Date:   Fri,  6 Dec 2019 18:13:02 -0500
Message-Id: <20191206231302.3466-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
References: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
    contain a canonical address."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5f836d4..2dbc0bf 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7219,9 +7219,9 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 			report_prefix_pop();
 		} else {
 			enter_guest();
-			report_guest_state_test("%s",
+			report_guest_state_test("Test canonical address",
 						VMX_VMCALL, addr_saved,
-						"GUEST_XXXXXXX");
+						field_name);
 		}
 
 		vmcs_write(field, NONCANONICAL);
@@ -7232,11 +7232,9 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 			report_prefix_pop();
 		} else {
 			enter_guest_with_invalid_guest_state();
-			report_guest_state_test("ENT_LOAD_PAT "
-					        "enabled",
+			report_guest_state_test("Test canonical address",
 					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-					        addr_saved,
-					        "GUEST_PAT");
+					        NONCANONICAL, field_name);
 		}
 
 		vmcs_write(field, addr_saved);
@@ -7247,11 +7245,9 @@ static void test_canonical(u64 field, const char * field_name, bool host)
 			report_prefix_pop();
 		} else {
 			enter_guest_with_invalid_guest_state();
-			report_guest_state_test("ENT_LOAD_PAT "
-					        "enabled",
+			report_guest_state_test("Test canonical address",
 					        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
-					        addr_saved,
-					        "GUEST_PAT");
+					        NONCANONICAL, field_name);
 		}
 	}
 }
@@ -7450,6 +7446,13 @@ static void vmx_guest_state_area_test(void)
 	vmx_set_test_stage(1);
 	test_set_guest(guest_state_test_main);
 
+	/*
+	 * The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field
+	 * must each contain a canonical address.
+	 */
+	test_canonical(GUEST_SYSENTER_ESP, "GUEST_SYSENTER_ESP", false);
+	test_canonical(GUEST_SYSENTER_EIP, "GUEST_SYSENTER_EIP", false);
+
 	test_load_guest_pat();
 	test_guest_efer();
 	test_load_guest_perf_global_ctrl();
-- 
2.20.1

