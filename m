Return-Path: <kvm+bounces-17164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B988C235F
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB6511F2556B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C72A171675;
	Fri, 10 May 2024 11:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dc1GOyQa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E32171640
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340440; cv=none; b=eX62JhVUddeNurRmLz78MwYE5B+lInDSOrtR5QH6qOz4UwVJ2ZoiTa+sbv10P8Ys5xJ1CVXOtR/4wGSnTo32eGdfX1pK0DAQ5JGHBwGfL219CdZlTRjVK3m4cG1/siYaD6rYVqW1UiitbXZlfGyfObluojjX0MDh2YojBpApDZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340440; c=relaxed/simple;
	bh=W1srijuSTb7jeqkogw773MDhdMTTGhTLI4r93emG8so=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=p6FjW4fHAizM/jUeNOJXVkLSQd5mvmdtAP7+PGYyH58dpGDXu8VBFPHyD3Ib2rNHMmRKK2JBw1wSLIOfYiIwAe9rrlRYajiJTC2oYqsL0nzcFwHZhovoMy0UjuMM0sCZwBPdkHRHzmtOeAETGhRvxgFpMDqYTD8YN4yj7JtSAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dc1GOyQa; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so25118276.0
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340437; x=1715945237; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GeTpsY//IUL3F2M4pGNF9LnkrFBIxs/L6CWJHc93UMI=;
        b=dc1GOyQaf/VwYxcxJSdT3rleQS6uUSFcZ96d9RkxLxhgKKDRVJ7ezeEj0HwEXiKyD3
         2qYnTilAvqq04UugIW7UXd96usIhT0J9GWmw1yj4pa69dTCiX/YKuDz/vzHgYSk2rlPW
         BvnobaHSyI4wl9FbreR2JtHfc/Cj9yTNBpuGxXt0lhvuztKqbyO2FeCsUzH2oWVnzbl9
         6UaDVXnzdMBdiu/7tiA8Z4H9X99Cpq0jDiMhfMHeiVVvt6NJgDmQJZu3yGZXED7USOZ1
         rZAa7j8ioo3LpjJRRGkLedUDSBQd7jY00W+rhpdq6YxVYUQG2GGkdMwZZxzIQkin4GwT
         2SGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340437; x=1715945237;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GeTpsY//IUL3F2M4pGNF9LnkrFBIxs/L6CWJHc93UMI=;
        b=Nj1XbPeTz/Dpgmo20E13VCvmxslrM6YmkuMbZE9mQ7XVYQlrH8xN+iVYDkHW1TcShe
         W2Y6XKfHnJsVmJCCErdUStsAdY8aAbPt2fmtjZLOVJx8LMT9wjMbLiixJfJ42CXr4L1U
         HjJk86ya25+t1nf5r4pe6GxF4SsNe/gLGGcEbxh3y9I4KvK0RIMeZQF5ojFhhtX3UKgo
         N6fE+NMIqIQMJtJ1WGHgTbVZ8K2fYWJT10RWzt7pW4L1SUNaNrpRi9VvSfM/YZrvwb+U
         EmGDKHMXK0o+Ey1zjw4CAO45mBRx0TDHfrSetJbg3mJv3X1NKtYBUR4HtdrB1wEno6hU
         8Wcw==
X-Forwarded-Encrypted: i=1; AJvYcCU8al3HGwha8kXXkLO/T++9BWgpn5AYOhT2Utg4+vPffZ//JNnWoREnLQrGWZ7DBAP7r5sX/aH7bqrmRGJdle+8/1OD
X-Gm-Message-State: AOJu0Yy/ZtqyEQuj4fxXkQVwpOeFIiacL6Ie3rFzpiUB5n0KV2mJcPPN
	B+ADCjTWDVaCiY7NVIrT41XDdBVELWUJOrXA+0yJWIEpfTQlEYUXoIsLEtTMSXbfvs1r5QUQ/w=
	=
