Return-Path: <kvm+bounces-36438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3AFA1AD5B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77DDD3A27C7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30FD1D5CF2;
	Thu, 23 Jan 2025 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d5xa9Qu5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051D21D5AB9
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675861; cv=none; b=O2BFtZ+fLryFdyPk3G0Tc9DummcguhRpBA5zTAnJ/g+UK/XWH/RcWDFXMloJ2k2I3s15xTJQl70AGNYv8a8puMN+nlSyPZj5cGWKijGeNxy+zEV55xE1vqkbtm1pwQhPYPU5GzY4u0Isfgdqc2rpmMA9Yahzv+QgwWE0vhUYdAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675861; c=relaxed/simple;
	bh=tFNPptsT0HE+ZkqpvwTKnM5+lqvSN1DZbBVMCFQqpzo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qFh8MoeKVVGKWs8NJ7yiw11b8kSlIFSr6MkQSoxg4u7bEU037DbIazACJNRJrF4pwO+jOIWzHSlUp0pFpAIQ/viG1H/u+Y81ps5be3UcG8ej0Q8JsAbrBzFE0dRdPGMbA4VcJVidSzbt0iuk9U5sfPQ02dsUq5HTldf8vC+VTGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d5xa9Qu5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436a39e4891so10244685e9.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675857; x=1738280657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SrJqTercMM7Oiv7TI6NgScSjNQ/Q43/m4EWNljCwQJg=;
        b=d5xa9Qu5eulQEnWK22/SiSfws6JFU5Df8yc+HZDAHAs0ax+kuKwhBwMeLk/SVjZipA
         G9+u4sC0a9R6cwNFJcoYO8ukeNAOP5nE/Pn3MX3AR0kq17b+5QdVeLqWnjkDnF8lzGGI
         FHD6Z886iLr7oggyWy1sCoEaP33DobW//A33D2olU9nrjXHWjj9AwTHcnUfNU5rXowuJ
         PHrBL5YUya/ZutqJPzn1jOzA9yJDFBvbhUX2PaWXr823NXxgPOUXQhDMw+tvgz9lJ91q
         7gdVB0Cl5TbCl0JIH0rHK35vBU50pal2JhIRRUtHDBOzA8M/AHWyu5SG1MrKK3LqxcP7
         DcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675857; x=1738280657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SrJqTercMM7Oiv7TI6NgScSjNQ/Q43/m4EWNljCwQJg=;
        b=k7XkzSp76nOC/+Ud/8iiwLxDPIp5OKDB5l8ITwtorMxt+dr1nJ1rZg3nW99+jDMrvR
         FeBuzXkE55gxOCC1BGW4YX7k+6u5LNQo88J1TNjj1gr6v02fc0SKuA6f9G06f82vCr5j
         ZVXaSn7e8wLK6hk+xvc9BN3pLDcdjbMQxdcUsncoUISVoc+RGnaBqzNu6j89TW5/msH8
         5+Adp04SPjzqNRJmAIOXIRuWc9zMJszVjKlqk1zpwJyFs9a53gorI+eiAFu6aU7h6h9+
         L5W/OtAFUtaqIs6AusCm5TMKTCaeZK+EHDgKfzwgypJdxYG2HMTK/6l5iUYtm4Rsm+t3
         euGw==
X-Forwarded-Encrypted: i=1; AJvYcCU322eiaLx3fuz9GWxrbnhUm7Pr/f0fGiw23dF3Ej/pVdZUWKJOPmd3QCphAgx/AzRg/84=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBRVHystPW7L5zVTshOVuJxwPQzgtTeGDi0qUdhtGqvLTw3aMR
	aAtbqzZkIgmZdvhGpz/CqmLLnLnRBEnQzi3fFgBgUEDlnB97ZX6kngGgqpr2bQujypHhKmWNlhX
	sBtg=
