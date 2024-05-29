Return-Path: <kvm+bounces-18283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5812A8D360B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75FBCB2447B
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5999E180A95;
	Wed, 29 May 2024 12:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vf89R9wE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26AC38F96
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984805; cv=none; b=EQGp3cr40QeO2+hh8idl6J7dR3nqDf6o1EvGM9tQq2clTMO19ryGQ+73u/LhTL0jgxuZ/P4SlGlL1v4Woiy+zGnqJhrBKj78o7RTvOgBS9evQt1N+SV2nf0SkzrMK74LPKkZDeC/nc2SWxMK2vx7PkNaXP5BKuUH7tCcsq8t2mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984805; c=relaxed/simple;
	bh=+wFh6bAVdNhTd6MTyo642Dh+uNhSgGr7/zbHJwACshw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gI2F6V9JR3YPMhPa2i2mhdxO5TSfdzLV26MR3VkcbYtIikKy4rzDm2MmcJOFtcM1kpegzjdj8gIvk3rkCUgdsTxuP+sO60jg6o02+WITtfhYm+nyw9v/UddTUhuU2TGaPpX/DZhvMqYHjaxboSkx5IGrAvv8ANmYRIXpS3ABa8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vf89R9wE; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579c4641702so1174908a12.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984802; x=1717589602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KHM4hvPISZ5Fqfl4GlcTR57oUno+i9soKGwTyex86bs=;
        b=Vf89R9wE8pvaPl86PVR78GJ/2sDcl3BRcPJfTGS446JCpzbPyk3kU/DWfcff1xzg1O
         kqRcdWZphnNdKFEUMf16ymq8aJuP6Adjve5Ixx9hEblcXdDAQnhKg1lMHWhkGTrfHcUq
         XzzFVLtenmzh4dg8T11VcDSBiEy4yNuy+gnBUS+PzRq9REir8kltep4f9VNmIiyAnvj6
         wIDjRH4UFQlNTtb+8MvKCKDBeI/Y9RUWqs9GOx/kLYzfCOW8Z8ARTWeaYsU+RVufFGww
         7KQOV+LePBX2OzwSG/CKsS2nV6tegTdToj5Z3aIHtLZ/gcBt7gxo9y970+lB9D4d0HCJ
         lM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984802; x=1717589602;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KHM4hvPISZ5Fqfl4GlcTR57oUno+i9soKGwTyex86bs=;
        b=onaR5oFGL/cMH/qWbibCa/RKp4ERVJDnVVi/0aZEvaj4rmcjjwqt6emCjkEnZ/GXs9
         JW4cIeZJ7fhcgvjHU3YIs38bCBGoz0U0zjIc6Y0gz+83PHK+zxiqtVoiqIJGP4PQJ4y7
         WFK43Vh9KMmBdRk9ZRvrH8rl1T8wCGMK2Zldrb5qEC03S+DAfuQmggmI1+8Pe/23DLmz
         0MAu17DK30kZegmrq09pmqeMELXLNbfIgdTGsDJOnJzUhOuBhEHnTWX/ssmSHQmj6Wmu
         /ESSpRRI7VgG4hn8WkPWQeyLTCX1zwswV52ZHO3/IQqCqEBP/AJ29UpnaYrQpuRVYNmX
         +6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLOSpzKGhFH+0rO19g/a0c/o2s9Z6qb4EQhXc3tMKx3Owm40ntqCvhraRdn2luSI81LLUeBb4La2s4BrzO1n/lU65j
X-Gm-Message-State: AOJu0YxBpUuVr5DKDl0RqcAk5NJtkBxaxtz8saKSHCf0jw5jCMnboFv5
	zJHW2RT+ZI/2pNW5TcIuESj4q/3u/5O0b30B53PSJVdfqwTp6r6SmyE7/J0ZYTZ3jrVyIMO4Xg=
	=
X-Google-Smtp-Source: AGHT+IGy4WL2CP5PklvEqxujQTD6yc2fhlZRBTpxJ6g4wgBAaDOJBrprVoBIpT2DiBPtsVpg198JthWjYw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:3884:b0:578:242b:aac4 with SMTP id
 4fb4d7f45d1cf-57a03f586cdmr2540a12.2.1716984801909; Wed, 29 May 2024 05:13:21
 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-1-ptosi@google.com>
