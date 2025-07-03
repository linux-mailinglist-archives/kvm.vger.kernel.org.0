Return-Path: <kvm+bounces-51403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC06AF710A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81CC87AD5B0
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734FE29B789;
	Thu,  3 Jul 2025 10:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uSvYZozk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D77C2E175F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540147; cv=none; b=cgvGEm4xWTMUbLgg0Eth4dyKj/kpA3ELrpabpVkEZuLwPkmo8XxBTk7T/EEbC7GnCyiGQCzqRa5Xy9fIQftx/wgXSS96SVDfSZRTY8SsbjGBuCNzSp6I5zKGfwTDOSV3ItBJtcOo3UbHO/hPG73kGA203IJhog0L/bVVsqnTvOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540147; c=relaxed/simple;
	bh=yNrAZ8XSfdEzwB9QZmW9FsNd5V8nJp+lI11qLTiOGm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V3NBxnafNz3FRi6sGAdhbinSiCwCPb11VRHyNq1AHdwS61OxEOz56+zCVo0PnFAciF895l/cqwwdCB7h3LIQh0SZ9KNQvk1mMXJTH2l0dqh4uJZNafz09z464FP72CT/sO5BBJATMbEkWAO/9n5bnqufud0zTX620jDZ8rEFYnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uSvYZozk; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so618844f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540143; x=1752144943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f+2R1hBY3Aw7QOuX8M6Qxlc6ucglQYLGGejzuhYkZdw=;
        b=uSvYZozkQMSwzcJmxyztN8PsQzYI5In1bAllq/9akdPJ9pylqz1pdSUWllMXMkPiSi
         Rqv3gfMTA/J7pzMhxpwkSzxkWGUE0Bnjj/WBWB4AOaHVCiVOkUzmS9ut0NYxSPsx3xkZ
         J0ISkS7zUBXQtI30KDBfjikOVpcdgg/iyQmkFn4ZawsaD0EE00K0Sw0wEouNnuDtxAfg
         +WiWn9CVUtAEVDfuoB0rF5K9/uzjJBxaSShKKWvj11mm6yE1SIYNHXXyAiwY3WWLB01x
         iTbckTqsnw9pZkkdDYurt10fIvlebmczadyp40oHrxW+Oi2gnAvuBO2y/LWiWVjgIVu/
         D7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540143; x=1752144943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+2R1hBY3Aw7QOuX8M6Qxlc6ucglQYLGGejzuhYkZdw=;
        b=hF4PixjWcmEqR8AI7Yy0Q0xQVyUXC2R2Yy1crVOAgLqbUZFt4YJ1TcEPfI0/bWEcj/
         1MsIWWJrAfmGmeSGaZti1rPAvepSDeeIcfbvhClKzjRxDSHjsey6uk3QlpvyOHqrHz9D
         nKdGMVU287Rh3iPS+HNSe8rXwM78LsANLDlNQ1hxCOTTddfpeMDex3yk40+mElnhl5NK
         fOt05VPBXEFKghlxoQXiaAwpdrdQzIRKLiA48SJ8q8QKGKeJdHX6pKyIXsabBLOoRQJF
         WLQCPaLIjW/JxJUH+iBLC6sgmLBnc/PUX/tJ73HUBc0kTJGCZAF+1OSeUsm9boD8HBA8
         u5mQ==
X-Forwarded-Encrypted: i=1; AJvYcCX69W6x714HvJcpZErBi/u9Q+v+vKnrRVHhRJGUG5qS083daChBifzd4RM01FNq3iyHquA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQSK2vOQcJSFINu94k/dHfdAAH6Bl9U1tXm3tRzcJgl5sKI+lf
	dSfbdRJLzjhIbhqAeJv9wIhIH3XJYJugcz9N4faAqLs6slQGFWezsohYy8Y61e60GQE=
X-Gm-Gg: ASbGncvgdeWIN50AC+rdeieIBHuerjGibXLl9CSYGJ+nLVOxFgI813vobeMyaBmqAp6
	8XFRRUMbL2OMNDA7RqySscVYgBP4gztE04p/xq5Ilav1CJB4toaKr4ljxbXrTyGwv/aWl8UqJpX
	vFefonCf45CpWo/qUkXXNLzgGN9JPyr4WAkSb30XMQY/8fmc/IN8NLjuC00A2rcKdFTpbUv7bZT
	FdsDlrw37ne3X+KDXMJ1Z320g63QtL6vDGIWVAjyHhLbnw3khhC737xJUdAD1pmK0avn7QBDpAV
	ZNYAev0XpGBGNAACcsaKDpV18uywmUW4hh26RdU045Udr7fHBnYW6T4VbQaDERwCAL1YZ2A8XA1
	JXIAqXcjdWk4=
