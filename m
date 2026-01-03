Return-Path: <kvm+bounces-66964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A04FCEFD8F
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 10:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DA9C7301E989
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 09:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190C22DF701;
	Sat,  3 Jan 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjAllYe5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19242F6160
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 09:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767433573; cv=none; b=dupNiFnDqcP8oVUFuyBRn5oaFaONc+Jzrctdk/rN0ZqY9hLsFaYQmXZEpoNf4MpelNt02NqHGnIpZHF4L/bADhVLub/F9KP7TJNy1mPQlO1BvXl8t6UanRsnjenRQYNVXTPSOlOeahlbXdNyD81nA2ZHPm2eOjEeylIWZ2hASLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767433573; c=relaxed/simple;
	bh=qiuDGaE5GFviPLMUlJVaCxlFg9jSYMQF4FXhaN/XgAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gJLLs24KAxzL0SIMMEpPJ4a58ZtEEtEYBgKRa6fx1LO5dG0akSbNhUAjwX/QrmXQJDMMF2H9z/30YXfKSRFpQAx/ZCPZITdHuBivpO10ooMMC6ts0YdFiM8NV4kcWnk1ZCq1v7v+XW2YL4sQLTsEDVUPS4FJuaC2yAMxUwHuyhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjAllYe5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a1022dda33so102544535ad.2
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 01:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767433571; x=1768038371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QD8Sx/RaT2/O/5gLvBejwmV75tu/ja0fKa+EuiTHipM=;
        b=MjAllYe5W7hQm3ZW103GdwR5x165oSOBCB/tE0+tsTCsj5Vp6J1EQKPbQ8fgcShyAQ
         rZQAEfdMp/AQTOVhQpYWtjw8sgVIfmYpiarziEP2FmO1JpfXPysvk4byOrF8E0Fdj9iZ
         JsBTyhIDzZnMa2Ue7Sl7QQ6FtLUDvZZ/7pHqYolybIqY2lbSowIViPLH+EXThyEhOuT5
         0XGKc0ACIY4xdAUaa2jvnt2/4oD2xTei7Apecaz6Uoed6cfk/kdfsSwkJz3pC9XmEbr3
         GVyBM/VSrIY9OvO/eVEHMR5fzpAvdJFxEWU01bHs9/278Gy1u8Gbp2GiOPg3Atc/eAtn
         2lsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767433571; x=1768038371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QD8Sx/RaT2/O/5gLvBejwmV75tu/ja0fKa+EuiTHipM=;
        b=J6grkCU5uiw3f3lrrrNDbh96XqZ4mLiRxea59QD5/QB1SyaiVjpERiu/qUs+8GEs/5
         1IohnM/6Szn7W+4PyXClZqMXq6MH73OuEvLoE57rLggAxa4mC4p0b+kMfd4izGOcPSqC
         CshE5B0hpEL5llBkCCJNqzK5p9QsvZSUaHAiRvdwSN8IrW39Mqr1VctcCG/rAPxV3UKg
         WIt5Qba/BlbJTcuYfG5LRovsnDy7XxWG00s5K37E+r+QPoZEhpVotirA1Sox2HX1reAI
         wplQrcHsSDu41zWJR7iMOGk6WUzU81Pd6IsVIDr+yTcRnrwxuT/dNbGzSeM/ycBd9L4t
         tVuA==
X-Forwarded-Encrypted: i=1; AJvYcCVK0BerWRQcGRgCV/7qZLPULdSjXY61nC0MZg1jspaj4kbUKI2okCVn7+b9agtUIhQ/lVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Oa7FKOEL5uz2a0WlPUZR6otoEz+tPTM0G7AGvbmy2NBBc7Ko
	h/RES6I0un/nvXfvQhOebc76yGcLrMbsOjyvJoZUWQP9rUqZAA3dpzqY
X-Gm-Gg: AY/fxX7iBjSPA+8hOcpcWKlljLFo28YielTuVi42VDrTXKRLXnYd8n45uMoxZNtKBJh
	kbfKPqcyqiHa+Mt3cHLWdbZh2sY5CBnz7EfqGp2EfSuL7sylsx95cxYiHQiU4au1hD1/mEU+Cu7
	zrPhK6kxrlBgF7DJy7dUVsQo68x71BSxAONin///ZBxtpd9TwFGhQh2pgLIHEbYKTa5UFuFkSyb
	Lc9kD0LL4KzflDIp18KoeMLByIR6d/BJ7USoSLmVNPeNvqe5CkAHa6CBX5tDQNAPj+K4xC5Fxt4
	qCZQcQ/0SB9PoGn16RhL7D78h2yWav5iXCR7QK5zYzsHV9zguxzMaB69BKGIfP6KvG1IQQBmv0A
	r2vynHK/kqeNQd7uPY4kMpUPwLI5t69Q4DtkdzL3ss5MgDADyz47di/K2qj5sD1gaJgWk0rB592
	YGdZaVuOzyTllv9QEI27sCnvGysputb8Poi4DFl4wFScVaNMk0h2AyN4qhfNkoRpdf
X-Google-Smtp-Source: AGHT+IFZ9sPizMNM+JWU3KI5MPEz2Gf+WxarNuEkzY+cxzhhI3PlvMK1ckXi0qC5e1Tf6i9ocvTvEA==
X-Received: by 2002:a17:902:f68a:b0:295:99f0:6c66 with SMTP id d9443c01a7336-2a2f2836964mr436023025ad.36.1767433571215;
        Sat, 03 Jan 2026 01:46:11 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cbdasm403124315ad.65.2026.01.03.01.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 01:46:10 -0800 (PST)
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
Subject: [PATCH 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
Date: Sat,  3 Jan 2026 18:44:59 +0900
Message-Id: <20260103094501.5625-2-naohiko.shimizu@gmail.com>
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
 drivers/clocksource/timer-riscv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 4d7cf338824a..cfc4d83c42c0 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -50,8 +50,9 @@ static int riscv_clock_next_event(unsigned long delta,
 
 	if (static_branch_likely(&riscv_sstc_available)) {
 #if defined(CONFIG_32BIT)
-		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
+		csr_write(CSR_STIMECMP, ULONG_MAX);
 		csr_write(CSR_STIMECMPH, next_tval >> 32);
+		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
 #else
 		csr_write(CSR_STIMECMP, next_tval);
 #endif
-- 
2.39.5


