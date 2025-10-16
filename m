Return-Path: <kvm+bounces-60195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A512FBE4DEE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 208514EEED0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4F5218ADD;
	Thu, 16 Oct 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="eAgyuSt7"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster6-host11-snip4-8.eps.apple.com [57.103.76.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56DCEED8
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636295; cv=none; b=VhfXKXXzUhe1Dw8Cb8eeYbvVwp5JzG7Fow/RoruCLD2xIwXyHopOmj2aPFL8sXLi6BO3e4VxZoh17KqoFVpz69ASEEEf3WWSH8hqdm17TXI/EGUacGpGcIu8mTD+pkSu48IVe8D3rdhnzEvxutyEs5ml7jpzwkF3fnjOU9Du82k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636295; c=relaxed/simple;
	bh=4Ri9D957C6yUVMgRfwA7qpVoAqX8J2DOvAf0/Hia83Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mrlVVYo0nbSLwGpHQVOiWjp45xu+g0zABEyd+qPJjhOdwADr+RL5km8QgerZTTc2D0RZ0UK2ymvv/ZVY8nx247BorLQJRpy+dk+28/JCAln1YVN67ctBGcH84xU8fr96EocQ7l1GddfSDTKJbio2rV/4ugu1Q7zUxLEeg7zK+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=eAgyuSt7; arc=none smtp.client-ip=57.103.76.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 485EA1800110;
	Thu, 16 Oct 2025 17:38:09 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=TpZRPdKhUTjyuX0UqPOFFkd5b/O+tgyQUHZLONOBYCk=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=eAgyuSt7Fl/yzHBPMSLEBxExuS8+exh5wivynXnUxiTeymfKWSsClD7aK+4vwC/42Mfi5l9IJI0gFcWUMFMuDksaapxoIuv/5tddh56aB/MGFXnR6w5YSiqWdXQRXhRq1VZmXUMvrA1/VxlEFH+dvr5Pa70uNDiWd794wmHP9N9P7mJWE+8UX/IJR1Ji4WD+IOzMlrc0gAMI+fSqwY5sRVjHDbEU3601HS29FiWdr+Ah3XxNJOtdN7pSvsUM0BNZjp5ScGDuIqwxDLYjKjXPTb9PSGFVj6UHZkeoe80gkDh0tHygfneMTxAIqipj2oxdYHNNNtbZkpCNfy+fA/eqtA==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id A2834180010F;
	Thu, 16 Oct 2025 17:38:05 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>
Subject: [PATCH v8 00/24] WHPX support for Arm
Date: Thu, 16 Oct 2025 19:37:39 +0200
Message-ID: <20251016173803.65764-1-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfXxP7acZsq7Ng0
 ZGwMsHRBSsp4bacy6fOaEpXp0Mc6HoENCbzyhZJMU9RQT7HDhrCaR2r/ucAXY/5IDgDTPdv+dbH
 SEVMphdY9MFJrkb91MyGbrdWtXev0WPbugYX27jn+8g0RmIxJOC8C5Q+bQqiRUbqdWqGKoPfiyG
 f8MhxL6RTUGfZbqOYuD4LIZaxIa8rSvJ3Co6guuwF7/EvDMDjJerIGWC4G4ugbamNWy6UEYvhfU
 C1HHTzPLE/qVLv7XT6HIEdRZDjgjvqUe6t6sLRY1HRHuvRyAbDIZzH9Ww86BdCDFcmlYEp3c4=
X-Proofpoint-GUID: 6XueHETvQdBRN20UcUvR5fK4X9zwgGUd
X-Proofpoint-ORIG-GUID: 6XueHETvQdBRN20UcUvR5fK4X9zwgGUd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 clxscore=1030 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAABaH72HdoZKULZDDPFUWIUPBdiFKkAT+lPewsoecxaMrjCCH+uHbCnleLvw6LHbhfznptnilXBEVpdKjfnCW82ik3ubxEhHQzPZao/0PebBW1nlRgYYsnseYpFKGCYi4hewbzvt2Zg91EiND76m0Ki3WsT0E1duduuCl8Lc79n1KMGBZlQnIYGl+fA5aT4zMa/ALvvQE7ruXnxh5ucLhz2u0kvpEiWJfKs6Px8SLjnY25Gcrdz8H2RK5QGsaEcgTvc7kSm5PMgPKwv+Rv3Ctj4Txi+W9OrSwtquxof4ca02znUvvtRs/vByYC0W5C/p3RVPbFi6/ozsFS1t+nnq/IrflNsIS6apeUSRu8+an/aooEvGj/r9OPem/A6d3yweVefJjW7DohVkIouGtUo24crSHyai9soiafo747/evxw3Q1896GmxDiNGd3aDFUtzjyBbdB6zS5LObFZ9uL9m0TbH8daalIimFcWz9QUTBwJj9mvuYgKaYin29PnE8iXqi7PRHFf+PVpTGShcMT0jq3D1Z/ubYWblf9F5QSkHgphRZsERuYyHnew0CqlBJzwEnOZg3q4xg+hMnIHGYCjwjgs4pHLM8C76m+kdNzR+Z5S9auC4C6LQgnXnCDBYBuuqCA3rz+k/utoqbqFgn2m64VbFN32EJ5DiXOr7LFeZEw2MYZdphNBnXFU6dud1takyy+tHehJj+QHfOkmDQEdDhoO2/9H3+AMM2NS2cgFHhTvb8bszzEYmuECakwnsg6+YbCdyPCSlQ8RiuxGwcBivyyuteHHMAgcnc8meQ/OLyEaGyuFdRDsDOwzONI4YSkLUKr8767XlHEGOOB+MokLiAUp+RakGtomC1BuWP6zBYLT5caRBkjzai7ctpLoJXvHFhjYvIOyWGyr6pCZ3H6sCung0hA=

Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this submission: whpx-v8)

