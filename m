Return-Path: <kvm+bounces-46201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E83AB41FE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C70C1B601C5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974222BD004;
	Mon, 12 May 2025 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qtahiwuU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201F2BCF5F
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073114; cv=none; b=UuBLkAsnDAGPCfbauUmhqaEhWOJF+DpYtKXrW39tPWTEXBf1nrUqUEhrq3Msunkwr/tdugaVtrsUAEU/BXUwVKn+UB5XmxrNpS0A4xObqdjTyA2llZrKYGmmDqfFKlAgn0+8M/9dMCPZlUbg7xWpkMDcS2q288KxNECtw90hw8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073114; c=relaxed/simple;
	bh=ZcJ9bNJ+hVv4zuD9NQKZ5O8Hx8Y07EfgC4s5cMI4uvI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K5a4qqg8w4QpuKZ2BK7RZyojX2dfuDUnGhlknDLNwssov+pv3zCoDCslsKYCqH662ZY9++rVkGZZgxDcIbnPXJlHrEoHLFANBCwMsC5fPk6cIGQKNUAO6YxwWW3ZLUvVvVS8hGvmqX4RQYUHse1+TkTWG/WybzA6yKzi9TwLzB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qtahiwuU; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b1396171fb1so3185012a12.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073112; x=1747677912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4MW56a2N9JGW8XiFvlXolamnMWHQl+hL453c6R1PReI=;
        b=qtahiwuU7IDNXZXbx2bokLy+CS/ul6YrBjbypYmZxN6me5L+/5lYAzvH8Vzlqk1JNm
         ljmO4iaA8fMC+ZNfyZmqcwd2CosnnFSA9wwFwtD9WvgTBGKMZRA+6MOMafpCbKIGHBkw
         CKpyo6GMiQf791en+g1+Vq4QxP264oa8IRKzom5I2yYz0UObVWjblEMMDUbISuBpyl1t
         8EPzfPsCNZIGrxbsODkLj7KI4bQG31CcapUQUpyQf7UeXTkBdk8nl7DvYNCs9PLxH+Nl
         pIartaUzkMTduaEWra3HzUlFKCz9/GtQXCQTsq35zai3iAR3F6UM7LGJVBDMXR49qro2
         F/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073112; x=1747677912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MW56a2N9JGW8XiFvlXolamnMWHQl+hL453c6R1PReI=;
        b=S8L9idps1r7FwK/xMjrutFpqnnxdkb/CQy/dAfhCPwGwaIGwjPUWQZ5cwweMrUE9iJ
         Cl46cpU76kzzlWNBb+4ljTB6X2CJDmCrYF4IiEIXbF00iweK3ekv5mTBAB+WnRxbgGos
         rOn57fJMmZz0KsExo2SANslKplgDlH13lOYUKUdcJp6bGzgIYBlUOiiPtaQDJ4KEC01J
         nn6wwjGYXjtBdyn7XARDciZuXDNEjPaOwUvIb8Fe2SO63o5iRhBW72+Y2qA7dRx+6cKR
         +HSOmdoXAsUSfRdTUSQCb1gL70cWlTSvAKSKHG1e+LBqFWwH4ReFHHOtPp5vKpUlIOFt
         MLcw==
X-Forwarded-Encrypted: i=1; AJvYcCVqCdNxWnqJ7T3fNKOhuko7MWQhDzIVfm7u1WrfGlX3TSQFQmVTVFDD60R7IVLa3fb5YVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwclH5VUsr5qPMy2nsVtkYOtU7TEOeIk97nPq4p/Wuc08l8FLlC
	Vquf5roCWjfeMedwez7cQCYlY+rVdcXt8BxbjcrSZ2mSmMHJNZlt3cMDxHFs9Es=
X-Gm-Gg: ASbGncub2zHyCcPKigQY4p8w+EPO+q9v0ctaPgZuY+pp/a5x/j++QjvVzMH8Zfbo7o3
	QOOPP425T1CB0tHBo/soAuXwLS0BNBYCDVKKq+bJ3gUr41pTCZy9fcHCiU3z4gA2bDblPhJZnFH
	mWyFZL/Fn8ZQbvwAaK3FOULluCjxX5hVnxOwQeWstoZK3um4MuseSoJAIv8/Q6cCrXREX1rV7NB
	LiWDt6oZ8AHGxuGs3Lb42txkUmDT2gCTzld3S92FyuejD3QKTDl5xNwTM+FNQIu9KjcD9rpyLqe
	GhHq+qBMSP01q2AvmiTddQzqxSlxBKZ7oFz25s/+pSaVgOeOLZE=
