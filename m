Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411E43BA004
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhGBLvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44684 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhGBLvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:20 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D11C62009A;
        Fri,  2 Jul 2021 11:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=98c5XVosXkxsEF5csivCrj46Eo5ocAf/SNIwP2m+geg=;
        b=oKBp+2dXgQNMp818q+YuiaUS7ky3obkmqy8deUnZzLTorhZlH6jMsrh9Qq/9VJSc/87TIj
        bLhfHyAK7GAiS6SNOAM9z3rPqNfgDBmTutRwfRAeKT6Ybv9jN6KO+WxaxegUTSeTgdfuKk
        GMithEI10iywo9d8M/Ogeg9D/m0VKT4=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 7B11911C84;
        Fri,  2 Jul 2021 11:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=98c5XVosXkxsEF5csivCrj46Eo5ocAf/SNIwP2m+geg=;
        b=oKBp+2dXgQNMp818q+YuiaUS7ky3obkmqy8deUnZzLTorhZlH6jMsrh9Qq/9VJSc/87TIj
        bLhfHyAK7GAiS6SNOAM9z3rPqNfgDBmTutRwfRAeKT6Ybv9jN6KO+WxaxegUTSeTgdfuKk
        GMithEI10iywo9d8M/Ogeg9D/m0VKT4=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 1NKMHB/93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:47 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
Date:   Fri,  2 Jul 2021 13:48:14 +0200
Message-Id: <20210702114820.16712-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series brings EFI support to a reduced subset of kvm-unit-tests
on x86_64. I'm sending it out for early review since it covers enough
ground to allow adding KVM testcases for EFI-only environments.

EFI support works by changing the test entrypoint to a stub entry
point for the EFI loader to jump to in long mode, where the test binary
exits EFI boot services, performs the remaining CPU bootstrapping,
and then calls the testcase main().

Since the EFI loader only understands PE objects, the first commit
introduces a `configure --efi` mode which builds each test as a shared
lib. This shared lib is repackaged into a PE via objdump.

Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
relocate ELF .dynamic contents.

Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.

Commit 6 patches out some broken tests for EFI. Testcases that refuse
to build as shared libs are also left disabled, these need some massaging.

git tree: https://github.com/varadgautam/kvm-unit-tests/commits/efi-stub

Varad Gautam (6):
  x86: Build tests as PE objects for the EFI loader
  x86: Call efi_main from _efi_pe_entry
  x86: efi_main: Get EFI memory map and exit boot services
  x86: efi_main: Self-relocate ELF .dynamic addresses
  cstart64.S: x86_64 bootstrapping after exiting EFI
  x86: Disable some breaking tests for EFI and modify vmexit test

 .gitignore          |   2 +
 Makefile            |  16 ++-
 configure           |  11 ++
 lib/linux/uefi.h    | 337 ++++++++++++++++++++++++++++++++++++++++++++
 x86/Makefile.common |  45 ++++--
 x86/Makefile.x86_64 |  43 +++---
 x86/cstart64.S      |  78 ++++++++++
 x86/efi.lds         |  67 +++++++++
 x86/efi_main.c      | 167 ++++++++++++++++++++++
 x86/vmexit.c        |   7 +
 10 files changed, 741 insertions(+), 32 deletions(-)
 create mode 100644 lib/linux/uefi.h
 create mode 100644 x86/efi.lds
 create mode 100644 x86/efi_main.c

-- 
2.30.2