Missing features:
- PSCI state sync with Hyper-V
- Interrupt controller save-restore
- SVE register sync

Known bugs:
- reboots when multiple cores are enabled are currently broken
- U-Boot still doesn't work (hangs when trying to parse firmware) but EDK2 does.

Note:

"target/arm/kvm: add constants for new PSCI versions" taken from the mailing list.

"accel/system: Introduce hwaccel_enabled() helper" taken from the mailing list, added here
as part of this series to make it compilable as a whole.

"hw/arm: virt: add GICv2m for the case when ITS is not available" present in both the HVF
vGIC and this series.

And another note:
Seems that unlike HVF there isn't direct correspondence between WHv registers and the actual register layout,
so didn't do changes there to a sysreg.inc.

Updates since v7:
- Oops, fixing bug in "hw/arm: virt: cleanly fail on attempt to use the platform vGIC together with ITS".
Other commits are unchanged.

Updates since v6:
- Rebasing
- Fixing a bug in the GICv3+GICv2m case for ACPI table generation
- getting rid of the slots infrastructure for memory management
- Place the docs commit right after the "cleanly fail on attempt to run GICv3+GICv2m on an unsupported config" one
as that's what switches ITS to a tristate.
- Fixing a build issue when getting rid of the arch-specific arm64 hvf-stub.

Updates since v5:
- Rebasing
- Address review comments
- Rework ITS enablement to a tristate
- On x86: move away from deprecated APIs to get/set APIC state

Updates since v4:
- Taking into account review comments
- Add migration blocker in the vGICv3 code due to missing interrupt controller save/restore
- Debug register sync

Updates since v3:
- Disabling SVE on WHPX
- Taking into account review comments incl:

- fixing x86 support
- reduce the amount of __x86_64__ checks in common code to the minimum (winhvemulation)
which can be reduced even further down the road.
- generalize get_physical_address_range into something common between hvf and whpx

Updates since v2:
- Fixed up a rebase screwup for whpx-internal.h
- Fixed ID_AA64ISAR1_EL1 and ID_AA64ISAR2_EL1 feature probe for -cpu host
- Switched to ID_AA64PFR1_EL1/ID_AA64DFR0_EL1 instead of their non-AA64 variant

Updates since v1:
- Shutdowns and reboots
- MPIDR_EL1 register sync
- Fixing GICD_TYPER_LPIS value
- IPA size clamping
- -cpu host now implemented

