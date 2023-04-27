Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16F16F022C
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 09:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243175AbjD0HzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 03:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243092AbjD0HzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 03:55:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2647F1FCE;
        Thu, 27 Apr 2023 00:55:00 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R7RsKg011910;
        Thu, 27 Apr 2023 07:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7KDMLRcP7EMv4sR5rEIDfakZszXyox4OQYrWkzK77q0=;
 b=N/jBIsmAuENvMGX0rJpXu4jpovXtNJSbXGBZRKII+Am6AmumGAQA3mqgLMkD5O+7IWQd
 DE+WP2LD+UUC8HfVAOQG65L55ElPuuBpMKtWKuYozBQuz6/UlWrrGnjTXl6PmaDOI4/i
 SbE3UD8ROPnF9h2baUtn5HidELbeWTqEasD+jdo+JCr+431G2RjoaKa9wpD0KHKnNfFJ
 M09i1EC4f+aqRCVrvndN1jwjxDvgPGdSCktWGuvEbdJslyr4zxvGC8LQB54yNb8rfkuL
 zpWSps88yUN1cTVSiE+LWSUzwod9Qn+gcQPdV7aw61v6SnE3k9fQo0Fwqf6kdHZ7nNwd QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp58umb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 07:54:59 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33R7klKG001659;
        Thu, 27 Apr 2023 07:54:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7mp58ukv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 07:54:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R47hQM019378;
        Thu, 27 Apr 2023 07:54:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47772t6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 07:54:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33R7srS35309064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 07:54:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40C592004B;
        Thu, 27 Apr 2023 07:54:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8899520040;
        Thu, 27 Apr 2023 07:54:52 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.19.188])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 07:54:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/1] s390x: sclp: consider monoprocessor on read_info error
Date:   Thu, 27 Apr 2023 09:54:50 +0200
Message-Id: <20230427075450.6146-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230427075450.6146-1-pmorel@linux.ibm.com>
References: <20230427075450.6146-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CLlohtwUvNMOL9yJEv1ajRB7QzcM9U8y
X-Proofpoint-ORIG-GUID: u44x42simNgcbbNjAyaQBfTFLCyzTCOL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxlogscore=962 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304270064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A test would hang if an abort happens before SCLP Read SCP
Information has completed.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/sclp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 390fde7..07523dc 100644
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

