Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0CC509D4A
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 12:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388249AbiDUKRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 06:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388170AbiDUKQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 06:16:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AC3E0D1;
        Thu, 21 Apr 2022 03:13:42 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23L9Urjt030106;
        Thu, 21 Apr 2022 10:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pdgXxv0+VCuXjqXpq6OOi2OhFQbz4E7VV/VHS8VNUxM=;
 b=KvwiPAUn/hL6//tU+3ShbtElEcT8jqv8vG6dblZYgu+kDNXyKQN5k7+FZSaPMRl6gnqA
 0K6SjWrjVtg8u9xa7pZ7a2Nqy/FVmLJscmHrWW69uzDO/8omVB2i9CLVknF7lhOJ74NM
 +TDys5/P4U3aEBe9J6CQZwQW0/6dFh8Guh6b6RBmhUxImSTiBlGxSX1XspymohINJ4DQ
 5dW5vkWJrYPGw48fRU8GxSDyT25Lug0CwJZVv+gtYsIFKobS1ErmJw0wqLApu6wNU3sy
 pHouNXoO4hMbWwf59jkAWVJKnMAQVMVyEjgHOIS2zECT7ovui4Zw4HaewKbECw0zBerq vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cww3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:42 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23L9t6F1025508;
        Thu, 21 Apr 2022 10:13:42 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fjdn4cwv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23LADQrL024264;
        Thu, 21 Apr 2022 10:13:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8qnb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:13:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23LA0k3m52887970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 10:00:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 747A9AE053;
        Thu, 21 Apr 2022 10:13:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E6CAE04D;
        Thu, 21 Apr 2022 10:13:35 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Apr 2022 10:13:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 11/11] s390x: Restore registers in diag308_load_reset() error path
Date:   Thu, 21 Apr 2022 10:11:30 +0000
Message-Id: <20220421101130.23107-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220421101130.23107-1-frankja@linux.ibm.com>
References: <20220421101130.23107-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 37YfNc4rmd88ftf1ww-E_Duaufwiq6fW
X-Proofpoint-GUID: kYM_BbMyBHY0mL5MYEgvkpHQ6kUIUkn8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of an error we'll currently return with the wrong values in
gr0 and gr1. Let's fix that by restoring the registers before setting
the return value and branching to the return address.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cpu.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/s390x/cpu.S b/s390x/cpu.S
index 82b5e25d..0bd8c0e3 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -34,6 +34,7 @@ diag308_load_reset:
 	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
 	/* Do the reset */
 	diag    %r0,%r2,0x308
+	RESTORE_REGS_STACK
 	/* Failure path */
 	xgr	%r2, %r2
 	br	%r14
-- 
2.32.0

