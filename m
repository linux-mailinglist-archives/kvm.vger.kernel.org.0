Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0954440E0A
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhJaMNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229982AbhJaMNn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:43 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VC7xrX006822;
        Sun, 31 Oct 2021 12:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=qP6ZZ8/L6afteZFkiW1RgjMdtZ74JIif7/qc/Eoq3o4=;
 b=nB/DeMfxaVRiYdve/VW27NOwxDuxfXoSgjOTSFpnzkkJ7H0euQ+BVvI2HOhKJ2yRpWah
 Qm+JIAXZSFujFEYvTScf0UoOUfQv0B+BLmyzaxh2Ep08rn54rNFkiWMLbQAFsgFMsVpy
 CdHSMPOc0uKtGQAo9InkndkEy2QlAarYFkstUVny1YRq6QCr/pUOY1oqoufVOpjOz3QD
 H8uHYSdaLD83QpUw/YKifQ+P/GIgPphdMjXwhtinRDMtnGTkNglCdMuqcEMLIeKiFP+t
 Glz+0lHwDQIJEowr1oH7OxEe95TYV7fPcpRUI3/PYYe8eOoEyTTOAlDxd1CzWgHV6bNC fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1s75s1k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:11 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VCBBv3018268;
        Sun, 31 Oct 2021 12:11:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1s75s1jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9BPN011176;
        Sun, 31 Oct 2021 12:11:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3c0waj4qvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB58V25100682
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E6B942042;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A8074203F;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id DBC80E06C2; Sun, 31 Oct 2021 13:11:04 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 01/17] s390/gmap: validate VMA in __gmap_zap()
Date:   Sun, 31 Oct 2021 13:10:48 +0100
Message-Id: <20211031121104.14764-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dJcuGye-6qTOcWZZVb3CoZVpaxGs1RK9
X-Proofpoint-ORIG-GUID: gQetYFMUuPg5FodQziXlp574vWNvRSRy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 adultscore=0 spamscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap"). The pure prescence in our guest_to_host
radix tree does not imply that there is a VMA.

Further, we should not allocate page tables (via get_locked_pte()) outside
of VMA boundaries: if evil user space decides to map hugetlbfs to these
ranges, bad things will happen because we suddenly have PTE or PMD page
tables where we shouldn't have them.

Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
calling get_locked_pte().

Note that gmap_discard() is different:
zap_page_range()->unmap_single_vma() makes sure to stay within VMA
boundaries.

Fixes: b31288fa83b2 ("s390/kvm: support collaborative memory management")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-2-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/gmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 4d3b33ce81c6..e0735c343775 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -672,6 +672,7 @@ EXPORT_SYMBOL_GPL(gmap_fault);
  */
 void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 {
+	struct vm_area_struct *vma;
 	unsigned long vmaddr;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -681,6 +682,11 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 						   gaddr >> PMD_SHIFT);
 	if (vmaddr) {
 		vmaddr |= gaddr & ~PMD_MASK;
+
+		vma = vma_lookup(gmap->mm, vmaddr);
+		if (!vma || is_vm_hugetlb_page(vma))
+			return;
+
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
 		if (likely(ptep))
-- 
2.31.1

