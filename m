Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E252F2A0756
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 15:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgJ3OB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 10:01:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726754AbgJ3OB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 10:01:56 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UDWgrf040664;
        Fri, 30 Oct 2020 10:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=XwBZSiGdxOOiSXm4d9FIjQh4CivXkkYs7jASRRe1l/U=;
 b=MONT8pgOiQOE2oW+cO09/fzwZYBMArqlM1m7r0YL88C5YmJq8Q7IQUivTDtlft76FhdC
 hRtsdLhseCy3WI4sJIu7TFlpCYJ1lZbLApUXPPB0d/ozsjv2uaUGx037ZRr/wAqC3h9r
 1ezLVOQdW/mq6xiinChNULOk9140YcPByCd3PKQLkhWoixsBwGc38lBY1KasHe3dvtcS
 a9lb+AKrhxPjr8tyKUSTue5VuujACK+xQegO3XU1enP5HSgzhDOnXnqAbZkWSVRZlpIX
 sZOlS9E2CQ4Bmi+ZGXAYQjj3J5OfsUHJNzfMt+yQWBiSC70SBCpbuCmXWwhEX5T40G89 Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34geqbjmry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 10:01:54 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UDYDpQ050023;
        Fri, 30 Oct 2020 10:01:53 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34geqbjmmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 10:01:53 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UDwiCs022488;
        Fri, 30 Oct 2020 14:01:46 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 34fpvrgssd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 14:01:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UE1hOP28377432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 14:01:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89ED2A405B;
        Fri, 30 Oct 2020 14:01:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C41D4A4055;
        Fri, 30 Oct 2020 14:01:42 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 14:01:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH] kvm: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup
Date:   Fri, 30 Oct 2020 10:01:41 -0400
Message-Id: <20201030140141.106641-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_04:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=13 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can only have protected guest pages after a successful set secure
parameters call as only then the UV allows imports and unpacks.

By moving the test we can now also check for it in s390_reset_acc()
and do an early return if it is 0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 arch/s390/kvm/pv.c       | 3 ++-
 arch/s390/mm/gmap.c      | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6b74b92c1a58..08ea6c4735cd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2312,7 +2312,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		struct kvm_s390_pv_unp unp = {};
 
 		r = -EINVAL;
-		if (!kvm_s390_pv_is_protected(kvm))
+		if (!kvm_s390_pv_is_protected(kvm) || !mm_is_protected(kvm->mm))
 			break;
 
 		r = -EFAULT;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index eb99e2f95ebe..f5847f9dec7c 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -208,7 +208,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
-	atomic_set(&kvm->mm->context.is_protected, 1);
 	return 0;
 }
 
@@ -228,6 +227,8 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
+	if (!cc)
+		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index cfb0017f33a7..64795d034926 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2690,6 +2690,8 @@ static const struct mm_walk_ops reset_acc_walk_ops = {
 #include <linux/sched/mm.h>
 void s390_reset_acc(struct mm_struct *mm)
 {
+	if (!mm_is_protected(mm))
+		return;
 	/*
 	 * we might be called during
 	 * reset:                             we walk the pages and clear
-- 
2.25.1

