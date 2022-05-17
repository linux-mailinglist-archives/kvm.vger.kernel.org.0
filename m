Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4552A0E5
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345840AbiEQL44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345716AbiEQL4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:56:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BA265EF;
        Tue, 17 May 2022 04:56:19 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBM335012613;
        Tue, 17 May 2022 11:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=o9L9/ukF/ryeTfjj7Se/m4P3HTqUokRQnQxujg/L0kA=;
 b=I5mArOKZksEz5yzIuNYEQiaaaPPgzz3zP7QbZWhVLgVH8T1BXAJS1crfoEdOoCToCiZO
 1dRxGeRoxYW3s5b5eI6RFDLDfQ2P/i456sn3DgW/9N6ZzjCOJXGvHk+8axGDTjLcwT8N
 VI75Jb1XIJbHhdReSYHplqmS7gad0M6NhFLZQsAJTSOyghMN/oMg/yfeKm/9k9WcrrOt
 GOrAoVDv6MlI7FxEy57/MiyPYSxOoslTC9LZEyXLwU0gqRz4O70neRcqN2oCgBlVwbBm
 vx88WiUubGlsooSpPPqMKsffNurnnZk6IXhs4/Ie6AGkvp59hYT23s3tRpsYfanOZXom vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artgn5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:18 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBfmT7024445;
        Tue, 17 May 2022 11:56:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artgn4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:17 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBqvfv003708;
        Tue, 17 May 2022 11:56:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3g24293aae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBuBch57868566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:56:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18267A404D;
        Tue, 17 May 2022 11:56:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE05A4040;
        Tue, 17 May 2022 11:56:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:56:10 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 4/4] s390x: Test effect of storage keys on diag 308
Date:   Tue, 17 May 2022 13:56:07 +0200
Message-Id: <20220517115607.3252157-5-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220517115607.3252157-1-scgl@linux.ibm.com>
References: <20220517115607.3252157-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6gMla2h8NMrbGBLxb6uty4aRBu80avpw
X-Proofpoint-GUID: VNB8iT1LcHYkrOcZTV60GBsCToDXtvZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that key-controlled protection does not apply to diag 308.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 s390x/skey.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/s390x/skey.c b/s390x/skey.c
index 60ae8158..c2d28ffd 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -285,6 +285,31 @@ static void test_store_cpu_address(void)
 	report_prefix_pop();
 }
 
+static void test_diag_308(void)
+{
+	uint16_t response;
+	uint32_t (*ipib)[1024] = (void *)pagebuf;
+
+	report_prefix_push("DIAG 308");
+	(*ipib)[0] = 0; /* Invalid length */
+	set_storage_key(ipib, 0x28, 0);
+	/* key-controlled protection does not apply */
+	asm volatile (
+		"lr	%%r2,%[ipib]\n\t"
+		"spka	0x10\n\t"
+		"diag	%%r2,%[code],0x308\n\t"
+		"spka	0\n\t"
+		"lr	%[response],%%r3\n"
+		: [response] "=d" (response)
+		: [ipib] "d" (ipib),
+		  [code] "d" (5)
+		: "%r2", "%r3"
+	);
+	report(response == 0x402, "no exception on fetch, response: invalid IPIB");
+	set_storage_key(ipib, 0x00, 0);
+	report_prefix_pop();
+}
+
 /*
  * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
  * with access key 1.
@@ -714,6 +739,7 @@ int main(void)
 	test_chg();
 	test_test_protection();
 	test_store_cpu_address();
+	test_diag_308();
 	test_channel_subsystem_call();
 
 	setup_vm();
-- 
2.33.1

