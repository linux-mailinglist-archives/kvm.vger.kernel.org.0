Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7535C588
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 13:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbhDLLpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 07:45:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40952 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240502AbhDLLpn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 07:45:43 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CBXsLx034073;
        Mon, 12 Apr 2021 07:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XH41vIKQPXVPDTcuOx2GPyt+VwfndhJWpB7omC2dJ1U=;
 b=Tpxzw7+ji3uO2PJ9CijNg840tJxACKR0gLY8/6y6SrdI7Yyph2VFvrTC2OiMjp+fu0N5
 FImAnr68yYUCKsaYci/IADei1c3vt4oUCNkHV27t119Upc3Zuw0R4lNExQIuFoKdqwmH
 EBJOoh//0JX1N3SvYoC/1szzWBGNPXoLXuDwJ8XUBr37zdQF3cySMeBiGaTL4X9WTnsk
 Tn183YOCQ7zlrRmekiy7nC0xxTYja+TIswAmf9ytXt+tU3AEDqxTR3xQLhooA5ht0YDC
 IMnmzb6gm/3hKElLCvEM9uJ+zWYr9M/nsbVyVpo2qll2Ti0SZmCXe/sNhhVlOmHFkbii Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushvs0su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 07:44:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CBZgC5040506;
        Mon, 12 Apr 2021 07:44:47 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ushvs0rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 07:44:47 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CBhIGU021621;
        Mon, 12 Apr 2021 11:44:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 37u3n88wvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 11:44:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CBigIS46203250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 11:44:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29EBBAE055;
        Mon, 12 Apr 2021 11:44:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D17A7AE045;
        Mon, 12 Apr 2021 11:44:38 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.37.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 11:44:38 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, groug@kaod.org
