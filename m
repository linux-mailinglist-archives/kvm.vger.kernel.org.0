Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2266F43A1
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbjEBMVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjEBMV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:21:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1814B5B85;
        Tue,  2 May 2023 05:21:27 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342CD3m1019980;
        Tue, 2 May 2023 12:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=J8MXHooEbZxLg10nF8GMHYpehdtFuKcjNFlsO2dpEmU=;
 b=kxhlj3dowFUEHsEgtUfL20S6NmkspYZtlbfykCDxKY5KzolVEyDc9eQ+ea27shZ3IR31
 9aXLVZqS6ihm9JrEZkKt1Q/6OzkWIl2sKQlOquTXImdl1p4s2VQ45x1vvN4eiHUnacEj
 AnTTb44P1ohQoYgRCdul8GM3RA/TKGOwBUb9ye40UZhm4M5AZJIo9WVFdLpnEwnF6YAb
 jbNqetevlJFdFxoi1LNF6lTDCq24STjkS8COTwDtaUgVYmWUbo1SZsX1eicQy2mEzBVi
 PZ/WvZD+aDGbHZ4VTpdHu/lyPQ/lPB4MTMYU1kIaT7Txwo/SpSTh0nx2awSGqUUylzuZ Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb23g8u4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:25 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342C6tsU012048;
        Tue, 2 May 2023 12:21:25 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb23g8u15-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:25 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427agCg003648;
        Tue, 2 May 2023 12:00:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6h9sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:00:46 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342C0hbl26214944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:00:43 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499EB2004E;
        Tue,  2 May 2023 12:00:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A1BF2006A;
        Tue,  2 May 2023 12:00:42 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:00:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/7] lib: s390x: uv: Introduce UV validity function
Date:   Tue,  2 May 2023 11:59:25 +0000
Message-Id: <20230502115931.86280-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502115931.86280-1-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XMkEINLlg207XiHvpcZb4k_103GI72j1
X-Proofpoint-ORIG-GUID: Da8dizL5dexNTtgc1CujG13zvEHi0JUH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