X-Gm-Gg: ASbGncuZUUZAYadXYGQDlZrWNKnWHLIZhp/3NaTCsSbBMgRD3Mp3bOYxQhCtq2k59kd
	ye10M2ilcrJJCsmjXTrJAq/W1g0NvKBOFqv/AQlCuGJWE+GJ9LXBeS+Rkqnh8B64uQDpqWFyQjp
	GiqWTtTLU20aqtBxvoNkc1HXZOw0uqqVwr0PmDtmzFwCgotf+PWzWm2zv0JDmi9AxHcmCsvGeEm
	SpqCeiYNia1s9sx0IdjXHyHdFD24IMcbUqXcZ/K1nhbRHXGw95UMz9ikv4KQhukcDuHZbfN7+wR
	BpsaIVNlgTithmCIZqiCV9csNWTUTB3zJ3jtqcZfkPSVF+OYsfz2ompsCOzm366KSA==
X-Google-Smtp-Source: AGHT+IGBiB8E0eTSoI28+V9cp1gWnvQIF0NcnM5MrTMqS5rNZ7M1PFDJt5j8Or2lR2bn/A8RFfyqaQ==
X-Received: by 2002:a05:600c:a09:b0:435:9ed3:5688 with SMTP id 5b1f17b1804b1-438913f86dcmr267594425e9.18.1737675857123;
        Thu, 23 Jan 2025 15:44:17 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd54c098sm6544235e9.31.2025.01.23.15.44.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:16 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 00/20] accel: Simplify cpu-target.c (omnibus)
Date: Fri, 24 Jan 2025 00:43:54 +0100
Message-ID: <20250123234415.59850-1-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Yet another cleanup series before respining the "extract TCG
fields from CPUState" series. Before that, we try to clarify
a bit the code around CPU creation. Target specific code is
reduced further. Some intermixed User/System is separated,
making maintenance simpler IMHO. Since my local branch is
quite big, I tried to group here all the generic patches.

Regards,

Phil.

Based-on: <20250123215609.30432-1-philmd@linaro.org>
  "target/ppc: Move TCG code from excp_helper.c to tcg-excp_helper.c"

