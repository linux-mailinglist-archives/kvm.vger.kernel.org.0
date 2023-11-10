Return-Path: <kvm+bounces-1468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 029457E7CB2
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB861281429
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D10D1DDD1;
	Fri, 10 Nov 2023 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bNfMD/Vb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A4F1C694
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:34 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C0E3821E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:32 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADek51024482;
	Fri, 10 Nov 2023 13:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=OanHKiMZlZkDg6m8yXWYZT9lvhD43fkTASwQXL9Gqhs=;
 b=bNfMD/VbV4qB+OPJmeOqJW2cczW36us82lL/J+BJJEtL8wXPXdVOQurv2XRsn3pU8Es0
 PrLKKpnsDfcFI+DN2eZJ3j08py3KbmHGIGJAe+nNuHx8TBwmWimRlytJcUZ3qFf/wI4w
 dlpJ54ZEaYj30ZHYBp2IJ2vMrQzLltGP6NOJ4u+OfvuowHE7tTV1xZI0WHyYkqQa4UOr
 mptsfiWoNFVCZYngT13xr1PiWDkEeq10l80DRCJNK5VduIx0DBhNrTa88a3LxJ/GWf1K
 +bB9T6mFJR082v5WkrLQWK6kLqPM4+Gw9D66ZVNw00GWHDuPDIF0haXhutscUN+POQL4 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkx0ber-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:29 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADs7EU007741;
	Fri, 10 Nov 2023 13:54:28 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkx0bec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:28 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAB1nEK003455;
	Fri, 10 Nov 2023 13:54:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b6q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsJjv65929478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 949CB20043;
	Fri, 10 Nov 2023 13:54:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AC292004B;
	Fri, 10 Nov 2023 13:54:16 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:16 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/26] s390x: sie: ensure guests are aligned to 2GB
Date: Fri, 10 Nov 2023 14:52:16 +0100
Message-ID: <20231110135348.245156-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: udgiM4IXW0MZNx4ElFRuromYMGIkF8bW
X-Proofpoint-ORIG-GUID: imi9zpIJ3dOIii2OdQMQenSM8k0JmpDa
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

Until now, kvm-unit-tests has aligned guests to 1 MB in the host virtual
address space. Unfortunately, some s390x environments require guests to
be 2GB aligned in the host virtual address space, preventing
kvm-unit-tests which act as a hypervisor from running there.

We can't easily put guests at address 0, since we want to be able to run
with MSO/MSL without having to maintain separate page tables for the
guest physical memory. 2GB is also not a good choice, since the
alloc_pages allocator will place its metadata there when the host has
more than 2GB of memory. In addition, we also want a bit of space after
the end of the host physical memory to be able to catch accesses beyond
the end of physical memory.

The vmalloc allocator unfortunately allocates memory starting at the
highest virtual address which is not suitable for guest memory either
due to additional constraints of some environments.

The physical page allocator in memalign_pages() is also not a optimal
choice, since every test running SIE would then require at least 4GB+1MB
of physical memory.

This results in a few quite complex allocation requirements, hence add a
new function sie_guest_alloc() which allocates memory for a guest and
then establishes a properly aligned virtual space mapping.

Rework snippet test and sie tests to use the new sie_guest_alloc()
function.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106170849.1184162-3-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sie.h     |  2 ++
 lib/s390x/snippet.h |  9 +++------
 lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 s390x/sie.c         |  4 ++--
 4 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 147cb0f..c1724cf 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -285,4 +285,6 @@ void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
 
+uint8_t *sie_guest_alloc(uint64_t guest_size);
+
 #endif /* _S390X_SIE_H_ */
diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 11ec54c..910849a 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -125,14 +125,11 @@ static inline void snippet_pv_init(struct vm *vm, const char *gbin,
 /* Allocates and sets up a snippet based guest */
 static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
 {
-	u8 *guest;
-
-	/* Allocate 1MB as guest memory */
-	guest = alloc_pages(8);
-	memset(guest, 0, HPAGE_SIZE);
+	const unsigned long guest_size = SZ_1M;
+	uint8_t *guest_start = sie_guest_alloc(guest_size);
 
 	/* Initialize the vm struct and allocate control blocks */
-	sie_guest_create(vm, (uint64_t)guest, HPAGE_SIZE);
+	sie_guest_create(vm, (uint64_t)guest_start, guest_size);
 
 	if (is_pv) {
 		/* FMT4 needs a ESCA */
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index b44febd..97a093b 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -15,6 +15,8 @@
 #include <asm/page.h>
 #include <libcflat.h>
 #include <alloc_page.h>
+#include <vmalloc.h>
+#include <sclp.h>
 
 void sie_expect_validity(struct vm *vm)
 {
@@ -111,6 +113,46 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
 	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
 }
 
+/**
+ * sie_guest_alloc() - Allocate memory for a guest and map it in virtual address
+ * space such that it is properly aligned.
+ * @guest_size: the desired size of the guest in bytes.
+ */
+uint8_t *sie_guest_alloc(uint64_t guest_size)
+{
+	static unsigned long guest_counter = 1;
+	u8 *guest_phys, *guest_virt;
+	unsigned long i;
+	pgd_t *root;
+
+	setup_vm();
+	root = (pgd_t *)(stctg(1) & PAGE_MASK);
+
+	/*
+	 * Start of guest memory in host virtual space needs to be aligned to
+	 * 2GB for some environments. It also can't be at 2GB since the memory
+	 * allocator stores its page_states metadata there.
+	 * Thus we use the next multiple of 4GB after the end of physical
+	 * mapping. This also leaves space after end of physical memory so the
+	 * page immediately after physical memory is guaranteed not to be
+	 * present.
+	 */
+	guest_virt = (uint8_t *)ALIGN(get_ram_size() + guest_counter * 4UL * SZ_1G, SZ_2G);
+	guest_counter++;
+
+	guest_phys = alloc_pages(get_order(guest_size) - 12);
+	/*
+	 * Establish a new mapping of the guest memory so it can be 2GB aligned
+	 * without actually requiring 2GB physical memory.
+	 */
+	for (i = 0; i < guest_size; i += PAGE_SIZE) {
+		install_page(root, __pa(guest_phys + i), guest_virt + i);
+	}
+	memset(guest_virt, 0, guest_size);
+
+	return guest_virt;
+}
+
 /* Frees the memory that was gathered on initialization */
 void sie_guest_destroy(struct vm *vm)
 {
diff --git a/s390x/sie.c b/s390x/sie.c
index cd3cea1..ce5b606 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -89,8 +89,8 @@ static void setup_guest(void)
 {
 	setup_vm();
 
-	/* Allocate 1MB as guest memory */
-	guest = alloc_pages(8);
+	guest = sie_guest_alloc(SZ_1M);
+
 	/* The first two pages are the lowcore */
 	guest_instr = guest + PAGE_SIZE * 2;
 
-- 
2.41.0


