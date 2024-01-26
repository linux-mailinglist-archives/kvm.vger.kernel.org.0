Return-Path: <kvm+bounces-7158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 456C883DBB3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B0871C214D0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF511DFE3;
	Fri, 26 Jan 2024 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NTauUIHo"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3731DDE9
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279048; cv=none; b=nPXKAq20hV6D2iLNBqVEgfy+qZjPqXjjqGroxLGr0koSa9HEx8jgKrKpJg5PN62Wo45qYO40Ao50hIhbSMeg8yqXEnfeK/BYk50BHp21KUArK1OPUGziWG6vthuq3Cv5lGTrMXfBuWom+mmsiirEdVzSuAnf+krOLTO9BuoORpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279048; c=relaxed/simple;
	bh=aZSlWNk/RnJAVtDTB0t6+fL8GzUU2SL3SGhM76ESfuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=NKxpS28n/+TPJzRcGlbUbcNfO5RByB+yQYf0/S/SYgxgz3WezRHl4Cnm9/pySu/sYTrgcu2gHhx3crYTD6QM0hCCKSrT1Rq1h9f/DBzuEavq1H26oyxEgpz052+yWMMj7Gya5xWVC3yIhACrRBvtEBRuuJeRbK0BCR9qOhtqcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NTauUIHo; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fbzgEz1s/5JU7chZfU/WobWmghnPKaJfJA+urmjrYhg=;
	b=NTauUIHo/BOKiUJ0ttoyNZaktD5lN4KZEYshuoW3hC3xot7EQp+Gdts/Ijn7NDP3nz0ysy
	F1um1bqEpUqWOxc+eFIubpBZxd8KacD6enV4TnVV48Vksec1UgVrhSTP7+EwO78/5HAK11
	1+25kSLvllZO44l7f8QECV2E9z902fs=
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
Subject: [kvm-unit-tests PATCH v2 12/24] arm/arm64: Remove spinlocks from on_cpu_async
Date: Fri, 26 Jan 2024 15:23:37 +0100
Message-ID: <20240126142324.66674-38-andrew.jones@linux.dev>
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

Remove spinlocks from on_cpu_async() by pulling some of their
use into a new function and also by narrowing the locking to a
single on_cpu_info structure by introducing yet another cpumask.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/arm/asm/smp.h |  4 +++-
 lib/arm/smp.c     | 37 ++++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/lib/arm/asm/smp.h b/lib/arm/asm/smp.h
index 9f6d839ab568..f0c0f97a19f8 100644
--- a/lib/arm/asm/smp.h
+++ b/lib/arm/asm/smp.h
@@ -27,9 +27,11 @@ extern bool cpu0_calls_idle;
 extern void halt(void);
 extern void do_idle(void);
 
-extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
 extern void on_cpu_async(int cpu, void (*func)(void *data), void *data);
 extern void on_cpu(int cpu, void (*func)(void *data), void *data);
 extern void on_cpus(void (*func)(void *data), void *data);
 
+extern void smp_boot_secondary(int cpu, secondary_entry_fn entry);
+extern void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry);
+
 #endif /* _ASMARM_SMP_H_ */
diff --git a/lib/arm/smp.c b/lib/arm/smp.c
index c00fda2efb03..e0872a1a72c2 100644
--- a/lib/arm/smp.c
+++ b/lib/arm/smp.c
@@ -76,12 +76,32 @@ void smp_boot_secondary(int cpu, secondary_entry_fn entry)
 	spin_unlock(&lock);
 }
 
+void smp_boot_secondary_nofail(int cpu, secondary_entry_fn entry)
+{
+	spin_lock(&lock);
+	if (!cpu_online(cpu))
+		__smp_boot_secondary(cpu, entry);
+	spin_unlock(&lock);
+}
+
 struct on_cpu_info {
 	void (*func)(void *data);
 	void *data;
 	cpumask_t waiters;
 };
 static struct on_cpu_info on_cpu_info[NR_CPUS];
+static cpumask_t on_cpu_info_lock;
+
+static bool get_on_cpu_info(int cpu)
+{
+	return !cpumask_test_and_set_cpu(cpu, &on_cpu_info_lock);
+}
+
+static void put_on_cpu_info(int cpu)
+{
+	int ret = cpumask_test_and_clear_cpu(cpu, &on_cpu_info_lock);
+	assert(ret);
+}
 
 static void __deadlock_check(int cpu, const cpumask_t *waiters, bool *found)
 {
@@ -158,22 +178,21 @@ void on_cpu_async(int cpu, void (*func)(void *data), void *data)
 	assert_msg(cpu != 0 || cpu0_calls_idle, "Waiting on CPU0, which is unlikely to idle. "
 						"If this is intended set cpu0_calls_idle=1");
 
-	spin_lock(&lock);
-	if (!cpu_online(cpu))
-		__smp_boot_secondary(cpu, do_idle);
-	spin_unlock(&lock);
+	smp_boot_secondary_nofail(cpu, do_idle);
 
 	for (;;) {
 		cpu_wait(cpu);
-		spin_lock(&lock);
-		if ((volatile void *)on_cpu_info[cpu].func == NULL)
-			break;
-		spin_unlock(&lock);
+		if (get_on_cpu_info(cpu)) {
+			if ((volatile void *)on_cpu_info[cpu].func == NULL)
+				break;
+			put_on_cpu_info(cpu);
+		}
 	}
+
 	on_cpu_info[cpu].func = func;
 	on_cpu_info[cpu].data = data;
-	spin_unlock(&lock);
 	set_cpu_idle(cpu, false);
+	put_on_cpu_info(cpu);
 	smp_send_event();
 }
 
-- 
2.43.0


