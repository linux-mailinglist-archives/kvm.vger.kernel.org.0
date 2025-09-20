Return-Path: <kvm+bounces-58289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E384B8C9A6
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 16:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F0987AF237
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 14:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8993205E3B;
	Sat, 20 Sep 2025 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="QLnTWrIr"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host10-snip4-10.eps.apple.com [57.103.86.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362052AD22
	for <kvm@vger.kernel.org>; Sat, 20 Sep 2025 14:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376922; cv=none; b=PfSMM76i/U7ktvcyjAV/s1Ws3X+XT36k4JXJpWhqcOUmMXhzq7nLiXhcw+hFK3dRJDG8xvBELE7nakxCsjgB0Bx3e+Kx4OZwf5r3s/mSTIAxJMEjR3y/CaG1YjKM2lTnTozWVUAHBqE3pSf3KVNgvBKWUBvEX1f/VbCtsqbucvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376922; c=relaxed/simple;
	bh=1qkXgvKeOPXWPh8wGfRJSBtXENsY0we9KY1xyxv9b8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sRKlqBZwGAmB2tCWfbXRlrCeA6AbSpMzp7v3fdEP7QDE71bU9LT/3ORn8MZbzQPNSnfBkQQrsMb/o39LDv3rWmoqxdIGAWlDxAgGnQG7MOd7TPf3HxiNmnOrR1JI4GjFNTgwvhP3K1Flhwg1H/VcvXK1W0lrMJPeTeNtJc3bLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=QLnTWrIr; arc=none smtp.client-ip=57.103.86.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPS id 01DA0181729E;
	Sat, 20 Sep 2025 14:01:52 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=gH+1mhRq+Q6jbURH4IDoZbvrLZRZnHLaio5C9CrJrC4=; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=QLnTWrIrQUZojsHPaljACBYtqoK78PHpeMJ0oedgAlXfdDs9T8cTLAgbERjF2l4lA158fANlvJdWZ83G/TCX5qjqo0CGZvldq3TuSs34hrCVYU5SOWKqm2rSBjanFjkljxLl4yf6sh3M871PMzd3FUnKXYmi0s8/e6J5QcMFCdskYLZ5sy0XtleRpBSZ/pGulpKeTP8l/eKXM4h3x3vPbuUeN8yJdpAg5FnooS5Y8RvrHX2PFjalvUH4hCyYdyA8R1SqhHRU3kH0O+QUep2GbYfAyO/EnO/KCy2kn5a1ZXgvA3Ye86mYUIeMTng8gk+Vugesakqyums0kkKwu5k67g==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-100-percent-3 (Postfix) with ESMTPSA id 8C6F51817262;
	Sat, 20 Sep 2025 14:01:27 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mads Ynddal <mads@ynddal.dk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	Igor Mammedov <imammedo@redhat.com>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Alexander Graf <agraf@csgraf.de>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v6 00/23] WHPX support for Arm
Date: Sat, 20 Sep 2025 16:01:01 +0200
Message-ID: <20250920140124.63046-1-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: libiZkKede5AQw9z5Z2PdENfZHlkvN-8
X-Proofpoint-ORIG-GUID: libiZkKede5AQw9z5Z2PdENfZHlkvN-8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDEzNiBTYWx0ZWRfX0Dh/qc8BYQgJ
 92U/Q19NAhlQ4loFC8TSh00+i73Mq4fQZgRUYItxlgd8XYpkShchNBfqsOBO/qOmFh9tPGXEMtW
 ZJ5qIqdexImaParAS/AG3Wxe0i3xTH0AYHG8FIfQUoYOmyMK3phzyzWoaKztGLdFb39yDqt+rND
 Qq+RGXuIHQwD1ctYcEsFNDJ+qfjDzm2I6yJUeKEFPUNkelK8uKtWRkcgZ+T7Oz7EULLlJYsQBue
 NqE6Wxq7g/Sg55lEEe70b2hEOzghq99Y/Bwfgph12F2kcgfhmF9DVvd6Rsa7Rwz/h0A5ZDEUA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_05,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 suspectscore=0 mlxscore=0 clxscore=1030 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2509200136
