Return-Path: <kvm+bounces-13777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 320FF89A7AE
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DF211F210F6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627D258AA0;
	Fri,  5 Apr 2024 23:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p3kzgsFL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D5355E58
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361381; cv=none; b=Fu0xk+Q16cNiv5WQYevzJG2R0Y2CrtRKKxGss/nHB4XSaFrabd3PyrK9/MYSEuxwfI1GuSBSqLWN3Kpb56ofDf9TX+W9ZiVE0cxuYZXn8z5+EfP6QWnt/plXlttJNekSrQ9OGhWu5JF0Jfy3wv+xOqOVm2HX8jte64/473mwv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361381; c=relaxed/simple;
	bh=SjL/u1m2Yv/QRFJSraA0c31ZdkVwSK2OEnA/q8Dl4T4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YisaB6nDkAoFzfA7N+GJMujMFvzApUUoYVgp30kYc7pLxx7lgmRr0VgMKq/vItL/9ua92r4chUF/xdjqrEYB2yuOhrpobXasNZy1iXAmgNblUDvzGVrkyYEAWSXpRBcpwGjW0kHZQZRToj5n9RC06ZduFWr0deucc1hD2vkg8DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p3kzgsFL; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ece02cfbf2so2302331b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361379; x=1712966179; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=dc7nqkLts1TDH13FpbqcVsZjCzE8xryBRB3cO5xkb48=;
        b=p3kzgsFLGmqGYFnyqpmXELrBWRsKSbHyiNDaoqtneGEwuUWA9jZBFop+TJZ1wjhWwI
         b7OcfZZ/ljjB+WqWG8XTblOQwVOc4TmK+0Nl+CeMbLLZvg2XPvInJQSA8E0kJx3DyppL
         cLhiKiG/X7oQ0TN/RV2QWYUDw09WFG3VMT8Pa6RpvCly3j2E2i+WyLyawuXAXgOLuOib
         KPd233oXdjw6xKBPgFnIuKSfThiYFb6YsWDE85MYhM3HCf6p4iIoDFnW8sienWIzlGnx
         5Ktx9z5f8wQST1+6S8PHe0tDqql89yC28Xw98wzM2L1mm6ytLLFRrLYmQUaWuPz+wl+l
         iClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361379; x=1712966179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dc7nqkLts1TDH13FpbqcVsZjCzE8xryBRB3cO5xkb48=;
        b=CvUyS6yg5VUDTrmZansDfhmhd+29XS6OsTXev4r/UX32FK/shlrM22o7qBTErfuqT6
         goKfhfodcKiPR1ATnvoO3CD/XOJeMWyBye6iDxtHMvfav8DGeA0yE5+5pZarUuSi1F76
         lFroLxmBIgKpft1Cy0BJvM5Nqq3qMgADhUiey93rMAmrZmhB1UQU5nHSde5Y8z0czH20
         C/zCqOIoZUEysZDSR2s0vPldY4xBBeq0XjBeHTmjJ53qfJrhY2/m5a3skkW2yl3GQkHK
         FZ6+W04gZHcBgs1pvsUV3rR8rNUtxz/NcAl2j53BCBIWPNmM2VqLQoSEthjH4g4GykWw
         2x4g==
X-Gm-Message-State: AOJu0YzyGvDQFfnI8beebgq18gl3r2IT0lBb0/OWPWgmNE2tyUtSFnsG
	U6ho9EzLdRorjUaDTI95amfXjFmkc2YeEyuAiytvGxlZWG0OR/ET7O/reZdgvSWi3hCnvbxd7MD
	YCA==
X-Google-Smtp-Source: AGHT+IHgLgfMouF5Fr9j95xTXSHpDYGHdGZywxLUroJfpTjaxfmeAcot/L0Rnzk/8SgWunlRcEKDGyS7IR8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:92a6:b0:6ea:d61b:ec8d with SMTP id
 jw38-20020a056a0092a600b006ead61bec8dmr235502pfb.5.1712361379288; Fri, 05 Apr
 2024 16:56:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:55:59 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-7-seanjc@google.com>
Subject: [PATCH 06/10] KVM: x86: Use "is Intel compatible" helper to emulate
 SYSCALL in !64-bit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Use guest_cpuid_is_intel_compatible() to determine whether SYSCALL in
32-bit Protected Mode (including Compatibility Mode) should #UD or succeed.
The existing code already does the exact equivalent of
guest_cpuid_is_intel_compatible(), just in a rather roundabout way.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 45 ++++++++------------------------------
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/x86.c         |  6 +++++
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5d4c86133453..1fb73d96bdf0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2363,41 +2363,6 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
 	return is_guest_vendor_intel(ebx, ecx, edx);
 }
 
-static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
-{
-	const struct x86_emulate_ops *ops = ctxt->ops;
-	u32 eax, ebx, ecx, edx;
-
-	/*
-	 * syscall should always be enabled in longmode - so only become
-	 * vendor specific (cpuid) if other modes are active...
-	 */
-	if (ctxt->mode == X86EMUL_MODE_PROT64)
-		return true;
-
-	eax = 0x00000000;
-	ecx = 0x00000000;
-	ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
-	/*
-	 * remark: Intel CPUs only support "syscall" in 64bit longmode. Also a
-	 * 64bit guest with a 32bit compat-app running will #UD !! While this
-	 * behaviour can be fixed (by emulating) into AMD response - CPUs of
-	 * AMD can't behave like Intel.
-	 */
-	if (is_guest_vendor_intel(ebx, ecx, edx))
-		return false;
-
-	if (is_guest_vendor_amd(ebx, ecx, edx) ||
-	    is_guest_vendor_hygon(ebx, ecx, edx))
-		return true;
-
-	/*
-	 * default: (not Intel, not AMD, not Hygon), apply Intel's
-	 * stricter rules...
-	 */
-	return false;
-}
-
 static int em_syscall(struct x86_emulate_ctxt *ctxt)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
@@ -2411,7 +2376,15 @@ static int em_syscall(struct x86_emulate_ctxt *ctxt)
 	    ctxt->mode == X86EMUL_MODE_VM86)
 		return emulate_ud(ctxt);
 
-	if (!(em_syscall_is_enabled(ctxt)))
+	/*
+	 * Intel compatible CPUs only support SYSCALL in 64-bit mode, whereas
+	 * AMD allows SYSCALL in any flavor of protected mode.  Note, it's
+	 * infeasible to emulate Intel behavior when running on AMD hardware,
+	 * as SYSCALL won't fault in the "wrong" mode, i.e. there is no #UD
+	 * for KVM to trap-and-emulate, unlike emulating AMD on Intel.
+	 */
+	if (ctxt->mode != X86EMUL_MODE_PROT64 &&
+	    ctxt->ops->guest_cpuid_is_intel_compatible(ctxt))
 		return emulate_ud(ctxt);
 
 	ops->get_msr(ctxt, MSR_EFER, &efer);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 5382646162a3..0f71d4699b78 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -222,6 +222,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_cpuid_is_intel_compatible)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ea6f4fc910f..ac607b41890e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8505,6 +8505,11 @@ static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
 }
 
+static bool emulator_guest_cpuid_is_intel_compatible(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_is_intel_compatible(emul_to_vcpu(ctxt));
+}
+
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
 	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
@@ -8603,6 +8608,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
 	.guest_has_rdpid     = emulator_guest_has_rdpid,
+	.guest_cpuid_is_intel_compatible = emulator_guest_cpuid_is_intel_compatible,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.is_smm              = emulator_is_smm,
 	.is_guest_mode       = emulator_is_guest_mode,
-- 
2.44.0.478.gd926399ef9-goog


