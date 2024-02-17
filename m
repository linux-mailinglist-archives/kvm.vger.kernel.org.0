Return-Path: <kvm+bounces-8919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 405D3858C11
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB873282FB7
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 00:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7519171D1;
	Sat, 17 Feb 2024 00:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OPrkRoIE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE0614AB2
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131496; cv=none; b=c9Ue5OGf0nTng6L054JVaNdxFnCTEIB7X2+Ml5Ya8m0+lIuqQRNVAs3NRCYCrwhNRRWmFujTqQEdJ3PXQZXOfQ/+RK1zp1yesVFc80ZxSMuBxWlf/9A79brUYE1szKM6g43QzwZTmAYte6lq8RwNf+DPUIlzfma8Ytv6zE7TNRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131496; c=relaxed/simple;
	bh=T/rm/p4zZLrZ8lUQrOICPzaapq/vW9EgZQVSXWVG5rw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=H8py7UR94jh0txV8PJ3r2VOqUKkhrmiXoMBU0FCeDGds0Nv8fseUsNeVwa/X9HSwY66vm5B7ZPadUxGU7bSm2bthH7NxbvE94cEx8Urr22mZg0/CSpFHFrvjqI7eGrHT4pKffGNRRTfWqbz45xl+vFbaMaAdnLQMvh5O3/pl5uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OPrkRoIE; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-59d489e8d68so483899eaf.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131494; x=1708736294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IzVo2l1UeODXlFr9ZspobMSeOz6FqRsDzZRtwqz0aks=;
        b=OPrkRoIEKkCbQ4YuvXA/KDHVjR4g1oj2QRLXipeRksevCbLgIO8J+1WlN6T4pSgHYZ
         Vi5gZH+89WqV3vpAHcshLk+4WPfIL5JHvq9c8Lkn2vrVDswj7d2Mzg777l276+8f02+h
         CU6JPhzNg1Odohqi3nnEA/lPJjbKdzhn4gdmweF2UyeFFdtvpwjfiAo2LWp/H9sWy7GK
         1S7PlaO2dqils+OSU6wOKKkgClBy2xxr2oyglgKUcbTajrX1SmpmwIzc4JkaXeciUByZ
         BSPc9GBZw/q6CU8UIMIGh5s+5EDQ/7IKSyAyYj/Dtn+eAjWaAQUJGVuatk57oqfD/VL0
         hQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131494; x=1708736294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IzVo2l1UeODXlFr9ZspobMSeOz6FqRsDzZRtwqz0aks=;
        b=Joc5MVAmzBtGDOgB8Pxt+ruyYCaLBEUQ6TJNn2cb47vQVR5lBh1eUUsDO87JFJpMtx
         glSUbM+llDeWfXg/ODNVeUJb6DfI8DT6StKY9TSnorA97heVGrTLp8CLoQp0zr646ESp
         0McO2eOvM3r8BDljg7Uf3k5Ih6uy4pIgpPxfiAsr8WctwizV/LP3pTDOAG/yWlQ0TnFK
         9KBgx3VkwfwyBYe7PmwwePJ/M/dlgGgZiJh1k1b58wcryKCMsLMkDpfr9P3NjN7+lzW9
         6nrDXKjw7JyvNYmgmIDPO90UI94QXy5r4XzBUEvZAnTYCYMoPYqKs27c4h88iPLyeUPX
         YFAA==
X-Forwarded-Encrypted: i=1; AJvYcCW0QJiMt8M3mX4/qGRMrw8eA6aqqUrPVHUz1rggFVxQ9zX3cqTfWiiXRZmyh8xmc6lg6iI66o2eykgASyZN3lx76s1i
X-Gm-Message-State: AOJu0Yzydg8L/dTI6N9VAqA7xt1qxoJaRgEJXpZVxWS1snykSxA0iu7J
	4tYbRxq/77dVXwXb4p5lowPQQDDHOxNQKK6yKD96DbsbknJ6TQgs+SrqcBFakh0=
X-Google-Smtp-Source: AGHT+IF2qj5VG2aWGKmy+Z/F9xqjxzKMZfdoF+ZXES4kZiPGRVxWB31P4WLI9MkML3OCwmckEUxPAA==
X-Received: by 2002:a05:6358:659b:b0:178:fd13:d6e4 with SMTP id x27-20020a056358659b00b00178fd13d6e4mr7493295rwh.25.1708131493668;
        Fri, 16 Feb 2024 16:58:13 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:13 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 00/20] Add Counter delegation ISA extension support 
Date: Fri, 16 Feb 2024 16:57:18 -0800
Message-Id: <20240217005738.3744121-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds the counter delegation extension support. It is based on
very early PoC work done by Kevin Xue and mostly rewritten after that.
The counter delegation ISA extension(Smcdeleg/Ssccfg) actually depends
on multiple ISA extensions.

