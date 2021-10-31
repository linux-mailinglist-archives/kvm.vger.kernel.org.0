Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7C2440E29
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhJaMOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:14:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231717AbhJaMNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19V9pG8n014496;
        Sun, 31 Oct 2021 12:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=8E3yP8gks57uXrUsPPGkorn+atiFiQ8Ci39zgc+btFQ=;
 b=asVeQ9SnY/rdk8ZgXBlhRsRdi05HC+ksUSP7Tm+gxbI2DWA5OyFRLXLxKruasR0TCGgX
 UfG6MPTuycmbNon4t2B3TpsaQAgXCK6Wjrex9HhVaRtvIrqqXeLMtpbsEn6D+nszC5l4
 D9O/2ew61Dim87rPcV8aDNq/9Hd61NBWGG1/w5CyUxCWi6n5RFKT7qCjkCW0t5T2TAxJ
 zXt44vASpJwYXXUYu30B2zUOsSdjHtZ+rGnseDqOFhv01TmYPiAO+D/GyTBbCSeBn1XW
 eh2fRicwENrOcuzJmAh1M4SkB7KQYPKhvGT7+uxygP3ReDIZZJv5Rx5UWo5bs2l6cqzq eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1rvm1ktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:16 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCAc3w017795;
        Sun, 31 Oct 2021 12:11:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1rvm1kt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9Ptn022996;
        Sun, 31 Oct 2021 12:11:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3c0wp9cq18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCBA5C62652676
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E71FA4057;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A627A4053;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B1B4EE06C2; Sun, 31 Oct 2021 13:11:09 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 15/17] KVM: s390: Fix handle_sske page fault handling
Date:   Sun, 31 Oct 2021 13:11:02 +0100
Message-Id: <20211031121104.14764-16-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7-uNGRfL69rcw8npbUaVbEDIKxl5Gdr0
X-Proofpoint-ORIG-GUID: 8gUaI__GabkcJngd3n2aziA02DqUjTyy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

If handle_sske cannot set the storage key, because there is no
page table entry or no present large page entry, it calls
fixup_user_fault.
However, currently, if the call succeeds, handle_sske returns
-EAGAIN, without having set the storage key.
Instead, retry by continue'ing the loop without incrementing the
address.
The same issue in handle_pfmf was fixed by
a11bdb1a6b78 ("KVM: s390: Fix pfmf and conditional skey emulation").

Fixes: bd096f644319 ("KVM: s390: Add skey emulation fault handling")
Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20211022152648.26536-1-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/priv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 53da4ceb16a3..417154b314a6 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -397,6 +397,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		mmap_read_unlock(current->mm);
 		if (rc == -EFAULT)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+		if (rc == -EAGAIN)
+			continue;
 		if (rc < 0)
 			return rc;
 		start += PAGE_SIZE;
-- 
2.31.1

