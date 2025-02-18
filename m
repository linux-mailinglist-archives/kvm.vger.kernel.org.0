Return-Path: <kvm+bounces-38449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2460CA3A06F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 15:51:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBE21174171
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 14:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C0026A1AB;
	Tue, 18 Feb 2025 14:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="otD6c3nx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC1E24113C
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739889797; cv=none; b=pD+AyDI68YQpv2znT5OgKrVgCrdJMd7nfoH2ELx8eZljVzqidZQnl8S+D4plFMiyiSAX2ruidz7K3YfAEC+3ushyRCthQAwvl7yjNC1hViJwc4D+/zYLELLaWdTxkpI19t4r1KOT82zyGg/fnwa4wghb8HR5ejVjZFUl7413VLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739889797; c=relaxed/simple;
	bh=4lW/twvdhE+A+c+wKCSUwMTcipMdqeplNUW6N48zvLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LuONT4RmMRkmS+fy2XYDEfJiocy8ElSHGBsP5Veuuu4qh6kfWWleqffM6HwR+OwdpBWApVQEIy0S7jdRXbpEuAfVmV+cDbtOciATEY8UXoYiwkpkkKq37O0TW/52ddmeXlluJXz1AIbaJn3bSQTpowvyz55NcTGwVGhtapOFJKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=otD6c3nx; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43998ec3733so996175e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 06:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739889794; x=1740494594; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jel/om40HLmpwtgskjT+Vd7H7nmCr+AlMBVyaul/WCc=;
        b=otD6c3nx+/GXsjAi/FKzW+N3t18Kj3O4klg2vJucjtvtc4kaSd8P7u5NhLaSLz3VbF
         PJTK7TinyOWPFMsE8kT+Bn5OBMqaP7CmhGTrdXxlNetMpBZM6KlUdxALozqAMXyO1AGm
         sixiAEM3ckLRQ48IrGFW64yvZOet76XpYo3a+VHkz/8LzyfqOWE5yZdFJ8jo6dduDVWD
         +iUnEE2NYBkeY9ofU3NE814xUiQO0cwqzUP/AMZ6pKEnzOf+Yis8HuKrLNCAWwuhboFY
         Bnn9cwNwWb1QAEd082ZnjJgE9tLIKFQNcjngkIGhObWVoESBqufP4S5hbB/q3t+QDdHW
         URUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739889794; x=1740494594;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jel/om40HLmpwtgskjT+Vd7H7nmCr+AlMBVyaul/WCc=;
        b=eNAORrlk1mM/6HipuqjLzaAqqYnav6zs3UsHk1d0CiniuppLm/4yOKDedlB4NurN+M
         pBmIqhbqWuaixJ+au/hge8+4eJ/Q9klIdipVjHbcTWFV2paBlGzT0c9Xa2lOd/5EF18x
         n4PYUlIIWb5WQ5HZMw3UJI+cKEfhp/u3yw7hhZuEjQUWQSaQGpUWaYpl0ExNbhCn8gAA
         SoTIYw+hh1isYJLyfQ8J8Va8PJU5CsbbiFtk34nrYh05QybTlXA9YZiCvYvpqUC9NTzf
         y1o2gx0zaNluBE6ShuxJp1dNjU/pEP6ljUuuiyVryC/reV7Pi/XXRLwVjX3zuojOEGcW
         aUsA==
X-Forwarded-Encrypted: i=1; AJvYcCWKbwNYO2UZn6yX7+71T1XO6m6KI+xA9rIrqBVF3NenXlmOAlbwldlFy4WG5qryZmLPiBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRCTXKvojSXDT88mmF7cydoTFlw0UlLbEiafbF9GISGf9xjCT/
	QRfrJbZY1uIN1wjOyfIQDpnuiHOzDj2dBjxYa4ED7T7Zqjw8Nb1ZL5CKi3rdmH2CaSkqoxOKw0r
	ICf5NPG26NQ==
X-Google-Smtp-Source: AGHT+IHpYFUhEi3NwetUXZRckhwIr+1DZvrCsLXzKq961BPNu7xrlPpIzMh19VLzq7zt+78SXVccEhyX+T6l1Q==
X-Received: from wmqd18.prod.google.com ([2002:a05:600c:34d2:b0:439:8e81:fd03])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154d:b0:434:a923:9310 with SMTP id 5b1f17b1804b1-4396e701614mr136998375e9.15.1739889793882;
 Tue, 18 Feb 2025 06:43:13 -0800 (PST)
Date: Tue, 18 Feb 2025 14:42:57 +0000
In-Reply-To: <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218111306.GFZ7RrQh3RD4JKj1lu@fat_crate.local>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250218144257.1033452-1-derkling@google.com>
Subject: Re: [PATCH final?] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Patrick Bellasi <derkling@matbug.net>, 
	Brendan Jackman <jackmanb@google.com>, David Kaplan <David.Kaplan@amd.com>
Content-Type: text/plain; charset="UTF-8"

> in the interest of finally making some progress here I'd like to commit this
> below (will test it one more time just in case but it should work :-P). It is
> simple and straight-forward and doesn't need an IBPB when the bit gets
> cleared.

That's indeed simple and straight-forward for the time being.

Maybe a small improvement we could add on top is to have a separate and
dedicated cmdline option?

Indeed, with `X86_FEATURE_SRSO_USER_KERNEL_NO` we are not effectively using an
IBPB on VM-Exit anymore. Something like the diff down below?

Best,
Patrick

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 1d7afc40f2272..7609d80eda123 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2531,6 +2531,7 @@ enum srso_mitigation_cmd {
        SRSO_CMD_SAFE_RET,
        SRSO_CMD_IBPB,
        SRSO_CMD_IBPB_ON_VMEXIT,
+       SRSO_CMD_BP_SPEC_REDUCE,
 };

 static const char * const srso_strings[] = {
@@ -2562,6 +2563,8 @@ static int __init srso_parse_cmdline(char *str)
                srso_cmd = SRSO_CMD_IBPB;
        else if (!strcmp(str, "ibpb-vmexit"))
                srso_cmd = SRSO_CMD_IBPB_ON_VMEXIT;
+       else if (!strcmp(str, "spec-reduce"))
+               srso_cmd = SRSO_CMD_BP_SPEC_REDUCE;
        else
                pr_err("Ignoring unknown SRSO option (%s).", str);

@@ -2617,7 +2620,7 @@ static void __init srso_select_mitigation(void)

        case SRSO_CMD_SAFE_RET:
                if (boot_cpu_has(X86_FEATURE_SRSO_USER_KERNEL_NO))
-                       goto ibpb_on_vmexit;
+                       goto spec_reduce;

                if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
                        /*
@@ -2670,14 +2673,7 @@ static void __init srso_select_mitigation(void)
                }
                break;

-ibpb_on_vmexit:
        case SRSO_CMD_IBPB_ON_VMEXIT:
-               if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
-                       pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
-                       srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
-                       break;
-               }
-
                if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
                        if (has_microcode) {
                                setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2694,6 +2690,14 @@ static void __init srso_select_mitigation(void)
                        pr_err("WARNING: kernel not compiled with MITIGATION_IBPB_ENTRY.\n");
                }
                break;
+
+spec_reduce:
+       case SRSO_CMD_BP_SPEC_REDUCE:
+               if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+                       pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+                       srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+                       break;
+               }
        default:
                break;
        }

