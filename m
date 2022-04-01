Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278514EEC3E
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345507AbiDALTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345457AbiDALSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05931877F7
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:41 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319j3DB007734
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c5SFzfQf7kPWAzQreYEcrFgHzA3W7E8LW8DsMlnJOXU=;
 b=RFjBi7NHxPo5rkzlmxOj0Nxet/xhA4zvAseEvWpXw5t6U/WEGoe98uBTFEIebFN/4AAp
 UWpcwNXkwDFTEx2aKVK7Yl2L8S0nEd6JkQ4JVsymK+QLSzalOvfwsEJ8aq2jAX5HuXIr
 qY9fMrfgyJDvgjbRP6xzR2bIM01heMNgbCHnU6wY/VJ8C5x6Ug8KUQ3VUi7nCOYg7y8h
 RnbFWDya6s0+xeiCUZ4AolH9LdnjzyBIInsAqeE7vMEQT1e/Am6Mpip0KsqWRIkO/Gww
 rvB+Ul16o2BL3zwbCOtIsJdQAUlAVWjTUyXmJxGIvZyd+KYAc5ybDtjkI7K+mZl4sDYN dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9twx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:41 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231AiDhl004436
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:41 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9tw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7jrh019695;
        Fri, 1 Apr 2022 11:16:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3qun4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:38 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGZfv37093830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B04704C05C;
        Fri,  1 Apr 2022 11:16:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 604B14C05E;
        Fri,  1 Apr 2022 11:16:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 23/27] s390x: remove spurious includes
Date:   Fri,  1 Apr 2022 13:16:16 +0200
Message-Id: <20220401111620.366435-24-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q8oyTR2dqZUW0a0o-xKJ3tThdkbFRtQC
X-Proofpoint-GUID: 2ZZ7AHqepKlAB1if-SvbJIeussaqlLPu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 mlxlogscore=785 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unused includes of vm.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg-sie.c    | 1 -
 s390x/pv-diags.c    | 1 -
 s390x/spec_ex-sie.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 8ae9a52a..46a2edb6 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -16,7 +16,6 @@
 #include <asm/facility.h>
 #include <asm/mem.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sclp.h>
 #include <sie.h>
 #include <snippet.h>
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 110547ad..6899b859 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -19,7 +19,6 @@
 #include <asm/sigp.h>
 #include <smp.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <vmalloc.h>
 #include <sclp.h>
 #include <snippet.h>
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index 5dea4115..d8e25e75 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -11,7 +11,6 @@
 #include <asm/page.h>
 #include <asm/arch_def.h>
 #include <alloc_page.h>
-#include <vm.h>
 #include <sie.h>
 #include <snippet.h>
 
-- 
2.34.1

