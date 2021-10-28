Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC443E2C7
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 15:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhJ1N7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 09:59:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhJ1N7R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 09:59:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SClXC3017313;
        Thu, 28 Oct 2021 13:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EQPuTmQ5sMCrgcCyoTQ+1cRu8JV73P1o78gwzfO85eY=;
 b=P5cBxycH7Phlkxkp/+pJs9VLiOYebXVZtLL0/0xZQsINlaJGXXNlQ7+wGqy1pfrYyEM7
 tTJyzGhKAADk4DtmRpnoCevUge2obkAF3It+Pd+VGwbKCPdR/STwNtgXgYqlVFUszdny
 gXaBYa9Ubhi6ja/PUlXBXU/T0FYpI5XDEJl6wIED8Dy/3QZTHgo3jNHEp1SbQ2yGBjRP
 e2Y1i6fvr+Uo1bmEGbiUkXDFIspf6xrCrdwcifnUy+SpwqlhVp6LhwkPU++uU2VFASit
 pAnpWAlB9ldOlY1uzcJu+cC8CzcdG+7+QmXOaybYgISJSvxmvT7kjMCgRsWMCbs1Yb0G VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byv68sm2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:50 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SDS5GS002375;
        Thu, 28 Oct 2021 13:56:50 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byv68sm1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:49 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SDqROj011140;
        Thu, 28 Oct 2021 13:56:47 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3bx4eq8ean-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 13:56:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SDui4W53084656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 13:56:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F623A405B;
        Thu, 28 Oct 2021 13:56:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D89A405F;
        Thu, 28 Oct 2021 13:56:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 13:56:43 +0000 (GMT)
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
Subject: [PATCH v2 1/3] KVM: s390: gaccess: Refactor gpa and length calculation
Date:   Thu, 28 Oct 2021 15:55:54 +0200
Message-Id: <20211028135556.1793063-2-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211028135556.1793063-1-scgl@linux.ibm.com>
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _xdyulxcozA4GqM5m1rJD97pRhX9lex6
X-Proofpoint-GUID: OXCrOcN8h62beMR6xvmygkp8n6lmAN4p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110280075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve readability be renaming the length variable and
not calculating the offset manually.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6af59c59cc1b..0d11cea92603 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -831,7 +831,8 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long _len, nr_pages, gpa, idx;
+	unsigned long nr_pages, gpa, idx;
+	unsigned int fragment_len;
 	unsigned long pages_array[2];
 	unsigned long *pages;
 	int need_ipte_lock;
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
2.25.1

