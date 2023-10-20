Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2447D11E8
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377601AbjJTOyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377572AbjJTOyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:54:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414A19E;
        Fri, 20 Oct 2023 07:54:36 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEqJHA029235;
        Fri, 20 Oct 2023 14:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DxwOxLTaVIOxqj5rHYlkclCvDezNc43Dr8HDZdxQzik=;
 b=pYu8CDELwEGHvNKsDedNrVigB8nnmPH3LcmpjvmySKM0GTB/4K1TL23SoPvcUrYWrGCp
 W36Su0VkPsNhZjzR0AYrwwFppP8osyzGAaE1YU1sWEcuEUFbY0/pukd+nseqefDuuKMv
 Qw4T/8KY4QkQ7KvQ2Klb/EwoA0Wjb6pZiUBxG6aymwv7Tj/lAAyjUaE6CiynGyHtJZ3f
 5/tEqspxfTlH/Y66+3twmQK27o+DlEKevzzdEv11Buo15AV6ysionx8LFVYdlg6XSN/J
 4gg+VMSKAuFBEjmwWkNFcxnQ7NYk5lM9MfLgU3p22PyoJpPLsmTLHvCWpReWIAiGp24y hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuupp83yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:54:20 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KEqb8n031132;
        Fri, 20 Oct 2023 14:54:17 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuupp83jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:54:17 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KCE5rV024173;
        Fri, 20 Oct 2023 14:49:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc295746-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn4D125494158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C037320040;
        Fri, 20 Oct 2023 14:49:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D59220043;
        Fri, 20 Oct 2023 14:49:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:04 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 03/10] s390x: topology: Use function parameter in stsi_get_sysib
Date:   Fri, 20 Oct 2023 16:48:53 +0200
Message-Id: <20231020144900.2213398-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231020144900.2213398-1-nsg@linux.ibm.com>
References: <20231020144900.2213398-1-nsg@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JzZtiTbeqGieTsQ50I2Ige68RD5EedKo
X-Proofpoint-GUID: qOdgj06jT2O6LRGD8M2XexLOPcU-rien
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=984
 spamscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Actually use the function parameter we're give instead of a hardcoded
access to the static variable pagebuf.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/s390x/topology.c b/s390x/topology.c
index 1c4a86fe..032e80dc 100644
--- a/s390x/topology.c
+++ b/s390x/topology.c
@@ -324,7 +324,7 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
 
 	report_prefix_pushf("SYSIB");
 
-	ret = stsi(pagebuf, 15, 1, sel2);
+	ret = stsi(info, 15, 1, sel2);
 
 	if (max_nested_lvl >= sel2) {
 		report(!ret, "Valid instruction");
-- 
2.41.0

