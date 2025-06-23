Return-Path: <kvm+bounces-50311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8695CAE3FF1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C04DB3BA3D7
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A89B23F409;
	Mon, 23 Jun 2025 12:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FL5uuOyw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076430E85D
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681131; cv=none; b=VUnOVM8FOwPUUxLCHF/xPJrHW3L1v2mkItBfOI8M5NPTGMwz931V7AFS/wJzUuKemZq9//tt26QkrTqnydsf+SAUP+NC5Hdspaz5xdiDSErNWlUdgr5+Jign4dnjnLtmSkX2a1LMOS4ksazdnxXBwOWo3m4phaK8Aq9CgiiehFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681131; c=relaxed/simple;
	bh=g2354ffOtC6tYcX5UrL5qYND2ImuoO5sk9ORnSWOirQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dJLi+RSJNGTHsJIZYGKWeunt0SpvoLKF1PC9D1N9NDh/8+40qoBp1Y0w14N2+4FBAg/X6qCwjHsHhEHDAuKBqIZoVc+NlRZRh726Be3H1AdT1kyf3eg8fH7uvKzH+5sDi6Pd0kC2Fjeu3m11jyxvhBSJdUANZiT/704OHPeqPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FL5uuOyw; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so3234381f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681128; x=1751285928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7t8GepafkJeMN/Zl0RDAcmDhcsq3WRAaImUu4o56bag=;
        b=FL5uuOywfL0Q0h31fbeVvYBiX44eDsG2Wl91AEsC6vwFpFrzi8uHg7oZD5VYaBxz/U
         P0rabTHH2i9tHceUCtIvDOLQKZY9VyLWCy39jD7wqkQiS94D8+sMAUx+DbzPTNCFkdJk
         9BlEiSBIso2PHdfuSza/dWl3shkR3SfVGJEi82W4hRbOrtqkreSKu/nYWu066tFw28sV
         bw68BA9ySr00Gz3fD3uKDZL647F2T86Kk1FkttEA4TXUQc0V1fSox5CCRp8xzXgTY5iy
         zmmGlkHXI+x/oqX+3cyOeSU4Qok/6XCxvHF+3mL/9/ykHSydytwu3JSQnw2LbPGsOt0j
         HYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681128; x=1751285928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7t8GepafkJeMN/Zl0RDAcmDhcsq3WRAaImUu4o56bag=;
        b=jbK5gBSIaxnxydAZ7dv/JKeV1Qn3g72w65khHLem0tb8YE0I8CpdS/9YUSTibNk5lk
         /wqVEVVzBPYx/6Mlj4Isde2uYlaJOjdkmHerF2heXstiHPrKIR+68sa1RRQUrKDhSZXj
         APVNCLw0hdFmBpf5bjHC4aDBqqaLWjh8AWd1vOnLMTa4cDhjwjROwS1tcrYHfZrgb7UC
         LvoaotcZqQ4p1PbwXH+aVD+wbrjYHpLD3DD/5GnG7ABlZVIuVy0WEtRELWLeBlVFC/F6
         pTKnuu1xzA5fS70KhTluGG70KwVcIPWvLV/ElAw8sHJE0QiCtgFBYM0oG6+N1z5yk34G
         23lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDsFrwZa7Y1TfTQ1Ch2XCpMsWQBAtR2yyKPNjRzQawe3Y1OFknVTtUyIiyFATmZdF6/DE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgHZeZ1+XxK4iFbpbVPm5rbliTwe06uWu6kVmDhwaOMp0bc1yA
	3FU/Ph0avXz5IA8FCMo8Tsrsvk8D6/ni5B17ddwlYg6zDBE/k2i1k/2ThTOYQqn9gOc=
