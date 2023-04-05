Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8446D7734
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbjDEIps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjDEIpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1716A2727
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:42 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3357VdvF014022;
        Wed, 5 Apr 2023 08:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eooVMNY12d4PIRdlfRREXKlBB/c6LetaDTS5O1I3m78=;
 b=ldSTaOeNx9Qg6jrmPNPpVj9JMiAk0ahwsBELkr7RFeOKZ3II7eo891nkBIIwdqVVZiQV
 87E5gZ83HQMa3CX/DFcbfvYJND3Vbd7bMn7QxKJGKpojfz+davBS9LJqgKx4zaTe4u3G
 42FuPAfafgdzEuEGvoY5rQbq5oyCwnDkJc8tpmPgVyZ69w3OAkQjU1SYVYD+iGgHZpQC
 td+3Oez2uc2CO6gYfOGV5KbrSX/blZ+DG5/IbkpzGAbJt3GkiDYTwljee98G8Im4SLqK
 SdIOjRZxrHHDr16wpFKgS1J+5DZR6du/SBRsyryTVcDldgzf92NEWpkJCyjNumUF7aMv LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps4p5hsxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:40 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358HCDP028057;
        Wed, 5 Apr 2023 08:45:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps4p5hsxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 334HPHp0024391;
        Wed, 5 Apr 2023 08:45:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ppc87b69g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jY5b28836498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE1FA20043;
        Wed,  5 Apr 2023 08:45:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37F7120040;
        Wed,  5 Apr 2023 08:45:34 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:34 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL v3 07/14] lib/linux/const.h: test for `__ASSEMBLER__` as well
Date:   Wed,  5 Apr 2023 10:45:21 +0200
Message-Id: <20230405084528.16027-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zdS5LalBiNhWclwL5ZkXvvbiNLwQ6zWB
X-Proofpoint-GUID: zz7KTLBb1oUetAk6MzidgcZ_cydakfZz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

