Return-Path: <kvm+bounces-70197-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BwnLYFNg2lrlAMAu9opvQ
	(envelope-from <kvm+bounces-70197-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:45:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE1AE69D2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C794D3008C3D
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B8740B6CE;
	Wed,  4 Feb 2026 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aXKIyDTO"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5732874ED;
	Wed,  4 Feb 2026 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770212728; cv=none; b=e2RHyHlSfNgdX4I1T4J3qKSkkFbTvexG6DT/05j2IDhs1X557oujB0cos/rfkEtG/ptLqPTb0UhfiCih5qR8H9Co2y5B0GBAeyBRaBt70MWcOTKGbeYgIxxEXLDJ5Qj1yXpQuqIXqdZ0jLP/yJQ6Bzi5NViPuoIvsqCWMbvD4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770212728; c=relaxed/simple;
	bh=K5wCrxDoRu44lWPXg8e4A9D3K+aHxqruv32sypmQUAg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X9T61bxFoBpFmhnk3a3af9UlIBmR3ZLX9gaTWpbAWudPFau82tvJdUQ13VuXXUD9G5mR/iZJBt96UL1lYpKwKTaBX9KYm09LAhTCy99vSf5WEZ4P5d4c2Lm+Vielw7i+gOnO95fjuuXTBOO6HsEhPp72aHU5Nky8Hd4ZPu8TkBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aXKIyDTO; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770212718; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=om1FUqBBj9rquR58NW7QTlpJTDIIM+QxVVQ3WntmFgM=;
	b=aXKIyDTOB1jH1bO7+h0HIy0MvmQWYxGjzeHmigOvUTh8LHAngdnzMTTRi6s88rc3Tyu5aWJNjqNQG30b4amk/JryR+2DmJKkD75qQGK217OdXLKVEzuF9LXHBxpRBWFjQXZjcLbL+OIumF5LHegTS2h0xxX2ZINw8Xh4KzX5Fb0=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyXBz6r_1770212714 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 21:45:16 +0800
From: fangyu.yu@linux.alibaba.com
To: pbonzini@redhat.com,
	corbet@lwn.net,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	radim.krcmar@oss.qualcomm.com,
	andrew.jones@oss.qualcomm.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v5 0/3] Support runtime configuration for per-VM's HGATP mode
Date: Wed,  4 Feb 2026 21:45:04 +0800
Message-Id: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70197-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,alibaba.com:email]
X-Rspamd-Queue-Id: DAE1AE69D2
X-Rspamd-Action: no action

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Currently, RISC-V KVM hardcodes the G-stage page table format (HGATP mode)
to the maximum mode detected at boot time (e.g., SV57x4 if supported). but
often such a wide GPA is unnecessary, just as a host sometimes doesn't need
sv57.

This patch introduces per-VM configurability of the G-stage mode via a new
KVM capability: KVM_CAP_RISCV_SET_HGATP_MODE. User-space can now explicitly
request a specific HGATP mode (SV39x4, SV48x4, SV57x4 or SV32x4) during
VM creation.

---
Changes in v5:
    - Use architectural HGATP.MODE encodings as the bit index for the supported-mode
      bitmap and for the VM-mode selection UAPI; no new UAPI mode/bit defines are
      introduced(per Radim).
    - Allow KVM_CAP_RISCV_SET_HGATP_MODE on RV32 as well(per Drew).
    - Link to v4:
      https://lore.kernel.org/linux-riscv/20260202140716.34323-1-fangyu.yu@linux.alibaba.com/
---
Changes in v4:
    - Extend kvm_riscv_gstage_mode_detect() to probe all HGATP.MODE values
      supported by the host and record them in a bitmask.
    - Treat unexpected pgd_levels in kvm_riscv_gstage_mode() as an internal error
      (e.g. WARN_ON_ONCE())(per Radim).
    - Move kvm_riscv_gstage_gpa_bits() and kvm_riscv_gstage_gpa_size() to header
      as static inline helpers(per Radim).
    - Drop gstage_mode_user_initialized and Remove the kvm_debug() message from
      KVM_CAP_RISCV_SET_HGATP_MODE(per Radim).
    - Link to v3:
      https://lore.kernel.org/linux-riscv/20260125150450.27068-1-fangyu.yu@linux.alibaba.com/
---
Changes in v3:
    - Reworked the patch formatting (per Drew).
    - Dropped kvm->arch.kvm_riscv_gstage_mode and derive HGATP.MODE from
      kvm_riscv_gstage_pgd_levels via a helper, avoiding redundant per-VM state(per Drew).
    - Removed kvm_riscv_gstage_max_mode and keep only kvm_riscv_gstage_max_pgd_levels
      for host capability detection(per Drew).
    - Other initialization and return value issues(per Drew).
    - Enforce that KVM_CAP_RISCV_SET_HGATP_MODE can only be enabled before any vCPUs
      are created by rejecting the ioctl once kvm->created_vcpus is non-zero(per Radim).
    - Add a memslot safety check and reject the capability unless
      kvm_are_all_memslots_empty(kvm) is true, ensuring the G-stage format is not
      changed after any memslots have been installed(per Radim).
    - Link to v2:
      https://lore.kernel.org/linux-riscv/20260105143232.76715-1-fangyu.yu@linux.alibaba.com/

Fangyu Yu (3):
  RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode
  RISC-V: KVM: Detect and expose supported HGATP G-stage modes
  RISC-V: KVM: add KVM_CAP_RISCV_SET_HGATP_MODE

 Documentation/virt/kvm/api.rst      |  27 ++++++++
 arch/riscv/include/asm/kvm_gstage.h |  31 +++++++--
 arch/riscv/include/asm/kvm_host.h   |  19 ++++++
 arch/riscv/kvm/gstage.c             | 102 ++++++++++++++--------------
 arch/riscv/kvm/main.c               |  12 ++--
 arch/riscv/kvm/mmu.c                |  20 +++---
 arch/riscv/kvm/vm.c                 |  21 +++++-
 arch/riscv/kvm/vmid.c               |   3 +-
 include/uapi/linux/kvm.h            |   1 +
 9 files changed, 160 insertions(+), 76 deletions(-)

-- 
2.50.1


