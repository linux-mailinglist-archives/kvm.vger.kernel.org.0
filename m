Return-Path: <kvm+bounces-66965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F39ADCEFD95
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 10:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A7A3C303443E
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 09:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB502DF701;
	Sat,  3 Jan 2026 09:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpbiXT3u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC92F5A10
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767433577; cv=none; b=COp+qzlsHDLfThK8tec0aqz3lhnSf3+GZ9+UmsLKDk14APwp5X8Bvw1XfY1H7s8QbQlu6wK4PmgYaqULj2ducgB/NZLVlROfTdfgVxfIZcDaX8pBp8IxSJyxPProSgqA2cBR/yCCJLDR8lYbgQI6aUXoPTETk56JrhUzjpXU2NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767433577; c=relaxed/simple;
	bh=yc4wocHubhJNjuOJ923K2RmiU09pvoJT7Cjlm+DcU+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oiZHfVcZGHssyAQumcSakGbSxeJUFraBFtcbxHRs5vBnpYzQb7xxxkKYP343GHsq2bq4sbZexC2mmxo+m4fmahQvjVBgxxjAT4FolOYbLqfGJjI23d5KJuJzyP6jIyxZMmGnlHvG3DEib5fVka6vn4SolxuD4A9sFGa9AaHjhJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpbiXT3u; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a12ebe4b74so226666135ad.0
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 01:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767433575; x=1768038375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxjRzDH8YfA2CgJ8ukRlCUfNc/bMZBLM3ftExUQvlc8=;
        b=CpbiXT3ul96SlIlEKAVPFONPB0ilsaJ8ZF9177y3PFMkzapnX6j+L17C54PbJT/Rdj
         G/avRhjj327eWzEfu/T0imsPH63MEGqVE9Tdm8Aw8o5TTSsFVoEV/iYMjVmCv2P4+FEw
         5cr+GC7N6AVKkkEVB/p1LTLbmcLNoqqnzlQoYRz+kw/S+CYSz271ZVnH3VeYiY5BgmVm
         2QXsLNHH+JIv9yCLYVKvLZdl1AxbOvanLkLD+uWXpPOhgrxy1VILLWcikHAN0HEOXUfQ
         1kkWDCZ7aSYf/S1LvpmrPENqt+CqxItZYorPudMW2EYDimxRAiJ/0kKOZRYrVAPEIIM0
         FkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767433575; x=1768038375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lxjRzDH8YfA2CgJ8ukRlCUfNc/bMZBLM3ftExUQvlc8=;
        b=fJaLZxO692HarO9+8LZmPYOzIXyYY+USNxPDi4FeQnJdIF1A2W6pbxdzpuUYdm8uvV
         EtAyMll2g4NyRuAUjTQ0ZbVrQNcDi2sR1T2fqTUz5SdIsb1DAd26o7Xeoqfjo7va17bE
         AVpBonVlnMxk6gGoSsbWOUd6mzXvPrwPm1oFDajGC/U+MGYHuW5vkeHXk31gKuad/BXf
         ZZR5W/qPKR/8jmx1WgYXCcI/tyWCPg5tXyGrsQhSi20y7dkXuI/4Vo6FYEoTS2xWbmi/
         qNfOnE8M8qCVAaZkeMZZ85Dg1kKxhpJeGhIwfThjBfR65Tegh6fqLo+WCspPowXIC0jm
         d64A==
X-Forwarded-Encrypted: i=1; AJvYcCUKawl8YetXgTR7KY3SjNmkDodg47yoGa6l7dVAtAIWpOlU3239JH04hAX7W0WB4BjckmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLkjTNiGwKyXliUDEZXF6dHHOr1X0CIUvouFLY0A8gtFttzhfR
	TEy8VV85AG1QELEHXtgKG404sj9tmz1VvJduNVVvCyDfu8KWW27rcy5+
X-Gm-Gg: AY/fxX5g15K2J8E30lhRZt+bX2mA5evo71kUk3Y9QnLqbVa9+JJljR6Mqe/ZA2MXwIE
	3dZG1+6BNwfdZISajTZbgq89QZp091yB16MA0yONU+sKCT4UmB4EmwsM5KlnN6vu634DT7lPh4I
	UmrE/oTO+gbXvTWcMEYnbB4vBYicQnUMrtK8X1F6QajlKP9HD+23kS5gEvmsHMnNRIsW2bLHHoP
	hZWhGT218WMN0pgPxxQHj3pPQEf6IheYX2+XEevDC6QMJl+KisiJ9b9ypzjPmEygANGxP2ue32y
	xkoS2FYMywgym03DF18GbgPsWes8WgfGbXixeoxH9STNNtUi89zE44rCdamd7uYaRy8/WWgEqwq
	2icLSqLZbAAEFH3K9mxusZKgGzrEFYSfsJHTSmw9/Fib4N/9ZnRTBJwZHN+7nlKk3zF2n/PCiJK
	ox11hI59u42HFaJKOr5bTAaYxp4Hy2Lz4gd8xnRFjVBP7AF/GwT2EXLHQ3vO9l4CLW
X-Google-Smtp-Source: AGHT+IEkB956+B9xGmx9cTGzL/pONpKgSLBP8lNFvd+0O3zkG68Mte459jHa1jjHCkA3n/rN8fRFsg==
X-Received: by 2002:a17:903:290:b0:2a1:e19:ff5 with SMTP id d9443c01a7336-2a2f273818fmr480811265ad.38.1767433574809;
        Sat, 03 Jan 2026 01:46:14 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cbdasm403124315ad.65.2026.01.03.01.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 01:46:14 -0800 (PST)
From: Naohiko Shimizu <naohiko.shimizu@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	atish.patra@linux.dev,
	daniel.lezcano@linaro.org,
	tglx@linutronix.de,
	nick.hu@sifive.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Naohiko Shimizu <naohiko.shimizu@gmail.com>
Subject: [PATCH 2/3] riscv: kvm: Fix vstimecmp update hazard on RV32
Date: Sat,  3 Jan 2026 18:45:00 +0900
Message-Id: <20260103094501.5625-3-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
References: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>
---
 arch/riscv/kvm/vcpu_timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index 85a7262115e1..f36247e4c783 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -72,8 +72,9 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
 static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 ncycles)
 {
 #if defined(CONFIG_32BIT)
-	ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
+	ncsr_write(CSR_VSTIMECMP,  ULONG_MAX);
 	ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
+	ncsr_write(CSR_VSTIMECMP, (u32)ncycles);
 #else
 	ncsr_write(CSR_VSTIMECMP, ncycles);
 #endif
@@ -307,8 +308,9 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
 		return;
 
 #if defined(CONFIG_32BIT)
-	ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
+	ncsr_write(CSR_VSTIMECMP, ULONG_MAX);
 	ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
+	ncsr_write(CSR_VSTIMECMP, (u32)(t->next_cycles));
 #else
 	ncsr_write(CSR_VSTIMECMP, t->next_cycles);
 #endif
-- 
2.39.5


