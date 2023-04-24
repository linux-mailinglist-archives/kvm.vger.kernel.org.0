Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF2E6ED3CE
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjDXRmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjDXRml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:42:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF79072BC;
        Mon, 24 Apr 2023 10:42:28 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33OHb6TJ026416;
        Mon, 24 Apr 2023 17:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FJqT2us/IqaN+hjvIKDXTC81BDXlrZ/2woISC2ePFIw=;
 b=L8A4lZO+LfIRXxoWTFVPphBJs3ci8I9ZjscgDCSaLRFw557M0dVbllYPi0pDwG17SIxF
 s9/gsKec9RU7A1SbMna4+UKEFveExScEAKwLKOLsMWv+OX0sPXU3t0R+WIzqZaaVg6ZR
 muLIs/kmAWsmHUJLr08d/mD4pteVxP95L11m2knVxkMBPnjLBchmjOy0l7zv8nFFF2db
 Aa9WLEmnsvTpKwJ+CHN7VV8PV1MKpxgFdEM9V/qqC48qVfDXv9DCMnD6JaHrFk1BB8Kx
 mCxtjhz+z/DD8g6bEfAbcyezVigza2Fyk/SO2rtDI9aslX4IFGxM8AVSgNJ1bQL7Rdp9 jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q47r7wwh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:28 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33OHeD8p010030;
        Mon, 24 Apr 2023 17:42:27 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q47r7wwfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33OFbAko018839;
        Mon, 24 Apr 2023 17:42:24 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3q477711xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Apr 2023 17:42:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33OHgLX927591184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 17:42:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B8FD20040;
        Mon, 24 Apr 2023 17:42:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F8CA20043;
        Mon, 24 Apr 2023 17:42:20 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.94.57])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Apr 2023 17:42:20 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/1] s390x: sclp: consider monoprocessor on read_info error
Date:   Mon, 24 Apr 2023 19:42:18 +0200
Message-Id: <20230424174218.64145-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230424174218.64145-1-pmorel@linux.ibm.com>
References: <20230424174218.64145-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oLcbTTzsZtSbBuIe8dqg4O2f1N21IY09
X-Proofpoint-ORIG-GUID: hNwbMAHITAQKo445RV-XUn65s0meMZBN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_11,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=957 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304240158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we can not read SCP information we can not abort during
sclp_get_cpu_num() because this function is called during exit
and calling it will lead to an infnite loop.

The loop is:
abort() -> exit() -> smp_teardown() -> smp_query_num_cpus() ->
sclp_get_cpu_num() -> assert() -> abort()

Since smp_setup() is done after sclp_read_info() inside setup() this
loop happens when only the start processor is running.
Let sclp_get_cpu_num() return 1 in this case.

Fixes: 52076a63d569 ("s390x: Consolidate sclp read info")
Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index acdc8a9..c09360d 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -119,8 +119,9 @@ void sclp_read_info(void)
 
 int sclp_get_cpu_num(void)
 {
-	assert(read_info);
-	return read_info->entries_cpu;
+    if (read_info)
+	    return read_info->entries_cpu;
+    return 1;
 }
 
 CPUEntry *sclp_get_cpu_entries(void)
-- 
2.31.1

