Return-Path: <kvm+bounces-11043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FC2872546
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 18:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C890FB2303F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A29A17756;
	Tue,  5 Mar 2024 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ap7NF3d0"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10D17559
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 17:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658549; cv=none; b=SpOVXeCCkciMTFuoA9hQStT1kixANAR0gLZwjjh7fOcCyIKm2OUpJcSpzi3DVEkEPpfriMaFv0SeaqpxBvwpxMeOntnhcH4VoFOx9YhOOMEVOVWE9xecc40mbG2yHLVmYe3qaDsB6WSVlRXZvW3h6/pprny0HAzI1fLxxZbZo+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658549; c=relaxed/simple;
	bh=24V7ixbq2YncjbjPwMlh0hmEj06CdhvH7HFYRxqOIv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=BXRTxs3ULcHyIe4e/aPvGk6YoFWa+ta+kh0iw80PPqi29c62yGjxxWa29s4ERs/BtKD9sAf3iQcoIVxDcXFZxs2LwM0E8hTAEyMKXyA4KRRT0QXhRZ6iXMl4WIdczek93pu2jkw62o1AV/PNBMUaHL2MM7LSnaCiPD8H2slbJNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ap7NF3d0; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709658546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lnx86mIelCSQRXsx8I9hWhibAHGsTcpUKaR0USeZNW0=;
	b=Ap7NF3d0Sr0EKWsRkQgdeVChuSEzDVhSUa/MJtFu0dRsvP3gkzFvAwqntvycYsVBoW9awy
	qvjnlJ7L/RGALtWUgqoRSJEr7pjuVNXlIORh9clqmUtFnSX1i8TNqHeS2h0kKIeV3xAyZa
	LG1U9cuJYOihSQlNW60/nJahEqUNwT8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 02/13] riscv: show_regs: Prepare for EFI images
Date: Tue,  5 Mar 2024 18:09:01 +0100
Message-ID: <20240305170858.395836-17-andrew.jones@linux.dev>
In-Reply-To: <20240305170858.395836-15-andrew.jones@linux.dev>
References: <20240305170858.395836-15-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

EFI images start with a header page and then _text, so the load
address should use 'ImageBase' instead of _text. Just add the
ImageBase symbol to the non-efi build too and then change show_regs()
to use it instead. While there, add a couple convenience calculations
for the PC and return address (pre-subtract the load address from
them) in order to make it quicker for looking them up in an objdump.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/processor.c | 8 ++++----
 riscv/flat.lds        | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index 6c868b805cf7..ece7cbffc6dd 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -8,20 +8,20 @@
 #include <asm/processor.h>
 #include <asm/setup.h>
 
-extern unsigned long _text;
+extern unsigned long ImageBase;
 
 void show_regs(struct pt_regs *regs)
 {
 	struct thread_info *info = current_thread_info();
-	uintptr_t text = (uintptr_t)&_text;
+	uintptr_t loadaddr = (uintptr_t)&ImageBase;
 	unsigned int w = __riscv_xlen / 4;
 
-	printf("Load address: %" PRIxPTR "\n", text);
+	printf("Load address: %" PRIxPTR "\n", loadaddr);
 	printf("CPU%3d : hartid=%lx\n", info->cpu, info->hartid);
 	printf("status : %.*lx\n", w, regs->status);
 	printf("cause  : %.*lx\n", w, regs->cause);
 	printf("badaddr: %.*lx\n", w, regs->badaddr);
-	printf("pc: %.*lx ra: %.*lx\n", w, regs->epc, w, regs->ra);
+	printf("pc: %.*lx (%lx) ra: %.*lx (%lx)\n", w, regs->epc, regs->epc - loadaddr, w, regs->ra, regs->ra - loadaddr);
 	printf("sp: %.*lx gp: %.*lx tp : %.*lx\n", w, regs->sp, w, regs->gp, w, regs->tp);
 	printf("a0: %.*lx a1: %.*lx a2 : %.*lx a3 : %.*lx\n", w, regs->a0, w, regs->a1, w, regs->a2, w, regs->a3);
 	printf("a4: %.*lx a5: %.*lx a6 : %.*lx a7 : %.*lx\n", w, regs->a4, w, regs->a5, w, regs->a6, w, regs->a7);
diff --git a/riscv/flat.lds b/riscv/flat.lds
index d4853f82ba1c..1ca501e6593b 100644
--- a/riscv/flat.lds
+++ b/riscv/flat.lds
@@ -30,6 +30,7 @@ PHDRS
 
 SECTIONS
 {
+    PROVIDE(ImageBase = .);
     PROVIDE(_text = .);
     .text : { *(.init) *(.text) *(.text.*) } :text
     . = ALIGN(4K);
-- 
2.44.0


