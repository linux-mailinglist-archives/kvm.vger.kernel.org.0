Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A87C71EF68
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjFAQps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAQpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 12:45:47 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616F5D1;
        Thu,  1 Jun 2023 09:45:46 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351Gghfc012813;
        Thu, 1 Jun 2023 16:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CocCYhN7bwfs0Dd45RZPjUIVTOg/X+Vcd8WCw5O32EY=;
 b=nd9kOlT+dZBsKf1zxF3kut98B6LY6GN6zdDihypPwWFzRPfkKhiCisSyaZVfkkuW1KhC
 FlNPLn/HogMct9hyE4fIUSaWkUxGAX4vDMLWV+uwxQpp0gsxTLGZTQzobUPh3loL6jYK
 OzSffRn87LUAHMcvxZyq87WtdTJhJKL2DrEcA8KCsguYQ9c4j0Ko+uVbOiWIcfl5Nqxj
 pQmc84Ns9SDPHS/cj9k9+DaHPOQ7Tmdvo4l7vjSZ2imDuXWCHyasj+61/Q6x/0IpJwxo
 dVRMScQphK5FE7lQlyvLw6yVCp/x9BiY2EHHOBnDDfhxlP9Rp8NGI8JVQUmEH1qDiTnF yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxy36r314-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:45 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351GhK9a014781;
        Thu, 1 Jun 2023 16:45:45 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxy36r308-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:45 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3514pP1q022818;
        Thu, 1 Jun 2023 16:45:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g52n61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 16:45:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351GjdWk42336732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 16:45:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6DA920040;
        Thu,  1 Jun 2023 16:45:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F26820043;
        Thu,  1 Jun 2023 16:45:39 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.12.131])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 16:45:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v5 1/2] s390x: sclp: treat system as single processor when read_info is NULL
Date:   Thu,  1 Jun 2023 18:45:36 +0200
Message-Id: <20230601164537.31769-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230601164537.31769-1-pmorel@linux.ibm.com>
References: <20230601164537.31769-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 80BGnOEIfTv0hQR_6GsHHc-LVdQs_mvV
X-Proofpoint-GUID: 3Rqg12Pvrc0oLgpmzm_hvDegWFIBoPk6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=653 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010144
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a test abort()s before SCLP read info is completed, the assertion
on read_info in sclp_read_info() will fail. Since abort() eventually
calls smp_teardown() which in turn calls sclp_get_cpu_num(), this will
cause an infinite abort() chain, causing the test to hang.

Fix this by considering the system single processor when read_info is
missing.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sclp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index acdc8a9..adf357b 100644
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
2.31.1

