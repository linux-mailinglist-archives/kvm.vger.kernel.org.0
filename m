Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258EC6C0B0E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCTHE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCTHEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:20 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF5A1ACD3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so11325552pjt.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLn62fnhVYcTKroEi44rWRTC6DFRLihoZVooCHLndOU=;
        b=U3fDHASpmwKd2JjpnYqTR+NSzPu7vrxAEEye3SxghX8OdKT4SFle3WZwPl7Fs1ujQn
         YOCgNUacpAkDN6VTqZZmMywphe4OWZJqxYEqvo0rQlYkUQ30vm5JC95rJBLjA8JvjUXH
         U4q580oMLj0Ts7eudShxciF92J+gSJSDgk3Nzuhye2OZ9gtS6+VBS7+1rsjwBeNzug7d
         Ty+LBbnsIw5vhe8kwdhBO5XDvhO4oXiQAT0ZpmhnPB/wzNTwQ8EUg5bqtV443weVrm93
         zbNB2SP7QdbTBO9vBKYc1FGv+cDRNusSrtc6i/TNfTU0so4jRNEEYPvWOTiutMuvy4/s
         JN5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLn62fnhVYcTKroEi44rWRTC6DFRLihoZVooCHLndOU=;
        b=cpvtZrMOPaFOOoKGlFBGb0jhK0NOwTrx1lNY4wj7OXWRAv9p8lNu3uCYGwMCzPUDJJ
         oBokoMc9wkToGePj+qkEc96TzZy9U1qMAW4iHBNb7PsMRr1+ip4eUj/EBEv8o0QxpWXn
         cVwlvCa2wftcv9iFYrZ0iJ1WvOdGly2akq4exXn8StygnKKfZB3ctPuWyRBkAYcsg6k/
         t1kPWMhTnYidCK3iq/Cdi4HGSz8+w67KqivZ1XE32nDJrc70bTayOxp5HH/RfatVHxKA
         yfdQ1q1MCIqCD6UXD7DQvYyb+3I4YJHg4o5oFQ8XVMK1hpg2/GPd1FDoF9aLftNamGTi
         5JCA==
X-Gm-Message-State: AO0yUKXjqC3I98Aznad/W8F3/QB/qTph3AIAHWwV+ddhIipZujPWbAC4
        DbSTX57oHkIa8fS5sJC2AnG18NgKUlY=
X-Google-Smtp-Source: AK7set+XcP5XN5+445/zo+zYoxEt+kkxIVDFsPLqllhrJk7DbqRPB9va4Ej2pTS2l/Y6W2B6WzMyHQ==
X-Received: by 2002:a05:6a20:a111:b0:d3:76e0:89fd with SMTP id q17-20020a056a20a11100b000d376e089fdmr22450678pzk.50.1679295851055;
        Mon, 20 Mar 2023 00:04:11 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:04:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 07/10] powerpc/spapr_vpa: Add basic VPA tests
Date:   Mon, 20 Mar 2023 17:03:36 +1000
Message-Id: <20230320070339.915172-8-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VPA is a(n optional) memory structure shared between the hypervisor
and operating system, defined by PAPR. This test defines the structure
and adds registration, deregistration, and a few simple sanity tests.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/linux/compiler.h    |  2 +
 lib/powerpc/asm/hcall.h |  1 +
 lib/ppc64/asm/vpa.h     | 62 ++++++++++++++++++++++++++++
 powerpc/Makefile.ppc64  |  2 +-
 powerpc/spapr_vpa.c     | 90 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100644 lib/ppc64/asm/vpa.h
 create mode 100644 powerpc/spapr_vpa.c

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 6f565e4..c9d205e 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -45,7 +45,9 @@
 
 #define barrier()	asm volatile("" : : : "memory")
 
+#ifndef __always_inline
 #define __always_inline	inline __attribute__((always_inline))
+#endif
 #define noinline __attribute__((noinline))
 #define __unused __attribute__((__unused__))
 
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
index 0000000..45688fe
--- /dev/null
+++ b/powerpc/spapr_vpa.c
@@ -0,0 +1,90 @@
+/*
+ * Test sPAPR hypervisor calls (aka. h-calls)
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <libfdt/libfdt.h>
+#include <devicetree.h>
+#include <libcflat.h>
+#include <util.h>
+#include <alloc.h>
+#include <asm/processor.h>
+#include <asm/hcall.h>
+#include <asm/vpa.h>
+#include <asm/io.h> /* for endian accessors */
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
+/**
+ * Test the H_REGISTER_VPA h-call register/deregister.
+ */
+static void register_vpa(struct vpa *vpa)
+{
+	uint32_t cpuid = fdt_boot_cpuid_phys(dt_fdt());
+	int disp_count1, disp_count2;
+	int rc;
+
+	rc = hcall(H_REGISTER_VPA, 1ULL << 45, cpuid, vpa);
+	report(rc == H_SUCCESS, "VPA registered");
+
+	print_vpa(vpa);
+
+	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 % 2 == 0, "Dispatch count is even while running");
+	msleep(100);
+	disp_count2 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 != disp_count2, "Dispatch count increments over H_CEDE");
+
+	rc = hcall(H_REGISTER_VPA, 5ULL << 45, cpuid, vpa);
+	report(rc == H_SUCCESS, "VPA deregistered");
+
+	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
+	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
+}
+
+int main(int argc, char **argv)
+{
+	struct vpa *vpa;
+
+	vpa = memalign(4096, sizeof(*vpa));
+
+	memset(vpa, 0, sizeof(*vpa));
+
+	vpa->size = cpu_to_be16(sizeof(*vpa));
+
+	report_prefix_push("vpa");
+
+	register_vpa(vpa);
+
+	return report_summary();
+}
-- 
2.37.2

