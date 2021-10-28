Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3786F43E2CC
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhJ1N7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:59:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230421AbhJ1N7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 09:59:19 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SDHp67014934;
        Thu, 28 Oct 2021 13:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eSw5DGAZnx4YMYV5a7tcWTA9NrwkN8U9+kTSxgHxq6I=;
 b=IfX7qvWI+M+bw6emQIyZwF42OW9A/PHCEBEPSJJk+5XmItsUN7ZxVE0iQ5dyrHnT77Cl
 PZThh9D3S4AXvtdlTaFY2nI8BLdNHNUN+iMAaKcTM5Daw7WemjZfl/gQXU0o8WXhLgxR
 EFzsCESUhKtA/shbzqiyKRPIDEZUPvs4zuXkXK7mkc/UZqY8FgGI3HD3LYV/VMst+O9+
 nGE6PZGeSb9IFdACHNoiEcW56PCzy0yigAvJFe3dkiP/AKnJodWnYhHAcAT+kBF8besw
 j+qZ7tXK7BKbIGCcESxnmwJrZDqQILJoskIiZvX6S9EJPI+crk55P/jH3YT4EI6fPhbW ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3byvmf0uh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:51 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SDI3xI015587;
        Thu, 28 Oct 2021 13:56:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3byvmf0ugh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SDqBxh023546;
        Thu, 28 Oct 2021 13:56:49 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3bx4ej8d8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:49 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SDuj1V39190926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 13:56:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE5A4A4062;
        Thu, 28 Oct 2021 13:56:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C63CA4054;
        Thu, 28 Oct 2021 13:56:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 13:56:45 +0000 (GMT)
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
Subject: [PATCH v2 3/3] KVM: s390: gaccess: Cleanup access to guest frames
Date:   Thu, 28 Oct 2021 15:55:56 +0200
Message-Id: <20211028135556.1793063-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028135556.1793063-1-scgl@linux.ibm.com>
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qog0TgVjU61hsGuI9_eh1PAaJnIAVCNt
X-Proofpoint-ORIG-GUID: BhOw6vA-u1qmuwyxa9z5LR-ANZaUMlDo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper function for guest frame access.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f0848c37b003..9a633310b6fe 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -866,6 +866,20 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	return 0;
 }
 
+static int access_guest_page(struct kvm *kvm, enum gacc_mode mode, gpa_t gpa,
+			      void *data, unsigned int len)
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
2.25.1

