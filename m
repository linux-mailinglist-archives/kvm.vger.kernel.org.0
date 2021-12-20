Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A801347B2A2
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbhLTSLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 13:11:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240343AbhLTSLM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 13:11:12 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKHj6pV010350;
        Mon, 20 Dec 2021 18:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yR+k63n8l7yQxpxy2KBZLExk8bcL1VjuF/f4S+RXN1o=;
 b=GCKLmul73MvWdaV5MVEVgqNVyYShcqBF+EpjJXxmvyE1LGPHdCKieFneHn73ta78+N+D
 YdzcWmrCxHa+umAcwLWPd9H12XchnXmkMk7qDElCx3szg1xDlBeRvYDhb2d275IiCs7j
 haY08KflePE8AHZVznjcgxbsJ2O1f6HCpK5ZPSovJH6tsKh1yDTp7zJf8PZoymdbbsnl
 UAIWijtxhwNE2x0bDKmZrUIvuO2cbPW9GBYS0b704IuM9c04eKtQTmk3uTX+NTMpNeQz
 9owbB6NusZPjd3KKEbfelC2kbLredpDekWHlZT/8LN9dbTeW3ik5BNaCB5G/7gtr78CE RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d1sahqw7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:12 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BKHmHIt021111;
        Mon, 20 Dec 2021 18:11:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3d1sahqw7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BKI4G7E028087;
        Mon, 20 Dec 2021 18:11:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3d1799f77v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 18:11:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BKIB6W039715076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 18:11:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08FD9A405F;
        Mon, 20 Dec 2021 18:11:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F6BA405C;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Dec 2021 18:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 989EAE63A4; Mon, 20 Dec 2021 19:11:05 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 2/6] KVM: s390: gaccess: Refactor gpa and length calculation
Date:   Mon, 20 Dec 2021 19:11:00 +0100
Message-Id: <20211220181104.595009-3-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220181104.595009-1-borntraeger@linux.ibm.com>
References: <20211220181104.595009-1-borntraeger@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e3RGDijcacUQIvmRBF_fBPsKHO0rhSNJ
X-Proofpoint-ORIG-GUID: kh-iRd3dFirikS50Bx-X6lxoaSlnapqe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_08,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Improve readability by renaming the length variable and
not calculating the offset manually.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20211126164549.7046-2-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.33.1

