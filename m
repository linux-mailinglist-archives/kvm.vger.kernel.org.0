Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BF066CE83
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjAPSN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjAPSMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C90B39BB5
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:07 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFqZjs027894
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8C2kewx5hMuKq1I/rCDR/sEVvDd3kNv7sGTVpCFKeqo=;
 b=WCCHxaJBt0sHy2gxdzQp/ra75R7ThkoarbbwDrBaT7d9Lk9G6JfWombZaYjvnxjg+Cf+
 NuGktRSQ2x69S63KVbBsVAJ6vSLMMVogKJXCOiFjULNXlVVyQ5OSx7vdkWFBKmCleswP
 H3gdMZ+32TlQxPSzARajUWc6j3MephOcbzGSj3mRQjb/vV4JpmNa60TaKbE5fMRCf3yx
 +Kn7AhIk4yrnLbzx8bwGJmGcV2S+jeCTdeOtgdgIXJ7+2Xp7KgfONm4qpYYNm1ECgmB3
 dK0iXzV7pvyedMOiuz7ahDi1w+ef5q7fW8nA2SWQIY1MWawyup+T3oHQKV3IOVDtBIHu EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n59kqaj66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:07 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHiSbp004985
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:07 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n59kqaj5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:07 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFebfO023789;
        Mon, 16 Jan 2023 17:59:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16jrta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHx1Pa50069766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:59:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E578E20043;
        Mon, 16 Jan 2023 17:59:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5385A20040;
        Mon, 16 Jan 2023 17:59:00 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:59:00 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 6/9] s390x: define a macro for the stack frame size
Date:   Mon, 16 Jan 2023 18:57:54 +0100
Message-Id: <20230116175757.71059-7-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mh_GVpIVV0E6v92xZfIpA4OAlWShHV83
X-Proofpoint-GUID: Xw5rII7u2-m_zz2E8n1H_DjucWo_VP5G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define and use a macro for the stack frame size.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 lib/s390x/asm-offsets.c | 1 +
 s390x/cstart64.S        | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index f612f3277a95..188dd2e51181 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -87,6 +87,7 @@ int main(void)
 	OFFSET(STACK_FRAME_INT_GRS0, stack_frame_int, grs0);
 	OFFSET(STACK_FRAME_INT_GRS1, stack_frame_int, grs1);
 	DEFINE(STACK_FRAME_INT_SIZE, sizeof(struct stack_frame_int));
+	DEFINE(STACK_FRAME_SIZE, sizeof(struct stack_frame));
 
 	return 0;
 }
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 6f83da2a6c0a..468ace3ea4df 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -38,7 +38,7 @@ start:
 	/* setup stack */
 	larl	%r15, stackptr
 	/* Clear first stack frame */
-	xc      0(160,%r15), 0(%r15)
+	xc      0(STACK_FRAME_SIZE,%r15), 0(%r15)
 	/* setup initial PSW mask + control registers*/
 	larl	%r1, initial_psw
 	lpswe	0(%r1)
-- 
2.34.1

