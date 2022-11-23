Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0500E63531F
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbiKWIrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236680AbiKWIrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:47:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5621D2DDC;
        Wed, 23 Nov 2022 00:47:19 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN6M5KN039609;
        Wed, 23 Nov 2022 08:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=92bj0GHN32CsEjX9VmkfiBaFpHqsTz6F4uXbW75Sj2Q=;
 b=KL0bG+8hZguth0WC/jaDLSOmsTbnakOmIssqBlCtn5WgJy0RXDL2nP4c3Wu6uKyxZsy4
 fwyl8+OSEZknESy5cWF+RhTSaVPSH8s13G81YFn/4hP4rpU86W/lNtTb0mxnR33CZlQ1
 e7E6nze6m8NvrV3mdH3Xwc4fywjwL3kPLnhkPuKAixcIqA9OLR0OCvePMbG3X1WWdsR8
 BojOv4JdiLtTWWCmGoDYGYFKFJvwlFNo0Gib0jVrX9xbWmYqAmKJKgyu32BRsaIllkg1
 SpZdZGIm6mE99BQW72WjALVs/8rxYnebqpLh/6Wcz2QReuLaOspFeBs6yrf2ytjz/BRO WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffewwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN86fPQ036526;
        Wed, 23 Nov 2022 08:47:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10ffewvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:18 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN8Z8mu001203;
        Wed, 23 Nov 2022 08:47:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8wc5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN8lDpe48693520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 08:47:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 753FD11C04A;
        Wed, 23 Nov 2022 08:47:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA0C111C04C;
        Wed, 23 Nov 2022 08:47:12 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 08:47:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/5] s390x: Clear first stack frame and end backtrace early
Date:   Wed, 23 Nov 2022 08:46:55 +0000
Message-Id: <20221123084656.19864-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123084656.19864-1-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DELy4Db56bwxpSK43DYNsLmX-ie9pfUI
X-Proofpoint-GUID: DtrRJ3cfbt9VyDWzpwTCKeAtdfaig-Fm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When setting the first stack frame to 0, we can check for a 0
backchain pointer when doing backtraces to know when to stop.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.34.1

