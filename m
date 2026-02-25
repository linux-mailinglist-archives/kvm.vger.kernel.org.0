Return-Path: <kvm+bounces-71865-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKuHES1An2laZgQAu9opvQ
	(envelope-from <kvm+bounces-71865-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:32:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DD919C509
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2707314A21A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 953193E8C56;
	Wed, 25 Feb 2026 18:27:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEADA2EC081;
	Wed, 25 Feb 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772044036; cv=none; b=uiosoJnm+pZg7pSojvV5RPNJHZYnqMBBS4aWzaFZalymbf4kNzUqtKcWmufnzNggMOBJCnvlT9tIAu9D81WrO7zBKa7yV1eKJJkoO6iAF3nO3Ac0pJ8M4YRxWU1IKMiYFIIQDFkvnXxxJu3yBVtuUCncOtjRHsHpb8mALnWXCiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772044036; c=relaxed/simple;
	bh=EGGThpwlmLMElRls2fQ6eUT8hNMAXccPdZajc9Ils8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qIqfnpJPGGl52nubx9gPvlCvOISOcbmswAoO5ryU0/A/FnnSrlJyT5cvrQ53hx2DQHKaZIWJ8+WpnhQmFhn/7VqlXcY7fcwgw8jLx6Fp3R2jltuy93vtJvchL9vMgOTKWddWMR1pfbsk6TeBLDNwbIEQBxp3EYAFnP5QfDgpRjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D70CC15A1;
	Wed, 25 Feb 2026 10:27:06 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4266C3F73B;
	Wed, 25 Feb 2026 10:27:10 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v14 0/8] support FEAT_LSUI
Date: Wed, 25 Feb 2026 18:27:00 +0000
Message-Id: <20260225182708.3225211-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71865-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: A8DD919C509
X-Rspamd-Action: no action

Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
previleged level to access to access user memory without clearing
PSTATE.PAN bit.

This patchset support FEAT_LSUI and applies it mainly in
futex atomic operation and others.

This patch based on v7.0-rc1


Patch History
==============
form v13 to v14:
  - add LSUI config check in cpucap_is_possible()
  - fix build failure with clang-19
  - https://lore.kernel.org/all/20260223174802.458411-1-yeoreum.yun@arm.com/

form v12 to v13:
  - rebase to v7.0-rc1
  - apply CASLT for swapping guest descriptor
  - remove has_lsui() for checking cpu feature.
  - simplify __lsui_cmpxchg32() according to @Catalin's suggestion.
  - use uaccess_ttbr0_enable()/disable() for LSUI instructions.
  - https://lore.kernel.org/all/aYWuqTqM5MvudI5V@e129823.arm.com/

from v11 to v12:
  - rebase to v6.19-rc6
  - add CONFIG_ARM64_LSUI
  - enable LSUI when !CPU_BIG_ENDIAN and PAN presents.
  - drop the swp emulation with LSUI insns instead, disable it
    when LSUI presents.
  - some of small fixes (useless prefix and suffix and etc).
  - https://lore.kernel.org/all/20251214112248.901769-1-yeoreum.yun@arm.com/

from v10 to v11:
  - rebase to v6.19-rc1
  - use cast instruction to emulate deprecated swpb instruction
  - https://lore.kernel.org/all/20251103163224.818353-1-yeoreum.yun@arm.com/

from v9 to v10:
  - apply FEAT_LSUI to user_swpX emulation.
  - add test coverage for LSUI bit in ID_AA64ISAR3_EL1
  - rebase to v6.18-rc4
  - https://lore.kernel.org/all/20250922102244.2068414-1-yeoreum.yun@arm.com/

from v8 to v9:
  - refotoring __lsui_cmpxchg64()
  - rebase to v6.17-rc7
  - https://lore.kernel.org/all/20250917110838.917281-1-yeoreum.yun@arm.com/

from v7 to v8:
  - implements futex_atomic_eor() and futex_atomic_cmpxchg() with casalt
    with C helper.
  - Drop the small optimisation on ll/sc futex_atomic_set operation.
  - modify some commit message.
  - https://lore.kernel.org/all/20250816151929.197589-1-yeoreum.yun@arm.com/

from v6 to v7:
  - wrap FEAT_LSUI with CONFIG_AS_HAS_LSUI in cpufeature
  - remove unnecessary addition of indentation.
  - remove unnecessary mte_tco_enable()/disable() on LSUI operation.
  - https://lore.kernel.org/all/20250811163635.1562145-1-yeoreum.yun@arm.com/

from v5 to v6:
  - rebase to v6.17-rc1
  - https://lore.kernel.org/all/20250722121956.1509403-1-yeoreum.yun@arm.com/

from v4 to v5:
  - remove futex_ll_sc.h futext_lsui and lsui.h and move them to futex.h
  - reorganize the patches.
  - https://lore.kernel.org/all/20250721083618.2743569-1-yeoreum.yun@arm.com/

from v3 to v4:
  - rebase to v6.16-rc7
  - modify some patch's title.
  - https://lore.kernel.org/all/20250617183635.1266015-1-yeoreum.yun@arm.com/

from v2 to v3:
  - expose FEAT_LSUI to guest
  - add help section for LSUI Kconfig
  - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/

from v1 to v2:
  - remove empty v9.6 menu entry
  - locate HAS_LSUI in cpucaps in order
  - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/


Yeoreum Yun (8):
  arm64: cpufeature: add FEAT_LSUI
  KVM: arm64: expose FEAT_LSUI to guest
  KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
  arm64: futex: refactor futex atomic operation
  arm64: futex: support futex with FEAT_LSUI
  arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
  KVM: arm64: use CASLT instruction for swapping guest descriptor
  arm64: Kconfig: add support for LSUI

 arch/arm64/Kconfig                            |  20 ++
 arch/arm64/include/asm/cpucaps.h              |   2 +
 arch/arm64/include/asm/futex.h                | 284 +++++++++++++++---
 arch/arm64/include/asm/lsui.h                 |  27 ++
 arch/arm64/kernel/armv8_deprecated.c          |  16 +
 arch/arm64/kernel/cpufeature.c                |  10 +
 arch/arm64/kvm/at.c                           |  30 +-
 arch/arm64/kvm/sys_regs.c                     |   3 +-
 arch/arm64/tools/cpucaps                      |   1 +
 .../testing/selftests/kvm/arm64/set_id_regs.c |   1 +
 10 files changed, 342 insertions(+), 52 deletions(-)
 create mode 100644 arch/arm64/include/asm/lsui.h

--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


