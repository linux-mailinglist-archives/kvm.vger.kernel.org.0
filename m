Return-Path: <kvm+bounces-66988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BDDCF10C9
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 15:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A27FD30142E5
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 14:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED631FC0ED;
	Sun,  4 Jan 2026 14:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9W+a2P2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A0A30E83E
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767535210; cv=none; b=NAIXkq5CBbcLVpdKCpmLdYv+6m91bgWnm+7pqmgs+kjElEdRsDg3vYuOnmXcVCH5xSMx4+QEIPFZoZtFxeAm+E/KlfLzqR76VA9jIL6iNYKgX55YokmIRbSnxx5u244AZeuQUalYY50UWf8QyETKdaELHWtgpxlJBTEpX6ktdd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767535210; c=relaxed/simple;
	bh=nHW+73ZaAvs1MMVnyYoWmVeCllRCYLD9BRIL3THHAcs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=klR8HjOsJ7rPQZzE+j9gbPPIfKZRV332u9jVSOe8gOw1Uq82VX9mXW+XOOk4rmBoMpS66pNJNaEQnoyPdA4oRo2He8MAfu6irrP+/xRlo+SzRxwSNkKCak4eEVIVBIm9vf6g1KvJkWXbRR6V5QGxHHUdwurDm+z6SU1uaFnp6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9W+a2P2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a0bae9aca3so188953025ad.3
        for <kvm@vger.kernel.org>; Sun, 04 Jan 2026 06:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767535208; x=1768140008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HEqhNW5O+8RAp0S31dtdTiF5gzWANx1aqh14jIZncZA=;
        b=I9W+a2P2Hj5pFjAL9WoIAbLUWD0G3CI3aekVVK73W5QjHAtSQSQ038pQMU6HbbL8tU
         FXSu3tDvtidoB1mNuPw57S6dXM4wVDZ+YMkmk9GbuKEjmXczIwKolzMsc9C9vXAMnEGL
         M7jXwNgH8+oWhfEuT04/ws/XmTjsx/+kGXYGB6NibhI62T51ue8q4fc2npW+zMH6lLHC
         MRTMGed61/r1vcDuEXz8gRuQXJ89XbRc0b4rlCUscfM4ujw58GTi7Bdp61ODQywrCpfh
         Gcch0uWt3n6iaP79BO90Gcz8h8czGteStSLd3oCRdKhzQGxuuSYIH1vowItIqZj/8ev8
         pZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767535208; x=1768140008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEqhNW5O+8RAp0S31dtdTiF5gzWANx1aqh14jIZncZA=;
        b=LhvnwXbIJQD2sNgPPbb0POt5bl7zvZr/2KFfNQF5DpG1LCJVci036xt6DGYzlE6/nr
         tDnVF+FG4exasuwuph9TyH+4Nam4wvMJMsWryc29G44rkjwPyRSaLpT5efisO7ci+Dlr
         j6YJAkiN6qG4u2oRXyI7KG9FvXpppVME0dXqr8q6X90jBrjQPuYQ7Ovuyf5Qhv6U6jNv
         oue9I8Rj854wcaQ/cqf3tT2cwtnxrSxHSiO0gnavwVSN3rgJUESM/k5zPdfQ0RcBhL6z
         lPxQxHfWuKcG3MI6UpveNUxaTGqy9xYXYjgwYZxMf8dHLRRykRIJXeHbKBweMHga50jQ
         g45w==
X-Forwarded-Encrypted: i=1; AJvYcCVcG/JgQjfUJ4FlcPfL11go0V+LJgPDAMEpJkgbLOXqGDlvPtU3H+wIUUv9HMzzivbi9fI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmvjolTjdX1f+tC90S5V0z3GkFYHdo654ZRJaiyI/bO/bsNFLH
	DPAiW0YjzuF4JYfMlklJL2FM4joofpNfKn8+WUTagzTMbG1RFfORfj9f
X-Gm-Gg: AY/fxX4yaJnUrF/+k3yLvP0LJNtRw0mTJVbKVU93ko010hBqE1jMPpVU0E7DiebVw+e
	vLwkZSkCg3DY08FUgJOdG5J/EXrzk/SiM9iZeDQ1F9QzyHDQ5IINwUIiR8Z42WuC4abqLIqPkZ/
	8EtDkoiZ0ZtJKB09Eh6WniivaPlXDAW1cLkJqy5UVD0RHZAqAnuaNPCZWdYdjkThq6+6byUb7GN
	WWMm8zgvGDb3HCoGxsDY0xRfoQtjANmk8kikNY33mCDRrSW13bEKRJuXc3MALac7fWAZ7AkmRCT
	dvPUe+mefGB+cjy8Ro0k3hwQ7Jj4C2sJ5ci+DU2LvQIF6gIgWB9cee/lLzwth0Zm+1OOrFn89Ju
	0wQWJI3T0yJJSqV4VdNGhJZv9Yh9n6vweLW5GPEZj9mpx86oGDxpnwQJO2X6oarmS5RsjpQ8bJQ
	H0QXBMKs7fmPGzEfpb9NJap+A5mTtjts0mv/3DfmZsoquvw5ufUb4EIZKL6RaauUkb
X-Google-Smtp-Source: AGHT+IHYOHBJT78zqotwaAPeOBEa33pI9OjGBIGmbHuEBwmEYLu2IfXRLZs8IapRix35ur7Qubzuzw==
X-Received: by 2002:a17:902:c403:b0:297:f527:a38f with SMTP id d9443c01a7336-2a2f2231764mr476919905ad.18.1767535208281;
        Sun, 04 Jan 2026 06:00:08 -0800 (PST)
Received: from localhost.localdomain (g163-131-201-140.scn-net.ne.jp. [163.131.201.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4cb25sm432327535ad.56.2026.01.04.06.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 06:00:07 -0800 (PST)
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
Subject: [PATCH v3 0/3] riscv: fix timer update hazards on RV32
Date: Sun,  4 Jan 2026 22:59:35 +0900
Message-Id: <20260104135938.524-1-naohiko.shimizu@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series fixes timer register update hazards on RV32 for
clocksource, KVM, and suspend/resume paths by adopting the 3-step
update sequence recommended by the RISC-V Privileged Specification.

Changes in v3:
- Dropped redundant subject line from commit descriptions.
- Added Fixes tags for all patches.
- Moved Signed-off-by tags to the end of commit messages.

Changes in v2:
- Added detailed architectural background to commit messages.
- Added KVM and suspend/resume cases.

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


