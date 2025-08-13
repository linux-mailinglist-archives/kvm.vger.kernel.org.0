Return-Path: <kvm+bounces-54611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 409A9B254E5
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 23:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4211B5A09EF
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 21:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219892F9995;
	Wed, 13 Aug 2025 21:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="ZqcxVeOg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91849295D91
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 21:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755118811; cv=none; b=hU1s7SCo/pcFUl2VDxaxRhEVc9PgdA+pKk2ecgpAFZHp5rhcZf0I29dQLE80iG3rDHaIh0ok8ZiivtRQxVC7G5F3fGUTG7pk+lbywrT0zrzTpYpomYp4WTDeSrdzKvXSx5/Av4qzq7C4i1e60bOClts7yZD+cPAJsIg4JdiPmzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755118811; c=relaxed/simple;
	bh=3c2a2skHRpE+mGqSPR/NEnu/8+vWFYIf/noO11bitU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LYgMZ5hyMZ5oSUBNhyO3pbIWKayklrFwN8gG1V6V6jzbwR6NXOuL6eqh3f9lixMj6u020ovS0VJXK/iibDfozqk/UYRKsM87jWB17hdTzJRFjwOF/3U4vvH2uskLggo0Jmsl5MjTkHwEWHYz5Pj+yNGMUozGdVZZlIR2Q3Yyuc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=ZqcxVeOg; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32326793a85so312480a91.1
        for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 14:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1755118808; x=1755723608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5eLiIt9u895aiPm246tdxZtX0UgwU4Q0T4u/dRMEv9A=;
        b=ZqcxVeOgFIZdRPYkeAzxokyBwxgxCSv3YO0igm4dgR//UPqBZrzPrOegW2tH+A5fnj
         xfRNIn71WhRzC17qNLDdVGVkmhhkSMr8ox0JAdL1tpSKCGYoD+Jz6A24LZuRrCLrk0uW
         P/03FvrurD+CWRHOXGDb1NtTSaiY1rel/Zpw/kzELIdHt6qcZPblmE9TbaMVHoPkDFzX
         Qo+haRqC5o/iwu+lo8ZjOuacYzRhHT597M9IFln8cibozASVat6gfQMkJQimBU0dibDg
         4E2nEqY5xvLnl0+LDr0kGs1jlQBp/0bOJ/PB3b64TNr4yoGzj9QsGl/hV5UGVPWQqTfO
         WK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755118808; x=1755723608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eLiIt9u895aiPm246tdxZtX0UgwU4Q0T4u/dRMEv9A=;
        b=crqQGGcWkCd4WVfo0lkQKUsPhf8QLt2jHgz2V0E75JnL09AAbMVDTSw57PKKsKPsA1
         4HaIOSPBSErIaMmBxexAXTLyO0GQ2RW9D7ucms6kOdcbCSAXOFBHoLwQrak4EAu7khKt
         Y0ERygvjpi4a2f5qa0pdfcr57M52lNOFK5AJJHSzSybddOfda909t46R6ovGDUFneioc
         532b2CziGcF/qQ2iq0lq2ucEvX76pf+VlhLbsFqla3AsMKRXO3M2sGGla5FHsoWnCxPL
         PdacMTPSoccMuBPgH92cRgL9Kjin88eLxXTd9onawjHZnRVRKkVi3MbsS2aP+WUxtk2e
         1tbw==
X-Gm-Message-State: AOJu0YxUIlcVTZb1ii06Q1S7O9g+16zAfIVcDrkQRd1MB87X6zV/RynG
	lN13/818/0A/f4ZqDrWu4zNlv5knmVYJ9/N9CErTWvqyrK5dDgQ3sjYBKeUTLsX9Sst9uOo/Omn
	lemTzVJEg1g==