Subject: [PATCH v5 1/3] Linux headers: update from 5.12-rc3
Date:   Mon, 12 Apr 2021 17:14:31 +0530
Message-Id: <20210412114433.129702-2-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ziR8cwdBWjqTP8omL1y21yLw309mnuAc
X-Proofpoint-ORIG-GUID: T2freNY9MB-HOqZjTI8zYcDD7C1pF7Oy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update against Linux 5.12-rc3

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
 include/standard-headers/linux/input.h        |  2 +-
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
 linux-headers/asm-generic/unistd.h            |  4 +-
 linux-headers/asm-mips/unistd_n32.h           |  1 +
 linux-headers/asm-mips/unistd_n64.h           |  1 +
 linux-headers/asm-mips/unistd_o32.h           |  1 +
 linux-headers/asm-powerpc/kvm.h               |  2 +
 linux-headers/asm-powerpc/unistd_32.h         |  1 +
 linux-headers/asm-powerpc/unistd_64.h         |  1 +
 linux-headers/asm-s390/unistd_32.h            |  1 +
 linux-headers/asm-s390/unistd_64.h            |  1 +
 linux-headers/asm-x86/kvm.h                   |  1 +
 linux-headers/asm-x86/unistd_32.h             |  1 +
 linux-headers/asm-x86/unistd_64.h             |  1 +
 linux-headers/asm-x86/unistd_x32.h            |  1 +
 linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
 linux-headers/linux/vfio.h                    | 27 ++++++
 18 files changed, 161 insertions(+), 4 deletions(-)

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index c47e19810c..a61ae520c2 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -526,6 +526,25 @@ extern "C" {
  */
 #define I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS fourcc_mod_code(INTEL, 7)
 
+/*
+ * Intel Color Control Surface with Clear Color (CCS) for Gen-12 render
+ * compression.
+ *
+ * The main surface is Y-tiled and is at plane index 0 whereas CCS is linear
+ * and at index 1. The clear color is stored at index 2, and the pitch should
+ * be ignored. The clear color structure is 256 bits. The first 128 bits
+ * represents Raw Clear Color Red, Green, Blue and Alpha color each represented
+ * by 32 bits. The raw clear color is consumed by the 3d engine and generates
+ * the converted clear color of size 64 bits. The first 32 bits store the Lower
+ * Converted Clear Color value and the next 32 bits store the Higher Converted
+ * Clear Color value when applicable. The Converted Clear Color values are
+ * consumed by the DE. The last 64 bits are used to store Color Discard Enable
+ * and Depth Clear Value Valid which are ignored by the DE. A CCS cache line
+ * corresponds to an area of 4x1 tiles in the main surface. The main surface
+ * pitch is required to be a multiple of 4 tile widths.
+ */
+#define I915_FORMAT_MOD_Y_TILED_GEN12_RC_CCS_CC fourcc_mod_code(INTEL, 8)
+
 /*
  * Tiled, NV12MT, grouped in 64 (pixels) x 32 (lines) -sized macroblocks
  *
@@ -1035,9 +1054,9 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  * Not all combinations are valid, and different SoCs may support different
  * combinations of layout and options.
  */
-#define __fourcc_mod_amlogic_layout_mask 0xf
+#define __fourcc_mod_amlogic_layout_mask 0xff
 #define __fourcc_mod_amlogic_options_shift 8
-#define __fourcc_mod_amlogic_options_mask 0xf
+#define __fourcc_mod_amlogic_options_mask 0xff
 
 #define DRM_FORMAT_MOD_AMLOGIC_FBC(__layout, __options) \
 	fourcc_mod_code(AMLOGIC, \
diff --git a/include/standard-headers/linux/input.h b/include/standard-headers/linux/input.h
index f89c986190..7822c24178 100644
--- a/include/standard-headers/linux/input.h
+++ b/include/standard-headers/linux/input.h
@@ -81,7 +81,7 @@ struct input_id {
  * in units per radian.
  * When INPUT_PROP_ACCELEROMETER is set the resolution changes.
  * The main axes (ABS_X, ABS_Y, ABS_Z) are then reported in
- * in units per g (units/g) and in units per degree per second
+ * units per g (units/g) and in units per degree per second
  * (units/deg/s) for rotational axes (ABS_RX, ABS_RY, ABS_RZ).
  */
 struct input_absinfo {
diff --git a/include/standard-headers/rdma/vmw_pvrdma-abi.h b/include/standard-headers/rdma/vmw_pvrdma-abi.h
index 0989426a3f..c30182a7ae 100644
--- a/include/standard-headers/rdma/vmw_pvrdma-abi.h
+++ b/include/standard-headers/rdma/vmw_pvrdma-abi.h
@@ -133,6 +133,13 @@ enum pvrdma_wc_flags {
 	PVRDMA_WC_FLAGS_MAX		= PVRDMA_WC_WITH_NETWORK_HDR_TYPE,
 };
 
+enum pvrdma_network_type {
+	PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_ROCE_V1 = PVRDMA_NETWORK_IB,
+	PVRDMA_NETWORK_IPV4,
+	PVRDMA_NETWORK_IPV6
+};
+
 struct pvrdma_alloc_ucontext_resp {
 	uint32_t qp_tab_size;
 	uint32_t reserved;
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 7287529177..ce58cff99b 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -861,9 +861,11 @@ __SYSCALL(__NR_faccessat2, sys_faccessat2)
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 #define __NR_epoll_pwait2 441
 __SC_COMP(__NR_epoll_pwait2, sys_epoll_pwait2, compat_sys_epoll_pwait2)
+#define __NR_mount_setattr 442
+__SYSCALL(__NR_mount_setattr, sys_mount_setattr)
 
 #undef __NR_syscalls
-#define __NR_syscalls 442
+#define __NR_syscalls 443
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 59e53b6e07..2ca45a0122 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -371,6 +371,7 @@
 #define __NR_faccessat2	(__NR_Linux + 439)
 #define __NR_process_madvise	(__NR_Linux + 440)
 #define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_mount_setattr	(__NR_Linux + 442)
 
 
 #endif /* _ASM_MIPS_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 683558a7f8..c8df45e69c 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -347,6 +347,7 @@
 #define __NR_faccessat2	(__NR_Linux + 439)
 #define __NR_process_madvise	(__NR_Linux + 440)
 #define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_mount_setattr	(__NR_Linux + 442)
 
 
 #endif /* _ASM_MIPS_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index ca6a7e5c0b..10ba4cf9f5 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -417,6 +417,7 @@
 #define __NR_faccessat2	(__NR_Linux + 439)
 #define __NR_process_madvise	(__NR_Linux + 440)
 #define __NR_epoll_pwait2	(__NR_Linux + 441)
+#define __NR_mount_setattr	(__NR_Linux + 442)
 
 
 #endif /* _ASM_MIPS_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index c3af3f324c..9f18fa090f 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -644,6 +644,8 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
 #define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
+#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 4624c90043..1d63e42fc4 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -424,6 +424,7 @@
 #define __NR_faccessat2	439
 #define __NR_process_madvise	440
 #define __NR_epoll_pwait2	441
+#define __NR_mount_setattr	442
 
 
 #endif /* _ASM_POWERPC_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 7e851b30bb..6a8708c0c5 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -396,6 +396,7 @@
 #define __NR_faccessat2	439
 #define __NR_process_madvise	440
 #define __NR_epoll_pwait2	441
+#define __NR_mount_setattr	442
 
 
 #endif /* _ASM_POWERPC_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index c94d2c3a22..e5efe406e3 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -414,5 +414,6 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 984a06b7eb..f0392fc6c7 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -362,5 +362,6 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8e76d3701d..5a3022c8af 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -112,6 +112,7 @@ struct kvm_ioapic_state {
 #define KVM_NR_IRQCHIPS          3
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
+#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 18fb99dfa2..1374427c66 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -432,6 +432,7 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
 
 
 #endif /* _ASM_X86_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index bde959328d..e9d0707bc3 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -354,6 +354,7 @@
 #define __NR_faccessat2 439
 #define __NR_process_madvise 440
 #define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
 
 
 #endif /* _ASM_X86_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 4ff6b17d3b..107aee76f2 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -307,6 +307,7 @@
 #define __NR_faccessat2 (__X32_SYSCALL_BIT + 439)
 #define __NR_process_madvise (__X32_SYSCALL_BIT + 440)
 #define __NR_epoll_pwait2 (__X32_SYSCALL_BIT + 441)
+#define __NR_mount_setattr (__X32_SYSCALL_BIT + 442)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 020b62a619..238c6c5847 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -216,6 +216,20 @@ struct kvm_hyperv_exit {
 	} u;
 };
 
+struct kvm_xen_exit {
+#define KVM_EXIT_XEN_HCALL          1
+	__u32 type;
+	union {
+		struct {
+			__u32 longmode;
+			__u32 cpl;
+			__u64 input;
+			__u64 result;
+			__u64 params[6];
+		} hcall;
+	} u;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -251,6 +265,9 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
 #define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
+#define KVM_EXIT_X86_BUS_LOCK     33
+#define KVM_EXIT_XEN              34
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -427,6 +444,8 @@ struct kvm_run {
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
 		} msr;
+		/* KVM_EXIT_XEN */
+		struct kvm_xen_exit xen;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -573,6 +592,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -1056,6 +1076,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_PPC_DAWR1 194
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1129,6 +1151,11 @@ struct kvm_x86_mce {
 #endif
 
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -1563,6 +1590,57 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_DIRTY_LOG_RING */
 #define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
 
+/* Per-VM Xen attributes */
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		__u64 pad[8];
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+
+/* Per-vCPU Xen attributes */
+#define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
+#define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1591,6 +1669,8 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1643,6 +1723,12 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
@@ -1764,4 +1850,7 @@ struct kvm_dirty_gfn {
 	__u64 offset;
 };
 
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 609099e455..e38a488403 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -46,6 +46,12 @@
  */
 #define VFIO_NOIOMMU_IOMMU		8
 
+/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
+#define VFIO_UNMAP_ALL			9
+
+/* Supports the vaddr flag for DMA map and unmap */
+#define VFIO_UPDATE_VADDR		10
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1074,12 +1080,22 @@ struct vfio_iommu_type1_info_dma_avail {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
+ * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
+ * maintain memory consistency within the user application, the updated vaddr
+ * must address the same memory object as originally mapped.  Failure to do so
+ * will result in user memory corruption and/or device misbehavior.  iova and
+ * size must match those in the original MAP_DMA call.  Protection is not
+ * changed, and the READ & WRITE flags must be 0.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -1102,6 +1118,7 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ *
  * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
  * before unmapping IO virtual addresses. When this flag is set, the user must
  * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
@@ -1111,11 +1128,21 @@ struct vfio_bitmap {
  * indicates that the page at that offset from iova is dirty. A Bitmap of the
  * pages in the range of unmapped size is returned in the user-provided
  * vfio_bitmap.data.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
+ * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
+ * virtual addresses in the iova range.  Tasks that attempt to translate an
+ * iova's vaddr will block.  DMA to already-mapped pages continues.  This
+ * cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
+#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
2.17.1

