Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C836C44F01D
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 00:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbhKLX7s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 18:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhKLX7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 18:59:48 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2601C061766
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:56:56 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id g142-20020a625294000000b004946d789d14so6503359pfb.3
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 15:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l7xQsaxv5sxUj0+hALtV5qXlMcVkfZThwYuBhUpNLxM=;
        b=CIZYRb0//pvhNU7aFsKCbNsZC9PvL9ZmhQ+5AcXZXEtH0kTrmlwEIJ2Fy+BPl4nmBN
         OqezmQWzMASZzDytowoMDKbPslaFOiM4TSK82dz3LuNf8Z75wNL23oTg3fH0/OyZjwD8
         mBA2NiAsh3+g6U9RoTZqg5mMMV423BGsuW6bOMUpUSfI005wQs43ZNYjVV4V4i9JmyeK
         ZPzLHNfMk5EeG58/6p/UASEzVCYXDFdkY6TTTOmJisBFcQczTniSrDnCDlLJy6mez2fb
         D8OPcZ41mTnqT4wB7TKKvV8c7QxxZpwxLDzmGQG/FI7pD0sIvhUdx7QTUimT+LrVoj1l
         iKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l7xQsaxv5sxUj0+hALtV5qXlMcVkfZThwYuBhUpNLxM=;
        b=WhkKqHVbfjJhKmEHXhhCDioviCP+F+sgaT7kcIHbtKFSxZRngFds7OYxBfK72vK+e9
         1J+15gc86xpLUmKqoQdtq7GSAVolWsLmfAinH5dbza+E9gKTcKpTyxEstwiL59icJ7TZ
         Vp1FoO/nCB58+EBYHcoamLajKb/HKSxkGAPrT3TIc8FKo7JD0gHZbd8isZAm4GnYwHJp
         klQZ8r84P+HqIamAfFwZRFiLsBDu9ls08nsF1NO62nBS1sUR1pKEWxBpTUd9laX6yr3d
         nsCbiBvTO7y8I5A3ZJHH/DCVaLLHbtMV5QtG9oEWxsKv40i77pp8Sp9isi6bghe5Wis/
         l6ng==
X-Gm-Message-State: AOAM530HMF+eSuVklrrv9lV4JQUeT8AFIzNFPK+VpMKsKK5EtLuTERrr
        wOTqsWKJ/UEPfSoqkxS/DbjvUGio3dBMXQZ79lnV/V5US6BfHn3QM6JtBMEt8fdm3rqKt16yauX
        VqrDOOuDrTjxGKxg3mcF+qL6SB/+BHBYvp/Cg8P8fnvXrGsep0vDPTZEtFwkLIm4=
X-Google-Smtp-Source: ABdhPJzz3odUurIFKtEPFAXuCCY+3Ms0ET8wt1AkwuLwISbovLReojtWUDOXdCtW3nmliNwIohSM/NnYXcBtTA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:903:2445:b0:142:2471:644e with SMTP
 id l5-20020a170903244500b001422471644emr12420220pls.48.1636761416173; Fri, 12
 Nov 2021 15:56:56 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:56:52 -0800
Message-Id: <20211112235652.1127814-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH] x86/pmu: Test PMU virtualization on emulated instructions
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Eric Hankland <ehankland@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests of "instructions retired" and "branch instructions retired,"
to ensure that these events count emulated instructions.

Signed-off-by: Eric Hankland <ehankland@google.com>
[jmattson:
  - Added command-line parameter to conditionally run the new tests.
  - Added pmu-emulation test to unittests.cfg
]
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/pmu.c         | 80 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg |  7 +++++
 2 files changed, 87 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index ec61ac956a55..a159333b0c73 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -33,6 +33,12 @@
 
 #define N 1000000
 
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+// These values match the number of instructions and branches in the
+// assembly block in check_emulated_instr().
+#define EXPECTED_INSTR 17
+#define EXPECTED_BRNCH 5
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t config;
@@ -468,6 +474,77 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_pop();
 }
 
+static void check_emulated_instr(void)
+{
+	uint64_t status, instr_start, brnch_start;
+	pmu_counter_t brnch_cnt = {
+		.ctr = MSR_IA32_PERFCTR0,
+		/* branch instructions */
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[5].unit_sel,
+		.count = 0,
+	};
+	pmu_counter_t instr_cnt = {
+		.ctr = MSR_IA32_PERFCTR0 + 1,
+		/* instructions */
+		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel,
+		.count = 0,
+	};
+	report_prefix_push("emulated instruction");
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+
+	start_event(&brnch_cnt);
+	start_event(&instr_cnt);
+
+	brnch_start = -EXPECTED_BRNCH;
+	instr_start = -EXPECTED_INSTR;
+	wrmsr(MSR_IA32_PERFCTR0, brnch_start);
+	wrmsr(MSR_IA32_PERFCTR0 + 1, instr_start);
+	// KVM_FEP is a magic prefix that forces emulation so
+	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
+	asm volatile(
+		"mov $0x0, %%eax\n"
+		"cmp $0x0, %%eax\n"
+		KVM_FEP "jne label\n"
+		KVM_FEP "jne label\n"
+		KVM_FEP "jne label\n"
+		KVM_FEP "jne label\n"
+		KVM_FEP "jne label\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"mov $0xa, %%eax\n"
+		"cpuid\n"
+		"label:\n"
+		:
+		:
+		: "eax", "ebx", "ecx", "edx");
+
+	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	stop_event(&brnch_cnt);
+	stop_event(&instr_cnt);
+
+	// Check that the end count - start count is at least the expected
+	// number of instructions and branches.
+	report(instr_cnt.count - instr_start >= EXPECTED_INSTR,
+	       "instruction count");
+	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
+	       "branch count");
+	// Additionally check that those counters overflowed properly.
+	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+	report(status & 1, "instruction counter overflow");
+	report(status & 2, "branch counter overflow");
+
+	report_prefix_pop();
+}
+
 static void check_counters(void)
 {
 	check_gp_counters();
@@ -563,6 +640,9 @@ int main(int ac, char **av)
 
 	check_counters();
 
+	if (ac > 1 && !strcmp(av[1], "emulation"))
+		check_emulated_instr();
+
 	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
 		gp_counter_base = MSR_IA32_PMC0;
 		report_prefix_push("full-width writes");
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3000e53c790f..2aedb24dc4ff 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -185,6 +185,13 @@ extra_params = -cpu host,migratable=no
 check = /sys/module/kvm/parameters/ignore_msrs=N
 check = /proc/sys/kernel/nmi_watchdog=0
 
+[pmu_emulation]
+file = pmu.flat
+arch = x86_64
+extra_params = -cpu max -append emulation
+check = /sys/module/kvm_intel/parameters/force_emulation_prefix=Y
+check = /proc/sys/kernel/nmi_watchdog=0
+
 [vmware_backdoors]
 file = vmware_backdoors.flat
 extra_params = -machine vmport=on -cpu max
-- 
2.34.0.rc1.387.gb447b232ab-goog

