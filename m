Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03D315F966
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 23:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBNW1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 17:27:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727723AbgBNW1L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 17:27:11 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EMPTrQ086191;
        Fri, 14 Feb 2020 17:27:10 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyunbfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:10 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01EMRAWt090985;
        Fri, 14 Feb 2020 17:27:10 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y4qyunbff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:27:10 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01EMP6EF017594;
        Fri, 14 Feb 2020 22:27:09 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 2y5bc0cd6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 22:27:09 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01EMR5Zs35914040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Feb 2020 22:27:05 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1682C136091;
        Fri, 14 Feb 2020 22:27:05 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A681136093;
        Fri, 14 Feb 2020 22:27:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Feb 2020 22:27:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2 03/42] s390/protvirt: introduce host side setup
Date:   Fri, 14 Feb 2020 17:26:19 -0500
Message-Id: <20200214222658.12946-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200214222658.12946-1-borntraeger@de.ibm.com>
References: <20200214222658.12946-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_08:2020-02-14,2020-02-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002140165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Add "prot_virt" command line option which controls if the kernel
protected VMs support is enabled at early boot time. This has to be
done early, because it needs large amounts of memory and will disable
some features like STP time sync for the lpar.

Extend ultravisor info definitions and expose it via uv_info struct
filled in during startup.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++
 arch/s390/boot/Makefile                       |  2 +-
 arch/s390/boot/uv.c                           | 21 +++++++-
 arch/s390/include/asm/uv.h                    | 45 +++++++++++++++-
 arch/s390/kernel/Makefile                     |  1 +
 arch/s390/kernel/setup.c                      |  4 --
 arch/s390/kernel/uv.c                         | 52 +++++++++++++++++++
 7 files changed, 122 insertions(+), 8 deletions(-)
 create mode 100644 arch/s390/kernel/uv.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dbc22d684627..b0beae9b9e36 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3795,6 +3795,11 @@
 			before loading.
 			See Documentation/admin-guide/blockdev/ramdisk.rst.
 
+	prot_virt=	[S390] enable hosting protected virtual machines
+			isolated from the hypervisor (if hardware supports
+			that).
+			Format: <bool>
+
 	psi=		[KNL] Enable or disable pressure stall information
 			tracking.
 			Format: <bool>
diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index e2c47d3a1c89..30f1811540c5 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
 obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
 obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
-obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
+obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
 obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
 obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
 targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index ed007f4a6444..af9e1cc93c68 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -3,7 +3,13 @@
 #include <asm/facility.h>
 #include <asm/sections.h>
 
+/* will be used in arch/s390/kernel/uv.c */
+#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 int __bootdata_preserved(prot_virt_guest);
+#endif
+#if IS_ENABLED(CONFIG_KVM)
+struct uv_info __bootdata_preserved(uv_info);
+#endif
 
 void uv_query_info(void)
 {
@@ -18,7 +24,20 @@ void uv_query_info(void)
 	if (uv_call(0, (uint64_t)&uvcb))
 		return;
 
-	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
+	if (IS_ENABLED(CONFIG_KVM)) {
+		memcpy(uv_info.inst_calls_list, uvcb.inst_calls_list, sizeof(uv_info.inst_calls_list));
+		uv_info.uv_base_stor_len = uvcb.uv_base_stor_len;
+		uv_info.guest_base_stor_len = uvcb.conf_base_phys_stor_len;
+		uv_info.guest_virt_base_stor_len = uvcb.conf_base_virt_stor_len;
+		uv_info.guest_virt_var_stor_len = uvcb.conf_virt_var_stor_len;
+		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
+		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
+		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
+		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
+	}
+
+	if (IS_ENABLED(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) &&
+	    test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
 	    test_bit_inv(BIT_UVC_CMD_REMOVE_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list))
 		prot_virt_guest = 1;
 }
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 4093a2856929..34b1114dcc38 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -44,7 +44,19 @@ struct uv_cb_qui {
 	struct uv_cb_header header;
 	u64 reserved08;
 	u64 inst_calls_list[4];
-	u64 reserved30[15];
+	u64 reserved30[2];
+	u64 uv_base_stor_len;
+	u64 reserved48;
+	u64 conf_base_phys_stor_len;
+	u64 conf_base_virt_stor_len;
+	u64 conf_virt_var_stor_len;
+	u64 cpu_stor_len;
+	u32 reserved70[3];
+	u32 max_num_sec_conf;
+	u64 max_guest_stor_addr;
+	u8  reserved88[158-136];
+	u16 max_guest_cpus;
+	u64 reserveda0;
 } __packed __aligned(8);
 
 struct uv_cb_share {
@@ -69,6 +81,19 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
+struct uv_info {
+	unsigned long inst_calls_list[4];
+	unsigned long uv_base_stor_len;
+	unsigned long guest_base_stor_len;
+	unsigned long guest_virt_base_stor_len;
+	unsigned long guest_virt_var_stor_len;
+	unsigned long guest_cpu_stor_len;
+	unsigned long max_sec_stor_addr;
+	unsigned int max_num_sec_conf;
+	unsigned short max_guest_cpus;
+};
+extern struct uv_info uv_info;
+
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 extern int prot_virt_guest;
 
@@ -121,11 +146,27 @@ static inline int uv_remove_shared(unsigned long addr)
 	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
 }
 
