Return-Path: <kvm+bounces-19395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 744D2904AC8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 07:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAC381F22087
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 05:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DC23770C;
	Wed, 12 Jun 2024 05:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZo77Jad"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309C15BB
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 05:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718169816; cv=none; b=MYth9+Rp0Z6s8l6bnajMu5AyIB+EDZHMesLM7bdG153ZW414/OMZB50IS5V/WhVi/ny3x4plwKEjEpUIy+JNOVkP/CZzfa8nWudE8L4nvytbW7bVBOGeOY8IRE4cf4J/wGBUUuyHVg2vbaEYsvZKVdjsFzWtnKj2Fh3D9Z/Qink=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718169816; c=relaxed/simple;
	bh=izqDl4kXsZEuJhy3PRwmpOV9WGA9iKHbBfjl4oEXfZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0f7dZKjTGtAi4URMh0isNZPZdIyyzcwcoVc/ehnoW/Jh0e1KuwwO+9TNKFkywJkfscJlG457gG0wSM66+Z3tO9Y/WVzUB6SmOe1+bp8E9LTLoOT7ckUyTttKt7SqOAqjHnP23Ut/ldOszxNJ1oji/eU0Ad7vImemWDlLZhyktU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TZo77Jad; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-6e41550ae5bso3430928a12.3
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718169814; x=1718774614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LYx9pWe+IXQn9iXJjFIm9X9Ha+gW+XiixBi0YYKAco=;
        b=TZo77JadVft9ZwMj0eFgiXZljPwmJYZ/hGE65prn8rC65PxG4IXN5YWoBvpktKJ/T/
         UZvMBnyTqtADrHnTN5WE1cd8GboRHWN2fLFtInLXrEv1v/h6uJ5iqpkhqiBRJmKtZxLz
         QEbYR09hBWxgI+IZkgp8ihka41Q2knzXDYj/r7FtBVm+cZWnPqCoVwOKaz+eMgP5mkPo
         wuPQH1cqb1OGqZTxxmDxuzij5WVQOTk/zngv/OsbuLb1n0X03MmZ9gN36oH69DRYGtAe
         7R6Elu1kyb+7RauKJU5/dEtJqkwEDu/BBNXxm4yG375NPV4HmXDnZoo/sCEdh5+Mj6dy
         Gn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718169814; x=1718774614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3LYx9pWe+IXQn9iXJjFIm9X9Ha+gW+XiixBi0YYKAco=;
        b=ROoBLivbjQXyahBAUuidpPhVL5MZLPxr29pjDTuR8KCOaUPFEGw0xD9sJmIMTPnrKe
         5kh3RoFknj15pEY86kbjGR10mFlli/zyqCMFRI2NH3Z+mh/LGhq3cK15IoNkcEAVu5pp
         a09hipiAeVDYoTEkwtGZe2dDt7AqQLK3RSwrn/YZlAIX2ZyaliF561+WRiDPxposgmFH
         8ZhY5gzT1EaYZNlSmT1N+4kXNIcxH1ZrWtFjVCWZWt+0SNKQRT2DDxQoB49x6os5AkK9
         AFHNWUwFglD99h1BoA9LrtMfQtBoivcumPlfFHMABsTqjXWNUDHnpbHYC7SBTmMnxb0N
         vQyg==
X-Forwarded-Encrypted: i=1; AJvYcCU+7bSkXEDL5D3O94bORP7CVenRptendqN3GWjHWI5mSWjeKfFdn/bHgCdKQhCMmfzWqo6q+IZN6vVQk2DSqrcD+Zyl
X-Gm-Message-State: AOJu0YwPcl1M7G3qKXzCI/VoYuZYWsNTgUEy6gcwkhk4BJ+NfR6i2SeQ
	BBUGhInj7bSyID8EVuLhxefiIrDakSnCfpPkrDCK8t9Wkhez47ez