Philippe Mathieu-Daudé (20):
  qemu/compiler: Absorb 'clang-tsa.h'
  user: Extract common MMAP API to 'user/mmap.h'
  gdbstub: Check for TCG before calling tb_flush()
  cpus: Cache CPUClass early in instance_init() handler
  cpus: Keep default fields initialization in cpu_common_initfn()
  accel/kvm: Remove unused 'system/cpus.h' header in kvm-cpus.h
  accel/tcg: Build tcg_flags helpers as common code
  accel/tcg: Restrict tlb_init() / destroy() to TCG
  accel/tcg: Restrict 'icount_align_option' global to TCG
  accel/tcg: Rename 'hw/core/tcg-cpu-ops.h' -> 'accel/tcg/cpu-ops.h'
  accel: Rename 'hw/core/accel-cpu.h' -> 'accel/accel-cpu-target.h'
  accel/accel-cpu-target.h: Include missing 'cpu.h' header
  accel: Forward-declare AccelOpsClass in 'qemu/typedefs.h'
  accel/tcg: Move cpu_memory_rw_debug() user implementation to
    user-exec.c
  cpus: Fix style in cpu-target.c
  cpus: Restrict cpu_common_post_load() code to TCG
  cpus: Have cpu_class_init_props() per user / system emulation
  cpus: Have cpu_exec_initfn() per user / system emulation
  cpus: Register VMState per user / system emulation
  cpus: Build cpu_exec_[un]realizefn() methods once

 MAINTAINERS                                   |   4 +-
 accel/kvm/kvm-cpus.h                          |   2 -
 accel/tcg/internal-common.h                   |  13 +
 bsd-user/qemu.h                               |  13 +-
 .../accel-cpu.h => accel/accel-cpu-target.h}  |   7 +-
 .../tcg-cpu-ops.h => accel/tcg/cpu-ops.h}     |   0
 include/block/block_int-common.h              |   1 -
 include/block/graph-lock.h                    |   2 -
 include/exec/exec-all.h                       |  16 -
 include/exec/page-protection.h                |   2 -
 include/hw/core/cpu.h                         |   2 +
 include/qemu/clang-tsa.h                      | 114 -------
 include/qemu/compiler.h                       |  87 +++++
 include/qemu/thread.h                         |   1 -
 include/qemu/typedefs.h                       |   1 +
 include/system/accel-ops.h                    |   1 -
 include/system/cpus.h                         |   4 -
 include/user/mmap.h                           |  32 ++
 linux-user/user-mmap.h                        |  19 +-
 accel/accel-system.c                          |   1 +
 accel/accel-target.c                          |   2 +-
 accel/hvf/hvf-accel-ops.c                     |   1 +
 accel/kvm/kvm-accel-ops.c                     |   1 +
 accel/qtest/qtest.c                           |   1 +
 accel/stubs/tcg-stub.c                        |   4 -
 accel/tcg/cpu-exec-common.c                   |  34 +-
 accel/tcg/cpu-exec.c                          |  37 +--
 accel/tcg/cputlb.c                            |   2 +-
 accel/tcg/icount-common.c                     |   2 +
 accel/tcg/monitor.c                           |   1 -
 accel/tcg/tcg-accel-ops.c                     |   1 +
 accel/tcg/translate-all.c                     |   3 +-
 accel/tcg/user-exec-stub.c                    |  11 +
 accel/tcg/user-exec.c                         |  94 +++++-
 accel/tcg/watchpoint.c                        |   2 +-
 accel/xen/xen-all.c                           |   1 +
 block/create.c                                |   1 -
 bsd-user/signal.c                             |   2 +-
 cpu-common.c                                  |   1 -
 cpu-target.c                                  | 314 +-----------------
 gdbstub/system.c                              |   6 +-
 hw/core/cpu-common.c                          |  31 ++
 hw/core/cpu-system.c                          | 170 ++++++++++
 hw/core/cpu-user.c                            |  44 +++
 hw/mips/jazz.c                                |   2 +-
 linux-user/signal.c                           |   2 +-
 system/cpus.c                                 |   1 +
 system/globals.c                              |   1 -
 system/physmem.c                              |   2 +-
 target/alpha/cpu.c                            |   2 +-
 target/arm/cpu.c                              |   2 +-
 target/arm/tcg/cpu-v7m.c                      |   2 +-
 target/arm/tcg/cpu32.c                        |   2 +-
 target/arm/tcg/mte_helper.c                   |   2 +-
 target/arm/tcg/sve_helper.c                   |   2 +-
 target/avr/cpu.c                              |   2 +-
 target/avr/helper.c                           |   2 +-
 target/hexagon/cpu.c                          |   2 +-
 target/hppa/cpu.c                             |   2 +-
 target/i386/hvf/hvf-cpu.c                     |   2 +-
 target/i386/kvm/kvm-cpu.c                     |   2 +-
 target/i386/nvmm/nvmm-accel-ops.c             |   1 +
 target/i386/tcg/tcg-cpu.c                     |   4 +-
 target/i386/whpx/whpx-accel-ops.c             |   1 +
 target/loongarch/cpu.c                        |   2 +-
 target/m68k/cpu.c                             |   2 +-
 target/microblaze/cpu.c                       |   2 +-
 target/mips/cpu.c                             |   2 +-
 target/openrisc/cpu.c                         |   2 +-
 target/ppc/cpu_init.c                         |   2 +-
 target/ppc/kvm.c                              |   2 +-
 target/riscv/kvm/kvm-cpu.c                    |   2 +-
 target/riscv/tcg/tcg-cpu.c                    |   4 +-
 target/rx/cpu.c                               |   2 +-
 target/s390x/cpu.c                            |   2 +-
 target/s390x/tcg/mem_helper.c                 |   2 +-
 target/sh4/cpu.c                              |   2 +-
 target/sparc/cpu.c                            |   2 +-
 target/tricore/cpu.c                          |   2 +-
 target/xtensa/cpu.c                           |   2 +-
 tests/unit/test-bdrv-drain.c                  |   1 -
 tests/unit/test-block-iothread.c              |   1 -
 util/qemu-thread-posix.c                      |   1 -
 hw/core/meson.build                           |   5 +-
 84 files changed, 590 insertions(+), 578 deletions(-)
 rename include/{hw/core/accel-cpu.h => accel/accel-cpu-target.h} (92%)
 rename include/{hw/core/tcg-cpu-ops.h => accel/tcg/cpu-ops.h} (100%)
 delete mode 100644 include/qemu/clang-tsa.h
 create mode 100644 include/user/mmap.h
 create mode 100644 hw/core/cpu-user.c

-- 
2.47.1


