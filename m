Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB7386543
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhEQUJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237648AbhEQUJY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:24 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK42DQ010236;
        Mon, 17 May 2021 16:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lcS1oPzM/HaoemXQ/k5aHQXUjFtNIVU5i2RT/CgUc28=;
 b=Qrjf2hINF7SsJmJX94GPT8UJ9gmTzPHOnxXQa4QDPoVCMxEUgTLiAWOIwyvr8l5wKe/a
 GxheHu39d98NkFcRh1E04F02RCUMwvollKx8VZWpRv65Q2HTTbFUbQKB+mYE+P9xVV4u
 Fdtnl3rIITayF4AtwgtvJKyxOv3exuXIu3bI0lQuAtMv8zJonRxqxVwZtg6PfPJ84x0J
 L8znjWWXOvjw7tTYtVDLFXuHqINkoCndSwttMKBy0iu6snjGa3wdyblDyYS00YrfZflX
 ASfCCuWF0Ruc6YGytpdwT4wqcGLEGJJhWkBJ6pMS/1mawWZ+k100c9XIvBM6vxh+ar+O /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kwk7asq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:06 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK5CCt014840;
        Mon, 17 May 2021 16:08:06 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kwk7asp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:06 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK84aH001482;
        Mon, 17 May 2021 20:08:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 38j5x88k7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK7XWg29163822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:07:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0F6A52050;
        Mon, 17 May 2021 20:08:00 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5F6F55205A;
        Mon, 17 May 2021 20:08:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 03/11] KVM: s390: pv: handle secure storage violations for protected guests
Date:   Mon, 17 May 2021 22:07:50 +0200
Message-Id: <20210517200758.22593-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9myAGkH7_BDl4fnvX2x7ntnjZZw-cPsG
X-Proofpoint-GUID: QOwVd3yq0VX8AgACcjEoOI1uOKuJdmuG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=816 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, protected guests will be able to trigger secure
storage violations in normal operation.

This patch adds handling of secure storage violations for protected
guests.

Pages that trigger the exception will be made non-secure before
attempting to use them again.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kernel/uv.c      | 43 ++++++++++++++++++++++++++++++++++++++
 arch/s390/mm/fault.c       | 10 +++++++++
 3 files changed, 54 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 9aa621e84745..c6fe6a42e79b 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -345,6 +345,7 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 3d94760c0371..b19b1a1444ec 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -338,6 +338,49 @@ int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
 }
 EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
 
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
+	vma = find_vma(gmap->mm, uaddr);
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
+	 * Fault handlers can race; it is possible that one CPU will destroy
+	 * and import the page, at which point the second CPU handling the
+	 * same fault will not be able to destroy. In that case we do not
+	 * want to terminate the process, we instead try to export the page.
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
index e30c7c781172..efdef35bc415 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -846,6 +846,16 @@ NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
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
2.31.1

