Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D218716026
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjE3MmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 08:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjE3Ml7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 08:41:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC4F1AE;
        Tue, 30 May 2023 05:41:36 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCOJnd002967;
        Tue, 30 May 2023 12:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H5eb8Q3JYxR53lMbo9Awfz1SU4tK6NY4EGhs0xSeaxc=;
 b=NY5guQCWVB5PREaFEfS6fzXcjTd3UznRriVJ51D5uSWcR08W5do1sYVKXXmX3EDkJw1l
 i3stVDhzq5179Hfc1P5nXvM0AZ+GkBUblGz5iy+f5zQNVirQXrdmhIz3EaJTJSqGA6p6
 C5KIG/xOl7eSufLPkB6OBvCAQXSsdOQFUIZrpAr4LFlfcLKFdvNs0thLIdDZBrhNAK+4
 3PMJo4hEHdsLH4Saa5o86jcBJUji/vUVDRhJEDXoUsbUhRO1pZuQRX1nv84dvp48aAj+
 BZEA8hTPJNUV9AnX4Rlp8qtyqJFj5xHpomGX9nCl7ygJBEZ636parW9gKcGZe1ND3m+9 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh46rghw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:04 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34UCPBku005122;
        Tue, 30 May 2023 12:41:04 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qwh46rggu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34U5OjdF010603;
        Tue, 30 May 2023 12:41:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qu9g518dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 May 2023 12:41:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34UCevCL20382234
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 May 2023 12:40:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCB0320040;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 840BF2004B;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 30 May 2023 12:40:57 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] s390x: sclp: consider monoprocessor on read_info error
Date:   Tue, 30 May 2023 14:40:55 +0200
Message-Id: <20230530124056.18332-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230530124056.18332-1-pmorel@linux.ibm.com>
References: <20230530124056.18332-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eQ1sh7eaACl6RH2lZr_jXLuk_kMsU-dN
X-Proofpoint-GUID: tqSOjvUzm4qXunRuvnvfx-JVWbWahjox
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

A kvm-unit-test would hang if an abort happens before SCLP Read SCP
Information has completed if sclp_get_cpu_num() does not report at
least one CPU.
Since we obviously have one, report it.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 12919ca..34a31da 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -121,6 +121,12 @@ int sclp_get_cpu_num(void)
 {
 	if (read_info)
 		return read_info->entries_cpu;
+	/*
+	 * If we fail here and read_info has not being set,
+	 * it means we failed early and we try to abort the test.
+	 * We need to return at least one CPU, and obviously we have
+	 * at least one, for the smp_teardown to correctly work.
+	 */
 	return 1;
 }
 
-- 
2.31.1

