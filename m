Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39C54CAD20
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244480AbiCBSMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241663AbiCBSMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196E1CD33F;
        Wed,  2 Mar 2022 10:11:52 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HqUM1005761;
        Wed, 2 Mar 2022 18:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GiQkGbgtlqxuqtXWVQ3hg5KCgKbW+bo0vCKXPSv9npY=;
 b=YX0ZtUXut7a84JheV50fBlHPnvmT7sWp4ozaULeVV6//sihBxXWeiHaz7XYUK8e5ClN/
 RKTfCUogbqKiO98FhZ+VkMbBYrBDjv1SDHjiVrtNH8WIHUSXRvv+Ffv4oqHJELzamM0o
 g8cX/jL/v5BXlwsB4NlEmCxkeAe1560jRIXyf4xFKeEGi4kUy3G7ix3CwuVpizKaHhMg
 n/xCxz1L6ZagnZcFgVEkhD9VGIK20IRqXDFXxNm7Q8rczIAj4FBXKc3907Y3gFt1+VLL
 lxWc739ij9wIxcG/xwwj5krmJhjnm+4E+ZIW1OgGOU0quUjRBvMtK3MWG5uJy8vTFkl8 Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejdc70d1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:51 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222I70hH009136;
        Wed, 2 Mar 2022 18:11:51 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejdc70d0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:51 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I9gnD016925;
        Wed, 2 Mar 2022 18:11:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3efbu8x0jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBjVA55181646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9165752050;
        Wed,  2 Mar 2022 18:11:45 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 10B025204F;
        Wed,  2 Mar 2022 18:11:45 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 02/17] KVM: s390: pv: handle secure storage violations for protected guests
Date:   Wed,  2 Mar 2022 19:11:28 +0100
Message-Id: <20220302181143.188283-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0_esgtXwYfhK9yEjRtSfJTLIJPz-REsJ
X-Proofpoint-ORIG-GUID: _av8ZlcYGx3SILInSYk-qz2UpzC-Qiui
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=674
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, protected guests will be able to trigger secure
storage violations in normal operation.

A secure storage violation is triggered when a protected guest tries to
access secure memory that has been mapped erroneously, or that belongs
to a different protected guest or to the ultravisor.

With upcoming patches, protected guests will be able to trigger secure
storage violations in normal operation. This happens for example if a
protected guest is rebooted with lazy destroy enabled and the new guest
is also protected.

When the new protected guest touches pages that have not yet been
destroyed, and thus are accounted to the previous protected guest, a
secure storage violation is raised.

This patch adds handling of secure storage violations for protected
guests.

This exception is handled by first trying to destroy the page, because
it is expected to belong to a defunct protected guest where a destroy
should be possible. If that fails, a normal export of the page is
attempted.

Therefore, pages that trigger the exception will be made non-secure
before attempting to use them again for a different secure guest.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kernel/uv.c      | 55 ++++++++++++++++++++++++++++++++++++++
 arch/s390/mm/fault.c       | 10 +++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 86218382d29c..6b2b33f19abe 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -356,6 +356,7 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index a5425075dd25..2754471cc789 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -334,6 +334,61 @@ int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
 }
 EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
 
+/**
+ * gmap_destroy_page - Destroy a guest page.
+ * @gmap the gmap of the guest
+ * @gaddr the guest address to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
+ */
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
+{
+	struct vm_area_struct *vma;
+	unsigned long uaddr;
+	struct page *page;
+	int rc;
+
+	rc = -EFAULT;
+	mmap_read_lock(gmap->mm);
+
+	uaddr = __gmap_translate(gmap, gaddr);
+	if (IS_ERR_VALUE(uaddr))
+		goto out;
+	vma = vma_lookup(gmap->mm, uaddr);
+	if (!vma)
+		goto out;
+	/*
+	 * Huge pages should not be able to become secure
+	 */
+	if (is_vm_hugetlb_page(vma))
+		goto out;
+
+	rc = 0;
+	/* we take an extra reference here */
+	page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_GET);
+	if (IS_ERR_OR_NULL(page))
+		goto out;
+	rc = uv_destroy_owned_page(page_to_phys(page));
+	/*
+	 * Fault handlers can race; it is possible that two CPUs will fault
+	 * on the same secure page. One CPU can destroy the page, reboot,
+	 * re-enter secure mode and import it, while the second CPU was
+	 * stuck at the beginning of the handler. At some point the second
+	 * CPU will be able to progress, and it will not be able to destroy
+	 * the page. In that case we do not want to terminate the process,
+	 * we instead try to export the page.
+	 */
+	if (rc)
+		rc = uv_convert_owned_from_secure(page_to_phys(page));
+	put_page(page);
+out:
+	mmap_read_unlock(gmap->mm);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(gmap_destroy_page);
+
 /*
  * To be called with the page locked or with an extra reference! This will
  * prevent gmap_make_secure from touching the page concurrently. Having 2
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index ff16ce0d04ee..47b52e5384f8 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -853,6 +853,16 @@ NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
 void do_secure_storage_violation(struct pt_regs *regs)
 {
+	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
+	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
+
+	/*
+	 * If the VM has been rebooted, its address space might still contain
+	 * secure pages from the previous boot.
+	 * Clear the page so it can be reused.
+	 */
+	if (!gmap_destroy_page(gmap, gaddr))
+		return;
 	/*
 	 * Either KVM messed up the secure guest mapping or the same
 	 * page is mapped into multiple secure guests.
-- 
2.34.1

