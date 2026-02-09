Return-Path: <kvm+bounces-70650-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOJNEY1iimleJwAAu9opvQ
	(envelope-from <kvm+bounces-70650-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3EE011518B
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 23:41:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFB84303183B
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 22:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0705318EE5;
	Mon,  9 Feb 2026 22:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HhXL+lHX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD18315760
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 22:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676847; cv=none; b=uRam+QFeHeuDlWRNQetJZHB8ld2zz70oGRSr3DLSNEeyZkdwGTRq8QWMtjk9GJyMIQFX3HhCNr0WoJvdfIm1al20MagJVHkly1DvfbZzBbBNerLvbA+aiF7OA2Luu0lr+wub4lk/YUd25KTL/V6rIVrhtVPZ0NUAqIyHZW2ao2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676847; c=relaxed/simple;
	bh=2w2NkSfnUYCtKCT1TvD2j7eUbaB9dlOlqow5wyJZoKY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eIXPv3K4pxXQE1MVBKlA5CTLbMY5KlFDTysGPQlFvjzu04+x3DM1NhX1+lKnHaKcR8h7WpVZHX2EdGSUmZ8fOyB39lBj08QS2aw0XlASQqFyugEYuJ989xnjcCsXgiJfrUH+kQmGgmuxlu5kzWmnG4PfeMQCPy4CaAc1AIs+pps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HhXL+lHX; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-663006e4c3cso1123175eaf.2
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 14:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676844; x=1771281644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=30Nas80AMvo6RyW+BR+2WwHJbWJfG1zda4JX9g84//U=;
        b=HhXL+lHXdq2/jXdePqpenUlxL1QhrhU2eUgJlgQ2aztzvzgtrzsF+snXRALa4WyjCs
         Jfy175SB0ER6ISIkj+UJh4Jsn2qk578bJphXpHTEanqTwfx3xZx8kaCkZGX7OCWSpc55
         IAxUvrn3sOiiH33g4L1rLvoVfGKPYeaf45TRrAihX3HPIH4UwpifJQ05kROyFEXLmMN4
         nBCIPnm7DWSoJ3kX1v0u03wO5VwM5Rwgp9m7OZqcXWR50n42iRCtdXLWig17PgkjoHTf
         qJ+AA2Ezb6tzVTMCriGAdffxGVFgodmCAkup/s/+qESwB5LIiDt0DHIyYZcSdUP+oKca
         INFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676844; x=1771281644;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=30Nas80AMvo6RyW+BR+2WwHJbWJfG1zda4JX9g84//U=;
        b=jOdqZl7eLGuA6zHHWGrEnYk5qP3oXxjP/RaXqKUhNL1iZqtU3aPyMKH8SrqwWsmc0/
         GpQm2HgVgcXL7JtmLp41uXraTXfUjR0Pu3pGYpnfKO0TmcCPRjNSEI9ssgHhybA9TWsd
         qhLBcVh+Z9jOn7gDxs4w0/EEMwWiX3u+h/5Ntm2SuPn3TBMFQWYKCtkOcn9Jg8URMGKh
         ryIaL+57TuerlzyFEYAva/+l0GeJnoGpIk/jEoT4WU2COJoIZHJHCF91bR6zPbUno5Zx
         d+4StDjkY27fupr67P+3h/c9b/2rf7Njkhy+e427Evwqufz6iMekYqBVYPpViaC8HjUU
         ryPg==
X-Gm-Message-State: AOJu0Yz/qnLyHQHU3zXGhettOZ0WXgkNuBU0HtYEgDsa2CoaTtdrXz4f
	AVIbhr0Ik8Kbzlo+1C8pSJGG51fZKUNltpvW/bhfw0/kunS3EuJMOiScRm99iJxua8oAek5Zlj9
	0HTh/wCGIBIW7kPG43Cnb9frhaxaTpUFqvpdLNWg5jlaVBUy5/1E7mRPXQiauE5q6vlqKRYC46/
	hNmiqd7zSsVSf0F6qkiQcM0DF+PNhM32biAc3doE2FATPeYy2/IZkD2YxflSI=
X-Received: from ileg3.prod.google.com ([2002:a05:6e02:1a23:b0:467:9e40:e391])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:220b:b0:664:86ce:df46 with SMTP id 006d021491bc7-66d0c472fd0mr6437177eaf.57.1770676843797;
 Mon, 09 Feb 2026 14:40:43 -0800 (PST)
Date: Mon,  9 Feb 2026 22:13:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-1-coltonlewis@google.com>
Subject: [PATCH v6 00/19] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-70650-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gitlab.com:url]
X-Rspamd-Queue-Id: A3EE011518B
X-Rspamd-Action: no action

This series creates a new PMU scheme on ARM, a partitioned PMU that
allows reserving a subset of counters for more direct guest access,
significantly reducing overhead. More details, including performance
benchmarks, can be read in the v1 cover letter linked below.

An overview of what this series accomplishes was presented at KVM
Forum 2025. Slides [1] and video [2] are linked below.

IMPORTANT: This iteration does not yet implement the dynamic counter
reservation approach suggested by Will Deacon in January [3]. I am
working on it, but wanted to send this version first to keep momentum
going and ensure I've addressed all issues besides that.

v6:
* Rebase onto v6.19-rc7