X-Gm-Gg: ASbGncvWgIkD1zK+qJ0R5fTbVxTsSGnkrvsZHVd8AX962jpWxWVDv6rAKgFDKUVA75n
	SXo1n7GFxmvU3hcYMSZebKe/0ETYbHZCWjOiDIU8gkOpiHRz5LDUeSP83pT9tGQmKQpdJBMqZoY
	NjSOliwdPhTESgJ08iEynEFA3Dg2Ml2lrQzpqyPRYWrfAOSeX20z7IWJzLwxDk889R1DD8jVLqJ
	eyvyylvx+wpcYOUKqYNmXGz4imQUh1d7XmC9GtvPR+AgsDKWbBkrRlFpTpdnuIFADvYVSOgnyhN
	e2Qip2DvL9Oo4LgRfWS19aTPDTncqG2q+Oz5hLx+XRa/0IPUUAYbPoMygiwDysxRyEj5adbiHl5
	k01xoDpDlMVztzIP2IhHC5RKyISd3Fq9rM1X/
X-Google-Smtp-Source: AGHT+IFM1NS/tC9WBk7I3nX53LY2i9vYAhCY9oXhCQwhmOzZQ3Cjx1W2PBOvVDeh1+H7KqoU9pMS+Q==
X-Received: by 2002:a05:6000:248a:b0:3a5:2fae:1348 with SMTP id ffacd0b85a97d-3a6d13129c6mr9113300f8f.51.1750681128074;
        Mon, 23 Jun 2025 05:18:48 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117c66esm9121303f8f.47.2025.06.23.05.18.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:18:47 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 00/26] arm: Fixes and preparatory cleanups for split-accel
Date: Mon, 23 Jun 2025 14:18:19 +0200
Message-ID: <20250623121845.7214-1-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Only the last patch is missing review (#26)

Since v2:
- Addressed thuth review comments

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
  hw/arm/virt: Only require TCG || QTest to use TrustZone
  hw/arm/virt: Only require TCG || QTest to use virtualization extension
  hw/arm/virt: Rename cpu_post_init() -> post_cpus_gic_realized()
  hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
  tests/functional: Set sbsa-ref machine type in each test function
  tests/functional: Restrict nested Aarch64 Xen test to TCG
  tests/functional: Require TCG to run Aarch64 imx8mp-evk test
  tests/functional: Add hvf_available() helper
  tests/functional: Expand Aarch64 SMMU tests to run on HVF accelerator

 meson.build                                   |  1 +
 accel/hvf/trace.h                             |  2 +
 include/qemu/accel.h                          |  3 +
 include/system/accel-ops.h                    |  4 +-
 include/system/hvf.h                          |  3 +
 target/arm/cpu.h                              |  2 -
 target/arm/internals.h                        |  6 +-
 target/arm/tcg/translate.h                    |  1 +
 accel/accel-common.c                          |  4 +
 accel/accel-system.c                          |  3 +-
 accel/hvf/hvf-accel-ops.c                     |  8 ++
 accel/tcg/tcg-accel-ops.c                     |  4 +-
 hw/arm/sbsa-ref.c                             |  8 +-
 hw/arm/virt.c                                 |  9 +-
 target/arm/cpu.c                              | 78 +++++++++--------
 target/arm/hvf/hvf.c                          | 86 ++++++++++++-------
 target/arm/kvm.c                              |  2 +-
 target/arm/tcg/translate-a64.c                |  6 --
 target/arm/tcg/translate.c                    |  2 +-
 target/i386/hvf/hvf.c                         |  5 ++
 accel/hvf/trace-events                        |  7 ++
 python/qemu/utils/__init__.py                 |  2 +-
 python/qemu/utils/accel.py                    |  8 ++
 target/arm/hvf/trace-events                   |  5 +-
 tests/functional/qemu_test/testcase.py        |  6 +-
 tests/functional/test_aarch64_imx8mp_evk.py   |  1 +
 tests/functional/test_aarch64_sbsaref.py      |  5 +-
 .../functional/test_aarch64_sbsaref_alpine.py |  3 +-
 .../test_aarch64_sbsaref_freebsd.py           |  3 +-
 tests/functional/test_aarch64_smmu.py         | 12 ++-
 tests/functional/test_aarch64_xen.py          |  1 +
 31 files changed, 186 insertions(+), 104 deletions(-)
 create mode 100644 accel/hvf/trace.h
 create mode 100644 accel/hvf/trace-events

-- 
2.49.0


