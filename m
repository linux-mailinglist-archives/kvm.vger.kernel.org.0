Return-Path: <kvm+bounces-39512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA0FA472B4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9B511887890
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570C022F176;
	Thu, 27 Feb 2025 02:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nm8uHFYu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9504722D7BB
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622788; cv=none; b=OFVnOGpKYHqeddcl9nehtcrDVbOlC+5TmR5re88V9Jq51OI5Jc2yxlUQKhBCwmJvyah1DNUkqVk5MkTlSp5spQ9r6axDF3saPcPBw/K64zqgpdH/ar86Ij3lnnDRvmhilorRHIw/m0Loo2rcVVf0Ums1OKoFBUTMNAztX1AVWiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622788; c=relaxed/simple;
	bh=2a8H0eAkRitgl8N78ADmzcHYgYnoAl+7GQjDO0K/gtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uWv1BwSNgSJQrVsHpVz/uI3tQMK8t5yC4wuE8k2fifamcPPWqWURxq5pKqB4Rr2Q08IFgH9GV0ILx7DN31ANVSu+Ac5EqTYrwRhCTQF0Qfo9BDl4j7njDwmkQken9g3+c+yT5gDZHYG0LnDwmgGr97nKlcYYahZGFEeclLBMKBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nm8uHFYu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1a4c14d4so1064240a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622785; x=1741227585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qN8YI5wmqMG6yVEs+7cu8Sw/AfoU86Z3NaGBSlCYqu0=;
        b=Nm8uHFYuFCk8Bd2Qof4oqMWXSWGl8WVAxHjMxvQY4OFbVcZmBLVgG/N5xWGh8deco4
         bt3AIBG6yct8eJW/F6RmyoZrfmDQLggUH6t+q/debx423fkAmEhwWRJuymWTmpuiiRC7
         /P+yt6HaBQxc83xO5w35QbmGvQ55JUQCwglUDc7XDMI04DPOG3ZGPmz6qDLRsEmSuYDj
         KVUVzKlzVmbvAYldM1erDs/9pX4bSxKfB0thCPvgmlgeQp7OOzUpvNWUMA0gOXktNi7z
         JF8nv4+x1u1DMTwnkpV3RsVlQoqe4odhcfQenOF1luUdcA/2UCyrLsHh6+53/KrEu8Oi
         bHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622785; x=1741227585;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qN8YI5wmqMG6yVEs+7cu8Sw/AfoU86Z3NaGBSlCYqu0=;
        b=qZgvfcHox60/Kp9ELACsxFqP+GglXNa7a8hmqQxDSXhi5eTGlq7azsxtk3R9JfxX7M
         UGt2vm9QQK7bjVIRzskcob1fMm19QKizuovnqGV40+eg5/QFEINKdDNM41DKw8Jex8Ea
         PYOwKuXvR+uKmRT+8fddeIVnY43ZSsxmOGyIVk9dY4DVLMLWKj8+EUsVKVXcVAQDcxjc
         7XKZjwOP7qzDPV3idhE2JbLYCNzCLdpmHb2AxewwSTTh3dNEtjNZG+thizS1y8rvf4bH
         iTQH/S4LSxQmCGtrCfrYjqIGpZARm0S/7EwPGJdf67dD+0vVJPDUnCWYPUAIYBPFWkvz
         5TtA==
X-Forwarded-Encrypted: i=1; AJvYcCXUdkOvqwmgatVOZ3EU7uv1zrIrJRwaHVIW0DravdmSPA1MUd9TJX9BmCHDLVhIgyZ1/QA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDm9zdDtWELkgWzFU0oznMA5pzbkt9SGBfb51YrQYXmgxl0Rsc
	9vnlPg+sRFO546y7zR/Tu836/qIgBdbek+kQBfHsa0Unt3DbJMsI4EvzSWseSDK+NhwYD0yc/3+
	Vwg==
X-Google-Smtp-Source: AGHT+IEw7VZRln4iIrg1rWM/7IZnuYkNWSUUNxKKGfY9HmA7vrLySNMf4INY1k647TDU8xAK61s1yi1H724=
X-Received: from pjbsw12.prod.google.com ([2002:a17:90b:2c8c:b0:2fa:284f:adae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5243:b0:2f4:434d:c7f0
 with SMTP id 98e67ed59e1d1-2fe68ada3e8mr17648463a91.12.1740622784911; Wed, 26
 Feb 2025 18:19:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:40 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-25-seanjc@google.com>
Subject: [PATCH v2 24/38] timekeeping: Resume clocksources before reading
 persistent clock
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

When resuming timekeeping after suspend, restore clocksources prior to
reading the persistent clock.  Paravirt clocks, e.g. kvmclock, tie the
validity of a PV persistent clock to a clocksource, i.e. reading the PV
persistent clock will return garbage if the underlying PV clocksource
hasn't been enabled.  The flaw has gone unnoticed because kvmclock is a
mess and uses its own suspend/resume hooks instead of the clocksource
suspend/resume hooks, which happens to work by sheer dumb luck (the
kvmclock resume hook runs before timekeeping_resume()).

Note, there is no evidence that any clocksource supported by the kernel
depends on a persistent clock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/time/timekeeping.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1e67d076f195..332d053fa9ce 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1794,11 +1794,16 @@ void timekeeping_resume(void)
 	u64 cycle_now, nsec;
 	unsigned long flags;
 
-	read_persistent_clock64(&ts_new);
-
 	clockevents_resume();
 	clocksource_resume();
 
+	/*
+	 * Read persistent time after clocksources have been resumed.  Paravirt
+	 * clocks have a nasty habit of piggybacking a persistent clock on a
+	 * system clock, and may return garbage if the system clock is suspended.
+	 */
+	read_persistent_clock64(&ts_new);
+
 	raw_spin_lock_irqsave(&tk_core.lock, flags);
 
 	/*
-- 
2.48.1.711.g2feabab25a-goog


