Return-Path: <kvm+bounces-50067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 96223AE1B6D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A68DA7AD28B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80AD28AB11;
	Fri, 20 Jun 2025 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TEfMhbpH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF2236442
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424835; cv=none; b=PP4dKaQ58ruBQ4yJzAChcpbwzMp6mRZviYyGBUWmbKIj2iATMKAsoiCGrjTi2woAUat/lDonlPEL0qn3+zH6Z78ovn1yWxRZBaK0ExDDbFW4mLe1RMJDz3Q02OMPy8S8MtHUBbylegbyKxm4j8yPLu9xSdwZLmwIZz8EDHqWqWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424835; c=relaxed/simple;
	bh=oVl2R6BlJ00aSL/yhNoEtUFUDYCiuIxGl+HmN/K7ayM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fJqUn+GsQnO2Z/UkwDMbuvq3PgxriHsD89cp6jkrhK7ltQNGF0lTu2nLIkUCRHCBNoALPyo2KgOSVHT0ywjOAaOVmR59eWBZZtQnobM5n9b7uG8pmHSOr9lP6aLUIawECJOCjTv/Sc+3gIQ5SWdl82X4h8g7BAfz935MYeF6++E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TEfMhbpH; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a5257748e1so1243602f8f.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424832; x=1751029632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+QJmU5PBg2tZeWfZeXKYOSoau8zVaAF0qlZsb030HdQ=;
        b=TEfMhbpHt7524cmdfxCrVbKI9I76RcdkwOB3Hn0Cfx+D7EJh+b5EbtZfp0hfbTI8Qc
         4M2Xe9O8BMxRsESbXv1u7tvx8fXgWaensnFRdTzGEaFBzZtRVkNacOn6fvlxcZakYGL4
         5lkvLVJPhrg11u6w0AP1lbolRSaGK7+K7R5vy1bCIL13pdKvRq8fSWx02Nq/HBCcT6tR
         FIpRSMRrsARYfDSQmhivlYFv+G+Z6lDas3pOER0/ffvx99Fc8Vs2Ekd1RxnRb+cz8uuZ
         2pkxbfiKJZnBTk5qEw9CX1EUTka2SvW0GbWt+isv9LNB9cGIFBe194YyMfb+xPbar3Xe
         y9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424832; x=1751029632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QJmU5PBg2tZeWfZeXKYOSoau8zVaAF0qlZsb030HdQ=;
        b=jcb5T21j+INZsBv1k0J4PkPEMaunD5yFzcvYffBQPlLTgKZiNcEVrqQ/db25QuDdfQ
         qNhtjsxyu8B8Cgn6OzHu6SEjGAhEXkMRWpQGZTs2qHQ7Fu2dOKcphplzwfXMgNpvUwCv
         zE7G5YN+9ExQ9RZlO/wX5i3TBDUsXbCA4GFxs4hzid8BhwwTWSt2VvWzYvki0X+jRheb
         qccD1wiv4kHhw4gNO/UKADNsMrZK3VjTyOeLLGmJDBFRDGkAf2eFMf3vZ5tBxrhvwWEt
         hBXT3Z3hMijugNsmXYeUpKuCtZ2H+VXHzdxBVzjwXgxTi7qJuM3/t9hkpkEEwEDvD7pL
         Jq2A==
X-Forwarded-Encrypted: i=1; AJvYcCWKJzPSBXIghp24lnvR0F7Vz4CgwNj8bACK3urmyTn5PRajfr6EzeV/oXMbU6t9/5tuMng=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqteV2MKy8Jlt1kVPsoo41fjp5x5qLnR7w/uI30FrGCmLmg6SK
	b4eeeAzW3Uq6JWvtn2cPj9e+TSuCBLXeDQ79Z+BBCYjwz6/PXp5kbicNXrfTr4b9Z4I=
X-Gm-Gg: ASbGnctPx89Ub087sFwCe2yvK12qZSAT7JrpGS8tFM/CV/0ZEDkXex1XdXKscYKZYMx
	IvbkQ4LnrlibMmwhSjwbjm6Bs4H5Ixm0zjpSOvNuHo5QHRuApB8HBTczj5ZDU1LVcw+C1E705W2
	74yZNTBiHmq7Bj/Sf6nlVCnDUWQ2qn8CsswdLTU4zW4GiYLu4tPPxy9J+VIYR8aEg+6FGnlDtXj
	s7ZtGLid6pJG0Xa8ThoANpOCIw6dxMTte3T5GZYjqgL/qDSQ7gaESUpZRjq3uDye0gM9PbRb3pl
	3ERtZhOlDFouPwDs1joiQ+SQqA3Y+IUQhK75IMrnEYixcC+K82VIyNsF5SkZmpyYMvu/xEtiDVr
	Rcf/UABH6bsPKgL2zvpWcUZxHy8RVIcoh+iBA
