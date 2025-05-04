Return-Path: <kvm+bounces-45293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A76CAA83E9
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:29:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8538717955F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAE9167DB7;
	Sun,  4 May 2025 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CxfjqJFQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84748320F
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336563; cv=none; b=iwLANfPI5+04REUVoCxI4m/YQ0sFoz4ofDyrE0gyGDPxcjzUkAnXKwhpUYeqDLqCXvGGzjhAM27NmMCnUxPnFZF19FMXYcN3i0ED/HCrIk1jx35FNwfT9JCfPtcJ9Gt7XLsyZOvihL08s2GJBAe2SfhqMp1D+K7W9jeGoDq4+S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336563; c=relaxed/simple;
	bh=FWbNp1cgFKHLXZgK++yZY4kZOla3LTzHgFUkrUFij+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VqDHEB7jx5d2dIcjOaEqKB7IzqYRHJBct4+Go+asVo65jIQHDvoLhEGAYPNqNhvZthos970H8TsMB15sHVbc1i8z55yEArRQG9yOIrC2+ZkVGw6zSDanuxDqI9hH2aD+pVJKsaL76FDw7uma4a4joqaUeTdrwFWIQVzLDzlN4Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CxfjqJFQ; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b0b2d1f2845so2383137a12.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336560; x=1746941360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=irSEhIVJB8mOBUgNyh7cPK4XpLIapKVpALnmORMTl0E=;
        b=CxfjqJFQx1V6CRipcGq/TTRWnZsDWm0etb3d7m8PeHh0btGICHWiA5kw5WiipFEhWm
         uvCFhKB75vlTuO3kA4EtlwSIT0B3ILjL/nk89zADj/dTzdg4+I8ntgzOzUW1qo4wElEB
         A7Ny28DXL4ku4Vd2HB6THOCSxOELp+Cf75ksoroFLLYe9Uu06+FhuDq3T4MYLMgnRvNJ
         a4srEkacHCBlG8wX/W29/5w7a2GvgTrKTF1mimJOZOG6VR8KunPJiyXNyXbdQ7duUXW6
         Ml7huyy/GZ2Iv0uTWGhlZoGLRr2jgo7gnsfC01AGhCklO9Jhsun7/xI9B9lb+7tRxcIx
         zK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336560; x=1746941360;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=irSEhIVJB8mOBUgNyh7cPK4XpLIapKVpALnmORMTl0E=;
        b=JwwlXoRUXxFM2ljvcu9VGPwWSUZIkKtWs/mDgpD9+krYTANx1f3Jh40GUKMmDr7ouq
         KyI8+GNJFcSyhYjaUGAKFVqyg78BV1pMR24X++1DcuB1TuY7F24bZ0nQCCKaX88em6YK
         ViJkpwwoy+PKfUv1VMk1tyqAyll9Ls5t4hajWq6yeDEhbjQrHUFsiOJes5lDriF0O9ps
         4nDzQHTGtB63qGND4c6dHECNH9hB8USWKX2I4sWeot5Q7lXjejHOV0hXJOYG2MkHKc/S
         00S8yxZAjBt6z7c/OpXWv6xF2tzFxapZkSCLuO4EIYh/3/MPhLARmTbHr3wVE9JwOMPB
         GzPw==
X-Forwarded-Encrypted: i=1; AJvYcCWSb1W+xo8JAEhP4Zvuxt0q8xwSlCxMditF2nUKUAM0EJ39yQTa/T4WmIBi3A/q4vhhen4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN665bzOfu4KrrxDStfesXKiydU1js2D1EtFO77CPcgsAdMavM
	wgDgsCpYv/juQCOAZ/FUoywiFKu7soRiEkioxD5XiRAl1VTIa+6h7htywTfjWG8=
X-Gm-Gg: ASbGnct6Q75jzpHN+xiJDsZLYtmyMiwI2CloesRkVjos6DRqzgboOYMnJX48Gdstj7m
	yQTDeN7TLf1qiVkNJxL09j3sADSpZZE7NqpnxMJrUZm/ftnuu412gXYSo0o0/j7Ogr2lr3nG9DY
	FhG0SgOTCq5oHDGOBRUNd/JOudjRbqGPTALfdmyzUV5WmA0c8QUY1QX+HSls12xmL+hf5+Z5Tq5
	Y4QxN25YoTygr1qX7j/NsvmVM+Vo5noKlirvN4uB0micqJ/So76sjV8moJsU85+elXlTqK9Vj7z
	3Nh4zYfJNwiQR6zgQLjRUlbbBS82YlS8Z1xkYQ34
