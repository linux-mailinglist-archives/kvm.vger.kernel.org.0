Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892FD411588
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhITN0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36250 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239406AbhITN0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:42 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD3xF008192;
        Mon, 20 Sep 2021 09:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YHr4VAbKSlFMvGduFqQ1hgUf0FOp5Uz0G/5DpnNIGCs=;
 b=NM53Sg75Jbh110uzxdUUSO/PuksKGkPoWusRfx/2Q8Ml3x0DpsN/r4TGlGIDrtD23qm7
 qBYuP1HU/haWVDsgsQ//4hlYOnIxUWM6UhMHmB6GTT30TK5TR0wM8d14l5w6JPLVtaPL
 usJ8szZDdZ7IUsr++mgi/9hHC6cvP9gcokbxeELwkUFkeP+PnJ+V+i1wnGITRzGPvQH2
 Jha4aLHTRdZxtxa/n3gYmE/qnV8CPEXDDoG1RgDiMHycMSV43YYH1YLiLJWZc9qu1EEE
 J/KaSbpmAiqXtlacN3tcuQ5YquJ44t3I81Q6I5s/SpAS26Z3oEDVhjFTGNKgS/0aLVUL BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1jfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:14 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDDL7W009514;
        Mon, 20 Sep 2021 09:25:14 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1je0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD63V031006;
        Mon, 20 Sep 2021 13:25:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj86sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP73C35520978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 558FAA4051;
        Mon, 20 Sep 2021 13:25:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E02C4A4040;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 07/14] KVM: s390: pv: handle secure storage violations for protected guests
Date:   Mon, 20 Sep 2021 15:24:55 +0200
Message-Id: <20210920132502.36111-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dh8DdtIVRUkG1saqit2s9l1v5uq-o1fp
X-Proofpoint-ORIG-GUID: HKPesSK7mRCMS09hOvlhXjKmC9KFzE7l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=708
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200079
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
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kernel/uv.c      | 46 ++++++++++++++++++++++++++++++++++++++
 arch/s390/mm/fault.c       | 10 +++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 3236293d5a31..c8bd72be8974 100644
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
index 05f8bf61d20a..3d2042e85151 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -349,6 +349,52 @@ int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
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
index e33c43b38afe..eb68b4f36927 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -850,6 +850,16 @@ NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
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

