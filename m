Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D4E4239A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436590AbfFLLNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:13:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732323AbfFLLNI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 07:13:08 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CB8BBS118214
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:07 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2xpxcpwm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:07 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 12:13:05 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 12:13:02 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CBD0Ck45482176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 11:13:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE33742052;
        Wed, 12 Jun 2019 11:13:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E16B4204D;
        Wed, 12 Jun 2019 11:13:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 11:13:00 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: [PATCH v5 1/8] s390/mm: force swiotlb for protected virtualization
Date:   Wed, 12 Jun 2019 13:12:29 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612111236.99538-1-pasic@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061211-0016-0000-0000-0000028868EE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061211-0017-0000-0000-000032E59E05
Message-Id: <20190612111236.99538-2-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On s390, protected virtualization guests have to use bounced I/O
buffers.  That requires some plumbing.

Let us make sure, any device that uses DMA API with direct ops correctly
is spared from the problems, that a hypervisor attempting I/O to a
non-shared page would bring.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/Kconfig                   |  4 +++
 arch/s390/include/asm/mem_encrypt.h | 18 +++++++++++
 arch/s390/mm/init.c                 | 47 +++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 arch/s390/include/asm/mem_encrypt.h

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 109243fdb6ec..88d8355b7bf7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+config ARCH_HAS_MEM_ENCRYPT
+        def_bool y
+
 config MMU
 	def_bool y
 
@@ -187,6 +190,7 @@ config S390
 	select VIRT_CPU_ACCOUNTING
 	select ARCH_HAS_SCALED_CPUTIME
 	select HAVE_NMI
+	select SWIOTLB
 
 
 config SCHED_OMIT_FRAME_POINTER
diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
new file mode 100644
index 000000000000..0898c09a888c
--- /dev/null
+++ b/arch/s390/include/asm/mem_encrypt.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef S390_MEM_ENCRYPT_H__
+#define S390_MEM_ENCRYPT_H__
+
+#ifndef __ASSEMBLY__
+
+#define sme_me_mask	0ULL
+
+static inline bool sme_active(void) { return false; }
+extern bool sev_active(void);
+
+int set_memory_encrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages);
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* S390_MEM_ENCRYPT_H__ */
+
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 14d1eae9fe43..f0bee6af3960 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -18,6 +18,7 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
+#include <linux/swiotlb.h>
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -29,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/cma.h>
 #include <linux/gfp.h>
+#include <linux/dma-mapping.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -42,6 +44,8 @@
 #include <asm/sclp.h>
 #include <asm/set_memory.h>
 #include <asm/kasan.h>
+#include <asm/dma-mapping.h>
+#include <asm/uv.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
 
@@ -128,6 +132,47 @@ void mark_rodata_ro(void)
 	pr_info("Write protected read-only-after-init data: %luk\n", size >> 10);
 }
 
+int set_memory_encrypted(unsigned long addr, int numpages)
+{
+	int i;
+
+	/* make specified pages unshared, (swiotlb, dma_free) */
+	for (i = 0; i < numpages; ++i) {
+		uv_remove_shared(addr);
+		addr += PAGE_SIZE;
+	}
+	return 0;
+}
+
+int set_memory_decrypted(unsigned long addr, int numpages)
+{
+	int i;
+	/* make specified pages shared (swiotlb, dma_alloca) */
+	for (i = 0; i < numpages; ++i) {
+		uv_set_shared(addr);
+		addr += PAGE_SIZE;
+	}
+	return 0;
+}
+
+/* are we a protected virtualization guest? */
+bool sev_active(void)
+{
+	return is_prot_virt_guest();
+}
+
+/* protected virtualization */
+static void pv_init(void)
+{
+	if (!is_prot_virt_guest())
+		return;
+
+	/* make sure bounce buffers are shared */
+	swiotlb_init(1);
+	swiotlb_update_mem_attributes();
+	swiotlb_force = SWIOTLB_FORCE;
+}
+
 void __init mem_init(void)
 {
 	cpumask_set_cpu(0, &init_mm.context.cpu_attach_mask);
@@ -136,6 +181,8 @@ void __init mem_init(void)
 	set_max_mapnr(max_low_pfn);
         high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 
+	pv_init();
+
 	/* Setup guest page hinting */
 	cmma_init();
 
-- 
2.17.1

