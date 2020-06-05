Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855FB1F0061
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgFETWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:22:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgFETWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:22:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JGabq071713;
        Fri, 5 Jun 2020 19:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=pgyzLwohL7e4TRlgOmGBRFjn486CICwNIm8iBlwaOLg=;
 b=jnkFfnFuaU70dmqTL6HH7kDDA19g1zTnKwjAgKUbQSaLFMrmnlFmUrR525RsqnRpKWkg
 Iti9324n51mJMSUYJCJc+Dp4lv0+BQHyCToL6uojvsB1VHsuwbUBnL8GNoNLvQjoTrcP
 HcRT2/i+e6FSxOzIy8quwKb3H1W+sOo9TzBvoj89mdvuNpywpyXcOmCS1NZ4DCTLKh+j
 weCEgdiSaiEjZ/byqgHL8pVGdvKJ0yp4NjVzto9iUiz93ZPevKlkquDeSDp6qDMNKbBg
 caVATIDWsZftREBLlMgYBE+DpUFPog1TFLZVox6mMuFOqeGKfMNbm2zjcps2wWD9N9Pf jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31f91dvdxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 19:22:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JIApr011935;
        Fri, 5 Jun 2020 19:20:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31f927mps1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 19:20:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 055JKYAj002455;
        Fri, 5 Jun 2020 19:20:34 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 19:20:34 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 3/3 v2] kvm-unit-tests: nVMX: Test GUEST_LIMIT_GDTR and GUEST_LIMIT_IDTR on vmentry of nested guests
Date:   Fri,  5 Jun 2020 19:20:22 +0000
Message-Id: <1591384822-71784-4-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=13 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
SDM vol 3C, the following checks are performed on the Guest Descriptor-Table
Registers on vmentry of nested guests:

    - Bits 31:16 of each limit field must be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 7dd8bfb..d13b34d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7834,6 +7834,17 @@ static void vmx_guest_state_area_test(void)
 	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
 	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
 
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

