Return-Path: <kvm+bounces-57227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 291D7B51FD2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B7FC1C85789
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8631F34164E;
	Wed, 10 Sep 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KOStvE9T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341233A006;
	Wed, 10 Sep 2025 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527677; cv=none; b=nwlxM/PkGnJX/wkVjnSkODzo6x3jqARW9p2Q8q3XUVKd+6KeD/eNYLBAn54mWPfoExermQcqOVbEuYlJNQLwoCalQTxISUtdhoVUE0QDeYKaEQFa7QadKoYrwLIhWMTJ3zoAw0vQ28WoK1xtEtnASC2yLIPvT08SaU4ltSuFjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527677; c=relaxed/simple;
	bh=bWMowTeh2/1d5oGu7izhhh9kJVERl9VAD674OQHgcCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDqPbV1EnFuRaMJJQHUAGg2hdckR2e6e0rWv6p4qsQzFj0yGX8Fx7+JOs0J7r58P1/OHGXn/l7AQE0B9mVy5Jw7BVIPgxF/S3cK2VMTwpjYKxN83LusfOGk5KXBsk0rdYiPDMM4R+Bl82Nte1zYhBoeBXpw6pIHTOY2NUEkK6d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KOStvE9T; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGb4Fq019819;
	Wed, 10 Sep 2025 18:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vGFJ7em+CPmlCOCor
	dbIG3MyDmtsZvzzNsmREmWKrbw=; b=KOStvE9TBOrjeHfKJTMIgHQy/dhXB+JDq
	v2kc884LKQbgu8bVlgIrJSgAHB1PMwZhfMpPZtSW3FWaO2GUFtxky9TzougZspD8
	AWGPKjG+xdZMlr3g2Ou50GBCAi2Hf+mF1bbb3E3KUoh642NIsfW1+/IJy/NkYFpE
	O+2LMYCMVWhyn64iRzn5pELgst7xPRYPuBotLuSc7ekm/b/Q/O1JwPRETpnQhfzi
	OXHqcwVv52XiV781fOmbTCq3MIn6LxDHNlmUNWtBwBvKEG9iNFmHxr2Oc20AQn7j
	dalVQcY9VeaiZDczHWOrjcvjsbH+cS3wl1MMBDxfJAgC7lKz/76qw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukemvr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AF1kpn001172;
	Wed, 10 Sep 2025 18:07:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203hjp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7m0k48890134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D37F520040;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DA1020049;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 08/20] KVM: s390: KVM page table management functions: allocation
Date: Wed, 10 Sep 2025 20:07:34 +0200
Message-ID: <20250910180746.125776-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910180746.125776-1-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX035V6400oW3N
 jMvGmQVV/dYBljsX7JCcDdMa+P7QMAitNRr//Dd5edqzPSyYHyNqoH3FcGLX0EU2+ii8JkSUFIi
 EviNVv6CJswNqU5e0YiHcltFf/773raUARjlU9DriyvVRGnJEIn3kaQZSfhYJxOTpbicVYc1pkz
 b/CLRVjvbfq7ctbUCHFu6rHJxZhT6cU3IgTnHA6d8+T/GyxXd+Xi1RTkZRdYPbB8Z9S0ZfPAHR5
 nQ7NsKocNl0Ur/fFs7IxPrHT+Oni59y5l6Q+y7SZjmWKTeQyAaEp1cXU/Iko1xU07wHtQi3EREy
 /ntviNpD8ni/zVYzDx/mzvy800Aol8W4OHaDR55MVJoIQVRmbXmFON/ZBmcR9DyKIQkwfUSpdb0
 h2kaMYY+
X-Proofpoint-ORIG-GUID: nCfm7gBG3jxakD3lN3DGH6FtRZ7rRuMB
X-Proofpoint-GUID: nCfm7gBG3jxakD3lN3DGH6FtRZ7rRuMB
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c1be79 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=6fqA5LU_ubG9txeiEBQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds the boilerplate and functions for the allocation and
deallocation of DAT tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/Makefile     |  1 +
 arch/s390/kvm/dat.c        | 91 ++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h        |  4 ++
 arch/s390/mm/page-states.c |  1 +
 4 files changed, 97 insertions(+)
 create mode 100644 arch/s390/kvm/dat.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 9a723c48b05a..84315d2f75fb 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
+kvm-y += dat.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
new file mode 100644
index 000000000000..326be78adcda
--- /dev/null
+++ b/arch/s390/kvm/dat.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2020, 2024
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *		 David Hildenbrand <david@redhat.com>
+ *		 Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pagewalk.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/swapops.h>
+#include <linux/ksm.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+
+#include <asm/pgalloc.h>
+#include <asm/page-states.h>
+#include <asm/tlb.h>
+#include "dat.h"
+
+static inline struct page_table *dat_alloc_pt_noinit(void)
+{
+	struct page *page;
+	void *virt;
+
+	page = alloc_pages(GFP_ATOMIC, 0);
+	if (!page)
+		return NULL;
+
+	virt = page_to_virt(page);
+	__arch_set_page_dat(virt, 1);
+	return virt;
+}
+
+struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits)
+{
+	struct page_table *res;
+
+	res = dat_alloc_pt_noinit();
+	if (res)
+		dat_init_page_table(res, pte_bits, pgste_bits);
+	return res;
+}
+
+static inline struct crst_table *dat_alloc_crst_noinit(void)
+{
+	struct page *page;
+	void *virt;
+
+	page = alloc_pages(GFP_ATOMIC | __GFP_COMP, CRST_ALLOC_ORDER);
+	if (!page)
+		return NULL;
+	virt = page_to_virt(page);
+	__arch_set_page_dat(virt, 1UL << CRST_ALLOC_ORDER);
+	return virt;
+}
+
+struct crst_table *dat_alloc_crst(unsigned long init)
+{
+	struct crst_table *res;
+
+	res = dat_alloc_crst_noinit();
+	if (res)
+		crst_table_init((void *)res, init);
+	return res;
+}
+
+void dat_free_level(struct crst_table *table, bool owns_ptes)
+{
+	unsigned int i;
+
+	for (i = 0; i < _CRST_ENTRIES; i++) {
+		if (table->crstes[i].h.fc || table->crstes[i].h.i)
+			continue;
+		if (!is_pmd(table->crstes[i]))
+			dat_free_level(dereference_crste(table->crstes[i]), owns_ptes);
+		else if (owns_ptes)
+			dat_free_pt(dereference_pmd(table->crstes[i].pmd));
+	}
+	dat_free_crst(table);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 1e355239247b..5056cfa02619 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -385,6 +385,10 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool w, bool d)
 	return res;
 }
 
+void dat_free_level(struct crst_table *table, bool owns_ptes);
+struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits);
+struct crst_table *dat_alloc_crst(unsigned long init);
+
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
 	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index 01f9b39e65f5..5bee173db72e 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 
 int __bootdata_preserved(cmma_flag);
+EXPORT_SYMBOL(cmma_flag);
 
 void arch_free_page(struct page *page, int order)
 {
-- 
2.51.0


