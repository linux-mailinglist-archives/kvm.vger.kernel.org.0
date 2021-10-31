Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6515A440E2A
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhJaMOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:14:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232030AbhJaMNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:48 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VAbVsB020290;
        Sun, 31 Oct 2021 12:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=xjKMEWUCjCwCFBbsysFYeipMHaSuuxL/+UUWPBAUPVA=;
 b=YibWB+97y4YOzkMEeKLdRekuvKLN+goRHyiB6vEeiyzi4kC3iwSyWcUmookaPRqVI71D
 CWIQTHbEl71U8ERGgx6xJXCZ05Jn/ij1NmrgYY+TKQ+xnBqxt7B0FcU0o3PsdHlzeWb/
 fT0pJAhAZbHdZ6gMU6UOzVKP+7rEfHdepVvwWvFCretjnBJKK4iM3OKEywRnFNWr6QZK
 v2KzJJE1E0iftw5/7sjByyE0+z65nNpxZGraLAFKbehAkC6vVs/Pe9NSanHRtKXKIeF8
 6S+1Fr8GsGXqXnP28/NwCfRw8RvPWdqWTxreYIQINdoR8IeF0myv2vkIy9xlJvf351cG iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1r0n24uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:16 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VBx8bM010994;
        Sun, 31 Oct 2021 12:11:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1r0n24u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9Pto022996;
        Sun, 31 Oct 2021 12:11:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3c0wp9cq1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:13 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCBAn061800762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:10 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1DEDA405B;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E306A4054;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 48FFDE06C2; Sun, 31 Oct 2021 13:11:10 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 17/17] KVM: s390: add debug statement for diag 318 CPNC data
Date:   Sun, 31 Oct 2021 13:11:04 +0100
Message-Id: <20211031121104.14764-18-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cxv_cqCVsBQ_58hBk4NifLJrkW7pTRz4
X-Proofpoint-ORIG-GUID: ik2KxbL21ZxbC6Ue2AmvZgBp7MEEqwXm
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Collin Walling <walling@linux.ibm.com>

The diag 318 data contains values that denote information regarding the
guest's environment. Currently, it is unecessarily difficult to observe
this value (either manually-inserted debug statements, gdb stepping, mem
dumping etc). It's useful to observe this information to obtain an
at-a-glance view of the guest's environment, so lets add a simple VCPU
event that prints the CPNC to the s390dbf logs.

Signed-off-by: Collin Walling <walling@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20211027025451.290124-1-walling@linux.ibm.com
[borntraeger@de.ibm.com]: change debug level to 3
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6482ea9139bb..c6257f625929 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4255,6 +4255,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
 		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
 		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
+		VCPU_EVENT(vcpu, 3, "setting cpnc to %d", vcpu->arch.diag318_info.cpnc);
 	}
 	/*
 	 * If userspace sets the riccb (e.g. after migration) to a valid state,
-- 
2.31.1

