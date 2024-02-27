Return-Path: <kvm+bounces-10115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B7386A00E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CA661C28B02
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B632451C5A;
	Tue, 27 Feb 2024 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="udLQN5+R"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B5EEDD
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061678; cv=none; b=gQd2TsnsVAEuOZg+dR9kCQMl16M9xfgwudkfa/YCEp8LgFrKvJj9o7NIUe4OMuWQUh7v+4nqGsPB8JXtKdw2figs0oRkgYjTzG+sYt8hodr46umrzwDxNsJ6iLq05bjMdQTGSnV5nDXi2Yh9sy7/MSwX7uc6Dj84wuZouA2u6kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061678; c=relaxed/simple;
	bh=mAay3FQRVDOwKDr/hK3B3D8SpehO8ApC+lwf1oZ8E5s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=eI+58iVE4M0TxX5akmRfBppfLreqP9NPRw/zk5tTJ2Cj0B49yJJWE59dT2O6e68F9vZtLHCrlA+PE5U8tCZ7dLeBX4kVPkHjSFYw5zzlCinbNEG28/1kMohBzxUAM9Y/eKJ3Vdlv1OdXmz6kWevDN3J41gJSAQXMCptbCUXxP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=udLQN5+R; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uN5YRcmU4+TYyuK3N4sp7o9YPMrd3e1u1vT6ipUfsgs=;
	b=udLQN5+RT1cOx7P49ocEHGtmzeY78acuUIOHYL3PS4Q3h93C0gL8FQu1FXu43g9oKZK6y2
	xjB/3XRhWsMI/n/qmx+Gt2F5pKIPDUmp5Y0msWlU95o3goZnXktzcrt+lnwQxMu6+pvBvi
	JcrrqY0Orz/Afm7GNhdf43eJELNWnwk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 00/18] arm64: EFI improvements
Date: Tue, 27 Feb 2024 20:21:10 +0100
Message-ID: <20240227192109.487402-20-andrew.jones@linux.dev>
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

v2:
 - Add another improvement (patches 15-17), which is to stop mapping
   EFI regions which we consider reserved (including
   EFI_BOOT_SERVICES_DATA regions which requires moving the primary stack)
 - Add EFI gitlab CI tests
 - Fix one typo in configure help text


Thanks,
drew


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

 .gitlab-ci.yml             |  32 +++++-
 arm/efi/crt0-efi-aarch64.S |  37 ++++--
 arm/efi/run                |  65 +++++++----
 arm/run                    |   6 +-
 configure                  |  17 +++
 lib/arm/mmu.c              |   6 +-
 lib/arm/setup.c            | 227 +++++++++++++++----------------------
 lib/efi.c                  |  93 +++++++++++++--
 lib/efi.h                  |   3 +-
 lib/linux/efi.h            |  29 +++++
 lib/memregions.c           |  53 +++++++++
 lib/memregions.h           |   6 +
 run_tests.sh               |   5 +-
 scripts/runtime.bash       |  21 ++--
 14 files changed, 396 insertions(+), 204 deletions(-)

-- 
2.43.0


