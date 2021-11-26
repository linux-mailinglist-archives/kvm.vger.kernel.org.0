Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49E45F26B
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239428AbhKZQvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:51:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1378417AbhKZQtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:49:14 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AQFgbrM017005;
        Fri, 26 Nov 2021 16:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FSTZmeDObuiz0zGwW+q+Y03RJ+4MF0UxnA1wcI8VmcA=;
 b=FIX/NHb9BJNx3l2Do5eueonC/ubgdGoQTniGTqOy5frT/7KMvsojRqaCbmvXj4UGiJZc
 3TFr16eR6/VzFkJBNKhhizZR5hdIsGyTicjxreUKZrLFAcJctu4DUqqFLLjVN+5QFZPw
 ixWVEqYIZhmxb1Za00PAknTQy2wnPs1DF+AbRPUR56Uk0kn/1l5gIqz381BAFm5RLFI9
 BC4PkclqOIIZNjmNWsTuzHzyMsSJiIoVA89S9zYa9Or7iwhS3izchws5eLFALM3BqsiG
 2QuiBnl2fPz/Wmnzm+pSCD5y9h9DkX1exoEEdgfdiZ0B3wuUgqSDWsQAIzob51TvR9su Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ck1972sqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:46:00 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AQG8GQb005841;
        Fri, 26 Nov 2021 16:46:00 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ck1972spu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:46:00 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AQGbJRs024388;
        Fri, 26 Nov 2021 16:45:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3cjm1fpnw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 16:45:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AQGjtiV786962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Nov 2021 16:45:55 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA7111C05B;
        Fri, 26 Nov 2021 16:45:55 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11C4111C04C;
        Fri, 26 Nov 2021 16:45:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Nov 2021 16:45:55 +0000 (GMT)
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
Subject: [PATCH v3 3/3] KVM: s390: gaccess: Cleanup access to guest pages
Date:   Fri, 26 Nov 2021 17:45:49 +0100
Message-Id: <20211126164549.7046-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211126164549.7046-1-scgl@linux.ibm.com>
References: <20211126164549.7046-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sjqngs3oCl3YAKVRNsXAqkFUOtOdnPAM
X-Proofpoint-ORIG-GUID: 2DXQ0DaMoG7w6Y1p-gCWkt_Nj93D_xka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_04,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111260095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper function for guest frame access.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index c09659609d68..9193f0de40b1 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
+static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+			     void *data, unsigned int len)
+{
+	const unsigned int offset = offset_in_page(gpa);
+	const gfn_t gfn = gpa_to_gfn(gpa);
+	int rc;
+
+	if (mode == GACC_STORE)
+		rc = kvm_write_guest_page(kvm, gfn, data, offset, len);
+	else
+		rc = kvm_read_guest_page(kvm, gfn, data, offset, len);
+	return rc;
+}
+
 int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
@@ -896,10 +910,7 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
-		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
-		else
-			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
+		rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
 		len -= fragment_len;
 		data += fragment_len;
 	}
@@ -920,10 +931,7 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
 		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
-		if (mode)
-			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
-		else
-			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
+		rc = access_guest_page(vcpu->kvm, mode, gpa, data, fragment_len);
 		len -= fragment_len;
 		gra += fragment_len;
 		data += fragment_len;
-- 
2.32.0

