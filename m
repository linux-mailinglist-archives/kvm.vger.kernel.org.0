Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604D66F44DC
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbjEBNO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjEBNO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:14:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ABA4C2B;
        Tue,  2 May 2023 06:14:55 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342DD4W9031070;
        Tue, 2 May 2023 13:14:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RXcHrG7/krC9/ByvYXXiF32Ernx8UTybrzn8umTWjXM=;
 b=D8sKisfdmc5k7IMaBrAK5CdFPgbrLIoTiek8PPXXx1jJcl1ODqbA3Jv/BCnuFGpZQljB
 qsZFmlX2s8X/QNgJK52lJU19GTILnQqf5I35OlsVWk6SgzsYBPNYdDXudM5fnthnxB0F
 3rh3a489okeHrXZkc3UPZ8JYPVIara+IYIuQplM/4E0EFTs12Hcz9YugtSlFTMVXmU5F
 7t3N5HRsGbws527QNgPmO5b80PS9Tyzx9ZIjfhPHurF7zN//h+e251reIjIGE7pmuTQk
 pHiSrwVhpAAXHw7rqUpQmGVCaElvNeDL0ZirdgMc+9cdIw2Wb3jnSv8UH8jWDTJlqFxy uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2ysrqby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:14:55 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D7JXq016270;
        Tue, 2 May 2023 13:14:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2ysrq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:14:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3420HgRF002522;
        Tue, 2 May 2023 13:09:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6skjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:27 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9Odk33882536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 657AA20040;
        Tue,  2 May 2023 13:09:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C0A420049;
        Tue,  2 May 2023 13:09:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/9] s390x: uv-host: Switch to smp_sigp
Date:   Tue,  2 May 2023 13:07:29 +0000
Message-Id: <20230502130732.147210-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K-sZqrGB6MwKNSAlape9PkYQCKLWqk_u
X-Proofpoint-ORIG-GUID: x8flgPhXrgnZvaYG9qFXJyfQ0U64OoKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's move to the new smp_sigp() interface which abstracts cpu
numbers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 0048a19f..a9543593 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -440,12 +440,12 @@ static void test_config_create(void)
 	 * non-zero prefix.
 	 */
 	if (smp_query_num_cpus() > 1) {
-		sigp_retry(1, SIGP_SET_PREFIX,
+		smp_sigp(1, SIGP_SET_PREFIX,
 			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
 		report(uvcb_cgc.header.rc == 0x10b && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
-		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
+		smp_sigp(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
 
 	tmp = uvcb_cgc.guest_sca;
-- 
2.34.1

