Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E40525F59
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379202AbiEMJvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379171AbiEMJvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887D45716C;
        Fri, 13 May 2022 02:51:49 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D7UooF006336;
        Fri, 13 May 2022 09:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CBlQFujlHui4J0+Bukn5kJ6beRwi1q8Q0IXGaXG08WA=;
 b=F2hpGAotyu6hV3HgJ7xpxWCscJzobgRS5o83Bnldmq39eu46GNfl68agVUEO0QO2CZrh
 qjhCA3iRQwLaHh+Iv0fsTXHOCGitQRFSydxc/QFcfCgjzKBVSLv7tCviIryx3TamjXv3
 +5+fjA4vGndVHhr4Q7W9ZjMcSXxqjlQZUvfE3XvcCyGOKW22QQ3+Id5RrbjABbi7BhlX
 efuSWFOxQQb05FHps4/lGS1capnKB/AvrPMYP3KZzsAfg3bGJCT7BmT3mwXGvE4re9++
 3Uxxh9svlw2YgpweEyzaAp/r5ZPg0GszNVKuZsTSOAjUBh6GzSQMwDgXJNiHCm101wnx YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1k0s2gw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:48 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D9e862018260;
        Fri, 13 May 2022 09:51:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1k0s2gvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:47 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9RJGI006771;
        Fri, 13 May 2022 09:51:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g0kn79x15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9pJLP27787592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:51:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07C624C05A;
        Fri, 13 May 2022 09:51:43 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294FF4C044;
        Fri, 13 May 2022 09:51:42 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/6] s390x: uv-host: Test uv immediate parameter
Date:   Fri, 13 May 2022 09:50:14 +0000
Message-Id: <20220513095017.16301-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220513095017.16301-1-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DQIw_PX2P2uvRyfT1Uea1cTzt1XwiLo9
X-Proofpoint-ORIG-GUID: j0I6DDIt_qkwP3Wi99MMT_AjFEFtY5MH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 bulkscore=0 clxscore=1015 impostorscore=0 mlxlogscore=957
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if we get a specification PGM exception if we set a
non-zero i3 when doing a UV call.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index f846fc42..fcb82d24 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -64,6 +64,28 @@ static struct cmd_list cmds[] = {
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
2.34.1

