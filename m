Return-Path: <kvm+bounces-13780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA4089A7B5
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 752362838D3
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBCD38FA5;
	Fri,  5 Apr 2024 23:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQS684c4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D75745C5
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361388; cv=none; b=XXm1OZsV7xiSq6bb/eF7R8LHsjW1jtO4KwT3q9zx/dZXsYVY3s5vJICXUN/126BZqehQ29WN92awFsrXIwzzX6JlPfU8a7SERXb2wAMxBWZ0vX48WUvlyXptk5iagVc0/HmEdbIPRK3E4QIwm+YU2299dW8jtWgxW2t3TN0qS3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361388; c=relaxed/simple;
	bh=b/B5Yxc1o5uGiHJ7jeAtZBsI3i+lBvUWpy7nGRTLMZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zt5RWChzpFdr/HdtxO/6fN/354tX0UnfjoVi1LDj5uGeYJFLJFiIL2uP6iUERFsbvTtO9uwnoMPsQKh450k1rKXb140Tbc51CwsJ/sdJz9rnfjjPrypZ4LchcR0DiT6QswFXs5anRCorF76PGuxn+e9kFAnn+mtrAav9W7kVu20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nQS684c4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6150e36ca0dso43291777b3.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361385; x=1712966185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2SJx+1wJFr0pWJuRZAhG+dHu/wPMI/D+PKH1v3GyCs=;
        b=nQS684c4a9A+0qoXhwtNKGH/328FgAm+mK/aUdb5JEBu6YSUSstc1ba8zBH5XT4fJx
         RyGRKnkCYWI4PsS424HbZE2lowr1+qvVI9v5aJaFbuDhJFCiqjJXvXpWf1MuAHVRe2Ww
         B3C9mWKHEqQ/akKPqJkMY2eyKLAIV4xVjQdBqE/K1q2E/+l9nMSjB1eorYvv8BahuNaX
         dYcqck083YKCYCt22vQIzCivsYHIkZASNUSXz/FOL8A3Oa7FFOCSVPZsk0VkxyuZu9eX
         Jn2a+MLxj2HCPcwOIInZNQPTkjXD0HhTIootK/STwqg5kYi66l9KIlrhZCyNyfNiqzT3
         iisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361385; x=1712966185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2SJx+1wJFr0pWJuRZAhG+dHu/wPMI/D+PKH1v3GyCs=;
        b=MrMVubj+uPp4GFB/QPluagHEVHnK//11Hqcz3shDNuuDa3x6/CqCe/cpqj8wGEq97v
         OOCfiQ0nuICUex0vmjNwbJ+VyYoTlKaAA4CH08e0B3m2InHOjvWNCPSo31Q0jMiUyCkW
         RFE4zzZ4Vsx4TXburJNNNCXFHGYkTm+qvM/IhieXD4qnStkCr4qmzfIZ/VjnKS/oElr0
         315BNEuadIp+SJRlnxEDNcg72lz9Nzfc3mJzgIIH2rsHz32y6jjV80Bi+51QvrIdxBy0
         nO8dT2Rj/77omy2966QbAW0bTpxlTcNTxaUvTaw7qqBQTiT2+/8pKtNXnF6pmo4f6FYi
         qzug==
X-Gm-Message-State: AOJu0YymRcJ3Gsa0CL8Xq2UDvf0opKx7/TlTkOhS2ECyI466zimFK8DF
	O7wxuy/TYC8BNllGs6UEhkObLfS61BJ0eoOYCSNBHJioLZXqxCeMXd+lYD2wOERdg2BfjLL2rqm
	VvA==
X-Google-Smtp-Source: AGHT+IEAQcVWaY2kxMZHD+fyUuyDnGFHrg0CbB+w3iHQiSVLJqyqN5x6yG2JtfvWF0cd2xOm/IS3a+FB7Bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8341:0:b0:615:3072:1934 with SMTP id
 t62-20020a818341000000b0061530721934mr659372ywf.10.1712361384736; Fri, 05 Apr
 2024 16:56:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:56:02 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-10-seanjc@google.com>
Subject: [PATCH 09/10] KVM: x86: Open code vendor_intel() in string_registers_quirk()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Open code the is_guest_vendor_intel() check in string_registers_quirk() to
discourage makiking exact vendor==Intel checks in the emulator, and to
remove the rather awful #ifdeffery.

The string quirk is literally the only Intel specific, *non-architectural*
behavior that KVM emulates.  All Intel specific behavior that is
architecturally defined applies to all vendors that are compatible with
Intel's architecture, i.e. should use guest_cpuid_is_intel_compatible().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 26e8c197a1d1..1acd97c6fa53 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2354,17 +2354,6 @@ setup_syscalls_segments(struct desc_struct *cs, struct desc_struct *ss)
 	ss->avl = 0;
 }
 
-#ifdef CONFIG_X86_64
-static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
-{
-	u32 eax, ebx, ecx, edx;
-
-	eax = ecx = 0;
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
-	return is_guest_vendor_intel(ebx, ecx, edx);
-}
-#endif
-
 static int em_syscall(struct x86_emulate_ctxt *ctxt)
 {
 	const struct x86_emulate_ops *ops = ctxt->ops;
@@ -2622,7 +2611,14 @@ static void string_registers_quirk(struct x86_emulate_ctxt *ctxt)
 	 * manner when ECX is zero due to REP-string optimizations.
 	 */
 #ifdef CONFIG_X86_64
-	if (ctxt->ad_bytes != 4 || !vendor_intel(ctxt))
+	u32 eax, ebx, ecx, edx;
+
+	if (ctxt->ad_bytes != 4)
+		return;
+
+	eax = ecx = 0;
+	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
+	if (!is_guest_vendor_intel(ebx, ecx, edx))
 		return;
 
 	*reg_write(ctxt, VCPU_REGS_RCX) = 0;
-- 
2.44.0.478.gd926399ef9-goog


