Return-Path: <kvm+bounces-66798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A8DCE8121
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 20:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E99B3014A05
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 19:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89A3224244;
	Mon, 29 Dec 2025 19:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OwIR3lx+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2048B2C187
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 19:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767037291; cv=none; b=QQV5Q9xnVxOk+L+mXkHhQbW8GBndFhCQXcVH5Z3/vxBUL7FUqbrGI8wHZ7oxCHJkfn2jCNUslyWlkGRpPUjXBjdTWJro0IptkJTzUmJrtDmrmsVfTUJ2hKy1INBnJMZiFu31plbW2vbzbbf6MG2ag2p9MnN1WFVYfta+hiRAutk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767037291; c=relaxed/simple;
	bh=jE0WBP5PYVRsBiHF4na01q7d4v78PYlCvg9nF7VCmC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsKvkOkFOPVXJhs3lSWEoACW3NknUtV/DC0g0WGQ1yjbx2ZOhm+pI4A2h+1EPk8rVWfdkVp/+GAcZu5FelDjSyQVmzDxa6DKmg5NYg9iGmzT3o5zZzvnxZSS/VUEQ+VzVVnQQZPaxsUJ3tmng+ebjhdQiHly6OC9v35IavN06ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OwIR3lx+; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo10472612b3a.2
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 11:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767037288; x=1767642088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8nLc5kAL7UgTFB1GCrT5nSSAirEhk5CRg+5f9jqqB2g=;
        b=OwIR3lx+Il5RVvwNEjCiFOJFTLG9NU7UUmMGh4gq/+Qq4SQCLXrxWWiDZV1qg+Hsca
         BH4iDKyzhUJ8kr6A2KPnykOD4EFeHbFt3/L/4YgophA4nvRQLfkfzbGCookHpmJeCxpK
         6BrCvB7AcU6SFxsFotv518RaS7lK+12FGkL3MSgjB/7cSdz8ujBpnwu7me4qMIABLd8k
         eQw7f7pcEhp4X1uBpF3l32mUqAnwR1+c42V8FEAZ39GYtNfwVobVK9LVOYu13cpzBVQ7
         diV3pt8l1ulWTy2N3jw/N5eHa6svSeBm3/6zajIDsuE6oDTT35rKPOt7ta+4RD/hkVRS
         kXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767037288; x=1767642088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8nLc5kAL7UgTFB1GCrT5nSSAirEhk5CRg+5f9jqqB2g=;
        b=HupOQAnRvA4QQOIpUGswaEeQUN8fL3PVRxWemHtQxcX/myOd1d5SY5ID+lNFpaSCR6
         pre+pDu0ZQuSanEeLbZUEFXilxenwGRGUVIGB81dLuv0vXydO4Po/0U9qWuDXA+/UIDu
         uyl+W2bnA+KT+K3IQpS0xcNQdezkmKBhKiR0LsRZ7jsKE8AImNlL3VDfCirLsbTEfSKH
         oRZsPSKsSOG7IMfUZPIC0jqhKnNd21RzTxgnhc8vjw3oLhhU8exVgtumakiA31snTbs+
         Q92BtJijVTPeYyzEkDKQOBevCE5umRKKUNuNat9AiNvz0dKYcUu8oV6baWNP8jd3Eted
         JACw==
X-Forwarded-Encrypted: i=1; AJvYcCUtKohjvHYxtkNzVWQQDefULLce1ozan47aWFDwtKwcl9yh12jka2v4Kup+01Wd6dhr0Fc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyThFzl+MpTpn6w1doYVX7Gyvk2Kj6dj9Do9TJaIZG+po90Hyes
	a4LvPLZL/7RJXQ8fBvvd/gyu6MksHPnIti79ZV7fyjHbMkdpwnzqUU4wrkIytW9ZcOk=
X-Gm-Gg: AY/fxX7CM/2h8G5gi7BCG2q72A1axzOSacekmSpfRiGhCX/L7oiov3Gsba94wUykURa
	+0KrbDNxqiNuxDgTYxBqO9FjqiIRyLj0M0HwSFuuA79A6/uk4/J5gkDDH3HEx1Wn/XzULe0dLNL
	ClIg07n/F3gAVG7pcUryWqqsZExhjBb0IOSVEU9Hd43Sf5b1eN45u3XARIiHwL4YPjaZrK93m8v
	vOs9493WTylHesYvNHmIUMJ95/V+CDPWXCD/90uKcbjehYFFnSLFl4Ry8eA9aOFNOgXT3DvvwXK
	FLz1rGnHint11PCe+sJv4enCwRVp65veLukMsuBakpShyX7D2O3zP4ioHq2FcUQvMybqI6cl2w+
	ckSyspL8FsO9fh1g+E3J4CIvvf/vbX2pvuXdMxh28K2xspYDvU5oYg7ndFtefLSP58SkWSznskg
	O2ssOP1hLClJnfwN6Swr1H6yEgFrh7nBvVsCOfSoR4UW4DQ0FStuo1UhuT
