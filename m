Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D24440E28
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhJaMOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:14:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231949AbhJaMNs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:48 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VBmUjA011703;
        Sun, 31 Oct 2021 12:11:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=mAdAzVDdoeyKjsXPshIIyj++5/1qb6MzjxdWbk5sqVA=;
 b=FPo+POVYlAP2qC0/p1UNs/eENBkSKqgdXq02s5VNALSOdV1whYTpEmqV9Y8yfRsl90g4
 CHrMgWVb/DkNZ+XL901FiMIn0qfccr+W60L4UblBji2f0Zgza7DQJ8zpfqZDS7HFaAf8
 vFrodR3D1y3Qs0mSK1fgQJYk3PU+BC33/O5cOVSHFFpjvROUJKPCES1jOusSr9tmBlFp
 FaMLbdnx9eKHD0IqzzptxhSobFgzy4rgwvOMF0PALUGA5KmtcvQJZMkzYXVfv3gstQKA
 pL1F0Pq5QyVlzkmv8DeERhzBDTGmoVg4iKxHKqibpZG+a5QYdxUTr2knRyyH6Uz/ANKC tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c1tkj8922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCBF53010313;
        Sun, 31 Oct 2021 12:11:15 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c1tkj891e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:15 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC8toq030645;
        Sun, 31 Oct 2021 12:11:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3c0wp94pd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCBAD338666524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:10 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6292042047;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ADF542045;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id F1620E056B; Sun, 31 Oct 2021 13:11:09 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 16/17] KVM: s390: pv: properly handle page flags for protected guests
Date:   Sun, 31 Oct 2021 13:11:03 +0100
Message-Id: <20211031121104.14764-17-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W9UWgJN48E7LF5jbxuKlrKdYDIp-K99l
X-Proofpoint-GUID: 3h0CJgX_PWx7d2-Jz84YwB1BHco3yAeC
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=949 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Introduce variants of the convert and destroy page functions that also
clear the PG_arch_1 bit used to mark them as secure pages.

The PG_arch_1 flag is always allowed to overindicate; using the new
functions introduced here allows to reduce the extent of overindication
and thus improve performance.

These new functions can only be called on pages for which a reference
is already being held.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210920132502.36111-7-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  9 ++++++---
 arch/s390/include/asm/uv.h      | 10 ++++++++--
 arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
 arch/s390/mm/gmap.c             |  4 +++-
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b61426c9ef17..e43416950245 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	pte_t res;
 
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	pte_t res;
 
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 9ab1914c5b95..72d3e49c2860 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -356,8 +356,9 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int uv_destroy_page(unsigned long paddr);
+int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
+int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
 void setup_uv(void);
@@ -365,7 +366,7 @@ void setup_uv(void);
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 
-static inline int uv_destroy_page(unsigned long paddr)
+static inline int uv_destroy_owned_page(unsigned long paddr)
 {
 	return 0;
 }
@@ -374,6 +375,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
 }
+
+static inline int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	return 0;
+}
 #endif
 
 #endif /* _ASM_S390_UV_H */
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 09b80d371409..8b0e62507d62 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -100,7 +100,7 @@ static int uv_pin_shared(unsigned long paddr)
  *
  * @paddr: Absolute host address of page to be destroyed
  */
-int uv_destroy_page(unsigned long paddr)
+static int uv_destroy_page(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
@@ -120,6 +120,22 @@ int uv_destroy_page(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_destroy_owned_page(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_destroy_page(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Requests the Ultravisor to encrypt a guest page and make it
  * accessible to the host for paging (export).
@@ -139,6 +155,22 @@ int uv_convert_from_secure(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_convert_from_secure(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Calculate the expected ref_count for a page that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index d63c0ccc5ccd..dfee0ebb2fac 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2684,8 +2684,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
 {
 	pte_t pte = READ_ONCE(*ptep);
 
+	/* There is a reference through the mapping */
 	if (pte_present(pte))
-		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
+		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
+
 	return 0;
 }
 
-- 
2.31.1

