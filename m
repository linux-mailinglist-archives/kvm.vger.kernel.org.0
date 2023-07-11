Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAC074F1B1
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbjGKOTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjGKOTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:19:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE7510FD
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:19:18 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BE8sG8025789;
        Tue, 11 Jul 2023 14:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DYozoPaaQH/BIdzajwQUzfnudE4xdMtLdLnmO8IdTsM=;
 b=YQh/fhxdo02DxlXEXsre8sEymvziDG2Qqo8dIywugATBa6D5d5i1XxC59b/s6jzj6oCk
 NOFzA3SBEfCtHfMJwEWHNCcC8l4PFJ9tu0seVm5xPq8yXIYCrS4JjAoFhQ/INJXVswl2
 GDqb1BIEPmsqWrrfPRzJaJA4F3da46r2bcwDqHoJug5uZBQ/Xgew3KpTd1LO455fN47m
 8HTqltlQvK9tprCrsgo8cyk3t/whkUxzBiL2+RMFmcuffRq9aDBqd9pHaw0JISJyQaHj
 HiYsPQJqj7Clq3ggH2qAYCTowuuO0noQPEn0L6p6RG+3kYyXa3dhiIz+37SlPzUaYJaU zA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrw98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:17:06 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE9JlF030015;
        Tue, 11 Jul 2023 14:16:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrvvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B3Mnqk014041;
        Tue, 11 Jul 2023 14:16:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3rpye5hcj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGHf149414522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 465CC2004B;
        Tue, 11 Jul 2023 14:16:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB84C20043;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:16 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 12/22] s390x: uv-host: Check for sufficient amount of memory
Date:   Tue, 11 Jul 2023 16:15:45 +0200
Message-ID: <20230711141607.40742-13-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K_YWTnBNQt05PJ_6ceADLdm6HPFCK4y8
X-Proofpoint-GUID: DPvjVxcWOGDxbpXJ3oPSSgz9gWJHPCxq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 impostorscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The UV init storage needs to be above 2G so we need a little over 2G
of memory when running the test.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-3-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 9dfaebd..ee8e44d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,6 +15,7 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
+#include <snippet.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/sigp.h>
@@ -720,6 +721,13 @@ int main(void)
 	test_invalid();
 	test_uv_uninitialized();
 	test_query();
+
+	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
+		report_skip("Not enough memory. This test needs about %ld MB of memory",
+			    SNIPPET_PV_MIN_MEM_SIZE / SZ_1M);
+		goto done;
+	}
+
 	test_init();
 
 	setup_vmem();
-- 
2.41.0

