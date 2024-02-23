Return-Path: <kvm+bounces-9530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3AF86164D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5B11C216DB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5DA405C7;
	Fri, 23 Feb 2024 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SMu7yjw3"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81A68288F
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703495; cv=none; b=Dk7P9+5q7qFaAB6eU6ejwHojgrhiyTwFQ3UT7TTUYonEd9Lw3oymHJ/m4I6AN/w7VqrqVzzky+5p4GgT9uIqfROMt/FU0vDTev9IPbat3poZW78D0Qn3WrswpGDrtNaQ2zSYZssxuc/sLQUH/nGeXFFF3ige4EHmOMQ+tptL42w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703495; c=relaxed/simple;
	bh=h0zA9WdQU74HCMfHbY1PNi3WkSqUAxRSW4xoqvVnwQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=dlr+kk2PRlPExd0tLEY4SRy3lOoQ16ACN8WK2Ds/JQIG84Zo6zZK16gkW26qLvYxsPB8axrnZlQxKD+H6r89kNZBycghB1+UGerqgAwvuSx/XIV6e1USnI9vHFGyHmnKU7Wg/jHmbCHueAZ8ZW8B8vm2KgxxVwRhPlhnDk9EFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SMu7yjw3; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o+jaWAifqARW9h/jbOW/BR9w2AzoLYKV+yoHHEw++Hw=;
	b=SMu7yjw3rzx0a5YNl0TjMpOhPVWStiYBeIxdTzOvK5yoXxTsDGzE5+k7MjydoHGob6H2bK
	kVI365vOYhrGL9CTxn6Zn5KpSuNahZQUop61BhzfbiOc4tM6b/92UxidCfC3ArQKoscru0
	n8EZnK1nE7rrX6S/Q79G7RTtVh/cWZo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 00/14] arm64: EFI improvements
Date: Fri, 23 Feb 2024 16:51:26 +0100
Message-ID: <20240223155125.368512-16-andrew.jones@linux.dev>
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

Thanks,
drew


Andrew Jones (13):
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

Shaoqin Huang (1):
  arm64: efi: Make running tests on EFI can be parallel

 arm/efi/run          |  65 ++++++++-----
 arm/run              |   6 +-
 configure            |  17 ++++
 lib/arm/setup.c      | 223 +++++++++++++++++--------------------------
 lib/efi.c            |  93 +++++++++++++++---
 lib/efi.h            |   3 +-
 lib/linux/efi.h      |  29 ++++++
 lib/memregions.c     |  57 +++++++++++
 lib/memregions.h     |   5 +
 run_tests.sh         |   5 +-
 scripts/runtime.bash |  21 ++--
 11 files changed, 343 insertions(+), 181 deletions(-)

-- 
2.43.0


