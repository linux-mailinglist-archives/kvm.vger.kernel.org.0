Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B074FDC9A
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349477AbiDLKgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359296AbiDLK0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:26:19 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132C2554A1;
        Tue, 12 Apr 2022 02:30:28 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C7n0LA018780;
        Tue, 12 Apr 2022 09:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=harjNjeLgb3SC+YUmWLa7FHRrYn8heCn+ZHOscjU10k=;
 b=WmK7sjmhuIN3XXwjR5xduIQXqR7LnQlxXiAYpAziuV+S58KPYNyk001sWEOf+DRXAGFe
 VYt7xgxWY4n2KH9wTxuiJ54WhjdClyLhM8B2ang8YOAOEow+qDRkAWqLeNmCI8TLFo1T
 Sakri5tm+5OMYKO6k3d3d9gH3+2a3MSCFJAoLqPAZGLEq0soSD2tVw8uBXQ7MP4ftGeY
 Q/N4qMgCf4F0JfPg7IWxi8bZkRlJAnUBTM7DzDEuz96L7salv3vv6oSMg6m0c1hL8cFU
 v1Hal+DByLDA6w4JerYpo6r7YZp4dRwGQhkBynRIUZJ3ck0tyVvMntu8vmEP2G6ZO6Gg Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd2quw94t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:30:28 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23C9URrp030639;
        Tue, 12 Apr 2022 09:30:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fd2quw946-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:30:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23C9BhZ2015408;
        Tue, 12 Apr 2022 09:30:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fb1dj4k7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:30:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23C9Hr2v43057442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 09:17:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2E594C046;
        Tue, 12 Apr 2022 09:30:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE1D4C04E;
        Tue, 12 Apr 2022 09:30:22 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Apr 2022 09:30:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 3/3] s390x: smp: make stop stopped cpu look the same as the running case
Date:   Tue, 12 Apr 2022 11:30:22 +0200
Message-Id: <20220412093022.21378-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v5aZaTdU_GxIKQaiFGfGtT9dWfDYEYhi
X-Proofpoint-ORIG-GUID: HJZRix2QeikgGfhwej9XVzGTeBsbA0xW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-12_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 spamscore=0 adultscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=884
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204120042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjust the stop stopped CPU case such that it looks the same as the stop running
CPU case: use the nowait variant, handle the error code in the same way and make
the report messages look the same.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 5257852c35a7..de3aba71c956 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -144,8 +144,9 @@ static void test_stop(void)
 	report(smp_cpu_stopped(1), "cpu stopped");
 
 	report_prefix_push("stop stopped CPU");
-	report(!smp_cpu_stop(1), "STOP succeeds");
-	report(smp_cpu_stopped(1), "CPU is stopped");
+	rc = smp_cpu_stop_nowait(1);
+	report(!rc, "return code");
+	report(smp_cpu_stopped(1), "cpu stopped");
 	report_prefix_pop();
 
 	report_prefix_pop();
-- 
2.31.1

