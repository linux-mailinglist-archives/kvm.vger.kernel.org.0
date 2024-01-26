Return-Path: <kvm+bounces-7150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B345583DBAB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 699D01F2437F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2C91CFAB;
	Fri, 26 Jan 2024 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="de6FZQDW"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509F41CF99
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279028; cv=none; b=id9tOwqWDuTd6NnahSrNgH5SJw5al2R/a+MjcxK158ZiL+RCzpdMy29XRZg8CRb7F7pMGnE4MMUgQmIXYU+RBJrmJIRqqkC2IXofUxmNeNxc2eAL2QVmI/PhQF+XYJf/HRnUusQ8GCaitV3u2xrsTiq88EsvSUcpMOry6e1FEyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279028; c=relaxed/simple;
	bh=zY6CG5vGF99tT5HaVpdsav72jVAF1O/bAxOoo2ZbQ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=boVJVweYZ1F9hu7pMxnyLdJW0ljpJf1uGUuvYgEUifsE2yEQOp0mW7TYk6s/jkcadOvGZU1IkVqZlI56szGBVkDlleMQcerxFlmvvgE3Y0nzhuCUEkAwgYPVqhjKLby8ptMnO8NAUG9LZt5eq7SnZOvWlzI44pmIt1d1Y4B4Mdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=de6FZQDW; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XQohV6+uQbHgWwjNgHeXL3JkN2QKAX4B1acB6nE1eAA=;
	b=de6FZQDWD5ta9m9zez9E0hqUW59WupOfIYGGbm4dbTaOUIOj5nCDwzLU2Epve8iEsT7ljx
	tLirRLWNlKwjatIZvCZeAAOYjGUloGK991sDcTOjuBtcGCqi5FnnuOaF+mhygWzL+xDodX
	JExKrxPsQTu/98O78zTQlOAAQoTrMuU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 04/24] arm/arm64: Share cpu online, present and idle masks
Date: Fri, 26 Jan 2024 15:23:29 +0100
Message-ID: <20240126142324.66674-30-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

RISC-V will also use Arm's three cpumasks. These were in smp.h,
but they can be in cpumask.h instead, so move them there, which
is now shared.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/arm/asm/smp.h | 33 ---------------------------------
 lib/cpumask.h     | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index bb3e71a55e8c..b89a68dd344f 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -23,39 +23,6 @@ extern bool cpu0_calls_idle;
 extern void halt(void);
 extern void do_idle(void);
 
-extern cpumask_t cpu_present_mask;
-extern cpumask_t cpu_online_mask;
-extern cpumask_t cpu_idle_mask;
-#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
-#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
-#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
-#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
-#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
-
-static inline void set_cpu_present(int cpu, bool present)
-{
-	if (present)
-		cpumask_set_cpu(cpu, &cpu_present_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_present_mask);
-}
-
-static inline void set_cpu_online(int cpu, bool online)
-{
-	if (online)
-		cpumask_set_cpu(cpu, &cpu_online_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_online_mask);
-}
-
-static inline void set_cpu_idle(int cpu, bool idle)
-{
-	if (idle)
-		cpumask_set_cpu(cpu, &cpu_idle_mask);
-	else
-		cpumask_clear_cpu(cpu, &cpu_idle_mask);
-}
-
 extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
diff --git a/lib/cpumask.h b/lib/cpumask.h
index d30e14cda09e..be1919234d8e 100644
--- a/lib/cpumask.h
+++ b/lib/cpumask.h
@@ -119,4 +119,37 @@ static inline int cpumask_next(int cpu, const cpumask_t *mask)
 			(cpu) < nr_cpus; 			\
 			(cpu) = cpumask_next(cpu, mask))
 
+extern cpumask_t cpu_present_mask;
+extern cpumask_t cpu_online_mask;
+extern cpumask_t cpu_idle_mask;
+#define cpu_present(cpu)		cpumask_test_cpu(cpu, &cpu_present_mask)
+#define cpu_online(cpu)			cpumask_test_cpu(cpu, &cpu_online_mask)
+#define cpu_idle(cpu)			cpumask_test_cpu(cpu, &cpu_idle_mask)
+#define for_each_present_cpu(cpu)	for_each_cpu(cpu, &cpu_present_mask)
+#define for_each_online_cpu(cpu)	for_each_cpu(cpu, &cpu_online_mask)
+
+static inline void set_cpu_present(int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, &cpu_present_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_present_mask);
+}
+
+static inline void set_cpu_online(int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, &cpu_online_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_online_mask);
+}
+
+static inline void set_cpu_idle(int cpu, bool idle)
+{
+	if (idle)
+		cpumask_set_cpu(cpu, &cpu_idle_mask);
+	else
+		cpumask_clear_cpu(cpu, &cpu_idle_mask);
+}
+
 #endif /* _CPUMASK_H_ */
-- 
2.43.0