X-Google-Smtp-Source: AGHT+IEJ9h5ss6DQ9nbsYss8UAzQAQ33xR7PMaeHXiIi1steBknP4WF0eD2p4PDUPBMV6vbuu4kWIQ==
X-Received: by 2002:a05:6000:23c3:b0:3a4:f744:e00c with SMTP id ffacd0b85a97d-3a6d130452fmr1797673f8f.29.1750424831952;
        Fri, 20 Jun 2025 06:07:11 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646dc66fsm24751975e9.18.2025.06.20.06.07.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:11 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 00/26] arm: Fixes and preparatory cleanups for split-accel
Date: Fri, 20 Jun 2025 15:06:43 +0200
Message-ID: <20250620130709.31073-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Since v1:
- Addressed rth's review comments

Omnibus series of ARM-related patches (noticed during the
"split accel" PoC work).

- Usual prototypes cleanups
- Check TCG for EL2/EL3 features (and not !KVM or !HVF)
- Improve HVF debugging
- Correct HVF 'dtb_compatible' value for Linux
- Fix HVF GTimer frequency (My M1 hardware has 24 MHz)
  (this implies accel/ rework w.r.t. QDev vCPU REALIZE)
- Expand functional tests w.r.t. HVF

Regards,

Phil.

Philippe Mathieu-Daudé (26):
  target/arm: Remove arm_handle_psci_call() stub
  target/arm: Reduce arm_cpu_post_init() declaration scope
  target/arm: Unify gen_exception_internal()
  target/arm/hvf: Simplify GIC hvf_arch_init_vcpu()
  target/arm/hvf: Directly re-lock BQL after hv_vcpu_run()
  target/arm/hvf: Trace hv_vcpu_run() failures
  accel/hvf: Trace VM memory mapping
  target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
  target/arm: Correct KVM & HVF dtb_compatible value
  accel/hvf: Model PhysTimer register
  target/arm/hvf: Pass @target_el argument to hvf_raise_exception()
  target/arm: Restrict system register properties to system binary
  target/arm: Create GTimers *after* features finalized / accel realized
  accel: Keep reference to AccelOpsClass in AccelClass
  accel: Introduce AccelOpsClass::cpu_target_realize() hook
  accel/hvf: Add hvf_arch_cpu_realize() stubs
  target/arm/hvf: Really set Generic Timer counter frequency
  target/arm/hvf: Trace host processor features
  hw/arm/virt: Only require TCG || QTest to use TrustZone
  hw/arm/virt: Only require TCG || QTest to use virtualization extension
  hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
  hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
  tests/functional: Restrict nexted Aarch64 Xen test to TCG
  tests/functional: Require TCG to run Aarch64 imx8mp-evk test
  tests/functional: Add hvf_available() helper
  tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator

 meson.build                                 |   1 +
 accel/hvf/trace.h                           |   2 +
 include/qemu/accel.h                        |   3 +
 include/system/accel-ops.h                  |   4 +-
 include/system/hvf.h                        |   3 +
 target/arm/cpu.h                            |   2 -
 target/arm/internals.h                      |   6 +-
 target/arm/tcg/translate.h                  |   1 +
 accel/accel-common.c                        |   4 +
 accel/accel-system.c                        |   3 +-
 accel/hvf/hvf-accel-ops.c                   |   8 ++
 accel/tcg/tcg-accel-ops.c                   |   4 +-
 hw/arm/sbsa-ref.c                           |   8 +-
 hw/arm/virt.c                               |   9 +-
 target/arm/cpu.c                            |  78 ++++++------
 target/arm/hvf/hvf.c                        | 129 +++++++++++++++-----
 target/arm/kvm.c                            |   2 +-
 target/arm/tcg/translate-a64.c              |   6 -
 target/arm/tcg/translate.c                  |   2 +-
 target/i386/hvf/hvf.c                       |   5 +
 accel/hvf/trace-events                      |   7 ++
 python/qemu/utils/__init__.py               |   2 +-
 python/qemu/utils/accel.py                  |   8 ++
 target/arm/hvf/trace-events                 |   6 +-
 tests/functional/qemu_test/testcase.py      |   6 +-
 tests/functional/test_aarch64_imx8mp_evk.py |   1 +
 tests/functional/test_aarch64_smmu.py       |   9 +-
 tests/functional/test_aarch64_xen.py        |   1 +
 28 files changed, 221 insertions(+), 99 deletions(-)
 create mode 100644 accel/hvf/trace.h
 create mode 100644 accel/hvf/trace-events

-- 
2.49.0


