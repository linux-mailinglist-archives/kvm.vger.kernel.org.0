Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760DC58EC73
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiHJM4x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiHJM4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:56:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB965C349;
        Wed, 10 Aug 2022 05:56:38 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACoQWp012677;
        Wed, 10 Aug 2022 12:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=8+oT9Nis5SKah9qTR3TP8xCyoTW/s4DlrF3m5iveus0=;
 b=aookoxmhPpcIx/2uPVoefBQqhfRaBKurFGSfLopJrnOJiIWEIoxL4S7+79PRqkURK4Nm
 QVtqdGX63UotogcdRWPPgTzKOZMUk9m48eBZKQGwFxcHkHkxaAPE0LhHq3f/511yKaIG
 oaLmaqU5ucPPKLCZreqr1Z9W2SYSY7FmSpp3XtrpiJrKUFxUvPxP9+arzgeSoyOQPJ18
 /YLX5L6ggPtdVfaHqs1YCLhUylip6G2xtTQHdPvrRcIb6kkTP3ZJVaPH8nPfG3TpKJT3
 Pb8Xr5QAvs0VhoP25v7QAu9beIDR/Y5eunDE+FzaobQ8j5rQsa0B2/4Kma//GWR01ab1 SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv6dcw2g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:37 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ACpaRR019554;
        Wed, 10 Aug 2022 12:56:37 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv6dcw2en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:37 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACpU2k021444;
        Wed, 10 Aug 2022 12:56:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3huwvjgmr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACuVbV18874850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:56:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EC584C044;
        Wed, 10 Aug 2022 12:56:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DFA54C040;
        Wed, 10 Aug 2022 12:56:30 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 6/6] KVM: s390: pv: module parameter to fence asynchronous destroy
Date:   Wed, 10 Aug 2022 14:56:25 +0200
Message-Id: <20220810125625.45295-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810125625.45295-1-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eFnpAkKohgDH_k706ceUmYZbBM5b18gU
X-Proofpoint-GUID: MOTEmYVFB1IHnFsteb1kTmxixtJp15uB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "async_destroy", to allow the asynchronous
destroy mechanism to be switched off. This might be useful for
debugging purposes.

The parameter is enabled by default since the feature is opt-in anyway.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 4a20a6be6601..8c7af96c4546 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -209,7 +209,13 @@ unsigned int diag9c_forwarding_hz;
 module_param(diag9c_forwarding_hz, uint, 0644);
 MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
 
-static int async_destroy;
+/*
+ * allow asynchronous deinit for protected guests; enable by default since
+ * the feature is opt-in anyway
+ */
+static int async_destroy = 1;
+module_param(async_destroy, int, 0444);
+MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
 
 /*
  * For now we handle at most 16 double words as this is what the s390 base
-- 
2.37.1

