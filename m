Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371DA4EEC3B
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344748AbiDALTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345427AbiDALSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04921877F4
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:42 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231BAaSt005632
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fOdyq1T8GEGnPA083uI+90zv9OGvJ3mMlVVAgn5wrgI=;
 b=qnKo2h2A7VygyQR1Lh/FK9LDBfJvX5iyHd3mkI+RbiIlGjV2hFpmVmxtSF1F5JyPHcfB
 MgEzrS/XUpPkx4WloIOth73C/T+lYjIShVVu76bnrVWFMmUkuBlwa1z9I/KagZB9UgSQ
 VTy3UexTNqcFOnAI5RuWf3kVNvgzFS64muftltY+2ic2a46IgGvVWoFbxY1KIglfIVmt
 tF1UDdb1wJ2I/JzolCPCfKl9DHqV+WMtylSYfecM9UKWbdmrZUFSt2XSPdSkwU4sNlw0
 INzgngj0D/G3vq0q9HeBS3OAdXuB8qHI/zVr/siPoDsbATSHzmDLyqI3U3riSvnzRgoj Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231AgK6X014172
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7ss9012931;
        Fri, 1 Apr 2022 11:16:39 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9mv0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGaI342991950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1670B4C063;
        Fri,  1 Apr 2022 11:16:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D8B4C062;
        Fri,  1 Apr 2022 11:16:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 24/27] s390x: skey: remove check for old z/VM version
Date:   Fri,  1 Apr 2022 13:16:17 +0200
Message-Id: <20220401111620.366435-25-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0jZXUGsYjBJhvVFvDoSiYMIKwcEyxETU
X-Proofpoint-GUID: agNe7c_A9l6tpj7fOt8xKVibWrVAoEf4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the check for z/VM 6.x, since it is not needed anymore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/skey.c | 37 ++++---------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/s390x/skey.c b/s390x/skey.c
index 58a55436..edad53e9 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -65,33 +65,9 @@ static void test_set(void)
 	       "set key test");
 }
 
-/* Returns true if we are running under z/VM 6.x */
-static bool check_for_zvm6(void)
-{
-	int dcbt;	/* Descriptor block count */
-	int nr;
-	static const unsigned char zvm6[] = {
-		/* This is "z/VM    6" in EBCDIC */
-		0xa9, 0x61, 0xe5, 0xd4, 0x40, 0x40, 0x40, 0x40, 0xf6
-	};
-
-	if (stsi(pagebuf, 3, 2, 2))
-		return false;
-
-	dcbt = pagebuf[31] & 0xf;
-
-	for (nr = 0; nr < dcbt; nr++) {
-		if (!memcmp(&pagebuf[32 + nr * 64 + 24], zvm6, sizeof(zvm6)))
-			return true;
-	}
-
-	return false;
-}
-
 static void test_priv(void)
 {
 	union skey skey;
-	bool is_zvm6 = check_for_zvm6();
 
 	memset(pagebuf, 0, PAGE_SIZE * 2);
 	report_prefix_push("privileged");
@@ -106,15 +82,10 @@ static void test_priv(void)
 	report(skey.str.acc != 3, "skey did not change on exception");
 
 	report_prefix_push("iske");
-	if (is_zvm6) {
-		/* There is a known bug with z/VM 6, so skip the test there */
-		report_skip("not working on z/VM 6");
-	} else {
-		expect_pgm_int();
-		enter_pstate();
-		get_storage_key(pagebuf);
-		check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
-	}
+	expect_pgm_int();
+	enter_pstate();
+	get_storage_key(pagebuf);
+	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 
 	report_prefix_pop();
-- 
2.34.1

