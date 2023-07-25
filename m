Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E48761BF5
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 16:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjGYOjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 10:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbjGYOjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 10:39:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B227A18F;
        Tue, 25 Jul 2023 07:39:12 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36PEVvPo016678;
        Tue, 25 Jul 2023 14:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PSKgy27g6aT7qxjixFMt+8BNoj+J3RcCjeTShddjaik=;
 b=hpxtsEuxiVZNFwEZZTXyAxdG1UyseWAjc0Oukc1wDfEgyjztCvHCyU2W76W5YS9G3Evh
 UkaA0xWvLHUE4Jv+1PD3Ypv70cXqsSuLl5wvUokMKUtzqaLQue0J/aq6Bo9E6ZitARqb
 LMk9lDD7WNDu7W7PLBxJzmCwcgLDrCT09mDSQ9cDci3MV+4acVeOe6pp9+vgtl7iSxvk
 C7mXwmVEK4kqW2N7EoGGooC0mXLL9f/qAPWpCeTa1pZaxczh6+hqgneF+EyLEPXbs1YV
 J0ZKqwrG0vyvlw2Mzzk0XgT2E26l+BL3DsIwCyxT19g9yAoQcM9il9k6S6HBU2rSqRDC qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wrjum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:10 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36PEX12o022379;
        Tue, 25 Jul 2023 14:39:08 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2g7wrjs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:08 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36PDfPS4002079;
        Tue, 25 Jul 2023 14:39:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0temvr75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jul 2023 14:39:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36PEd1pl23855804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 14:39:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C49A62004B;
        Tue, 25 Jul 2023 14:39:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87DAD2005A;
        Tue, 25 Jul 2023 14:39:01 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jul 2023 14:39:01 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 5/6] KVM: s390: interrupt: Fix single-stepping keyless mode exits
Date:   Tue, 25 Jul 2023 16:37:20 +0200
Message-ID: <20230725143857.228626-6-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725143857.228626-1-iii@linux.ibm.com>
References: <20230725143857.228626-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 99Rb97IJKnG_uJOCvuLI_GIypdCxZNhC
X-Proofpoint-GUID: xMnq1I8kFFhZFzb7DO1UF6AAx-xMuHmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_08,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=924
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307250128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_s390_skey_check_enable() does not emulate any instructions, rather,
it clears CPUSTAT_KSS and arranges the instruction that caused the exit
(e.g., ISKE, SSKE, RRBE or LPSWE with a keyed PSW) to run again.

Therefore, skip the PER check and let the instruction execution happen.
Otherwise, a debugger will see two single-step events on the same
instruction.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index db222c749e5e..9f64f27f086e 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -630,8 +630,8 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		rc = handle_partial_execution(vcpu);
 		break;
 	case ICPT_KSS:
-		rc = kvm_s390_skey_check_enable(vcpu);
-		break;
+		/* Instruction will be redriven, skip the PER check. */
+		return kvm_s390_skey_check_enable(vcpu);
 	case ICPT_MCHKREQ:
 	case ICPT_INT_ENABLE:
 		/*
-- 
2.41.0

