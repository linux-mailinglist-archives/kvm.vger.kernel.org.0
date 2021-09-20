Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24275411580
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbhITN0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239395AbhITN0k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:40 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD4E2022474;
        Mon, 20 Sep 2021 09:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SAC/UWUbp9h/+bspINz5hMtt5nml0kfzkshBQz3mMz4=;
 b=Vl9swiM6Mql0JA950WVF8oH4S/d6PEx+DJgQ7bS4lHRRUI49qhR3OnDMjsL0lPzVrtQh
 beQngmcjjJQfbxXELEJoOddq+zWvuUu4BLgEy3NtfrMli2YdIkopkehHKIxfraD4u5vt
 6r3sg3rmqDYuBI/cvLkOBg08JFt4bj9qNHP60YL2RvkBOwsh87cpY+ix1eo+vnsH2X6o
 s0HLgeWZCyOockYwSC2DMmetOUBWnhCCt4B4mcMqPGaUUQfnjhFHoSQddYHAQ4B9aA+c
 8IEJBEJH6ugJiQnr+WoDy1uA2CUGXWa1HfBZxzjjkXdiN/UwMufEjtNNH+e9imLs6DfP Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w6aj85d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDD4fE022521;
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w6aj841-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDP8d2022956;
        Mon, 20 Sep 2021 13:25:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3b57r904kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP5q043254226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:05 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFAC2A4069;
        Mon, 20 Sep 2021 13:25:05 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28446A406B;
        Mon, 20 Sep 2021 13:25:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 04/14] KVM: s390: pv: avoid stalls when making pages secure
Date:   Mon, 20 Sep 2021 15:24:52 +0200
Message-Id: <20210920132502.36111-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y7VQ6i_kYNjG_b7E2NTz8NJG2wZolnid
X-Proofpoint-ORIG-GUID: ewh6-Jj4M7w9ErdZ9obb7dgC4fgSOqRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve make_secure_pte to avoid stalls when the system is heavily
overcommitted. This was especially problematic in kvm_s390_pv_unpack,
because of the loop over all pages that needed unpacking.

Due to the locks being held, it was not possible to simply replace
uv_call with uv_call_sched. A more complex approach was
needed, in which uv_call is replaced with __uv_call, which does not
loop. When the UVC needs to be executed again, -EAGAIN is returned, and
the caller (or its caller) will try again.

When -EAGAIN is returned, the path is the same as when the page is in
writeback (and the writeback check is also performed, which is
harmless).

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
---
 arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
 arch/s390/kvm/intercept.c |  5 +++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index aeb0a15bcbb7..68a8fbafcb9c 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 {
 	pte_t entry = READ_ONCE(*ptep);
 	struct page *page;
-	int expected, rc = 0;
+	int expected, cc = 0;
 
 	if (!pte_present(entry))
 		return -ENXIO;
@@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	if (!page_ref_freeze(page, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &page->flags);
-	rc = uv_call(0, (u64)uvcb);
+	/*
+	 * If the UVC does not succeed or fail immediately, we don't want to
+	 * loop for long, or we might get stall notifications.
+	 * On the other hand, this is a complex scenario and we are holding a lot of
+	 * locks, so we can't easily sleep and reschedule. We try only once,
+	 * and if the UVC returned busy or partial completion, we return
+	 * -EAGAIN and we let the callers deal with it.
+	 */
+	cc = __uv_call(0, (u64)uvcb);
 	page_ref_unfreeze(page, expected);
-	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
-	if (rc)
-		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
-	return rc;
+	/*
+	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * If busy or partially completed, return -EAGAIN.
+	 */
+	if (cc == UVC_CC_OK)
+		return 0;
+	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
+		return -EAGAIN;
+	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
 /*
@@ -254,6 +267,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	mmap_read_unlock(gmap->mm);
 
 	if (rc == -EAGAIN) {
+		/*
+		 * If we are here because the UVC returned busy or partial
+		 * completion, this is just a useless check, but it is safe.
+		 */
 		wait_on_page_writeback(page);
 	} else if (rc == -EBUSY) {
 		/*
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 72b25b7cc6ae..47833ade4da5 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -516,6 +516,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
 	 */
 	if (rc == -EINVAL)
 		return 0;
+	/*
+	 * If we got -EAGAIN here, we simply return it. It will eventually
+	 * get propagated all the way to userspace, which should then try
+	 * again.
+	 */
 	return rc;
 }
 
-- 
2.31.1