X-Google-Smtp-Source: AGHT+IFEI3kP7+/Q7bvMToK/ATcDsgPgakMUcVNY2RKc9MxdqMTNkkAmPrF1OGt99dCKrN5LxALVVw==
X-Received: by 2002:a05:6000:1885:b0:3a9:16f4:7a38 with SMTP id ffacd0b85a97d-3b34243febamr1912922f8f.2.1751540142628;
        Thu, 03 Jul 2025 03:55:42 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997e24bsm23412215e9.16.2025.07.03.03.55.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:55:41 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 00/69] accel: Preparatory cleanups for split-accel
Date: Thu,  3 Jul 2025 12:54:26 +0200
Message-ID: <20250703105540.67664-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Missing review: 23-24, 27

Since v4:
- Addressed Pierrick & Zhao review comments
- Added R-b tags

Few changes needed before being able to add the
split acceleration:

- few method docstring added
- remove pointless stubs
- propagate soon required AccelState argument
- try to reduce current_accel() uses
- move declarations AccelClass <-> AccelOpsClass
- display model name in 'info cpus'
- add 'info accel' command to QMP/HMP
- make accel_create_vcpu_thread() more generic
- introduce hwaccel_enabled()

I plan to send a PR once fully reviewed (v5 likely final, 69 is a good number).

Regards,

Phil.

