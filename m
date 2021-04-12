Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D686435CAC7
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243290AbhDLQG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:06:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14006 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243218AbhDLQGO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 12:06:14 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CG3VMI102318;
        Mon, 12 Apr 2021 12:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=orDMdXV3rlosXcj+oxi4JJynnRcsI+kKvmzDHBz7sNk=;
 b=tlvpapH2GjFm7JoNhLXLi7oMVmeuN+0DpcD8YSzxvRXm08oBFcFXqAmlE7ZvPY/wdhGO
 RlMkk46wSuOQ3Yedm5GUYZERXuwbxjbx1lMqyh9erJA+fsDNJguz6uQ62vwhxemN+PWr
 I1S+e/naHCq/0Atagagkpbh4o4swiRV9htdrl/Okmf2Ej/Kk3ax2Bh/dP4BCxBbL4voj
 XU5TG+7aTC26p4ypNgbmfOEsj21aT3gJnaoLaiyOnqW4VGI9xzpCGjbFFzTd81oBcsyw
 QPDJMjWN2VgDGlU6X9kbRAUOOlqTlBtK6bSNee96XPgUFFEdL4xkEkUuJ1nJK3FQ9Zi3 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vkd56w52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:55 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CG48Zc105567;
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vkd56w3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 12:05:54 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CFsWXh011311;
        Mon, 12 Apr 2021 16:05:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n891ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 16:05:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CG5Qsr32244188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 16:05:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4CAAA4040;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B7E2A405B;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 12 Apr 2021 16:05:47 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 5C1E7E0393; Mon, 12 Apr 2021 18:05:47 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@de.ibm.com>
Subject: [GIT PULL 4/7] KVM: s390: extend kvm_s390_shadow_fault to return entry pointer
Date:   Mon, 12 Apr 2021 18:05:42 +0200
Message-Id: <20210412160545.231194-5-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412160545.231194-1-borntraeger@de.ibm.com>
References: <20210412160545.231194-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KZBhrrAWnTxPabMRID6vn5r3AGGgeECp
X-Proofpoint-ORIG-GUID: OeAMq4vbmt6HqtecqzLEUloxY0voZryE
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_11:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
DAT table entry, or to the invalid entry.

Also return some flags in the lower bits of the address:
PEI_DAT_PROT: indicates that DAT protection applies because of the
              protection bit in the segment (or, if EDAT, region) tables.
PEI_NOT_PTE: indicates that the address of the DAT table entry returned
             does not refer to a PTE, but to a segment or region table.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: stable@vger.kernel.org
Reviewed-by: Janosch Frank <frankja@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210302174443.514363-3-imbrenda@linux.ibm.com
[borntraeger@de.ibm.com: fold in a fix from Claudio]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
 arch/s390/kvm/gaccess.h |  6 +++++-
 arch/s390/kvm/vsie.c    |  8 ++++----
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6b57059493..b9f85b2dc053 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
  * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
- * @pgt: pointer to the page table address result
+ * @pgt: pointer to the beginning of the page table for the given address if
+ *	 successful (return value 0), or to the first invalid DAT entry in
+ *	 case of exceptions (return value > 0)
  * @fake: pgt references contiguous guest memory block, not a pgtable
  */
 static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
@@ -1034,6 +1036,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rfte.val = ptr;
 			goto shadow_r2t;
 		}
+		*pgt = ptr + vaddr.rfx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
 		if (rc)
 			return rc;
@@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rste.val = ptr;
 			goto shadow_r3t;
 		}
+		*pgt = ptr + vaddr.rsx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
 		if (rc)
 			return rc;
@@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			rtte.val = ptr;
 			goto shadow_sgt;
 		}
+		*pgt = ptr + vaddr.rtx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
 		if (rc)
 			return rc;
@@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 			ste.val = ptr;
 			goto shadow_pgt;
 		}
+		*pgt = ptr + vaddr.sx * 8;
 		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
 		if (rc)
 			return rc;
@@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
  * @vcpu: virtual cpu
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
+ * @datptr: will contain the address of the faulting DAT table entry, or of
+ *	    the valid leaf, plus some flags
  *
  * Returns: - 0 if the shadow fault was successfully resolved
  *	    - > 0 (pgm exception code) on exceptions while faulting
@@ -1165,11 +1173,11 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
  *	    - -ENOMEM if out of memory
  */
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
-			  unsigned long saddr)
+			  unsigned long saddr, unsigned long *datptr)
 {
 	union vaddress vaddr;
 	union page_table_entry pte;
-	unsigned long pgt;
+	unsigned long pgt = 0;
 	int dat_protection, fake;
 	int rc;
 
@@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 		pte.val = pgt + vaddr.px * PAGE_SIZE;
 		goto shadow_page;
 	}
-	if (!rc)
-		rc = gmap_read_table(sg->parent, pgt + vaddr.px * 8, &pte.val);
+
+	switch (rc) {
+	case PGM_SEGMENT_TRANSLATION:
+	case PGM_REGION_THIRD_TRANS:
+	case PGM_REGION_SECOND_TRANS:
+	case PGM_REGION_FIRST_TRANS:
+		pgt |= PEI_NOT_PTE;
+		break;
+	case 0:
+		pgt += vaddr.px * 8;
+		rc = gmap_read_table(sg->parent, pgt, &pte.val);
+	}
+	if (datptr)
+		*datptr = pgt | dat_protection * PEI_DAT_PROT;
 	if (!rc && pte.i)
 		rc = PGM_PAGE_TRANSLATION;
 	if (!rc && pte.z)
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 2d8631a1f23e..daba10f76936 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -376,7 +376,11 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
 int ipte_lock_held(struct kvm_vcpu *vcpu);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
+/* MVPG PEI indication bits */
+#define PEI_DAT_PROT 2
+#define PEI_NOT_PTE 4
+
 int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
-			  unsigned long saddr);
+			  unsigned long saddr, unsigned long *datptr);
 
 #endif /* __KVM_S390_GACCESS_H */
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index bd803e091918..78b604326016 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -620,10 +620,10 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix);
+	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
 	if (!rc && (scb_s->ecb & ECB_TE))
 		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-					   prefix + PAGE_SIZE);
+					   prefix + PAGE_SIZE, NULL);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -914,7 +914,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 				    current->thread.gmap_addr, 1);
 
 	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_addr);
+				   current->thread.gmap_addr, NULL);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
 				  current->thread.gmap_addr,
@@ -936,7 +936,7 @@ static void handle_last_fault(struct kvm_vcpu *vcpu,
 {
 	if (vsie_page->fault_addr)
 		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr);
+				      vsie_page->fault_addr, NULL);
 	vsie_page->fault_addr = 0;
 }
 
-- 
2.30.2

