Return-Path: <kvm+bounces-47585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9237EAC2364
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 15:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DDF07AF66B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A414E1B3725;
	Fri, 23 May 2025 13:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gz/hIbei"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993B1197A8E;
	Fri, 23 May 2025 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005441; cv=none; b=EtTxab4J3YSaF3hkqDBFhgRvLUmu20EcbXkK6Jgmmn7UnExgydCBh686/l8gtvOR4OXRRqmDSijv13IuBH5V8gSRYtWEKVb2a9LLgAEe7Zs6qvaj3cFYEujJ3oGlRMQRl0xWD7NF7D8fe+V8YkEF2OihRGuZG8+tADpYLcSvoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005441; c=relaxed/simple;
	bh=uYbH/ZIqMPWrZFB8YNPBWGbymnQ+Ulhst/xo8QmXFO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxyU5lCYLMRk2KFRxSdkKL8bKGAhTr+tfH7QctgQ3i6STeKuOWrDne6ToFC0QpCx6tnkhItZPCB6bKiV0KTrg9idmL2KLMNVsFlHUjzVoyQfj2K0ncYUsv6zM5kCOWPBxrnZnJlPlfGQZUKPBuviTmukxM3VxT/iTrDTBWwcH8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gz/hIbei; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAeTVn031163;
	Fri, 23 May 2025 13:03:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q4qhSMlU70LDNj830
	PN6JuSZerM3apOOxDsenQhu3Tk=; b=Gz/hIbeib4QpCDBtGXP0WcKXgH9rbPOyG
	HNYPHQuyTiSjJ/haQfj+wSuYd87WxQ9KgLjNr1wxc0HKulkrTXOrZmz+da2/z9Qj
	JwOGk9DhYVXCHaSHtJz2vLTpdYQ/3JVG+sU+hr1EFg0vNIIu5oW1K2rsBcjx2z+9
	3rA+FXVmBs+iDzoGbwNyy9PSECQTbqDymnuI8d+J7D6Q6LYJNQ3KD4yBJhAt9M9B
	q9iyec0qWhnbMqNKn0q7dFz8GBUTVc9Mp+OxLpv5G0WNy2LhpzjBpoSEkLS6k2/v
	k3L69nQoQE9D+0/MrJuzgi+A94jra+j6gkXw7IuJJEsy8sOAYhGEg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t669nefh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NAXVZS032122;
	Fri, 23 May 2025 13:03:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnmpm3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 13:03:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54ND3pTq42205612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 13:03:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F75720040;
	Fri, 23 May 2025 13:03:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B497220043;
	Fri, 23 May 2025 13:03:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 13:03:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v4 4/4] KVM: s390: simplify and move pv code
Date: Fri, 23 May 2025 15:03:48 +0200
Message-ID: <20250523130348.247446-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523130348.247446-1-imbrenda@linux.ibm.com>
References: <20250523130348.247446-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=RrPFLDmK c=1 sm=1 tr=0 ts=6830723c cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=7_jnfmalSeIvgFZyEUQA:9
X-Proofpoint-ORIG-GUID: d9uO2zXDTQNGKAFt_BDA3C5I7fzMKq2L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDExNSBTYWx0ZWRfXwk8lIdrl//SD RkXslRyjvno+5E87CGIyOyW+L+OUgUxecFBYYmSA0lmYXynCCP8QZLUiR2PsIzI/eESKcZI6eQS NgRwdMNJI5eb/qfe2Xnz08lGx9YAMhIps/0x8iTA9/MaMgj7g3E8B8qNCEd2Udcur8LrjNLAs+K
 0vftOgsdq2sprk1vv9hdyLShadwyPMlO8kyiKjKfPxAqQXFJXOn3FBmC6MYrF6hPfqihQX48jJA KV55NLyaJnkPpLCRvxR64KW4rPzVUs1LvLOx2XNiQABoTLq+3f3ogkulUcBxfnnG4ypAhhZEsgH MEYiz0uci/DAADVA+BqsYzQJDy3EyzOwKUujvu7c3aKbyKdXcRdGS8ww4eqtjNX1oRDgiE4NU2g
 AYUUPtAxvDN4e6BVOrzn8T3Vo9oP7DUVHz22pI2kMfOxY3L9JY7BXk3k2oiLoebaxRQl72OM
