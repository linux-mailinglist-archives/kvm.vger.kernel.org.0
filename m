Return-Path: <kvm+bounces-11823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF6D87C437
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D586B21461
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153F776056;
	Thu, 14 Mar 2024 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLpvac6i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3902A1C7
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447788; cv=none; b=mCSjy9t714DYpU+ecZULOwZKHMdq9R407mLsucE5bIySVoudYLJdKu947uB3o8ySjv98c9BZtFvzlc3fyQ3XfqOEsEn/H+55o7prSJ6UxNCb0qVoUQB0sA2/BVSkZG/nJEgH1kti9hdU5o1H8xUDT6Oi02LMqR7fG74aOuJphbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447788; c=relaxed/simple;
	bh=Es0A1CWvnUyhC/wcE9t/V1zJ0tGF5MsSskGQY/bA+Zo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nw+atSeYRV0H09eWzswfU2g9pvYvTiY6UhFENzdXdAAGOJA+AYjPTdbtPWqrcbnRWgcCSR6NzEXOrgHBoZKmCc86DSX+DqIlyAg/9W3ky2EN+SBnhR2lk5C+//v5WfAGCJ7510+Z2x5L5ZWTi4nN16L24nYtInkJwD8Ry1BeQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLpvac6i; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56845954ffeso1893861a12.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447785; x=1711052585; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGzKh07BEWjrakKuGgA7dSnfa62MUh7NaFhZ8iSDfO0=;
        b=xLpvac6iX199qkgBBvMcpYajpmPuPnxoWC1cXjdikDug42sdvrrfPTiT+pAaDn63Bh
         rX8J1MNUc7o7+KTYoEAg1U0bQsf6N+/lXav5ehm5NUKkPeuiYyke19XxKPC/O9GMXLOC
         KpHq5fBm2+LRGxTdzcUHGyTlk5fIUqeZr0qqhTy1KPqb+SxFejzLxFjpO7S0nv2KIi7I
         vaDs0ZBN8Tk8LRdBo9iSjy/K7hY8vdBwrbVF7McFH0TqVK5HTGZMmKkUy7plRAeStq+r
         dTproG7WIaGDwdnc8EZjyDEPzSu2xHZHAWoCtmL1ewr8FPkie3yWHME4H/oXBlEncTlm
         hH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447785; x=1711052585;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGzKh07BEWjrakKuGgA7dSnfa62MUh7NaFhZ8iSDfO0=;
        b=VHqpHeTLfwWSQ++0QVUkMS4DRBXGhUK0Qs6s/H3Xo0RIPMdJdiGX5hFFrKlqi/ufX7
         XYw8npUPxATVAgZOq4eS0vOGtH5E44XhCOLcGlsjoWUE2pANRT5sjJifa+NfNmvlsESN
         nRrfrpNqmXyytr/1RZZ0e7lW1NXKHBFTcnAuU5pKkLFsHfT0+QcgQtVzoMuxPUGToGvJ
         cdrOshqSyI+3vArfOAWIlXEExDCZ3jD4zRx7y+kmPqc+jptQZAPWxzqTiok1fm0zg58d
         0gsp8b9gqrn8UxeqpbFpk2ICAOjD1YjoQu3fBX/ARuHZ2lpPKcnnK/gliRoun8Thrqb8
         n7FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAxEh90gggZX0aW1JKfRVQiCqRRWf6a1/JM4V2tD12M9pt5GdqEZys/vXCCGxgLryJVYSwxYuDPMWwL36Z+Z59vxUV
X-Gm-Message-State: AOJu0YxESnpZJwe0ENTxFT++egVdJEgvwmWrha2uM5aAjriXyUABOYGU
	C7kHzqF4k8z6fhhDUZ5dnNSc0nkBFv7kX7+ELTIx3+cSQ2lPkhXcDKFsfGeMZw==
X-Google-Smtp-Source: AGHT+IFKAaxhbx2F42VMc8P+jVQLNZM8zQDsShOoa/ppQez6OHZy7OgV3iEioiFJNpKQ1MttakLqog==
X-Received: by 2002:a05:6402:1ccd:b0:566:c167:4ac1 with SMTP id ds13-20020a0564021ccd00b00566c1674ac1mr2132851edb.26.1710447784699;
        Thu, 14 Mar 2024 13:23:04 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id o1-20020aa7dd41000000b00568830944f9sm1012487edw.19.2024.03.14.13.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:04 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:00 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 00/10] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
runtime type checks before any indirect function call. On AArch64, it generates
a BRK instruction to be executed on type mismatch and encodes the indices of the
registers holding the branch target and expected type in the immediate of the
instruction. As a result, a synchronous exception gets triggered on kCFI failure
and the fault handler can retrieve the immediate (and indices) from ESR_ELx.

This feature has been supported at EL1 ("host") since it was introduced by
b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
ESR_EL1, giving informative panic messages such as

  [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
  (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
  [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP

However, it is not or only partially supported at EL2: in nVHE (or pKVM),
CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler from
injecting the checks. In VHE (or hVHE), EL2 code gets compiled with the checks
but the handlers in VBAR_EL2 are not aware of kCFI and will produce a generic
and not-so-helpful panic message such as

  [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
  [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
  [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1de7ec7edbadc0de
  [   36.456088][  T200] VCPU:00000000e189c7cf

To address this,

- [01/10] fixes an existing bug where the ELR_EL2 was getting clobbered on
  synchronous exceptions, causing the wrong "PC" to be reported by
  nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limiting
  for kCFI, as it would mask the location of the failed type check.
- [02/10] & [03/10] (resp.) fix and improve __pkvm_init_switch_pgd for kCFI
- [04/10] to [06/10] prepare nVHE for CONFIG_CFI_CLANG and [09/10] enables it
- [10/10] improves kCFI error messages by saving then parsing the CPU context

As a result, an informative kCFI panic message is printed by or on behalf of EL2
giving the expected type and target address (possibly resolved to a symbol) for
VHE/hVHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=y).

Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=y.

Pierre-Clément Tosi (10):
  KVM: arm64: Fix clobbered ELR in sync abort
  KVM: arm64: Fix __pkvm_init_switch_pgd C signature
  KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
  KVM: arm64: nVHE: Simplify __guest_exit_panic path
  KVM: arm64: nVHE: Add EL2 sync exception handler
  KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
  KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
  arm64: Move esr_comment() to <asm/esr.h>
  KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
  KVM: arm64: Improve CONFIG_CFI_CLANG error message

 arch/arm64/include/asm/esr.h            | 11 +++++++
 arch/arm64/include/asm/kvm_hyp.h        |  4 +--
 arch/arm64/kernel/asm-offsets.c         |  1 +
 arch/arm64/kernel/debug-monitors.c      |  4 +--
 arch/arm64/kernel/traps.c               |  2 --
 arch/arm64/kvm/handle_exit.c            | 39 +++++++++++++++++++++-
 arch/arm64/kvm/hyp/entry.S              | 43 ++++++++++++++++++++++---
 arch/arm64/kvm/hyp/hyp-entry.S          |  4 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 ++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  6 ++--
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c    |  6 ++++
 arch/arm64/kvm/hyp/nvhe/host.S          | 19 ++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      | 11 ++++---
 arch/arm64/kvm/hyp/nvhe/setup.c         |  6 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 27 ++++++++++++++--
 15 files changed, 149 insertions(+), 40 deletions(-)

-- 
Pierre

