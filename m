Return-Path: <kvm+bounces-37431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AD7A2A20E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D883162BC6
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62369225786;
	Thu,  6 Feb 2025 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="J4bfwaBU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFBC224AFD
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826598; cv=none; b=lKjmqQjZ1myq+ZRPTyfrd9FOAFqbKSsz8bL6EMO5lNVaXvgsP6xB/YJNkA+ticpgpU3i/vnhuWH76H9H1AZBx/3vZUCsCg75sZ9ejKvyedNQ7h/AqkQAv3D5LfIyj9VNV/pXjUGiSosGTfxzTQXHUt2FRlPGSiIk0vvDx+MSVlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826598; c=relaxed/simple;
	bh=bdbTzm2sfqN76SC74i+7NJCPhMid7XD0dN+qvDxxi4w=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZObx2BWv+LqgywbNUEIscGUxN4UqZnJlq8FLazbe2hh3CkcwRLb/nHuFwI94IdpWiHrO9wu6oOwvkxXsBBiYV9PvrmuTkALtCxS0jU61KPWqK24lYsxIRMGO6Rgt4xBLsJ6ESddgFVLJOmJc6mMXzMiUwQh5zAtmqsXY5RpQJB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=J4bfwaBU; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2f9d3d0f55dso800772a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826595; x=1739431395; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XcfIWddzFd8yj6o0Xr4QawJxvmjYCrHgBJ9/YF34lAs=;
        b=J4bfwaBULt3qZXDAZPXQLzXFUg5zCENLhy2InicTpxxN495wowo7i79yvLtyLoMtZf
         mPG9gBtHi8FK5P3iw9wgs5c39QMPzeXba0ZYeNLKP6y79a504GCtmLic8TAmVT4Y5IjY
         VvBBMk8M/oEvkHE4l60EAIJj3bh24D/fJPD/vQiOh3JHx4IyxsRwHf8KY1Aw+7f02hVu
         PbKP/sPDyA/DrUx7CWFG51mAi8LOtP4C6tQqGlEw+xpsEb2sYTH3+DJf8T0dUtPSsEIl
         tCqMwzuUDugfD6BbTQUHD5NiSFSc+FqB9PMGKPG42CBFynsnq60FeuN2F8aU6I5fEHz5
         9Szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826595; x=1739431395;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XcfIWddzFd8yj6o0Xr4QawJxvmjYCrHgBJ9/YF34lAs=;
        b=v2FvA/6IDQuiwsqclP5U6p82jxoghuhxHSJp3irOyW8RMX42jNs2G2DmL3PNI9mCwu
         E3gOpq+TOMu+iFA4vl6YLu9Z4NcqO6RVB2qntYJvtzhAwOf/gBXKGSpNMWUMWy1r5wAe
         R4LIAbalr6I32QBmBivQLlRtbK72nSTZrz0yRBu13FvQmX67l1zdm90NP848ZyNffTLI
         N9ZOccYNB++GhIyMFJHDA2gWb50lh3267ETT9xWnC+Vc3NxKF+I9pNllJdkwx7SG0wm5
         FKn+4I8Xa9JHdjev6+0CjpXdPzZGlqm+5Ajr5GAo8WFvpozC0kBNJjHdpJH76q2AwMAM
         kDWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgdI+M+zhdv33NIFv65iJCdMqjr8z7QnbFbHkRK+5v6wRJyv9C5rddsJ3Ina7RtraYTEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzIV20WkBmN7BdCAQboXDXaevRLSWNXtPjoZeh+ovFz/N1A00N
	MqtDVsCRCSqiwErDs5XQHcajW+ra7dnbhZjyroSMW0k+KMvRO4roBnLHf7zIxto=
X-Gm-Gg: ASbGnctmZ5cVjff3M1PuDRr2/P2KoUt9R9F9XmAODW+p9DNRxyWFqnKtQgAMK1qTUxR
	prWGT6RAhlv4WSYCaz1Ke5tFAUW0gu5XuP9CT4WP8szTkSMt9Jwp0Lv7Z24MdKiOc6CMOhnYl05
	uresqGhvxtAO1ZTsInFC9zaU1pmbdNzObG3GoPS+Yh+Spoq7kaCVB5SM7Cco10mDhgsMhETthWo
	x2wFAD+061cVMoeUWLG/96CyUlugjl7KgquSDRTtZRFtKtersY62Q5kI5fFMzpOyBB4MYA+bRsj
	ZcKGb50urO3nyJvks4TZJ/6uDR9z
