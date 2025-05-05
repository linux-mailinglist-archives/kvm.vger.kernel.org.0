Return-Path: <kvm+bounces-45486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDFEAAAD38
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:31:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86BDB1891F98
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC09928D8DE;
	Mon,  5 May 2025 23:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YTDMCKIK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E87F28B3E9
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487225; cv=none; b=L0KR1Ur4/3rU35l+E0qklY21dmIkGpoUkOMpxWR5OYFnTBYVlXIP1n0yLbioYug6NSguZWvSSlbRX8WI8SiCVB9xBOV0YTcQSA3PjdtICjAZxjFnr9eNN0new5rpojeA9ME4xp85dD3EFb9tW6jXq1hFlHRYdXREYwEIPN2/4Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487225; c=relaxed/simple;
	bh=KM4e5k99+ZhpII/rmnqZ2icmNCpowZAV9OwyNYgA724=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AeE7BnOVWtjihpJPisl2kCnxpbVvIOaAd5ud9aw8me5zpjowy+aAmaJ8PO6VDElQxeAczalMi8/jejfvUhuWm+JMd8tEoQbegRbcgbblubihXO5k4a98uF/sVQRW+GwrVyCm/ZxUKU/29K9TIdcVmIInn/WDLKarFKXu09LLeME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=fail smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YTDMCKIK; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-af6a315b491so4540100a12.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487221; x=1747092021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=04Ix3M4tuJXhEIQ9AeSHf28aqJlTNZ3AOq6Hx3kur6A=;
        b=YTDMCKIK1hHLGhNWnN+n0Jl/FpRgxTq5Uwdk4xqgGADKfvHUJE9jf1uERbGzSe+EP7
         +JVC28yif2Gp2TgrSpMKyu+011PYgKzJy8UnFqs8M/gqIG/emkEfKeF8/c8l8fWNHt9i
         Om6+MHD++t4J9W+LPZBlt8nHkoebecMRfOim8m2rc+LMnC4EhCKXESIjjjv17LHb6PYH
         JoFq87bzDC73ueew0tohQqqV52Ef2I9yk4vWHSwNfw0wt68yJ3jevgBgfHGu7CysUl+H
         1JCkPvDtUbhNNM5+7+2PwOy9PSxv7EXwLcQS4LNmsT2G3Xe5dkRr/q9UkUhNPtrTzqpJ
         1I3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487221; x=1747092021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04Ix3M4tuJXhEIQ9AeSHf28aqJlTNZ3AOq6Hx3kur6A=;
        b=qaTAG9BbghciuXfrsS+yBTKRT6VUaiSHLcDeIcsqnZrNlAUE33Q3CQAas08wyH3YSw
         fV+ScD2kTrWY9esSP2zFcUOf331eLdkI3/GRrG7gRnONIfFm7HDX/zOcn8SWZvrNhXdn
         KME3EcXZ9aYHA2aQ9E8ZX+N6jlQA5j5M1LlKMbhXX0r7GnowqfgAhNHKMoOfGxYofj6S
         vBhifFNfKtkD7mJwUpBh/mt2fDayFRC+nfdYkmp4hV+VQmje1MduM/a/r/3iOLaukRye
         zuOEr+JeMz6pn9cLA4FFbqRW5vdvrXQ/cUQKGpT8t+MxlTFAnAfzPBu/S/yXApy/wdN9
         rkTw==
X-Forwarded-Encrypted: i=1; AJvYcCVw8ozSG2GvxwUBkWz3ig7NFSyBqDo3zvPEneWf0KUlNKzuTacR6kFaekiSv5ydIk3s4VI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl/7dK1uzKII/3c6b3xp2Msku4ThXwVgCf38vqMZSOrHhM3SDi
	gPdlgGpMXlXSkAPuCcs6jil6OA3oWyraxryQQaGbToZ3AUzzUHWHpV02fOTgG/Y=
X-Gm-Gg: ASbGnctr7+snGR3OjfLWXhtkDDO8peF3Is4yh2/YfTVNkQ0MrkwUDXR37pNWICZ6FGM
	dEwdRtXduVV43CKJeqWH/ftRBuvLjBJObvRmkoDDvsiOXxscEECCTlP28VHRcSlke1XK5ZBUvvc
	X0WWIPUiexkAvTA0TGtPU1ipjoLgzsotPRq8EZPJX+wv0wDZco0A/w5hCmD6seqj2V57XLB0uJf
	HB7Vvm38JrpGiGnvmnBG+KfUVbDazHogfAFCC95JlN5SDcSsQNaQehk0wveeM5y0ThZ6cnvkkZI
	5qKBdPWZRt8EXh++MdP+YsgWh09fBa8ohcLLeH+P
X-Google-Smtp-Source: AGHT+IHfCgAA4+D90CVu2oz49y29SXm3HfgqMa52LdxN54WvvmDw5NiqsMm2gDuMWZrsbaNGyWXGVA==
X-Received: by 2002:a17:903:41cb:b0:220:e1e6:4472 with SMTP id d9443c01a7336-22e328cf92emr16217105ad.13.1746487220678;
        Mon, 05 May 2025 16:20:20 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 00/50] single-binary: compile target/arm twice
Date: Mon,  5 May 2025 16:19:25 -0700
Message-ID: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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

Pierrick Bouvier (49):
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

 meson.build                    |  104 ++-
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
 target/arm/helper.c            |   23 +-
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
 36 files changed, 1547 insertions(+), 1398 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


