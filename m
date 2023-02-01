Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA95D686211
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 09:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjBAIt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 03:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjBAItQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 03:49:16 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D04126CF;
        Wed,  1 Feb 2023 00:49:05 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3117fZNo027818;
        Wed, 1 Feb 2023 08:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Fkc/GGdNZ2iIcsG4JdFeUCvG515K6qcjueb48TgfQX4=;
 b=WscIVXXH/iu5XnjW65PIcDQ87Afg4BKoKlFtKbunOAy62JRpsM9S3Cyq0ra/XVtqWrn1
 tD3gKfpLg7bukXGbjdMx1W97jyI9p5DTfptk2Ca919yWmalpswT8FN9uvQmcp6nRBqQ+
 P+O9DQbZJ86ivw8zPesO/r5HW2TtuQrEWdULJaYjW7BM5g1RmkHAXADGX7S+8Qs3VUzx
 y76esB5NtIuX/xzh5x+eEigtFZNKetGu0D6BumWv3/x3j0dF78TwOzxvoFGNwrpklF2b
 Cq47DGSvgMaxvwNHDTdfB8Qzpg3Tg5epLxUhIOpv9f33SjGqbxIxPuO2Fj9gveDgDIeJ xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfkj0jbna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:49:04 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3118Wv0C014817;
        Wed, 1 Feb 2023 08:49:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfkj0jbmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:49:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VGSmCd024026;
        Wed, 1 Feb 2023 08:48:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3ncvuqua0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 08:48:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3118ms1Q23658916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 08:48:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A01920043;
        Wed,  1 Feb 2023 08:48:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6E6E20040;
        Wed,  1 Feb 2023 08:48:53 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 08:48:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/3] lib: s390x: Introduce UV validity function
Date:   Wed,  1 Feb 2023 08:48:31 +0000
Message-Id: <20230201084833.39846-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201084833.39846-1-frankja@linux.ibm.com>
References: <20230201084833.39846-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aRaS4mhfhAA-KSVQUgR3mtNdToV_beRP
X-Proofpoint-ORIG-GUID: kkwoP8Nn0inrAQQw3f1Sij56EPmihw4y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_03,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PV related validities are in the 0x20** range but the last byte might
be implementation specific, so everytime we check for a UV validity we
need to mask the last byte.

Let's add a function that checks for a UV validity and returns a
boolean.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 5fe29bda..78b979b7 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -35,4 +35,11 @@ static inline void uv_setup_asces(void)
 	lctlg(13, asce);
 }
 
+static inline bool uv_validity_check(struct vm *vm)
+{
+	uint16_t vir = sie_get_validity(vm);
+
+	return vm->sblk->icptcode == ICPT_VALIDITY && (vir & 0xff00) == 0x2000;
+}
+
 #endif /* UV_H */
-- 
2.34.1