Subject: [PATCH v4 00/13] KVM: arm64: Add support for hypervisor kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler injec=
t
runtime type checks before any indirect function call. On AArch64, it gener=
ates
a BRK instruction to be executed on type mismatch and encodes the indices o=
f the
registers holding the branch target and expected type in the immediate of t=
he
instruction. As a result, a synchronous exception gets triggered on kCFI fa=
ilure
and the fault handler can retrieve the immediate (and indices) from ESR_ELx=
.

This feature has been supported at EL1 ("host") since it was introduced by
b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
ESR_EL1, giving informative panic messages such as

  [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
  (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
  [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP

However, it is not or only partially supported at EL2: in nVHE (or pKVM),
CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler f=
rom
injecting the checks. In VHE, EL2 code gets compiled with the checks but th=
e
handlers in VBAR_EL2 are not aware of kCFI and will produce a generic and
not-so-helpful panic message such as

  [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
  [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
  [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1d=
e7ec7edbadc0de
  [   36.456088][  T200] VCPU:00000000e189c7cf

To address this,

- [01/13] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limi=
ting
  for kCFI, as it would mask the location of the failed type check.
- [02/13] fixes a minor C/asm ABI mismatch which would trigger a kCFI failu=
re
- [03/13] to [09/13] prepare nVHE for CONFIG_CFI_CLANG and [10/13] enables =
it
- [11/13] improves kCFI error messages by saving then parsing the CPU conte=
xt
- [12/13] adds a kCFI test module for VHE and [13/13] extends it to nVHE & =
pKVM

As a result, an informative kCFI panic message is printed by or on behalf o=
f EL2
giving the expected type and target address (possibly resolved to a symbol)=
 for
VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=3Dy).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=
=3Dy.

Changes in v4:
  - Addressed Will's comments on v3:
  - Removed save/restore of x0-x1 & used __guest_exit_panic ABI for new rou=
tines
  - Reworked __pkvm_init_switch_pgd new API with separate args
  - Moved cosmetic changes (renaming to __hyp_panic) into dedicated commit
  - Further clarified the commit message regarding R_AARCH64_ABS32
  - early_brk64() uses esr_is_cfi_brk() (now introduced along esr_brk_comme=
nt())
  - Added helper to display nvHE panic banner
  - Moved the test module to the end of the series

Pierre-Cl=C3=A9ment Tosi (13):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
  KVM: arm64: nVHE: Simplify __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2h sync exception handler
  KVM: arm64: Rename __guest_exit_panic __hyp_panic
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Introduce esr_comment() & esr_is_cfi_brk()
  KVM: arm64: Introduce print_nvhe_hyp_panic helper
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: Improve CONFIG_CFI_CLANG error message
  KVM: arm64: VHE: Add test module for hyp kCFI
  KVM: arm64: nVHE: Support test module for hyp kCFI

 arch/arm64/include/asm/esr.h            |  11 ++
 arch/arm64/include/asm/kvm_asm.h        |   3 +
 arch/arm64/include/asm/kvm_cfi.h        |  38 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |   3 +-
 arch/arm64/kernel/asm-offsets.c         |   1 +
 arch/arm64/kernel/debug-monitors.c      |   4 +-
 arch/arm64/kernel/traps.c               |   8 +-
 arch/arm64/kvm/Kconfig                  |  20 ++++
 arch/arm64/kvm/Makefile                 |   3 +
 arch/arm64/kvm/handle_exit.c            |  50 ++++++++-
 arch/arm64/kvm/hyp/cfi.c                |  37 +++++++
 arch/arm64/kvm/hyp/entry.S              |  34 +++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/cfi.h    |  47 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   7 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |   6 ++
 arch/arm64/kvm/hyp/nvhe/host.S          |  21 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  23 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  19 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   7 ++
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c         |  34 +++++-
 arch/arm64/kvm/hyp_cfi_test.c           |  75 +++++++++++++
 arch/arm64/kvm/hyp_cfi_test_module.c    | 135 ++++++++++++++++++++++++
 26 files changed, 553 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cfi.h
 create mode 100644 arch/arm64/kvm/hyp/cfi.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
 create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c

--=20
2.45.1.288.g0e0cd299f1-goog


