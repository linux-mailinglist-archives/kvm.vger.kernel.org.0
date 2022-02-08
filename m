Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DFD4AD9D7
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356811AbiBHN3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358105AbiBHN24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:28:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3028BC02B66D;
        Tue,  8 Feb 2022 05:25:13 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218DGEJm023540;
        Tue, 8 Feb 2022 13:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tS2oB09IDstAatWzssNQFK/V6UJySOwoBm84tEk+6ao=;
 b=d6+10S+MKn2vsskehjx7qca6b1B8hkFgleU2q7z52NlaSnLU7FXxXqy1FlGW2nPdQXhK
 Rx9zeiPvjd6oFBwUmO1J6+loAkvigHqKoQo4yXUpy2/6YssRI0jGWqMK6RlmGn6OKvjd
 JLKcqvpskoa5ddZ8iChBH5ZVjqLKEL7SZFnMESb7eozBG0Z+aWt6e8Cv6RUuk3QltaNk
 CUzRpuOnQT+Bp57SvZ534x4HUNz7RLwsQTBYqZEBZv3Ie8unZQsbL9NBvPQzWWg62/NA
 eeopAiiDH4qCumlQDtkpMkvMGxhqUZlqKbL6j8KB08P3hxjFdi1stYIYcL8B12ch2zG+ tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355b26ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:12 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218DPBuD020906;
        Tue, 8 Feb 2022 13:25:12 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e355b26k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:12 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218DFngb022520;
        Tue, 8 Feb 2022 13:25:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj4vtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:25:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218DP6gX22151462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 13:25:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CFA542057;
        Tue,  8 Feb 2022 13:25:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFE4D42041;
        Tue,  8 Feb 2022 13:25:05 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.71.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 13:25:05 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 1/4] s390x: lib: Add SCLP toplogy nested level
Date:   Tue,  8 Feb 2022 14:27:06 +0100
Message-Id: <20220208132709.48291-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208132709.48291-1-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w4o6ywJ9tnC5wpibxSJavr2Yh4s24nMa
X-Proofpoint-ORIG-GUID: 9pPFzrf_CXO66Jvg4P4CLQ7t7pDfMD9z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum CPU Topology nested level is available with the SCLP
READ_INFO command inside the byte at offset 15 of the ReadInfo
structure.

Let's return this information to check the number of topology nested
information available with the STSI 15.1.x instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/sclp.c | 6 ++++++
 lib/s390x/sclp.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 33985eb4..e15b3b2c 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -128,6 +128,12 @@ int sclp_get_cpu_num(void)
 	return read_info->entries_cpu;
 }
 
+int sclp_get_stsi_parm(void)
+{
+	assert(read_info);
+	return read_info->stsi_parm;
+}
+
 CPUEntry *sclp_get_cpu_entries(void)
 {
 	assert(read_info);
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index fead007a..541eb441 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -146,7 +146,8 @@ typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
 	uint8_t rnsize;
-	uint8_t  _reserved1[16 - 11];       /* 11-15 */
+	uint8_t  _reserved1[15 - 11];       /* 11-14 */
+	uint8_t stsi_parm;
 	uint16_t entries_cpu;               /* 16-17 */
 	uint16_t offset_cpu;                /* 18-19 */
 	uint8_t  _reserved2[24 - 20];       /* 20-23 */
@@ -323,6 +324,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
+int sclp_get_stsi_parm(void);
 CPUEntry *sclp_get_cpu_entries(void);
 void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
-- 
2.27.0