1. S[m|s]csrind : The indirect CSR extension[1] which defines additional
   5 ([M|S|VS]IREG2-[M|S|VS]IREG6) register to address size limitation of
   RISC-V CSR address space.
2. Smstateen: The stateen bit[60] controls the access to the registers
   indirectly via the above indirect registers.
3. Smcdeleg/Ssccfg: The counter delegation extensions[2]

The counter delegation extension allows Supervisor mode to program the
hpmevent and hpmcounters directly without needing the assistance from the
M-mode via SBI calls. This results in a faster perf profiling and very
few traps. This extension also introduces a scountinhibit CSR which allows
to stop/start any counter directly from the S-mode. As the counter
delegation extension potentially can have more than 100 CSRs, the specification
leverages the indirect CSR extension to save the precious CSR address range.

Due to the dependency of these extensions, the following extensions must be
enabled in qemu to use the counter delegation feature in S-mode.

"smstateen=true,sscofpmf=true,ssccfg=true,smcdeleg=true,smcsrind=true,sscsrind=true"

When we access the counters directly in S-mode, we also need to solve the
following problems.

1. Event to counter mapping
2. Event encoding discovery

The RISC-V ISA doesn't define any standard either for event encoding or the
event to counter mapping rules.

Until now, the SBI PMU implementation relies on device tree binding[3] to
discover the event to counter mapping in RISC-V platform in the firmware. The
SBI PMU specification[4] defines event encoding for standard perf events as well.
Thus, the kernel can query the appropriate counter for an given event from the
firmware.

However, the kernel doesn't need any firmware interaction for hardware
counters if counter delegation is available in the hardware. Thus, the driver
needs to discover the above mappings/encodings by itself without any assistance
from firmware. One of the options considered was to extend the PMU DT parsing
support to kernel as well. However, that requires additional support in ACPI
based system. It also needs more infrastructure in the virtualization as well.

This patch series solves the above problem #1 by extending the perf tool in a
way so that event json file can specify the counter constraints of each event
and that can be passed to the driver to choose the best counter for a given
event. The perf stat metric series[5] from Weilin already extend the perf tool
to parse "Counter" property to specify the hardware counter restriction.
I have included the patch from Weilin in this series for verification purposes
only. I will rebase as that series evolves.

This series extends that support by converting comma separated string to a
bitmap. The counter constraint bitmap is passed to the perf driver via
newly introduced "counterid_mask" property set in "config2". Even though, this
is a generic perf tool change, this should not affect any other architecture
if "counterid_mask" is not mapped. 

@Weilin: Please let me know if there is a better way to solve the problem I
described. 

The problem #2 is solved by defining a architecture specific override function
that will replace the perf standard event encoding with an encoding specified
in the json file with the same event name. The alternate solution considered
was to specify the encodings in the driver. However, these encodings are vendor
specific in absence of an ISA guidelines and will become unmanageable with
so many RISC-V vendors touching the driver for their encoding. 

The override is only required when counter delegation is available in the
platform which is detected at the runtime. The SBI PMU (current implementation)
doesn't require any override as it defines the standard event encoding. The
hwprobe syscall defined for RISC-V is used for this detection in this series.
A sysfs based property can be explored to do the same but we may require
hwprobe in future given the churn of extensions in RISC-V. That's why, I went
with hwprobe. Let me know if anybody thinks that's a bad idea. 

The perf tool also hook allows RISC-V ISA platform vendors to define their
encoding for any standard perf or ISA event. I have tried to cover all the use
cases that I am aware of (stat, record, top). Please let me know if I have
missed any particular use case where architecture hook must be invoked. I am
also open to any other idea to solve the above said problem.

PATCH organization:
PATCH 1 is from the perf metric series[5]
PATCH 2-5 defines and implements the indirect CSR extension.
PATCH 6-10 defines the other required ISA extensions.
PATCH 11 just an overall restructure of the RISC-V PMU driver.
PATCH 12-14 implements the counter delegation extension and new perf tool
plumbings to solve #1 and #2.
PATCH 15-16 improves the perf tool support to solve #1 and #2.
PATCH 17 adds a perf json file for qemu virt machine.
PATCH 18-20 adds hwprobe mechanism to enable perf to detect if platform supports
delegation extensions.

There is no change in process to run perf stat/record and will continue to work
as it is as long as the relevant extensions have been enabled in Qemu.

However, the perf tool needs to be recompiled with as it requires new kenrel
headers.

The Qemu patches can be found here:
https://github.com/atishp04/qemu/tree/counter_delegation_rfc

