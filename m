Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9EB4BA310
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbiBQOfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiBQOff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:35 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D94E2B1A82
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:19 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEB9nX025344
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7P0KavX6jEFumYPIFUs82gOofNE3xLxF+5rmbycY1+k=;
 b=MTdXZz0CTcTifOewuC69enkwQcpbuTP1clkFImwwMM2mVdwj9FsDh4KRpnFg69mElok2
 mvUYgf/cVbFiWyxjMG2Cl2uZZsDfJoSgSgXszLkWMUA4fnv1tgYWAcDqXj7/VW3tr2K4
 JtSIW5es2WRT3wf2L6EKZ7WIk+B7RIg95oAlzkjuTlyK6oY6px2MUGL3eqzd5kw1ga3H
 zNEdg0oru7OMpwdNJFjhaxdnIhKXpy5XMRUZ5S0vkNAC4etq0ubSSx8moW8u+EB/0pFL
 i7IoMB0BPVxuU7rupbTfvJ4IB4rH/xQdSm/zKTmXF+IdNoAUxZp9dRfu61VL4/GLwt9Z KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9q461e7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:19 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HELfCS030629
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9q461e6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXrPW014144;
        Thu, 17 Feb 2022 14:35:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3e64ha12ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZDu337552434
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C38742041;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C4904204B;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 1/9] s390x/cpumodel: give each test a unique output line
Date:   Thu, 17 Feb 2022 15:34:56 +0100
Message-Id: <20220217143504.232688-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ek-LvBqMMUh2u_RS-OKEiwiS5f4k91bJ
X-Proofpoint-ORIG-GUID: uTODsTjxxMGjprwozF3yo-RB0EsCrjBF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 mlxlogscore=711 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

Until now we had multiple tests running under the same prefix. This can
result in multiple identical lines like
SKIP: cpumodel: dependency: facility 5 not present
SKIP: cpumodel: dependency: facility 5 not present

Make this unique by adding a proper prefix.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/cpumodel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 67bb6543..23ccf842 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -116,14 +116,15 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
+		report_prefix_pushf("%d implies %d", dep[i].facility, dep[i].implied);
 		if (test_facility(dep[i].facility)) {
 			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
 				     test_facility(dep[i].implied),
-				     "%d implies %d",
-				     dep[i].facility, dep[i].implied);
+				     "implication not correct");
 		} else {
 			report_skip("facility %d not present", dep[i].facility);
 		}
+		report_prefix_pop();
 	}
 	report_prefix_pop();
 
-- 
2.34.1

