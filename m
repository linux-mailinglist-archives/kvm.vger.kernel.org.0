Return-Path: <kvm+bounces-40670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BAEA59989
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57A2B16F1D2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1809622D7AF;
	Mon, 10 Mar 2025 15:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sdD/23dZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4C322E418
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619654; cv=none; b=eW6TzbqwtnZaGI6SacU8f36u7UCdMlCiQnb7XPD0jUuuUCcB1aQ0z0Gf1lczPqFM05LsHlOGp+bRpttDrL9dxbnigyfE6MJ3rCo/ASeIjQilkhGCD3wCB7ymvE3VNphhKBnbO5+hoXe+1i7q6HFk5Fgh9gjKXsy47N2MmXlVH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619654; c=relaxed/simple;
	bh=o8LicozigsBJPUxfw0UjH/+haPfd2EDEodthfJ8bhLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQCuBgT12xVAFLLDuiBDQo4MnctuvvHj1hJPgf9d3VsQq0RyG4jQBTh+xMtbMJ5Ii+wcfe0RqXIe+e/JbZjzYJAkvRw1YhtjWhyKgjCz3LjWDBICZaidZMyqa3NWWCCQKwqOT+LyPgRrNpbxQvU3M4Dz0ieDcvD9jCbf+te6GN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sdD/23dZ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-224171d6826so64657545ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619651; x=1742224451; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NTEMNxwWUDdJDHTSWR5BaYosnBDapUg7Ev6g031TeV8=;
        b=sdD/23dZh56zIGm8cLD57MT1KljzYrdDdt0dTNjXryen8/XPut3abB0rYHPCsTnwIl
         xBltirmFV6nHe57X0hLBs9mWLRWy4vI+sZj2qGbIKjKJtVbtnuJzYRLZrCiM7XM/ahwJ
         ZpXOcffhvM+w+4+bsrIeOXs0dN1CGZ+NFBFTQYQR27GGRth8cMejLYM8u6/i1a3mc9xP
         IrDyfcCA2Q4tgWfDQV/kcIlWNB4HFx1rOX3QKICsv9NkXWic3SPDGx2De36h2SGf+uJ9
         4KAjrCmLACeHBpGjvTXIMYcZmASp0gPbF919FzQkH6r9/oZLBGobFP9q65GeHJklT/Uk
         Hu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619651; x=1742224451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTEMNxwWUDdJDHTSWR5BaYosnBDapUg7Ev6g031TeV8=;
        b=nejUmUn50nq5FnpzUyEegFKVDvRyLo58kr+wRFesQtIeexqT96nYpOTjaCWMDt88L7
         TvLpl51sy1tb+E+B9pQNfBAxP8qhsde2Mfr7eWSWXHYhh2Qe6FFHAjY8FNY/kzrW2GGo
         HOzYx9QccBI64CzF2dltJBgKbSEjCHDQHJxJhTEhVZQCFU7d6xGfzMjRwCzkGj1FmN8w
         NkufSuas5ofVF0GPyx/r3Yh8MA2V5OHiv3lCfJUOg4X5UnxVrjnXS5/bpk09zhmrAMuk
         TZJbIQcTkYzZNWg2pxxEV4bmqelG7z8TjLxz6PrTwGoNG0B/a/q+1jKussya6kADBAfW
         tIBg==
X-Forwarded-Encrypted: i=1; AJvYcCVrXsnVAhwIpKteVkDYEK35zkZJdxhM+ikwlcskF98UaozcEQhhZOHYrYY0fMiHJS+WvnM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzORPLlPUksvd2MNc80USdKIZVhf0nn12vbGPAJfovRd4I98mwb
	Tkx5D9N+yAenKaTN0yoZ8Cjb1va4purROlftnqO/LyDxV0aWgnZWUd9qLcmYx0M=
X-Gm-Gg: ASbGncs2PYw7HreoRNq8SYanlygAuJHbmPsCOxJ7KmjGd39MZ9zZsOK2IZVY2FZzZ84
	s0Y06LOH2PD8KoYZZYbJV26x+Au0AQ3fUlacmLmjbJEFhAQGtXRXdL6Qw1mceZPIdbZJBtF+7n+
	WZIl7xoFdQrlGbXA4ed7M39XjPPz62nYv6awMXD6dSaRtyDCaPrO8oiDZMpk8k/3NzZ7BzTCw3+
	YNBo9sWIjSsH6e27Hjlty+Z9z91kjRQX6aeKb9KlFeKP5wY0jnDvypj99W6XfWswitwjo6BwF4+
	6NN1jbCTgWZK9oUdElyABx1g+lPaLME9QoAnZjMbjH/Z+w==
X-Google-Smtp-Source: AGHT+IFrDg0cMkxcg3xxzzqPCaOQUBTnQwFpZHXCVcuWzC1x8fPkcfYHuG4bXSCleAdszR5qGgJy/A==
X-Received: by 2002:a17:902:d54e:b0:224:1ce1:a3f4 with SMTP id d9443c01a7336-2242887b415mr253277735ad.1.1741619651099;
        Mon, 10 Mar 2025 08:14:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:14:10 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 10/17] riscv: misaligned: enable IRQs while handling misaligned accesses
Date: Mon, 10 Mar 2025 16:12:17 +0100
Message-ID: <20250310151229.2365992-11-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We can safely reenable IRQs if they were enabled in the previous
context. This allows to access user memory that could potentially
trigger a page fault.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 55d9f3450398..3eecc2addc41 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -206,6 +206,11 @@ enum misaligned_access_type {
 static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type type)
 {
 	irqentry_state_t state = irqentry_enter(regs);
+	bool enable_irqs = !regs_irqs_disabled(regs);
+
+	/* Enable interrupts if they were enabled in the interrupted context. */
+	if (enable_irqs)
+		local_irq_enable();
 
 	if (type ==  MISALIGNED_LOAD) {
 		if (handle_misaligned_load(regs))
@@ -217,6 +222,9 @@ static void do_trap_misaligned(struct pt_regs *regs, enum misaligned_access_type
 				      "Oops - store (or AMO) address misaligned");
 	}
 
+	if (enable_irqs)
+		local_irq_disable();
+
 	irqentry_exit(regs, state);
 }
 
-- 
2.47.2


