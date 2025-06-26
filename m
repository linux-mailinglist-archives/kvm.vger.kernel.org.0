Return-Path: <kvm+bounces-50796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C4AAE96DC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 437C416C983
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCA3258CD3;
	Thu, 26 Jun 2025 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="vtzlSpvk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E88123B63A
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923309; cv=none; b=mnpPnD0+zButMreHmi/nj2Sv3bIXNJ0anU3+WjQ5SwuuIEHv8tjZC0Ng5HeyghU4dSo8yPyhV52Nw5Iwk4d1FVVzeqZBd16rXhMfVKuO0KdMK5ah7PHlnL0DxniGaJ4uVaGxzcDQrywOQsfwVmUt7nJ2PoFnD9gUknaMcXSVf9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923309; c=relaxed/simple;
	bh=M97TO5Rpeah+bdVcKAXb5RZ1MLF072JfUVD3Xsg0O7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4ijIya9WaVlDdgdsRmez77pM6ppdhD2J3ly2qgK/0vvVvpgCnhD1rWD/dd0dAm00hyHgK9TlIvRzGz4Lrhl+Lysr34SCPUI5UPWMRHz8KLXXIInmw5Bfzg+48QPCzP6eFs7B8h+kHLkKfXaiEU4nd2kJEUgoY2QCHlWSpPe+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=vtzlSpvk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-453426170b6so10287855e9.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923305; x=1751528105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O8lrMYcoX38iZDH1n4L5EtRy/RdAZQsPsDhovmot7DA=;
        b=vtzlSpvk7WaRpi9y2PeoACAE2PsmAPfbBH7HCEBJXIoL5L3cwlDYllS6gFsW0GCyCA
         9ghg8IIc8y41vo8+9RUNm4pL6aCQmhqyrXJSUNtAhgJWVDnuLwSWVygWa5coDOXE9XW2
         HhDc43T51TgE4pk9MUnBIihwqNqTXf39z2MUcriwORjyDEFqOYaHM1nRRmuYqUu2zVbW
         AMhbhWFvbW3hUHX+LEHRllly5y4w4QzwLtPAbq8X6n2G67MV0McIysCGazYGVd8daURp
         WixSv57w3BNUmFtMvdkpzTs2Nurnrdklr1/hBnEyD0hwLv56Ik2gBIIuII9MKSJYUkgN
         1Wlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923305; x=1751528105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8lrMYcoX38iZDH1n4L5EtRy/RdAZQsPsDhovmot7DA=;
        b=wQQ6cSM9F2Q4RqShYFBeovnOQ/rFiu6RkM4LVkeErfmNO7n4dcd5K1iOwFgNunNSCS
         cAlWJe5h/CjROZzEv3v7KzLrZEV+bghzg+naelp5vht1YhJyVFiM0OZLoI6ZVfRYBKgN
         pFhMdeWG13rnq0ouaQgYMtGQJ9YtomApz/+dtzkPdezolhCjaQfss/7R5WBmx3uhVIOd
         ns8UrlKl7jl+3twf3+B6Yk7NjZN38dVb1kXjgGIMZNnyRgn7n7iuLQhbCfDaCTNA+vIj
         N7mv0iNHgraqLt2OCfif5w/asj+3TN5hsNKxfPLQTQG+/V7Xg+lGLe7U/5Tq/wwRb4tj
         B2rg==
X-Forwarded-Encrypted: i=1; AJvYcCWkmI4vSgVuvjDATYpdcbkxWm8bD0yCE8BnOAY0wjGvv+iu9ASLKn3UgBOtZSW+WtkgTUA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdmjSHT+hBEm77og9u06BkOLM2HT5EWesSjnP2tvQyhbN8TRW6
	99xyZsAS+oZdm4KAZA3ahRPzibUuId+4bLzy8hy+I0k0VGMhpBv3kVJK2+rAuwLhiHw=
X-Gm-Gg: ASbGnctm18djOYylMyDGnyTNVKLjg9g8wzAIuH2+46yEfvwRjqjEIfCusZ9mWNxF3Vm
	Jz25r7uIg6oWNXnQxyzBYrPucTdQOdXU41wKJa1fVaZQ7EDGpgplH+x0zD4uE1fn77gmZmULMYd
	ecLYqY4MZz96shS977f84dH4qgloR9QSF2vtgoBpCQlggVhHiZ7YKjNUJiPfJgC0zV95IzIvl8U
	J6PJzQjyyDOC+ukV4BjNuW62JfI/cm0wvdjHve6k0U3EODj4PNlwjNX52k07HLA0XZUtmahS2yL
	HBG5jnlK6lUkmI+52wJqWbb+PsYUI8Z9mdmDUvVeV6NCfyedYbTRFS95w5fMVxvw9TqDmqRVxgS
	mLBuvoMrzYDp5Iag3y1FhUgy+uMcRH14CkvJkI2R+7gNqWPipCKtYuLxSk6Z9H52Xug==
X-Google-Smtp-Source: AGHT+IHktlAz6STrnbCoI9kVgVywiHmCSr5Ebz/C8ieoIiftLwyK6v5M2EAD45uNGvyh8JsDilO+Mw==
X-Received: by 2002:a05:600c:a086:b0:43b:c857:e9d7 with SMTP id 5b1f17b1804b1-453889874a3mr21964175e9.5.1750923305474;
        Thu, 26 Jun 2025 00:35:05 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:05 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 03/13] x86: cet: Directly check for #CP exception in run_in_user()
Date: Thu, 26 Jun 2025 09:34:49 +0200
Message-ID: <20250626073459.12990-4-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chao Gao <chao.gao@intel.com>

Current CET tests validate if a #CP exception is raised by registering
a #CP handler. This handler counts the #CP exceptions and raises a #GP
exception, which is then caught by the run_in_user() infrastructure to
switch back to the kernel. This is convoluted.

Catch the #CP exception directly by run_in_user() to avoid the manual
counting of #CP exceptions and the #CP->#GP dance.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/cet.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index ce4de5e44c35..1ce576fe0291 100644
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
@@ -102,15 +88,14 @@ int main(int ac, char **av)
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
2.47.2


