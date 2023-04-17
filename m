Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0B6E4A68
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjDQN7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjDQN66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:58:58 -0400
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051614C39
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 06:58:52 -0700 (PDT)
Received: from [167.98.27.226] (helo=lawrence-thinkpad.guest.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1poPNM-0034ER-Oc; Mon, 17 Apr 2023 14:58:36 +0100
From:   Lawrence Hunter <lawrence.hunter@codethink.co.uk>
To:     qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org,
        Lawrence Hunter <lawrence.hunter@codethink.co.uk>
Subject: [PATCH v2 00/17] Add RISC-V vector cryptographic instruction set support
Date:   Mon, 17 Apr 2023 14:58:04 +0100
Message-Id: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset provides an implementation for Zvbb, Zvbc, Zvkned, Zvknh, Zvksh,
Zvkg, and Zvksed of the draft RISC-V vector cryptography extensions as per the
v20230407 version of the specification(1) (3206f07). This is an update to the
patchset submitted to qemu-devel on Friday, 10 Mar 2023 16:03:01 +0000.

We've included the following refactorings:

  - squashed commits into one commit per extension with separate commits for
    each refactoring
  - unified trans_rvzvk*.c.inc files into one trans_rvvk.c.inc
  - style fixes in insn32.decode and other files
  - added macros for EGS values in translation functions.

We've also updated from v20230303 to v20230407 of the spec:
  - Zvkb has been split into Zvbb and Zvbc
  - vbrev, vclz, vctz, vcpop and vwsll have been added to Zvbb.

Please note that the Zvkt data-independent execution latency extension (and all
extensions including it) has not been implemented, and we would recommend not
using these patches in an environment where timing attacks are an issue.

Work performed by Dickon, Lawrence, Nazar, Kiran, and William from Codethink
sponsored by SiFive, as well as Max Chou and Frank Chang from SiFive.

For convenience we have created a git repo with our patches on top of a recent
master. https://github.com/CodethinkLabs/qemu-ct

1. https://github.com/riscv/riscv-crypto/releases

Dickon Hood (3):
  target/riscv: Refactor translation of vector-widening instruction
  qemu/bitops.h: Limit rotate amounts
  target/riscv: Add Zvbb ISA extension support

Kiran Ostrolenk (5):
  target/riscv: Refactor some of the generic vector functionality
  target/riscv: Refactor vector-vector translation macro
  target/riscv: Refactor some of the generic vector functionality
  qemu/host-utils.h: Add clz and ctz functions for lower-bit integers
  target/riscv: Add Zvknh ISA extension support

Lawrence Hunter (2):
  target/riscv: Add Zvbc ISA extension support
  target/riscv: Add Zvksh ISA extension support

Max Chou (3):
  crypto: Create sm4_subword
  crypto: Add SM4 constant parameter CK
  target/riscv: Add Zvksed ISA extension support

Nazar Kazakov (4):
  target/riscv: Move vector translation checks
  target/riscv: Add Zvkned ISA extension support
  target/riscv: Add Zvkg ISA extension support
  target/riscv: Expose Zvk* and Zvb[b,c] cpu properties

 accel/tcg/tcg-runtime-gvec.c             |   11 +
 accel/tcg/tcg-runtime.h                  |    1 +
 crypto/sm4.c                             |   10 +
 include/crypto/sm4.h                     |    9 +
 include/qemu/bitops.h                    |   24 +-
 include/qemu/host-utils.h                |   54 ++
 target/arm/tcg/crypto_helper.c           |   10 +-
 target/riscv/cpu.c                       |   39 +
 target/riscv/cpu.h                       |    8 +
 target/riscv/helper.h                    |   95 ++
 target/riscv/insn32.decode               |   58 ++
 target/riscv/insn_trans/trans_rvv.c.inc  |  145 ++-
 target/riscv/insn_trans/trans_rvvk.c.inc |  617 +++++++++++++
 target/riscv/meson.build                 |    4 +-
 target/riscv/op_helper.c                 |    6 +
 target/riscv/translate.c                 |    1 +
 target/riscv/vcrypto_helper.c            | 1052 ++++++++++++++++++++++
 target/riscv/vector_helper.c             |  243 +----
 target/riscv/vector_internals.c          |   81 ++
 target/riscv/vector_internals.h          |  228 +++++
 20 files changed, 2362 insertions(+), 334 deletions(-)
 create mode 100644 target/riscv/insn_trans/trans_rvvk.c.inc
 create mode 100644 target/riscv/vcrypto_helper.c
 create mode 100644 target/riscv/vector_internals.c
 create mode 100644 target/riscv/vector_internals.h

-- 
2.40.0

