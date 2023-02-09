Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053956904B0
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjBIKZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBIKZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4911E66EE2;
        Thu,  9 Feb 2023 02:25:13 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AL6Pq029459;
        Thu, 9 Feb 2023 10:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=RzLCp6pQwZyeD59xn0DKcBZlFxc8FmNfnVcz8RkIeGo=;
 b=bbVnrFjl5yVcyVBAEdWaW0kNd0f2v/QHaHOA971IZThzRtWyKmyd5vTpYh/648simT1O
 9rSSh8N8csgRMESwkDV3vXb4FFyHmywYLiBTVSxjU3vJyrGj+UZuyD22qsULudwABfjw
 ajtU9U+2dZrjr3aZi25ovpfnxKe7ZgVywacMmn3kCiVUl/LBzbuvVa9QeE9EcLHC6whV
 qTbQjKnyFjEXSTydEVz9Q+RZq1o5xE+NoFzycr20wlBdhobGuyIXOpzUY2IvHde15VEp
 6WyOlWu+epynb+btdDYq9bG/Rwjx4cAS6MVjxrx4ZrRUrSLNvvudqMvJ7waE67lSEXZe BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmy0m02r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:12 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319AMFFw003852;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmy0m02q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318L9CYM023711;
        Thu, 9 Feb 2023 10:25:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06x1qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP6AT49414630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C64B2006A;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48CC02006E;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 09/18] KVM: s390: selftest: memop: Fix integer literal
Date:   Thu,  9 Feb 2023 11:22:51 +0100
Message-Id: <20230209102300.12254-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LWJeYaTR6gq220ODkridPjeO7V9SIQc8
X-Proofpoint-ORIG-GUID: KZAUV34YphS24mZvPBzEwJsC0S3oYxZG
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 spamscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 mlxlogscore=771
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

The address is a 64 bit value, specifying a 32 bit value can crash the
guest. In this case things worked out with -O2 but not -O0.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Fixes: 1bb873495a9e ("KVM: s390: selftests: Add more copy memop tests")
Reviewed-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20230206164602.138068-8-scgl@linux.ibm.com
Message-Id: <20230206164602.138068-8-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 1ae5c01f9904..c5fec84ef3c2 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -514,7 +514,7 @@ static void guest_copy_key_fetch_prot_override(void)
 	GUEST_SYNC(STAGE_INITED);
 	set_storage_key_range(0, PAGE_SIZE, 0x18);
 	set_storage_key_range((void *)last_page_addr, PAGE_SIZE, 0x0);
-	asm volatile ("sske %[key],%[addr]\n" :: [addr] "r"(0), [key] "r"(0x18) : "cc");
+	asm volatile ("sske %[key],%[addr]\n" :: [addr] "r"(0L), [key] "r"(0x18) : "cc");
 	GUEST_SYNC(STAGE_SKEYS_SET);
 
 	for (;;) {
-- 
2.39.1

