Return-Path: <kvm+bounces-39355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B7EA46A12
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 19:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C43318894BA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCBDF236456;
	Wed, 26 Feb 2025 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PBE2H7eo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0BE233D72
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740595619; cv=none; b=IPMmVefGpVo4fJjfdA6Hwz9U2GxDi/ulN5wcKAuEvp0oZzMHf//pgsTtyqKZgL54D2itL69PT0AmqMqHxldIFFte7Lkz2wCIm8Ws2cBOjktpBUQ15IQn5+ccUtS1u6VHRT4Ykp6FSZDMhelT6mD2IMzJLB2LrST9VOO3l/j6mP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740595619; c=relaxed/simple;
	bh=JodBzx7M4AQGobZza2uhbaZSvsPMslokXhqcEliSGAY=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UVk9RfCE+USb4JQktK5PdsK/AYy51jCKJ0SMtlvpOZW7RXa7QNMJN+oXZYn9KDjuQAvQ3P1IIEgGPjfB6YJQj/h2amLtoHGIkLtDLweskxpLhaQLDH303WjkWorzIPlHQhw4Oj/Yhq1EoHEptzxQdBHD86/R6MGrsWBGgaqHYLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PBE2H7eo; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4399a5afc95so502545e9.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 10:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740595615; x=1741200415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sOguHpycwUX8eihJ1N7vZXsBa1ko3FW4hupJ5yAhZ8c=;
        b=PBE2H7eox33eoJAMIFOS5adyQ4BsMfq4y8S8zbjWu7hL6InF3QJ3wbp1ytKyEEGR4d
         9buwgOgC4sxsCItSrRMPBwT2YwCKyNjaol6kQThPCF4ukv3VqzbqAv34xkXC4nyBZ57q
         qamm0Z8I+ZyOcDpIRgn0JXH+07BEXI24YN8UGrgO90HtuRL/5124S7O4zG2uRRl9lPJa
         EVhDhvRx3VUL7cs4PnU4YYK50JuwCMRkk5rRaWp8f/9FQvLEke1RPIYp60Bg2eg9mNub
         98Hk3WyxyCfki+8NBSGZLUcLVUusgSe3gplK440Ztb9zgmuzAZraOuhlM8FYNbEGYWda
         ddTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740595615; x=1741200415;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sOguHpycwUX8eihJ1N7vZXsBa1ko3FW4hupJ5yAhZ8c=;
        b=d2WxhnZInJecrEHF/yaTC/8w3avY0sLoSNZnz5XZ8pJ8lu8EueOXI1eLzrgbAC3LEm
         xM20n5m5Bgmeztc3dT+g+Q7pA/Mcgc+P1tp4jZ9nZ6UETh9/oQZmfpV/Y1+2WjXO3BDO
         GcWIAPwoQxQR4Ht9pCZe0+wMRJUN/WYCUT6IwukIP78bQlxSMotUHfU1V3ZWFQuf1eIn
         sxzcuxC/b0MPoTG86m8y2wlthE5dYdIORESbUlvbYa5RGTjSw98jrCgSHyoT7Ds9pKV9
         2qFOZEKSSxVRo/+LaadStogov8mXOhG4LLHi/0E23JoXvoSk7vYGpZnJNEgUrWnXjBrk
         XNmA==
X-Forwarded-Encrypted: i=1; AJvYcCXOpqtkVCzjYe1pVrQ9v+MPe/MIZnnwN8UOqt1Q6jMYXu3ryvOupFAiUBcHdoivzv7iIso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+gNQZx/GIiVyEhNSER1DAL1L4vgzhI0uAnSqlAdmGFkeu6OcZ
	JM8pgHkEUTO2T24zIf7r4OCbgk9XatCfc/QiCAsueC3ZxXNjG3EPY+/Uj7jx0RSLuVm4eBIfSvu
	SXk4mTUgGaQ==
X-Google-Smtp-Source: AGHT+IHASSc7e4RmQTri0Z7g3+xd3N5kxnQGr9pL116mxIOSxNQO+ye9Qs7fGUpkV1t41+kDq2AToRr56faLhg==
X-Received: from wmpz20.prod.google.com ([2002:a05:600c:a14:b0:439:9558:cfae])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3151:b0:439:a1ef:c242 with SMTP id 5b1f17b1804b1-439ae18fdc1mr219774895e9.0.1740595615641;
 Wed, 26 Feb 2025 10:46:55 -0800 (PST)
