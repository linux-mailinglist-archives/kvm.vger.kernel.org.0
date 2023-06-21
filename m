Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED90738977
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjFUPfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbjFUPeo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:34:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13011FE0;
        Wed, 21 Jun 2023 08:34:24 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LFPXr3010211;
        Wed, 21 Jun 2023 15:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ior3p9PwOvimuqOAF02R59UYURSdnc9HphpU5H5wHCs=;
 b=UNLUfXO7K8v86UQoEQBMnCASwJter9yYfhQgJs027tdjnpmmCaNbbDjdKH78vufik23O
 rQL3SQcqAtmzNAUH+Lkq+qG6qWmfhYWCZJrHDLEDJ3SVp70p3r1a1eZhHyP2jHNrvT75
 NhyL/PFO084m6n/E8JSEsHpi7ybHaK6MLIf4GKpgOU+AXkYqVaJtGhXOE1CvwVPzzu6i
 NBEbprSXwN/1xUtlzqJ4oyf7HEQ1ITPb6BG1hEyO0AELvD3+frF+K/rzDuFApojb1966
 VmKSlPjCvi43A92MLxT71Gj5PAXlR0xGZBaeAey6ErSuYvDWhHiQ8slw0sKN/IgnTuor sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70ahr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:24 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35LFSnNm020619;
        Wed, 21 Jun 2023 15:34:23 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rc3u70aex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35L3IF3f011691;
        Wed, 21 Jun 2023 15:34:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3r94f5audy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:20 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35LFYHHa23528008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jun 2023 15:34:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91EA820040;
        Wed, 21 Jun 2023 15:34:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AFF520043;
        Wed, 21 Jun 2023 15:34:17 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.33.34])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jun 2023 15:34:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, nrb@linux.ibm.com, pmorel@linux.ibm.com
Subject: [GIT PULL 04/11] KVM: s390/diag: fix racy access of physical cpu number in diag 9c handler
Date:   Wed, 21 Jun 2023 17:29:10 +0200
Message-ID: <20230621153227.57250-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230621153227.57250-1-frankja@linux.ibm.com>
References: <20230621153227.57250-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: J-Qt72TXcM1nsAS-UWapBcjkjhosxfz6
X-Proofpoint-ORIG-GUID: AvHH4HyVD0REpdDG3Xyl-Ex9r0n14wrR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_08,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306210131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

We do check for target CPU == -1, but this might change at the time we
are going to use it. Hold the physical target CPU in a local variable to
avoid out-of-bound accesses to the cpu arrays.

Cc: Pierre Morel <pmorel@linux.ibm.com>
Fixes: 87e28a15c42c ("KVM: s390: diag9c (directed yield) forwarding")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/diag.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 807fa9da1e72..3c65b8258ae6 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -166,6 +166,7 @@ static int diag9c_forwarding_overrun(void)
 static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *tcpu;
+	int tcpu_cpu;
 	int tid;
 
 	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
@@ -181,14 +182,15 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 		goto no_yield;
 
 	/* target guest VCPU already running */
-	if (READ_ONCE(tcpu->cpu) >= 0) {
+	tcpu_cpu = READ_ONCE(tcpu->cpu);
+	if (tcpu_cpu >= 0) {
 		if (!diag9c_forwarding_hz || diag9c_forwarding_overrun())
 			goto no_yield;
 
 		/* target host CPU already running */
-		if (!vcpu_is_preempted(tcpu->cpu))
+		if (!vcpu_is_preempted(tcpu_cpu))
 			goto no_yield;
-		smp_yield_cpu(tcpu->cpu);
+		smp_yield_cpu(tcpu_cpu);
 		VCPU_EVENT(vcpu, 5,
 			   "diag time slice end directed to %d: yield forwarded",
 			   tid);
-- 
2.41.0