* Drop the reorganization patches I had previously included from Sean
  and Anish and rework without them.

* Inline FGT programming for easier readability

* Change register access path to drop simultaneous writing of the
  virtual and physical registers and write only where the canonical
  state should reside. The PMU register fast path behaves like a
  simple accessor now, relying on generic helpers when needed.

* Related to the previous, drop several patches modifying sys_regs.c
  and incorporate PMOVS and PMEVTYPER into the fast path instead.

* Move the register fast path call to kvm_hyp_handle_sysreg_vhe since
  this feature depends on VHE mode

* Remove the heavyweight access checks from the fast path that had the
  potential to inject an undefined exception. For what checks are
  necessary, just return false and let the normal path handle
  injecting exceptions

* Remove the legacy support for writeable PMCR.N. VMMs must use the
  vCPU attribute to change the number of counters.

* Simplify kvm_pmu_hpmn by relying on kvm_vcpu_on_unsupported_cpu and
  moving HPMN validation of nr_pmu_counters to the ioctl boundary when
  it is set.

* Disable preemption during context swap

* Simplify iteration of counters to context swap by iterating a bitmask

* Clear PMOVS flags during load to avoid the possibility of generating
  a spurious interrupt when writing PMINTEN or PMCNTEN

* Make kvm_pmu_apply_event_filter() hyp safe

* Cleanly separate interrupt handling so the host driver clears the
  overflow flags for the host counters only and KVM handles clearing
  the guest counter flags.

* Ensure the guest PMU state is on hardware before checking hardware
  for the purposes of determining if an overflow should be injected
  into the guest.

* Naming and commit message improvements

* Change uAPI to vCPU device attribute selected when other PMU
  attributes are selected.

* Remove some checks for exceptions when accessing invalid counter
  indices with the Partitioned PMU. Hardware does not guarantee them
  so the Partitioned PMU can't either.

v5:
https://lore.kernel.org/kvmarm/20251209205121.1871534-1-coltonlewis@google.com/

v4:
https://lore.kernel.org/kvmarm/20250714225917.1396543-1-coltonlewis@google.com/

v3:
https://lore.kernel.org/kvm/20250626200459.1153955-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvm/20250620221326.1261128-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvm/20250602192702.2125115-1-coltonlewis@google.com/

[1] https://gitlab.com/qemu-project/kvm-forum/-/raw/main/_attachments/2025/Optimizing__itvHkhc.pdf
[2] https://www.youtube.com/watch?v=YRzZ8jMIA6M&list=PLW3ep1uCIRfxwmllXTOA2txfDWN6vUOHp&index=9
[3] https://lore.kernel.org/kvmarm/aWjlfl85vSd6sMwT@willie-the-truck/

Colton Lewis (18):
  arm64: cpufeature: Add cpucap for HPMN0
  KVM: arm64: Reorganize PMU functions
  perf: arm_pmuv3: Introduce method to partition the PMU
  perf: arm_pmuv3: Generalize counter bitmasks
  perf: arm_pmuv3: Keep out of guest counter partition
  KVM: arm64: Set up FGT for Partitioned PMU
  KVM: arm64: Define access helpers for PMUSERENR and PMSELR
  KVM: arm64: Write fast path PMU register handlers
  KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
  KVM: arm64: Context swap Partitioned PMU guest registers
  KVM: arm64: Enforce PMU event filter at vcpu_load()
  KVM: arm64: Implement lazy PMU context swaps
  perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
  KVM: arm64: Detect overflows for the Partitioned PMU
  KVM: arm64: Add vCPU device attr to partition the PMU
  KVM: selftests: Add find_bit to KVM library
  KVM: arm64: selftests: Add test case for partitioned PMU
  KVM: arm64: selftests: Relax testing for exceptions when partitioned

Marc Zyngier (1):
  KVM: arm64: Reorganize PMU includes

 arch/arm/include/asm/arm_pmuv3.h              |  28 +
 arch/arm64/include/asm/arm_pmuv3.h            |  12 +-
 arch/arm64/include/asm/kvm_host.h             |  17 +-
 arch/arm64/include/asm/kvm_types.h            |   6 +-
 arch/arm64/include/uapi/asm/kvm.h             |   2 +
 arch/arm64/kernel/cpufeature.c                |   8 +
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/config.c                       |  41 +-
 arch/arm64/kvm/debug.c                        |  31 +-
 arch/arm64/kvm/hyp/vhe/switch.c               | 240 ++++++
 arch/arm64/kvm/pmu-direct.c                   | 439 +++++++++++
 arch/arm64/kvm/pmu-emul.c                     | 674 +---------------
 arch/arm64/kvm/pmu.c                          | 717 ++++++++++++++++++
 arch/arm64/kvm/sys_regs.c                     |   9 +-
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   6 +-
 drivers/perf/arm_pmuv3.c                      | 149 +++-
 include/kvm/arm_pmu.h                         | 126 +++
 include/linux/perf/arm_pmu.h                  |   1 +
 include/linux/perf/arm_pmuv3.h                |  14 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vpmu_counter_access.c | 112 ++-
 tools/testing/selftests/kvm/lib/find_bit.c    |   1 +
 24 files changed, 1889 insertions(+), 750 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-direct.c
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c


base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
--
2.53.0.rc2.204.g2597b5adb4-goog

