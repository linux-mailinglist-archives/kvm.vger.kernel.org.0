Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3976F699AE5
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBPRNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjBPRNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:13:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE674E5CF
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:13:03 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GGMfde014952
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=fLzBHvB5ua71RNOfYeCXVebfugEMhF3red/bgamVwqI=;
 b=qMRfCzpzpMuLbsc9y7Aiy7ZHnJaleqOQ9BQ8a54Ggp8nC2y9hIRSokYys6qXR1oR88f2
 Vo9GbFEFw9AohCa5e1tpWftQAJVF8uDHhWsIrzhFrDPmAFSt9z5+B0vUdOKkyn/xB4me
 JbedIBqxJC8x9jGrQC0uUUXMvyLFp7SsrUTKgcHIvtaAUULjldFNuXLiUNYouF11Wf76
 7kqgSdJuDyhRunfBQHhMUdz7NWRWBxAIuwhR4wd8lALT/A75n/QxQkcRG718hBLSUBgc
 p7Ll/2Njvwi3U/3laWoEnnABuK6psFx4HatUd9r1z0z6rn1cY/une5PPuRXnnpA1Iul4 /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsqy3h7fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:02 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31GH8GRb009974
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 17:13:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsqy3h7eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G62oRM010856;
        Thu, 16 Feb 2023 17:13:00 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6xyn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 17:13:00 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GHCvnH33489320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 17:12:57 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98C4D20043;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75F422004D;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 17:12:57 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 09/10] s390x: Clear first stack frame and end backtrace early
Date:   Thu, 16 Feb 2023 18:12:54 +0100
Message-Id: <20230216171255.48799-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216171255.48799-1-imbrenda@linux.ibm.com>
References: <20230216171255.48799-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3pbghYxW3nWmZuxEEX1OMv85Wu4G9_k1
X-Proofpoint-GUID: zMgKor-uAAw3QFUtz2F_5cPwPTPBSc6S
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_13,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160148
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

When setting the first stack frame to 0, we can check for a 0
backchain pointer when doing backtraces to know when to stop.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20230112154548.163021-7-frankja@linux.ibm.com
Message-Id: <20230112154548.163021-7-frankja@linux.ibm.com>
---
 lib/s390x/stack.c | 2 ++
 s390x/cstart64.S  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index e714e07c..9f234a12 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -22,6 +22,8 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 	for (depth = 0; stack && depth < max_depth; depth++) {
 		return_addrs[depth] = (void *)stack->grs[8];
 		stack = stack->back_chain;
+		if (!stack)
+			break;
 	}
 
 	return depth;
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 666a9567..6f83da2a 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -37,6 +37,8 @@ start:
 	sam64				# Set addressing mode to 64 bit
 	/* setup stack */
 	larl	%r15, stackptr
+	/* Clear first stack frame */
+	xc      0(160,%r15), 0(%r15)
 	/* setup initial PSW mask + control registers*/
 	larl	%r1, initial_psw
 	lpswe	0(%r1)
-- 
2.39.1