X-Google-Smtp-Source: AGHT+IFKLAKOMwGgrW3gptnRK9NG8WToNY0soeikvGZ3tFM78QRkaQ5c6Eratbtmd2B75aByNiO65g==
X-Received: by 2002:a05:6a20:8402:b0:1b5:8d94:907a with SMTP id adf61e73a8af0-1b8a9b9e15amr986922637.14.1718169814157;
        Tue, 11 Jun 2024 22:23:34 -0700 (PDT)
Received: from wheely.local0.net (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6bd75f711sm112170705ad.11.2024.06.11.22.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 22:23:33 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v10 01/15] powerpc: Add facility to query TCG or KVM host
Date: Wed, 12 Jun 2024 15:23:06 +1000
Message-ID: <20240612052322.218726-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240612052322.218726-1-npiggin@gmail.com>
References: <20240612052322.218726-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use device tree properties to determine whether KVM or TCG is in
use.

Logically these are not the inverse of one another, because KVM can run
on a TCG processor (if TCG is emulating HV mode, or it is using the
nested hypervisor APIs in pseries / spapr). And kvm-unit-tests can run
on that KVM.

This can be a problem because some issues relate to TCG CPU emulation
some to the spapr hypervisor implementation, some to KVM, some to real
hardware, so the TCG test is best-effort for now and is set to the
opposite of KVM. The two independent variables are added because we may
be able to more accurately determine this in future.

Use this facility to restrict some of the known test failures to TCG.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h |  3 +++
 lib/powerpc/setup.c         | 26 ++++++++++++++++++++++++++
 powerpc/interrupts.c        |  6 ++++--
 powerpc/sprs.c              |  2 +-
 powerpc/tm.c                |  2 +-
 5 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index a3859b5d4..a660344cb 100644
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
index 622b99e5d..86e2e144c 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -208,6 +208,9 @@ void cpu_init(struct cpu *cpu, int cpu_id)
 	cpu->exception_stack += SZ_64K - 64;
 }
 
+bool host_is_tcg;
+bool host_is_kvm;
+
 void setup(const void *fdt)
 {
 	void *freemem = &stacktop;
@@ -259,6 +262,29 @@ void setup(const void *fdt)
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
diff --git a/powerpc/interrupts.c b/powerpc/interrupts.c
index 552c48ef2..3e3622e59 100644
--- a/powerpc/interrupts.c
+++ b/powerpc/interrupts.c
@@ -72,7 +72,8 @@ static void test_mce(void)
 	is_fetch = false;
 	asm volatile("lbz %0,0(%1)" : "=r"(tmp) : "r"(addr));
 
-	report(got_interrupt, "MCE on access to invalid real address");
+	/* KVM does not MCE on access outside partition scope */
+	report_kfail(host_is_kvm, got_interrupt, "MCE on access to invalid real address");
 	if (got_interrupt) {
 		report(mfspr(SPR_DAR) == addr, "MCE sets DAR correctly");
 		if (cpu_has_power_mce)
@@ -82,7 +83,8 @@ static void test_mce(void)
 
 	is_fetch = true;
 	asm volatile("mtctr %0 ; bctrl" :: "r"(addr) : "ctr", "lr");
-	report(got_interrupt, "MCE on fetch from invalid real address");
+	/* KVM does not MCE on access outside partition scope */
+	report_kfail(host_is_kvm, got_interrupt, "MCE on fetch from invalid real address");
 	if (got_interrupt) {
 		report(recorded_regs.nip == addr, "MCE sets SRR0 correctly");
 		if (cpu_has_power_mce)
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index a85011ad5..dc810b8da 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -590,7 +590,7 @@ int main(int argc, char **argv)
 
 		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32)) {
 			/* known failure KVM migration of CTRL */
-			report_kfail(i == 136, pass,
+			report_kfail(host_is_kvm && i == 136, pass,
 				"%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
 				sprs[i].name, i,
 				before[i], after[i]);
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
2.45.1


