Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBEF60CB21
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiJYLoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiJYLn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1860917537A
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:55 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB7uKS006252
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Rr5w/3x1oQlLRljNtIP878GohRWWtenlK2aogyaq5dM=;
 b=LBDIIpuy4bbc3e3pkF+bgGQi9o/kjicVMi5naGPViCLxHrEZYOyMMRfV4eA9+UGxF+Cz
 ckcdwwH3Blu93oBbGoYqlsy4Rnm8rxYi65MwWck9vPyFSw0KorukjTWK7JTqYnQ0F/C+
 t/h3Pg+J0OL3NM/sdf4615P3K0w7c5UISoEqI8ihXDas/niAoKsbJhiFOIhDLm/vZJNx
 EEJjLusFLpUYqFv52q2pTIv8Kl9ydmkWi6nDx+l/9/gOcCuhwFEvxU16tgIHtJDTjnro
 MCYhNHFRfWRIuD1tYW8WCiHr0zDeNqA6FcxEDXeBw2r5obLt6OEe1FHMGOmDK0uDjn1x gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvfap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBJHWN027642
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ked6qvf9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:54 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBdmbR013584;
        Tue, 25 Oct 2022 11:43:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3kdv5fgr4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:51 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBcZDv40370652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:38:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E410AE045;
        Tue, 25 Oct 2022 11:43:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0ACAAE051;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 09/22] s390x: uv-host: Test uv immediate parameter
Date:   Tue, 25 Oct 2022 13:43:32 +0200
Message-Id: <20221025114345.28003-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dZMcyW974H22hQAAxEX7ju3a5yTzeDiD
X-Proofpoint-ORIG-GUID: zSrOqjsqfIUemayAvhmoYT14WK-_RHr1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 bulkscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=854 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's check if we get a specification PGM exception if we set a
non-zero i3 when doing a UV call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Message-Id: <20221017093925.2038-4-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 24dcd6dc..e401fa5d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -90,6 +90,28 @@ static struct cmd_list cmds[] = {
 	{ NULL, 0, 0 },
 };
 
+static void test_i3(void)
+{
+	struct uv_cb_header uvcb = {
+		.cmd = UVC_CMD_INIT_UV,
+		.len = sizeof(struct uv_cb_init),
+	};
+	unsigned long r1 = 0;
+	int cc;
+
+	report_prefix_push("i3");
+	expect_pgm_int();
+	asm volatile(
+		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],4,2\n"
+		"		ipm	%[cc]\n"
+		"		srl	%[cc],28\n"
+		: [cc] "=d" (cc)
+		: [r1] "a" (r1), [r2] "a" (&uvcb)
+		: "memory", "cc");
+	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
+	report_prefix_pop();
+}
+
 static void test_priv(void)
 {
 	struct uv_cb_header uvcb = {};
@@ -585,6 +607,7 @@ int main(void)
 		goto done;
 	}
 
+	test_i3();
 	test_priv();
 	test_invalid();
 	test_uv_uninitialized();
-- 
2.37.3

