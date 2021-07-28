Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB483D90A0
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhG1O1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:27:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236977AbhG1O0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:45 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENN8A021105;
        Wed, 28 Jul 2021 10:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=38gFOKTrICW/O1vPT+e3nGr/ypCZAcQ7LGuzZZqEV8Y=;
 b=PBgMWLiGdfYVD6PzDXd8A0/vZBDcNxH10MMW8YB80iCRDhX1B7kswmQHq6hU9bDDmzER
 80kB5GeK20fM0q1+MPJg/9evrByHyWFPJu+OyYynTB8rolCl/NdhMNUYOEykd7TXbwqv
 4ZVHCKj+wVdtkyRBE+Rk92xCWE2cZbyXV0bhMekT5kWM8YqOETKs9QF/9hm9lT7ycabf
 lzfLq2Y6xccdR+4eNQ/oCrOZFFDVVy67yFKSgIpqG6ZmxbCqwPclXDu81MLRudCk2ai9
 zdMtFG03gzr6scZKAtmPZv04YrVmG6dHMezlgjtveDjew5N9AJwBXNsoSYobTTpnZGZu 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35rb6ebw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENsxj022885;
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35rb6eb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEJ6aM011264;
        Wed, 28 Jul 2021 14:26:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3a235kgr58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQbR230736860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DBAA4057;
        Wed, 28 Jul 2021 14:26:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E486FA4065;
        Wed, 28 Jul 2021 14:26:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/13] KVM: s390: pv: avoid stall notifications for some UVCs
Date:   Wed, 28 Jul 2021 16:26:19 +0200
Message-Id: <20210728142631.41860-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728142631.41860-1-imbrenda@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SEkbtfQ3kIXHROiIromPa2DXfBf-bk8q
X-Proofpoint-GUID: pjtvj0adBZWtOQzEl3a15SQaRcURU-sr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve make_secure_pte to avoid stalls when the system is heavily
overcommitted. This was especially problematic in kvm_s390_pv_unpack,
because of the loop over all pages that needed unpacking.

Also fix kvm_s390_pv_init_vm to avoid stalls when the system is heavily
overcommitted.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 11 ++++++++---
 arch/s390/kvm/pv.c    |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index aeb0a15bcbb7..fd0faa51c1bb 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -196,11 +196,16 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	if (!page_ref_freeze(page, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &page->flags);
-	rc = uv_call(0, (u64)uvcb);
+	rc = __uv_call(0, (u64)uvcb);
 	page_ref_unfreeze(page, expected);
-	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
-	if (rc)
+	/*
+	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * If busy or partially completed, return -EAGAIN.
+	 */
+	if (rc == 1)
 		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
+	else if (rc > 1)
+		rc = -EAGAIN;
 	return rc;
 }
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c8841f476e91..e007df11a2fe 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -196,7 +196,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
 	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
 
-	cc = uv_call(0, (u64)&uvcb);
+	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
-- 
2.31.1

