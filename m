Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66A06F44CA
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbjEBNMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjEBNLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:11:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BF45B92;
        Tue,  2 May 2023 06:11:48 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D90g2020063;
        Tue, 2 May 2023 13:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sX+Uu2kBa/nKhMbVw52BJMR0BOcBBUsfkM+dGmUk97k=;
 b=l4VmhpqMlq2F+l3+QNdTPtMb4b/T+5c9uHZPJ849xob9+gw4e+ZalJubeyfGZupHhHqY
 6wvM/EO+bwpYgEKMuwWX+ueRrudGdpgGuky98XsVIlAGEJ5Wh6w/fqG55AzaT8PODEZ9
 NlyhFK6e9acAbMfs5AY1BT5tfXoMzCri/1qsFj8YTNF9lcXjA+T1LPpYkGAB5JaDcg3W
 ilzJyyVfia/Jo2j8SrJiWG/MT1FFbVA/NjL9f+uL3WkkrNZ0LTjTpAGerzR7Ivk0KCPR
 riwcDvNS1TsCjpfde6RO6HjNPh2HwD8RUImdUpS2ey4G97W2L+W0IgDNJkDhuSggv0u6 nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8gd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:11:47 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D99FZ022060;
        Tue, 2 May 2023 13:11:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8fp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:11:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3420u9KV023433;
        Tue, 2 May 2023 13:09:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q8tgg1m24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:30 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9Q7I3408620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A61D20049;
        Tue,  2 May 2023 13:09:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 913E720043;
        Tue,  2 May 2023 13:09:25 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:25 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 8/9] s390x: uv-host: Fence access checks when UV debug is enabled
Date:   Tue,  2 May 2023 13:07:31 +0000
Message-Id: <20230502130732.147210-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wz_bQ_4qfSvJkfO3BVIc0Dd5_jFsCWp5
X-Proofpoint-ORIG-GUID: jxL94lrs5gQ5fWB0o3pZk7uebH9kMzbD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The debug print directly accesses the UV header which will result in a
second accesses exception which will abort the test. Let's fence the
access tests instead.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 4418e9b9..19bdd465 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -165,6 +165,15 @@ static void test_access(void)
 
 	report_prefix_push("access");
 
+	/*
+	 * If debug is enabled info from the uv header is printed
+	 * which would lead to a second exception and a test abort.
+	 */
+	if (UVC_ERR_DEBUG) {
+		report_skip("Debug doesn't work with access tests");
+		goto out;
+	}
+
 	report_prefix_push("non-crossing");
 	protect_page(uvcb, PAGE_ENTRY_I);
 	for (i = 0; cmds[i].name; i++) {
@@ -197,6 +206,7 @@ static void test_access(void)
 	uvcb += 1;
 	unprotect_page(uvcb, PAGE_ENTRY_I);
 
+out:
 	free_pages(pages);
 	report_prefix_pop();
 }
-- 
2.34.1