X-Proofpoint-GUID: d9uO2zXDTQNGKAFt_BDA3C5I7fzMKq2L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_03,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230115

All functions in kvm/gmap.c fit better in kvm/pv.c instead.
Move and rename them appropriately, then delete the now empty
kvm/gmap.c and kvm/gmap.h.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kernel/uv.c     |  12 ++--
 arch/s390/kvm/Makefile    |   2 +-
 arch/s390/kvm/gaccess.c   |   3 +-
 arch/s390/kvm/gmap-vsie.c |   1 -
 arch/s390/kvm/gmap.c      | 121 --------------------------------------
 arch/s390/kvm/gmap.h      |  39 ------------
 arch/s390/kvm/intercept.c |  10 +---
 arch/s390/kvm/kvm-s390.c  |   5 +-
 arch/s390/kvm/kvm-s390.h  |  42 +++++++++++++
 arch/s390/kvm/pv.c        |  61 ++++++++++++++++++-
 arch/s390/kvm/vsie.c      |  19 +++++-
 11 files changed, 133 insertions(+), 182 deletions(-)
 delete mode 100644 arch/s390/kvm/gmap.c
 delete mode 100644 arch/s390/kvm/gmap.h

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 9a5d5be8acf4..644c110287c4 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -135,7 +135,7 @@ int uv_destroy_folio(struct folio *folio)
 {
 	int rc;
 
-	/* See gmap_make_secure(): large folios cannot be secure */
+	/* Large folios cannot be secure */
 	if (unlikely(folio_test_large(folio)))
 		return 0;
 
@@ -184,7 +184,7 @@ int uv_convert_from_secure_folio(struct folio *folio)
 {
 	int rc;
 
-	/* See gmap_make_secure(): large folios cannot be secure */
+	/* Large folios cannot be secure */
 	if (unlikely(folio_test_large(folio)))
 		return 0;
 
@@ -403,15 +403,15 @@ EXPORT_SYMBOL_GPL(make_hva_secure);
 
 /*
  * To be called with the folio locked or with an extra reference! This will
- * prevent gmap_make_secure from touching the folio concurrently. Having 2
- * parallel arch_make_folio_accessible is fine, as the UV calls will become a
- * no-op if the folio is already exported.
+ * prevent kvm_s390_pv_make_secure() from touching the folio concurrently.
+ * Having 2 parallel arch_make_folio_accessible is fine, as the UV calls will
+ * become a no-op if the folio is already exported.
  */
 int arch_make_folio_accessible(struct folio *folio)
 {
 	int rc = 0;
 
-	/* See gmap_make_secure(): large folios cannot be secure */
+	/* Large folios cannot be secure */
 	if (unlikely(folio_test_large(folio)))
 		return 0;
 
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index f0ffe874adc2..9a723c48b05a 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -8,7 +8,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap.o gmap-vsie.o
+kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f6fded15633a..e23670e1949c 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -16,9 +16,10 @@
 #include <asm/gmap.h>
 #include <asm/dat-bits.h>
 #include "kvm-s390.h"
-#include "gmap.h"
 #include "gaccess.h"
 
+#define GMAP_SHADOW_FAKE_TABLE 1ULL
+
 /*
  * vaddress union in order to easily decode a virtual address into its
  * region first index, region second index etc. parts.
diff --git a/arch/s390/kvm/gmap-vsie.c b/arch/s390/kvm/gmap-vsie.c
index a6d1dbb04c97..56ef153eb8fe 100644
--- a/arch/s390/kvm/gmap-vsie.c
+++ b/arch/s390/kvm/gmap-vsie.c
@@ -22,7 +22,6 @@
 #include <asm/uv.h>
 
 #include "kvm-s390.h"
-#include "gmap.h"
 
 /**
  * gmap_find_shadow - find a specific asce in the list of shadow tables
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
deleted file mode 100644
index 6d8944d1b4a0..000000000000
--- a/arch/s390/kvm/gmap.c
+++ /dev/null
@@ -1,121 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Guest memory management for KVM/s390
- *
- * Copyright IBM Corp. 2008, 2020, 2024
- *
- *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
- *               Martin Schwidefsky <schwidefsky@de.ibm.com>
- *               David Hildenbrand <david@redhat.com>
- *               Janosch Frank <frankja@linux.vnet.ibm.com>
- */
-
-#include <linux/compiler.h>
-#include <linux/kvm.h>
-#include <linux/kvm_host.h>
-#include <linux/pgtable.h>
-#include <linux/pagemap.h>
-
-#include <asm/lowcore.h>
-#include <asm/gmap.h>
-#include <asm/uv.h>
-
-#include "gmap.h"
-
-/**
- * gmap_make_secure() - make one guest page secure
- * @gmap: the guest gmap
- * @gaddr: the guest address that needs to be made secure
- * @uvcb: the UVCB specifying which operation needs to be performed
- *
- * Context: needs to be called with kvm->srcu held.
- * Return: 0 on success, < 0 in case of error.
- */
-int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
-{
-	struct kvm *kvm = gmap->private;
-	unsigned long vmaddr;
-
-	lockdep_assert_held(&kvm->srcu);
-
-	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return -EFAULT;
-	return make_hva_secure(gmap->mm, vmaddr, uvcb);
-}
-
-int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
-{
-	struct uv_cb_cts uvcb = {
-		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
-		.header.len = sizeof(uvcb),
-		.guest_handle = gmap->guest_handle,
-		.gaddr = gaddr,
-	};
-
-	return gmap_make_secure(gmap, gaddr, &uvcb);
-}
-
-/**
- * __gmap_destroy_page() - Destroy a guest page.
- * @gmap: the gmap of the guest
- * @page: the page to destroy
- *
- * An attempt will be made to destroy the given guest page. If the attempt
- * fails, an attempt is made to export the page. If both attempts fail, an
- * appropriate error is returned.
- *
- * Context: must be called holding the mm lock for gmap->mm
- */
-static int __gmap_destroy_page(struct gmap *gmap, struct page *page)
-{
-	struct folio *folio = page_folio(page);
-	int rc;
-
-	/*
-	 * See gmap_make_secure(): large folios cannot be secure. Small
-	 * folio implies FW_LEVEL_PTE.
-	 */
-	if (folio_test_large(folio))
-		return -EFAULT;
-
-	rc = uv_destroy_folio(folio);
-	/*
-	 * Fault handlers can race; it is possible that two CPUs will fault
-	 * on the same secure page. One CPU can destroy the page, reboot,
-	 * re-enter secure mode and import it, while the second CPU was
-	 * stuck at the beginning of the handler. At some point the second
-	 * CPU will be able to progress, and it will not be able to destroy
-	 * the page. In that case we do not want to terminate the process,
-	 * we instead try to export the page.
-	 */
-	if (rc)
-		rc = uv_convert_from_secure_folio(folio);
-
-	return rc;
-}
-
-/**
- * gmap_destroy_page() - Destroy a guest page.
- * @gmap: the gmap of the guest
- * @gaddr: the guest address to destroy
- *
- * An attempt will be made to destroy the given guest page. If the attempt
- * fails, an attempt is made to export the page. If both attempts fail, an
- * appropriate error is returned.
- *
- * Context: may sleep.
- */
-int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr)
-{
-	struct page *page;
-	int rc = 0;
-
-	mmap_read_lock(gmap->mm);
-	page = gfn_to_page(gmap->private, gpa_to_gfn(gaddr));
-	if (page)
-		rc = __gmap_destroy_page(gmap, page);
-	kvm_release_page_clean(page);
-	mmap_read_unlock(gmap->mm);
-	return rc;
-}
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
deleted file mode 100644
index c8f031c9ea5f..000000000000
--- a/arch/s390/kvm/gmap.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- *  KVM guest address space mapping code
- *
- *    Copyright IBM Corp. 2007, 2016, 2025
- *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
- *               Claudio Imbrenda <imbrenda@linux.ibm.com>
- */
-
-#ifndef ARCH_KVM_S390_GMAP_H
-#define ARCH_KVM_S390_GMAP_H
-
-#define GMAP_SHADOW_FAKE_TABLE 1ULL
-
-int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
-int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
-struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level);
-
-/**
- * gmap_shadow_valid - check if a shadow guest address space matches the
- *                     given properties and is still valid
- * @sg: pointer to the shadow guest address space structure
- * @asce: ASCE for which the shadow table is requested
- * @edat_level: edat level to be used for the shadow translation
- *
- * Returns 1 if the gmap shadow is still valid and matches the given
- * properties, the caller can continue using it. Returns 0 otherwise, the
- * caller has to request a new shadow gmap in this case.
- *
- */
-static inline int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level)
-{
-	if (sg->removed)
-		return 0;
-	return sg->orig_asce == asce && sg->edat_level == edat_level;
-}
-
-#endif
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b4834bd4d216..c7908950c1f4 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -16,13 +16,11 @@
 #include <asm/irq.h>
 #include <asm/sysinfo.h>
 #include <asm/uv.h>