X-Gm-Gg: ASbGncuLwjTvFjr8FA2VGGAMvVvnpQhUhnc7jQDGaQnv8lzqXAE7teensMS30r5KvNp
	aUErlWc3LiEK2+HYRao2mUM5HlN+qZiv+F2tq169mXZtwKNkJnYzkZSUi31vRKnD4K/bd61SaqM
	US5AYBUTWkruxzON78Da3hcA5QdNsygwBqK+aPzpzZtnJ73+L46tgdzCDuI0inV7IzRK0Vq/Q4x
	8TQ2xFvF3Pva8OSa1Mx8PdQnrZQWF3wQlRWzDHoic3xSiUd8bSJc3w8k1+Iajbgj7Zw6WoNq8j7
	3qIZoaNonLZI/vWVt/JaNVFyCZitipjKPmbhvjtj+DC+MVj42LvEenvrF+StreKxI2qdCMK1P1J
	lQVA9XnpdEqaRjAkrLyu5Tg/6GhO3jeQczofZ17yC3JsnraAulF3ki0OwzpZ4DxVEckRcn8YsER
	ObXf6Fr6SeReOoHsVbDnu2kOQ2LqDEYbteJPyZ24g=
X-Google-Smtp-Source: AGHT+IEXJdeyuZrTaJf/ZC2UNbTT2svIrtVLyam9egGc2fXU0o9BYIyVhEPHIKqfaUK6duZ/rcdqXw==
X-Received: by 2002:a17:90b:58cf:b0:321:2b8a:430a with SMTP id 98e67ed59e1d1-32327b495f9mr872457a91.28.1755118808081;
        Wed, 13 Aug 2025 14:00:08 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf00da00c2a4b02ad8ab5b75.dip0.t-ipconnect.de. [2003:fa:af00:da00:c2a4:b02a:d8ab:5b75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232579deefsm950490a91.21.2025.08.13.14.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 14:00:07 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: kvm@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3] KVM: VMX: Make CR4.CET a guest owned bit
Date: Wed, 13 Aug 2025 22:59:56 +0200
Message-ID: <20250813205957.14135-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make CR4.CET a guest-owned bit under VMX by extending
KVM_POSSIBLE_CR4_GUEST_BITS accordingly.

There's no need to intercept changes to CR4.CET, as it's neither
included in KVM's MMU role bits, nor does KVM specifically care about
the actual value of a (nested) guest's CR4.CET value, beside for
enforcing architectural constraints, i.e. make sure that CR0.WP=1 if
CR4.CET=1.

Intercepting writes to CR4.CET is particularly bad for grsecurity
kernels with KERNEXEC or, even worse, KERNSEAL enabled. These features
heavily make use of read-only kernel objects and use a cpu-local CR0.WP
toggle to override it, when needed. Under a CET-enabled kernel, this
also requires toggling CR4.CET, hence the motivation to make it
guest-owned.

Using the old test from [1] gives the following runtime numbers (perf
stat -r 5 ssdd 10 50000):

* grsec guest on linux-6.16-rc5 + cet patches:
  2.4647 +- 0.0706 seconds time elapsed  ( +-  2.86% )

* grsec guest on linux-6.16-rc5 + cet patches + CR4.CET guest-owned:
  1.5648 +- 0.0240 seconds time elapsed  ( +-  1.53% )

Not only does not intercepting CR4.CET make the test run ~35% faster,
it's also more stable with less fluctuation due to fewer VMEXITs.

Therefore, make CR4.CET a guest-owned bit where possible.

This change is VMX-specific, as SVM has no such fine-grained control
register intercept control.

If KVM's assumptions regarding MMU role handling wrt. a guest's CR4.CET
value ever change, the BUILD_BUG_ON()s related to KVM_MMU_CR4_ROLE_BITS
and KVM_POSSIBLE_CR4_GUEST_BITS will catch that early.

Link: https://lore.kernel.org/kvm/20230322013731.102955-1-minipli@grsecurity.net/ [1]
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
This patch needs to go on top of Chao's KVM+CET series:
https://lore.kernel.org/kvm/20250812025606.74625-1-chao.gao@intel.com/

v3:
- reword changelog slightly to match style
- pick up Reviewed-by from Chao Gao

v2:
- provide motivation and performance numbers

 arch/x86/kvm/kvm_cache_regs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 36a8786db291..8ddb01191d6f 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,8 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE \
+	 | X86_CR4_CET)
 
 #define X86_CR0_PDPTR_BITS    (X86_CR0_CD | X86_CR0_NW | X86_CR0_PG)
 #define X86_CR4_TLBFLUSH_BITS (X86_CR4_PGE | X86_CR4_PCIDE | X86_CR4_PAE | X86_CR4_SMEP)
-- 
2.50.1


