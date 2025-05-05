Return-Path: <kvm+bounces-45347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F3BAA8AAE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22CFA7A7CCE
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15AD1991C9;
	Mon,  5 May 2025 01:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ydw/Fa++"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED12E191F84
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409949; cv=none; b=Nkxt4Z/SBXYUArUD9kg+dC4XB/suDyx/KqfKRun+ywdqynOJmASyuOlcG1IG5/uIdvxs2xJxOHBE1aLAQGHmJHfs3bMF+pqppPYWboaSPDE1rx4FD5DbulvZHjgc/VApXUgA4PEpCMT6LTt/M/GxugIRmAjZhrwp5wUAdWjpkTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409949; c=relaxed/simple;
	bh=/8Z7DX2u6gFm+0qwWYJv7LOYXC0255HnjuHGthy4hqw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VXIq+U6WJMf/JSzCHB1fdlfeYENy+jOg5yJP+7WzRKDOd5MyDJT2YF47iMM8dCapSZmeZ42B2q1lD9Q8eoQuSypYrWsX+G4OnTON642j3FwJ13tBE8b+N7tA9fUExrwkwFR52FoG9L3KRVHRjqJMCndfxoWBni2r2lpIRHYAd08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ydw/Fa++; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso5499921b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409947; x=1747014747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ahgA2NICchATUWyUqONsVh9cLKvE33L09maAByMkPyk=;
        b=Ydw/Fa++PoUAvouhA/ogSBwHzd0hDITP49x+VVwEKzaDmQ04LQPFgQtV20tYaOrbQ0
         X07OtDwbTcQCIy3EtLK//gkoOtqdeWPyYdL3XjYwqRSatDUohS+K9Y55eEreUhN9cAw4
         4RrAE1uUn8cJAZKBKadvKbBMapz+GcUojI0+k3+JVOdbDo9Bn7iEZ0yo1dR5b7BYSMpu
         74abwX3/HHnj34fOYMiT0kKdj8tqpnhbwI7mCP8dl/aO0qn4IlNFDARmwQqaNeTq/A0N
         HQiSpkP/H6JrIpKkEvwmXuo0LW6XSFBLM3ZgEAP46gHMeyFw6ffjeMp2A61dTcaxsuqn
         Sk/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409947; x=1747014747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ahgA2NICchATUWyUqONsVh9cLKvE33L09maAByMkPyk=;
        b=Tskq47GNWGWVLdglmkZWB8NRs4sCq2ldjBUJndLt/X7P8Ycxk6leqbl/s2NaD6YIic
         NP73NspzaCs3BuU4YQMOvaikwrj37D0z0AfLWbirBY0WHfKVIK0anvqP0Le2aHDgK71h
         sH65rU6yY5spb9zmwgKnV8OH6MK7DGDwGNJXyw09q3TkojJIZCzMKiQm6kod4stPNVNY
         nKyrzQVNGCjK2rDPcks6Cosqd+X4LamHdr0UoYUZbEPFRL1sDCxyX1RuYon92nxsHJpP
         sXNkn41Gu+H6l87z23TJ+TinR4Mp94aq/s1DArnOPtsgiRM+kGpXfyRi/TADBp5u/6FU
         LHWA==
X-Forwarded-Encrypted: i=1; AJvYcCWPbtol5wr9N2Oi8Px58JFgfJdb5bonocIdDhXhDVvj6wsVZ9rW/+P+O2jbVlvUW1eQ+LA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyONAcGwLuTBy2Uthh/5KuE57fVwsjjwIlG0AuOgQPx8t0SHpAK
	1egXQpxIBzfH09VHu3hO5F7yoFJjVgSc2KP/i9/6Wzh6/1IEyb06prG/QebPL9s=
X-Gm-Gg: ASbGncvWFb/NB01lV5RjTK+Wsr9/faX0kAngyLZ5AYNCM5HwfXFbiTOeFHTkZMswe85
	6sfdX5qxomy/uNYsaWmFJrkWABdTYIluEWDBcQvvvytjt6OqmwdEL2RvStM4pXFtGMbbqmZ/Lc2
	cajnuRdLYiT+r94dNbnnh/CUuiPVfWE0gsB3C8TXYrlalTwvkzCCpJ/i3surEUKn0om2MLPLoQv
	PaJ/65uEiP5zs4tKqIokNBth+Q0M0FcInRO+PwqptAqXaIMTQLA6xz6YHCZWW5TwtTl6iIfFC+O
	zLkutNg0HV5d+vRp7jwvk1Cfpo6ca0xozSg0/F6K
X-Google-Smtp-Source: AGHT+IE1sKfZ34X1oQ8FA4uYE1kw3ZEBhackQfnDZGJTR9Ww8iIZHCriZQXJNLDmi+zkHeZosREfpQ==
X-Received: by 2002:a05:6a20:9f4d:b0:1f5:9d5d:bcdd with SMTP id adf61e73a8af0-20e96205cebmr7161534637.1.1746409946929;
        Sun, 04 May 2025 18:52:26 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 00/48] single-binary: compile target/arm twice
Date: Sun,  4 May 2025 18:51:35 -0700
Message-ID: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
Fully tested on linux-x86_64

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
  target/arm: Replace target_ulong -> uint64_t for HWBreakpoint

Pierrick Bouvier (47):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  meson: apply target config for picking files from libsystem and
    libuser
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
  target/arm/tcg/crypto_helper: compile file twice (system, user)
  target/arm/tcg/hflags: compile file twice (system, user)
  target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
  target/arm/tcg/neon_helper: compile file twice (system, user)
  target/arm/tcg/tlb_helper: compile file twice (system, user)
  target/arm/tcg/tlb-insns: compile file twice (system, user)
  target/arm/tcg/arith_helper: compile file twice (system, user)
  target/arm/tcg/vfp_helper: compile file twice (system, user)

 meson.build                    |  104 ++-
 include/system/hvf.h           |   15 +-
 include/tcg/tcg-op-common.h    |    1 +
 include/tcg/tcg.h              |   14 +
 target/arm/helper.h            | 1152 +------------------------------
 target/arm/internals.h         |    6 +-
 target/arm/kvm_arm.h           |   87 +--
 target/arm/tcg/helper.h        | 1153 ++++++++++++++++++++++++++++++++
 include/exec/helper-head.h.inc |   11 +
 accel/hvf/hvf-stub.c           |    5 +
 target/arm/arch_dump.c         |    6 -
 target/arm/cpu.c               |   47 +-
 target/arm/cpu32-stubs.c       |   26 +
 target/arm/debug_helper.c      |    6 +-
 target/arm/helper.c            |   21 +-
 target/arm/hyp_gdbstub.c       |    6 +-
 target/arm/kvm-stub.c          |   97 +++
 target/arm/kvm.c               |   42 +-
 target/arm/machine.c           |   15 +-
 target/arm/ptw.c               |    6 +-
 target/arm/tcg/arith_helper.c  |    4 +-
 target/arm/tcg/crypto_helper.c |    4 +-
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
 35 files changed, 1542 insertions(+), 1396 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


