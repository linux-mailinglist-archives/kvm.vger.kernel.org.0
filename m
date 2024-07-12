Return-Path: <kvm+bounces-21563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1616F92FF11
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 19:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 419C91C22D8D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471FB17DA3B;
	Fri, 12 Jul 2024 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhMe8Kzt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444617DE29
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720803728; cv=none; b=UDfjLzRViyvRJUrG703c+taZ74EKBCJxC3VEGIQ3tq4g/34SzLkSPbABPXrH3GsBn6f+ea2r4dXXhgtzXfXvsMsANkz+Xs1YQjnGOVj3UAS2bd2jGZdJvFcglpmTEKehN46/8lNqlBSQCAuakcIbrJ2HYe2d59BD59tBZUJPPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720803728; c=relaxed/simple;
	bh=YkaJF7Xf4QM1+szW+WKOyK5ItJOpiRPMrYEvbEfqZbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NgwjF3Qos49sUPwWKjp7OGGkncsCZ3jKqU/h5gZfHB1KjYEcEMtKz1Qi8fYYLXf3OzVg1VieySX+VZbGtUJGFBDg63d9DXgIzJgjwU6cAVZcsgErp5NlBD6PG+Avh2EqoRGX9oXLUS1CyFgr18OTxuzkSl2YfWEKqDFWE/l/Kvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhMe8Kzt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-42668857c38so15413905e9.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 10:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720803725; x=1721408525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dYEbdVw49p7KL3LM6Ug+7tiHwUhfthVzlKoBikBuWUA=;
        b=zhMe8KzterI1hpUMnNShaiFtQ2RejWo5Y//TQSed6cpWSJDdYvktR1jx6DMuJfXEsu
         7YSE25yCEifXGNsgY96Klzq/ck0jgcsydSPLbXBmQwDo4guflswu0HwGlN/qbNvbrVXc
         xuiVd3cEPd3JQZ8Q6PFgjRMFhmxO2BCOHDQOdvhZv+h1EBT0sC+XpnFT8JnqeULewl8z
         8XECTYGso5RoFe6gLv9M3b11Sv66A0YaIHCVPqqoGFiKXWllfFsim5eVWg2esyzaj6eD
         wY5YOTIe1wxX0jiiC09uC7wgUEFY9GSg0zL5qd7zwZ2VPZAnu/0DBSLDnToFNDzOz1c2
         1Vjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720803725; x=1721408525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYEbdVw49p7KL3LM6Ug+7tiHwUhfthVzlKoBikBuWUA=;
        b=hd/64Ys9JkBJneXMg3FNdkMKzgSvWdgju+d2iBhra7btRSLhHG5MTgXsgbsO7yIyXF
         IHobE2OzPvuBLHXVMaDdUnP2gQNnD2qErgHyDSJ2+Yx3BiyGfUNBwnai+3lvNkhRHppe
         lvGOoCpQ0EkJu0zBZj2xhfdVvu6AXvYjkrqyM4JRykOcObPbVWNpeSMaMA1OQuhkOGel
         Wte+LCw57XLfkXMQjXETPFcHgwtTDtSpn7PFBcoMbvXy1SlFRQ3csbtB/8MSxmTTLlJB
         j+ATaYTqqupPeOIlO+K0AizIsArGHmeoaWZ/rUiazXKVOZRgtymeOsDtKVwG2wTT5SSu
         +sKw==
X-Forwarded-Encrypted: i=1; AJvYcCUBrotY3Q81ZyXaU0KTxGnUqnVGcvGh6FvzTx9dIOmZCudHVMf7MTA40GrTGtUBldHEs9qfSYgYOuU87JGBxQ6CVyN3
X-Gm-Message-State: AOJu0YzMPTFowTgatJWFR2kyxS4rZQP6qwUTyJbe3JL5lXcdul1OReOd
	9wrmrkWaS5/ri4fVHnxhE2wNqCraoTxdiQDhC7K4byhQ+TM6fa8CpircCveHOF+EeKj9Q7j+YJR
	JtFmmajGE+w==
X-Google-Smtp-Source: AGHT+IEpFjrIcdozWeccrHJ18iMfCUI+HuVuPHUhyCg9CuNp5bbpeH6dXY+Lf29VqG6hp3YNWuNGMoEtsiBUuQ==
X-Received: from beeg.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:11db])
 (user=jackmanb job=sendgmr) by 2002:a05:600c:5129:b0:426:6a14:8e62 with SMTP
 id 5b1f17b1804b1-4266ff87a5fmr1913465e9.0.1720803725228; Fri, 12 Jul 2024
 10:02:05 -0700 (PDT)
Date: Fri, 12 Jul 2024 17:00:43 +0000
In-Reply-To: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
X-Mailer: b4 0.14-dev
Message-ID: <20240712-asi-rfc-24-v1-25-144b319a40d8@google.com>
Subject: [PATCH 25/26] mm: asi: Stop ignoring asi=on cmdline flag
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon <liran.alon@oracle.com>, 
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
	Lorenzo Stoakes <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Michal Hocko <mhocko@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Valentin Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Junaid Shahid <junaids@google.com>, Ofir Weisse <oweisse@google.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, 
	KP Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, 
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

At this point the minimum requirements are in place for the kernel to
operate correctly with ASI enabled.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/mm/asi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 891b8d351df8..6cf0af1bfa07 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -174,14 +174,14 @@ void __init asi_check_boottime_disable(void)
 		pr_info("ASI disabled through kernel command line.\n");
 	} else if (ret == 2 && !strncmp(arg, "on", 2)) {
 		enabled = true;
-		pr_info("Ignoring asi=on param while ASI implementation is incomplete.\n");
+		pr_info("ASI enabled through kernel command line.\n");
 	} else {
 		pr_info("ASI %s by default.\n",
 			enabled ? "enabled" : "disabled");
 	}
 
 	if (enabled)
-		pr_info("ASI enablement ignored due to incomplete implementation.\n");
+		setup_force_cpu_cap(X86_FEATURE_ASI);
 }
 
 /*

-- 
2.45.2.993.g49e7a77208-goog


