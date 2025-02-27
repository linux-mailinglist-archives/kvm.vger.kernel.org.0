Return-Path: <kvm+bounces-39499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D275DA4724E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2DC51887703
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FBC1E5212;
	Thu, 27 Feb 2025 02:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mfl5tOLB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1F91A0730
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622764; cv=none; b=sYA7tf7dirSj95kFtTcmDESShImj4aatmT/rj6vpVIL7WDt/1BTqvtyrXIUBozAVet9hWuNKH4RIuhBwmJ0gJ9yYq3pMsFHib7Lj20rnsTJmWqd4RU05rT1ZXMyg3/M8OBMsW3fBVqcMg1tu5UEdHwZ7I0HIVrnX1lE0husWX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622764; c=relaxed/simple;
	bh=YBBFB7GmxuAVG9YiGJjI2SvbfrD7XwOfpFXbtpwvuc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fcRVqTnQYqZ3yBVr18OjRy/2s6lEDxYO3YxiVKpWvL9WW3e1HHR5l2r6WmtCJM4YL4yPERJ3tvS8PMzHTHfIGZVRCHGbl+9YqM2DwHvWtFnTgpd+rO2JGbVBv1JfXLe3jI3Id74O3Rg8iyz7u6QQxnaOT4CQAV0ciLCbqajjPmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mfl5tOLB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so1565643a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622762; x=1741227562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yPGNLLFa/vXB2a0UM8EIYJpWd3IhBx8wcQJSj3RCAHc=;
        b=Mfl5tOLBxPPbZBxbuE6j27RikeaJMT8bJZcimZRek0AKjVfDveP7flohhWlEDHUCyl
         j0KsuPelGvo+36ZpDb/YCo0BwozOYknCCdKWkVXMRrNxweDfHuCbvm1XuN06Ak1Zkz9w
         blLrd7kaGYs7b6at1rblABhB6uZtnQvD2LUsQwVTFmUU+8+MHxPf7ftMmhHT1kJOzPdD
         m3S8bfaI1lB4xobOmyvZfiEiB1vh0V+DyKNmgB5Cc2zIFrBIVFQjNX2XvQcy9f6hJ3XJ
         bxGbSP5Mq1oIn5gQs3epb/NuKczYDNh1zwiE6OtGS5cBIIV6bO9bgopTtBMS1aO0nSUI
         iLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622762; x=1741227562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yPGNLLFa/vXB2a0UM8EIYJpWd3IhBx8wcQJSj3RCAHc=;
        b=Ipv0ftBcqe/Eydw5VciSZEYcaKd2o5I4ldEHNVvurjSKu4MFd2VJszCHL/UuDETHDH
         QmyAgyuFf04coUU/T206u1cZe5IPKWV5eE8cLImhFy2ZGfBHSLnlrju2lfsuvpml1kvg
         duIXhBrw+5JncpdBF0iOJnYI5TNCEFNk1LcEqlPGCfdO1sMqI9UZHhV+A26HT2Wl2tyR
         Rtw7xUnKD/2JCx6Nd3cMBbwTJ6M31XKwkCN4+n+X4BCrilAMcXujdNSWWuHSwfa+g8Cy
         zw3qSuSu9u3nG/jXccasEOW2pfh0YlaKB7o1kH/ZUap54mEMTbd+Cv0Ln3BKD17zgy/p
         Y05w==
X-Forwarded-Encrypted: i=1; AJvYcCUIgtIW7+aE/HBXCgCL3EiTeM4cdswjyyUFib3y32wMQ27ONek9qIAryV3OeB5Jtn6PWOE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx58fcJZkVktKq/hHW2nWCca3rnlzUG4v+mJsl9OzYQ3FoU0Q1S
	C+BGwoOoDOWXjRdr7t3Ijd0p1qOZvPPHZuchlL4rl29/skNFNtMzolnAYZMK+CqkFPwA5orKbk/
	vQw==
X-Google-Smtp-Source: AGHT+IGTG4bhtwk6xF9NkwSwRr4MZ0JMu1OW/uXbFyNTNSUBj4feLwfxPugt+I59qi4711mZsSVJuOvx1D0=
X-Received: from pjbqn3.prod.google.com ([2002:a17:90b:3d43:b0:2ea:5469:76c2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:fa14:b0:2fe:84d6:cdfc
 with SMTP id 98e67ed59e1d1-2fe84d6cf88mr6952534a91.35.1740622762299; Wed, 26
 Feb 2025 18:19:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:27 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-12-seanjc@google.com>
Subject: [PATCH v2 11/38] x86/kvmclock: Setup kvmclock for secondary CPUs iff CONFIG_SMP=y
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Gate kvmclock's secondary CPU code on CONFIG_SMP, not CONFIG_X86_LOCAL_APIC.
Originally, kvmclock piggybacked PV APIC ops to setup secondary CPUs.
When that wart was fixed by commit df156f90a0f9 ("x86: Introduce
x86_cpuinit.early_percpu_clock_init hook"), the dependency on a local APIC
got carried forward unnecessarily.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvmclock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index b898b95a7d50..80d1a06609c8 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -186,7 +186,7 @@ static void kvm_restore_sched_clock_state(void)
 	kvm_register_clock("primary cpu clock, resume");
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_SMP
 static void kvm_setup_secondary_clock(void)
 {
 	kvm_register_clock("secondary cpu clock");
@@ -324,7 +324,7 @@ void __init kvmclock_init(void)
 
 	x86_platform.get_wallclock = kvm_get_wallclock;
 	x86_platform.set_wallclock = kvm_set_wallclock;
-#ifdef CONFIG_X86_LOCAL_APIC
+#ifdef CONFIG_SMP
 	x86_cpuinit.early_percpu_clock_init = kvm_setup_secondary_clock;
 #endif
 	x86_platform.save_sched_clock_state = kvm_save_sched_clock_state;
-- 
2.48.1.711.g2feabab25a-goog


