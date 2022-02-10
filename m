Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B524B115F
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243358AbiBJPJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:09:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235318AbiBJPJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:09:40 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEAD3D4
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 07:09:40 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82F6FD6E;
        Thu, 10 Feb 2022 07:09:40 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32D803F718;
        Thu, 10 Feb 2022 07:09:39 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 0/4] configure changes and rename --target-efi
Date:   Thu, 10 Feb 2022 15:09:39 +0000
Message-Id: <20220210150943.1280146-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first two patches are fixes for stuff I found while working on patch
#3.

Patch #3 ("configure: Make the --target option available to all
architectures") was suggested by Drew when he reviewed my series to add
support to run_tests.sh for kvmtool [1] (kvmtool can only be used to run
the arm/arm64 tests). With this patch, now all architecture have --target
as a configure option, with the only valid value being "qemu" (with the
exception of arm and arm64, of course). This was suggested by Drew for two
reasons:

* There's a possibility that kvm-unit-tests will get support for other VMMs
  in the future (his example was Rust VMM).

* The changes to the scripts to support kvmtool were rather awkward, as
  testing the value of $TARGET was some of the time accompanied by testing
  the value of $ARCH.

I renamed --target-efi to --efi-payload in the last patch because I felt it
looked rather confusing to do ./configure --target=qemu --target-efi when
configuring the tests. If the rename is not acceptable, I can think of a
few other options:

1. Rename --target to --vmm. That was actually the original name for the
option, but I changed it because I thought --target was more generic and
that --target=efi would be the way going forward to compile kvm-unit-tests
to run as an EFI payload. I realize now that separating the VMM from
compiling kvm-unit-tests to run as an EFI payload is better, as there can
be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
a test runner, so I think the impact on users should be minimal.

2. Keep both option as they are. Personally, I think that would be
confusing to the end user, but I don't have a strong opinion against it.

[1] https://www.spinics.net/lists/kvm/msg247896.html

Alexandru Elisei (4):
  configure: Fix whitespaces for the --gen-se-header help text
  configure: Restrict --target-efi to x86_64
  configure: Make the --target option available to all architectures
  Rename --target-efi to --efi-payload

 Makefile             | 10 +++-------
 configure            | 45 +++++++++++++++++++++++++++-----------------
 lib/x86/acpi.c       |  4 ++--
 lib/x86/amd_sev.h    |  4 ++--
 lib/x86/asm/page.h   |  8 ++++----
 lib/x86/asm/setup.h  |  4 ++--
 lib/x86/setup.c      |  4 ++--
 lib/x86/vm.c         | 12 ++++++------
 scripts/runtime.bash |  4 ++--
 x86/Makefile.common  |  6 +++---
 x86/Makefile.x86_64  |  6 +++---
 x86/access_test.c    |  2 +-
 x86/efi/README.md    |  2 +-
 x86/efi/run          |  2 +-
 x86/run              |  4 ++--
 15 files changed, 62 insertions(+), 55 deletions(-)

-- 
2.35.1

