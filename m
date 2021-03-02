Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9B32B57A
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377472AbhCCHRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1575505AbhCBSaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 13:30:20 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 122HZCIv105617;
        Tue, 2 Mar 2021 12:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oA8O2HJgDVGFTawl3fJiP+oMYJOQ88DUEVk+MzF3CHw=;
 b=HckMR/OWW1kjRb4xTXcdCM7fqWCAbHCDlmRmkb4lV4BMpQgfIhLKj0dylP1V9HcrLjRY
 p60EP+lAWXVXZ6Jq200IOKRhcRD5xt6lqbXPV/M8W0mwbK0h0bVjkIvGmsYcKVX5ENTq
 mu/+CUsfeV1odt4rI2ofG8CYhw29FwoKbi2mBD2+HPSMEV50LmOByBVZmHfL1Ykyf+71
 hXLSrVcCdl4K05gYxcMTF5pG9mWo9gs1fgIJ0dtyL6W5MuaYr5VTAggyoMHgZ8O0tIZM
 uHB1Gx8NWLoglPDPve/RZF8hTbJcKvk2hnCpTtGYHiTpdaSeDgoLl7mOOE5ZbiQvXjco gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qf3nqfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:50 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 122HZI9J106057;
        Tue, 2 Mar 2021 12:44:49 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371qf3nqet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 12:44:49 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 122Hfi3M028680;
        Tue, 2 Mar 2021 17:44:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 36yj531h54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 17:44:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 122HiiVW43450708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 17:44:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12C1952052;
        Tue,  2 Mar 2021 17:44:44 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.194])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B18A152054;
        Tue,  2 Mar 2021 17:44:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v5 1/3] s390/kvm: split kvm_s390_logical_to_effective
Date:   Tue,  2 Mar 2021 18:44:41 +0100
Message-Id: <20210302174443.514363-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210302174443.514363-1-imbrenda@linux.ibm.com>
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=859
 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020136
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split kvm_s390_logical_to_effective to a generic function called
_kvm_s390_logical_to_effective. The new function takes a PSW and an address
and returns the address with the appropriate bits masked off. The old
function now calls the new function with the appropriate PSW from the vCPU.

This is needed to avoid code duplication for vSIE.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/gaccess.h | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index f4c51756c462..107fdfd2eadd 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -36,6 +36,29 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
 	return gra;
 }
 
+/**
+ * _kvm_s390_logical_to_effective - convert guest logical to effective address
+ * @psw: psw of the guest
+ * @ga: guest logical address
+ *
+ * Convert a guest logical address to an effective address by applying the
+ * rules of the addressing mode defined by bits 31 and 32 of the given PSW
+ * (extendended/basic addressing mode).
+ *
+ * Depending on the addressing mode, the upper 40 bits (24 bit addressing
+ * mode), 33 bits (31 bit addressing mode) or no bits (64 bit addressing
+ * mode) of @ga will be zeroed and the remaining bits will be returned.
+ */
+static inline unsigned long _kvm_s390_logical_to_effective(psw_t *psw,
+							   unsigned long ga)
+{
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
+		return ga;
+	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
+		return ga & ((1UL << 31) - 1);
+	return ga & ((1UL << 24) - 1);
+}
+
 /**
  * kvm_s390_logical_to_effective - convert guest logical to effective address
  * @vcpu: guest virtual cpu
@@ -54,11 +77,7 @@ static inline unsigned long kvm_s390_logical_to_effective(struct kvm_vcpu *vcpu,
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
 
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_64BIT)
-		return ga;
-	if (psw_bits(*psw).eaba == PSW_BITS_AMODE_31BIT)
-		return ga & ((1UL << 31) - 1);
-	return ga & ((1UL << 24) - 1);
+	return _kvm_s390_logical_to_effective(&vcpu->arch.sie_block->gpsw, ga);
 }
 
 /*
-- 
2.26.2

