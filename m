Return-Path: <kvm+bounces-45696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1323AAD957
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 10:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624873AB172
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 07:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E6D221F08;
	Wed,  7 May 2025 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jrLDEXA4"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A83221540
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 07:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604566; cv=none; b=nS2pTC04WYykRaO4TdofhGhFaCDUTIwqN9oewzRxN4a6rcpSRMeNBAxKOtl7fRjXe2erYEioRaygM6KhYxxCgLPd4d6D+UXhDr7/nRtkoRhf+XO1VRXd8YWLZfnNe2mUJyKBNNBCyhaBrF2YScjFt4D4JWj7rKSopMkdkQ+dukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604566; c=relaxed/simple;
	bh=sJGD6d0tKzo1zgSJs5v+k+6paZ0owgCovIf/ErtkgqU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JXk3tn73PXy4iILqM0LmAnf03NoDvLGPTqU67FujSL4w/2cp429VYkct1dxRlQr7QP5UGH1oajoiNqVrtQ6NdD/Jz0Xy+d7pG6H2qzC5A/Yfhm9zfVKTg5votZzXLl0k/lXzNi75QtJCQyr5MS0U4hODPFf9j3/n+sYKscNz9+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jrLDEXA4; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 May 2025 00:55:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746604559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Qs2ymGmFE4Exf9+DNZUXGKGppSFIJ90KNPIX17yY0JU=;
	b=jrLDEXA4IGwo4G5FYDmQ6viAezrAj56u2aaP35qqCiHwDdzuBT5cZ0d5xfBEbrmlH51AiM
	fNKJHQL4A2IikwixKwuvSbST1HAxWppqOuErMbbPjbV4H0Jvg8wXCuVPkEIQdrix71D8+O
	MZuHk4vg7RvIoe5MJYMqHvrHsfGxWyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.15, round #3
Message-ID: <aBsSAKYrVPjj4tSa@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

This is probably the last batch of fixes I have for 6.15. The bug in
user_mem_abort() getting fixed is likely to bite some folks. On top of
that, Marc snuck in another erratum fix for AmpereOne with more to come
on that front...

Please pull.

The following changes since commit b4432656b36e5cc1d50a1f2dc15357543add530e:

  Linux 6.15-rc4 (2025-04-27 15:19:23 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-fixes-6.15-3

for you to fetch changes up to 3949e28786cd0afcd96a46ce6629245203f629e5:

  KVM: arm64: Fix memory check in host_stage2_set_owner_locked() (2025-05-07 00:17:05 -0700)

----------------------------------------------------------------
KVM/arm64 fixes for 6.15, round #3

 - Avoid use of uninitialized memcache pointer in user_mem_abort()

 - Always set HCR_EL2.xMO bits when running in VHE, allowing interrupts
   to be taken while TGE=0 and fixing an ugly bug on AmpereOne that
   occurs when taking an interrupt while clearing the xMO bits
   (AC03_CPU_36)

 - Prevent VMMs from hiding support for AArch64 at any EL virtualized by
   KVM

 - Save/restore the host value for HCRX_EL2 instead of restoring an
   incorrect fixed value

 - Make host_stage2_set_owner_locked() check that the entire requested
   range is memory rather than just the first page

----------------------------------------------------------------
Marc Zyngier (5):
      KVM: arm64: Force HCR_EL2.xMO to 1 at all times in VHE mode
      KVM: arm64: Prevent userspace from disabling AArch64 support at any virtualisable EL
      KVM: arm64: selftest: Don't try to disable AArch64 support
      KVM: arm64: Properly save/restore HCRX_EL2
      KVM: arm64: Kill HCRX_HOST_FLAGS

Mostafa Saleh (1):
      KVM: arm64: Fix memory check in host_stage2_set_owner_locked()

Sebastian Ott (1):
      KVM: arm64: Fix uninitialized memcache pointer in user_mem_abort()

 arch/arm64/include/asm/el2_setup.h              |  2 +-
 arch/arm64/include/asm/kvm_arm.h                |  3 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h         | 13 +++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c           |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                 | 36 ++++++++++++++-----------
 arch/arm64/kvm/mmu.c                            | 13 +++++----
 arch/arm64/kvm/sys_regs.c                       |  6 +++++
 tools/testing/selftests/kvm/arm64/set_id_regs.c |  8 +++---
 8 files changed, 48 insertions(+), 35 deletions(-)

