Return-Path: <kvm+bounces-51884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4164EAFE0D6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3D91172990
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D022749E0;
	Wed,  9 Jul 2025 07:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lGa5dMb4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6402B273D8B
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 07:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752044708; cv=none; b=RJce0rOyM37R1sWoilaup8quL3NU3q9cGnnI5obJPxxtAP5Yi/s/Bypl/8mrYW6OotpBABmXZeBb8ww7yAbIz6lRlBHPo69oOToCbglt2SOjH2lta+mQ24b7mqgt56moTWI0CBqgfRcGVHPIVdm9ilTot9kO3eXtpNshTjhNVRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752044708; c=relaxed/simple;
	bh=bqDfiVKFuR+e8N7emCK6GdbPPlTbsBsyYl3PH3KjyJw=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=lW//EAhFeRQ+q4AfHV9L6FmC7+uS7251jvfS/WEqaPQO6s7QhCKwJXITWWE30vRfz/iWOV8iGEXskLFPY7swHih/QPRDdCxfjjTAGJmgTGrlvVBw2zn7f/B4ycWpzygKuE3kuJgCP4G5x+bYl8j33016V/5MBppXRabLGqIzqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lGa5dMb4; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e81b3e168a6so5692020276.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 00:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752044706; x=1752649506; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HaDQLHJuamQG+Oz/rXsc1nJQc3j6887WnfJ3FWY6wPY=;
        b=lGa5dMb4/QCskSc/99m9viQEHFXRqBqRbuSxe8xbbz1YtNKIQIHcB3SWi2d6gc03NM
         yjMjJYjLpL0efYbj12ikl3F9Vt1vpd40ZbT4SQEUyFezNUsZuxbxOO4foCxR9M6eeRDJ
         0ddqiQYvYZsttyrpxusJBc1Lk8t31SSk11tb7LaEAQGqTgEeEUdjrQKl2FmJjeFNYvlx
         ZQx3s3C0sOEOxfUt+NQeDSIvkXR1lQGvJs7RuI4fVOKa7zt/5mQkLHPa+eI0mAKQuPkm
         PC5ZUj4H62nz3hRyxxrxayLIkoMo8SV9au9VXzGrTmwxQGpk0vde0OVl5yOU90R5uDLE
         Q7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752044706; x=1752649506;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HaDQLHJuamQG+Oz/rXsc1nJQc3j6887WnfJ3FWY6wPY=;
        b=SOUbDdHVp4imwzIdYrQgiAIrzoae8y70ZN7tM1KseYdv/ax5KDcsfdEiCeTuuc9zcp
         9vr1u6ua4fsYmByB1w4EEyWWIcec1oe5RtyCO9/5hMnVw/hzR42IQylJYhhOcdSgkhZd
         I1ruU/wFs9xlDM0NlSYa0dSBqnGGXQKOTlFrjCE2pTaPJanY/ii6bxPeVNC1ni0fJnTZ
         KxSvMY83wxeeOZ/5EQz8HBFXs2zTdwkoc6neM6+t9k3P+ccQpkV9wnNG1KIa7+KNVQxk
         93vhBOCBAz7UxQaDPa363BeeYo8c5OjQsZ2vL4Z8VQcPKGLdt8XQxsUodEwXSDgtuseA
         tfPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBXZuecxZkfpBPkUbvBkEK9X7OJu8dhc/siD/Rg8fJf4pBdRaNiDmBVLYr+2N81gvFOY4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcw+RL9ktsM4wsFFPA7zv2/7usKEK7myPMZlI2ozURXcEWFwXw
	n8MdYOq+ND/54wvbUu68aNQB/M1nle2kIuBaLXpoBNtrrzEvuMS5iw1cX59g51VuY6s2nseSwEy
	Syjf1iPoFmaYYgQ==
X-Google-Smtp-Source: AGHT+IE5ZkJJrfChwxmjelv9TbY/xNBu5uRt03nGE+i4WAPwg6JLhbF8sllzldrGvtvYqXjNVHB2+Nx7G6uM6w==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:a92c:694f:82fe:62a])
 (user=suleiman job=sendgmr) by 2002:a05:6902:6c0e:b0:e89:883d:dd33 with SMTP
 id 3f1490d57ef6-e8b6e19fdcamr688276.5.1752044706399; Wed, 09 Jul 2025
 00:05:06 -0700 (PDT)
Date: Wed,  9 Jul 2025 16:04:50 +0900
In-Reply-To: <20250709070450.473297-1-suleiman@google.com>
Message-Id: <20250709070450.473297-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709070450.473297-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v6 3/3] KVM: x86: Add "suspendsteal" cmdline to request host
 to add suspend duration in steal time
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	John Stultz <jstultz@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a new command line parameter, "suspendsteal", enabling the
guest to use MSR_KVM_SUSPEND_STEAL, which tells the host that it would
like host suspend duration to be included in steal time.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 arch/x86/kernel/kvm.c                           | 15 +++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f1f2c0874da9dd..9f5758ca8fadd5 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -7074,6 +7074,11 @@
 			improve throughput, but will also increase the
 			amount of memory reserved for use by the client.
 
+	suspendsteal
+			[X86,PV_OPS]
+			Enable requesting the host to include the duration the
+			host was suspended in steal time. Disabled by default.
+
 	suspend.pm_test_delay=
 			[SUSPEND]
 			Sets the number of seconds to remain in a suspend test
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c783bc187..35d1bb2283c2c0 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -320,6 +320,18 @@ static void __init paravirt_ops_setup(void)
 #endif
 }
 
+static bool suspend_steal;
+
+static int __init suspendsteal_setup(char *s)
+{
+	if (kvm_para_has_feature(KVM_FEATURE_SUSPEND_STEAL))
+		suspend_steal = true;
+
+	return 0;
+}
+
+early_param("suspendsteal", suspendsteal_setup);
+
 static void kvm_register_steal_time(void)
 {
 	int cpu = smp_processor_id();
@@ -331,6 +343,9 @@ static void kvm_register_steal_time(void)
 	wrmsrq(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
 	pr_debug("stealtime: cpu %d, msr %llx\n", cpu,
 		(unsigned long long) slow_virt_to_phys(st));
+
+	if (suspend_steal)
+		wrmsrl(MSR_KVM_SUSPEND_STEAL, KVM_MSR_ENABLED);
 }
 
 static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
-- 
2.50.0.727.gbf7dc18ff4-goog