-void uv_query_info(void);
 #else
 #define is_prot_virt_guest() 0
 static inline int uv_set_shared(unsigned long addr) { return 0; }
 static inline int uv_remove_shared(unsigned long addr) { return 0; }
+#endif
+
+#if IS_ENABLED(CONFIG_KVM)
+extern int prot_virt_host;
+
+static inline int is_prot_virt_host(void)
+{
+	return prot_virt_host;
+}
+#else
+#define is_prot_virt_host() 0
+#endif
+
+#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
+	IS_ENABLED(CONFIG_KVM)
+void uv_query_info(void);
+#else
 static inline void uv_query_info(void) {}
 #endif
 
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 2b1203cf7be6..22bfb8d5084e 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_events.o perf_regs.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_diag.o
 
 obj-$(CONFIG_TRACEPOINTS)	+= trace.o
+obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_PGSTE))	+= uv.o
 
 # vdso
 obj-y				+= vdso64/
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index b2c2f75860e8..a2496382175e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -92,10 +92,6 @@ char elf_platform[ELF_PLATFORM_SIZE];
 
 unsigned long int_hwcap = 0;
 
-#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
-int __bootdata_preserved(prot_virt_guest);
-#endif
-
 int __bootdata(noexec_disabled);
 int __bootdata(memory_end_set);
 unsigned long __bootdata(memory_end);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
new file mode 100644
index 000000000000..b1f936710360
--- /dev/null
+++ b/arch/s390/kernel/uv.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Ultravisor functions and initialization
+ *
+ * Copyright IBM Corp. 2019, 2020
+ */
+#define KMSG_COMPONENT "prot_virt"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <linux/memblock.h>
+#include <asm/facility.h>
+#include <asm/sections.h>
+#include <asm/uv.h>
+
+/* the bootdata_preserved fields come from ones in arch/s390/boot/uv.c */
+#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
+int __bootdata_preserved(prot_virt_guest);
+#endif
+
+#if IS_ENABLED(CONFIG_KVM)
+int prot_virt_host;
+EXPORT_SYMBOL(prot_virt_host);
+struct uv_info __bootdata_preserved(uv_info);
+EXPORT_SYMBOL(uv_info);
+
+static int __init prot_virt_setup(char *val)
+{
+	bool enabled;
+	int rc;
+
+	rc = kstrtobool(val, &enabled);
+	if (!rc && enabled)
+		prot_virt_host = 1;
+
+	if (is_prot_virt_guest() && prot_virt_host) {
+		prot_virt_host = 0;
+		pr_warn("Protected virtualization not available in protected guests.");
+	}
+
+	if (prot_virt_host && !test_facility(158)) {
+		prot_virt_host = 0;
+		pr_warn("Protected virtualization not supported by the hardware.");
+	}
+
+	return rc;
+}
+early_param("prot_virt", prot_virt_setup);
+#endif
-- 
2.25.0

