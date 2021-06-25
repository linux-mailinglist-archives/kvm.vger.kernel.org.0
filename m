Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC23B4278
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhFYL1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 07:27:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229573AbhFYL1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 07:27:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PBEUot157812;
        Fri, 25 Jun 2021 07:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fQoQloBgAjDKMAE8cxv0es2r5BFQPkUwVofnZZRAqUM=;
 b=aPguOTjRNFeVTHoGK5VdJkl3A6v7VzQm02ms+aFIoyRlglBPn9X2B/YuSVAO1n0myB9E
 2Qg5xitatsL0z0Z+37iZaybxewfEATaKjPUPgeQ8vgQVUmE1vrIxFh/+yCgbTKe6wEfl
 OP7waKEEVsfPfkWPp/FvSzh8dPyALm3l/kcSJniNEsaVEsmO2W++ZY5qgNgSlEhjHMyQ
 LULixutLAGG+M7sDn0HS1gG4R/EVAWe+8kE3M4M09UMtf58Rq7iHfEKbwtv0yv+zBsgj
 te8fw+wbE3sTbLSvhqbZ79OnzvqdxB/zloGbhUM4kVUKvOkDedXb3dzAcxRPmrplzNiu 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de3d0bfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:41 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15PBFT01160215;
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de3d0bfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15PBIY8U023165;
        Fri, 25 Jun 2021 11:24:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 399878sntd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 11:24:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15PBN8uN32440746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 11:23:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D69A9AE04D;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C58FFAE045;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 88526E07DE; Fri, 25 Jun 2021 13:24:35 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 3/3] KVM: s390: allow facility 192 (vector-packed-decimal-enhancement facility 2)
Date:   Fri, 25 Jun 2021 13:24:34 +0200
Message-Id: <20210625112434.12308-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625112434.12308-1-borntraeger@de.ibm.com>
References: <20210625112434.12308-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XwAQG7aC3OWX_YUbrALbnXZfyX8IOkTS
X-Proofpoint-GUID: F6_E7Ai31-nRZN6aYTdaaR7ocKbdEL8y
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_03:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pass through newer vector instructions if vector support is enabled.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 876fc1f7282a..f72f361d39dd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -713,6 +713,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 				set_kvm_facility(kvm->arch.model.fac_mask, 152);
 				set_kvm_facility(kvm->arch.model.fac_list, 152);
 			}
+			if (test_facility(192)) {
+				set_kvm_facility(kvm->arch.model.fac_mask, 192);
+				set_kvm_facility(kvm->arch.model.fac_list, 192);
+			}
 			r = 0;
 		} else
 			r = -EINVAL;
-- 
2.31.1

