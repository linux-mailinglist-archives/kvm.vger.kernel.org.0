Return-Path: <kvm+bounces-45766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B8AAAEF56
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 655321BA7A77
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBA2290D8D;
	Wed,  7 May 2025 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I5eEhOJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7051D2AD20
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661366; cv=none; b=QZy55IffenLW/3YXQFgCTjLJYLc8JE+5O6E8qsMaAuKqFS4904fAgUi19I6W8K3YfP0XxVG1hiwnz01ERwCWvThpF25fdyhIWL6mq9igVvhdvxr/4f605jDhQE0MucQZmcYXsb7TP9CRcw0NIb6WKkEPk73Sq+a0l2q063rNSwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661366; c=relaxed/simple;
	bh=dQNBbxhjmfGrOU1wLDxVNFa08ytj5lIani7W1uECOm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LtcMICAcEbkEMToTlzeZAB9Udb5vEVVbAyAoVPrFwq7y6eojFneNXFMDak13CTnfiQb0VBgMiOzAZO00+DY3DIeTv20Pps8KGzO2WtCykcKZIgN0oN3ytC50ks4sCrS/Yku58F7stMZ/dP4u8ybogtwLkAikzZk3vEasiCe3gGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I5eEhOJq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-227d6b530d8so4592445ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661363; x=1747266163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JehyW8M8VpKFuaI6YYMmr2hRWJI92AYFHrbysHYIqEM=;
        b=I5eEhOJqoDcr/eV93SXT+H9iIDTPQfhn4Zrz6R215/pU9JHVWeRWMf1FAO3YQh6AS8
         q542ZjNYmXinwbp8JSCUltWKMG2+/sKVsFA21nT1xZUEWOJYt5R3wx/CgpuQPcGlaa4m
         bKj/K4JVaoelv89kXkB3YrKDfHZJdIu0FzDxoAEoo8OdJV5N8T9SnNphAhX+8Q9rfpxB
         NwCb4hAuVTx6AfehnNF4RT8UDDa2JXb0ihc1r6begTTH3zCvg4XnNlRy3TyyY4NUvE/3
         ndWL9AbcCnTMx2CdgCtOwfXGcBcnF9FjPhp5OVfgFoss+kwG51q0jbdPKKWxoHh7SNGK
         rZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661363; x=1747266163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JehyW8M8VpKFuaI6YYMmr2hRWJI92AYFHrbysHYIqEM=;
        b=nUhbEQebhkBKBqDZhumoY4IrCfjdiQ/KUvOSv18ELTRyYeB6ZETNy2XcrAjQa2Giif
         +eTHiocoY3LPkKTkfuksmA5Rlz+8rfRTJlqbPqqC2XO4+R+cS0bVccpofTEhYkZjSkET
         BgoDe0v06YjKfguiw5GEWBCgPzMagDUnTdGkhUVuTpqhD1DREd4e1relXm0O4qF30rlC
         JWr3BKCfO7/XMiGv/7+aV102BGHCMEviHZrmQiRjs3pS81fNr9kWmTFu03vHdQlmLbnF
         wCQ5uteQJu1WwsZDN1FQtZsIaexHJXcbge34MeUZCmAFem97iWsu0E8xjQWbkHit6sgk
         VciA==
X-Forwarded-Encrypted: i=1; AJvYcCWXu4QIhlgyA+zK5lq9tlib538EQW0QzxGamKT6ZnAQ0qtDcq7oyZYvkiedfp8H96O/q5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywps78xlaTqo3auHg09ITIfsrjJShnodcYVldCfLacpWDJr/gWD
	dwWasjJEkAJn36c2j7fplHMhFcw4kq6LIyX6uGEL4gwfpr0EqDemR5xdUODPhtw=
X-Gm-Gg: ASbGncsn+aherYrmF4X5TfXrd49z1G0F7yVq8TrGQUP48wbzyslqfjqspRdKegGP4NA
	FBLpkn+JpjdSyZMkpX/Q9AN92FeavG1pzieYkBe1Ql4vsIjlE1wcaUTgeyiOtdYlvI2ZlI5JeuH
	90yOIxJ7ufQtcUgw7SEkIhNbYkfxuG9Ow2diDAmJSfUjCLl3qbHywuTjs6gkCLGZhGEenf8oxX0
	OryhxbaTEW4D7lyvBTazH9Gmlew5o+NANVNtwUgsHg+gFmtZUGsRlVF6Ynf4+mcgUZWGpt8Oqmf
	YUfm1y96OX9AqhnGr4zYceAHaNxBmduYVjWhUaxP
X-Google-Smtp-Source: AGHT+IEb8/jS6XFLZwBXKGo2JRaGqzWwUaCf2+23h6WBJFHtJioR8urxC77q0Op0VwdLUAEl1smgUg==
X-Received: by 2002:a17:903:166e:b0:224:c47:cbd with SMTP id d9443c01a7336-22e5e98947fmr80611175ad.0.1746661363604;
        Wed, 07 May 2025 16:42:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:43 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 00/49] single-binary: compile target/arm twice
Date: Wed,  7 May 2025 16:41:51 -0700
Message-ID: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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

Pierrick Bouvier (48):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  target/arm: move kvm stubs and remove CONFIG_KVM from kvm_arm.h
  target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
  target/arm/cpu: move arm_cpu_kvm_set_irq to kvm.c
  accel/hvf: add hvf_enabled() for common code
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
 include/system/hvf.h           |   15 +-
 include/tcg/tcg-op-common.h    |    1 +
 include/tcg/tcg.h              |   14 +
 target/arm/helper.h            | 1152 +------------------------------
 target/arm/internals.h         |    6 +-
 target/arm/kvm_arm.h           |   87 +--
 target/arm/tcg/helper.h        | 1153 ++++++++++++++++++++++++++++++++
 target/arm/tcg/vec_internal.h  |    2 +
 include/exec/helper-head.h.inc |   11 +
 accel/hvf/hvf-stub.c           |    5 +
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
 accel/hvf/meson.build          |    1 +
 target/arm/meson.build         |   41 +-
 target/arm/tcg/meson.build     |   29 +-
 36 files changed, 1534 insertions(+), 1386 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


