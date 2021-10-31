Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32201440E25
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhJaMN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231857AbhJaMNr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:47 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19V9pHt8014541;
        Sun, 31 Oct 2021 12:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=26FfT+sNuGCGYu19Xfvu/4WlE0+/uy/G/aws0DaWHec=;
 b=U3jqhdv8zTzMV7WYkHUx5aePjTIWeNmM404IxkQ1zG1UCfOPlGmPJHy8i2gqpEpkgSG/
 V+uaqb2+l5y3iIJTaN7ThojaC55EFx+AG1dVfExTGWFY/cP++zooQQS213cOhZUwGOzS
 +iwekvC7IknlgRt+W5qlvPTE9O4HslaUQf2V/OP3sqFz546nyl0pk8ZZvwZlWFOszM97
 t+TQDfJtf7LaztfAFflACBztFcp2X+40lckRZoExSzLhqoNOw0NuIlMCbiwiMK+9s9Z1
 TXmmh4s8jShQ4X345Q0BIZSnSvFCX/ugK9unYiJ3DL09WV6utRw5BPlzBXrMDj++SQid tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1rvm1ktg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VC5KoY022206;
        Sun, 31 Oct 2021 12:11:15 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1rvm1ksu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9O4T006454;
        Sun, 31 Oct 2021 12:11:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3c0wp957uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB99Q3932922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A69DA404D;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27551A4040;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C2951E056B; Sun, 31 Oct 2021 13:11:08 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 12/17] KVM: s390: pv: avoid stalls when making pages secure
Date:   Sun, 31 Oct 2021 13:10:59 +0100
Message-Id: <20211031121104.14764-13-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iWIr8v_YjLiM5Pt4QOKC7XG5Dcrb6qiA
X-Proofpoint-ORIG-GUID: BiNZaf4V0EwRv0chQAxeu1eWCnNkSRU7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

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

Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210920132502.36111-5-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
 arch/s390/kvm/intercept.c |  5 +++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f95ccbd39692..09b80d371409 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -165,7 +165,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 {
 	pte_t entry = READ_ONCE(*ptep);
 	struct page *page;
-	int expected, rc = 0;
+	int expected, cc = 0;
 
 	if (!pte_present(entry))
 		return -ENXIO;
@@ -181,12 +181,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
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
@@ -239,6 +252,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
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
index 2bd8f854f1b4..d07ff646d844 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -518,6 +518,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
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