-#include <asm/gmap.h>
 
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace.h"
 #include "trace-s390.h"
-#include "gmap.h"
 
 u8 kvm_s390_get_ilen(struct kvm_vcpu *vcpu)
 {
@@ -546,7 +544,7 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
 			  guest_uvcb->header.cmd);
 		return 0;
 	}
-	rc = gmap_make_secure(vcpu->arch.gmap, uvcb.gaddr, &uvcb);
+	rc = kvm_s390_pv_make_secure(vcpu->kvm, uvcb.gaddr, &uvcb);
 	/*
 	 * If the unpin did not succeed, the guest will exit again for the UVC
 	 * and we will retry the unpin.
@@ -654,10 +652,8 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 		break;
 	case ICPT_PV_PREF:
 		rc = 0;
-		gmap_convert_to_secure(vcpu->arch.gmap,
-				       kvm_s390_get_prefix(vcpu));
-		gmap_convert_to_secure(vcpu->arch.gmap,
-				       kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
+		kvm_s390_pv_convert_to_secure(vcpu->kvm, kvm_s390_get_prefix(vcpu));
+		kvm_s390_pv_convert_to_secure(vcpu->kvm, kvm_s390_get_prefix(vcpu) + PAGE_SIZE);
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 10cfc047525d..d5ad10791c25 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -53,7 +53,6 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "pci.h"
-#include "gmap.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -4976,7 +4975,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		 * previous protected guest. The old pages need to be destroyed
 		 * so the new guest can use them.
 		 */
