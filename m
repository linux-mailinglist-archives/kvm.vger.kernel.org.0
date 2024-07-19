Return-Path: <kvm+bounces-21974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 738A8937E0F
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DB821F21B4B
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F881149C40;
	Fri, 19 Jul 2024 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqtAqOen"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6049C1494A0
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721432632; cv=none; b=mizh1dlOKlzbmH5/OQ/YaJ3RfrAM+hYv/8+EhfLgJ3ENLuNMRSkjt+8m75yPcOa+Jgt8g7ymFC9hTQx9ZsBr8jY7y2U4vm3PlxztGnbA/CyFfogEvGBheBS8fmuT44Jfk5irLo4BMGwVePAQIh7k75YGGMUnM8YyTn8qj0yhKxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721432632; c=relaxed/simple;
	bh=9VC1o23EyPnmCsIUXN13mbYo4nMy/PcXMeGVi57HKHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XTSVuIyrwKuS6JKiOeHXJZmgd24ibc9BmE16fBdwZJI5excavu/ptjsABKELGTUpIUvtxQ5Da531ruBavhYtSySHfvKWvUZszvy8/fFla8JSgLqZW5PjD+0/a7ji/6D3cUpRHekg/uRPiQVs/dJ+TqpvodTRbvSmLHC/pwUR4gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fqtAqOen; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70af5f8def2so1324886b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721432630; x=1722037430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7GRI70QT0vlqusEkjG3FXqYLsYvXxnP78B7joN4qu0=;
        b=fqtAqOenea+jug6vhkcKDsRqx79hWEdz8f73cYIH2iI9nSsvRBd5IAQbwG7NtpzlSC
         b+l8enHTY862ktDxs+ACVJIfNz6nCYuWLWyP/D8rGk+cvAEYkRtgYcxe9U1BhnHqYGy8
         VGaGWGr7lFKj9gTMbaVj2S5gJpeREVaWp5ofet9c1FP5oC1+9XwHnQGPxXWSzeaJoJZZ
         hploaa4T5/NjXb8dyjkSGQdqNDVO+EUcCe+OAk/WcXDkUb9YXzlHBMgL/YHtJyeabY6U
         Z6J66QlZaLgVpxEb/gsw2t4xfTp3jYESuZOQIMdWTwcNcSUr38jeP4VL85AW9Bc9ZNht
         YQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721432630; x=1722037430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7GRI70QT0vlqusEkjG3FXqYLsYvXxnP78B7joN4qu0=;
        b=ooRGoq8k98CHkAV7xgUPbyKJjEg0GaF+cFcCIj8Z85PDz0vUYbol5JYy5jsDaFIiGU
         qcPwF0CWfS4E0cEv4pbQXLlDNgN7wqA7YzeesiTQ9fw64BARld6GhdwRcE5uEjjn/Jrr
         /9KFJIubympM6zfJHCkUK8Pk0+Xo924V8KUuIthDThXlXRF25dXxtrB/dZkols1aFUkt
         EMj226c7Ox2Lsm8O5AbmMoKE2lraGhHNbv6DdJvBSDsal1scQ6lmn0j+AaBX4BQ/9oKZ
         JKWYGAxo2jMaL+YovhbumXIyMD2JDGi0jcPUS4Rh8vQfKkeDzMywan5eQA+W289BR85X
         zsAQ==
X-Gm-Message-State: AOJu0Yzv7mWM2lqKbDJ5iU1WZ9cMLCzLiAUHC47R3moOYypG7U4SvJlg
	nises0koqeDELYcDnyI6YWTX0vYVPx/z75olmIomMdVu0d+fJjnejd7J2gs66GrZ6mn4WrCGBWJ
	UBw==
X-Google-Smtp-Source: AGHT+IEiuM3Z91qDjQNlWIAL1YtO0VXEuZifNLzsyyzV/85gD4e0QNR3MJvKRnBVzqGPUl26Tn7sPfzVK4g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3991:b0:706:71b3:d7cf with SMTP id
 d2e1a72fcca58-70d0845c0d5mr6033b3a.0.1721432630110; Fri, 19 Jul 2024 16:43:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:43:38 -0700
In-Reply-To: <20240719234346.3020464-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240719234346.3020464-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719234346.3020464-2-seanjc@google.com>
Subject: [PATCH 1/8] KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

Inject a #GP on a WRMSR(ICR) that attempts to set any reserved bits that
are must-be-zero on both Intel and AMD, i.e. any reserved bits other than
the BUSY bit, which Intel ignores and basically says is undefined.

KVM's xapic_state_test selftest has been fudging the bug since commit
4b88b1a518b3 ("KVM: selftests: Enhance handling WRMSR ICR register in
x2APIC mode"), which essentially removed the testcase instead of fixing
the bug.

WARN if the nodecode path triggers a #GP, as the CPU is supposed to check
reserved bits for ICR when it's partially virtualized.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a7172ba59ad2..35c4567567a2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2472,7 +2472,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 	 * maybe-unecessary write, and both are in the noise anyways.
 	 */
 	if (apic_x2apic_mode(apic) && offset == APIC_ICR)
-		kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR));
+		WARN_ON_ONCE(kvm_x2apic_icr_write(apic, kvm_lapic_get_reg64(apic, APIC_ICR)));
 	else
 		kvm_lapic_reg_write(apic, offset, kvm_lapic_get_reg(apic, offset));
 }
@@ -3186,8 +3186,21 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 	return 0;
 }
 
+#define X2APIC_ICR_RESERVED_BITS (GENMASK_ULL(31, 20) | GENMASK_ULL(17, 16) | BIT(13))
+
 int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
 {
+	if (data & X2APIC_ICR_RESERVED_BITS)
+		return 1;
+
+	/*
+	 * The BUSY bit is reserved on both Intel and AMD in x2APIC mode, but
+	 * only AMD requires it to be zero, Intel essentially just ignores the
+	 * bit.  And if IPI virtualization (Intel) or x2AVIC (AMD) is enabled,
+	 * the CPU performs the reserved bits checks, i.e. the underlying CPU
+	 * behavior will "win".  Arbitrarily clear the BUSY bit, as there is no
+	 * sane way to provide consistent behavior with respect to hardware.
+	 */
 	data &= ~APIC_ICR_BUSY;
 
 	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
-- 
2.45.2.1089.g2a221341d9-goog


