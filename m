Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C5734E11
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjFSIhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjFSIhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:37:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B56170D;
        Mon, 19 Jun 2023 01:35:05 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8FD8p026543;
        Mon, 19 Jun 2023 08:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dO9kt/pdcE4GgRY6OJhIckivItRF9/Pi/KI3x77huZ8=;
 b=tE0Ly7P6lxxWs4iUQlbHik9EAgKI5NtLamHtnkI6TBEiUKeeooTtkiwGSWUw9lqccp7b
 NBxjg75C7agXMst2W312tRL8fkwNthLzo03EPkqwrf0Q4VTI/bmJbkXRzDDQ3b4RiC0V
 bFswLXcMX0Z4G3MBnQt0i+Ocj2C0DLaEMJlwasHbHvGln5Xu8FC3NDMtY+XFXWjAM00U
 ZhVCbGZ9KonhyhXCXZAptwbMPOnzH+ad+VHZLNhLlP9uKWhQdJNbbD5B88SWK58XKs8O
 36NPaKVOD9kJsYfc/o2OIlCbQtAY/AtPYwLAoax8IDkYqK42nb/x7dAz+8sj6b/X7VHo qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rak0g0yq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:04 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J7qXtI028356;
        Mon, 19 Jun 2023 08:34:04 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rak0g0ypg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J6phYb008679;
        Mon, 19 Jun 2023 08:34:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3r943e0xnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8XrCg6488668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F64F2004D;
        Mon, 19 Jun 2023 08:33:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 211CF20043;
        Mon, 19 Jun 2023 08:33:52 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 1/8] lib: s390x: sie: Fix sie_get_validity() no validity handling
Date:   Mon, 19 Jun 2023 08:33:22 +0000
Message-Id: <20230619083329.22680-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230619083329.22680-1-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ItsohCvYQUYURtNlp_uN61Ba28G0YfpT
X-Proofpoint-ORIG-GUID: 3vU9DRRFyxjsNspQ2Y00fACzOkGg3FZj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_06,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 suspectscore=0 mlxlogscore=801 malwarescore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

Rather than asserting, we can return a value that's designated as a
programming only value to indicate that there has been no validity.

The SIE instruction will never write 0xffff as a validity code so
let's just use that constant.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 9241b4b4..b44febde 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -23,7 +23,13 @@ void sie_expect_validity(struct vm *vm)
 
 uint16_t sie_get_validity(struct vm *vm)
 {
-	assert(vm->sblk->icptcode == ICPT_VALIDITY);
+	/*
+	 * 0xffff will never be returned by SIE, so we can indicate a
+	 * missing validity via this value.
+	 */
+	if (vm->sblk->icptcode != ICPT_VALIDITY)
+		return 0xffff;
+
 	return vm->sblk->ipb >> 16;
 }
 
-- 
2.34.1

