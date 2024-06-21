Return-Path: <kvm+bounces-20315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CD5913094
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 00:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 555791F22E93
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 22:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3BF16EBE2;
	Fri, 21 Jun 2024 22:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zAxAqElu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBA715D1
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 22:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719010209; cv=none; b=Jz1IcZgfzInut0gPsxb12JsRFCKqgRi2yA4o8V67Gsr1KE3CsYsiXKKo0rImtaTCLF7aAMCuvVqO+eIC81eTfiYPyV9xUjWDpEjJwmItQMIzs1ohqt2fX28XyVcHKwtkqAuTGUwVFzyB+DxDHYPN8ffItTZQmGflgLXb4Dbf6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719010209; c=relaxed/simple;
	bh=3zRIh8KzXJ6Ra6H3n0sDHtr/3zSB/lFhiNs0azBMWes=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PD7sp44jWDGh0OIi/ExQS9ldz3yqNqJeW/tkzsZKC9XM9Ai4qYM6Gdf9GhI+KQJsII9m/aX8mwBXhoyiqtrhoNG8HvNi6EwQQIQLtV+Z7rX76VXi0JTz1iKuoR/FLuSCLnSQlpEDjLpJOb334eJE2sTDxEt5hCB0N+dLWec3SqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zAxAqElu; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7065b598e6cso771650b3a.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 15:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719010207; x=1719615007; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q7RHoEtb8Rzzz6WiOsYTQYUFPpHS28vcIRhAXWsKW58=;
        b=zAxAqElu6JGnKggPhajvzbljOBidOKWncA0AfeFeH/aqOYcz99QvQ/2LeduuPb8K8P
         qY+aCXjvwMOVQ6kCXSpP2pVtfEph/RLQxfRW9utN/+1L771B8yQHJvZ0xBHrEx/PDkoD
         9BLA9zA/+dEmiXGecuhi1SX+1ziUkGsVcsW/MwXzb/qXc8TuOC0L38WvF3+PrScy9y7c
         Ul/3auZOTtRBzK5ZlIrYRZgGdEEEhzaFkubCv+6HHvRabh6iEo95M+KoqoreL9pYDZRK
         owZxI0B26plb1ZicsX/48UknhtjMl9HW3+fhdn1GlzXDRdofNN7gNZ8JOY0CBjt9ID+s
         VhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719010207; x=1719615007;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q7RHoEtb8Rzzz6WiOsYTQYUFPpHS28vcIRhAXWsKW58=;
        b=xVP5BPGj82XZ1KrD6zVQdNka/u8ns9bY/L/ceWYZU51Mi7+5ck9afuXYUC9Q8dmbVb
         WXZBgMxEgeoBD21EfQEKnQtWSvY/N4ZTP4G58eqCfcVT6QiePwaKclhYUwqI6SR82uBx
         vfXTtia/pd3+OtS/ReBbCv5f0V+ZZWdGlDXtgClZqpRqKw9bJ9O1hz3jYzCcxxFatzjS
         MsRTiciAc7T4ck1aA1GkSogGYl7zMaJ4WlRd6+QftfLc/ktQLPxru4/q7iqmTQHcQhyk
         Fri8u+2ATBSIZhlChYBbnFMQDKoDrOKbL6ay5EV4JCLv/5CrARLUWNOqfKwovpL+/kv1
         CBfA==
X-Forwarded-Encrypted: i=1; AJvYcCUwqF6fXIng4I89F76tUjcYWB8s3bLJlbBObqptw7pxjom6arMDDMC8rrql2wKrOq3i2anX1Mxidk5x5xNObUsLao7S
X-Gm-Message-State: AOJu0Yx7V2XedIDGOtieb4mjyPIKkWmFIH4GZmUj1YJPWoWMwP86qhoj
	qNjQpOstHqXfZKYwtr35/ua5bEP+ajtQ+5KVRBmUl0IWeOcJQcNEJ+BeOrpqziPJjJwQkmy2esk
	nliLdM5Apyw==
X-Google-Smtp-Source: AGHT+IGUNSGDCAMvu/N6mc9mTooMoSP2JZcPo0wSCkILZD0T1B3W7g35AqUGS8a7DGzIR/3/bIJH+J1SbP3cyA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:8687:b0:706:29ea:7131 with SMTP
 id d2e1a72fcca58-70629eac8bfmr30394b3a.2.1719010207181; Fri, 21 Jun 2024
 15:50:07 -0700 (PDT)
Date: Fri, 21 Jun 2024 15:48:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240621224946.4083742-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Complain about an attempt to change the APIC base address
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
 arch/x86/kvm/lapic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index acd7d48100a1..5284dddab337 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2583,6 +2583,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 
 	if ((value & MSR_IA32_APICBASE_ENABLE) &&
 	     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
+		vcpu_unimpl(vcpu, "APIC base %#llx is not %#llx",
+			    apic->base_address, APIC_DEFAULT_PHYS_BASE);
 		kvm_set_apicv_inhibit(apic->vcpu->kvm,
 				      APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
 	}
-- 
2.45.2.741.gdbec12cfda-goog


