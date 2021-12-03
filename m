Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54357467BFA
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382347AbhLCRB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382255AbhLCRBt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:49 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Es0GN005755;
        Fri, 3 Dec 2021 16:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bZ8nqMlYPeJPBjNmx3bpER2luWpBy9T3FxxPXHEWhJ0=;
 b=D7j3wD/girhgFtwruGD92lpsEbtFvJPJ4tVcvLXwKSRF7Wmx84AcVtmAQgaCgClO+Suu
 +ANce26pWPLGh47qf0to4TZ9Q3BabMhmUiUKjj4YmOh1m2FCPu/0o9mwUfKHrbZq2D6t
 edSwvIfSUnpxMqYaCsLcAU4gHGISSo8Gy5TXDRuD+eP/8SVjbsifq1mDpTpg9kJnrkkI
 wVipYc5diyf7mtAiL6w209tIUhIGTuX7NHxVEG6L8hygztipCOMF+k9XyLWLj5lcgcj+
 AiXpLyPRfGAaHnxhGsyiPYRKdRHR0t7DHmfFxjpetjCg3Iw08nPCKGRKjVWkooKJyVQX ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqnd5tknh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:25 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GbHuE001647;
        Fri, 3 Dec 2021 16:58:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqnd5tkms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GwEgU023025;
        Fri, 3 Dec 2021 16:58:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkyv9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwJr216580968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF4BC52052;
        Fri,  3 Dec 2021 16:58:18 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6CBAA5204F;
        Fri,  3 Dec 2021 16:58:18 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/17] KVM: s390: pv: add export before import
Date:   Fri,  3 Dec 2021 17:58:03 +0100
Message-Id: <20211203165814.73016-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IdpYQjyeFKt8I4Nss9Ddr1_GzaRLXrfW
X-Proofpoint-ORIG-GUID: D6P3cZ1F0yePZIwXHxQO4zP6bq2IMg1Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to upcoming changes, it will be possible to temporarily have
multiple protected VMs in the same address space, although only one
will be actually active.

In that scenario, it is necessary to perform an export of every page
that is to be imported, since the hardware does not allow a page
belonging to a protected guest to be imported into a different
protected guest.

This also applies to pages that are shared, and thus accessible by the
host.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f706456f6261..ec01c3f8b13c 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -234,6 +234,12 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
+		atomic_read(&mm->context.protected_count) > 1;
+}
+
 /*
  * Requests the Ultravisor to make a page accessible to a guest.
  * If it's brought in the first time, it will be cleared. If
@@ -277,6 +283,8 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 
 	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(page_to_phys(page));
 	rc = make_secure_pte(ptep, uaddr, page, uvcb);
 	pte_unmap_unlock(ptep, ptelock);
 	unlock_page(page);
-- 
2.31.1

