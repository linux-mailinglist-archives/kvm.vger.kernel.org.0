Return-Path: <kvm+bounces-45029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 206E3AA5AC5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF7349A3017
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F9E2690EC;
	Thu,  1 May 2025 06:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fWgbxKqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50094746E
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080634; cv=none; b=ibcDAqk2Bk3vy4Wk/MKIgsI5RMfbybAC7IDft8t8CO9GNJp+4PJTBgiPgXfuIOL5EznigbmnteRtHppokAPUm4xF39thtAoLdEsalDwnZZyFbXecuUM6zJXmcLtQ8D8dOk8gX5xMFgkwRyi+T2MGLl+WhxopWXZRsS93R2moZ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080634; c=relaxed/simple;
	bh=TyqiHJBn08s0GaD72/S2yioZ1FwJhriCAKX+jdHMQkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=scWotWciWAx3qSEN9ttRtgXZ0qtqI8COZBNyUo/Jch7DSLXXgEHCv2el2/JwIEiPRZru5oUVbUnvb/PJqwdmDkkhPouAsfVJHWV2wtgxzDdi+113XVbomJsyI1k0lFKGTGQVtunJTjZcBIh9bTr4LRvkj2zVM7vc1NTzgIxhyuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fWgbxKqx; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-739be717eddso551000b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080631; x=1746685431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rkK6B1xUwpIIGqtDFIUiUmTkZGBt+hJWF4dMkT/mNuo=;
        b=fWgbxKqxL0MoBFFqfctNJ5Xiaahr26XiASfUkf9aK4yBeOEf/zvRXlYmQjo+0QUo+o
         gj4M0+QP7oJotPZZvoNlfxAZHhp59N27tuLugj6qcFPviZ1xaflvJWJe4QNwBZo0jBq0
         XCAnQQjhkM3LSNZnFvPGZeY5uCme4pU/GCzn8gk2yuqVm3rEXHxgHWJMhgJzPE6jAvUi
         /uD1xH6+sLOjnn3ITNv1IT58ieNmyKe5zV696iFsBmDtAyr+owVyFAZACR3f62FtD4SO
         MNBNLStH1rWy+O9rqspKVY9l6WFX+pATQyjIocr7VPd3b+GsOn9AuZzns2mmnRSuSzBX
         CEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080631; x=1746685431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rkK6B1xUwpIIGqtDFIUiUmTkZGBt+hJWF4dMkT/mNuo=;
        b=iZy15Ti2N/LzqTJBApC96TkX1gLaoAikSaqE4El356oqDhvn+KD9T4xVFH7mu6oQHn
         ZWRy1UegsRDRcmqewwU0zdud7okaKx40/zts6Bjgc6NlqZcwhP/jGMUFjO9x6Eiy3+b4
         adgKclRi199te3+pFCjrNXxT4mqtb5bSr+YVWz93R2dEX2dVJNRfm4Nw4tEdL4clHb09
         pQXtta50KVub8Born9I224Zk2N5Zzhr69SJnvsDCGs3vyevRRp7FJn+15kca7v5yXKWe
         eHunnmhSNbdi6gxsvD9AhOMvjvvmj/TdPKgvQp+TK07fzgNtT3l6CkE5M67LSuKDzQeC
         AY3g==
X-Forwarded-Encrypted: i=1; AJvYcCWJ3JTr8ytOy/RvRdV+E4y69e/4IjUdM8/AdlVJPHx+Lh4LuvOlEjP/fyVIdGb+dnAPpgc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+VL9dh/zyDcvul06jUS1uBHNuH2+4VSXkm1lQJuOxycyrXlnA
	AOYtvJ4Ym8w5K0BeKkKwMykTa++TJHMSFXVCnK6aLelsThQzuczLyjlS31GKkjA=
X-Gm-Gg: ASbGncv8SMSlzNMo2xcSGf/cJiZ/HYFAVzltaskbLrgvA+G3/t0xzH+F8x2GsqrN+K7
	hHu1sTn2WbjE5nP5JLt5w+1UISSjXN6skb8Wf4yyDq87xNDR17PFwYR4NfTp/KfOTcECYzDb7zg
	dJM++JzFJ1JzwvgYd1lGqmfyPXB8dW7ZbjEc/41XrZItWd7atR4KSLqNV4oiftmQ70aK3+p7OVR
	SvCh58rsVUuE00RQGO+hMDi9WF2buOdWTMkuIh/dbIxjAoPBOHAf3RG52e4jx7/W7iLKOHh4zGw
	Z7PD+OIMWFGmiJe1zupJN9MqRtOjvmFiQQjRhlVW
X-Google-Smtp-Source: AGHT+IE+QE3VdhRxsOSZO494VE5KFtC0CSO9PmXREhijoNUJXdUHnZkCg1m0jSY9sHBEloCWq/dRiA==
X-Received: by 2002:a05:6a00:2450:b0:73e:30af:f479 with SMTP id d2e1a72fcca58-74038a834fcmr8492876b3a.19.1746080631530;
        Wed, 30 Apr 2025 23:23:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 00/33] single-binary: compile target/arm twice
Date: Wed, 30 Apr 2025 23:23:11 -0700
Message-ID: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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
- target/arm/machine.c: migration
- target/arm/gdbstub.c: gdbhelpers
- target/arm/arm-qmp-cmds.c: qapi
They will not be ported in this series.

Built on {linux, windows, macos} x {x86_64, aarch64}
Fully tested on linux-x86_64

v1
--

- target/arm/cpu.c

v2
--

- Remove duplication of kvm struct and constant (Alex)
- Use target_big_endian() (Anton)

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

Philippe Mathieu-Daudé (1):
  target/arm: Replace target_ulong -> uint64_t for HWBreakpoint

Pierrick Bouvier (32):
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
  target/arm/helper: use i64 for exception_pc_alignment
  target/arm/helper: user i64 for probe_access
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
  target/arm/ptw: replace target_ulong with uint64_t
  target/arm/ptw: remove TARGET_AARCH64 from arm_casq_ptw
  target/arm/ptw: compile file once (system)
  target/arm/meson: accelerator files are not needed in user mode
  target/arm/kvm-stub: compile file once (system)

 meson.build                    |   78 ++-
 include/system/hvf.h           |   15 +-
 target/arm/helper.h            | 1152 +------------------------------
 target/arm/internals.h         |    6 +-
 target/arm/kvm_arm.h           |   83 +--
 target/arm/tcg/helper.h        | 1153 ++++++++++++++++++++++++++++++++
 accel/hvf/hvf-stub.c           |    5 +
 target/arm/arch_dump.c         |    6 -
 target/arm/cpu.c               |   47 +-
 target/arm/cpu32-stubs.c       |   26 +
 target/arm/debug_helper.c      |    6 +-
 target/arm/helper.c            |   21 +-
 target/arm/hyp_gdbstub.c       |    6 +-
 target/arm/kvm-stub.c          |   87 +++
 target/arm/kvm.c               |   29 +
 target/arm/ptw.c               |   17 +-
 target/arm/tcg/op_helper.c     |    2 +-
 target/arm/tcg/tlb_helper.c    |    2 +-
 target/arm/tcg/translate-a64.c |    2 +-
 target/arm/tcg/translate.c     |    2 +-
 accel/hvf/meson.build          |    1 +
 target/arm/meson.build         |   43 +-
 22 files changed, 1436 insertions(+), 1353 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


