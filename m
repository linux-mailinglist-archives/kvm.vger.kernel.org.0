Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDAB66CE81
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjAPSNV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbjAPSMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:12:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C6638B68
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 09:59:06 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHlvn2023250
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VNgpHTKejN8N3y4iYvj+pn4nVbMqC3wMRtbkD5eBpEA=;
 b=QH8KRKvFkHHH6n2Vp8Z+fvKz4PeYhT6xBsuUvVkh5KehVyzwZ3W7cX+2mMMp8+afkBsJ
 TENWrTVC9m2V4B4mvSuqji38w8KlBgVZoZlKUan9sM8ydbZ07afv/awIgJU0Clq32R+z
 6OD/uMG+EMmO5PJzpqGPNydg+TzmmsejNgtD5JMx+Y8ijDEZFM+57Si/gHZ2uqziC1mg
 Unc9+mMFJQ91zz1B08hmLaxBho5Gz2BrlgTlZ6cPrg34cXzOUDnmMYs9XaFyWOem9mGS
 aMZswn1Qe+pa7b6/tmzu2Y6m5n+6+fjc3Tlja+/gIYRzaPyq8lo3ufZ0rclvsjjjCRFU 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n54r9tevh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHx5eh015965
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:59:05 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n54r9teuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:05 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GDO2qF004582;
        Mon, 16 Jan 2023 17:59:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3n3m16a0a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 17:59:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GHwxRu49218030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 17:58:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 798902004B;
        Mon, 16 Jan 2023 17:58:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D94E320040;
        Mon, 16 Jan 2023 17:58:58 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.31.34])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 17:58:58 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH 4/9] s390x/Makefile: refactor CPPFLAGS
Date:   Mon, 16 Jan 2023 18:57:52 +0100
Message-Id: <20230116175757.71059-5-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116175757.71059-1-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GWommfxH3WyoXo5f-0MyJj6Pnfy0ZOP9
X-Proofpoint-ORIG-GUID: QEyHEn5NovB3YyLJaK0pcZpcgHMYcWaA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 spamscore=0 mlxlogscore=800 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301160131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change makes it easier to reuse them.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 s390x/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/s390x/Makefile b/s390x/Makefile
index b6bf2ed99afd..032524373593 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -63,9 +63,12 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
+INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x lib
+CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
+
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
+CFLAGS += $(CPPFLAGS)
 CFLAGS += -O2
 CFLAGS += -march=zEC12
 CFLAGS += -mbackchain
-- 
2.34.1

