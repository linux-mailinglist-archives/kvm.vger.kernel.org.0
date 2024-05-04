Return-Path: <kvm+bounces-16593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F818BBB59
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22B521C2083C
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE823BB23;
	Sat,  4 May 2024 12:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uef6Byi1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187E3B29D
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825852; cv=none; b=GVOKdvaO5CI36Z4bvSm6q+OLWJVq8JDjnI8eAVH8Pp9z+PoczrifsMEQ8k9qt0J9B8Ks7pKuXN5BhpBIzMq7QZ/3u03qStDXwydZ16VH5s4fC1hdcHTob8GDae4qVM4E+ndqQD7CEe1KjXCW1qFKhslISuE5rU2IAVdoRERWzG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825852; c=relaxed/simple;
	bh=3RD5yGkTolOWBCABY3gJu0BBns+e2AeCAJII8G3LR9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoCdXgAzsmNemoCkj37L4KezE9kHuBrzpErby6Y7inrulUaQbOZk9r81ifZJVPC56QXMh9si+NUTKosAXfyocYBXVvVAKJGgO4rjPHWaCqbvPZVLLZukPQ9cS+uQ2HiZ26Z6vampfpJBhQ2p1V8wzmCRjVkzKlm0VXXGDUNeRUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uef6Byi1; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6f44bcbaae7so473125b3a.2
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825850; x=1715430650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6KvNFDDT9boTvfk0g7Fu/0RZ+dy+RbVwyckvEdOV/A=;
        b=Uef6Byi1euLp9T+npNN2uil5G+B287RkmdWcHNLzn3JR4R7o2sNU+jdLL6xbmcRkCm
         XQ/dCbWF8bS16raQisWNXH82Lx3Q5Ftrc40Lia1LUtECzgP2O227LvHVkcgSk8sXGmdK
         Nl1idvEQpjmNBj1j2YvTv+yCJxq11R0WRv/33aYv2W5FdwEMSV+tgqyHRoSTOSUkbutG
         13JglWXea/qQtLuOY5vPzMenxwRSFY1l4rmH6oyq+5K4IOZSaU23v/5wHVwxsALrOjmU
         JpDk8/IusemsyBNIE/OGk8czhR4MW7Bn5GGFWBhQ6pVkBx6VWdLZy+X7c3Xz4UafulN0
         tZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825850; x=1715430650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6KvNFDDT9boTvfk0g7Fu/0RZ+dy+RbVwyckvEdOV/A=;
        b=Dfbcr09AVUwdw/RQlzG8aOcvjoRpzUiKr9ImIvkIoGyEcG/iX4afjXsop3oUDkUWdy
         tDCX0eZR6IIKpTtEuxLBGyZ9VmYUtw9LqHVVrMXZ8+orj/uH44KC4agMDDXUqCVPfvDV
         mOHs68TakthmCfwjUWSA7Jj8cL44rTPhMr7Yxs6WWc2Ka66LGVwNplsaLMK8JKabGGCC
         UxacsSuglUxoRAvKoFM4J4Oj1RAu7O4bUb0l6jPbvuhi3H0+yCOeyyTz//SkkUHyQ24l
         pYPRWFe46kfgeu9njD0lVk1thpdd1VOCxOL05HZQ4NB927i4V1ABu3xI/MBMbZud7lne
         mZoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVVrBqBiY2410fdMKANZw7QYbUxadGCRVhDmDlFTVX44JRVJyFdHv8ahACks6F0rTdYzM97J5zq38nxc/iWXgKnXdv
X-Gm-Message-State: AOJu0YxtFiolyzWtCZJO1BuCXpP33YFxdRjK7Kt/q5kBsN+qxf54w/Oq
	2d0mQp6kb3Lrg0mtTxzlgeIWkWDSmZjguuuPQps38U5rCEYBGLLoXWaiOw==
X-Google-Smtp-Source: AGHT+IGiUp63wEQAX/25zlW8DnNsOdcroeS4VtV/DdyFyGXhh8WS73VQ1qY6UjK6KxrSgimj86sx7A==
X-Received: by 2002:a05:6a20:320d:b0:1af:66e6:b1b2 with SMTP id hl13-20020a056a20320d00b001af66e6b1b2mr4860642pzc.1.1714825849815;
        Sat, 04 May 2024 05:30:49 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:49 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v9 30/31] powerpc: Add facility to query TCG or KVM host
Date: Sat,  4 May 2024 22:28:36 +1000
Message-ID: <20240504122841.1177683-31-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use device tree properties to determine whether KVM or TCG is in
use.

