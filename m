Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9C26CA468
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjC0MqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjC0MqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:46:05 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDA9448E
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so8659660pjl.4
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MggKjz1jGSX2ljFurbDWc1emKG96JVyKWj1HMRupWA8=;
        b=Qp0HwLCoc8aRPVm5JCoidf6vwo34/69ZZrQgfednrqoA5NEOpNIe0P4ZOkQpSI22f1
         dfx4r5mcogbShwW4rfd0UIY6zgdf+lDQ8UsaRiLNVaVifr3EAMtfpWMwzyBbV7DM85en
         832zJfvNQuQylk96QlURMB775tf/ANeH1TJaYlVRWuQagWYmiiGpjXsDNOcp0Yqbd9C4
         aVBrVY3ArXomU7csTdtwa8oH7oXFz8ihz6xf8mfjv+loB+3Qqjqg3Kh+DxkioBuYt/XB
         /x8gy5xDL8mOV7dwxReBX8wxXN/c5opsipvZpzI47/VLVsSF9tyMHB8mbqfDBK+1gFu1
         IBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MggKjz1jGSX2ljFurbDWc1emKG96JVyKWj1HMRupWA8=;
        b=KhQl3uGq+iii3vDI8m0iILbSbWjvTxzsZhHs23g4oGOQfbbpgHT8vwYPh6mHY2mZLz
         U//Bo+QxqDsoQe5sRAKlIm4YQCwCYtHtktCz5eV7OF5ajAVxx8H6GtIFlkD6YDdesE/a
         UxHHWkVDDn/npLFjiWGO2sYokuifvM2S9BSCN2DhvCOHkHTGTqqJjg3FXctXud5Wp63A
         542lfe3RY/wz3TKfKJQ8oA9FnakrJRgwf7QLS6oAnobHzCnngQfV/Abr5M4jSQtOy2T5
         XiCwc0GRiDf4hSUBH3FDpofK/EovNFw/3Fhx2Y1xnM01BaridKAG4HiSe81kr/FIMzxv
         YFhg==
X-Gm-Message-State: AAQBX9fwkS2LMOMTGq2gyZ0PRal2YvYv/rVWhUCVVXP4omp5GAdp9j5Q
        P0ELhVxi0lBl8nRsGSXSCokFSJw7CKA=
X-Google-Smtp-Source: AKy350ayOQoR6MU8pGJ5dGKEBcJvuWNXBQs7N55HlQ7iJ/Dnw5trOJHzGUKtq7iL12s1qF6VbNqxaw==
X-Received: by 2002:a17:902:fb44:b0:19f:27fd:7cb5 with SMTP id lf4-20020a170902fb4400b0019f27fd7cb5mr9835542plb.10.1679921158488;
        Mon, 27 Mar 2023 05:45:58 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 08/13] powerpc/spapr_vpa: Add basic VPA tests
Date:   Mon, 27 Mar 2023 22:45:15 +1000
Message-Id: <20230327124520.2707537-9-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VPA is an optional memory structure shared between the hypervisor
and operating system, defined by PAPR. This test defines the structure
and adds registration, deregistration, and a few simple sanity tests.

[Thanks to Thomas Huth for suggesting many of the test cases.]
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- Added to unittests.cfg [Thomas review]
- Removed __always_inline header hunk [Thomas review]
- Updated comments [Thomas review]
- Better coverage of VPA registration error cases [Thomas review]
- Fix unbalanced prefix push [Thomas review]
- Don't print VPA contents unless -v option is given.
- Split VPA hcall register/unregister tests from testing of elements
  of the VPA when it has been registered into different functions and
  prefixes.

 lib/powerpc/asm/hcall.h |   1 +
 lib/ppc64/asm/vpa.h     |  62 +++++++++++++++
 powerpc/Makefile.ppc64  |   2 +-
 powerpc/spapr_vpa.c     | 172 ++++++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg   |   3 +
 5 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 lib/ppc64/asm/vpa.h
 create mode 100644 powerpc/spapr_vpa.c

