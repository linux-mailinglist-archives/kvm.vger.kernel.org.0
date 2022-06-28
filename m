Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA81655E685
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347002AbiF1N4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346902AbiF1N4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5083336F;
        Tue, 28 Jun 2022 06:56:29 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDlD1P020642;
        Tue, 28 Jun 2022 13:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LwPERVQ/LeDFvhzd+k/ubf+EGcl/b1sGE+qUB8TH8mQ=;
 b=NxXECasZPPHw92l22BEEoO7rbaQJdNjU/jM71MOMP/Ktv/CN7I7r9bWQenNl0m1Or/3W
 2mYEoEORQAzDDF1BoWbkUZ4I9Q2Y9W22KV65K9A0+IjuMa8pyP0k+Nxj1LUQtCpkQyrL
 TqxVh8qf1YAnHorkTfWdLsz2dIuTRYllwiBCigdPO9e6PY0sLSh0BGwk0hJaNfrzXB+i
 BHJ8Xr8UVE3vNuj1UEipn3QL4xMXHyYbxDzXW/+2RVnwOhnW8CEf3urfSR0+f83mT4i1
 xxc3fft1NnUknZ4Q2W7a8rpibjWRnlXLpLYXU/PDW0ETgHNYSdax83LneV6N5DUcn1Jv BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7rawt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDlsJl023175;
        Tue, 28 Jun 2022 13:56:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7ravf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDpoCj011099;
        Tue, 28 Jun 2022 13:56:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gwt08upku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDuMXB20513104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:56:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E4B54C046;
        Tue, 28 Jun 2022 13:56:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 339344C04E;
        Tue, 28 Jun 2022 13:56:22 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 06/18] KVM: s390: pv: add export before import
Date:   Tue, 28 Jun 2022 15:56:07 +0200
Message-Id: <20220628135619.32410-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HA0rlM-8Nih7hb1FaPCMs-KJND3LJgT5
X-Proofpoint-ORIG-GUID: p9lk2BvbK6j8cVaAOErGPwVsCqgoUaod
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/s390/kernel/uv.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index ce14fd0b573c..87b176008785 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -234,6 +234,32 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
+/**
+ * should_export_before_import - Determine whether an export is needed
+ * before an import-like operation
+ * @uvcb: the Ultravisor control block of the UVC to be performed
+ * @mm: the mm of the process
+ *
+ * Returns whether an export is needed before every import-like operation.
+ * This is needed for shared pages, which don't trigger a secure storage
+ * exception when accessed from a different guest.
+ *
+ * Although considered as one, the Unpin Page UVC is not an actual import,
+ * so it is not affected.
+ *
+ * No export is needed also when there is only one protected VM, because the
+ * page cannot belong to the wrong VM in that case (there is no "other VM"
+ * it can belong to).
+ *
+ * Return: true if an export is needed before every import, otherwise false.
+ */
+static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
+{
+	if (uvcb->cmd == UVC_CMD_UNPIN_PAGE_SHARED)
+		return false;
+	return atomic_read(&mm->context.protected_count) > 1;
+}
+
 /*
  * Requests the Ultravisor to make a page accessible to a guest.
  * If it's brought in the first time, it will be cleared. If
@@ -277,6 +303,8 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 
 	lock_page(page);
 	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	if (should_export_before_import(uvcb, gmap->mm))
+		uv_convert_from_secure(page_to_phys(page));
 	rc = make_secure_pte(ptep, uaddr, page, uvcb);
 	pte_unmap_unlock(ptep, ptelock);
 	unlock_page(page);
-- 
2.36.1

