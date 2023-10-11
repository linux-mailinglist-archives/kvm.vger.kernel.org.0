Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2107C4E06
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 11:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjJKJCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 05:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjJKJB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 05:01:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCC81AB;
        Wed, 11 Oct 2023 02:01:27 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8sink020083;
        Wed, 11 Oct 2023 09:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4VQsNAEFtrPSQ948+ACf44EN5Nl4Tf18U/G+gwA9BTM=;
 b=m2z5WxM4AVcHMOeNSWyOCAKEz7fxiCDW9qbAJAX/t1aR6Cw0y9gDWb9XYqlE5CRhTK2C
 Eni1LLWszP8rmEKcbhXHRkjJ0MMv0amGeJViLgNywAlzL7yR3R+H7wTaWZxoBuNoblsD
 HqlhEWvq530GlQ/ZIEA7ZCglUFymvOvlDNbdKqGjOtUwyv3APB3HVKxnF2WUEHT053tq
 L4oX997QBqcqrxvvYp3P7sqpAi9Arfj9oSl60J+ckf/qD9jlLRgMJyTIiRDEyBeT6nGW
 NnPKA6DEonpQ1Dv1XPCg9v5vllQN/6VE9RVPhZ7vQEcQTuNF2RS1bqB6p16o4SQIzymn Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw07c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 09:01:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39B8t3co020892;
        Wed, 11 Oct 2023 09:01:22 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnrkw0750-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 09:01:22 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39B8h7W6025927;
        Wed, 11 Oct 2023 08:56:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkjnneuuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 08:56:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39B8ueSM44826886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 08:56:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6220D20043;
        Wed, 11 Oct 2023 08:56:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D55420040;
        Wed, 11 Oct 2023 08:56:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 08:56:40 +0000 (GMT)
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
        Sean Christopherson <seanjc@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Subject: [kvm-unit-tests PATCH 2/9] s390x: topology: Use parameter in stsi_get_sysib
Date:   Wed, 11 Oct 2023 10:56:25 +0200
Message-Id: <20231011085635.1996346-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231011085635.1996346-1-nsg@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S7RUchPPzr8Py3ntilBLFnLZJafhBFOk
X-Proofpoint-GUID: QQbct2fNsiDv3IrokMIAdlZt9ZbXxL_q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_06,2023-10-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=994
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of accessing global pagebuf.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 53838ed1..e1bb6014 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -322,7 +322,7 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	report_prefix_pushf("SYSIB");
 
-	ret = stsi(pagebuf, 15, 1, sel2);
+	ret = stsi(info, 15, 1, sel2);
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-- 
2.41.0