diff --git a/lib/powerpc/asm/hcall.h b/lib/powerpc/asm/hcall.h
index 1173fea..e0f5009 100644
--- a/lib/powerpc/asm/hcall.h
+++ b/lib/powerpc/asm/hcall.h
@@ -18,6 +18,7 @@
 #define H_SET_SPRG0		0x24
 #define H_SET_DABR		0x28
 #define H_PAGE_INIT		0x2c
+#define H_REGISTER_VPA		0xDC
 #define H_CEDE			0xE0
 #define H_GET_TERM_CHAR		0x54
 #define H_PUT_TERM_CHAR		0x58
diff --git a/lib/ppc64/asm/vpa.h b/lib/ppc64/asm/vpa.h
new file mode 100644
index 0000000..11dde01
--- /dev/null
+++ b/lib/ppc64/asm/vpa.h
@@ -0,0 +1,62 @@
+#ifndef _ASMPOWERPC_VPA_H_
+#define _ASMPOWERPC_VPA_H_
+/*
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+
+#ifndef __ASSEMBLY__
+
+struct vpa {
+	uint32_t	descriptor;
+	uint16_t	size;
+	uint8_t		reserved1[3];
+	uint8_t		status;
+	uint8_t		reserved2[14];
+	uint32_t	fru_node_id;
+	uint32_t	fru_proc_id;
+	uint8_t		reserved3[56];
+	uint8_t		vhpn_change_counters[8];
+	uint8_t		reserved4[80];
+	uint8_t		cede_latency;
+	uint8_t		maintain_ebb;
+	uint8_t		reserved5[6];
+	uint8_t		dtl_enable_mask;
+	uint8_t		dedicated_cpu_donate;
+	uint8_t		maintain_fpr;
+	uint8_t		maintain_pmc;
+	uint8_t		reserved6[28];
+	uint64_t	idle_estimate_purr;
+	uint8_t		reserved7[28];
+	uint16_t	maintain_nr_slb;
+	uint8_t		idle;
+	uint8_t		maintain_vmx;
+	uint32_t	vp_dispatch_count;
+	uint32_t	vp_dispatch_dispersion;
+	uint64_t	vp_fault_count;
+	uint64_t	vp_fault_tb;
+	uint64_t	purr_exprop_idle;
+	uint64_t	spurr_exprop_idle;
+	uint64_t	purr_exprop_busy;
+	uint64_t	spurr_exprop_busy;
+	uint64_t	purr_donate_idle;
+	uint64_t	spurr_donate_idle;
+	uint64_t	purr_donate_busy;
+	uint64_t	spurr_donate_busy;
+	uint64_t	vp_wait3_tb;
+	uint64_t	vp_wait2_tb;
+	uint64_t	vp_wait1_tb;
+	uint64_t	purr_exprop_adjunct_busy;
+	uint64_t	spurr_exprop_adjunct_busy;
+	uint32_t	supervisor_pagein_count;
+	uint8_t		reserved8[4];
+	uint64_t	purr_exprop_adjunct_idle;
+	uint64_t	spurr_exprop_adjunct_idle;
+	uint64_t	adjunct_insns_executed;
+	uint8_t		reserved9[120];
+	uint64_t	dtl_index;
+	uint8_t		reserved10[96];
+};
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASMPOWERPC_VPA_H_ */
diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
index ea68447..b0ed2b1 100644
--- a/powerpc/Makefile.ppc64
+++ b/powerpc/Makefile.ppc64
@@ -19,7 +19,7 @@ reloc.o  = $(TEST_DIR)/reloc64.o
 OBJDIRS += lib/ppc64
 
 # ppc64 specific tests
