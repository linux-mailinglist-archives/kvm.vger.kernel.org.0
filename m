Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD511506D3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBCNUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbgBCNUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:02 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DG9q3106229
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:01 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya491-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:01 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DGFhl106933
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:01 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya48h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:01 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFmrg028920;
        Mon, 3 Feb 2020 13:20:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2xw0y6da45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:00 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DJw2B51511760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:19:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EB5F28077;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 604832805C;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 02/37] s390/protvirt: introduce host side setup
Date:   Mon,  3 Feb 2020 08:19:22 -0500
Message-Id: <20200203131957.383915-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
protected virtual machines hosting support code.

Add "prot_virt" command line option which controls if the kernel
protected VMs support is enabled at early boot time. This has to be
done early, because it needs large amounts of memory and will disable
some features like STP time sync for the lpar.

Extend ultravisor info definitions and expose it via uv_info struct
filled in during startup.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 ++
 arch/s390/boot/Makefile                       |  2 +-
 arch/s390/boot/uv.c                           | 20 +++++++-
 arch/s390/include/asm/uv.h                    | 46 ++++++++++++++++--
 arch/s390/kernel/Makefile                     |  1 +
 arch/s390/kernel/setup.c                      |  4 --
 arch/s390/kernel/uv.c                         | 48 +++++++++++++++++++
 arch/s390/kvm/Kconfig                         | 19 ++++++++
 8 files changed, 136 insertions(+), 9 deletions(-)
 create mode 100644 arch/s390/kernel/uv.c

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index ade4e6ec23e0..327af96f9528 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3750,6 +3750,11 @@
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
index e2c47d3a1c89..82247e71617a 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -37,7 +37,7 @@ CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
 obj-y	:= head.o als.o startup.o mem_detect.o ipl_parm.o ipl_report.o
 obj-y	+= string.o ebcdic.o sclp_early_core.o mem.o ipl_vmparm.o cmdline.o
 obj-y	+= version.o pgm_check_info.o ctype.o text_dma.o
-obj-$(CONFIG_PROTECTED_VIRTUALIZATION_GUEST)	+= uv.o
+obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST))	+= uv.o
 obj-$(CONFIG_RELOCATABLE)	+= machine_kexec_reloc.o
 obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr.o
 targets	:= bzImage startup.a section_cmp.boot.data section_cmp.boot.preserved.data $(obj-y)
diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index ed007f4a6444..88cf8825d169 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -3,7 +3,12 @@
 #include <asm/facility.h>
 #include <asm/sections.h>
 
+#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 int __bootdata_preserved(prot_virt_guest);
+#endif
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+struct uv_info __bootdata_preserved(uv_info);
+#endif
 
 void uv_query_info(void)
 {
@@ -18,7 +23,20 @@ void uv_query_info(void)
 	if (uv_call(0, (uint64_t)&uvcb))
 		return;
 
-	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&
+	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)) {
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
index 4093a2856929..32eac3ab2d3b 100644
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
+	u32 reserved68[3];
+	u32 max_num_sec_conf;
+	u64 max_guest_stor_addr;
+	u8  reserved80[150-128];
+	u16 max_guest_cpus;
+	u64 reserved98;
 } __packed __aligned(8);
 
 struct uv_cb_share {
@@ -69,9 +81,21 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
-#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
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
 extern int prot_virt_guest;
 
+#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
 static inline int is_prot_virt_guest(void)
 {
 	return prot_virt_guest;
@@ -121,11 +145,27 @@ static inline int uv_remove_shared(unsigned long addr)
 	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
 }
 
-void uv_query_info(void);
 #else
 #define is_prot_virt_guest() 0
 static inline int uv_set_shared(unsigned long addr) { return 0; }
 static inline int uv_remove_shared(unsigned long addr) { return 0; }
+#endif
+
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
+	defined(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST)
+void uv_query_info(void);
+#else
 static inline void uv_query_info(void) {}
 #endif
 
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 2b1203cf7be6..1b958a453e37 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_events.o perf_regs.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_cpum_cf_diag.o
 
 obj-$(CONFIG_TRACEPOINTS)	+= trace.o
+obj-$(findstring y, $(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) $(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST))	+= uv.o
 
 # vdso
 obj-y				+= vdso64/
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index d5fbd754f41a..f2ab2528859f 100644
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
index 000000000000..35ce89695509
--- /dev/null
+++ b/arch/s390/kernel/uv.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Common Ultravisor functions and initialization
+ *
+ * Copyright IBM Corp. 2019
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <linux/memblock.h>
+#include <asm/facility.h>
+#include <asm/sections.h>
+#include <asm/uv.h>
+
+#ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
+int __bootdata_preserved(prot_virt_guest);
+#endif
+
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
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
+		pr_info("Running as protected virtualization guest.");
+	}
+
+	if (prot_virt_host && !test_facility(158)) {
+		prot_virt_host = 0;
+		pr_info("The ultravisor call facility is not available.");
+	}
+
+	return rc;
+}
+early_param("prot_virt", prot_virt_setup);
+#endif
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index d3db3d7ed077..9ce9c7295e16 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -55,6 +55,25 @@ config KVM_S390_UCONTROL
 
 	  If unsure, say N.
 
+config KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+	bool "Protected guests execution support"
+	depends on KVM
+	help
+	Support hosting protected virtual machines in KVM. The state
+	of these machines like memory content or register content is
+	protected from the host or host administrators.
+
+	Enabling this option will enable extra code that allows a
+	Linux hypervisor to talk to a new firmware instance called
+	ultravisor that will take care of protecting the guest while
+	also enabling KVM to run this guest.
+
+	This feature must be enable via the kernel command line option
+	prot_virt.
+
+	If unsure, say Y.
+
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source "drivers/vhost/Kconfig"
-- 
2.24.0

