Return-Path: <kvm+bounces-50714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A12AE8899
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F1857A8644
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965FD29B771;
	Wed, 25 Jun 2025 15:48:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38217289371;
	Wed, 25 Jun 2025 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866510; cv=none; b=L7m/lNcW7Q9CUC3jop0FY8DpzP8Qqv+hIE7EG7rtOBYdzfafO/zQTmyBQFljY4RV3MPCNE2d+BddNPgPzmAsD37hmgGlRxbmc5oC5GW7vwaoJdVRexbxArIoC/mkzpWtvkL4QXBwQxDs+VjJ7IA3NsfODbSc9QCwHfzCypFTEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866510; c=relaxed/simple;
	bh=J7yxmU37C6Pa1hm6zaVN5jrh/95KXnt35sXkoN3UtVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jde2RWEcyZbGIYdKUGVU5z3V2oR8XsLwPLdBUmb48aRU8i+icEar8aWpZCkAxPoZOxnnLcgXLm4yL0KdbLlKrC85GRCfyMLbaoSCWvYkCmxVF13VDNKDmCQR9HoqgODopOuct6ENXhcBuD5+rZXICjNcAcbEFV2YFhODAgitG54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6DC711A2D;
	Wed, 25 Jun 2025 08:48:07 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 346E33F58B;
	Wed, 25 Jun 2025 08:48:21 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 00/13] arm/arm64: Add kvmtool to the runner script
Date: Wed, 25 Jun 2025 16:48:00 +0100
Message-ID: <20250625154813.27254-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3 can be found here [1]. Based on top of the series that add qemu_params and
test_args [2].

To goal is to allow the user to do:

$ ./configure --target=kvmtool
$ make clean && make
$ ./run_tests.sh

to run all the tests automatically with kvmtool.

Reasons to use kvmtool:

* kvmtool is smaller and a lot easier to modify compared to qemu, which
means developers may prefer it when adding or prototyping new features to
KVM, and being able to run all the tests reliably and automatically is very
useful.

* kvmtool is faster to run the tests (a couple of times faster on
my rockpro64), making for a quick turnaround. But do keep in mind that not
all tests work on kvmtool because of missing features compared to qemu.

* kvmtool does things differently than qemu: different memory layout,
different uart, PMU emulation is disabled by default, etc. This makes it a
good testing vehicule for kvm-unit-tests itself.

Changes v3->v4
--------------

Overview of the changes:

* Gathered Reviewed-by tags - thanks for the review!

* Sent patches #1 ("scripts: unittests.cfg: Rename 'extra_params' to
'qemu_params'") and #2 ("scripts: Add 'test_args' test definition parameter")
as a separate series.

* Fixed the typos reported during the review.

* Ran shellcheck on the patches, this resulted in minor changes.

* Dropped patch "configure: Export TARGET unconditionally" - now the functions
in vmm.bash will check if TARGET is set, instead of having the other scripts use
$TARGET to directly index the vmm_opts array.

* Direct reads of $TARGET have been replaced with vmm_get_target(), to account
for the fact that most architectures don't configure $TARGET (only arm and
arm64 do that).

* Renamed check_vmm_supported() to vmm_check_supported() to match the
function names introduced in subsequent patches.

* Renamed vmm_opts->vmm_optname to match the new function names.

* Reordered the key-value pairs from vmm_optname in alphabetical order.

* Use the "," separator for the composite keys of the associative array instead
of ":" (don't remember why I originally settled on ":", but it was a really poor
choice).

* Dropped the Reviewed-by tags from Drew and Shaoqin Huang from patch #6
("scripts: Use an associative array for qemu argument names") - the review is
much appreciated, but the way the vmm_opts array (now renamed to vmm_optname) is
created, and used, has changed, and since the patch is about introducing the
associative array, I thought it would be useful to have another round of review.

* Use functions instead of indexing vmm_opts (now vmm_optname) directly.

* Fixed standalone test generation by removing 'source vmm.bash' from
scripts/arch-run.bash, $arch/run and scripts/runtime, and having
scripts/mkstandalone.sh::generate_test() copy it directly in the final test
script. Didn't catch that during the previous iterations because I was
running the standalone tests from the top level source directory, and
"source scripts/vmm.bash" happened to work.

More details in the changelog for the modified patches.

[1] https://lore.kernel.org/kvm/20250507151256.167769-1-alexandru.elisei@arm.com/
[2] https://lore.kernel.org/kvm/20250625154354.27015-1-alexandru.elisei@arm.com/

Alexandru Elisei (13):
  run_tests.sh: Document --probe-maxsmp argument
  scripts: Document environment variables
  scripts: Refuse to run the tests if not configured for qemu
  scripts: Use an associative array for qemu argument names
  scripts: Add 'kvmtool_params' to test definition
  scripts: Add support for kvmtool
  scripts: Add default arguments for kvmtool
  scripts: Add KVMTOOL environment variable for kvmtool binary path
  scripts: Detect kvmtool failure in premature_failure()
  scripts: Do not probe for maximum number of VCPUs when using kvmtool
  scripts/mkstandalone: Export $TARGET
  scripts: Add 'disabled_if' test definition parameter for kvmtool to
    use
  scripts: Enable kvmtool

 README.md               |  18 +++-
 arm/efi/run             |   8 ++
 arm/run                 | 161 ++++++++++++++++-----------
 arm/unittests.cfg       |  31 ++++++
 configure               |   1 -
 docs/unittests.txt      |  26 ++++-
 powerpc/run             |   5 +-
 riscv/run               |   5 +-
 run_tests.sh            |  35 +++---
 s390x/run               |   3 +-
 scripts/arch-run.bash   | 112 +++++++------------
 scripts/common.bash     |  30 ++++--
 scripts/mkstandalone.sh |   8 +-
 scripts/runtime.bash    |  35 ++----
 scripts/vmm.bash        | 234 ++++++++++++++++++++++++++++++++++++++++
 x86/run                 |   5 +-
 16 files changed, 525 insertions(+), 192 deletions(-)
 create mode 100644 scripts/vmm.bash

-- 
2.50.0


