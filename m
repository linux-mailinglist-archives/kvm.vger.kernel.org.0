Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AFA45F266
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhKZQvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:51:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350248AbhKZQtN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:49:13 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQGHURB004851;
        Fri, 26 Nov 2021 16:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NHgVq451btQJDqLBaBQ0eIkyyWyZ4NbneBXJDZY0iNU=;
 b=tYEjWm9oZInan/aqzjBJxzb4TGfVlf9Odm8ooTrjqY9X3mQqXckjRi9vPPoHjocL7zG/
 i0NTa+hb4jXLvJso5yxUVuWPbq6O3vhoGQbQhePxWAlap3WYl1CWvAiuT+eg4t+1PjNl
 Xn7VS7c5U+yMuyFf8Zjp3wH6JQPoS2yuNksQ/SZ5YUMBGDwWItkyvU2Nm3DJYHj85SeV
 L73qafn9cazXNwpCVdvM4tWHl2/awspAetfJ3+xRLih9x8yLcJtc+Wqjlaxen7de+CGL
 s8W1RAqDR/6jqCFNqTzAbiQJHQulSfSLZeeStKyq3zhUANX5wFCMbcS/uTtaE9DCN62N bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ck2ynrfet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:46:00 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AQGeaJj011897;
        Fri, 26 Nov 2021 16:45:59 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ck2ynrfdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:59 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AQGchdr012092;
        Fri, 26 Nov 2021 16:45:57 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3cernak2kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AQGjsC230933268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 16:45:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F155011C052;
        Fri, 26 Nov 2021 16:45:53 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9ABB311C04A;
        Fri, 26 Nov 2021 16:45:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Nov 2021 16:45:53 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] KVM: s390: gaccess: Refactor gpa and length calculation
Date:   Fri, 26 Nov 2021 17:45:47 +0100
Message-Id: <20211126164549.7046-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211126164549.7046-1-scgl@linux.ibm.com>
References: <20211126164549.7046-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5c-nvdIvMF_U_PU8xFMYhnK4tT7YFq9h
X-Proofpoint-ORIG-GUID: KlOk6lcsw2TtDz2nO_dl5jcSk5RiJwjl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_04,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111260095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve readability by renaming the length variable and
not calculating the offset manually.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6af59c59cc1b..45966fbba182 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -831,8 +831,9 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long _len, nr_pages, gpa, idx;
+	unsigned long nr_pages, gpa, idx;
 	unsigned long pages_array[2];
+	unsigned int fragment_len;
 	unsigned long *pages;
 	int need_ipte_lock;
 	union asce asce;
@@ -855,15 +856,15 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		ipte_lock(vcpu);
 	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
-		gpa = *(pages + idx) + (ga & ~PAGE_MASK);
-		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
+		gpa = pages[idx] + offset_in_page(ga);
+		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
 		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
+			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
 		else
-			rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
-		len -= _len;
-		ga += _len;
-		data += _len;
+			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
+		len -= fragment_len;
+		ga += fragment_len;
+		data += fragment_len;
 	}
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
@@ -875,19 +876,20 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode)
 {
-	unsigned long _len, gpa;
+	unsigned int fragment_len;
+	unsigned long gpa;
 	int rc = 0;
 
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
-		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
+		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
 		if (mode)
-			rc = write_guest_abs(vcpu, gpa, data, _len);
+			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
 		else
-			rc = read_guest_abs(vcpu, gpa, data, _len);
-		len -= _len;
-		gra += _len;
-		data += _len;
+			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
+		len -= fragment_len;
+		gra += fragment_len;
+		data += fragment_len;
 	}
 	return rc;
 }
-- 
2.32.0

