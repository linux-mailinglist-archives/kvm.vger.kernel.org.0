Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4321E74F1B0
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjGKOTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjGKOTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:19:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DD171C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:19:12 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BE8mgs025553;
        Tue, 11 Jul 2023 14:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=BzB+fE34ZU0OL/jOwYuFuIJaWj6scI0Ii5qik+Ir5Qw=;
 b=CciFnHY6FkliqylHxcapGUPbARiAYbeBHZrjU3vj6KOH54nrhfsZ5lfA99DWI0milamb
 dlq9zHDnvDkEfzRNkFe0/bCaNr9hZrlxvb1Mc//3bGyF9QcKo6cTzisghZD+F9J/ZMN1
 lrO/UAxXDJlxrmff/vDVrC7p4R1OoiHnOi4bcmO6x5iX4MQWpN+LJ5CBEe5KHkktZSd6
 Tkk7+6jUoCa0QKNw1mrsazKk1mM0HnD9wKwU1OhjU4dTH5q3IDfhoeJKlCW4g1dVH8t+
 SRpO+XoQi9E3FMrnYpGOOTUSuNQy+4CILQ6NjKpmuGxYDixSzSziL76sgsR+C1VfpRYx nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrwwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:18:00 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE9H1E029797;
        Tue, 11 Jul 2023 14:17:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8bbrvwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:17:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B5uOlv030259;
        Tue, 11 Jul 2023 14:16:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59tu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGIdu26804502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:18 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 751FA20043;
        Tue, 11 Jul 2023 14:16:18 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00FDC20049;
        Tue, 11 Jul 2023 14:16:18 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:17 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 14/22] s390x: uv-host: Add cpu number check to test_init
Date:   Tue, 11 Jul 2023 16:15:47 +0200
Message-ID: <20230711141607.40742-15-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w8U2BnAaQJ1VNHGovyZkd8oPWdEchwQJ
X-Proofpoint-GUID: MHCGwTkc7ZLQA-wtehoaJOgcSLoILC2d
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

We should only run a test that needs more than one cpu if a sufficient
number of cpus are available.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-5-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 08ef266..c04cdd7 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -550,11 +550,15 @@ static void test_init(void)
 	       "storage below 2GB");
 	uvcb_init.stor_origin = tmp;
 
-	smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
-	rc = uv_call(0, (uint64_t)&uvcb_init);
-	report(rc == 1 && uvcb_init.header.rc == 0x102,
-	       "too many running cpus");
-	smp_cpu_stop(1);
+	if (smp_query_num_cpus() > 1) {
+		smp_cpu_setup(1, PSW_WITH_CUR_MASK(cpu_loop));
+		rc = uv_call(0, (uint64_t)&uvcb_init);
+		report(rc == 1 && uvcb_init.header.rc == 0x102,
+		       "too many running cpus");
+		smp_cpu_stop(1);
+	} else {
+		report_skip("Not enough cpus for 0x102 test");
+	}
 
 	rc = uv_call(0, (uint64_t)&uvcb_init);
 	report(rc == 0 && uvcb_init.header.rc == UVC_RC_EXECUTED, "successful");
-- 
2.41.0