-		if (gmap_destroy_page(vcpu->arch.gmap, gaddr)) {
+		if (kvm_s390_pv_destroy_page(vcpu->kvm, gaddr)) {
 			/*
 			 * Either KVM messed up the secure guest mapping or the
 			 * same page is mapped into multiple secure guests.
@@ -4998,7 +4997,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 		 * guest has not been imported yet. Try to import the page into
 		 * the protected guest.
 		 */
-		rc = gmap_convert_to_secure(vcpu->arch.gmap, gaddr);
+		rc = kvm_s390_pv_convert_to_secure(vcpu->kvm, gaddr);
 		if (rc == -EINVAL)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 8d3bbb2dd8d2..c44fe0c3a097 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -308,6 +308,9 @@ int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 				u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc);
 int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
 			      u16 *rc, u16 *rrc);
+int kvm_s390_pv_destroy_page(struct kvm *kvm, unsigned long gaddr);
+int kvm_s390_pv_convert_to_secure(struct kvm *kvm, unsigned long gaddr);
+int kvm_s390_pv_make_secure(struct kvm *kvm, unsigned long gaddr, void *uvcb);
 
 static inline u64 kvm_s390_pv_get_handle(struct kvm *kvm)
 {
@@ -319,6 +322,41 @@ static inline u64 kvm_s390_pv_cpu_get_handle(struct kvm_vcpu *vcpu)
 	return vcpu->arch.pv.handle;
 }
 
+/**
+ * __kvm_s390_pv_destroy_page() - Destroy a guest page.
+ * @page: the page to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
+ *
+ * Context: must be called holding the mm lock for gmap->mm
+ */
+static inline int __kvm_s390_pv_destroy_page(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	int rc;
+
+	/* Large folios cannot be secure. Small folio implies FW_LEVEL_PTE. */
+	if (folio_test_large(folio))
+		return -EFAULT;
+
+	rc = uv_destroy_folio(folio);
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
+		rc = uv_convert_from_secure_folio(folio);
+
+	return rc;
+}
+
 /* implemented in interrupt.c */
 int kvm_s390_handle_wait(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu);
