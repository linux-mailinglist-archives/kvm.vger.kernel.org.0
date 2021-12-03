Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24AB467BEC
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382253AbhLCRBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:49 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57104 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382238AbhLCRBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:47 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GmB47001029;
        Fri, 3 Dec 2021 16:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sF223Wvbi6df2izpTLXQX3avsSRj5+5piQo/k4EjQ5s=;
 b=FnPJZunMhwHZjBb6rhzLWNQj8W/GNbLlS6TDeYasMfNaS8/thkXbqzio5wqZ29963xv8
 f2AH1Q0kg+0EqrT6+c/mqTR3Xt4pRocne0/u7jX24M9eFPrP0kARvU2C3Ivu2tvGqg35
 bU0fZFFWrZyIwt5Ta9uQuBJpIBv7QYa6Qy4UGh9rUYrWlJvWRvVpiJtFPdFhrasSzt9q
 J/B455lnn6W2ZXQJ8YoGsII8GmRISUFbAlI7oYaDdCYfWPdCpWNGr74csvpzWA1oh4UG
 RziRDP9DAnpMFdSdHmnflW7s4YQo2G3aC+P4TzWRRDmue52ki4mCCMgEy1i3UPSQaeT9 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2rr5f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GnWrl002988;
        Fri, 3 Dec 2021 16:58:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2rr5em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GwEBq023029;
        Fri, 3 Dec 2021 16:58:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkyv8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwGuG18481542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D0A05204E;
        Fri,  3 Dec 2021 16:58:16 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1B46752051;
        Fri,  3 Dec 2021 16:58:16 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/17] KVM: s390: pv: handle secure storage violations for protected guests
Date:   Fri,  3 Dec 2021 17:57:59 +0100
Message-Id: <20211203165814.73016-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yl9zqjB4xSV5hLrbW41TGRNUNKy9Y5Kq
X-Proofpoint-GUID: 7VRnY0xd3jba_BzWa9SuiRIiFrm98HjW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=623 lowpriorityscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With upcoming patches, protected guests will be able to trigger secure
storage violations in normal operation.

This patch adds handling of secure storage violations for protected
guests.

Pages that trigger the exception will be made non-secure before
attempting to use them again for a different secure guest.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kernel/uv.c      | 55 ++++++++++++++++++++++++++++++++++++++
 arch/s390/mm/fault.c       | 10 +++++++
 3 files changed, 66 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 72d3e49c2860..cdbd340188ab 100644
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
index 386d4e42b8d3..f706456f6261 100644
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
index d30f5986fa85..a1928c89bbfa 100644
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
2.31.1

