Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619AF786F6B
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbjHXMq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239192AbjHXMqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDCBE59;
        Thu, 24 Aug 2023 05:46:22 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgmVR019888;
        Thu, 24 Aug 2023 12:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/DXnYDnOUNzy3YJlD4pxLtS9/09QGNwXUTgbXk5u/uI=;
 b=ihfcn2lnUqvqjZcEhP+wZxol0pHqCvHA3jbjU0RtOJhrOihyIXy1SHwLbymBfa+1I06i
 SjcWxc2dG/ESW8gU02Bg/1ECeOXcz5fUlgi5sDPcvXLhrNeBX6f9k5vQ8xBW/TA5Rodb
 Cmab1wyu4bnypv1Lyu/ImW65e6Fg5P3fHVSJhy1kgCSorcytXkZdlGN3I9REZjojzC9Y
 Ta2L2e4NMkjQDYFG61KpiVSihzRW7g0eevqLitDCMfbKatXl03NvFz02YXV7OtHALPGX
 h4t/ZWeeWiDjQIEVRathjCyW/WjaMJXWq725zMBWYMmtPZvRHvQdyZvuyjXtR+YI7z+o 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0gmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:21 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OChlaH025816;
        Thu, 24 Aug 2023 12:46:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0gam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:18 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCcAgY027333;
        Thu, 24 Aug 2023 12:46:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn20sq12n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCkCDV19792504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A3342004B;
        Thu, 24 Aug 2023 12:46:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66EF520040;
        Thu, 24 Aug 2023 12:46:11 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 05/22] KVM: s390: interrupt: Fix single-stepping keyless mode exits
Date:   Thu, 24 Aug 2023 14:43:14 +0200
Message-ID: <20230824124522.75408-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i-YY1tJCxHb8Ri8arOBYjSI-EqyPIFYr
X-Proofpoint-GUID: VYKE1Mq14U08MMM-LhfblQeJN4WN8hC7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=650
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

kvm_s390_skey_check_enable() does not emulate any instructions, rather,
it clears CPUSTAT_KSS and arranges the instruction that caused the exit
(e.g., ISKE, SSKE, RRBE or LPSWE with a keyed PSW) to run again.

Therefore, skip the PER check and let the instruction execution happen.
Otherwise, a debugger will see two single-step events on the same
instruction.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Message-ID: <20230725143857.228626-6-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

