Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D4374F189
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjGKOQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjGKOQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683819AA
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:36 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BECh23017147;
        Tue, 11 Jul 2023 14:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=O/5ScFUz9wRThzQTY3i8yeYKDjfdJb7tkxNV5o3g/Q0=;
 b=add7+yvvtYIvFMsK6rPHqiZWEfHOfZ43glpxG4ET+IquSdnn+R5bCjTdJuJgis1HGDlE
 JEDhtlQgcbw4g71iKgeM4RPiL5VITASIhf/X+jqR5Ft8pWWfwqneDBev8cy7K/EVzLCf
 nSm+QgbrWil6MUO5YtkYqA1CZ/YtElLzmw9+/hVs/81Yy40LT1w6EMIZ80smTsLdVEpv
 ICrpNp00CMzymv7bWVeCFMF/VdtozfGh+Yg63UZ3byreR5mxewotrHdE9Jex8Xlr9tGj
 RL1zBWNwZYwIKsvFV2t3LCxlyAu3b25rCJ/Hrhhzn17Q/ThEgZrtRLr1xe0a+ZSsA6rY Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my8606-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:27 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEEF56026857;
        Tue, 11 Jul 2023 14:16:26 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8my85x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:26 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEFiNJ019772;
        Tue, 11 Jul 2023 14:16:24 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqmu0r144-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:24 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGLMN20906692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5D3420043;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37ABB20040;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [PATCH 19/22] s390x: sclp: treat system as single processor when read_info is NULL
Date:   Tue, 11 Jul 2023 16:15:52 +0200
Message-ID: <20230711141607.40742-20-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7vI_kP7TyoS-d9omefuY7ScSd6I8uyby
X-Proofpoint-ORIG-GUID: 5uo6FVqm6qa1IdgMmtvEy3UaLAR3gYAp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=573 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

When a test abort()s before SCLP read info is completed, the assertion
on read_info in sclp_read_info() will fail. Since abort() eventually
calls smp_teardown() which in turn calls sclp_get_cpu_num(), this will
cause an infinite abort() chain, causing the test to hang.

Fix this by considering the system single processor when read_info is
missing.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230601164537.31769-2-pmorel@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sclp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 390fde7..15662aa 100644
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
+	 * Don't abort here if read_info is NULL since abort() calls
+	 * smp_teardown() which eventually calls this function and thus
+	 * causes an infinite abort() chain, causing the test to hang.
+	 * Since we obviously have at least one CPU, just return one.
+	 */
+	return 1;
 }
 
 CPUEntry *sclp_get_cpu_entries(void)
-- 
2.41.0

