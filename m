Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81D56F44EB
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbjEBNVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEBNVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:21:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB195B87;
        Tue,  2 May 2023 06:21:22 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342DL3Rd017183;
        Tue, 2 May 2023 13:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BeuSG80lhZzAxm+xgPSCu6jB8z0XOAYkfECOi77WbmE=;
 b=Xnx0YFRjXkUEVxuApD3uhHGHZv1VR22bwQ+vCrR8qgrQ8FAA9+d3JlLNkGuuKDMQ54Av
 EakoaaWtv5inPuwx0zBO5f57N/WNPVEjiKXR+2IeFjP+VuKzssYsq4Nll8B1bCynCpbu
 jmTV+4LvmmKiyPM5NENJIuGpNj0ciOkOfcK4NeSyl1CUTkUYDBc1Ab10sAgwhz+ZwxWS
 B8QBPdYDXWUM3k7rjOo+FXAkMBhJDJ9+nYoJ1mo0vuCzyGYXSneYyC8DFjsIoPn+Hvr5
 pCO7cHpThuvEJZk1aAv6jWIeCd4/rIENmlxBxmgAHaDUj5SSZyaBdC8LkjmSHRnZerj8 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2gpsrvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:21:20 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342DHc6C029300;
        Tue, 2 May 2023 13:21:18 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2gpsrq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:21:18 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3424qtb1008357;
        Tue, 2 May 2023 13:09:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6sb4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9Msm22807080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56CA02004E;
        Tue,  2 May 2023 13:09:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DB9820040;
        Tue,  2 May 2023 13:09:21 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:21 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/9] s390x: uv-host: Add cpu number check
Date:   Tue,  2 May 2023 13:07:27 +0000
Message-Id: <20230502130732.147210-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IP9y3BeLx-WkM5uJt01b58a2SHpWCfwr
X-Proofpoint-ORIG-GUID: Sf7GsTMmiBNEonwemCFODnmksqHILicC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 1c04d8ef..ed13bc26 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -550,11 +550,15 @@ static void test_init(void)
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

