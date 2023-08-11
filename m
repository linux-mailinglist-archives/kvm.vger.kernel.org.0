Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A000778DB5
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 13:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbjHKL37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 07:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbjHKL37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 07:29:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A976E64;
        Fri, 11 Aug 2023 04:29:58 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37BBSWvP014101;
        Fri, 11 Aug 2023 11:29:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oovwbOe3YxysVBN2CU5Se6/QCcsjf2rFHI4JDDIXwWo=;
 b=CASHy4VpSQpzhkj9m19phsS9LFtN8NLOtcLs6Ar4KAiB2ieyGQLBpyP3Fg3LE9ozbpgx
 70RPYtZIKou5ScK+dSKTYT0B7TPk+v2QGAcow3wAMC5qj5yxHSh+ocacGrosuBV0Ltn5
 kO0wWeFcuBO27TL2GtOnSzfB4jzOcg0I3p38hG+bL9ZAgS2/FVOG2hPtsAz2y32TPsWV
 aaRlPcbR8Lv/OD62q/HUFRq1F4bMEUAUS+SPP9g+Rx4prork9Rm0i5+lEce04oXWjXV/
 mF5H+WjD3E5DY8iQFSh0dQvorluJaetpqldhzl5/wWpgCYjQn97oUrNM8AO5VRZZ3MTO uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sdm56g0g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 11:29:58 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37BBTvAj017012;
        Fri, 11 Aug 2023 11:29:57 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sdm56g0g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 11:29:57 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37B9rKUI007606;
        Fri, 11 Aug 2023 11:29:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sa1502mwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 11:29:53 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37BBToJ562652726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Aug 2023 11:29:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 477BC2004F;
        Fri, 11 Aug 2023 11:29:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E58DF2004E;
        Fri, 11 Aug 2023 11:29:49 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 11 Aug 2023 11:29:49 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        nsg@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: spec_ex: load full register
Date:   Fri, 11 Aug 2023 13:29:36 +0200
Message-ID: <20230811112949.888903-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: makIMKgjNYGLz1Mpl6YyRBUExFlvCMbi
X-Proofpoint-ORIG-GUID: Fvr5o6LZoEAHwe4Fvi-Rkqxqwv1BFlLl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-11_02,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308110101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There may be contents left in the upper 32 bits of executed_addr; hence
we should use a 64-bit load to make sure they are overwritten.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/spec_ex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
index e3dd85dcb153..72b942576369 100644
--- a/s390x/spec_ex.c
+++ b/s390x/spec_ex.c
@@ -142,7 +142,7 @@ static int psw_odd_address(void)
 		"	larl	%%r1,0f\n"
 		"	stg	%%r1,%[fixup_addr]\n"
 		"	lpswe	%[odd_psw]\n"
-		"0:	lr	%[executed_addr],%%r0\n"
+		"0:	lgr	%[executed_addr],%%r0\n"
 	: [fixup_addr] "=&T" (fixup_psw.addr),
 	  [executed_addr] "=d" (executed_addr)
 	: [odd_psw] "Q" (odd)
-- 
2.41.0

