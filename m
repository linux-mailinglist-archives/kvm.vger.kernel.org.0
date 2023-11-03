Return-Path: <kvm+bounces-463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 763ED7DFF3A
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 07:41:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6761F1C20909
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 06:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0991679D1;
	Fri,  3 Nov 2023 06:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JXWPtNe3"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1028917CA
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 06:41:40 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA24CA;
	Thu,  2 Nov 2023 23:41:38 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A36ek84019934;
	Fri, 3 Nov 2023 06:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XTggoVLwdL6KTjQ0ZrB9ljS56YDf3mMltfkTpGRShd0=;
 b=JXWPtNe3z54psMdOGduzSIbOZr+aFNVwznmnN8A4bNdkMn6OtHcljeYdQZBdTb+XO6jk
 JmUgiWyKEtTM6PJc57R0Cy000GoWqDDt9gso+6QzuD2XJlp3S446CtGqCTT9+tM34xOq
 BYThlBFMYo/CzJaJ3uA3VOEqoZY4C3n+NGiVWTkcfTv4A40JmncO2n5fnoADmbd5Q+hc
 rf9tp126ofpEpAXPIwPIPdVavTVFTB0oa20GHqFmTFkNHYalf6VMcxxd2m+6+PK+jFkw
 lG+5cTCTl2P4oseiclBvScH6L23GsLLcnCwQMj0OTu6E0yMt+n5Gw4Bwj6n5OBOW70T+ 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4uam0s84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:38 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A36eu03021554;
	Fri, 3 Nov 2023 06:41:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4uam0s7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:37 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A33x67j000583;
	Fri, 3 Nov 2023 06:41:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmtmf2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:41:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A36fY5P19333740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 06:41:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE4F02005A;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B95862004E;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 06:41:33 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 2/2] s390x: sie: ensure guests are aligned to 2GB
Date: Fri,  3 Nov 2023 07:35:47 +0100
Message-ID: <20231103064132.11358-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103064132.11358-1-nrb@linux.ibm.com>
References: <20231103064132.11358-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R-lhPlEKTodqQnwdfBGNGIxhlMP-v1r7
X-Proofpoint-ORIG-GUID: X6G9fXNbIKquDtbAiog6nWiAhWSchW1d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_06,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311030053

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

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h     |  2 ++
 lib/s390x/snippet.h |  9 +++------
 s390x/sie.c         |  4 ++--
 4 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index b44febdeaaac..bd907a0ffefa 100644
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
 
+/*
+ * Allocate memory for a guest and map it in virtual address space such that
+ * it is properly aligned.
+ * @guest_size the desired size of the guest in bytes.
+ */
+uint8_t *sie_guest_alloc(uint64_t guest_size)
+{
+	pgd_t *root;
+	u8 *guest_phys, *guest_virt;
+	static unsigned long guest_counter = 1;
+	unsigned long i;
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
+	for (i = 0; i <= guest_size; i += PAGE_SIZE) {
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
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 147cb0f2a556..c1724cf2f67e 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -285,4 +285,6 @@ void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
 
+uint8_t *sie_guest_alloc(uint64_t guest_size);
+
 #endif /* _S390X_SIE_H_ */
diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 11ec54c379e9..910849aa186c 100644
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
diff --git a/s390x/sie.c b/s390x/sie.c
index cd3cea10d100..ce5b6069bf0b 100644
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


