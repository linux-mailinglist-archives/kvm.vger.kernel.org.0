Return-Path: <kvm+bounces-66970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A14F9CF01C1
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 16:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1FF930169A2
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 15:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F452D1F7E;
	Sat,  3 Jan 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEXmlf75"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE6B30E824
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767453868; cv=none; b=kq/mJZfPesVQe2ujcDYptjnCxUIO0D9RzWlHQJV8GXb/2LauEn4/IVHFhSDUEw9FXya5cZTU1z2BMews3swsuqo35F9qvKS5ByJILQ7h2oKOU5o/IhqDCRKMhNglKtoEcZ2iXQI8vkX6SpHOCT5RQUehyFHHsUK7zFllapbsPEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767453868; c=relaxed/simple;
	bh=vfVhvj+aKK5XbT70viSOGx/zfj3iCryc4q3ARLnO6Xk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oruOIP0E7ryn81VSEvufgCpfMvJa/tPV3K7XHz4h1lNVeop+/iWCVaS1SQuCE5m+hfPOqyMJJbjWzTQorUPcSezHOCes08BsB6Dd99jDNTrkCAUKeLcXkBqJw7xUNChum7wdPlWjPFBvJms1SRWLB1QHf1nNymRfxiVwUFjmPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEXmlf75; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a2ea96930cso145959335ad.2
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 07:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767453866; x=1768058666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hicfMUjmbw+QHk3n6PAlOK0aZkOq9/nKehIWGD00WH0=;
        b=QEXmlf75gURFfJBkxO8rtRgD8mBeX3zOswQcgFjoVtcl5GiNfaI/woIZS2WCHZju82
         LpRGEwVgdzRwM+KAaO1ZWIePXvEmAuF9Km+c5h0/PulyngPUruTKkMPvqnePXUjmcZak
         ROoX0df9R6RaHfCyazUMh/JuzdRlN5Pnu5xzVREED9zlFOA9VCNakg25rp2jg4gZy3qZ
         dKY0to9m/yvrO8Vz7qRmWRYcuT+FAs79UrIZ14jcQZGr69T7U/LcpoTHg4y7P/RdnkDI
         TqfS1k4NvbLK7DGtL8+RUKMdf4qh0WIJYHksG3vqvydhc9FQdjilhhHsZQAks9uK+ak7
         cajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767453866; x=1768058666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hicfMUjmbw+QHk3n6PAlOK0aZkOq9/nKehIWGD00WH0=;
        b=rhGM+LInzfRsBHqTCHCN4GmsUEWpFPH5yu5pd4+zF4Ujfhl565H9QaudUwP3dYmLpE
         w7XmMJn/48ienfK7xjujAN6hGhKxreeUWpp2LkcszX0CLpZf4TVh1OdSGLh2NZiTf4ss
         rYpsXg4j68Ajf4uBi+6VRSXJU5XQIyTyAQypJr1qAAno4clec5P4Yr9uw0lJLL3e/5B/
         tgsebRY069KdQkYRBOgJ84I/BEwf2PxHfXzLTDhj/K8XumJAml5Z4aMMsi9J20KatWIu
         9PYXumN3MAAE/5nOf3F5GEhtUUOK7EpH6XtCSFlnQDELvQIjKExcn6cA7M69jQFxPytO
         hifQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuchq1LJ6y0KP0MFVqjFdwj6uaey1gRuo5ERJvdTPSRA9MQ8okZ7NaiwAD1+ZiPx2oo2E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQu+40TbT+TvIltAe3RNvqFL75/kGOOS/UQaYV9r95kv4dkHLC
	ThaUwPgCSVKJY5V+lu/tk48I0/cAUY42G/6A83QKNBeaaiSP/3Kq7wFz
X-Gm-Gg: AY/fxX7vOgEekO0o9/zQ/Y88ThKlGLoCmpVgcw/c2+ul3aAKDLPSu30rs3OfYdFUgJs
	2rY9QYYlnSZJEkQTAkiCoB1nHYRRaD5UZcatinpdRRJhPd4P3/OErRxu6o+mVmwc/HY5uOftsOQ
	X470SSbFClpFaEvcGn94hUWoweLSxVoZm0Jnr71iHmf0nu2bEAfCpICU0swGk3EDtC/nseiinKk
	LDRv4sR+M36SW3W2Jb0AZABcRVf0P4UzolxnhV/kLDUoYOlT79nYVw7uUHooYmRbXQBTsFy3T05
	jPuJiOnmTBhhO45kn4i1tQZEfIGnTuLUrxOhW101U6Vwqb0uDAj+JzuAkg8yW1AvxPG8HgxYWV6
	LCKMIG3hp9XEPj7/zN7l0P8l1fdLCBATi7IOB4Bw+7OGgFdry3zdSCWvJZh0nyPi+irhAaljRWt
	vy+/oy2c8/sDPq9qU3NMButiVK+YXHvnw1OAXQ8UfVGsNRbWmaNh/P5GAh68sypNoRSnnQyhRjv
	Kc=
X-Google-Smtp-Source: AGHT+IHkJssiBmursdyzh3wg8jKWzXxaoy5QZmOvyZosTsH6bVwm8hrvSg0Syw3FUSaNH48MoyKl+Q==
X-Received: by 2002:a17:902:e785:b0:2a0:b467:a7cf with SMTP id d9443c01a7336-2a2f1f71a56mr408784195ad.0.1767453865690;
        Sat, 03 Jan 2026 07:24:25 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f4770a256sm2107802a91.12.2026.01.03.07.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 07:24:25 -0800 (PST)
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
Subject: [PATCH v2 0/3] riscv: Fix potential spurious timer interrupts on RV32
Date: Sun,  4 Jan 2026 00:23:57 +0900
Message-Id: <20260103152400.552-1-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series addresses a potential race condition when updating 64-bit timer comparison registers (stimecmp/vstimecmp) on RV32 systems.

According to the RISC-V Privileged Specification (specifically section 3.2.1 for mtimecmp, which applies logically to stimcmp as well), updating a 64-bit comparison register via two 32-bit writes can cause a spurious interrupt if the intermediate state is evaluated by the hardware.

Currently, the Linux kernel (including v6.12) often writes the LSB first or does not use the recommended 3-step sequence (setting LSB to 0xFFFFFFFF first) on RV32. This can lead to a transient state where Time >= Compare is incorrectly true, triggering a "ghost" pending interrupt.

Changes:

1. Fix suspend_restore_csrs to use the 3-step sequence for stimecmp.
2. Fix KVM vcpu timer updates to prevent vstimecmp hazards.
3. Fix riscv_clock_next_event in the clocksource driver.

Although this hazard is difficult to observe in QEMU due to its instruction-boundary interrupt polling, it is a critical correctness issue for physical RV32 hardware implementations with asynchronous comparators.

---
Changes in v2:
- Added detailed architectural background in commit descriptions as requested by Anup.
- Cited RISC-V Privileged Specification regarding 64-bit timer updates on RV32.

Signed-off-by: Naohiko Shimizu <naohiko.shimizu@gmail.com>

Naohiko Shimizu (3):
  riscv: clocksource: Fix stimecmp update hazard on RV32
  riscv: kvm: Fix vstimecmp update hazard on RV32
  riscv: suspend: Fix stimecmp update hazard on RV32

 arch/riscv/kernel/suspend.c       | 3 ++-
 arch/riscv/kvm/vcpu_timer.c       | 6 ++++--
 drivers/clocksource/timer-riscv.c | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.39.5


