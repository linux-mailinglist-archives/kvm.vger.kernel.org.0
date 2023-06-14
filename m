Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331BC72B920
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 09:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbjFLHuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 03:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbjFLHtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:49:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C934BB
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 00:49:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 397FD22850;
        Mon, 12 Jun 2023 07:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686556091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=c8kwzDIIBDr3fel/kfXlCHjmh+lpX2M0y16Mob/akTo=;
        b=0AssJnx4mjikpWU+wQ01lhjrCNnvd2IjjM2pj66IH0pZPvUpqR8J6pemHTcDyGQJURK/gH
        TkarJhMT4FkrsQraWFoLxmHQZWmUtytVTRzOsb5r82MlcttrmU8fnlJD2DUppIGT0KMKb+
        +Wr6VUAOEjxnJ1TLQIEgGSIpPRnv2mU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686556091;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=c8kwzDIIBDr3fel/kfXlCHjmh+lpX2M0y16Mob/akTo=;
        b=MVYwuZu+AnIN+k0z2LiWHlQzyVss/yOxunG0PD2EmmojkYkbRc5d2PsuLgWmUgOiEA6Khp
        7Jq1qgJp76qLv2Cw==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 942522C141;
        Mon, 12 Jun 2023 07:48:10 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        rientjes@google.com, seanjc@google.com, zxwang42@gmail.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 00/11] Add #VC exception handling for AMD SEV-ES
Date:   Mon, 12 Jun 2023 09:47:47 +0200
Message-Id: <20230612074758.9177-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For AMD SEV-ES, kvm-unit-tests currently rely on UEFI to set up a
#VC exception handler. This leads to the following problems:

1) The test's page table needs to map the firmware and the shared
   GHCB used by the firmware.
2) The firmware needs to keep its #VC handler in the current IDT
   so that kvm-unit-tests can copy the #VC entry into its own IDT.
3) The firmware #VC handler might use state which is not available
   anymore after ExitBootServices.
4) After ExitBootServices, the firmware needs to get the GHCB address
   from the GHCB MSR if it needs to use the kvm-unit-test GHCB. This
   requires keeping an identity mapping, and the GHCB address must be
   in the MSR at all times where a #VC could happen.

Problems 1) and 2) were temporarily mitigated via commits b114aa57ab
("x86 AMD SEV-ES: Set up GHCB page") and 706ede1833 ("x86 AMD SEV-ES:
Copy UEFI #VC IDT entry") respectively.

However, to make kvm-unit-tests reliable against 3) and 4), the tests
must supply their own #VC handler [1][2].

This series adds #VC exception processing from Linux into kvm-unit-tests,
and makes it the default way of handling #VC exceptions.

If --amdsev-efi-vc is passed during ./configure, the tests will continue
using the UEFI #VC handler.

[1] https://lore.kernel.org/all/Yf0GO8EydyQSdZvu@suse.de/
[2] https://lore.kernel.org/all/YSA%2FsYhGgMU72tn+@google.com/

v4:
- Rebased the patches on top of the current state of the test suite
- Rebased the insn decoder on linux kernel v6.4

v3:
- Reduce the diff between insn decoder code imported into kvm-unit-tests
  and the original code in Linux; cleanup #VC handling.

v2:
- Drop #VC processing code for RDTSC/RDTSCP and WBINVD (seanjc). KVM does
  not trap RDTSC/RDTSCP, and the tests do not produce a WBINVD exit to be
  handled.
- Clarify the rationale for tests needing their own #VC handler (marcorr).

Vasant Karasulli (11):
  x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
  x86: Move svm.h to lib/x86/
  lib: Define unlikely()/likely() macros in libcflat.h
  lib: x86: Import insn decoder from Linux
  x86: AMD SEV-ES: Pull related GHCB definitions and helpers from Linux
  x86: AMD SEV-ES: Prepare for #VC processing
  lib/x86: Move xsave helpers to lib/
  x86: AMD SEV-ES: Handle CPUID #VC
  x86: AMD SEV-ES: Handle MSR #VC
  x86: AMD SEV-ES: Handle IOIO #VC
  x86: AMD SEV-ES: Handle string IO for IOIO #VC

 .gitignore                         |    2 +
 Makefile                           |    3 +
 configure                          |   21 +
 lib/libcflat.h                     |    3 +
 lib/x86/amd_sev.c                  |   13 +-
 lib/x86/amd_sev.h                  |   98 +++
 lib/x86/amd_sev_vc.c               |  494 ++++++++++++
 lib/x86/desc.c                     |   17 +
 lib/x86/desc.h                     |    1 +
 lib/x86/insn/README                |   23 +
 lib/x86/insn/gen-insn-attr-x86.awk |  443 +++++++++++
 lib/x86/insn/inat.c                |   86 ++
 lib/x86/insn/inat.h                |  233 ++++++
 lib/x86/insn/inat_types.h          |   18 +
 lib/x86/insn/insn.c                |  749 +++++++++++++++++
 lib/x86/insn/insn.h                |  279 +++++++
 lib/x86/insn/insn_glue.h           |   32 +
 lib/x86/insn/x86-opcode-map.txt    | 1191 ++++++++++++++++++++++++++++
 lib/x86/msr.h                      |    1 +
 lib/x86/processor.h                |   15 +
 lib/x86/setup.c                    |    8 +
 {x86 => lib/x86}/svm.h             |   40 +-
 lib/x86/xsave.c                    |   40 +
 lib/x86/xsave.h                    |   16 +
 x86/Makefile.common                |   16 +-
 x86/Makefile.x86_64                |    1 +
 x86/kvmclock.c                     |    4 -
 x86/svm.c                          |    2 +-
 x86/svm_tests.c                    |    2 +-
 x86/xsave.c                        |   42 +-
 30 files changed, 3835 insertions(+), 58 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c
 create mode 100644 lib/x86/insn/README
 create mode 100644 lib/x86/insn/gen-insn-attr-x86.awk
 create mode 100644 lib/x86/insn/inat.c
 create mode 100644 lib/x86/insn/inat.h
 create mode 100644 lib/x86/insn/inat_types.h
 create mode 100644 lib/x86/insn/insn.c
 create mode 100644 lib/x86/insn/insn.h
 create mode 100644 lib/x86/insn/insn_glue.h
 create mode 100644 lib/x86/insn/x86-opcode-map.txt
 rename {x86 => lib/x86}/svm.h (94%)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

--
2.34.1

