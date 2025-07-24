Return-Path: <kvm+bounces-53402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AB46B111D4
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78BD1C8820F
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352DE2EF2B8;
	Thu, 24 Jul 2025 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="46MSUgyl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="za+N3V8J"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8632EF2A6;
	Thu, 24 Jul 2025 19:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753385849; cv=none; b=h64cSF6bhKZzcHEt7YfFqemYrINeITuVmGx5xmeUh+wxvYceBJLcO1qxn3TMIrO94E2I6KyR9VZNWawh0JqS/JPCZq09P4QbjtoZ6Ncvgjx4JM4wJ3fGEewpkhQCKeA+VeqXDJ0bLSbbqwRsE952yQ/QNMTRV/UzqAjEir3Ne1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753385849; c=relaxed/simple;
	bh=NqhvlfUYaDV/+2XHHooAozZ1Ma4TP4Tc6co3ykPUrHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYzwJQ2ImXAeHmFS1wehon4ZuzlTumicyJBfwHeujY5YM4y/L9cHp5eFZKZYYuRgjneRIGroVFLMcOnDHbET2f34EG0t1fPlEyiRC/+aui9a0VvtQmhLICAfgyUViVyPPjsxk3plvRY1MOEWnfsVn/WazMBBYURunW3CKjAtLzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=46MSUgyl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=za+N3V8J; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: "Ahmed S. Darwish" <darwi@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753385845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=46MSUgylEQfR+x1hgiGTV8bUgoRn0bWZL4f0hoTq5sFgf7QuuSH81iN7AtcqbZbQvYfj77
	pAlQ3gz6AK7rL/y6o1ne+36SWQd0HjfzAvlR0rdAZoaGTNIj4xkKOohvjU3+pL8nSpQ7L3
	TKidQaHkeueKAy+AwwkDqBDaiV/vKdLiHCv9nuZczlMGl/tpIDBJvKU0ltQ7SOHBC2jYy5
	oelNm194RsuhNO+Cuc3hTB1kdK11UHsw3tzIU7A7ck0u4X2k92dpDMX1BQ7M3xngfjRRMI
	lZjRBG2UDplnb0PULuqGCGEEjCzzoOiAgChVLEBQrkvnELRAxq7FYXaMF3ubpw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753385845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAEsC2skIOSaWZt2MlflxtyQsbT7+BYF8vFWwagm9QY=;
	b=za+N3V8JyilLKN1ZX26xkbhA2opJgMn9iX70ZLPUfLrioz8y7UmVanvqAI5y69IskNHjnN
	sKu6+9Oz4f4UJ7AQ==
To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Ogness <john.ogness@linutronix.de>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	x86-cpuid@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>
Subject: [PATCH v5 4/4] x86/cpu: <asm/processor.h>: Do not include the CPUID API header
Date: Thu, 24 Jul 2025 21:37:05 +0200
Message-ID: <20250724193706.35896-5-darwi@linutronix.de>
In-Reply-To: <20250724193706.35896-1-darwi@linutronix.de>
References: <20250724193706.35896-1-darwi@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

<asm/processor.h> includes the main CPUID API header <asm/cpuid/api.h>
but it does not need it.

Remove the include.

Note, this allows the CPUID API header to include <asm/processor.h> at a
later step, which is needed for the upcoming CPUID model and parser,
without introducing a circular dependency.

Note, all call sites which implicitly included the CPUID API header
through <asm/processor.h> have been already modified to explicitly
include the CPUID API instead.

Signed-off-by: Ahmed S. Darwish <darwi@linutronix.de>
---
 arch/x86/include/asm/processor.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bde58f6510ac..910e36b0c00d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -16,7 +16,6 @@ struct vm86;
 #include <uapi/asm/sigcontext.h>
 #include <asm/current.h>
 #include <asm/cpufeatures.h>
-#include <asm/cpuid/api.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
-- 
2.50.1


