Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D40A6C6578
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjCWKn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjCWKn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128073B642
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:26 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N8KjBD028264
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c2Xsngf+B0AUlm9d260xy2SJteEiX0O1Q/5pzAQL44g=;
 b=cuFB7Loi9GneW8b7cspX1GraFKgtCOe1VUvGXUnfUADk1uAT55IvxUVsN8krDlZej6by
 69Vr0ekqXTz/4xbwvnHdl154ZTJ3wMnCag3lzPUwwxgvzoI/ZzKzEC3KrRCb+hMmqb1l
 ydsRAuTIzNJG79u4UNTI87ObjHnzMD9CNFaJWHXKtKHqkFF/mknpeeldFHnqI1kMaIE3
 6yMZT6Ji5lIShG3XTuJPummPxKzBVDX3spg3SpqP1cw0rn4sh6DD/IsTZhM6xvPOtjiU
 dTRqNf0+t/ic96Cy223gaBT+h8ITln/FvncK/cboJCcy7biSpwv2EHMK6StMqbqSiRqT aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk65k4cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32N8uaHV028839
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk65k4bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32N93SWC003592;
        Thu, 23 Mar 2023 10:40:22 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e3es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeIL227394738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:18 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B2FD20040;
        Thu, 23 Mar 2023 10:40:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 975652004D;
        Thu, 23 Mar 2023 10:40:17 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/8] s390x: uv-host: Add cpu number check
Date:   Thu, 23 Mar 2023 10:39:10 +0000
Message-Id: <20230323103913.40720-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3fSZ070LbHiYQBWRBcS4n6OMZ7_DEF4e
X-Proofpoint-GUID: M94QFlLQHLM02kzXqYes5lq0to7dUkMM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should only run a test that needs more than one cpu if a sufficient
number of cpus are available.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 0f550415..42ea2a53 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -546,11 +546,15 @@ static void test_init(void)
 	       "storage below 2GB");
 	uvcb_init.stor_origin = mem;
 
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
2.34.1