X-Google-Smtp-Source: AGHT+IGo0IO4yjjuiyGHyaAJ0POQANwu/jLlGwAMMHLN1KwC0wmsSQAnJSPQ5JuyqcISwOKowqqUIA==
X-Received: by 2002:a17:90b:268b:b0:2ee:d63f:d8f with SMTP id 98e67ed59e1d1-2f9e0762f8amr9118109a91.13.1738826595250;
        Wed, 05 Feb 2025 23:23:15 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:14 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v4 00/21] Add Counter delegation ISA extension support
Date: Wed, 05 Feb 2025 23:23:05 -0800
Message-Id: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFljpGcC/23O0YrCMBAF0F+RPJuSmSRN3Kf9j0WWNhltQBtJu
 sFF+u/GiiDSxzvMPTM3likFyuxrc2OJSsghjjWo7Ya5oRuPxIOvmaFAJQxo7uLfOFH69XSiYzf
 Vdd6i7SQerNs5x2rxkugQrgv6s695CHmK6X+5UeAxfXIIRghtpG2kUQoQOPAq5uHynUKJOYyuc
 fHMHkbBV08LALX2RkEuuO07o5zvrYZ+RZFvCppVRValVXanvCFovf5Q5nm+A0nshfA1AQAA
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, Kaiwen Xue <kaiwenx@rivosinc.com>, 
 Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

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
or Virt machine users can just "max" cpu instead.

When we access the counters directly in S-mode, we also need to solve the
following problems.

1. Event to counter mapping
2. Event encoding discovery

The RISC-V ISA doesn't define any standard either for event encoding or the
event to counter mapping rules. Until now, the SBI PMU implementation relies
on device tree binding[3] to discover the event to counter mapping in RISC-V
platform in the firmware. The SBI PMU specification[4] defines event encoding
for standard perf events as well. Thus, the kernel can query the appropriate
counter for an given event from the firmware.

However, the kernel doesn't need any firmware interaction for hardware
counters if counter delegation is available in the hardware. Thus, the driver
needs to discover the above mappings/encodings by itself without any assistance
from firmware.

Solution to Problem #1:
This patch series solves the above problem #1 by extending the perf tool in a
way so that event json file can specify the counter constraints of each event
and that can be passed to the driver to choose the best counter for a given
event. The perf stat metric series[5] from Weilin already extend the perf tool
to parse "Counter" property to specify the hardware counter restriction.
As that series was not revised in a while, I have rebased it and included in
this series. I can only include the necessary parts from that patch required
for this series if required. 

This series extends that support by converting comma separated string to a
bitmap. The counter constraint bitmap is passed to the perf driver via
newly introduced "counterid_mask" property set in "config2".
However, it results in the following event string which has repeated information
about the counters both in list and bitmask format. I am not sure how I can pass
the list information to the driver directly. That's why I added a
counterid_mask property.

Additionaly, the PATCH5 in [5] parses the bitmask information from the
string and puts it into the metric group structure. We can just convert it in
python easily and pass it to the metric group instead. The PATCH19 does exactly
that and sets the counterid_mask property.

@Weilin @Ian : Please let me know if there is a better way to solve the problem I
described. 

Due to the new counterid_mask property, the layout in empty-pmu-events.c got
changed which is patched in PATCH 20 based on existing script.

Possible solutions to Problem #2:

1. Extend the PMU DT parsing support to kernel as well. However, that requires
additional support in ACPI based system. It also needs more infrastructure in
the virtualization as well.

2. Rename perf legacy events to riscv specific names. This will require users to
use perf differently than other ISAs which is not ideal.

3. Define a architecture specific override function for legacy events. Earlier
RFC version did that but it is not preferred as arch specific behavior in perf
tool has other ramifications on the tests.

4. Ian graciously helped and sent a generic fix[6] for #3 that prefers json
over legacy encoding. Unfortunately, it had some regressions and the discussions
are ongoing if it is a viable solution.

5. Specify the encodings in the driver. There were earlier concerns of managing
these in the driver as these encodings are vendor specific in absence of an ISA
guidelines. However, we also need to support counter virtualization and legacy
event users (without perf tool) as described in [7]. That's why, this series
adapts this solution similar to other ISAs. The vendors can define their pmu
event encoding and event to counter mapping in the driver.

Note: This solution is still compatible with solution #4 by Ian. It gives vendors
flexibility to define legacy event encoding in either the driver or json file
if Ian's series [6] is merged. If we can get rid of the legacy events in the
future, we can just rely on the json encodings. I have not added a json file for
qemu as I have not included Ian's patches in this series. But I have verified them
with a virt machine specific json file.

The Qemu patches can be found here:
https://github.com/atishp04/qemu/tree/b4/counter_delegation_v4

The Linux kernel patches can be found here:
https://github.com/atishp04/linux/tree/b4/counter_delegation_v4

