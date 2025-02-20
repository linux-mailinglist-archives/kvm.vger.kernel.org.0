Return-Path: <kvm+bounces-38709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E17A3DC40
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 15:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D77816D556
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4621F709E;
	Thu, 20 Feb 2025 14:14:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E9B1EF092
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 14:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740060851; cv=none; b=q3k7LpwBMv/J/zQ/xCHBT7qGHVkzH9Yc7x3jc6d8LIdTFIIXCPKwx2iYhbett2wxwL4E7RqsKWwn4n1y4EMuxPMyGiLKAoaLvJZwKBxvqESjK7br5pXl9hPm9s1uH9i18hhT26/6ekbIZOAr8ZUl7pnPhhhGy81PLPEzVQY+NPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740060851; c=relaxed/simple;
	bh=GzfL+JN/zQhAfgCOGHIqH4BWbMnEuwzR0f6bs6ZG5MM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b8aeB5+9lXuHsS4c8r5kcrJ1yPEi9c0ggOYkbMoVpTVBP+TWDIQcArDO+WZoJGwJHKPBgMadVFkFK7VeL+4h4XJGiS5sBf+OTqsLBW2ekG7cVL/bafYIsWDKiX6c1DctX0lzYgjqHUWtNXfwZDik5V+rYu2pYzHs5uMmZjq//9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 897A716F3;
	Thu, 20 Feb 2025 06:14:27 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F9E73F59E;
	Thu, 20 Feb 2025 06:14:07 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	drjones@redhat.com,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v1 0/7] arm64: support EL2
Date: Thu, 20 Feb 2025 14:13:47 +0000
Message-Id: <20250220141354.2565567-1-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is for adding support to running the kvm-unit-tests at EL2. These
have been tested with Marc Zyngier's Linux kvm-arm64/nv-next branch [1] and
kvmtool branch arm64/nv-6.13 [2]

The goal is to later extend and add new tests for Nested Virtualisation,
however they should also work with bare metal as well.

- The EFI/ACPI change has not been tested yet.
- The PMU tests don't all work in NV, a patch has been submitted that fixes it
  [3].
- The debug tests fail in NV
- micro-bench ipi test fails in 'bare metal' QEMU
- PMU pmu-mem-access, pmu-chain-promotion, pmu-overflow-interrupt fail
  on FVP, but fail when run from EL1 already. So not an EL2 issue.

I will continue to debug the above, but wanted to send this series out to make
some progress. We could even drop the last patch (actually enabling EL2), and
merge the rest, if people don't want to have some tests broken.

This is a continuation/reworking of Alexandru's patches at [4].

Thanks,

Joey

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-next (commit a35d752b17f4)
[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git arm64/nv-6.13 (commit 5b6fe295ea7)
[3] https://lore.kernel.org/kvmarm/20250217112412.3963324-1-maz@kernel.org/T/#t
[4] https://lore.kernel.org/all/1577972806-16184-1-git-send-email-alexandru.elisei@arm.com/


Joey Gouly (7):
  arm64: drop to EL1 if booted at EL2
  arm64: timer: use hypervisor timers when at EL2
  arm64: micro-bench: fix timer IRQ
  arm64: micro-bench: use smc when at EL2
  arm64: selftest: update test for running at EL2
  arm64: pmu: count EL2 cycles
  arm64: run at EL2 if supported

 arm/cstart64.S         | 55 ++++++++++++++++++++++++++++++++++++++++--
 arm/micro-bench.c      | 26 +++++++++++++++++---
 arm/pmu.c              | 21 +++++++++++++---
 arm/selftest.c         | 18 ++++++++++----
 arm/timer.c            | 10 ++++++--
 lib/acpi.h             |  2 ++
 lib/arm/asm/timer.h    | 11 +++++++++
 lib/arm/timer.c        | 19 +++++++++++++--
 lib/arm64/asm/sysreg.h |  5 ++++
 9 files changed, 150 insertions(+), 17 deletions(-)

-- 
2.25.1