@@ -398,6 +436,10 @@ void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
 				 unsigned long end);
 void kvm_s390_vsie_init(struct kvm *kvm);
 void kvm_s390_vsie_destroy(struct kvm *kvm);
+int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level);
+
+/* implemented in gmap-vsie.c */
+struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level);
 
 /* implemented in sigp.c */
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 22c012aa5206..14c330ec8ceb 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -17,7 +17,6 @@
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
-#include "gmap.h"
 
 bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
@@ -33,6 +32,64 @@ bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pv_cpu_is_protected);
 
+/**
+ * kvm_s390_pv_make_secure() - make one guest page secure
+ * @kvm: the guest
+ * @gaddr: the guest address that needs to be made secure
+ * @uvcb: the UVCB specifying which operation needs to be performed
+ *
+ * Context: needs to be called with kvm->srcu held.
+ * Return: 0 on success, < 0 in case of error.
+ */
+int kvm_s390_pv_make_secure(struct kvm *kvm, unsigned long gaddr, void *uvcb)
+{
+	unsigned long vmaddr;
+
+	lockdep_assert_held(&kvm->srcu);
+
+	vmaddr = gfn_to_hva(kvm, gpa_to_gfn(gaddr));
+	if (kvm_is_error_hva(vmaddr))
+		return -EFAULT;
+	return make_hva_secure(kvm->mm, vmaddr, uvcb);
+}
+
+int kvm_s390_pv_convert_to_secure(struct kvm *kvm, unsigned long gaddr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = kvm_s390_pv_get_handle(kvm),
+		.gaddr = gaddr,
+	};
+
+	return kvm_s390_pv_make_secure(kvm, gaddr, &uvcb);
+}
+
+/**
+ * kvm_s390_pv_destroy_page() - Destroy a guest page.
+ * @kvm: the guest
+ * @gaddr: the guest address to destroy
+ *
+ * An attempt will be made to destroy the given guest page. If the attempt
+ * fails, an attempt is made to export the page. If both attempts fail, an
+ * appropriate error is returned.
+ *
+ * Context: may sleep.
+ */
+int kvm_s390_pv_destroy_page(struct kvm *kvm, unsigned long gaddr)
+{
+	struct page *page;
+	int rc = 0;
+
+	mmap_read_lock(kvm->mm);
+	page = gfn_to_page(kvm, gpa_to_gfn(gaddr));
+	if (page)
+		rc = __kvm_s390_pv_destroy_page(page);
+	kvm_release_page_clean(page);
+	mmap_read_unlock(kvm->mm);
+	return rc;
+}
+
 /**
  * struct pv_vm_to_be_destroyed - Represents a protected VM that needs to
  * be destroyed
@@ -638,7 +695,7 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak,
 		.tweak[0] = tweak,
 		.tweak[1] = offset,
 	};
-	int ret = gmap_make_secure(kvm->arch.gmap, addr, &uvcb);
+	int ret = kvm_s390_pv_make_secure(kvm, addr, &uvcb);
 	unsigned long vmaddr;
 	bool unlocked;
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index a78df3a4f353..13a9661d2b28 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -23,7 +23,6 @@
 #include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
-#include "gmap.h"
 
 enum vsie_page_flags {
 	VSIE_PAGE_IN_USE = 0,
@@ -68,6 +67,24 @@ struct vsie_page {
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
 
+/**
+ * gmap_shadow_valid() - check if a shadow guest address space matches the
+ *                       given properties and is still valid
+ * @sg: pointer to the shadow guest address space structure
+ * @asce: ASCE for which the shadow table is requested
+ * @edat_level: edat level to be used for the shadow translation
+ *
+ * Returns 1 if the gmap shadow is still valid and matches the given
+ * properties, the caller can continue using it. Returns 0 otherwise; the
+ * caller has to request a new shadow gmap in this case.
+ */
+int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level)
+{
+	if (sg->removed)
+		return 0;
+	return sg->orig_asce == asce && sg->edat_level == edat_level;
+}
+
 /* trigger a validity icpt for the given scb */
 static int set_validity_icpt(struct kvm_s390_sie_block *scb,
 			     __u16 reason_code)
-- 
2.49.0