The opensbi patch can be found here:
https://github.com/atishp04/opensbi/tree/counter_delegation_v1

The Linux kernel patches can be found here:
https://github.com/atishp04/linux/tree/counter_delegation_rfc

[1] https://github.com/riscv/riscv-indirect-csr-access
[2] https://github.com/riscv/riscv-smcdeleg-ssccfg
[3] https://www.kernel.org/doc/Documentation/devicetree/bindings/perf/riscv%2Cpmu.yaml
[4] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-pmu.adoc
[5] https://lore.kernel.org/all/20240209031441.943012-4-weilin.wang@intel.com/

Atish Patra (17):
RISC-V: Add Sxcsrind ISA extension definition and parsing
dt-bindings: riscv: add Sxcsrind ISA extension description
RISC-V: Define indirect CSR access helpers
RISC-V: Add Ssccfg ISA extension definition and parsing
dt-bindings: riscv: add Ssccfg ISA extension description
RISC-V: Add Smcntrpmf extension parsing
dt-bindings: riscv: add Smcntrpmf ISA extension description
RISC-V: perf: Restructure the SBI PMU code
RISC-V: perf: Modify the counter discovery mechanism
RISC-V: perf: Implement supervisor counter delegation support
RISC-V: perf: Use config2 for event to counter mapping
tools/perf: Add arch hooks to override perf standard events
tools/perf: Pass the Counter constraint values in the pmu events
perf: Add json file for virt machine supported events
tools arch uapi: Sync the uinstd.h header file for RISC-V
RISC-V: Add hwprobe support for Counter delegation extensions
tools/perf: Detect if platform supports counter delegation

Kaiwen Xue (2):
RISC-V: Add Sxcsrind ISA extension CSR definitions
RISC-V: Add Sscfg extension CSR definition

Weilin Wang (1):
perf pmu-events: Add functions in jevent.py to parse counter and event
info for hardware aware grouping

Documentation/arch/riscv/hwprobe.rst          |  10 +
.../devicetree/bindings/riscv/extensions.yaml |  34 +
MAINTAINERS                                   |   4 +-
arch/riscv/include/asm/csr.h                  |  47 ++
arch/riscv/include/asm/csr_ind.h              |  42 ++
arch/riscv/include/asm/hwcap.h                |   5 +
arch/riscv/include/asm/sbi.h                  |   2 +-
arch/riscv/include/uapi/asm/hwprobe.h         |   4 +
arch/riscv/kernel/cpufeature.c                |   5 +
arch/riscv/kernel/sys_hwprobe.c               |   3 +
arch/riscv/kvm/vcpu_pmu.c                     |   2 +-
drivers/perf/Kconfig                          |  16 +-
drivers/perf/Makefile                         |   4 +-
.../perf/{riscv_pmu.c => riscv_pmu_common.c}  |   0
.../perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} | 654 ++++++++++++++----
include/linux/perf/riscv_pmu.h                |  13 +-
tools/arch/riscv/include/uapi/asm/unistd.h    |  14 +-
tools/perf/arch/riscv/util/Build              |   2 +
tools/perf/arch/riscv/util/evlist.c           |  60 ++
tools/perf/arch/riscv/util/pmu.c              |  41 ++
tools/perf/arch/riscv/util/pmu.h              |  11 +
tools/perf/builtin-record.c                   |   3 +
tools/perf/builtin-stat.c                     |   2 +
tools/perf/builtin-top.c                      |   3 +
.../pmu-events/arch/riscv/arch-standard.json  |  10 +
tools/perf/pmu-events/arch/riscv/mapfile.csv  |   1 +
.../pmu-events/arch/riscv/qemu/virt/cpu.json  |  30 +
.../arch/riscv/qemu/virt/firmware.json        |  68 ++
tools/perf/pmu-events/jevents.py              | 186 ++++-
tools/perf/pmu-events/pmu-events.h            |  25 +-
tools/perf/util/evlist.c                      |   6 +
tools/perf/util/evlist.h                      |   6 +
32 files changed, 1167 insertions(+), 146 deletions(-)
create mode 100644 arch/riscv/include/asm/csr_ind.h
rename drivers/perf/{riscv_pmu.c => riscv_pmu_common.c} (100%)
rename drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c} (61%)
create mode 100644 tools/perf/arch/riscv/util/evlist.c
create mode 100644 tools/perf/arch/riscv/util/pmu.c
create mode 100644 tools/perf/arch/riscv/util/pmu.h
create mode 100644 tools/perf/pmu-events/arch/riscv/arch-standard.json
create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/cpu.json
create mode 100644 tools/perf/pmu-events/arch/riscv/qemu/virt/firmware.json

--
2.34.1


