Return-Path: <kvm+bounces-48437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF99CACE466
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80DE41774DC
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A428D20298C;
	Wed,  4 Jun 2025 18:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yk5MkexI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B0D1F4625
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062188; cv=none; b=TEFKQBkJ/hKPu63hPDaKXQ5giHOTshf3jBHWQjH9U6DK5WrPTWfIeJeIVPy2cERZrSoz/kepp6JbbHVRSd5xlT1MmZ2JPLhx3cSz185iVnWJ91mu1+nmZxccfXiDzGfM6+KeYtY6JS9mnQmseacByzyIoAk3k+mzoITufzcbgOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062188; c=relaxed/simple;
	bh=wSPwbN3ieuAA5i3QnwoarFT0xAdW7EAvujIHvCeUWc0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WCiGEWtuf95/hv0EXQL/eAmPLbvgeTTuA4Dn6GA3UhBe1xS2hL6paKY6aAGnhq0bKdgFcUEMOw9hR5pQbzOcGau4x2QnjeJAjbFxA+uUliGW3uJIR78ero9YOtfuIKAor6slZmWSz0Xadu9QrViXjEvW0rgV//z+CHMN10Yeat8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yk5MkexI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eb60594e8so45068a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062187; x=1749666987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=97FxH47iTaBMm78jE/zI3TMEscE6CMGLr7jm7IAdfCY=;
        b=Yk5MkexIH2ec6X6y2nkbrWSrLYqY0naK+XIjc0zGPWvXyxSUAt/knQK8O7b2KlHM6i
         QRj7yNCQEWxXA3xvInPYxepEx1mfNDUHR9bhOCdVgcS7wPFbsX10hIpVe7/IlMb668LB
         AMdJEEmY+EBJBEX9em2KVEVDt9fpBnu3+wRNLzxClvjL3/KzqwiKGG9GrHCEd+C5agHo
         /h4thxUL7eKMvtaiFJgHI/Tp64JyYs36ASJRWFT00HMws9t7DS2F0ny3j8/EEBqHUkWR
         F5ANGQpfys19tbWqYd227OqVsSsUPyIsHXZMyBcFcczvUDW8HlzyxSA4goLbETkZveoU
         iHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062187; x=1749666987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97FxH47iTaBMm78jE/zI3TMEscE6CMGLr7jm7IAdfCY=;
        b=o5kXNidhmPBLKIsOJ3fvXxZRySPLr7LI+EB5TrRWIpZpCWtjQ3LpMMijK9DfUWEdQt
         LuNH1TR5vn7xYGewRZQwUjXVzlrH3xOXloZrgWDJS5xWYsPgIgiGok10eYM+Q48IeZCn
         MIxD6XMYJ1mPVetl6AcWBce3OBqzOGJkEog20QpZCL09b8fMRuRmTqw9kxZmnIUnzupe
         OfPsI59fxFDtA8y0F9/kRqpiAfr+Z9zyHELv7VqKL4eKJ7ptVUcoK6+Womgj7twXehFd
         uXFOX/0w1aoA+6O/zXWgNXBSK66H43c5OF2odcNeYMz/99SM3OD9MbBN4UDsfQ4FNKlj
         cVoA==
X-Gm-Message-State: AOJu0YwDsmtlB4V3kT3vCqd0Qq/DHV8rf4CRDRsh22/sf0TixY2qTnar
	kD0HBicMjjQTpPt5SFvtGwJzudpmbXUCsbhiV8VB865DVtZU4TUSiICi0K4/v9IFksSnpK4bp4m
	dSbaU6w==
X-Google-Smtp-Source: AGHT+IFnxY7STefTL+jyJ8A6cOBHcZKwHpczDcYW1wNXuuG04LWfS7rSKYS8HUItbV9cBblm1XlAYXYvel8=
X-Received: from pfbde15.prod.google.com ([2002:a05:6a00:468f:b0:746:21c4:c07a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da0:b0:215:e818:9fe5
 with SMTP id adf61e73a8af0-21d22c0ed97mr5841595637.18.1749062186740; Wed, 04
 Jun 2025 11:36:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:18 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/6] x86: Call setup_idt() from start{32,64}(),
 not from smp_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Call setup_idt() from the (non-EFI) 32-bit and 64-bit BSP boot paths so
that setup_idt() is called exactly once for all flavors.  To be able to
handle #VC, EFI calls setup_idt() early on, before smp_init().

This will allow moving the call to load_idt() into setup_idt(), without
creating weirdness, which in turn will allow taking faults in setup_idt(),
e.g. to probe for forced emulation support.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/smp.c  | 1 -
 x86/cstart.S   | 1 +
 x86/cstart64.S | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 9706072a..366e184c 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -146,7 +146,6 @@ void smp_init(void)
 	int i;
 	void ipi_entry(void);
 
-	setup_idt();
 	init_apic_map();
 	set_idt_entry(IPI_VECTOR, ipi_entry, 0);
 
diff --git a/x86/cstart.S b/x86/cstart.S
index 96e79a47..ded6f91b 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -109,6 +109,7 @@ ap_start32:
 
 start32:
 	setup_tr_and_percpu
+	call setup_idt
 	call reset_apic
 	call save_id
 	call mask_pic_interrupts
diff --git a/x86/cstart64.S b/x86/cstart64.S
index f3c398a5..9c1adad9 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -106,6 +106,7 @@ gdt32_end:
 .code64
 start64:
 	call load_idt
+	call setup_idt
 	load_tss
 	call reset_apic
 	call mask_pic_interrupts
-- 
2.49.0.1266.g31b7d2e469-goog