Logically these are not the inverse of one another, because KVM can be
used on top of a TCG processor (if TCG is emulating HV mode, or if it
provides a nested hypervisor interface with spapr). This can be a
problem because some issues relate to TCG CPU emulation, and some to
the spapr hypervisor implementation. At the moment there is no way to
determine TCG is running a KVM host that is running the tests, but the
two independent variables are added in case that is able to be
determined in future. For now that case is just incorrectly considered
to be kvm && !tcg.

Use this facility to restrict some of the known test failures to TCG.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |  3 +++
 lib/powerpc/setup.c         | 25 +++++++++++++++++++++++++
 powerpc/atomics.c           |  2 +-
 powerpc/interrupts.c        |  6 ++++--
 powerpc/mmu.c               |  2 +-
 powerpc/pmu.c               |  6 +++---
 powerpc/sprs.c              |  2 +-
 powerpc/timebase.c          |  4 ++--
 powerpc/tm.c                |  2 +-
 9 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index 28239c610..09535f8c3 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -10,6 +10,9 @@ void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
 void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
+extern bool host_is_tcg;
+extern bool host_is_kvm;
+
 extern bool cpu_has_hv;
 extern bool cpu_has_power_mce;
 extern bool cpu_has_siar;
diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index 8ff4939e2..2b9d67466 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -235,6 +235,8 @@ void cpu_init(struct cpu *cpu, int cpu_id)
 	cpu->in_user = false;
 }
 
+bool host_is_tcg;
+bool host_is_kvm;
 bool is_hvmode;
 
 void setup(const void *fdt)
@@ -290,6 +292,29 @@ void setup(const void *fdt)
 	assert(ret == 0);
 	freemem += fdt_size;
 
+	if (!fdt_node_check_compatible(fdt, 0, "qemu,pseries")) {
+		assert(!cpu_has_hv);
+
+		/*
+		 * host_is_tcg incorrectly does not get set when running
+		 * KVM on a TCG host (using powernv HV emulation or spapr
+		 * nested HV).
+		 */
+		ret = fdt_subnode_offset(fdt, 0, "hypervisor");
+		if (ret < 0) {
+			host_is_tcg = true;
+			host_is_kvm = false;
+		} else {
+			/* KVM is the only supported hypervisor */
+			assert(!fdt_node_check_compatible(fdt, ret, "linux,kvm"));
+			host_is_tcg = false;
+			host_is_kvm = true;
+		}
+	} else {
+		assert(cpu_has_hv);
+		host_is_tcg = true;
+		host_is_kvm = false;
+	}
 	ret = dt_get_initrd(&tmp, &initrd_size);
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
diff --git a/powerpc/atomics.c b/powerpc/atomics.c
index 975711fc8..7d6dfaed9 100644
--- a/powerpc/atomics.c
+++ b/powerpc/atomics.c
@@ -119,7 +119,7 @@ static void test_lwarx_stwcx(int argc, char *argv[])
 		      "stwcx.	%1,0,%3;"
 		      : "=&r"(old) : "r"(1), "r"(var), "r"((char *)var+1) : "cr0", "memory");
 	/* unaligned larx/stcx. is not required by the ISA to cause an exception, in TCG the stcx does not. */
-	report_kfail(true, old == 0 && *var == 0 && got_interrupt && recorded_regs.trap == 0x600, "unaligned stwcx. causes fault");
+	report_kfail(host_is_tcg, old == 0 && *var == 0 && got_interrupt && recorded_regs.trap == 0x600, "unaligned stwcx. causes fault");
 	got_interrupt = false;
 
 	handle_exception(0x600, NULL, NULL);
diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
index ba965ff76..6511c76f2 100644
--- a/powerpc/interrupts.c
+++ b/powerpc/interrupts.c
@@ -78,7 +78,8 @@ static void test_mce(void)
 
 	is_fetch = false;
 	asm volatile("lbz %0,0(%1)" : "=r"(tmp) : "r"(addr));
