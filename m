Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B032E73506C
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 11:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjFSJgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 05:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjFSJgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 05:36:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BF1B4;
        Mon, 19 Jun 2023 02:36:09 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8PgUf018126;
        Mon, 19 Jun 2023 08:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J8MXHooEbZxLg10nF8GMHYpehdtFuKcjNFlsO2dpEmU=;
 b=HzU2JX4iXWoEVdQBTl8Y3FNfOti8R0+0Yo0XVFtDFBkNpQRge9lKUev1qW2vVcTdleip
 /ktFT6IBq23fwPTsrx9aHgeME308lTUtbkbUUrJvUU8gPLsx5to2/sDQovYgn6Y0q07i
 oBy/VB8rofritRAQAxttAst5dBicLfpwEfDpCtgUDii0DYGqwu3bXLWK5o3sh3/Dmcau
 yXk/6OV26bkIcarEnjR3wwI2yTrUCr1THwlw45U3GS197NeIpor5Ioriqkjwuz7tmF2f
 RbaJk+OsrwB6aU8i7GWj6ARbYhKUreRXdcEAQbWVWqPb5oSO+jTguSCwI+BhRwGxNqSX iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakgh05t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:00 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J8PgJw018113;
        Mon, 19 Jun 2023 08:34:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rakgh05sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J5tT4g031967;
        Mon, 19 Jun 2023 08:33:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3r94f58xer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:33:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8Xso318088532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B4812004B;
        Mon, 19 Jun 2023 08:33:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D26420043;
        Mon, 19 Jun 2023 08:33:53 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 2/8] lib: s390x: uv: Introduce UV validity function
Date:   Mon, 19 Jun 2023 08:33:23 +0000
Message-Id: <20230619083329.22680-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230619083329.22680-1-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vz_mNVkLet9UzVARGBCvp_iM691aoAGZ
X-Proofpoint-GUID: BNF4hfUyp13HeWQebfQKHl9cJ4diPI9a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_06,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
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