Date: Wed, 26 Feb 2025 18:45:40 +0000
In-Reply-To: 20250218153414.GMZ7Sodh_eQXqTNE2x@fat_crate.local
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226184540.2250357-1-derkling@google.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Patrick Bellasi <derkling@google.com>, Sean Christopherson <seanjc@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>, Brendan Jackman <jackmanb@google.com>, 
	David Kaplan <David.Kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"

> On Tue, Feb 18, 2025 at 02:42:57PM +0000, Patrick Bellasi wrote:
> > Maybe a small improvement we could add on top is to have a separate and
> > dedicated cmdline option?
> > 
> > Indeed, with `X86_FEATURE_SRSO_USER_KERNEL_NO` we are not effectively using an
> > IBPB on VM-Exit anymore. Something like the diff down below?
> 
> Except that I don't see the point of this yet one more cmdline option. Our
> mitigations options space is a nightmare. Why do we want to add another one?

The changelog of the following patch provides the motivations.

Do you think something like the following self contained change can be added on
top of your change?

Best,
Patrick

---
From 62bd6151cdb5f8e3322d8c91166cf89b6ed9f5b6 Mon Sep 17 00:00:00 2001
From: Patrick Bellasi <derkling@google.com>
Date: Mon, 24 Feb 2025 17:41:30 +0000
Subject: [PATCH] x86/bugs: Add explicit BP_SPEC_REDUCE cmdline

Some AMD CPUs are vulnerable to SRSO only limited to the Guest->Host
attack vector. When no command line options are specified, the default
SRSO mitigation on these CPUs is "safe-ret", which is optimized to use
"ibpb-vmexit". A further optimization, introduced in [1], replaces IBPB
on VM-Exits with the more efficient BP_SPEC_REDUCE mitigation when the
CPU reports X86_FEATURE_SRSO_BP_SPEC_REDUCE support.

The current implementation in bugs.c automatically selects the best
mitigation for a CPU when no command line options are provided. However,
it lacks the ability to explicitly choose between IBPB and
BP_SPEC_REDUCE.
In some scenarios it could be interesting to mitigate SRSO only when the
low overhead of BP_SPEC_REDUCE is available, without overwise falling
back to an IBPB at each VM-Exit.
More in general, an explicit control is valuable for testing,
benchmarking, and comparing the behavior and overhead of IBPB versus
BP_SPEC_REDUCE.

Add a new kernel cmdline option to explicitly select BP_SPEC_REDUCE.
Do that with a minimal change that does not affect the current SafeRET
"fallback logic". Do warn when reduced speculation is required but the
support not available and properly report the vulnerability reason.

[1] https://lore.kernel.org/lkml/20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local/

Signed-off-by: Patrick Bellasi <derkling@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7fafd98368b91..2d785b2ca4e2e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2523,6 +2523,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
 	SRSO_MITIGATION_BP_SPEC_REDUCE,
+	SRSO_MITIGATION_BP_SPEC_REDUCE_NA,
 };

 enum srso_mitigation_cmd {
@@ -2531,6 +2532,7 @@ enum srso_mitigation_cmd {
 	SRSO_CMD_SAFE_RET,
 	SRSO_CMD_IBPB,
 	SRSO_CMD_IBPB_ON_VMEXIT,
+	SRSO_CMD_BP_SPEC_REDUCE,
 };

 static const char * const srso_strings[] = {
@@ -2542,6 +2544,7 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
 	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
 	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE_NA]	= "Vulnerable: Reduced Speculation, not available",
 };

 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2562,6 +2565,8 @@ static int __init srso_parse_cmdline(char *str)
 		srso_cmd = SRSO_CMD_IBPB;
 	else if (!strcmp(str, "ibpb-vmexit"))
 		srso_cmd = SRSO_CMD_IBPB_ON_VMEXIT;
+	else if (!strcmp(str, "bp-spec-reduce"))
+		srso_cmd = SRSO_CMD_BP_SPEC_REDUCE;
 	else
 		pr_err("Ignoring unknown SRSO option (%s).", str);

@@ -2672,12 +2677,8 @@ static void __init srso_select_mitigation(void)

 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
-		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
-			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
-			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
-			break;
-		}
-
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+			goto bp_spec_reduce;
 		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2694,6 +2695,17 @@ static void __init srso_select_mitigation(void)
 			pr_err("WARNING: kernel not compiled with MITIGATION_IBPB_ENTRY.\n");
 		}
 		break;
+
+	case SRSO_CMD_BP_SPEC_REDUCE:
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+bp_spec_reduce:
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		} else {
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE_NA;
+			pr_warn("BP_SPEC_REDUCE not supported!\n");
+		}
 	default:
 		break;
 	}
--
2.48.1.711.g2feabab25a-goog

