Return-Path: <kvm+bounces-13968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F22389D182
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 06:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0BC284492
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E0C60260;
	Tue,  9 Apr 2024 04:26:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx312.baidu.com [180.101.52.108])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C29355E49;
	Tue,  9 Apr 2024 04:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712636816; cv=none; b=ToLPWQZQ0LcdFlIOPvuJdmS4hmFXzRnVK17aEGSMQ6yn6nr5ikwkgsvO0/wbkeSkidID0t3KmgrpQMN9LqmPQh7NF/EhKiT67ufSFRZQ/jWOC0qzigPTGetmO9bmeg1Rx42qHtmhxMTR+t66nExQcbWN0QxqLRR+46j0jzlIASA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712636816; c=relaxed/simple;
	bh=jGNXxHR/Fh4U/7Tq9uNGVzYyZsoPbyiNVcG5X3Bq9MM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=Qt1OBnSE4vZgXD+IppGThMrcX/jHGH8HI0MZBjEuY/C8ylwgKVw7t0bOxDimnmuH8x2f204MsVZP4n8wtuxuGnmCTlMG5h3yPKA8KnV9YbbmlywpYH2SEhC/8ltZ0DH83hpqgWWAWsJc+dxEy7DANUw1i73pmvMdh4aaANWeb2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 4BFD87F00045;
	Tue,  9 Apr 2024 12:20:59 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	seanjc@google.com,
	szy0127@sjtu.edu.cn,
	thomas.lendacky@amd.com
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][RFC] x86,lib: Add wbinvd_on_many_cpus helpers
Date: Tue,  9 Apr 2024 12:20:56 +0800
Message-Id: <20240409042056.51757-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

wbinvd_on_many_cpus will call smp_call_function_many(), which should
be more efficient that iterating cpus since it would run wbinvd()
concurrently locally and remotely

it can be used by the below patch
https://patchwork.kernel.org/project/kvm/patch/1860502863.219296.1710395908135.JavaMail.zimbra@sjtu.edu.cn/

Cc: Zheyun Shen <szy0127@sjtu.edu.cn>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/include/asm/smp.h | 7 +++++++
 arch/x86/lib/cache-smp.c   | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index a35936b..70973de 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -111,6 +111,7 @@ void native_play_dead(void);
 void play_dead_common(void);
 void wbinvd_on_cpu(int cpu);
 int wbinvd_on_all_cpus(void);
+int wbinvd_on_many_cpus(const struct cpumask *mask);
 
 void smp_kick_mwait_play_dead(void);
 
@@ -159,6 +160,12 @@ static inline int wbinvd_on_all_cpus(void)
 	return 0;
 }
 
+static inline int wbinvd_on_many_cpus(const struct cpumask *mask)
+{
+	wbinvd();
+	return 0;
+}
+
 static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 {
 	return (struct cpumask *)cpumask_of(0);
diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index 7af743b..5950d1b 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -20,3 +20,10 @@ int wbinvd_on_all_cpus(void)
 	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
+
+int wbinvd_on_many_cpus(const struct cpumask *mask)
+{
+	smp_call_function_many(mask, __wbinvd, NULL, 1);
+	return 0;
+}
+EXPORT_SYMBOL(wbinvd_on_many_cpus);
-- 
2.9.4


