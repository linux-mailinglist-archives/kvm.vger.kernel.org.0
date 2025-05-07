Return-Path: <kvm+bounces-45716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D336AAE40B
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB665082F6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5126B28A1F8;
	Wed,  7 May 2025 15:13:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337D8169397;
	Wed,  7 May 2025 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630795; cv=none; b=GfiL0G8mdxJ2HiPnI1glXyfbwDhUdrrcq+yorW5oG5b9Qxu5kyK1V5AFVOIncs5a5uiYwsfKUHdYXWrO7tAH7nhMxUFaBB2bFbrwHftlodF2YUMAVn9j6znWCQXE54BDoqHaHykxoGJb93bmkRIeAxNJR19ugb17ffWUf8R4OqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630795; c=relaxed/simple;
	bh=erjqJjbQiAdebnC64Ummh0rNVRgrZ2tt5dbVIsfoKUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HRy7Zqkb9v1Ww3pd3zDjuXhNQZPYDNIExBc5v5IJLopjOABBR2LgnSMo0fixTg8tOU87L5WmYCxy7/UnJWlXh4xSgWGG+L20uYphT07fNMH5l84JhfLTQ4Gvp3tQdpcA9ACZfgIbumemkrMev3Bqq4q8KPFoghqh+TdX3s8xsho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 367FB339;
	Wed,  7 May 2025 08:13:03 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C7783F58B;
	Wed,  7 May 2025 08:13:10 -0700 (PDT)
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
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 00/16] arm/arm64: Add kvmtool to the runner script
Date: Wed,  7 May 2025 16:12:40 +0100
Message-ID: <20250507151256.167769-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 can be found here [1].

To goal is to allow the user to do:

$ ./configure --target=kvmtool
$ make clean && make
$ ./run_tests.sh

to run all the tests automatically with kvmtool.

Reasons to use kvmtool:

* kvmtool is smaller and a lot easier to hack than qemu, which means
developers may prefer it when adding or prototyping new features to KVM.
Being able to run all the tests reliably and automatically is very useful
in the development process.

* kvmtool is faster to run the tests (a couple of times faster on
my rockpro64), making for a quick turnaround. But do keep in mind that not
all tests work on kvmtool because of missing features compared to qemu.

* kvmtool does things differently than qemu: different memory layout,
different uart, PMU emulation is disabled by default, etc. This makes it a
good testing vehicule for kvm-unit-tests itself.

Changes in v3
-------------

Lots of changes following the excellent feedback I got. A bird's eye view:

* Split extra_params into qemu_params and test_args: qemu_params for qemu
arguments and test_args for the test's main() function.

Now that I'm putting the cover letter together I'm considering that maybe
having qemu_params, kvmtool_params and test_params (instead of test_args)
might be a better naming scheme.

* TARGET is now exported unconditionally. Unfortunately a side effect of
this is that checking out these series and running the tests will end up
with an error because the scripts now expect TARGET to be defined in
config.mak.

If it's unacceptable, I can drop this and handle everything in vmm.bash by
converting direct accesses to vmm_opts with functions defined in vmm.bash
(vmm_opts[$TARGET:parse_premature_failure] becomes
vmm_parse_premature_failure(), for example).

* Introduced scripts/vmm.bash to keep the vmm stuff contained. As a
consequence there's very little $TARGET stuff in scripts/runtime.bash (only
for premature_failure(), and no more 'case' statements anywhere) and
instead scripts/common.bash passes the correct arguments directly to
runtime.bash::run().

Unfortunately, because of all the changes, I decided not to keep some of
the Reviewed-by tags. That's not to say that the effort is not appreciated,
on the contrary, these changes are a direct result of the review; I dropped
the tags because I was worried they might not apply to the current content
of the patches.

If no major changes are needed following this round of review, for the next
iteration I'm planning to send the first two patches (extra_params renamed
to qemu_params and the new test_args) separately, to make sure it gets the
review it deserves from the rest of the architectures.

Still haven't managed to get EDK2 to work with kvmtool, so I've decided to
explicitely disabled UEFI tests in the last patch ("scripts: Enable
kvmtool") - this is new.

I would also like to point out that despite Drew's comment I kept the
'disabled_if' test definition because I think using 'targets', with the
default value of 'qemu', will probably lead to most, if not all, of the new
tests which will be added never being run or tested with kvmtool. More
details in patch #15 ("scripts: Add 'disabled_if' test definition parameter
for kvmtool to use").

[1] https://lore.kernel.org/kvm/20250120164316.31473-1-alexandru.elisei@arm.com/

Alexandru Elisei (16):
  scripts: unittests.cfg: Rename 'extra_params' to 'qemu_params'
  scripts: Add 'test_args' test definition parameter
  configure: Export TARGET unconditionally
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

 README.md               |  18 ++++-
 arm/efi/run             |   8 ++
 arm/run                 | 161 +++++++++++++++++++++++--------------
 arm/unittests.cfg       | 125 ++++++++++++++++++++---------
 configure               |  37 ++++++---
 docs/unittests.txt      |  54 +++++++++++--
 powerpc/run             |   4 +-
 powerpc/unittests.cfg   |  21 ++---
 riscv/run               |   4 +-
 riscv/unittests.cfg     |   2 +-
 run_tests.sh            |  35 ++++++---
 s390x/run               |   2 +-
 s390x/unittests.cfg     |  53 +++++++------
 scripts/arch-run.bash   | 113 ++++++++++----------------
 scripts/common.bash     |  71 +++++++++++------
 scripts/mkstandalone.sh |   4 +
 scripts/runtime.bash    |  51 +++++-------
 scripts/vmm.bash        | 170 ++++++++++++++++++++++++++++++++++++++++
 x86/run                 |   4 +-
 x86/unittests.cfg       | 164 +++++++++++++++++++++-----------------
 20 files changed, 730 insertions(+), 371 deletions(-)
 create mode 100644 scripts/vmm.bash


base-commit: 08db0f5cfbca16b36f200b7bc54a78fa4941bcce
-- 
2.49.0


