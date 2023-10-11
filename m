Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EF7C4DC4
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345739AbjJKI5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345652AbjJKI47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:56:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F520BA;
        Wed, 11 Oct 2023 01:56:57 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8srm0020451;
        Wed, 11 Oct 2023 08:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0zPOz7x89n6p8+3LYNGYTUmGK9PbxGrBfAyFwA+l8sM=;
 b=eLkUwUCl/sojayVTvMITch6QErkYjVRqPCXWCVYXPhddcMQX/HPEweMSzbK+3ZOgwD/a
 dgSlBSAHv5x4aqyK9nr9ta9Xqv/oaB7pYLubJc9sQKx7UGFOy3gYyOTcVFeqUOPKfBCW
 0owF4LiWOH5wiaoz5YFgdKg6jwMIvgNBt1J6zNdqfwNYLWYMrFHc8oeWfkNYWl7LyHTy
 21Vp6dW/wE4zQ7Mj0ZQOZc496ZQWTxfRr+atUJIzHCcgaNpGdnu5wpm5wErNwpBq389u
 ZZjgkph0FZWZQeioHUiU1doO45Hc1jl1gl/QLKJQbQTUJMzxvWfOztF4zWa3BbNlg0zo lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw01fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:47 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8uKFv024852;
        Wed, 11 Oct 2023 08:56:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw01f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:46 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B7QNwv023106;
        Wed, 11 Oct 2023 08:56:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1pcqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8uhjs24642280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:43 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5BF720043;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A49E320040;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:42 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH 6/9] s390x: topology: Rename topology_core to topology_cpu
Date:   Wed, 11 Oct 2023 10:56:29 +0200
Message-Id: <20231011085635.1996346-7-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HiYsuaFR2vK8Ps1J9VZfdEX8cJyjPCwB
X-Proofpoint-GUID: qNCjy8k7mVX7CNo4MMQp_scuya7sx-h4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is more in line with the nomenclature in the PoP.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 lib/s390x/stsi.h | 4 ++--
 s390x/topology.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
index 1351a6f3..8a97f44e 100644
--- a/lib/s390x/stsi.h
+++ b/lib/s390x/stsi.h
@@ -30,7 +30,7 @@ struct sysinfo_3_2_2 {
 };
 
 #define CPUS_TLE_RES_BITS 0x00fffffff8000000UL
-struct topology_core {
+struct topology_cpu {
 	uint8_t nl;
 	uint8_t reserved1[3];
 	uint8_t reserved4:5;
@@ -50,7 +50,7 @@ struct topology_container {
 
 union topology_entry {
 	uint8_t nl;
-	struct topology_core cpu;
+	struct topology_cpu cpu;
 	struct topology_container container;
 };
 
diff --git a/s390x/topology.c b/s390x/topology.c
index 0ba57986..c1f6520f 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -246,7 +246,7 @@ done:
 static uint8_t *check_tle(void *tc)
 {
 	struct topology_container *container = tc;
-	struct topology_core *cpus;
+	struct topology_cpu *cpus;
 	int n;
 
 	if (container->nl) {
-- 
2.41.0

