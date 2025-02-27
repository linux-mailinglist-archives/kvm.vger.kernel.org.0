Return-Path: <kvm+bounces-39520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6606DA472DC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C43A188BD47
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC4323C8AB;
	Thu, 27 Feb 2025 02:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kL48CMa5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6DD238D32
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622802; cv=none; b=NqEGvsgOywZzY7sSehpCv6+Hct6Fq/hNnTtrC7hzZIvPkG6BiaPvAGgAoL27gUF3cZRMpRHJn4kmRl0Ryjp0NjIXEjCjirHvQ3vtVkwacZ2x3tWeL5ujZEdPXa2JeJApQSgBNibg3CkzwrZOrBNdXcZBP68c6ZngFhgHGfh/P7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622802; c=relaxed/simple;
	bh=XdZRYBlPZyw/8jtawHaf0Gd25EjncrTXZSrOsMRCotM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I4DNvzFXzi+rPhS5w5z8IyzGDyBGWJJUtK+Rih4NHzc3FoYOxmpOsEfY3XzLe5I+QZC3NqrM463AyRkMJtcfEn8h9p8r5mv6iAV5oMjsh3Zf1231EpLAOjbtXe5eeLbxFOjyjDglNSZy1BBA4tcyBMTPi5zQsRlLfXAstl4BPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kL48CMa5; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe8de1297eso1024220a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622799; x=1741227599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LZJJLySVHQgVgABAB7C0XZjDtBlLYwz9ES+Z1vP/8LE=;
        b=kL48CMa5HC14aNbI0Clsz2W/FXFsbTLSaq66y5swjaYLwy92G2/KOpyXHgPIdH1wA0
         7pdF7gDgm1KFZsaLOrC3vhi/1/NU1Kds9jeCo857ZMxKJy43ucAAGlVApPm80cP7fyJ4
         Ak3WGFAoZWP9p56PU/FtWgNi8x8LSfI5aSLZeENPtLkZJawX/5O0IB3pAhCL9FIW8JUw
         HQ5rSgm47il+rEQfdN6ul6S3Av+lh9JmyzPlpTfaPzPHACpvbCJxvWjLGa2SYgTuxu5F
         HYMmTbNr5hAw8O7aWmxnWa8YRxFwGyF9JTHnUZwtFjhqZpYsP1zTTe2hSkBq5qh4Ig0g
         4Dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622799; x=1741227599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZJJLySVHQgVgABAB7C0XZjDtBlLYwz9ES+Z1vP/8LE=;
        b=O5tqeji56JcEiqYwu4NsjXrXl8OV1LKTaRVkwurBNGGRhJbgP8m1H3b9EniVjUry9S
         sPe1Vp6YBC+IPV9GfsHTvDlRqObBzMJiTleNZRzF/b1sFGWEnaRnH3CeLaCHBrhORnzi
         V4/WbxJpaUC9P876a5bD7sNjN5Sb/y/zrL0zRw0TlGGHcN59CLybm54Pcz736UEJSLZo
         GT63SPsfPEwwmmVEkzhuIRkqq32d52rSIncZ5EJlvoNvy+VVU2isV3f6U/zlUPjgrtGI
         aPolOnu7y3OyXQ/hGQsvznuQpm5cRuewfFuXbhKGGBssM/jaJ8WCoefUAEBBx4JTbUj1
         /L+g==
X-Forwarded-Encrypted: i=1; AJvYcCUNhNNM4IoMz/+iOjqrFY6vqOb63EuVp00/woNLD51fUfpBJqC8FXZe/F/FkVbrYU9Y/Ks=@vger.kernel.org
X-Gm-Message-State: AOJu0YykTXxV2ybSNV/u+mIBPPH9/Cgu9uTuCsRjAi2XMCPQKYUzteKr
	gVuJ+FyAWRTtjRp4AH1s0um61nH61+Tnw1DOW/TrKiQ3X0KsH+ruHjhXnthTRnDsG5WHId7GGy8
	UkQ==
X-Google-Smtp-Source: AGHT+IGhmfOgzOy0w88MLax4aQJq7WSM6/RTmeD/HK48z8QB3SAzs8w4kTiAhr4wwBRMQkXZhflq/qsZ2GU=
X-Received: from pjtq6.prod.google.com ([2002:a17:90a:c106:b0:2fc:11a0:c53f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:570c:b0:2fa:2c61:3e5a
 with SMTP id 98e67ed59e1d1-2fea12c36b0mr2515446a91.10.1740622798574; Wed, 26
 Feb 2025 18:19:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:48 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-33-seanjc@google.com>
Subject: [PATCH v2 32/38] x86/tsc: Rejects attempts to override TSC
 calibration with lesser routine
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

When registering a TSC frequency calibration routine, sanity check that
the incoming routine is as robust as the outgoing routine, and reject the
incoming routine if the sanity check fails.

Because native calibration routines only mark the TSC frequency as known
and reliable when they actually run, the effective progression of
capabilities is: None (native) => Known and maybe Reliable (PV) =>
Known and Reliable (CoCo).  Violating that progression for a PV override
is relatively benign, but messing up the progression when CoCo is
involved is more problematic, as it likely means a trusted source of
information (hardware/firmware) is being discarded in favor of a less
trusted source (hypervisor).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/tsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index be58df4fef66..ebcfaf7dcd38 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1309,8 +1309,13 @@ void tsc_register_calibration_routines(unsigned long (*calibrate_tsc)(void),
 
 	if (properties & TSC_FREQUENCY_KNOWN)
 		setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	else if (WARN_ON(boot_cpu_has(X86_FEATURE_TSC_KNOWN_FREQ)))
+		return;
+
 	if (properties & TSC_RELIABLE)
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	else if (WARN_ON(boot_cpu_has(X86_FEATURE_TSC_RELIABLE)))
+		return;
 
 	x86_platform.calibrate_tsc = calibrate_tsc;
 	if (calibrate_cpu)
-- 
2.48.1.711.g2feabab25a-goog


