Return-Path: <kvm+bounces-66989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7554DCF10C4
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 15:00:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2D87230022F7
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 14:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B91B30F533;
	Sun,  4 Jan 2026 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmEKechD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F252356BE
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767535214; cv=none; b=RV3fHPidReIyyIoDhca8SVTNAo5UaV5LkwBsK1Najz20yuoHPgT5Au6Z3a7w2cQ2Mv4HPguNB2hLO4fMrAuHhQUJAGITmLX00rxG+VZDZ41VlsXZOiQn+Iul1IcXcycpzR+i/PVebbvncHVDfIaSkTgx6ROR95vcnKCl+iWzyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767535214; c=relaxed/simple;
	bh=NsZ65gDJWN1ovH7JAOaHR6jRLwtFs3DZftFiqLTRFl8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YQq08/c9nZP6ETDKgWsd2Hz5ZQmPX+Rfz3crn3XTS/sa4TlFcTerZpLW5rZXUnbPlPQLbnala2wzBc0uz/R7EQKN5PsODTNrQ2U6t5Cgv/K5cWKHocImmwEnpueZUoE5VCH7mNJ6Xv3vsfPSJz7ZY8g3jip7lod9DZhqCAj5C/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmEKechD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29f102b013fso165748985ad.2
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 06:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767535212; x=1768140012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uKC0H97nVlNsmqfTcj9M3djnqsg1WIKTEJ/Ie/Lsi00=;
        b=fmEKechDYbaCy5Ehxa6MC+Pys6iRRo8LEXHn2bnXXeE8/5+Rs89bBXF1BSGozZYM7l
         In0sz5gPfEgFBTp5D9cKqfyXxdWq7ZWTGRXJITu68Y2ymzuplfMnScC+Tygvm+XezPYg
         a65S5YVln1uXwq1v/cd2Ujo2mKskY6+mL9Cf7qPDJKYISDqmerJQJa1HUzOWnY6R3YWP
         aDmXFobPtKHvBBpq5h8SR+WSjne/bcN4mD9B92DX/dOzJ+WckM/uEbGUtuOewUJUOOzk
         F48W80/8dBR5vsf7QMIEB0SxebcieXuvoJFFVsdVPcAesa0nze3dnLftm2oYH1Unw3t/
         H+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767535212; x=1768140012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uKC0H97nVlNsmqfTcj9M3djnqsg1WIKTEJ/Ie/Lsi00=;
        b=CfKgPi+Q/CS+AsWjhgjj9VvGyN+TOMDKLqdPRTr37XPF0dI1EVaxtdEPMF5bpV47wq
         zGujVdOUI5rBoWDVZiXJMjnkR7zICTFCVSSD7YKMJmy/00QMoIKdfNZDf/kRgvFVouPF
         THsAmgvjWownLKS6+wbqOEEEA4YbHBPCHxqNEczzRQPmKFauSJiI2iGxXqyr7WfX1J2P
         Ox1sBtQiZkIl4lZfZiuqE8hcu6Z0/rUTCnkOQm1/HNV8sV62Gj6nZPXBVa4IjzyyhVO0
         ZtSTfWNQlNWhf/tRyzdW/8uHTn/efheSGS6OHkY5bgTUTZvap3wxajTtAOuAyMV6nme6
         TEDA==
X-Forwarded-Encrypted: i=1; AJvYcCXxXJAL+SJWQw1kpoVYEPHjlF0fxpNJ6bNUrPwYBFpIVHhqa+hahupcz0K+NQHJb072oJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLC2BHXPGEuRpwSvC/eBz3eUcehDLvnnhm+Msw+RiGv9uqmRF/
	0UX2UtsIlAxcGYa526UytS5gAgJ6wko1WfhVDsPcQ2iCW8rowiqFzJg8
X-Gm-Gg: AY/fxX6cL8Yu6o4BEMKA41bsUQvETXNRQtyfWWAuFV1KN4hH3DhB9/D1s2pej8AWGQz
	twmz9oq5iGa1k8uSFVbPJPeae47JRwmZlWnWaJZ5Zg+o3b/ImCcrr9zkpPhkXFZiheg/VFJ3XaM
	vAkS2qE+wlDW7rffC4IoOZowHFu6n+LDMpeccSUvJ28FazpwE7kQDkcn29WVPm731F/l1kVLPEN
	UA2X54M8cDSgBdC3UP7Tik8WOEP6KEMn6cPCUC2PJgumIbV3yaCakC5jyCYMxgz7nnj8lwxs/fR
	yaI/BiM2t9Qt99UOiwgJhPoKMS7n365wGihSuvMReX5SwfSyJOtOwhqifwv/KE4HRQ4PSktG2rA
	6Vas6vZa9FChp9z49xeQTXI1/1GfrbehtSg2TPr6F+ydbh6DEHBeFHSbAYOVmWZwm3xSd/OXqN/
	38VIsg1DLHJw3ypi/TubhYaLYUNz741JwbCDmXq57VECtHYcwHF2gWkdnceNfJmtwv
X-Google-Smtp-Source: AGHT+IFWhEWVgZjHasmxigK04Dcv536ZNizp8RTdkFnv5HseXa6ZLIKf5NEo+F1Jf/zNHtSMHWTSZw==
X-Received: by 2002:a17:903:2345:b0:2a0:d629:9035 with SMTP id d9443c01a7336-2a2f220cebfmr462612735ad.3.1767535211800;
        Sun, 04 Jan 2026 06:00:11 -0800 (PST)
Received: from localhost.localdomain (g163-131-201-140.scn-net.ne.jp. [163.131.201.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb25sm432327535ad.56.2026.01.04.06.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 06:00:11 -0800 (PST)
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
Subject: [PATCH v3 1/3] riscv: clocksource: Fix stimecmp update hazard on RV32
Date: Sun,  4 Jan 2026 22:59:36 +0900
Message-Id: <20260104135938.524-2-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260104135938.524-1-naohiko.shimizu@gmail.com>
References: <20260104135938.524-1-naohiko.shimizu@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On RV32, updating the 64-bit stimecmp (or vstimecmp) CSR requires two
separate 32-bit writes. A race condition exists if the timer triggers
during these two writes.

The RISC-V Privileged Specification (e.g., Section 3.2.1 for mtimecmp)
recommends a specific 3-step sequence to avoid spurious interrupts
when updating 64-bit comparison registers on 32-bit systems:

1. Set the low-order bits (stimecmp) to all ones (ULONG_MAX).
2. Set the high-order bits (stimecmph) to the desired value.
3. Set the low-order bits (stimecmp) to the desired value.

Current implementation writes the LSB first without ensuring a future
value, which may lead to a transient state where the 64-bit comparison
is incorrectly evaluated as "expired" by the hardware. This results in
spurious timer interrupts.

This patch adopts the spec-recommended 3-step sequence to ensure the
intermediate 64-bit state is never smaller than the current time.

Fixes: 9f7a8ff6391f ("RISC-V: Prefer sstc extension if available")
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