X-Google-Smtp-Source: AGHT+IFTj45voNnhxORlgg/0h6D+fYSNfPoo0K7iespbQCHfkUHz4mUcGMgWDjbFTX/fPSN9MeBCEQ==
X-Received: by 2002:a17:903:1aa3:b0:224:76f:9e4a with SMTP id d9443c01a7336-22e102d01ebmr143378185ad.14.1746336560539;
        Sat, 03 May 2025 22:29:20 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:20 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 00/40] single-binary: compile target/arm twice
Date: Sat,  3 May 2025 22:28:34 -0700
Message-ID: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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

v4
--

CI: https://github.com/pbo-linaro/qemu/actions/runs/14816460393/job/41597560792
- add patch to apply target config for picking files in libsystem/libuser
  Useful for Philippe series for semihosting:
  https://lore.kernel.org/qemu-devel/20250502220524.81548-1-philmd@linaro.org/T/#me750bbaeeba4d16791121fe98b44202afaec4068
- update some patches description (Philippe & Richard)
- tcg: introduce vaddr type (Richard)
- modify concerned helpers to use vaddr instead of i64 (Richard)
- use int64_t instead of uint64_t for top_bits in ptw.c (Philippe)
- arm_casq_ptw: use CONFIG_ATOMIC64 instead of TARGET_AARCH64 and comment why
  (Richard)
- target/arm/machine.c

Philippe Mathieu-Daudé (1):
  target/arm: Replace target_ulong -> uint64_t for HWBreakpoint

Pierrick Bouvier (39):
  include/system/hvf: missing vaddr include
  meson: add common libs for target and target_system
  meson: apply target config for picking files from libsystem and
    libuser
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
  tcg: add vaddr type for helpers
  target/arm/helper: use vaddr instead of target_ulong for
    exception_pc_alignment
  target/arm/helper: use vaddr instead of target_ulong for probe_access
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
  target/arm/ptw: replace target_ulong with int64_t
  target/arm/ptw: replace TARGET_AARCH64 by CONFIG_ATOMIC64 from
    arm_casq_ptw
  target/arm/ptw: compile file once (system)
  target/arm/meson: accelerator files are not needed in user mode
  target/arm/kvm-stub: compile file once (system)
  target/arm/machine: reduce migration include to avoid target specific
    definitions
  target/arm/machine: remove TARGET_AARCH64 from migration state
  target/arm/machine: move cpu_post_load kvm bits to
    kvm_arm_cpu_post_load function
  target/arm/kvm-stub: add missing stubs
  target/arm/machine: compile file once (system)

 meson.build                    |  104 ++-
 include/system/hvf.h           |   15 +-
 include/tcg/tcg-op-common.h    |    1 +
 include/tcg/tcg.h              |   17 +
 target/arm/helper.h            | 1152 +------------------------------
 target/arm/internals.h         |    6 +-
 target/arm/kvm_arm.h           |   87 +--
 target/arm/tcg/helper.h        | 1153 ++++++++++++++++++++++++++++++++
 include/exec/helper-head.h.inc |   11 +
 accel/hvf/hvf-stub.c           |    5 +
 target/arm/arch_dump.c         |    6 -
 target/arm/cpu.c               |   47 +-
 target/arm/cpu32-stubs.c       |   26 +
 target/arm/debug_helper.c      |    6 +-
 target/arm/helper.c            |   21 +-
 target/arm/hyp_gdbstub.c       |    6 +-
 target/arm/kvm-stub.c          |   97 +++
 target/arm/kvm.c               |   42 +-
 target/arm/machine.c           |   15 +-
 target/arm/ptw.c               |    6 +-
 target/arm/tcg/op_helper.c     |    2 +-
 target/arm/tcg/tlb_helper.c    |    2 +-
 target/arm/tcg/translate-a64.c |    4 +-
 target/arm/tcg/translate.c     |    2 +-
 tcg/tcg.c                      |    6 +
 accel/hvf/meson.build          |    1 +
 target/arm/meson.build         |   41 +-
 27 files changed, 1506 insertions(+), 1375 deletions(-)
 create mode 100644 target/arm/tcg/helper.h
 create mode 100644 accel/hvf/hvf-stub.c
 create mode 100644 target/arm/cpu32-stubs.c

-- 
2.47.2


