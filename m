Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97E716095
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjE3Mxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjE3Mx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:53:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74E4E62;
        Tue, 30 May 2023 05:53:05 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UBe1p0001412;
        Tue, 30 May 2023 12:52:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3/MUmf6RVrTbJWhz8ZWo7HLQ56Zo6u83ZOAVpDo2Mf0=;
 b=AcPzAI1CXd8SGhk2/Q/LnfIVDHK0mOS5ivEK2nKvFPS+gy48faXzJl3NgOyM89zn2mAC
 7og/foFRQDYUtpamggKfZ2BFyvc0G8Jesphl+nQpBDAKJvuj8A8/owtPLdRu8+WP+qMw
 2YeOcGnNxZLslevrmrlM5qpCDghnoJPJguWgeg0gMwt48LhMxTuPIRIyC5sdtQOYmSxA
 9P56DcwJCj0YOiXjUSq7ZdFbnXIvw0BvzkeP0xmtKeiJ4HMA9RH1TyvZVFF54g2iq13o
 IQDhCAh4NRE3J7v4vWDgEweC0/FdBPVlkI8hDJzXpSchJdBFPVHX4WaVzZU+54LD3txT IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwbst1ygt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:50 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UBvBgp025142;
        Tue, 30 May 2023 12:52:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwbst1yg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U4TtWN032765;
        Tue, 30 May 2023 12:52:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g518hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:52:48 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UCqiP642533244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 12:52:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BD5A2004D;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 548212004E;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 12:52:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/2] s390x: sclp: consider monoprocessor on read_info error
Date:   Tue, 30 May 2023 14:52:42 +0200
Message-Id: <20230530125243.18883-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530125243.18883-1-pmorel@linux.ibm.com>
References: <20230530125243.18883-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oqd37jY6Pk4FguE9c8VFciny0ogKBxKt
X-Proofpoint-GUID: GPljcLOhVgRjLn9hSezBQYXpW7X0-VDv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A test would hang if an abort happens before SCLP Read SCP
Information has completed.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index acdc8a9..34a31da 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -119,8 +119,15 @@ void sclp_read_info(void)
 
 int sclp_get_cpu_num(void)
 {
-	assert(read_info);
-	return read_info->entries_cpu;
+	if (read_info)
+		return read_info->entries_cpu;
+	/*
+	 * If we fail here and read_info has not being set,
+	 * it means we failed early and we try to abort the test.
+	 * We need to return at least one CPU, and obviously we have
+	 * at least one, for the smp_teardown to correctly work.
+	 */
+	return 1;
 }
 
 CPUEntry *sclp_get_cpu_entries(void)
-- 
2.31.1

