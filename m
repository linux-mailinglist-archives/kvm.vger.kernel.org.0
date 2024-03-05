Return-Path: <kvm+bounces-11020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7814487249E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 17:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D1E3282BD9
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B248BC8CE;
	Tue,  5 Mar 2024 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BaMGpDR+"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C30944F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657191; cv=none; b=vAhfD6dd7uTwaz0ELdNbhx3U+DPGdmgYmzQ2JofPP8z5Y6aQXGj2j8rqxv1WNqexu0F8rLMEjhuJoR1gkIYSqJ0CvR08cKEzjdRlQ1UG+QAe0UCLttg/CKDvNcPFW/EwurxB5jEVItYubooeBUBfG4oBEhh/L2UTEZyZGXdW5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657191; c=relaxed/simple;
	bh=RBZ1IqN0wvayzIavSUntPoo+VwV4kM9DlZUNbceIoGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=oKPmd1MwHmWe0xzJDjnyYvybdLBGOjl8ohwZztZUN77obiAVReLE9ZRspYELsANfd18h9+Fz0TVz+gt8isIBcxyf0F4QSQBasci6Ogdulm1kFVr940Sle7LJ8FEpdFq3RYPvkly67dRSEcAUH74GruIBlbOTETgfDxdUuaha+rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BaMGpDR+; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N5skdnGptCvSeV3nyw9SgrNGWqfgJ4VhAt4swLYT7+w=;
	b=BaMGpDR+l7ZP+ciTCLzY1DFjJKN5JZrq15K/OlEyM6a4Pt7neEbHPYI7fhsaub7Z3ujpA4
	QBKou3AwM26ilDUt3nyZaUQpt3unCFAoTZf0kgVmr8l/crQb5LFoRLHMsQ/XjwCqQ1X4WZ
	o7CvfYedXUePZMt7ybdgI3kESoUpJAo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 00/18] arm64: EFI improvements
Date: Tue,  5 Mar 2024 17:46:24 +0100
Message-ID: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series collects one fix ("Update MAX_SMP probe") with a bunch of
improvements to the EFI setup code and run script. With the series
applied one can add --enable-efi-direct when configuring and then
run the EFI tests on QEMU much, much faster by using direct kernel
boot for them (and environment variables will work too). The non-
direct (original) way of running the EFI tests has also been sped up
a bit by not running the dummy test and not generating the dtb twice.
The cleanups in the setup code allow duplicated code to be removed
(by sharing with the non-EFI setup code) and eventually for riscv
to share some code too with the introduction of memregions_efi_init().

v3:
 - Dropped fdt_valid
 - Factored out qemu_args+=(-machine acpi=off) [Nikos]
 - Ensure etext is page aligned
 - Picked up Nikos's r-b's

v2:
 - Add another improvement (patches 15-17), which is to stop mapping
   EFI regions which we consider reserved (including
   EFI_BOOT_SERVICES_DATA regions which requires moving the primary stack)
 - Add EFI gitlab CI tests
 - Fix one typo in configure help text


Andrew Jones (17):
  runtime: Update MAX_SMP probe
  runtime: Add yet another 'no kernel' error message
  arm64: efi: Don't create dummy test
  arm64: efi: Remove redundant dtb generation
  arm64: efi: Move run code into a function
  arm64: efi: Remove EFI_USE_DTB
  arm64: efi: Improve device tree discovery
  lib/efi: Add support for loading the initrd
  arm64: efi: Allow running tests directly
  arm/arm64: Factor out some initial setup
  arm/arm64: Factor out allocator init from mem_init
  arm64: Simplify efi_mem_init
  arm64: Add memregions_efi_init
  arm64: efi: Don't map reserved regions
  arm64: efi: Fix _start returns from failed _relocate
  arm64: efi: Switch to our own stack
  arm64: efi: Add gitlab CI

Shaoqin Huang (1):
  arm64: efi: Make running tests on EFI can be parallel

 .gitlab-ci.yml              |  32 ++++-
 arm/efi/crt0-efi-aarch64.S  |  37 ++++--
 arm/efi/elf_aarch64_efi.lds |   1 +
 arm/efi/run                 |  64 ++++++----
 arm/run                     |   6 +-
 configure                   |  17 +++
 lib/arm/mmu.c               |   6 +-
 lib/arm/setup.c             | 227 ++++++++++++++----------------------
 lib/efi.c                   |  84 +++++++++++--
 lib/linux/efi.h             |  29 +++++
 lib/memregions.c            |  53 +++++++++
 lib/memregions.h            |   6 +
 run_tests.sh                |   5 +-
 scripts/runtime.bash        |  21 ++--
 14 files changed, 389 insertions(+), 199 deletions(-)

-- 
2.44.0


