Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6481C57D107
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbiGUQNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiGUQNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33AA84EDE;
        Thu, 21 Jul 2022 09:13:28 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFadK027816;
        Thu, 21 Jul 2022 16:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=eVWvBilpVyHU4TKn7FslMC+C6nxFXu5A6RcXauHx3Rg=;
 b=oQPU0Y46hv4ErR0qDwiBzVzYD0sTtGYbQO1Te0FM8LYv4LXoR//tqf7W5VEW06QrivA7
 kIpQfudHZ2FLdsLyKbZV2h2NMXvWZuFaNNm3gVCUv0Kgsp6YOPzkzsMnwgNLYb6ZaR8O
 j+ueoi+2hROJP27JMAFzV8CkdogY2SrRXeAGLtprvhiUqvOAtEXy5c7sAc0LY+nKp2zF
 i7eaAr2pL8FiwaBhvSDBPfdYTiyuhFeHJCG5ZFtp7Df5LaLNaUTOqlgEH3khXWAN3wb3
 wF3IoYQKPD/hr1ASpyrPFfT/kjsHHAVqTyD/ZlqUfm9bJjvHe5ozvQRJp4rey+tc4eND eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8jsbbfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:27 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFGUYr031909;
        Thu, 21 Jul 2022 16:13:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8jsbbdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7Wsa028797;
        Thu, 21 Jul 2022 16:13:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8yarh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDLLP23986662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2836A405C;
        Thu, 21 Jul 2022 16:13:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F015A4054;
        Thu, 21 Jul 2022 16:13:21 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: [GIT PULL 28/42] KVM: s390: pv: handle secure storage violations for protected guests
Date:   Thu, 21 Jul 2022 18:12:48 +0200
Message-Id: <20220721161302.156182-29-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cN2OAXmJAVVGsuy8OQviDpH-qXbXlJB6
X-Proofpoint-GUID: ALNRkAJ-cgDCsflr3UvPuKJ7orRUmxVR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=874 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A secure storage violation is triggered when a protected guest tries to
access secure memory that has been mapped erroneously, or that belongs
to a different protected guest or to the ultravisor.

With upcoming patches, protected guests will be able to trigger secure
storage violations in normal operation. This happens for example if a
protected guest is rebooted with deferred destroy enabled and the new
guest is also protected.

When the new protected guest touches pages that have not yet been
destroyed, and thus are accounted to the previous protected guest, a
secure storage violation is raised.

This patch adds handling of secure storage violations for protected
guests.

This exception is handled by first trying to destroy the page, because
it is expected to belong to a defunct protected guest where a destroy
should be possible. Note that a secure page can only be destroyed if
its protected VM does not have any CPUs, which only happens when the
protected VM is being terminated. If that fails, a normal export of
the page is attempted.

This means that pages that trigger the exception will be made
non-secure (in one way or another) before attempting to use them again
for a different secure guest.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-3-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-3-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kernel/uv.c      | 55 ++++++++++++++++++++++++++++++++++++++
 arch/s390/mm/fault.c       | 10 +++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 18fe04c8547e..be3ef9dd6972 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -426,6 +426,7 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c13d5a7b71f0..4c91a3dbc05b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -334,6 +334,61 @@ int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
 }
 EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
 
+/**
+ * gmap_destroy_page - Destroy a guest page.
+ * @gmap: the gmap of the guest
+ * @gaddr: the guest address to destroy
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
index e173b6187ad5..af1ac49168fb 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -837,6 +837,16 @@ NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
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
2.36.1

