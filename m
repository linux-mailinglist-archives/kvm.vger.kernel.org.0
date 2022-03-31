Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2204EDE5B
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 18:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbiCaQGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 12:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiCaQGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 12:06:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A13B879;
        Thu, 31 Mar 2022 09:04:35 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VFENf7016699;
        Thu, 31 Mar 2022 16:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MddiOPWhgpVDu/wZoAjOydjdF2Xsvvpw/2vdvVBApbQ=;
 b=Kfgbna1cKyiOT45Q6GfHard9iTTVVcGJUHolIWSWnosKRyTpszI9EAb6uguaz0RnrJp6
 Q9qBkfYH397dVdbspcXZacD5d09JDX0cTF4l1vKAZuDl1lhMs5/qBpl6sSwPZo1wE5/1
 KApXTnpZ8sQ7qESj0KHrIYxK4rsQEl83A0t8joB8/oKI9j4SFjL6uUJXZvflqTRfsdkm
 MzoDEtjWVTvTxh8t33+yfZERpHyta1l7bdNWOzA8RH4LufLWE2uWZbwj1eFle+FwGwl5
 PNP0jPk9wZ/Mz+V9LnxgPXU4FZwp1IgZ0pwcfyrTWJAxllawAglNKBOUW8ADd/FdJRlP 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f57rmu9tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:35 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VEkSuO005706;
        Thu, 31 Mar 2022 16:04:35 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f57rmu9t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VG1FoP003948;
        Thu, 31 Mar 2022 16:04:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8ses5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:32 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VG4TTZ34472428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 16:04:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A64B11C04C;
        Thu, 31 Mar 2022 16:04:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E01911C050;
        Thu, 31 Mar 2022 16:04:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 16:04:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/5] s390x: skey: remove check for old z/VM version
Date:   Thu, 31 Mar 2022 18:04:16 +0200
Message-Id: <20220331160419.333157-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331160419.333157-1-imbrenda@linux.ibm.com>
References: <20220331160419.333157-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z66LNtjqUFZ2IetjVhgEh0xDDl6qrLyR
X-Proofpoint-ORIG-GUID: ydiBU9mexjt3RaYubQQPzFy9rx7K9dKr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the check for z/VM 6.x, since it is not needed anymore.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

