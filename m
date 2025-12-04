Return-Path: <kvm+bounces-65279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C8ECA4009
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 15:27:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED8FE303EF69
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 14:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2A633ADAB;
	Thu,  4 Dec 2025 14:23:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56DD123EA95
	for <kvm@vger.kernel.org>; Thu,  4 Dec 2025 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764858228; cv=none; b=a+43AheD+ujgdRabeva9dRmzK9AUZZg3PTFBnu348AUxbfAY0j+N09IRkNClDXjjHEUNsVfUwmiov7vVOOWqbBrP2ydf42ALCy2qSMGj+ilonxpbeTDPzlVpDXXKjHWDs1sHWOkbwM6804Ged/Dr8Zwlf2EzLASp56AD8eehEcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764858228; c=relaxed/simple;
	bh=m5GLaNwrwFBOJDR8QSiMFVr/SOD8N0Ngf95FjAD/KIc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UAGp9sqlEueuTwz638XklStvH3eXGQ7Zz5Ing6g0hb8hFiOMOAdEeTE3wfplkE3xBL8dF3OrAPg+YG46m/Oa88y3riVPhJDvlo7fOoLRG5ukJ8Wc7D6IOMkIZrNNJlAjp9EbEM9iSRmsZyLBFecvbzXh0qCOQgfRuJpt2UY+rsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43543339;
	Thu,  4 Dec 2025 06:23:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27E663F73B;
	Thu,  4 Dec 2025 06:23:44 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v4 00/11] arm64: EL2 support
Date: Thu,  4 Dec 2025 14:23:27 +0000
Message-Id: <20251204142338.132483-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2.

Changes since v3[1]:
	- Added rb/acks, thanks!
	- Fixed checkpatch.pl issues
	- Changed EL2=1 env var to EL2=y or EL2=Y
	- Couldn't make the change as suggested in [2] since those tests are
	  also run at EL0, where CurrentEL is UNDEFINED. So I have left the
	  #ifdef.
	- Fixed SCTLR_ELx initialisation on secondary cores.

Thanks,
Joey

[1] https://lore.kernel.org/kvmarm/20250925141958.468311-1-joey.gouly@arm.com/
[2] https://lore.kernel.org/kvmarm/20251202122115.GA3921791@e124191.cambridge.arm.com/

Alexandru Elisei (2):
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2

Joey Gouly (9):
  arm64: set SCTLR_EL1 to a known value for secondary cores
  arm64: drop to EL1 if booted at EL2
  arm64: efi: initialise SCTLR_ELx fully
  arm64: efi: initialise the EL
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported
  arm64: add EL2 environment variable

 arm/cstart64.S             | 66 ++++++++++++++++++++++++++++++++++++--
 arm/efi/crt0-efi-aarch64.S |  5 +++
 arm/micro-bench.c          | 26 +++++++++++++--
 arm/pmu.c                  | 13 +++++---
 arm/run                    |  7 ++++
 arm/selftest.c             | 18 ++++++++---
 arm/timer.c                | 12 +++++--
 lib/acpi.h                 |  2 ++
 lib/arm/asm/setup.h        |  8 +++++
 lib/arm/asm/timer.h        | 11 +++++++
 lib/arm/setup.c            |  4 +++
 lib/arm/timer.c            | 19 +++++++++--
 lib/arm64/asm/sysreg.h     | 19 +++++++++++
 lib/arm64/processor.c      | 14 ++++++++
 14 files changed, 204 insertions(+), 20 deletions(-)

-- 
2.25.1


