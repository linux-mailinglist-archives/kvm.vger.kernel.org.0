Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4B494E3B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243377AbiATMwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:06 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41248 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbiATMwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 76F141F3AA;
        Thu, 20 Jan 2022 12:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=13r3L7n0SklbQHk30UdA5//mCUNHYO8ZPVuqcfl0L7k=;
        b=I9vohVjRFy5ihDAc3BznTZ9n0b/K+eUI7ToiyTDWgGeIZNi3SS42+x9Bc9Woyt/jf1vdMV
        iIv7K2RQg5O/z3ja3onFjzk1IPnl9Xq69L9ttJirA0ptwVjL3NAcUGc/DMw/PynzWe77Yp
        nAYND/Cq1Tjz0qEzxxfdGJtoD87nsZ0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CFD4A13B51;
        Thu, 20 Jan 2022 12:52:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KvnnL/Na6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:03 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 00/13] Add #VC exception handling for AMD SEV-ES
Date:   Thu, 20 Jan 2022 13:51:09 +0100
Message-Id: <20220120125122.4633-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For AMD SEV-ES, kvm-unit-tests currently rely on UEFI to set up a
#VC exception handler.

This series adds #VC exception processing from Linux to kvm-unit-tests.

Based on the kvm-unit-tests uefi branch at
2fbec2578 ("x86 UEFI: Make _NO_FILE_4Uhere_ work w/ BOOTX64.EFI")

Tree: https://github.com/varadgautam/kvm-unit-tests/tree/vc-handler-v1

Varad Gautam (13):
  x86/efi: Allow specifying AMD SEV/SEV-ES guest launch policy
  x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
  x86: Move svm.h to lib/x86/
  lib: x86: Import insn decoder from Linux
  x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
  x86: AMD SEV-ES: Prepare for #VC processing
  x86: AMD SEV-ES: Handle WBINVD #VC
  lib/x86: Move xsave helpers to lib/
  x86: AMD SEV-ES: Handle CPUID #VC
  x86: AMD SEV-ES: Handle RDTSC/RDTSCP #VC
  x86: AMD SEV-ES: Handle MSR #VC
  x86: AMD SEV-ES: Handle IOIO #VC
  x86: AMD SEV-ES: Handle string IO for IOIO #VC

 Makefile                   |    3 +
 configure                  |   16 +
 lib/x86/amd_sev.c          |    3 +-
 lib/x86/amd_sev.h          |  107 +++
 lib/x86/amd_sev_vc.c       |  504 ++++++++++++
 lib/x86/desc.c             |   15 +
 lib/x86/desc.h             |    1 +
 lib/x86/insn/inat-tables.c | 1566 ++++++++++++++++++++++++++++++++++++
 lib/x86/insn/inat.c        |   86 ++
 lib/x86/insn/inat.h        |  233 ++++++
 lib/x86/insn/inat_types.h  |   18 +
 lib/x86/insn/insn.c        |  778 ++++++++++++++++++
 lib/x86/insn/insn.h        |  280 +++++++
 lib/x86/setup.c            |   10 +
 {x86 => lib/x86}/svm.h     |   37 +
 lib/x86/xsave.c            |   37 +
 lib/x86/xsave.h            |   16 +
 x86/Makefile.common        |    4 +
 x86/Makefile.x86_64        |    1 +
 x86/efi/README.md          |    5 +
 x86/efi/run                |   16 +
 x86/svm.c                  |    2 +-
 x86/svm_tests.c            |    2 +-
 x86/xsave.c                |   43 +-
 24 files changed, 3738 insertions(+), 45 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c
 create mode 100644 lib/x86/insn/inat-tables.c
 create mode 100644 lib/x86/insn/inat.c
 create mode 100644 lib/x86/insn/inat.h
 create mode 100644 lib/x86/insn/inat_types.h
 create mode 100644 lib/x86/insn/insn.c
 create mode 100644 lib/x86/insn/insn.h
 rename {x86 => lib/x86}/svm.h (93%)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

-- 
2.32.0

