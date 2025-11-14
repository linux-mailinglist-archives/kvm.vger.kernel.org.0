Return-Path: <kvm+bounces-63130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B663C5AB99
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B30D335379C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D732D20CCCA;
	Fri, 14 Nov 2025 00:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZsZELI7L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9051FDE31
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079190; cv=none; b=VDZiPdJy4Y1pBytVMN4F0wzJcbFXIwKpZ+NSnreAw15ublxNWkX7k8NPtSOjRiwwbTL4OHSAmC2VFT/OP9f3GVJNfeqZkBd1ZL0NZnQBJxJ//pKdgTZjoVNqkrUMrD7Br4hiJ8i7kC4NJKYzIfTAVIpc+4zb8LGd0WOeeHdlHCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079190; c=relaxed/simple;
	bh=oGTggzr5jKcuOffOHLrYYa9DDB5vwZR9gG9clLfnX5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N8mUBlIk0dcU8ZoR5K9KbhmwXxiiQehjPIeBRZ4GIRPc/CPn+eEYgqxsy0BJhviRCrpHxAjd2VABrUzDvLz4fcEDdkaIgdD6ngD4iFGPBs5U3MgHNKgUBdywwr5q+pH84OR4PpqJdgeOKJsMqQz44KAMOxd30Bky2fB9o/HfrY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZsZELI7L; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so1561058b3a.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763079188; x=1763683988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kRBMfjFsGZBNLPJPvrgkKEEzOwvRF5vo6ZIWna3fffU=;
        b=ZsZELI7LnjUsaTNBj+ZceC96XMYjQoaEq1UJV4aRr0FGgxaNlKO3mXxVcPUmwyVmqU
         VHmbNpGTJaXqdLQ/WcULvnQTZNz78gv9YhAw7QyP3sQMPNJHtKiQrtNR1ng8ZhXWU7vQ
         kA1kC2vHIzx68xFEjWd4gqKtXLiIy4mhRO9OnwsGjoKljVCQRcxS8Bv8islui3pCLmwK
         z+OV9esKmicuvc556M6y52yW1NF3qH7hZRpdtEcoa4JAEBAsJKCn4SfEes3unDgdxvHh
         En7cXb+5YUjttAKArBuCnHLkwyuyYrl9HMTBJJr+3aeR0/o8Uq8zTHC4/so5zNlf+cq3
         oCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763079188; x=1763683988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kRBMfjFsGZBNLPJPvrgkKEEzOwvRF5vo6ZIWna3fffU=;
        b=ViA1W08KHYNxAqrmrFQVy3IUDoFfMs75/ygzNJ/xmIue95232cbfY98/Z7hPJAbSsy
         UioUh4VZrtywQhxhovZov5qKjDW0c3eXMRqnNsroispzgQHwR5qFbYFHD1Ai3aUYp6Uu
         Db1OMEMN6Cjw1WjSyOpEHpSYVu3+VvU8F41t28b2Dz10kJSQbQWDJZq+4Akdm1xuzdcA
         Yw7wrc2GF+b5nQ6Tbrnu2EhEqdmUQsY8GT1q8+1iujBpopk2CSfdvUaGDx9wEAC55b0B
         Xnx05SJdhQR5y1hYmygKwKlLtw2vhV22jwbaqMkNcGP4fHlQxXVZflZzssS9sFhK2/pT
         Mf3Q==
X-Gm-Message-State: AOJu0YwFsyzasPtfYI4BC9xiEh0qMRLcCkgI1qnJcPfKJVLoXqlFQsAG
	+FH86dOjYLCT0ONt6IIpCXUaROiK1FDrpc0sQiU6lenw1XVpdSI7SjdSUKVWFdk1FZ62hfNvGdB
	DJdgG8Q==
X-Google-Smtp-Source: AGHT+IGVlRBMA1oZC/w3stN/aQadv5YECwStDR7EL6YnCYYK34UV++Pj+ttSiBsqftvGVfGr9IVFLWdQGFc=
X-Received: from pghf7.prod.google.com ([2002:a63:e307:0:b0:b99:9560:3dc9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4315:b0:341:e79b:9495
 with SMTP id adf61e73a8af0-35ba2b8772amr1561364637.54.1763079187678; Thu, 13
 Nov 2025 16:13:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 16:12:45 -0800
In-Reply-To: <20251114001258.1717007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251114001258.1717007-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251114001258.1717007-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 04/17] x86: cet: Directly check for #CP
 exception in run_in_user()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Current CET tests validate if a #CP exception is raised by registering
a #CP handler. This handler counts the #CP exceptions and raises a #GP
exception, which is then caught by the run_in_user() infrastructure to
switch back to the kernel. This is convoluted.

Catch the #CP exception directly by run_in_user() to avoid the manual
counting of #CP exceptions and the #CP->#GP dance.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/cet.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index e2681886..7635fe34 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,9 +8,6 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static int cp_count;
-static unsigned long invalid_offset = 0xffffffffffffff;
-
 static u64 cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
@@ -54,15 +51,6 @@ static u64 cet_ibt_func(void)
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
-static void handle_cp(struct ex_regs *regs)
-{
-	cp_count++;
-	printf("In #CP exception handler, error_code = 0x%lx\n",
-		regs->error_code);
-	/* Below jmp is expected to trigger #GP */
-	asm("jmpq *%0": :"m"(invalid_offset));
-}
-
 int main(int ac, char **av)
 {
 	char *shstk_virt;
@@ -70,7 +58,6 @@ int main(int ac, char **av)
 	pteval_t pte = 0;
 	bool rvc;
 
-	cp_count = 0;
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
 		printf("SHSTK not enabled\n");
 		return report_summary();
@@ -82,7 +69,6 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	handle_exception(CP_VECTOR, handle_cp);
 
 	/* Allocate one page for shadow-stack. */
 	shstk_virt = alloc_vpage();
@@ -107,15 +93,14 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
-	cp_count = 0;
+	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
+	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.52.0.rc1.455.g30608eb744-goog