X-Google-Smtp-Source: AGHT+IHn+seSlUHxe/d++qBkY4dNL7LDRkrQjITqXqKQ+r5hF6/emBo0ZXMFZkXSOu8uzP134zkiFQ==
X-Received: by 2002:a17:902:f68f:b0:223:66a1:4503 with SMTP id d9443c01a7336-22fc8b73d0emr172327945ad.30.1747073111863;
        Mon, 12 May 2025 11:05:11 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:11 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 00/48] single-binary: compile target/arm twice
Date: Mon, 12 May 2025 11:04:14 -0700
Message-ID: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

More work toward single-binary.

Some files have external dependencies for the single-binary:
- target/arm/gdbstub.c: gdbhelpers
- target/arm/arm-qmp-cmds.c: qapi
- target/arm/tcg/translate*: need deep cleanup in include/tcg
- target/arm/tcg/cpu*: need TargetInfo implemented for arm/aarch64
- target/arm/tcg/*-helper*: need deeper split between aarch64 and arm code
They will not be ported in this series.

Built on {linux, windows, macos} x {x86_64, aarch64}
Fully tested on linux x {x86_64, aarch64}

Series is now tested and fully reviewed. Thanks for pulling it.

v8
--

- rebase on top of master

v7
--

- rebase on top of master
- removed patch to apply target config for picking files in libsystem/libuser,
  since it was the only one not reviewed.

v6
--

CI: https://github.com/pbo-linaro/qemu/actions/runs/14844742069/job/41675865456
- Replace target_ulong -> vaddr for HWBreakpoint (Philippe)
- build target/arm/tcg/crypto_helper.c once (Richard)
- build target/arm/tcg/tlb-insns for system only (Richard)
- build target/arm/tcg/arith_helper once (Richard)

v5
--

CI: https://github.com/pbo-linaro/qemu/actions/runs/14825451208/job/41617949501
- Do not define a separate vaddr type in tcg, simply alias to i32/i64 (Richard)
- target/arm/tcg/crypto_helper.c
- target/arm/tcg/hflags.c
- target/arm/tcg/iwmmxt_helper.c
- target/arm/tcg/neon_helper.c
- target/arm/tcg/tlb_helper.c
- target/arm/tcg/tlb-insns.c
- target/arm/tcg/arith_helper.c
- target/arm/tcg/vfp_helper.c

v4
--

CI: https://github.com/pbo-linaro/qemu/actions/runs/14816460393/job/41597560792
- add patch to apply target config for picking files in libsystem/libuser
  Useful for Philippe series for semihosting:
  https://lore.kernel.org/qemu-devel/20250502220524.81548-1-philmd@linaro.org/T/#me750bbaeeba4d16791121fe98b44202afaec4068
- update some patches description (Philippe & Richard)
- tcg: introduce vaddr type (Richard)
- modify concerned helpers to use vaddr instead of i64 (Richard)
- use int64_t instead of uint64_t for top_bits in ptw.c (Philippe)
- arm_casq_ptw: use CONFIG_ATOMIC64 instead of TARGET_AARCH64 and comment why
  (Richard)
- target/arm/machine.c

v3
--

CI: https://github.com/pbo-linaro/qemu/actions/runs/14765763846/job/41456754153
- Add missing license for new files (Richard)
- target/arm/debug_helper.c
- target/arm/helper.c
- target/arm/vfp_fpscr.c
- target/arm/arch_dump.c
- target/arm/arm-powerctl.c
- target/arm/cortex-regs.c
- target/arm/ptw.c
- target/arm/kvm-stub.c

v2
--

- Remove duplication of kvm struct and constant (Alex)
- Use target_big_endian() (Anton)

v1
--

- target/arm/cpu.c

Philippe Mathieu-Daudé (1):
  target/arm: Replace target_ulong -> vaddr for HWBreakpoint

Pierrick Bouvier (47):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
  target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
  target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
  target/arm/cpu: remove TARGET_BIG_ENDIAN dependency
  target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state
    common
  target/arm/cpu: remove TARGET_AARCH64 in arm_cpu_finalize_features
  target/arm/cpu: compile file twice (user, system) only
  target/arm/cpu32-stubs.c: compile file twice (user, system)
  tcg: add vaddr type for helpers
  target/arm/helper: use vaddr instead of target_ulong for
    exception_pc_alignment
  target/arm/helper: use vaddr instead of target_ulong for probe_access
  target/arm/helper: extract common helpers
  target/arm/debug_helper: only include common helpers
  target/arm/debug_helper: remove target_ulong
  target/arm/debug_helper: compile file twice (user, system)
  target/arm/helper: restrict include to common helpers
  target/arm/helper: replace target_ulong by vaddr
  target/arm/helper: expose aarch64 cpu registration
  target/arm/helper: remove remaining TARGET_AARCH64
  target/arm/helper: compile file twice (user, system)
  target/arm/vfp_fpscr: compile file twice (user, system)
  target/arm/arch_dump: remove TARGET_AARCH64 conditionals
  target/arm/arch_dump: compile file once (system)
  target/arm/arm-powerctl: compile file once (system)
  target/arm/cortex-regs: compile file once (system)
  target/arm/ptw: replace target_ulong with int64_t
  target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from
    arm_casq_ptw
  target/arm/ptw: compile file once (system)
  target/arm/meson: accelerator files are not needed in user mode
  target/arm/kvm-stub: compile file once (system)
  target/arm/machine: reduce migration include to avoid target specific
    definitions
  target/arm/machine: remove TARGET_AARCH64 from migration state
  target/arm/machine: move cpu_post_load kvm bits to
    kvm_arm_cpu_post_load function
  target/arm/kvm-stub: add missing stubs
  target/arm/machine: compile file once (system)
  target/arm/tcg/vec_internal: use forward declaration for CPUARMState
  target/arm/tcg/crypto_helper: compile file once
  target/arm/tcg/hflags: compile file twice (system, user)
  target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
  target/arm/tcg/neon_helper: compile file twice (system, user)
  target/arm/tcg/tlb_helper: compile file twice (system, user)
  target/arm/helper: restrict define_tlb_insn_regs to system target
  target/arm/tcg/tlb-insns: compile file once (system)
  target/arm/tcg/arith_helper: compile file once
  target/arm/tcg/vfp_helper: compile file twice (system, user)

 meson.build                    |   78 ++-
 include/system/hvf.h           |    1 +
 include/tcg/tcg-op-common.h    |    1 +
 include/tcg/tcg.h              |   14 +
 target/arm/helper.h            | 1152 +------------------------------
 target/arm/internals.h         |    6 +-
 target/arm/kvm_arm.h           |   87 +--
 target/arm/tcg/helper.h        | 1153 ++++++++++++++++++++++++++++++++
 target/arm/tcg/vec_internal.h  |    2 +
 include/exec/helper-head.h.inc |   11 +
 target/arm/arch_dump.c         |    6 -
 target/arm/cpu.c               |   47 +-
 target/arm/cpu32-stubs.c       |   26 +
 target/arm/debug_helper.c      |    6 +-
 target/arm/helper.c            |   24 +-
 target/arm/hyp_gdbstub.c       |    6 +-
 target/arm/kvm-stub.c          |   97 +++
 target/arm/kvm.c               |   42 +-
 target/arm/machine.c           |   15 +-
 target/arm/ptw.c               |    6 +-
 target/arm/tcg/arith_helper.c  |    5 +-
 target/arm/tcg/crypto_helper.c |    6 +-
 target/arm/tcg/hflags.c        |    4 +-
 target/arm/tcg/iwmmxt_helper.c |    4 +-
 target/arm/tcg/neon_helper.c   |    4 +-
 target/arm/tcg/op_helper.c     |    2 +-
 target/arm/tcg/tlb-insns.c     |    7 -
 target/arm/tcg/tlb_helper.c    |    5 +-
 target/arm/tcg/translate-a64.c |    2 +-
 target/arm/tcg/translate.c     |    2 +-
 target/arm/tcg/vfp_helper.c    |    4 +-
 tcg/tcg.c                      |    5 +
 target/arm/meson.build         |   41 +-
 target/arm/tcg/meson.build     |   29 +-
 34 files changed, 1519 insertions(+), 1381 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


