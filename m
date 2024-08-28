Return-Path: <kvm+bounces-25281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2CE962E59
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D435284AF4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D6219E838;
	Wed, 28 Aug 2024 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cW1ErWRi"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD1B1A4AA4
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 17:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865520; cv=none; b=dChUgajKL1igCWU+NLQ8gaHPRFA9RbFdyUJLnNE0nWb29NrdV6NuOK5tIGCCoGZl/WgS9r9ABFlqmo1V2skyK1x0ITERaGB2+T9N7zxYxPTfOt51haFKvf1uxCDqXZUI4g38UX3jUpAOhd4LNTmUQqhy8hkBWGFsFq9hze1NMXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865520; c=relaxed/simple;
	bh=u9OWERKTgU0H7S4aQmt520YASXs6yoLIoWVB8AHqDmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxkinL/JnWVayqN1HUzx2safdvi2D1P+Z8ve5KgjlhMjmjLTk5XYYEjYhFM/8TiYoSPszHZrYAV04bu0hdZlUZs7OborI893JpFXI5xjvJtJYcmIEP912FC4bNoGbo/I410YvdlznVpCbJRI2Y8qNzGG8wks3gf+4Mcsjs4fzc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cW1ErWRi; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724865514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tspsh3WEVuEOw9onfJfHYvO1bxNsbjpgCwGyMt1FjK4=;
	b=cW1ErWRirqfcY2OZh2Ssusbmc4Hl3pYDxfdqAvBfueAyjyevPVLqMZ7MvkdeTQ3WkjZwD+
	7vucHkryCJ5iTG22m7siImapjQlwc8feMgNhW2nfAcyv9Io7LIw7ng0bQEQvHsXgVjCWg+
	xPTbPJfr3D1FZm/qoYPc+cPx5QjMuqE=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 4/3] riscv: QEMU Sstc timer stop workaround
Date: Wed, 28 Aug 2024 19:18:28 +0200
Message-ID: <20240828171827.1401255-2-andrew.jones@linux.dev>
In-Reply-To: <20240828162200.1384696-5-andrew.jones@linux.dev>
References: <20240828162200.1384696-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

QEMU doesn't stop a pending timer when UINT64_MAX is written to
stimecmp, see QEMU commit ae0edf2188b3 ("target/riscv: No need to
re-start QEMU timer when timecmp == UINT64_MAX"). We should probably
change that in QEMU, but we need a solution in kvm-unit-tests anyway
in order to support older QEMU versions. A bit of an ugly workaround
is to simply subtract one from UINT64_MAX, which is still a really
big number, but not the exact number QEMU is using to decide it
should skip the timer update.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/timer.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
index 67fd031ab95f..28e1626607f7 100644
--- a/lib/riscv/timer.c
+++ b/lib/riscv/timer.c
@@ -62,9 +62,16 @@ void timer_start(unsigned long duration_us)
 void timer_stop(void)
 {
 	if (cpu_has_extension(smp_processor_id(), ISA_SSTC)) {
-		csr_write(CSR_STIMECMP, ULONG_MAX);
+		/*
+		 * Subtract one from ULONG_MAX to workaround QEMU using that
+		 * exact number to decide *not* to update the timer. IOW, if
+		 * we used ULONG_MAX, then we wouldn't stop the timer at all,
+		 * but one less is still a big number ("infinity") and it gets
+		 * QEMU to do what we want.
+		 */
+		csr_write(CSR_STIMECMP, ULONG_MAX - 1);
 		if (__riscv_xlen == 32)
-			csr_write(CSR_STIMECMPH, ULONG_MAX);
+			csr_write(CSR_STIMECMPH, ULONG_MAX - 1);
 	} else if (sbi_probe(SBI_EXT_TIME)) {
 		struct sbiret ret = sbi_set_timer(ULONG_MAX);
 		assert(ret.error == SBI_SUCCESS);
-- 
2.45.2


