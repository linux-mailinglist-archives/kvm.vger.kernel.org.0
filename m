Return-Path: <kvm+bounces-50797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7E62AE96DE
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4918A7AF716
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACF225B31A;
	Thu, 26 Jun 2025 07:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="aS0dmyBP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D71F2264B3
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923309; cv=none; b=OcivSRCwmokzS/GZ4v3GN+syv0/fZ03yEiwRsEVGcB2gchkTmkF3jcWMT2/3MEfdA8l8em5Wfdid2rpSTrmrj6+s7So7rZNmm760yp7uScep4b6Epgh4YiBixGcbihZdNnDugF1ynXY/ppfL72r1hBl+rSab1ja2eRbtBKxFwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923309; c=relaxed/simple;
	bh=gZwlXtsirOJZl9wk+y956YP67MFujv2ImZPskymqzwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPmnzJ3l75XGk7LowKop88AagnoDry1UbsvyeNr3eS6a2RNy46/BlLKGu5Suvof20fiOz7Gd1CBDF4/c1tARAsv2BLjGBhSP6ob6yrJY5IVgnsVIlbVAIVDcZx3i9GfycPDfOiActREd8BND09e4/c/S5p8XXAq5m2svvLqehBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=aS0dmyBP; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a531fcaa05so317440f8f.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923306; x=1751528106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rz21YNk1k1BPAOWAOeFIR4OW2Dy91zF5/U1l9ircQXs=;
        b=aS0dmyBPlV+twjJwl0KxbJQE0H5fFEF6pKtZ2roOPlPkLRx5UT7k+EJ4T7In9NZWMs
         T/1QTYH0OIr0MIf10gKQqQluzPWN26aI4C1jBtI6XexAVC8f6+9Xg0MlWEzCKh7qE9Wc
         9KLYEmFGSmYSh5RsZcQLapgo8ApL5Wgfn6l+LEyZK43ye3O2bP8dAfg5yp+rXeybrbXX
         +TEjaqjMVUEWvbSHf4tHOwk92t/3hSm/x93AfhWuJiJKQca0aVo0Rarop8qd5cUQO2UF
         +w8ErBBAvDh/1phKl736xqrj7pB+tCRIAF9neJEd+yEY5BUckQHv6HDdT13+zCgjAFcq
         IwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923306; x=1751528106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rz21YNk1k1BPAOWAOeFIR4OW2Dy91zF5/U1l9ircQXs=;
        b=WFFnRRnRY3iNrfWIpQIRD+NUZCMPr+TR+/rehlaDQnWwvGXitZtm+HLT9UU2g6LRSd
         /QkBZo1Qi5gToMhtDTz6JfzUfdAH5eLSrUhFRMPrkEH9PnEyI8QKbcPxeyoiaQ+zLaVb
         3J73GlJ15qeYkbocGXPCOTJ2l7xtP0kzhDSZic+AKJaAh4sv5m6AIU10aRbgT2UOUu0K
         U3057ZwaLALZsJJ88zikVyeWHEGLu6u6BZp/cEWal8TUSFcmc7bX65BY+EpRnQghSIKZ
         Tz75HEc2pRuhpnio6o8MrQ/HU4jTfInnKkLBbMCb6bY6KrzpecPrdKR6fVY/i8+Vxbld
         exaw==
X-Forwarded-Encrypted: i=1; AJvYcCXLB0zUk+ZBMfOGgqq6+kMsUDcdR/x0ddv/LPavk+giAkqlKW4/+Obqq2/OmlUhY0J+G80=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPbXXBKLj7m0JEpkg22bnCYOnRDa5M0r3O0Bg/NyTDmfcLPu2G
	wqy+t0CAKCWFhIgJXIHWphjCLt4PwJhD9JIqLe/0KbUWddHa1ROVFA49JwVlj2e2owduKldyhhu
	Q1c5X
X-Gm-Gg: ASbGncs0nB/a5YLI3Gc92SbdNTKflSEnYL7dGlFg/QVKmkGo+JnwZwPnpdqpzpqgcYR
	PVGU869nvTEh1115zINL+P3FkMXU6nPJHrj3PTcFruS2rqWMWGbQb2D0LyQi4gabAOPErkoeSHA
	IFSLOJxQ9RXcX3cJFdN0qGIGnoie4VePWFkyqfAeLFmvYNIv1zXSdZcYoH4y+PNNWpy7sjDYOlJ
	vvo6TexhcGx4vrorKJTjokAT/A8oBA8IxUCMn0IS4lQIxtF+wtOHdhlpMcJRbKeVjntMTjEng/1
	zyqlaRF/sVYrfuZvLvBzBfoi/Fiop7sV5G0exta3PNWhtXK8xyn/LdFlJ38bALkjAGQ+nmzyqAp
	DHZbeaoA3x8mNSmeTfeplya+oQa6XyxndyM6AQJEj87AravmK5JL2slT6VIJHaGkWPg==
X-Google-Smtp-Source: AGHT+IEaJbKrF8hgOXus9lwoYHA9Q8dK6g4+1IHYxEmdR/vvsTVXQzB6Uptl6dyKp1PAbtKj1OFyXQ==
X-Received: by 2002:a05:6000:41f8:b0:3a5:2b75:56cc with SMTP id ffacd0b85a97d-3a6ed6161camr4882923f8f.23.1750923306330;
        Thu, 26 Jun 2025 00:35:06 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:06 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 04/13] x86: cet: Validate #CP error code
Date: Thu, 26 Jun 2025 09:34:50 +0200
Message-ID: <20250626073459.12990-5-minipli@grsecurity.net>
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

The #CP exceptions include an error code that provides additional
information about how the exception occurred. Previously, CET tests simply
printed these error codes without validation.

Enhance the CET tests to validate the #CP error code.

This requires the run_in_user() infrastructure to catch the exception
vector, error code, and rflags, similar to what check_exception_table()
does.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/x86/usermode.c | 4 ++++
 x86/cet.c          | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
index c3ec0ad763d3..f896e3bdcbdb 100644
--- a/lib/x86/usermode.c
+++ b/lib/x86/usermode.c
@@ -23,6 +23,10 @@ static void restore_exec_to_jmpbuf(void)
 
 static void restore_exec_to_jmpbuf_exception_handler(struct ex_regs *regs)
 {
+	this_cpu_write_exception_vector(regs->vector);
+	this_cpu_write_exception_rflags_rf((regs->rflags >> 16) & 1);
+	this_cpu_write_exception_error_code(regs->error_code);
+
 	/* longjmp must happen after iret, so do not do it now.  */
 	regs->rip = (unsigned long)&restore_exec_to_jmpbuf;
 	regs->cs = KERNEL_CS;
diff --git a/x86/cet.c b/x86/cet.c
index 1ce576fe0291..b9699b0de787 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -89,13 +89,13 @@ int main(int ac, char **av)
 
 	printf("Unit test for CET user mode...\n");
 	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Shadow-stack protection test.");
+	report(rvc && exception_error_code() == 1, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
 	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(rvc, "Indirect-branch tracking test.");
+	report(rvc && exception_error_code() == 3, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.47.2


