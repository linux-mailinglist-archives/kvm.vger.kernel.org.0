Return-Path: <kvm+bounces-52264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A76B03504
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF58F189A127
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 03:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D72201278;
	Mon, 14 Jul 2025 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4t4lWHoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE681FE444
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 03:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752464244; cv=none; b=h2jS5ujxTqfTFPCYQLDA3hplTWTb5UysswscUvEMhv+rcs1u0AkD4xm2bs3VeisCsXUduMaBrPKA1/QdM9F4muzOf+2IcMCk22tf8+M1oZPKIo2THXIE4zRpzz/SOot7Fkrg7XFyfVFuSlwSqZ7LuGDUvQJt5jYuYW9myq2SVHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752464244; c=relaxed/simple;
	bh=Iw8UgECeSh4MOBXDjEL7rz+cVwwQWB07OSoxUeNK10o=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=Xae3PNIemVtZ8w2ID70NxPvTnTQDe3czLIYlnRyKo8mx7UwbD80RuYiKPqX6Lkv2pzFZBrF+/FL0qvIirpUT6vZTBWkX5PhRf1JpRCh5zukkcZOdO/Z4As6VbGj5ULfdyRL1XDRCK4l18v5yNns5lBfcs9TRSAEjsUqT/Pr4LLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4t4lWHoZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2356ce55d33so59279195ad.0
        for <kvm@vger.kernel.org>; Sun, 13 Jul 2025 20:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752464242; x=1753069042; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IuCOV0BBhXpldFkF7SjoypukvpXxsnclSm2cFgamVis=;
        b=4t4lWHoZMXuvjho/VVB93/+9z3/CdrlPZpS/7889ESuL8x1kyh3hgon7eUE2aofQt2
         9+CLdOmhrVkChYj9Y+901vFrezfe/QcKucxuxgo6Vx9QLogtUH91VQPlbeC0TUmPJIWT
         swY74Ka+jz545mwZcS46NTEYMchyapht2Grb49ZrddHHSlf8kElonbNX4n4XmHL2eIut
         VgGB0QY8LlQElpu4orjUPgt4FFXALXLHY/fOCG519ghVR/rKMca6E9SbuM/9hCQVcXAC
         aidR9KaIY9clrT/KImGd4N8QpD6no+M3feKcEOMlWIN9T1XZkC2Ijubt6OldY675dxJB
         NjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752464242; x=1753069042;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IuCOV0BBhXpldFkF7SjoypukvpXxsnclSm2cFgamVis=;
        b=J3RoTICfo1HrRnai+/MlyRdTCWD43HLr/vXQB2qNZ1NltYfpZ/+rC2fY/cl7x2kEPP
         XwZ5b/7foTd3PsGdhktlz7iWEkjQhsJ4iHjgEtUfVuR1akuUHvomJ0ZwsMKZvo2tDmLc
         F6ztSdJEBg/fQMmNYB2RoQofmGPtuN2bgDm9w6xemNGEpcqJhbWeRvxEWK9LQCuCKPP5
         40xN/KkWh9ypZy0MhC8PbStEw7cnn9e8gFkAsS8bTzjxiZXrnpSd6TwSeC6JQqb1oaot
         rix59WdAhA38y/tdg3IUwLOOxaUHQaSLTJnz5Z4mxvG/gBmd5rz4QMDwHQqXBp7Gp3tM
         fe2A==
X-Forwarded-Encrypted: i=1; AJvYcCWGzWltF6E26E6gaCI7yNmbzMLfUt6Cw3aKJ7R+WaEmneW0oJdPZQmnDw1VNjIRAcR2oPk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJZ6ZHOA8yuM+NRyHkQWhsAtzWqHRYt8kflXRGF1sNNhfDGHWw
	MhOgQJkaI9Se1VwpeYVTsLsWmDdMd6Ejeqy0FjCAI6HqifkLzPd0rOlfJ9jAT04nfrezZYT4+rY
	vbW9OyTGfCKMHpQ==
X-Google-Smtp-Source: AGHT+IFrBZOkLURtmxf4lvSzOVmE0ai7SJHbgn0xbbIb3ggEOAP+Yzu5GmOIjRZRMCD8thfwgdWkLGsD3AzRyw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:4f90:1ee3:198b:1fe4])
 (user=suleiman job=sendgmr) by 2002:a17:903:348d:b0:234:ddd7:5c16 with SMTP
 id d9443c01a7336-23dede708ddmr9195ad.4.1752464242498; Sun, 13 Jul 2025
 20:37:22 -0700 (PDT)
Date: Mon, 14 Jul 2025 12:36:49 +0900
In-Reply-To: <20250714033649.4024311-1-suleiman@google.com>
Message-Id: <20250714033649.4024311-4-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714033649.4024311-1-suleiman@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Subject: [PATCH v7 3/3] KVM: x86: Add "suspendsteal" cmdline to request host
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
index f1f2c0874da9..9f5758ca8fad 100644
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
index 921c1c783bc1..35d1bb2283c2 100644
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


