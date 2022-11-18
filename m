Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E15D62F8F4
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 16:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiKRPLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 10:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiKRPLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 10:11:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BAE13DCA;
        Fri, 18 Nov 2022 07:11:40 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIE7GYE005037;
        Fri, 18 Nov 2022 15:11:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JbdHzen0e4pCuiUEYzCHgMbnfJNWJPONv+SD25uCxeE=;
 b=GxwOu1v88gAHCJljtiu4tcica5D7d/coZqrEgfZp+5euoS3us3UlJBTw8fJ5gwilTemo
 X5ih3IX64JWxyDsYxDgu5m5AqczTn02CXeF5iXFqeDX37iZbx+YDYY2lZYuyD1p1ZIG4
 7LDwf+QTMIsdwSC4BIZGLkaF7ABMENmmxjmG9hQgA9bKIji+z3YE3CgvZzju3NKJEEtQ
 AH0TdLWvuwEU7U7NAux8RcjdkxGBNCy/v6dV1G7F2TrGa/54J7TvWjjGsa3RgwkQ39qZ
 V+GvBcLmKTuBRODKINv6RM7IerUoOj0UzwHtDoKNg6NN0eRUC/lTCZzyzslzAXckC5xh Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx7suymyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 15:11:40 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AIE7JoK005652;
        Fri, 18 Nov 2022 15:11:39 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx7suymx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 15:11:39 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AIF7W5G019105;
        Fri, 18 Nov 2022 15:11:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3kwppt113v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 15:11:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AIFBX8d60293556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 15:11:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB6B95204E;
        Fri, 18 Nov 2022 15:11:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 988ED52050;
        Fri, 18 Nov 2022 15:11:33 +0000 (GMT)
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH] KVM: s390: remove unused gisa_clear_ipm_gisc() function
Date:   Fri, 18 Nov 2022 16:11:33 +0100
Message-Id: <20221118151133.2974602-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3iSF9-cFcmoW_ze9JfcuVVpA0C8sYDx2
X-Proofpoint-GUID: fpoevSHkcQLDJPGJcl4Tnh4exrB7hoaF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_03,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 spamscore=0 mlxscore=0 bulkscore=0 mlxlogscore=716 phishscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211180088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang warns about an unused function:
arch/s390/kvm/interrupt.c:317:20:
  error: unused function 'gisa_clear_ipm_gisc' [-Werror,-Wunused-function]
static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)

Remove gisa_clear_ipm_gisc(), since it is unused and get rid of this
warning.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab569faf0df2..1dae78deddf2 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -314,11 +314,6 @@ static inline u8 gisa_get_ipm(struct kvm_s390_gisa *gisa)
 	return READ_ONCE(gisa->ipm);
 }
 
-static inline void gisa_clear_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
-{
-	clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
-}
-
 static inline int gisa_tac_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
 {
 	return test_and_clear_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long *) gisa);
-- 
2.34.1

