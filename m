Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC9F1DF3BC
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 03:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387515AbgEWBHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 21:07:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387481AbgEWBHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 21:07:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N12vmE141487;
        Sat, 23 May 2020 01:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=b3wjFY2nfeMXo73nP9tjwYwmaSSSRj72YCwuvzzjD3A=;
 b=nbw9m4B3qT859CBxh2jLOHeFBXRihjs4aIVKHFlUnF6ShaAcCfbG4pYLTD9kktnX6kx/
 I17DabwF9f2XMou17mg45rUitjTmdvHGE7Nh0AkVX263qwL74MlCTK56RgIjGRk9Ke9V
 Lqr4LGm6vkRfdpwTpcvPSTfBSklpiBJDh8niyAep7F/aZPogCK+DOmkNOkzbJK6YPtq6
 j3btXj6tUmo1cXhrimxxL2M4TzdsJo8PUh3uPdmmgb6p2HPwRfH2F6vP4it5c7pY+1DH
 qKDpsANv2Ha9WouLe66yJa6dgChTtVZNskfSNlssGGw8ymNPVhjfveRVQjzSrboI4Gp5 Ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284mg7qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 01:07:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N13LNU110813;
        Sat, 23 May 2020 01:07:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3150259y3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 01:07:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04N174BD021215;
        Sat, 23 May 2020 01:07:04 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 18:07:04 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/3] kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and GUEST_BASE_IDTR on vmentry of nested guests
Date:   Fri, 22 May 2020 20:26:01 -0400
Message-Id: <20200523002603.32450-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
References: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=13 phishscore=0 malwarescore=0
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
SDM vol 3C, the following check is performed on the Guest Descriptor-Table
Registers on vmentry of nested guests:

    - On processors that support Intel 64 architecture, the base-address
      fields must contain canonical addresses.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 68f93d3..fa27d99 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7827,6 +7827,11 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_perf_global_ctrl();
 	test_load_guest_bndcfgs();
 
+#ifdef __x86_64__
+	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
+	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
+#endif
+
 	/*
 	 * Let the guest finish execution
 	 */
-- 
1.8.3.1