-	report(got_interrupt, "MCE on access to invalid real address");
+	/* KVM does not MCE on access outside partition scope */
+	report_kfail(host_is_kvm, got_interrupt, "MCE on access to invalid real address");
 	if (got_interrupt) {
 		report(mfspr(SPR_DAR) == addr, "MCE sets DAR correctly");
 		if (cpu_has_power_mce)
@@ -88,7 +89,8 @@ static void test_mce(void)
 
 	is_fetch = true;
 	asm volatile("mtctr %0 ; bctrl" :: "r"(addr) : "ctr", "lr");
-	report(got_interrupt, "MCE on fetch from invalid real address");
+	/* KVM does not MCE on access outside partition scope */
+	report_kfail(host_is_kvm, got_interrupt, "MCE on fetch from invalid real address");
 	if (got_interrupt) {
 		report(recorded_regs.nip == addr, "MCE sets SRR0 correctly");
 		if (cpu_has_power_mce)
diff --git a/powerpc/mmu.c b/powerpc/mmu.c
index fef790506..27220b71f 100644
--- a/powerpc/mmu.c
+++ b/powerpc/mmu.c
@@ -172,7 +172,7 @@ static void test_tlbie(int argc, char **argv)
 	handle_exception(0x700, NULL, NULL);
 
 	/* TCG has a known race invalidating other CPUs */
-	report_kfail(true, !tlbie_test_failed, "tlbie");
+	report_kfail(host_is_tcg, !tlbie_test_failed, "tlbie");
 }
 
 #define THIS_ITERS 100000
diff --git a/powerpc/pmu.c b/powerpc/pmu.c
index 8b13ee4cd..960f90787 100644
--- a/powerpc/pmu.c
+++ b/powerpc/pmu.c
@@ -107,7 +107,7 @@ static void test_pmc5_with_sc(void)
 	pmc5_2 = mfspr(SPR_PMC5);
 
 	/* TCG does not count instructions around syscalls correctly */
-	report_kfail(true, pmc5_1 + 20 == pmc5_2, "PMC5 counts instructions with syscall");
+	report_kfail(host_is_tcg, pmc5_1 + 20 == pmc5_2, "PMC5 counts instructions with syscall");
 
 	handle_exception(0xc00, NULL, NULL);
 }
@@ -336,7 +336,7 @@ static void test_bhrb(void)
 				break;
 		}
 		report(nr_bhrbe, "BHRB has been written");
-		report_kfail(true, nr_bhrbe == 8, "BHRB has written 8 entries");
+		report_kfail(!host_is_tcg, nr_bhrbe == 8, "BHRB has written 8 entries");
 		if (nr_bhrbe == 8) {
 			report(bhrbe[4] == (unsigned long)dummy_branch_1,
 					"correct unconditional branch address");
@@ -369,7 +369,7 @@ static void test_bhrb(void)
 				break;
 		}
 		report(nr_bhrbe, "BHRB has been written");
-		report_kfail(true, nr_bhrbe == 6, "BHRB has written 6 entries");
+		report_kfail(!host_is_tcg, nr_bhrbe == 6, "BHRB has written 6 entries");
 		if (nr_bhrbe == 6) {
 			report(bhrbe[4] == (unsigned long)dummy_branch_1,
 					"correct unconditional branch address");
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index c5844985a..c496efe9e 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -590,7 +590,7 @@ int main(int argc, char **argv)
 
 		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32)) {
 			/* known failure KVM migration of CTRL */
-			report_kfail(true && i == 136,
+			report_kfail(host_is_kvm && i == 136,
 				"%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
 				sprs[i].name, i,
 				before[i], after[i]);
diff --git a/powerpc/timebase.c b/powerpc/timebase.c
index 02a4e33c0..b1378dd2b 100644
--- a/powerpc/timebase.c
+++ b/powerpc/timebase.c
@@ -94,7 +94,7 @@ static void test_dec(int argc, char **argv)
 			break;
 	}
 	/* POWER CPUs can have a slight (few ticks) variation here */
-	report_kfail(true, tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after mtDEC");
+	report_kfail(!host_is_tcg, tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after mtDEC");
 
 	tb1 = get_tb();
 	mtspr(SPR_DEC, dec_max);
@@ -159,7 +159,7 @@ static void test_dec(int argc, char **argv)
 	local_irq_enable();
 	local_irq_disable();
 	/* TCG does not model this correctly */
-	report_kfail(true, !got_interrupt, "no interrupt after wrap to positive");
+	report_kfail(host_is_tcg, !got_interrupt, "no interrupt after wrap to positive");
 	got_interrupt = false;
 
 	handle_exception(0x900, NULL, NULL);
diff --git a/powerpc/tm.c b/powerpc/tm.c
index 507eaf492..d4f436147 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -135,7 +135,7 @@ int main(int argc, char **argv)
 	}
 	/* kvm-unit-tests can limit number of CPUs present */
 	/* KVM does not report TM in secondary threads in POWER9 */
-	report_kfail(true, cpus_with_tm >= nr_cpus_present,
+	report_kfail(host_is_kvm, cpus_with_tm >= nr_cpus_present,
 	       "TM available in all 'ibm,pa-features' properties");
 
 	all = argc == 1 || !strcmp(argv[1], "all");
-- 
2.43.0


