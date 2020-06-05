Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997771F005F
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgFETWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:22:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40752 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgFETWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:22:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JGabZ071725;
        Fri, 5 Jun 2020 19:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6lwhDaRXiHcUzHZH2+C9hBV3CaBzPiRBMGi/fm0qcSE=;
 b=RplfaFNhAvHspqK8Z1NZUy8fJRaXZq7qRHPIaCD6jyk3pZcaGSk0rPdmTM75PTwPgJjZ
 yEnDn/DbiCo40h5sGnmsmUe+iRAJ4s1idxh4W5pXqSnkYu5uRAZ+707pZmtd+hT1Ayl/
 zEwRnaFT9vDnCPSz+UBoIiNVWZ6A2HmiwXufHu8O775gsRrXHEb/XKqdWF+zitFrbVoP
 hHVhty807Ai7zgaYRyHLtJ2DFfoSHqLK8vhORylTNs074sFU4pAZ5WhFDtbbvPp2XNyW
 GucBrkBXyHNDt599IyuJde/kJcgu6gmE4kdvkZ1tT+1jj5Gp0Gmm6G9yan9XrEq4JweZ kQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31f91dvdxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 19:22:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JHdNh185819;
        Fri, 5 Jun 2020 19:20:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31f925ujnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 19:20:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055JKXET017168;
        Fri, 5 Jun 2020 19:20:33 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 19:20:33 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/3 v2] kvm-unit-tests: nVMX: Test GUEST_BASE_GDTR and GUEST_BASE_IDTR on vmentry of nested guests
Date:   Fri,  5 Jun 2020 19:20:20 +0000
Message-Id: <1591384822-71784-2-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=13
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006050141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 cotscore=-2147483648 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=13 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050141
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
 x86/vmx_tests.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 68f93d3..4308ef3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7827,6 +7827,9 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_perf_global_ctrl();
 	test_load_guest_bndcfgs();
 
+	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
+	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
+
 	/*
 	 * Let the guest finish execution
 	 */
-- 
1.8.3.1

