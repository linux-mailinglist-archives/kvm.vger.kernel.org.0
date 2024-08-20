Return-Path: <kvm+bounces-24567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F009957C7A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 06:38:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB22F1C23ED9
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 04:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD53E62171;
	Tue, 20 Aug 2024 04:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="10kIfqLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88202148FF7
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 04:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724128699; cv=none; b=ByEiONeGC0JCP7bsaUq73ugAb0+yho71LzD41KTS2vgzw8/Ln2cMYRL5IT31/dJ/YdKeD8DIm5WejIKtpH5IK6Id2v5arsa+MRZItH2Pj3VQxQdcZS9QG0h7aZkrh8y85d69FHUNrZ6fNeBEbiEYjUBUg2sU4r08VA6kJ/2DUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724128699; c=relaxed/simple;
	bh=ImKLYihAGgQNZ/oanLjd47JquPgT6FVsGy+myZKO39w=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=AWKgcfdKaDttK4jF/OdBhIeo7MqJi4Kje+z/yeb+Ek1IyPN/XAIQdjONxpnHaKLCTJydaaA7/sHUkrxieWy7zg0YME2jAUZmuh+hSFupOcWr8o4vN5IyTuwmTUZ2Kvdc0pJFuz37mSzppLlAkZG3lgn81rNdOVrRpNYPUOjAG70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=10kIfqLQ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bcd04741fso8490201276.2
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 21:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724128696; x=1724733496; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5TZmmuMT9WUBBRzzYYXG22ftk/TTrrT11BrmS5ZBbdU=;
        b=10kIfqLQes1O13GioGpSnKp+rIEBS3MZymAGGiIS4+O+JuP1efMi/3W6QTwqfIAp13
         UNK3ta5A2BuNtFVZg+lZmh3EG+/XNT0qBJbqIEJEi4o/GJNtWMI2Jre68qBZ8oMywC1z
         7tYlBstOF3AzD9euvPu1YLhT0hD2mgLogGEyDVRWnR7R+husIhuw9+NeOe2QTF8CCMl4
         ootXaW39oCa4Egh/N1oVzPMkrdR1iIm/UtktuFizaQwvvzSX3fdoo8miDZD8xArWWphM
         t7hgtjps/cnAmCqWpKjBYRt7rSu7gTLc7eFj6CvLl6INXrKiG9QRb74I4/EOc2SahSZj
         1Y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724128696; x=1724733496;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TZmmuMT9WUBBRzzYYXG22ftk/TTrrT11BrmS5ZBbdU=;
        b=LwjlDTJfo6JF3mzkqfdlYdf2VfgZ/yOevZTMr1Rvo4d1KQvKTcvMyrhkNcr5gTUxJN
         wyse4/o63UIYeY3SCew2ATbyXlwPU2bX26d7yldX2cQm+UpV2oNYfb72R5X71BpfFoQ0
         2aWEk34y4F5wx8fxBYCQGpAmKtlGLY1If7c/nufwsPHjClZ2vmqC0HfwYdevDWvhHbah
         d9Z5aPZHxP5jMP/Vu8uArJz2EJUfCHVkOAT7DaMx6T1mBFEmJnAGkTP/gN8d4u0Oarud
         KzB/dpLS/sFfxllmd0iKsYmTOAsRtu2aZPOHjGduIPZ7qRBz5wImppJXSuQNqVtmwqVk
         23/w==
X-Forwarded-Encrypted: i=1; AJvYcCW1tgjxHChaem2XrxWKyWrfmz7/CdKWx6zwn3l64+ju5aGUyjfdaHudd6kQzZBMKDXhuTpJWEBnJoDzdH+9ILzRZihY
X-Gm-Message-State: AOJu0YyDcARdhg5rX7BKbKJTr5PVYdUF7IwRLvwZIhGAQV50pwKN64+L
	OhUmnflj9Fhv1LKoGcZm1IxPOnXrhRe7YfXBBMPZPdQ0bnuvJmOwwxrC2uG4WE/uYhSvBHUg1YW
	On7lA+siHYQ==
X-Google-Smtp-Source: AGHT+IFko9TuAg/fFH2b16tsE1En7DdlM8+lW8euXc+4FXbWb9LNWhThz2XFNutJecp7dklcYDTE0EbtT0+y8g==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:7c18:89e3:3db:64bf])
 (user=suleiman job=sendgmr) by 2002:a05:6902:14d:b0:e11:7112:6b9b with SMTP
 id 3f1490d57ef6-e1180e625a1mr258826276.3.1724128696422; Mon, 19 Aug 2024
 21:38:16 -0700 (PDT)
Date: Tue, 20 Aug 2024 13:35:42 +0900
In-Reply-To: <20240820043543.837914-1-suleiman@google.com>
Message-Id: <20240820043543.837914-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Subject: [PATCH v2 2/3] KVM: x86: Include host suspended time in steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, 
	Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling. This can be particularly noticeable
if the guest task was RT, as it can end up getting throttled for a
long time.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest subtract the duration from
the tasks' runtime.

Note that the case of a suspend happening during a VM migration
might not be accounted.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a68cb3eba78f8..728798decb6d12 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -898,6 +898,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
+		u64 last_suspend_ns;
 		struct gfn_to_hva_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e4069874a..104f3d318026fa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3654,7 +3654,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-	u64 steal;
+	u64 steal, suspend_ns;
 	u32 version;
 
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
@@ -3735,6 +3735,14 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	/*
+	 * Include the time that the host was suspended in steal time.
+	 * Note that the case of a suspend happening during a VM migration
+	 * might not be accounted.
+	 */
+	suspend_ns = kvm_total_suspend_ns();
+	steal += suspend_ns - vcpu->arch.st.last_suspend_ns;
+	vcpu->arch.st.last_suspend_ns = suspend_ns;
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
@@ -12280,6 +12288,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
+	vcpu->arch.st.last_suspend_ns = kvm_total_suspend_ns();
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
-- 
2.46.0.184.g6999bdac58-goog