[1] https://github.com/riscv/riscv-indirect-csr-access
[2] https://github.com/riscv/riscv-smcdeleg-ssccfg
[3] https://www.kernel.org/doc/Documentation/devicetree/bindings/perf/riscv%2Cpmu.yaml
[4] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-pmu.adoc
[5] https://lore.kernel.org/lkml/20240412210756.309828-1-weilin.wang@intel.com/
[6] https://lore.kernel.org/lkml/20250109222109.567031-1-irogers@google.com/
[7] https://lore.kernel.org/lkml/20241026121758.143259-1-irogers@google.com/T/#m653a6b98919a365a361a698032502bd26af9f6ba

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
Changes in v4:
- Added ISA depedancies as per dt schema instead of description. 
- Fixed few compilation issues due to patch reordering in v3.
- Link to v3: https://lore.kernel.org/r/20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com

Changes in v3:
- Fixed the dtb binding check failures.
- Inlcuded the fix reported by Rajnesh Kanwal for guest counter overflow.
- Rearranged the overflow handling more efficiently for better modularity.
- Link to v2: https://lore.kernel.org/r/20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com

Changes in v2:
- Dropped architecture specific overrides for event encoding.
- Dropped hwprobe bits.
- Added a vendor specific event encoding table to support vendor specific event
  encoding and counter mapping.
- Fixed few bugs and cleanup.
- Link to v1: https://lore.kernel.org/r/20240217005738.3744121-1-atishp@rivosinc.com

---
Atish Patra (17):
      RISC-V: Add Sxcsrind ISA extension definition and parsing
      dt-bindings: riscv: add Sxcsrind ISA extension description
      RISC-V: Define indirect CSR access helpers
      RISC-V: Add Smcntrpmf extension parsing
      dt-bindings: riscv: add Smcntrpmf ISA extension description
      RISC-V: Add Ssccfg ISA extension definition and parsing
      dt-bindings: riscv: add Counter delegation ISA extensions description
      RISC-V: perf: Restructure the SBI PMU code
      RISC-V: perf: Modify the counter discovery mechanism
      RISC-V: perf: Add a mechanism to defined legacy event encoding
      RISC-V: perf: Implement supervisor counter delegation support
      RISC-V: perf: Use config2/vendor table for event to counter mapping
      RISC-V: perf: Add legacy event encodings via sysfs
      RISC-V: perf: Add Qemu virt machine events
      tools/perf: Support event code for arch standard events
      tools/perf: Pass the Counter constraint values in the pmu events
      Sync empty-pmu-events.c with autogenerated one

Charlie Jenkins (1):
      RISC-V: perf: Skip PMU SBI extension when not implemented

Kaiwen Xue (2):
      RISC-V: Add Sxcsrind ISA extension CSR definitions
      RISC-V: Add Sscfg extension CSR definition

Weilin Wang (1):
      perf pmu-events: Add functions in jevent.py to parse counter and event info for hardware aware grouping

 .../devicetree/bindings/riscv/extensions.yaml      |  67 ++
 MAINTAINERS                                        |   4 +-
 arch/riscv/include/asm/csr.h                       |  57 ++
 arch/riscv/include/asm/csr_ind.h                   |  42 +
 arch/riscv/include/asm/hwcap.h                     |   8 +
 arch/riscv/include/asm/kvm_vcpu_pmu.h              |   4 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   2 +-
 arch/riscv/include/asm/sbi.h                       |   2 +-
 arch/riscv/include/asm/vendorid_list.h             |   4 +
 arch/riscv/kernel/cpufeature.c                     |   5 +
 arch/riscv/kvm/Makefile                            |   4 +-
 arch/riscv/kvm/vcpu_pmu.c                          |   2 +-
 arch/riscv/kvm/vcpu_sbi.c                          |   2 +-
 drivers/perf/Kconfig                               |  16 +-
 drivers/perf/Makefile                              |   4 +-
 drivers/perf/{riscv_pmu.c => riscv_pmu_common.c}   |   0
 drivers/perf/{riscv_pmu_sbi.c => riscv_pmu_dev.c}  | 976 +++++++++++++++++----
 include/linux/perf/riscv_pmu.h                     |  26 +-
 .../perf/pmu-events/arch/riscv/arch-standard.json  |  10 +
 tools/perf/pmu-events/empty-pmu-events.c           | 299 ++++---
 tools/perf/pmu-events/jevents.py                   | 218 ++++-
 tools/perf/pmu-events/pmu-events.h                 |  32 +-
 22 files changed, 1467 insertions(+), 317 deletions(-)
---
base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20
change-id: 20240715-counter_delegation-628a32f8c9cc
--
Regards,
Atish patra


