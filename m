Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B427A28F1
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfH2Vam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:30:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34500 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfH2Vam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:30:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLO41i165266;
        Thu, 29 Aug 2019 21:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=IRPd6orcNHx0Y6eG5a9T/1r/yIaLD4vG8YwlImy2uLM=;
 b=Vv3sYwnFHC+2kfrez3D3wUjVLvwaZ6ZfbZKy4oP+pNnYDRdfrS7i6WVNx/6VB52SEp0y
 beMskABtTZeoe7PCum2coxI9FbFpCIYjCPgLEO3vrTvd7jLPQu1T6RnOsI7Ua9iND0P/
 vk9hmzdBjRVIXv6F3QCN2pZhNKWtVwivhnXhomW3HTpxaa14aWDW+Ssjg/qTSbBrOaUm
 JtD3oKBusjxjNjw8eweK4PodY8ern0yxR/W5tpMLqsgWPFiXtDzF5zF+2dRu3tknGW0g
 vC8KmhYBwDKZ4AeTiJ4cZlGkzgv6XH82/bkh779PEDCDczSJSpi0+vwV/VUNChFW20XZ rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uppjc01ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:30:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE4DH018275;
        Thu, 29 Aug 2019 21:25:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2unvu0mb8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLPJPQ012584;
        Thu, 29 Aug 2019 21:25:19 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:25:18 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/4] kvm-unit-test: nVMX: __enter_guest() should not set "launched" state when VM-entry fails
Date:   Thu, 29 Aug 2019 16:56:34 -0400
Message-Id: <20190829205635.20189-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=923
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=979 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bit# 31 in VM-exit reason is set by hardware in both cases of early VM-entry
failures and VM-entry failures due to invalid guest state. Whenever VM-entry
fails, the nested VMCS is not in "launched" state any more. Hence,
__enter_guest() should not set the "launched" state when a VM-entry fails.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 872ba11..183d11b 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1805,6 +1805,8 @@ static void check_for_guest_termination(void)
  */
 static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 {
+	bool vm_entry_failure;
+
 	TEST_ASSERT_MSG(v2_guest_main,
 			"Never called test_set_guest_func!");
 
@@ -1812,15 +1814,14 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
 			"Called enter_guest() after guest returned.");
 
 	vmx_enter_guest(failure);
+	vm_entry_failure = vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE;
 	if ((abort_flag & ABORT_ON_EARLY_VMENTRY_FAIL && failure->early) ||
-	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE &&
-	    vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {
-
+	    (abort_flag & ABORT_ON_INVALID_GUEST_STATE && vm_entry_failure)) {
 		print_vmentry_failure_info(failure);
 		abort();
 	}
 
-	if (!failure->early) {
+	if (!vm_entry_failure) {
 		launched = 1;
 		check_for_guest_termination();
 	}
-- 
2.20.1

