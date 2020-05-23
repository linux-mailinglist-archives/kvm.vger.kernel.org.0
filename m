Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD01DF3B8
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387494AbgEWBHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 21:07:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54994 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387475AbgEWBHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 21:07:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N12hvR140755;
        Sat, 23 May 2020 01:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Gif6rYrgQ7jMQBVu8ERVcS36qGe2iNG99oyOQ8j0sBc=;
 b=fgeaX9M4vdDHxj31B3gj6z9o6D7pzRuTh8ejXYa4vVbM7qJNPZ+z60hkC1s/rBsUtkk7
 2LbmTxiBhm0zXGsMCH8urrGVH+mnK/iDxB5GKhp0x9sZH1nJMTMO6vfqRMnMiusCpn93
 IvIejxBb/FQS1XYHirUPqocPgXt6+E4hG6F2Hx0kM9qLeqIQHR6GFrTD99ONwYky11Dl
 jG9ZRMRRhT9RBIAuSzTK8PqAMeiB16AsIyE0uVhsKlsIxTpYfMS92BU0dGleFOGOT1ih
 nw0lacjRLNe8L460cfNwyJsufveVIFP8JyrGErEGNV6VklSI/fWzQy372/85z2E6ORy/ ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284mg7qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 01:07:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N13JVM167319;
        Sat, 23 May 2020 01:07:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3g8ac2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 01:07:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04N1752S006848;
        Sat, 23 May 2020 01:07:05 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 18:07:04 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 3/3] kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and GUEST_LIMIT_IDTR on vmentry of nested guests
Date:   Fri, 22 May 2020 20:26:03 -0400
Message-Id: <20200523002603.32450-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
References: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=13 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005230005
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Descriptor-Table Registers" in Intel
SDM vol 3C, the following checks are performed on the Guest Descriptor-Table
Registers on vmentry of nested guests:

    - Bits 31:16 of each limit field must be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f400408..7b6205d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7836,6 +7836,17 @@ static void vmx_guest_state_area_test(void)
 	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
 #endif
 
+	u32 guest_desc_limit_saved = vmcs_read(GUEST_LIMIT_GDTR);
+	TEST_GUEST_VMCS_FIELD_RESERVED_BITS(16, 31, 4, GUEST_LIMIT_GDTR,
+	    "GUEST_LIMIT_GDTR", guest_desc_limit_saved, "GUEST_LIMIT_GDTR",
+	    true);
+	vmcs_write(GUEST_LIMIT_GDTR, guest_desc_limit_saved);
+	guest_desc_limit_saved = vmcs_read(GUEST_LIMIT_IDTR);
+	TEST_GUEST_VMCS_FIELD_RESERVED_BITS(16, 31, 4, GUEST_LIMIT_IDTR,
+	    "GUEST_LIMIT_IDTR", guest_desc_limit_saved, "GUEST_LIMIT_IDTR",
+	    true);
+	vmcs_write(GUEST_LIMIT_IDTR, guest_desc_limit_saved);
+
 	/*
 	 * Let the guest finish execution
 	 */
-- 
1.8.3.1

