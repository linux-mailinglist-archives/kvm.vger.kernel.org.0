Return-Path: <kvm+bounces-66963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C68BCEFD8C
	for <lists+kvm@lfdr.de>; Sat, 03 Jan 2026 10:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58A3A302E146
	for <lists+kvm@lfdr.de>; Sat,  3 Jan 2026 09:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5AF2F3C3E;
	Sat,  3 Jan 2026 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRUOXpep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE181CEAC2
	for <kvm@vger.kernel.org>; Sat,  3 Jan 2026 09:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767433569; cv=none; b=cGp6z2ZMx/UaNnCqVaccdK+l+PfO6x9f+dvZaoEsXJeMl6BM4vteQjEsYwWW6vpRTCKI9U08Z6Oi+x65pwwFlrP3F95t9nv8mAmUA+kgfG2BtxJVhnMA0Jca/hDD0AflIr6L0KvzE0abwk/V3qbyMxQhl0PdoK9raSPCtrHDXsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767433569; c=relaxed/simple;
	bh=efwmUAMzmS/UvUUv5mWngiAZpwOYPN2n8W0XJebLrtw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E0RexfgaWPJ8ji7pper6ProYE5ms4MUNbzpJF00UgdccyhbzY8h3sg+JBkhWkBiCgaKd3YQXSOQijtTfLx9/YTuC7oA/hjOseJQcIevvjXcAXgCo6B7TftubTf6dPicwjYp+ISpls3qd0rF7l71ShP0/WP0h/5++s4FZctEiSKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gRUOXpep; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0c20ee83dso163035085ad.2
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 01:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767433568; x=1768038368; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JD0n/Fm55UFJQkbcsKqmkl3SnWwAZypi4Xu05/Efcno=;
        b=gRUOXpeprNWIdHsPrwTPycXZbhvZkIbq0atNY92FRzihdp2c2n549eK5oGSvPjHUVO
         ZWVpEZ7K/K8AG/FpB2Wi17H+lbAVGzdpbk0x4sjSI2BPiJ95UrEoF+MI/THJbQIxSkL0
         ZgHspwYOmvbd+CkmGCUrt/bqRuGa/FdNUOsDbWLxmItOVYWmjCkCCJCLPgpAz4VMo986
         xBT1bi2Dfi6PPEjqGiE9H3jRbW8Dn5Rjp2JYgQo9AdE83/DuMfPBty9+gDjHwwB+IMN5
         nZClo1UB9WcBcEECYCclJ6tdDPKbPlwUFWQ1qMuGbjGFnEvo3InkonOZeUyZOhs66yfE
         3lVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767433568; x=1768038368;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD0n/Fm55UFJQkbcsKqmkl3SnWwAZypi4Xu05/Efcno=;
        b=vk5nCjrxJKck/9O8rr+7E06BYNiBOhsQnIr5zNsBWLiE1y72tdAdec8YyJsHccFJsP
         P7zkm4y+6nNL8GFLExhaEXYbM6H6ag/A2ZgGtKBQZeR5XH4oAfLBAF1LficudH+wGiVi
         ekUZxbrm8UINw0nDLW64y0K1/Mvdnzj++rE4H3vksgqmpzYmNumIz8Exn/Ut2Q7qBc2e
         2F1CDQ60xL4gqzEmbVwnnIKrz4byWHoC3UVqjm/nVcP8fyZlMEaL7NIJipHthTHUHTpf
         /qx2I1RVjZFRpO4KvfMCsjW1VfUbN4BQ5wIkidrXQkWju5pI3WNBkxXzGAiMse21QcyA
         k/WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWa67WWQcD3GDEyG0zCAco6exfguWhA3cViQr1gBCGvyb47+KIDUsO78yRtPHfRsinVMPY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEr9I+VdDkr8BDXa51bb3nblw9Kqg2LQAZ7fQ3CuUBSe9NfBUw
	GqsdyKc31+5W6+5AcmRmTnQ4R4Yi3pBPHm9T6JshbHiRpjT+nxFegq8y
X-Gm-Gg: AY/fxX73bEblEtSLGHtbycU2ATsMENwT39Lsc7PGc5ysWyjwZFbp8NoKb09TN4GooPs
	HEgDWyhjoiEXbIosHz/hnjl7byy/tlZ0eArpNVYWuoWnhjH9TekQV7OrNQubpqeA/PPtp6c6IU9
	UAZD76FMgUXwy5HHOrJJsJaysMO+m8YlmwwWZjElPL/ACC2jSWSZV2CSwoJEiEPp7ujETUueLcR
	JSwRcK0Xen29KXklOt1O33r2QttjoTsAfc/1hP9L3X+h35tvlTTx0M/844wTOqe1QFTXZrXPc3T
	4fLu6pQJXJnz48X0N4hCAV9WLjqqf1+UmsOnXQWUU65IkuZ34g6DUZiwnbqJOVRqbmZF5dWCIwB
	XH5L+hofdwwQ73MhJgXZKkHsMxebp7FFQ0uLxjgBFzvs0s+HrdBG11ramkebtdA8hRDwNds7SRu
	0ICqhUw7VrW4ZImqDQLnSA+M1qOjKUkotySlJJmCAzyJbVmRDWroJdL6T13xdFKMhc
X-Google-Smtp-Source: AGHT+IFNLzKaiu1Bm8BObCDrR25tQvlAZc+Fjmboe3LwUIgq+AoeE4YcWvhwHDPuA8YxLt19m+hacA==
X-Received: by 2002:a17:903:244f:b0:2a1:3ade:c351 with SMTP id d9443c01a7336-2a2f222bd48mr502840155ad.2.1767433567709;
        Sat, 03 Jan 2026 01:46:07 -0800 (PST)
Received: from localhost.localdomain (123-48-16-240.area55c.commufa.jp. [123.48.16.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cbdasm403124315ad.65.2026.01.03.01.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 01:46:07 -0800 (PST)
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
Subject: [PATCH 0/3] riscv: Fix potential spurious timer interrupts on RV32
Date: Sat,  3 Jan 2026 18:44:58 +0900
Message-Id: <20260103094501.5625-1-naohiko.shimizu@gmail.com>
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