X-Google-Smtp-Source: AGHT+IH8LcT7Mlvj6sPM9cJjFdpOx3dU6FNulJiXugTsKM/5ei+quZrDmLQDkQIioDTzRKYsUovHynihLw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:100f:b0:dee:5d43:a0f3 with SMTP id
 3f1490d57ef6-dee5d43c91fmr54501276.6.1715340437656; Fri, 10 May 2024 04:27:17
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-1-ptosi@google.com>
Subject: [PATCH v3 00/12] KVM: arm64: Add support for hypervisor kCFI
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

- [01/12] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limi=
ting
  for kCFI, as it would mask the location of the failed type check.
- [02/12] & [03/12] (resp.) fix and improve __pkvm_init_switch_pgd for kCFI
- [04/12] to [06/12] prepare nVHE for CONFIG_CFI_CLANG and [10/12] enables =
it
- [12/12] improves kCFI error messages by saving then parsing the CPU conte=
xt
- [09/12] adds a kCFI test module for VHE and [11/12] extends it to nVHE & =
pKVM

As a result, an informative kCFI panic message is printed by or on behalf o=
f EL2
giving the expected type and target address (possibly resolved to a symbol)=
 for
VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=3Dy).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=
=3Dy.

Change in v3:
  - Reworked the commit message of [04/12]
  - (no code changes since v2, questions on v1 remain open)

Changes in v2:
  - Added 2 commits implementing a test module for hyp kCFI;
  - For __kvm_hyp_host_vector, dropped changes to the sync EL2t handler and=
 kept
    the SP overflow checks;
  - Used the names __guest_exit_restore_elr_and_panic, esr_brk_comment;
  - Documented the use of SYM_TYPED_FUNC_START for __pkvm_init_switch_pgd;
  - Fixed or clarified commit messages.

Pierre-Cl=C3=A9ment Tosi (12):
  KVM: arm64: Fix clobbered ELR in sync abort/SError
  KVM: arm64: Fix __pkvm_init_switch_pgd C signature
  KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
  KVM: arm64: nVHE: Remove __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2h sync exception handler
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Move esr_comment() to <asm/esr.h>
  KVM: arm64: VHE: Add test module for hyp kCFI
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: nVHE: Support test module for hyp kCFI
  KVM: arm64: Improve CONFIG_CFI_CLANG error message

 arch/arm64/include/asm/esr.h            |  11 ++
 arch/arm64/include/asm/kvm_asm.h        |   3 +
 arch/arm64/include/asm/kvm_cfi.h        |  38 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |   4 +-
 arch/arm64/kernel/asm-offsets.c         |   1 +
 arch/arm64/kernel/debug-monitors.c      |   4 +-
 arch/arm64/kernel/traps.c               |   8 +-
 arch/arm64/kvm/Kconfig                  |  20 ++++
 arch/arm64/kvm/Makefile                 |   3 +
 arch/arm64/kvm/handle_exit.c            |  39 ++++++-
 arch/arm64/kvm/hyp/cfi.c                |  37 +++++++
 arch/arm64/kvm/hyp/entry.S              |  43 +++++++-
 arch/arm64/kvm/hyp/hyp-entry.S          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/cfi.h    |  47 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   7 +-
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |   6 ++
 arch/arm64/kvm/hyp/nvhe/host.S          |  20 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  18 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  19 ++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |   6 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |   7 ++
 arch/arm64/kvm/hyp/vhe/Makefile         |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c         |  34 +++++-
 arch/arm64/kvm/hyp_cfi_test.c           |  75 +++++++++++++
 arch/arm64/kvm/hyp_cfi_test_module.c    | 135 ++++++++++++++++++++++++
 26 files changed, 553 insertions(+), 42 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_cfi.h
 create mode 100644 arch/arm64/kvm/hyp/cfi.c
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
 create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c

--=20
2.45.0.118.g7fe29c98d7-goog


