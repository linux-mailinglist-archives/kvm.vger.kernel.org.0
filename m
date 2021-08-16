Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55B3ED97E
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhHPPIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:08:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232083AbhHPPIC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:08:02 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GF5Vfe114945;
        Mon, 16 Aug 2021 11:07:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2SwfxrvZ5Uekf3xvAZUMZH+3HeMGkAe07sPorxpBIeQ=;
 b=Im7U+5nbSenoZAkbbG/1exRFAa9wLIcDr+0EAqv2zXcv8Iz9rN7uaqHS2DUKg7JG7tqb
 x1fHi0NxGzuWH0onzFcn5U5vI0gF+s0gswS/MXJ9V7SkmZqkQoEFbG98V8G30qdvPY3g
 Bh/oZYvvVo5enMyAsgmSCgB8Ici5IX8mUs+TPTztIh93z3iuJ+fvmLbyFzWRxkqvEB8+
 9VG1GJR1heHC7GiH3iaIUH642kueoy2Za3AgNKur7aUxzhqCCnJKjOJZE09IJvRNrVMt
 nF9L56makKqzXB7uN5zq53hlZsGg3WsA8OM63QYduFKltV/kSgEK3hy3M374NPh8WVA/ uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwtbc98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GF5a0p115515;
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwtbc8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:30 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GF4Y1O028373;
        Mon, 16 Aug 2021 15:07:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ae5f8u1n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 15:07:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GF3wU555378332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 15:03:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B90911C078;
        Mon, 16 Aug 2021 15:07:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC96D11C054;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     scgl@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: s390: gaccess: Cleanup access to guest frames
Date:   Mon, 16 Aug 2021 17:07:16 +0200
Message-Id: <20210816150718.3063877-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210816150718.3063877-1-scgl@linux.ibm.com>
References: <20210816150718.3063877-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IH6RP7uo4JX1bpRhfB8eLkYAmE_ooHjm
X-Proofpoint-ORIG-GUID: j82Fa4l5DlN9HUDT6HF9xk-b8c9eelEV
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_05:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper function for guest frame access.
Rewrite the calculation of the gpa and the length of the segment
to be more readable.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 48 +++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index b9f85b2dc053..df83de0843de 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -827,11 +827,26 @@ static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
+static int access_guest_frame(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+			      void *data, unsigned int len)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+	unsigned int offset = offset_in_page(gpa);
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
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long _len, nr_pages, gpa, idx;
+	unsigned long nr_pages, gpa, idx;
+	unsigned int seg;
 	unsigned long pages_array[2];
 	unsigned long *pages;
 	int need_ipte_lock;
@@ -855,15 +870,12 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		ipte_lock(vcpu);
 	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
-		gpa = *(pages + idx) + (ga & ~PAGE_MASK);
-		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
-		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
-		else
-			rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
-		len -= _len;
-		ga += _len;
-		data += _len;
+		gpa = pages[idx] + offset_in_page(ga);
+		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
+		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
+		len -= seg;
+		ga += seg;
+		data += seg;
 	}
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
@@ -875,19 +887,17 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 		      void *data, unsigned long len, enum gacc_mode mode)
 {
-	unsigned long _len, gpa;
+	unsigned long gpa;
+	unsigned int seg;
 	int rc = 0;
 
 	while (len && !rc) {
 		gpa = kvm_s390_real_to_abs(vcpu, gra);
-		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
-		if (mode)
-			rc = write_guest_abs(vcpu, gpa, data, _len);
-		else
-			rc = read_guest_abs(vcpu, gpa, data, _len);
-		len -= _len;
-		gra += _len;
-		data += _len;
+		seg = min(PAGE_SIZE - offset_in_page(gpa), len);
+		rc = access_guest_frame(vcpu->kvm, mode, gpa, data, seg);
+		len -= seg;
+		gra += seg;
+		data += seg;
 	}
 	return rc;
 }
-- 
2.25.1

