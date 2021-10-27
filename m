Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5943C061
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 04:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbhJ0C53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 22:57:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41616 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237738AbhJ0C53 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 22:57:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R1NSaT026003;
        Wed, 27 Oct 2021 02:55:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=mquzcs8+Xk9icp/L2UVb3BYTbG1C4KfeNB7ZvqspWe8=;
 b=FkXO612HeSQWIQGNBlvI2fhHjwDvcsBmN49QKiolj49+A1rKRcrFIG272a8iHiGiLiIF
 zvo4IlJb3pF4H9Ci1tZ40aP8enklvD+eAUIYrDssFLiJStCxb5dQKgQqPtE7KNmdYDZk
 FwpFPbsRLAVd7TXyXhTje2y89KsyEXHk5nQEPonz5cqN2OSK9Ek0d+r+teuS0oRIuoKL
 PeLxhbUZ0Gj7K7a+jPa10qvz67nIfY6u61rAz/DELOd2yfvKDbc7MAle464HDMsuDb5Z
 G3FhgtYJfb3AmDpSXlfvY/P2jLjuEJGG8b3mUptIP+nHPjfgJ/xQO6YYwKjI1tHk3oVd pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bxw2ja7p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 02:55:04 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19R2nMqL012631;
        Wed, 27 Oct 2021 02:55:03 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bxw2ja7ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 02:55:03 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19R2ruOT027360;
        Wed, 27 Oct 2021 02:55:02 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01wdc.us.ibm.com with ESMTP id 3bx4efruxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 02:55:02 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19R2t1Ek44499444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 02:55:01 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A3BAB2075;
        Wed, 27 Oct 2021 02:55:01 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B5D3B2064;
        Wed, 27 Oct 2021 02:55:01 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.160.124.65])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Oct 2021 02:55:01 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [PATCH] KVM: s390x: add debug statement for diag 318 CPNC data
Date:   Tue, 26 Oct 2021 22:54:51 -0400
Message-Id: <20211027025451.290124-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VXJ7JbOy3r7Ju-4MDoNkm44dMX5bneY7
X-Proofpoint-GUID: 6KXx7qR0PtCcGlQ6QCtBaRQdeA3IWHnp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_07,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270012
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The diag 318 data contains values that denote information regarding the
guest's environment. Currently, it is unecessarily difficult to observe
this value (either manually-inserted debug statements, gdb stepping, mem
dumping etc). It's useful to observe this information to obtain an
at-a-glance view of the guest's environment, so lets add a simple VCPU
event that prints the CPNC to the s390dbf logs.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..da3ff24eabd0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4254,6 +4254,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
 		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
 		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
+		VCPU_EVENT(vcpu, 2, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);
 	}
 	/*
 	 * If userspace sets the riccb (e.g. after migration) to a valid state,
-- 
2.31.1

