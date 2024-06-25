Return-Path: <kvm+bounces-20510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3656917513
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 314BD1C21243
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 23:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B4B17FAA9;
	Tue, 25 Jun 2024 23:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K4S8XLkb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F311494DE
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719359766; cv=none; b=A2GeA6hekYNv7UMUAGtuHO63sOFW0Adm4gNG+t5C3iYIXk1Kyhlx9JV+8ebjuV5kjMyxkgQoeCWNR2EUqzYzUBFGTW3R+kpmd5Fpf8ipWuLVlwwFwTY5z91VqAkMqqt3N3FxFZxrd9Ol7llMdpAMGueevxoPYKVbc5EfFdMoELo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719359766; c=relaxed/simple;
	bh=8HVAWnEatRzErHg93AOTBHo6059UvymtLk7JxiwifK0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=J2VHr8PUb+mbYnAutCGMw4qSYxpkBqW/lL5yzUkvwyoryBWmjdhUQAd+n9h3xuWFU2Kz9s48APNs1oKyhaGjJ9Eey5NZYXLgOJo+uGcdXdxbSJpIDoEyctYBsyVamyVsNB1fL9uRTkjd/7f+hZGMllR5ZpsC+bTfxMXqzrKGgYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K4S8XLkb; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-72492056db7so74747a12.0
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 16:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719359764; x=1719964564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u3X1I1Y8ZUf6tVfHHUIKpskeZ4FxLp94vJvfXK6CgwY=;
        b=K4S8XLkbCFwiV+BG3s6EFcqW4fXtxh6JOwq2M35ddoicsyUUHU+y/A1cLMdBPnUP1t
         tID/+T6hVwOZLxwnhNK9Atu3CeDYOgLO2i0zzfPgkZJa+ciLkSafPMnr1X7M+I+s0VDV
         ai2rwBnvZ98x7dd/RharwUXpr9G+5MUK0tsOMB5NkONtS1KedPFxkMoKl18PAUAoEpft
         IZAnfbJK+ohqgyjCy/ncTcqUVOFnlz+VBQYyvoOpaw2v1W64FcujiKvbIo0Ygv09AaIK
         2/LHoqCli7y3qyD1t5qZY+F1LVrBr4raWqws6ib3A4mz2qRzyli/meTsJoxSs0LwHYZr
         ZVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719359764; x=1719964564;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3X1I1Y8ZUf6tVfHHUIKpskeZ4FxLp94vJvfXK6CgwY=;
        b=fV2rJ1H5K63coxDZNl0+w9VfEM5oSRTeyDX36E/ZQvNwKnGrWFOhJuV6cx0A8mHb6O
         0W6CzfGpVmAMrKybSdpyqK3cka3moXnRWSqmHpoZVC7EwkVGyywqoqY6zbsbN2TfQdyb
         sEE6cLKV5aTMbY4re93rgLUWvkDzv3cf9HdqC6zGqR80Kkx9hN949HIkrBw5Y0ncSF9X
         epnyp++9Lb6hmjC03DDeWEYm1WmOMPU0jXtvrvyL+H13qpxlxZixZAxwuF3fAiOkcS/S
         rK48sQSsE7Lyjm5O4m+vVogCR7PG7kwdrFWusKoJk1vqT4URJz1HLdHPBcmlFMC4bGL9
         vO3g==
X-Forwarded-Encrypted: i=1; AJvYcCV0y+5LgTE0ixKSy2Qyj7znqh9NcLwlC/QbJss/Hoao7oQiDWKo+g1JNEe9yPHap0G+3VNpHJeejAzpFzPh+uWdAVVt
X-Gm-Message-State: AOJu0YxvFiC8cRfRZuvKtVeAyNi3UvQCakuMjbtVV/fpZ48IP/HJ612o
	6t6Msa2eduDIq1f589+NA+P+OjknVP/YVI75Zx7bB+DweTSYIeD7Rso4l+z+HUbiJ6uHJZC1S94
	N3kA7q/tIEA==
X-Google-Smtp-Source: AGHT+IFPnj57GoSmYTiLRNINE2X7pTVJT3ux5c8j3vt9pY2jqQGKbJZWT+Y5reQUo57kLJ8xAbY2SHl+rBfn2A==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a63:b514:0:b0:6f3:b24:6c27 with SMTP id
 41be03b00d2f7-71acab11218mr24870a12.5.1719359764319; Tue, 25 Jun 2024
 16:56:04 -0700 (PDT)
Date: Tue, 25 Jun 2024 16:53:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240625235554.2576349-1-jmattson@google.com>
Subject: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

KVM does not support changing the APIC's base address. Prior to commit
3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or
APIC base"), it emitted a rate-limited warning about this. Now, it's
just silently broken.

Use vcpu_unimpl() to complain about this unsupported operation. Even a
rate-limited error message is better than complete silence.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 Changes in v2:
  * Changed format specifiers from "%#llx" to "%#x"
  * Cast apic->base_address to unsigned int for printing
 
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index acd7d48100a1..43ac05d10b2e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2583,6 +2583,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
 	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
+		vcpu_unimpl(vcpu, "APIC base %#x is not %#x",
+			    (unsigned int)apic->base_address,
+			    APIC_DEFAULT_PHYS_BASE);
 		kvm_set_apicv_inhibit(apic->vcpu->kvm,
 				      APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 	}
-- 
2.45.2.741.gdbec12cfda-goog