X-Google-Smtp-Source: AGHT+IFuqvKSMnz7I0kpznEv4On8NRHmIrdjyfTJBTVSISEoTvYM4SaeUgYlzcp8/T8rdADCS7sVUQ==
X-Received: by 2002:a05:6a00:1ca7:b0:7e8:4471:ae78 with SMTP id d2e1a72fcca58-7ff6814367cmr25892716b3a.68.1767037288203;
        Mon, 29 Dec 2025 11:41:28 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7b71986asm30264809b3a.30.2025.12.29.11.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 11:41:27 -0800 (PST)
Message-ID: <54225b83-9071-495b-a473-eb967e17f475@linaro.org>
Date: Mon, 29 Dec 2025 11:41:26 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/28] WHPX support for Arm
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-1-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/28/25 3:53 PM, Mohamed Mediouni wrote:
> Link to branch: https://github.com/mediouni-m/qemu whpx (tag for this submission: whpx-v12)
> 
> Missing features:
> - VM save-restore: interrupt controller state notably
> - SVE register sync: I didn't have the time to test this on pre-release hardware with SVE2 support yet.
> So SVE2 is currently masked for VMs when running this.
> 
> Known bugs:
> - U-Boot still doesn't work (hangs when trying to parse firmware) but EDK2 does.
> 
> Note:
> 
> "target/arm/kvm: add constants for new PSCI versions" taken from the mailing list.
> 
> "accel/system: Introduce hwaccel_enabled() helper" taken from the mailing list, added here
> as part of this series to make it compilable as a whole.
> 
> "hw/arm: virt: add GICv2m for the case when ITS is not available" present in both the HVF
> vGIC and this series.
> 
> "hw: arm: virt-acpi-build: add temporary hack to match existing behavior" is not proper" is
> for ACPI stability but what is the right approach to follow there?
> 
> And another note:
> 
> Seems that unlike HVF there isn't direct correspondence between WHv registers and the actual register layout,
> so didn't do changes there to a sysreg.inc.
> 
> Updates since v11:
> - Address review comments
> - Rebase up to latest staging
> - Switch to assuming Qemu 11.0 as the newest machine model
> 
> Updates since v10:
> - Bring forward to latest Qemu
> - Fix a typo in the GICv3+GICv2m PR
> 
> Updates since v9:
> - Adding partition reset on the reboot side of things...
> 
> Updates since v8:
> - v9 and v8 were not submitted properly because of my MTA not behaving, sorry for that.
> - v10 introduces a new argument, -M msi=, to handle MSI-X configuration more granularly.
> - That surfaced what I think is a bug (?), with vms->its=1 on GICv2 configurations... or I did understand everything wrong.
> - Oopsie due to email provider ratelimiting.
> 
> Updates since v7:
> - Oops, fixing bug in "hw/arm: virt: cleanly fail on attempt to use the platform vGIC together with ITS".
> Other commits are unchanged.
> 
> Updates since v6:
> - Rebasing
> - Fixing a bug in the GICv3+GICv2m case for ACPI table generation
> - getting rid of the slots infrastructure for memory management
> - Place the docs commit right after the "cleanly fail on attempt to run GICv3+GICv2m on an unsupported config" one
> as that's what switches ITS to a tristate.
> - Fixing a build issue when getting rid of the arch-specific arm64 hvf-stub.
> 
> Updates since v5:
> - Rebasing
> - Address review comments
> - Rework ITS enablement to a tristate
> - On x86: move away from deprecated APIs to get/set APIC state
> 
> Updates since v4:
> - Taking into account review comments
> - Add migration blocker in the vGICv3 code due to missing interrupt controller save/restore
> - Debug register sync
> 
> Updates since v3:
> - Disabling SVE on WHPX
> - Taking into account review comments incl:
> 
> - fixing x86 support
> - reduce the amount of __x86_64__ checks in common code to the minimum (winhvemulation)
> which can be reduced even further down the road.
> - generalize get_physical_address_range into something common between hvf and whpx
> 
> Updates since v2:
> - Fixed up a rebase screwup for whpx-internal.h
> - Fixed ID_AA64ISAR1_EL1 and ID_AA64ISAR2_EL1 feature probe for -cpu host
> - Switched to ID_AA64PFR1_EL1/ID_AA64DFR0_EL1 instead of their non-AA64 variant
> 
> Updates since v1:
> - Shutdowns and reboots
> - MPIDR_EL1 register sync
> - Fixing GICD_TYPER_LPIS value
> - IPA size clamping
> - -cpu host now implemented
> 
> Mohamed Mediouni (26):
>    qtest: hw/arm: virt: skip ACPI test for ITS off
>    hw/arm: virt: add GICv2m for the case when ITS is not available
>    tests: data: update AArch64 ACPI tables
>    hw/arm: virt: cleanly fail on attempt to use the platform vGIC
>      together with ITS
>    hw: arm: virt: rework MSI-X configuration
>    hw: arm: virt-acpi-build: add temporary hack to match existing
>      behavior
>    docs: arm: update virt machine model description
>    whpx: Move around files before introducing AArch64 support
>    whpx: reshuffle common code
>    whpx: ifdef out winhvemulation on non-x86_64
>    whpx: common: add WHPX_INTERCEPT_DEBUG_TRAPS define
>    hw, target, accel: whpx: change apic_in_platform to kernel_irqchip
>    whpx: interrupt controller support
>    whpx: add arm64 support
>    whpx: change memory management logic
>    target/arm: cpu: mark WHPX as supporting PSCI 1.3
>    whpx: arm64: clamp down IPA size
>    hw/arm, accel/hvf, whpx: unify get_physical_address_range between WHPX
>      and HVF
>    whpx: arm64: implement -cpu host
>    target/arm: whpx: instantiate GIC early
>    whpx: arm64: gicv3: add migration blocker
>    whpx: enable arm64 builds
>    whpx: apic: use non-deprecated APIs to control interrupt controller
>      state
>    whpx: arm64: check for physical address width after WHPX availability
>    whpx: arm64: add partition-wide reset on the reboot path
>    MAINTAINERS: update the list of maintained files for WHPX
> 
> Philippe Mathieu-Daudé (1):
>    accel/system: Introduce hwaccel_enabled() helper
> 
> Sebastian Ott (1):
>    target/arm/kvm: add constants for new PSCI versions
> 
>   MAINTAINERS                                   |    6 +
>   accel/hvf/hvf-all.c                           |    7 +-
>   accel/meson.build                             |    1 +
>   accel/stubs/whpx-stub.c                       |    1 +
>   accel/whpx/meson.build                        |    7 +
>   {target/i386 => accel}/whpx/whpx-accel-ops.c  |    6 +-
>   accel/whpx/whpx-common.c                      |  540 +++++++++
>   docs/system/arm/virt.rst                      |   13 +-
>   hw/arm/virt-acpi-build.c                      |   16 +-
>   hw/arm/virt.c                                 |  140 ++-
>   hw/i386/x86-cpu.c                             |    4 +-
>   hw/intc/arm_gicv3_common.c                    |    3 +
>   hw/intc/arm_gicv3_whpx.c                      |  249 ++++
>   hw/intc/meson.build                           |    1 +
>   include/hw/arm/virt.h                         |    8 +-
>   include/hw/core/boards.h                      |    3 +-
>   include/hw/intc/arm_gicv3_common.h            |    3 +
>   include/system/hvf_int.h                      |    5 +
>   include/system/hw_accel.h                     |   13 +
>   .../whpx => include/system}/whpx-accel-ops.h  |    4 +-
>   include/system/whpx-all.h                     |   20 +
>   include/system/whpx-common.h                  |   26 +
>   .../whpx => include/system}/whpx-internal.h   |   25 +-
>   include/system/whpx.h                         |    5 +-
>   meson.build                                   |   20 +-
>   target/arm/cpu.c                              |    3 +
>   target/arm/cpu64.c                            |   17 +-
>   target/arm/hvf-stub.c                         |   20 -
>   target/arm/hvf/hvf.c                          |    6 +-
>   target/arm/hvf_arm.h                          |    3 -
>   target/arm/kvm-consts.h                       |    2 +
>   target/arm/meson.build                        |    2 +-
>   target/arm/whpx/meson.build                   |    5 +
>   target/arm/whpx/whpx-all.c                    | 1020 +++++++++++++++++
>   target/arm/whpx/whpx-stub.c                   |   15 +
>   target/arm/whpx_arm.h                         |   17 +
>   target/i386/cpu-apic.c                        |    2 +-
>   target/i386/hvf/hvf.c                         |   11 +
>   target/i386/whpx/meson.build                  |    1 -
>   target/i386/whpx/whpx-all.c                   |  569 +--------
>   target/i386/whpx/whpx-apic.c                  |   48 +-
>   tests/data/acpi/aarch64/virt/APIC.its_off     |  Bin 164 -> 188 bytes
>   42 files changed, 2219 insertions(+), 648 deletions(-)
>   create mode 100644 accel/whpx/meson.build
>   rename {target/i386 => accel}/whpx/whpx-accel-ops.c (96%)
>   create mode 100644 accel/whpx/whpx-common.c
>   create mode 100644 hw/intc/arm_gicv3_whpx.c
>   rename {target/i386/whpx => include/system}/whpx-accel-ops.h (92%)
>   create mode 100644 include/system/whpx-all.h
>   create mode 100644 include/system/whpx-common.h
>   rename {target/i386/whpx => include/system}/whpx-internal.h (88%)
>   delete mode 100644 target/arm/hvf-stub.c
>   create mode 100644 target/arm/whpx/meson.build
>   create mode 100644 target/arm/whpx/whpx-all.c
>   create mode 100644 target/arm/whpx/whpx-stub.c
>   create mode 100644 target/arm/whpx_arm.h
> 

Series tested by booting an accelerated linux kernel, works fine.

Regards,
Pierrick

