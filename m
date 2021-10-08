Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB142724A
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242304AbhJHUdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231727AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRLKm005256;
        Fri, 8 Oct 2021 16:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uHpyvHqjwJ8IYZVsiMIsYPtYhbbZRSqkxRJzIWRN7vU=;
 b=NWAB1ghH9vf5tsfGqnH+PdokC1FDc/kVbD2BD4RSdxQhbzySQnNAO+kzVCMtJvPq590R
 RqWH9tO3Wyu6rFW6dcs3y0DiRrv6ruN+OrjZ6LKuUzqKZDQokqXlz7zGhb1e/cK+zwOy
 Pjt6X+3PiAJRtDYEwrPkEF6K3wGA4/v33XUabwpYTAjuzEtTTlkNg4tjtcHf/5chwPen
 xoNjtVscAr5bt3qqAcH6yHHy81lapa1MK858JFpR1zqvEPR3oWAVBW8zSoQDS2F9zJAB
 pveGgi1oh1t8TCxWfZEEGG+Zl1/x3fYkhvSlOg1UVeV8KXuLv6g89XyzVJQExZ/xjPyQ lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvcagwec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:31 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KRI8r005205;
        Fri, 8 Oct 2021 16:31:31 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bjvcagwdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMqCf004726;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3beepkhfbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVO2Q60228044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A85F752065;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9C0DE5205A;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 3A08DE032A; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 1/6] KVM: s390: Simplify SIGP Set Arch handling
Date:   Fri,  8 Oct 2021 22:31:07 +0200
Message-Id: <20211008203112.1979843-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pYCpqghDSiebbWvHwvSlz1HiJFrX53wf
X-Proofpoint-GUID: KfGNC0xgXfGoH2QjCzMICnGE90cVJD-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Principles of Operations describe the various reasons that
each individual SIGP orders might be rejected, and the status
bit that are set for each condition.

For example, for the Set Architecture order, it states:

  "If it is not true that all other CPUs in the configu-
   ration are in the stopped or check-stop state, ...
   bit 54 (incorrect state) ... is set to one."

However, it also states:

  "... if the CZAM facility is installed, ...
   bit 55 (invalid parameter) ... is set to one."

Since the Configuration-z/Architecture-Architectural Mode (CZAM)
facility is unconditionally presented, there is no need to examine
each VCPU to determine if it is started/stopped. It can simply be
rejected outright with the Invalid Parameter bit.

Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/sigp.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 683036c1c92a..cf4de80bd541 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
 static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
 			   u64 *status_reg)
 {
-	unsigned int i;
-	struct kvm_vcpu *v;
-	bool all_stopped = true;
-
-	kvm_for_each_vcpu(i, v, vcpu->kvm) {
-		if (v == vcpu)
-			continue;
-		if (!is_vcpu_stopped(v))
-			all_stopped = false;
-	}
-
 	*status_reg &= 0xffffffff00000000UL;
 
 	/* Reject set arch order, with czam we're always in z/Arch mode. */
-	*status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
-					SIGP_STATUS_INCORRECT_STATE);
+	*status_reg |= SIGP_STATUS_INVALID_PARAMETER;
 	return SIGP_CC_STATUS_STORED;
 }
 
-- 
2.25.1

