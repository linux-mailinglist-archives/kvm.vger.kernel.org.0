Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71936C7DE6
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjCXMSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjCXMSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B051BF3
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:19 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OAZQk2023105
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DWZPQ8d7SmYGKEDopGrTrBGnTDgiAK4y6b6JEKgnbaM=;
 b=E0N0RtovJ4QJTCzcIIKmqUDQkjnUpbTTdFkTr/Vhqi+r8OOipBTWl5mtuQlvQcTJVx9Q
 PDKfB6/a5VxruDmXgQZ+ostQ+7eV6Q8ZpoDPyRNXsa6RXE1Orz783h5h1zpKTHFg4aY/
 X2TdRRHfPoH2K8MmvHAhAlcS1Pu8JauV3rxoCbQmi3+3uUgF5eiLtIy4u5PJFDlowYor
 9t01lN+imtbhp2XuNl1evWHTJijxAjtQUPC5vFBAHqez62GSJyba8aJh8BTyiZ621fsX
 4yNYg7Is3wmXS+rWfmjzpMqp3Bo3CZi+dG0UK+zcPbXPZEu98Ix/0sGaX5WLvO2ksy5g 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b29rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBrWwn005182
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:17 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pha8b29r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:17 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NM2ho5028487;
        Fri, 24 Mar 2023 12:18:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pgy7f8nv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCICUD48300476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 417232004D;
        Fri, 24 Mar 2023 12:18:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F172004B;
        Fri, 24 Mar 2023 12:18:11 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/9] s390x: uv-host: Add cpu number check
Date:   Fri, 24 Mar 2023 12:17:20 +0000
Message-Id: <20230324121724.1627-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UT8eQ5VkPnOLtul6QHIXWHDE2J5NJyE7
X-Proofpoint-GUID: cqOZMmLGPGpkzBPKZFhBopjf2mJ3qIsj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should only run a test that needs more than one cpu if a sufficient
number of cpus are available.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 32cbe03f..13e49ed3 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -549,11 +549,15 @@ static void test_init(void)
 	       "storage below 2GB");
 	uvcb_init.stor_origin = tmp;
 
-	smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
-	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x102,
-	       "too many running cpus");
-	smp_cpu_stop(1);
+	if (smp_query_num_cpus() > 1) {
+		smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
+		rc = uv_call(0, (uint64_t)&uvcb_init);
+		report(rc == 1 && uvcb_init.header.rc == 0x102,
+		       "too many running cpus");
+		smp_cpu_stop(1);
+	} else {
+		report_skip("Not enough cpus for 0x102 test");
+	}
 
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 0 && uvcb_init.header.rc == UVC_RC_EXECUTED, "successful");
-- 
2.34.1

