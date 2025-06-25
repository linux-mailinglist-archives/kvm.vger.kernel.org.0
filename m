Return-Path: <kvm+bounces-50708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 393EBAE887A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1AA016FF79
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B672BD590;
	Wed, 25 Jun 2025 15:44:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86310267721;
	Wed, 25 Jun 2025 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866250; cv=none; b=Fo8VTCeTxLfXSC5RjSxWdPS23+R90EFesnCyl4ck7P5ghwQ4HYNQoUsVxHkxQ2cSdS1M9BXPk+fS861edcXSn/emXWZF9+Adh71eBXPYODbYPfAojj6I66LT2nQ556ehtxGJWfsF1SJsJwTKI0ssQ94JbHuEf+gtkVAUSmoJ9hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866250; c=relaxed/simple;
	bh=dh0kZGnwTXRsEH9Unk+fFTGBQ1vm6Q6J0nATL3YIPKA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DyQdUpuqjxcJmzYtdemaau6cGbN8E+s1Z+4D4u/wUE68afBcPpXK92QZGjzyxDqfkgjkq42RNoPBGlAq2gLv4dAmqg/tCoqxJ4mNGg/8O2ozhyIH9umRh0xhp0iletn+jmUk9o+6woQ0GZFAmrhpS4ZBVtTf4s4LQcM7li9QUbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B91E106F;
	Wed, 25 Jun 2025 08:43:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C26323F58B;
	Wed, 25 Jun 2025 08:44:03 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	andrew.jones@linux.dev,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	pbonzini@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	david@redhat.com,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] scripts: extra_params rework
Date: Wed, 25 Jun 2025 16:43:52 +0100
Message-ID: <20250625154354.27015-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series was split from the series that adds support to use kvmtool when
using the scripts to run the tests [1]. kvmtool will be supported only for arm
and arm64, as they are the only architectures that compile the tests to run with
kvmtool.

The justification for these changes is to be able to introduce
kvmtool_params for kvmtool specific command line options, and to make a
clear distinction between the qemu options and the kvmtool options. This is
why qemu_params was added as a replacement for extra_params. extra_params
was kept for compatibility purposes for user's custom test definitions.

To avoid duplication of the arguments that are passed to a test's main()
function, test_args has been split from qemu_params. The same test_args
will be used by both qemu and kvmtool.

[1] https://lore.kernel.org/kvm/20250507151256.167769-1-alexandru.elisei@arm.com/

Alexandru Elisei (2):
  scripts: unittests.cfg: Rename 'extra_params' to 'qemu_params'
  scripts: Add 'test_args' test definition parameter

 arm/unittests.cfg     |  94 ++++++++++++++----------
 docs/unittests.txt    |  30 +++++---
 powerpc/unittests.cfg |  21 +++---
 riscv/unittests.cfg   |   2 +-
 s390x/unittests.cfg   |  53 +++++++-------
 scripts/common.bash   |  16 +++--
 scripts/runtime.bash  |  24 ++++---
 x86/unittests.cfg     | 164 ++++++++++++++++++++++++------------------
 8 files changed, 237 insertions(+), 167 deletions(-)


base-commit: 507612326c9417b6330b91f7931678a4c6866395
-- 
2.50.0


