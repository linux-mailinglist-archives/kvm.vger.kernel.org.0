Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07F975F045
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjGXJul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjGXJt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EBF30EC;
        Mon, 24 Jul 2023 02:47:55 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9dcKu029347;
        Mon, 24 Jul 2023 09:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YQJy/BXNNYvw+mu2oPv4Yu2e4F5FrpGUg51TjYpurHY=;
 b=b9SpIqp0n+Ae5o+WWKwy30sBRk7tbTh9ue5tckNBcU2p3c6TKPn9LSNdsReBjcciYeUb
 KLycwlWvfINgvVhQGojhi+DUslLkhvSmX05akvZG6VrPFG9I5619g80xEKucy2eTrAdd
 H2lnuKn1pmqV/7rGLBS3U5qNeH7mXxe4QwkU8AQ0QfrAjfJAx6SxV8ELlksJDj0bF46G
 ZRsYSGjpLGArx+105O05CvhtwxK5sc4XOn00mhz4fK5R4i5o2VWTpzDhefQRpcliWcM6
 ZQHbU6PV1e1t4ojreyhzLkFhO/aTuCYmSljIQw9bGSHc8qtcze2B7hQCH12izLZ7452f gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s0hw2gn2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:37 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9enYX002905;
        Mon, 24 Jul 2023 09:47:37 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s0hw2gn2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:37 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O7mBLu001851;
        Mon, 24 Jul 2023 09:47:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unj1k1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lXme46072452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AC4E20040;
        Mon, 24 Jul 2023 09:47:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B68C420049;
        Mon, 24 Jul 2023 09:47:32 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:32 +0000 (GMT)
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
Subject: [PATCH v3 5/6] KVM: s390: interrupt: Fix single-stepping keyless mode exits
Date:   Mon, 24 Jul 2023 11:44:11 +0200
Message-ID: <20230724094716.91510-6-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230724094716.91510-1-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gyKDY0v399DNHjOnaUkPyhaSOmsiNhUx
X-Proofpoint-GUID: RuNCpFDJXaayn6G42oNpOZMGDgymm_4N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=918 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240084
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
index d2f7940c5d03..62b3b956c843 100644
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

