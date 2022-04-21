Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8B2509B36
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386928AbiDUIx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 04:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386942AbiDUIxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 04:53:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD5A1EAF5;
        Thu, 21 Apr 2022 01:50:29 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L8iL8T014917;
        Thu, 21 Apr 2022 08:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cA99gfnWqwjdSC01xE3f+fIaCuXCXI+txA0ehxbl8K8=;
 b=rZPzqKiEnzloY6oIiUcN6fTwCYPSjxNrTK482epV9ReK7ACPZuH2S0EJmGBKVsVBD5V4
 ghkzeYYfs5Vzgb6FFMTywxMzy8sB1mHMR25MQQ0oiSgGe8IzMbhCxs2n+YbIyN2QW0fu
 gBvM63kwc8uXpCNBEuBJoPU1GtDXQhoCrXvqaAJl5L//d5tCTZ2M5wvqODuwav/LjpQ3
 6gIoSHPZeCxsMX08o/b4Co1EqawFIRHDewJZ7SdpiAsrS6jkFcnVZD1dYUxnDrQJcIAQ
 wfwfW7L0Em9C1i5IhHS8Yvjky+5cCoaVx8hOZ+i21ij7a+TQWnBTV2uzFIqP3ye7uJAo oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fk413g3q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:28 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L8jPEp017240;
        Thu, 21 Apr 2022 08:50:28 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fk413g3pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:28 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23L8ROWe007649;
        Thu, 21 Apr 2022 08:50:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3fgu6u4ec7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 08:50:26 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23L8oNcU42795366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 08:50:23 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CCD8A4053;
        Thu, 21 Apr 2022 08:50:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8BD1A4051;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 08:50:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/3] s390x: smp: make stop stopped cpu look the same as the running case
Date:   Thu, 21 Apr 2022 10:50:21 +0200
Message-Id: <20220421085021.1651688-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220421085021.1651688-1-nrb@linux.ibm.com>
References: <20220421085021.1651688-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bYGO8D13jRbbHNfdc6pIbQgjM7tHb-rZ
X-Proofpoint-GUID: 9flubUzVpUrKiSWyNye20zzxWABSVs3n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=953 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjust the stop stopped CPU case such that it looks the same as the stop running
CPU case: use the nowait variant, handle the error code in the same way and make
the report messages look the same.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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

