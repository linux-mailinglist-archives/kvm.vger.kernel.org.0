Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA36D1F0F
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjCaLcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 07:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCaLb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:31:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556CB1DF87
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:31:26 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VBTk8H017642;
        Fri, 31 Mar 2023 11:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eooVMNY12d4PIRdlfRREXKlBB/c6LetaDTS5O1I3m78=;
 b=XxTtwJnSraDmpaHkUIH0OJ+NYy9u/OGMfzuq2kyaPGlmlDZKpgc7xyLnWKc5YtN824BQ
 RmCpULi3kevG32emA2ZeKpe2ICBfVqi7/1XOS1v+EDmoPQqroP1QqfCkgaLKXrQTbMcY
 s98t2BXXD8VB9F8KbPidDuUWSjxzfCoz2k6Fu7jDMaXcOdyzeUYTfWp2c11Q/h+mxGNY
 7nS3TBUH8u0OmrM0QwbaPsVXL3G8FFy8LiXUNdILmoBKoGUbU0EerOrnOyOYIoAbknCG
 YyZRcChBMROvaJS2X8Id+YmKd/2ZbERoeZFDHgc+B8tJaIfYwLjfhCbEZQdidbaX/d/W dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnxpt816f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:58 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32VBUnua022788;
        Fri, 31 Mar 2023 11:30:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pnxpt815k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UMQnrj009344;
        Fri, 31 Mar 2023 11:30:56 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6ppgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 11:30:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32VBUqJN47841958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 11:30:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B6AB2004E;
        Fri, 31 Mar 2023 11:30:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 317CE20040;
        Fri, 31 Mar 2023 11:30:50 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.9.190])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 31 Mar 2023 11:30:50 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 07/14] lib/linux/const.h: test for `__ASSEMBLER__` as well
Date:   Fri, 31 Mar 2023 13:30:21 +0200
Message-Id: <20230331113028.621828-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331113028.621828-1-nrb@linux.ibm.com>
References: <20230331113028.621828-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6a2z8evvL_fVCQ2-eRB_cNem99D94nIv
X-Proofpoint-ORIG-GUID: cb6BekrdxZIeRrtTGtGD38OBYGu7zEKC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_06,2023-03-30_04,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2303310091
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

On s390x we're using the preprocessor for generating our linker scripts
out of assembly files. The macro `__ASSEMBLER__` is defined with value 1
when preprocessing assembly language using gcc. [1] Therefore, let's
check for the macro `__ASSEMBLER__` in `lib/linux/const.h` as well. Thus
we can use macros that makes use of the `_AC` or `_AT` macro in the
"linker scripts".

[1] https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230307091051.13945-8-mhartmay@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/linux/const.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/linux/const.h b/lib/linux/const.h
index c872bfd..be114dc 100644
--- a/lib/linux/const.h
+++ b/lib/linux/const.h
@@ -12,7 +12,7 @@
  * leave it unchanged in asm.
  */
 
-#ifdef __ASSEMBLY__
+#if defined(__ASSEMBLY__) || defined(__ASSEMBLER__)
 #define _AC(X,Y)	X
 #define _AT(T,X)	X
 #else
-- 
2.39.2