X-JNJ: AAAAAAABF/IzV6O/tb5ck1D72qwoMO4rBovNv+8WFw8lodokxRCF9TRbZOq1sge3cjT08EseaZ+nVzvrd9V8NkTU/1xRXjD0iDFVDpmwne4PJ6e72LUX2+J7wAtXY8wVz5Dz1FKdUAMl1Z7K3aCsxh979PztQJ1NSGVyi5dlMQYbS3/ftYHiaixh1+kyLFfcjlh4ueUU6g2e8Y2JnZTmJfA4OOyJKe1ZqsJ2+kTKeFEBsCA4W5frqVoCD4WCn6ydvViYFDfLTOq0CFAx2jknjziA96xy2fPcmQpW3kCyyAozhu07jGdMM2rLFZ7NQl8NiF8UESuw0iz6f35YcWXyqAbUBgrEOw8SVMxo4cQEDc0JcvwqhWfj0oKohvsArhVfF5UvzBTVM77FKkeTw8sS14+7VxsbpL8GKx+RDrtrgnbn0kAVStp55N47dH3WgaW0HAh93tpNN6LWyyoOyORici8IMhT9gdQOvfWgX68jDIl+ipmLGBpRnkM7XrULjWD0uadrN5nWR1kyD1gbKsmouyve2HTeAJNu8ZonhfvCsZZu0HQW0nrAXrcNXVdcp4Ji0LQvai+7+M/MBBF3QjNCwATX3/u4a8xjnp6wUgWgXHw6BDnNWAKsSVmszjj5v0V8B3B16ASfxD9afYUO9MAg+tZCPlY6b1Gh5j7dtC9wOtLbGwxegTjp2zJC6CuLtgjreYV6ENCWcUqyTaQeRgYwbJBmmgKji6uDAgCZ9glVBGp3c5oL+ZsDqaL6QsKYM5LpDAnwLibDcr4YDFNwy+jfjJlSoVJ2mzRA00UGevp7W0Y/uOM7if5bsT3es9acBOSigdPL3feoDuHOaJGEYbJvJPIUHq/Z9xi25alXc/hZcnX9Kj7cm5X6L2PHjQ2pAIq0NQXt7St4ZtBdy3mytg==

Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this submission: whpx-v6)

Missing features:
- PSCI state sync with Hyper-V
- Interrupt controller save-restore
- SVE register sync

Known bugs:
- reboots when multiple cores are enabled are currently broken

Note:

"target/arm/kvm: add constants for new PSCI versions" taken from the mailing list.

"accel/system: Introduce hwaccel_enabled() helper" taken from the mailing list, added here
as part of this series to make it compilable as a whole.

"hw/arm: virt: add GICv2m for the case when ITS is not available" present in both the HVF
vGIC and this series.

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

Mohamed Mediouni (21):
  hw/arm: virt: add GICv2m for the case when ITS is not available
  tests: data: update AArch64 ACPI tables
  whpx: Move around files before introducing AArch64 support
  whpx: reshuffle common code
  whpx: ifdef out winhvemulation on non-x86_64
  whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
  hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
  whpx: interrupt controller support
  whpx: add arm64 support
  whpx: copy over memory management logic from hvf
  target/arm: cpu: mark WHPX as supporting PSCI 1.3
  hw/arm: virt: cleanly fail on attempt to use the platform vGIC
    together with ITS
  whpx: arm64: clamp down IPA size
  hw/arm, accel/hvf, whpx: unify get_physical_address_range between WHPX
    and HVF
  whpx: arm64: implement -cpu host
  target/arm: whpx: instantiate GIC early
  whpx: arm64: gicv3: add migration blocker
  whpx: enable arm64 builds
  MAINTAINERS: update maintainers for WHPX
  docs: arm: update virt machine model description
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
 accel/whpx/whpx-common.c                      |  666 +++++++++++
 docs/system/arm/virt.rst                      |   10 +-
 hw/arm/virt-acpi-build.c                      |   16 +-
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
 meson.build                                   |   21 +-
 target/arm/cpu.c                              |    3 +
 target/arm/cpu64.c                            |   19 +-
 target/arm/hvf-stub.c                         |   20 -
 target/arm/hvf/hvf.c                          |    6 +-
 target/arm/hvf_arm.h                          |    3 -
 target/arm/kvm-consts.h                       |    2 +
 target/arm/meson.build                        |    2 +-
 target/arm/whpx/meson.build                   |    5 +
 target/arm/whpx/whpx-all.c                    | 1021 +++++++++++++++++
 target/arm/whpx/whpx-stub.c                   |   15 +
 target/arm/whpx_arm.h                         |   17 +
 target/i386/cpu-apic.c                        |    2 +-
 target/i386/hvf/hvf.c                         |   11 +
 target/i386/whpx/meson.build                  |    1 -
 target/i386/whpx/whpx-all.c                   |  569 +--------
 target/i386/whpx/whpx-apic.c                  |   48 +-
 tests/data/acpi/aarch64/virt/APIC             |  Bin 172 -> 148 bytes
 .../data/acpi/aarch64/virt/APIC.acpihmatvirt  |  Bin 412 -> 388 bytes
 tests/data/acpi/aarch64/virt/APIC.its_off     |  Bin 164 -> 188 bytes
 tests/data/acpi/aarch64/virt/APIC.topology    |  Bin 732 -> 708 bytes
 44 files changed, 2267 insertions(+), 653 deletions(-)
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