Philippe Mathieu-Daudé (69):
  system/memory: Restrict eventfd dispatch_write() to emulators
  system/runstate: Document qemu_add_vm_change_state_handler()
  system/cpus: Defer memory layout changes until vCPUs are realized
  system/cpus: Assert interrupt handling is done with BQL locked
  accel: Keep reference to AccelOpsClass in AccelClass
  accel: Introduce AccelOpsClass::cpu_target_realize() hook
  accel/hvf: Add hvf_arch_cpu_realize() stubs
  accel/kvm: Remove kvm_init_cpu_signals() stub
  accel/kvm: Reduce kvm_create_vcpu() declaration scope
  accel: Propagate AccelState to AccelClass::init_machine()
  accel/kvm: Prefer local AccelState over global MachineState::accel
  accel/hvf: Re-use QOM allocated state
  accel/tcg: Prefer local AccelState over global current_accel()
  accel: Directly pass AccelState argument to AccelClass::has_memory()
  accel/kvm: Directly pass KVMState argument to do_kvm_create_vm()
  accel: Remove unused MachineState argument of AccelClass::setup_post()
  accel: Pass AccelState argument to gdbstub_supported_sstep_flags()
  accel: Move supports_guest_debug() declaration to AccelClass
  accel: Move cpus_are_resettable() declaration to AccelClass
  accel: Move cpu_common_[un]realize() declarations to AccelOpsClass
  accel/system: Convert pre_resume() from AccelOpsClass to AccelClass
  hw/core/machine: Display CPU model name in 'info cpus' command
  accel/tcg: Remove 'info opcount' and @x-query-opcount
  accel/tcg: Remove profiler leftover
  accel/tcg: Factor tcg_dump_flush_info() out
  accel/tcg: Factor tcg_dump_stats() out for re-use
  accel/tcg: Extract statistic related code to tcg-stats.c
  qapi: Move definitions related to accelerators in their own file
  accel/system: Introduce @x-accel-stats QMP command
  accel/system: Add 'info accel' on human monitor
  accel/tcg: Implement get_[vcpu]_stats()
  accel/hvf: Implement get_vcpu_stats()
  accel/hvf: Report missing com.apple.security.hypervisor entitlement
  accel/hvf: Restrict internal declarations
  accel/hvf: Move per-cpu method declarations to hvf-accel-ops.c
  accel/hvf: Move generic method declarations to hvf-all.c
  cpus: Document CPUState::vcpu_dirty field
  accel/hvf: Replace @dirty field by generic CPUState::vcpu_dirty field
  accel/nvmm: Replace @dirty field by generic CPUState::vcpu_dirty field
  accel/whpx: Replace @dirty field by generic CPUState::vcpu_dirty field
  accel/kvm: Remove kvm_cpu_synchronize_state() stub
  accel/system: Document cpu_synchronize_state()
  accel/system: Document cpu_synchronize_state_post_init/reset()
  accel/nvmm: Expose nvmm_enabled() to common code
  accel/whpx: Expose whpx_enabled() to common code
  accel/system: Introduce hwaccel_enabled() helper
  target/arm: Use generic hwaccel_enabled() to check 'host' cpu type
  accel/dummy: Extract 'dummy-cpus.h' header from 'system/cpus.h'
  accel/dummy: Factor dummy_thread_precreate() out
  accel/tcg: Factor tcg_vcpu_thread_precreate() out
  accel: Factor accel_create_vcpu_thread() out
  accel: Introduce AccelOpsClass::cpu_thread_routine handler
  accel/dummy: Convert to AccelOpsClass::cpu_thread_routine
  accel/tcg: Convert to AccelOpsClass::cpu_thread_routine
  accel/hvf: Convert to AccelOpsClass::cpu_thread_routine
  accel/kvm: Convert to AccelOpsClass::cpu_thread_routine
  accel/nvmm: Convert to AccelOpsClass::cpu_thread_routine
  accel/whpx: Convert to AccelOpsClass::cpu_thread_routine
  accel: Factor accel_cpu_realize() out
  accel: Pass old/new interrupt mask to handle_interrupt() handler
  accel: Expose and register generic_handle_interrupt()
  accel: Always register AccelOpsClass::kick_vcpu_thread() handler
  accel: Always register AccelOpsClass::get_elapsed_ticks() handler
  accel: Always register AccelOpsClass::get_virtual_clock() handler
  accel/tcg: Factor tcg_vcpu_init() out for re-use
  accel/tcg: Factor mttcg_cpu_exec() out for re-use
  accel/tcg: Factor rr_cpu_exec() out
  accel/tcg: Clear exit_request once in tcg_cpu_exec()
  accel/tcg: Unregister the RCU before exiting RR thread

 MAINTAINERS                       |   1 +
 qapi/accelerator.json             |  74 +++++++
 qapi/machine.json                 |  68 +-----
 qapi/qapi-schema.json             |   1 +
 accel/accel-internal.h            |   2 +
 accel/dummy-cpus.h                |  15 ++
 accel/kvm/kvm-cpus.h              |   1 -
 accel/tcg/internal-common.h       |   2 +
 accel/tcg/tcg-accel-ops-icount.h  |   2 +-
 accel/tcg/tcg-accel-ops-mttcg.h   |   4 +-
 accel/tcg/tcg-accel-ops.h         |   5 +-
 include/hw/core/cpu.h             |   3 +-
 include/qemu/accel.h              |  22 +-
 include/system/accel-ops.h        |  42 +++-
 include/system/cpus.h             |   5 -
 include/system/hvf.h              |  38 ----
 include/system/hvf_int.h          |  37 +++-
 include/system/hw_accel.h         |  34 ++-
 include/system/kvm.h              |   8 -
 include/system/nvmm.h             |  23 +-
 include/system/runstate.h         |  10 +
 include/system/whpx.h             |  27 +--
 target/i386/whpx/whpx-accel-ops.h |   1 -
 accel/accel-common.c              |  55 ++++-
 accel/accel-qmp.c                 |  34 +++
 accel/accel-system.c              |  35 ++-
 accel/dummy-cpus.c                |  11 +-
 accel/hvf/hvf-accel-ops.c         | 341 +++++-------------------------
 accel/hvf/hvf-all.c               | 281 ++++++++++++++++++++++--
 accel/kvm/kvm-accel-ops.c         |  25 +--
 accel/kvm/kvm-all.c               |  38 ++--
 accel/qtest/qtest.c               |  10 +-
 accel/stubs/kvm-stub.c            |   9 -
 accel/stubs/nvmm-stub.c           |  12 ++
 accel/stubs/whpx-stub.c           |  12 ++
 accel/tcg/monitor.c               | 212 +------------------
 accel/tcg/tcg-accel-ops-icount.c  |   8 +-
 accel/tcg/tcg-accel-ops-mttcg.c   |  28 +--
 accel/tcg/tcg-accel-ops-rr.c      |  40 ++--
 accel/tcg/tcg-accel-ops.c         |  44 ++--
 accel/tcg/tcg-all.c               |  20 +-
 accel/tcg/tcg-stats.c             | 206 ++++++++++++++++++
 accel/xen/xen-all.c               |  13 +-
 bsd-user/main.c                   |   2 +-
 gdbstub/system.c                  |   7 +-
 hw/core/machine-hmp-cmds.c        |   4 +-
 hw/core/machine-qmp-cmds.c        |   2 +
 linux-user/main.c                 |   2 +-
 system/cpus.c                     |  55 ++---
 system/memory.c                   |  11 +-
 system/physmem.c                  |   8 +
 target/arm/arm-qmp-cmds.c         |   5 +-
 target/arm/cpu.c                  |   5 +-
 target/arm/hvf/hvf.c              |  11 +-
 target/i386/hvf/hvf.c             |  11 +-
 target/i386/hvf/x86hvf.c          |   2 +-
 target/i386/nvmm/nvmm-accel-ops.c |  17 +-
 target/i386/nvmm/nvmm-all.c       |  29 +--
 target/i386/whpx/whpx-accel-ops.c |  18 +-
 target/i386/whpx/whpx-all.c       |  33 ++-
 tests/qtest/qmp-cmd-test.c        |   1 -
 accel/meson.build                 |   2 +-
 accel/stubs/meson.build           |   2 +
 accel/tcg/meson.build             |   1 +
 hmp-commands-info.hx              |  26 ++-
 qapi/meson.build                  |   1 +
 66 files changed, 1186 insertions(+), 928 deletions(-)
 create mode 100644 qapi/accelerator.json
 create mode 100644 accel/dummy-cpus.h
 create mode 100644 accel/accel-qmp.c
 create mode 100644 accel/stubs/nvmm-stub.c
 create mode 100644 accel/stubs/whpx-stub.c
 create mode 100644 accel/tcg/tcg-stats.c

-- 
2.49.0


