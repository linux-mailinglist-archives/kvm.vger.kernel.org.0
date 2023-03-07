Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8476AD9F8
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 10:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCGJLa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 04:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCGJLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 04:11:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36AF5291D
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 01:11:14 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32771e0g011444
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=p0OgmB5fDUpyV46KmMqzsQjK1QXFPsuaf4U5e9BSEf4=;
 b=Yo7BZVAc+fgjkuIaRElPwGb1J7V3Z/sYAWNsueUr2uicgHsdKMFNtKT1RVq4oWLpcfDd
 l1eaeFjhw6Ymtb7xh6NIDU8FQ2b01LaUT5ewsWh/K4IWPKXCmc3+qwD0DmRDuN0Tl6VG
 GD7JH7jKyUOUYoA5SSuy5M3DW2Tmy6SeQuhcbQlDLRZI5IRmXLeUQzdeHZUqCmWc8Hed
 Ao4Gu98HwKDND8rzCuapM0/UoBAUn019xEXaYs1YbVzsAC26fkeU5k0U2TuHm3l2e7MW
 J+qj2/vhc4MCzJ8PfK1K8vTeqXIkNPhPhBBOok3MXBYuiW43PIIr/tDKTpdoURqFuIAK 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4yrex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:11:13 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3278tfLQ030788
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:13 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p50n4yre9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3272B3S6007338;
        Tue, 7 Mar 2023 09:11:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3p4188c0jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:10 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3279B7s764422376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 09:11:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AD5820043;
        Tue,  7 Mar 2023 09:11:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F016620040;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.61.17])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 09:11:06 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 7/7] lib/linux/const.h: test for `__ASSEMBLER__` as well
Date:   Tue,  7 Mar 2023 10:10:51 +0100
Message-Id: <20230307091051.13945-8-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307091051.13945-1-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FoThNxSzd8VkVLVNdL7jgwg0IZAq7b8r
X-Proofpoint-GUID: wJDUgNbEpySlJ0_aF0bLFr8Q8sOxAaXW
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_02,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=946 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390x we're using the preprocessor for generating our linker scripts
out of assembly files. The macro `__ASSEMBLER__` is defined with value 1
when preprocessing assembly language using gcc. [1] Therefore, let's
check for the macro `__ASSEMBLER__` in `lib/linux/const.h` as well. Thus
we can use macros that makes use of the `_AC` or `_AT` macro in the
"linker scripts".

[1] https://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/linux/const.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/linux/const.h b/lib/linux/const.h
index c872bfd25e13..be114dc4a553 100644
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
2.34.1