Mohamed Mediouni (22):
  qtest: hw/arm: virt: skip ACPI test for ITS off
  hw/arm: virt: add GICv2m for the case when ITS is not available
  tests: data: update AArch64 ACPI tables
  whpx: Move around files before introducing AArch64 support
  whpx: reshuffle common code
  whpx: ifdef out winhvemulation on non-x86_64
  whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
  hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
  whpx: interrupt controller support
  whpx: add arm64 support
  whpx: change memory management logic
  target/arm: cpu: mark WHPX as supporting PSCI 1.3
  hw/arm: virt: cleanly fail on attempt to use the platform vGIC
    together with ITS
  docs: arm: update virt machine model description
  whpx: arm64: clamp down IPA size
  hw/arm, accel/hvf, whpx: unify get_physical_address_range between WHPX
    and HVF
  whpx: arm64: implement -cpu host
  target/arm: whpx: instantiate GIC early
  whpx: arm64: gicv3: add migration blocker
  whpx: enable arm64 builds
  MAINTAINERS: update maintainers for WHPX
  whpx: apic: use non-deprecated APIs to control interrupt controller
    state

Philippe Mathieu-Daudé (1):
  accel/system: Introduce hwaccel_enabled() helper

Sebastian Ott (1):
  target/arm/kvm: add constants for new PSCI versions

 MAINTAINERS                                   |   11 +-
 accel/hvf/hvf-all.c                           |    7 +-
 accel/meson.build                             |    1 +
 accel/whpx/meson.build                        |    7 +
 {target/i386 => accel}/whpx/whpx-accel-ops.c  |    6 +-
 accel/whpx/whpx-common.c                      |  544 +++++++++
 docs/system/arm/virt.rst                      |   10 +-
 hw/arm/virt-acpi-build.c                      |   17 +-
 hw/arm/virt.c                                 |   70 +-
 hw/i386/x86-cpu.c                             |    4 +-
 hw/intc/arm_gicv3_common.c                    |    3 +
 hw/intc/arm_gicv3_whpx.c                      |  249 ++++
 hw/intc/meson.build                           |    1 +
 include/hw/arm/virt.h                         |    6 +-
 include/hw/boards.h                           |    3 +-
 include/hw/intc/arm_gicv3_common.h            |    3 +
 include/system/hvf_int.h                      |    2 +
 include/system/hw_accel.h                     |   13 +
 .../whpx => include/system}/whpx-accel-ops.h  |    4 +-
 include/system/whpx-all.h                     |   20 +
 include/system/whpx-common.h                  |   26 +
 .../whpx => include/system}/whpx-internal.h   |   23 +-
 include/system/whpx.h                         |    4 +-
 meson.build                                   |   20 +-
 target/arm/cpu.c                              |    3 +
 target/arm/cpu64.c                            |   19 +-
 target/arm/hvf-stub.c                         |   20 -
 target/arm/hvf/hvf.c                          |    6 +-
 target/arm/hvf_arm.h                          |    3 -
 target/arm/kvm-consts.h                       |    2 +
 target/arm/meson.build                        |    2 +-
 target/arm/whpx/meson.build                   |    5 +
 target/arm/whpx/whpx-all.c                    | 1018 +++++++++++++++++
 target/arm/whpx/whpx-stub.c                   |   15 +
 target/arm/whpx_arm.h                         |   17 +
 target/i386/cpu-apic.c                        |    2 +-
 target/i386/hvf/hvf.c                         |   11 +
 target/i386/whpx/meson.build                  |    1 -
 target/i386/whpx/whpx-all.c                   |  569 +--------
 target/i386/whpx/whpx-apic.c                  |   48 +-
 tests/data/acpi/aarch64/virt/APIC.its_off     |  Bin 164 -> 188 bytes
 41 files changed, 2142 insertions(+), 653 deletions(-)
 create mode 100644 accel/whpx/meson.build
 rename {target/i386 => accel}/whpx/whpx-accel-ops.c (96%)
 create mode 100644 accel/whpx/whpx-common.c
 create mode 100644 hw/intc/arm_gicv3_whpx.c
 rename {target/i386/whpx => include/system}/whpx-accel-ops.h (92%)
 create mode 100644 include/system/whpx-all.h
 create mode 100644 include/system/whpx-common.h
 rename {target/i386/whpx => include/system}/whpx-internal.h (89%)
 delete mode 100644 target/arm/hvf-stub.c
 create mode 100644 target/arm/whpx/meson.build
 create mode 100644 target/arm/whpx/whpx-all.c
 create mode 100644 target/arm/whpx/whpx-stub.c
 create mode 100644 target/arm/whpx_arm.h

-- 
2.50.1 (Apple Git-155)


