Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371F64E2432
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346282AbiCUKUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346257AbiCUKUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:38 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F08B2B26A;
        Mon, 21 Mar 2022 03:19:13 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L8QZ6c008491;
        Mon, 21 Mar 2022 10:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XlkiD+9qIVAFCk0Bh+L1998DKrnzpvIqppMNI7tlHdo=;
 b=MuUIND90FJnzWxPzBbF2amXlf9yQOrFAPTI0aPyaProxrhy3n56OzvPECcDHXI0PfiC7
 5YqQcdZwjvYfrmTfexr0ZU8dO3WIq1arUwhhFBQbI/eJdpG0l8cIzJccKSE7n89n4Ljm
 NevTO8Rg4TZEO3gDwgEVeRY4eQw/U9eRqrs8GkYzWXgY9gM9Y3zI6U4/3pacKqygI/fN
 9juWw9y0NQE3dN4Uy2ir6hQxtXOvPmOjwZnsA8sSUbc0oJRuujC3I2JWSGgjcltAfPjj
 OtFbIGvoNsZyldiGZvb1DXUsrR5Qw1INM2DuQBGO9NvpnYEiUDClqGAx+WfynwLpypYf aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exbyk36s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:12 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LABDEa040014;
        Mon, 21 Mar 2022 10:19:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exbyk36rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LADrBe016149;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t8ujt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ70g40567064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EEB011C04A;
        Mon, 21 Mar 2022 10:19:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D47D111C050;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 6/9] s390x: smp: add test for EMERGENCY_SIGNAL with invalid CPU address
Date:   Mon, 21 Mar 2022 11:19:01 +0100
Message-Id: <20220321101904.387640-7-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f5MvrnN2XrTt7M2j0fTgTBv6NR29xQet
X-Proofpoint-ORIG-GUID: K7l_EQpyAp5UJnAkoO8idCWGyZGr_4wv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In this case, we expect the order to be rejected.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index f22520b4f4fc..3bd7e7c8f5ed 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -580,6 +580,7 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
+	int cc;
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
@@ -592,6 +593,14 @@ static void test_emcall(void)
 	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
 	wait_for_flag();
 	smp_cpu_stop(1);
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
+	report(cc == 3, "CC = 3");
+
+	report_prefix_pop();
+
 	report_prefix_pop();
 }
 
-- 
2.31.1