-tests =
+tests = $(TEST_DIR)/spapr_vpa.elf
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
new file mode 100644
index 0000000..5586eb8
--- /dev/null
+++ b/powerpc/spapr_vpa.c
@@ -0,0 +1,172 @@
+/*
+ * Test sPAPR "Per Virtual Processor Area" and H_REGISTER_VPA hypervisor call
+ * (also known as VPA, also known as lppaca in the Linux pseries kernel).
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libcflat.h>
+#include <libfdt/libfdt.h>
+#include <devicetree.h>
+#include <util.h>
+#include <alloc.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/hcall.h>
+#include <asm/vpa.h>
+#include <asm/io.h> /* for endian accessors */
+
+static int verbose;
+
+static void print_vpa(struct vpa *vpa)
+{
+	printf("VPA\n");
+	printf("descriptor:			0x%08x\n", be32_to_cpu(vpa->descriptor));
+	printf("size:				    0x%04x\n", be16_to_cpu(vpa->size));
+	printf("status:				      0x%02x\n", vpa->status);
+	printf("fru_node_id:			0x%08x\n", be32_to_cpu(vpa->fru_node_id));
+	printf("fru_proc_id:			0x%08x\n", be32_to_cpu(vpa->fru_proc_id));
+	printf("vhpn_change_counters:		0x%02x %02x %02x %02x %02x %02x %02x %02x\n", vpa->vhpn_change_counters[0], vpa->vhpn_change_counters[1], vpa->vhpn_change_counters[2], vpa->vhpn_change_counters[3], vpa->vhpn_change_counters[4], vpa->vhpn_change_counters[5], vpa->vhpn_change_counters[6], vpa->vhpn_change_counters[7]);
+	printf("vp_dispatch_count:		0x%08x\n", be32_to_cpu(vpa->vp_dispatch_count));
+	printf("vp_dispatch_dispersion:		0x%08x\n", be32_to_cpu(vpa->vp_dispatch_dispersion));
+	printf("vp_fault_count:			0x%08lx\n", be64_to_cpu(vpa->vp_fault_count));
+	printf("vp_fault_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_fault_tb));
+	printf("purr_exprop_idle:		0x%08lx\n", be64_to_cpu(vpa->purr_exprop_idle));
+	printf("spurr_exprop_idle:		0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_idle));
+	printf("purr_exprop_busy:		0x%08lx\n", be64_to_cpu(vpa->purr_exprop_busy));
+	printf("spurr_exprop_busy:		0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_busy));
+	printf("purr_donate_idle:		0x%08lx\n", be64_to_cpu(vpa->purr_donate_idle));
+	printf("spurr_donate_idle:		0x%08lx\n", be64_to_cpu(vpa->spurr_donate_idle));
+	printf("purr_donate_busy:		0x%08lx\n", be64_to_cpu(vpa->purr_donate_busy));
+	printf("spurr_donate_busy:		0x%08lx\n", be64_to_cpu(vpa->spurr_donate_busy));
+	printf("vp_wait3_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait3_tb));
+	printf("vp_wait2_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait2_tb));
+	printf("vp_wait1_tb:			0x%08lx\n", be64_to_cpu(vpa->vp_wait1_tb));
+	printf("purr_exprop_adjunct_busy:	0x%08lx\n", be64_to_cpu(vpa->purr_exprop_adjunct_busy));
+	printf("spurr_exprop_adjunct_busy:	0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_adjunct_busy));
+	printf("purr_exprop_adjunct_idle:	0x%08lx\n", be64_to_cpu(vpa->purr_exprop_adjunct_idle));
+	printf("spurr_exprop_adjunct_idle:	0x%08lx\n", be64_to_cpu(vpa->spurr_exprop_adjunct_idle));
+	printf("adjunct_insns_executed:		0x%08lx\n", be64_to_cpu(vpa->adjunct_insns_executed));
+	printf("dtl_index:			0x%08lx\n", be64_to_cpu(vpa->dtl_index));
+}
+
+#define SUBFUNC_RESERVED	(0ULL << 45)
+#define SUBFUNC_REGISTER	(1ULL << 45)
+#define SUBFUNC_DEREGISTER	(5ULL << 45)
+
+/**
+ * Test the H_REGISTER_VPA h-call register/deregister calls.
+ */
+static void test_register_vpa(void)
+{
+	struct vpa *vpa;
+	uint32_t cpuid = fdt_boot_cpuid_phys(dt_fdt());
+	int rc;
+
+	report_prefix_push("H_REGISTER_VPA");
+
+	vpa = memalign(4096, sizeof(*vpa));
+
+	memset(vpa, 0, sizeof(*vpa));
+
+	vpa->size = cpu_to_be16(sizeof(*vpa));
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_RESERVED, cpuid, vpa);
+	report(rc == H_PARAMETER, "Reserved sub-function fails with H_PARAMETER");
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, 0xbadbad, vpa);
+	report(rc == H_PARAMETER, "Register with invalid proc-no fails");
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, (void *)vpa + 8);
+	report(rc == H_PARAMETER, "Register with VPA not cacheline aligned fails");
+
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, (void *)vpa + 4096 - 128);
+	report(rc == H_PARAMETER, "Register with VPA spanning 4096 bytes fails");
+
+	vpa->size = cpu_to_be16(632);
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, (void *)vpa);
+	report(rc == H_PARAMETER, "Register with VPA size < 640 bytes fails");
+	vpa->size = cpu_to_be16(sizeof(*vpa));
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, PHYSICAL_END);
+	report(rc == H_PARAMETER, "Register with VPA outside guest real memory fails");
+
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, vpa);
+	report(rc == H_SUCCESS, "VPA registered");
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_DEREGISTER, cpuid, NULL);
+	report(rc == H_SUCCESS, "VPA deregistered");
+
+	/*
+	 * From PAPR: "note no check is made that a valid VPA registration
+	 * exists".
+	 */
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_DEREGISTER, cpuid, NULL);
+	report(rc == H_SUCCESS, "Deregister succeeds with no VPA registered");
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_DEREGISTER, 0xbadbad, NULL);
+	report(rc == H_PARAMETER, "Deregister with invalid proc-no fails");
+
+	report_prefix_pop();
+}
+
+/**
+ * Test some VPA fields.
+ */
+static void test_vpa(void)
+{
+	struct vpa *vpa;
+	uint32_t cpuid = fdt_boot_cpuid_phys(dt_fdt());
+	int disp_count1, disp_count2;
+	int rc;
+
+	report_prefix_push("VPA");
+
+	vpa = memalign(4096, sizeof(*vpa));
+
+	memset(vpa, 0, sizeof(*vpa));
+
+	vpa->size = cpu_to_be16(sizeof(*vpa));
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_REGISTER, cpuid, vpa);
+	if (rc != H_SUCCESS) {
+		report_skip("VPA could not be registered");
+		return;
+	}
+
+	if (verbose)
+		print_vpa(vpa);
+
+	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 % 2 == 0, "Dispatch count is even while running");
+	msleep(100);
+	disp_count2 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 != disp_count2, "Dispatch count increments over H_CEDE");
+
+	rc = hcall(H_REGISTER_VPA, SUBFUNC_DEREGISTER, cpuid, vpa);
+	if (rc != H_SUCCESS)
+		report_fail("Could not deregister after registration");
+
+	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
+
+	report_prefix_pop();
+}
+
+int main(int argc, char *argv[])
+{
+	int i;
+
+	for (i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "-v") == 0) {
+			verbose = 1;
+		}
+	}
+
+	test_register_vpa();
+
+	test_vpa();
+
+	return report_summary();
+}
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e206a22..dd5f361 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -39,6 +39,9 @@ groups = selftest
 [spapr_hcall]
 file = spapr_hcall.elf
 
+[spapr_vpa]
+file = spapr_vpa.elf
+
 [rtas-get-time-of-day]
 file = rtas.elf
 timeout = 5
-- 
2.37.2

